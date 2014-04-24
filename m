Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbaDXIyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:54:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46655 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbaDXIyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:54:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 086/182] Btrfs: fix deadlock with nested trans handles
Date: Thu, 24 Apr 2014 09:50:11 +0100
Message-Id: <1398329507-5911-87-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fb.com>

commit 3bbb24b20a8800158c33eca8564f432dd14d0bf3 upstream.

Zach found this deadlock that would happen like this

btrfs_end_transaction <- reduce trans->use_count to 0
  btrfs_run_delayed_refs
    btrfs_cow_block
      find_free_extent
	btrfs_start_transaction <- increase trans->use_count to 1
          allocate chunk
	btrfs_end_transaction <- decrease trans->use_count to 0
	  btrfs_run_delayed_refs
	    lock tree block we are cowing above ^^

We need to only decrease trans->use_count if it is above 1, otherwise leave it
alone.  This will make nested trans be the only ones who decrease their added
ref, and will let us get rid of the trans->use_count++ hack if we have to commit
the transaction.  Thanks,

Reported-by: Zach Brown <zab@redhat.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
Tested-by: Zach Brown <zab@redhat.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/transaction.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index af1931a..bd3612b 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -663,7 +663,8 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	int lock = (trans->type != TRANS_JOIN_NOLOCK);
 	int err = 0;
 
-	if (--trans->use_count) {
+	if (trans->use_count > 1) {
+		trans->use_count--;
 		trans->block_rsv = trans->orig_rsv;
 		return 0;
 	}
@@ -711,17 +712,10 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	}
 
 	if (lock && ACCESS_ONCE(cur_trans->state) == TRANS_STATE_BLOCKED) {
-		if (throttle) {
-			/*
-			 * We may race with somebody else here so end up having
-			 * to call end_transaction on ourselves again, so inc
-			 * our use_count.
-			 */
-			trans->use_count++;
+		if (throttle)
 			return btrfs_commit_transaction(trans, root);
-		} else {
+		else
 			wake_up_process(info->transaction_kthread);
-		}
 	}
 
 	if (trans->type & __TRANS_FREEZABLE)
-- 
1.9.1

