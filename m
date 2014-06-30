Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbaF3MRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:17:31 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51962 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753288AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 026/181] Btrfs: cleanup transaction on abort
Date: Mon, 30 Jun 2014 13:50:47 +0200
Message-Id: <bd32872f2d74ea81fbb80b362052037b5882d414.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josef Bacik <jbacik@fusionio.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4e121c06adf53aae478ebce3035116595d063413 upstream.

If we abort not during a transaction commit we won't clean up anything until we
unmount.  Unfortunately if we abort in the middle of writing out an ordered
extent we won't clean it up and if somebody is waiting on that ordered extent
they will wait forever.  To fix this just make the transaction kthread call the
cleanup transaction stuff if it notices theres an error, and make
btrfs_end_transaction wake up the transaction kthread if there is an error.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/disk-io.c     | 3 +++
 fs/btrfs/transaction.c | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 84d590a9e4ad..409dcbd234dc 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1780,6 +1780,9 @@ sleep:
 		wake_up_process(root->fs_info->cleaner_kthread);
 		mutex_unlock(&root->fs_info->transaction_kthread_mutex);
 
+		if (unlikely(test_bit(BTRFS_FS_STATE_ERROR,
+				      &root->fs_info->fs_state)))
+			btrfs_cleanup_transaction(root);
 		if (!try_to_freeze()) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (!kthread_should_stop() &&
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 25d64e8e8e47..f98b976ce2b5 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -738,8 +738,10 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 		btrfs_run_delayed_iputs(root);
 
 	if (trans->aborted ||
-	    test_bit(BTRFS_FS_STATE_ERROR, &root->fs_info->fs_state))
+	    test_bit(BTRFS_FS_STATE_ERROR, &root->fs_info->fs_state)) {
+		wake_up_process(info->transaction_kthread);
 		err = -EIO;
+	}
 	assert_qgroups_uptodate(trans);
 
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
-- 
2.0.0

