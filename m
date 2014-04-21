Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaDUEhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 00:37:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaDUEfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 00:35:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zach Brown <zab@redhat.com>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: [PATCH 3.13 20/32] Btrfs: fix deadlock with nested trans handles
Date: Sun, 20 Apr 2014 19:13:37 -0700
Message-Id: <20140421021136.632021489@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140421021133.865086647@linuxfoundation.org>
References: <20140421021133.865086647@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/transaction.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -685,7 +685,8 @@ static int __btrfs_end_transaction(struc
 	int lock = (trans->type != TRANS_JOIN_NOLOCK);
 	int err = 0;
 
-	if (--trans->use_count) {
+	if (trans->use_count > 1) {
+		trans->use_count--;
 		trans->block_rsv = trans->orig_rsv;
 		return 0;
 	}
@@ -733,17 +734,10 @@ static int __btrfs_end_transaction(struc
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


