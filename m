Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491AbaEEMu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:50:28 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41038 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932321AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 38/50] Btrfs: fix deadlock with nested trans handles
Date: Mon,  5 May 2014 14:43:20 +0200
Message-Id: <3717191e66ae2c1bec8fdd0bfabe1240f11bbf9e.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josef Bacik <jbacik@fb.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/transaction.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index b791cfb9a050..25d64e8e8e47 100644
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
1.9.2

