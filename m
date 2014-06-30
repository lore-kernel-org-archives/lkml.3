Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbaF3L45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:56:57 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52130 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754035AbaF3Lx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Joel Becker <jlbec@evilplan.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 033/181] ocfs2: implement delayed dropping of last dquot reference
Date: Mon, 30 Jun 2014 13:50:54 +0200
Message-Id: <cac99bee6f388bfd0aebd2f07d941326a0b4dd0e.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e3a767b60fd8a9f5e133f42f4970cff77ec43173 upstream.

We cannot drop last dquot reference from downconvert thread as that
creates the following deadlock:

NODE 1                                  NODE2
holds dentry lock for 'foo'
holds inode lock for GLOBAL_BITMAP_SYSTEM_INODE
                                        dquot_initialize(bar)
                                          ocfs2_dquot_acquire()
                                            ocfs2_inode_lock(USER_QUOTA_SYSTEM_INODE)
                                            ...
downconvert thread (triggered from another
node or a different process from NODE2)
  ocfs2_dentry_post_unlock()
    ...
    iput(foo)
      ocfs2_evict_inode(foo)
        ocfs2_clear_inode(foo)
          dquot_drop(inode)
            ...
	    ocfs2_dquot_release()
              ocfs2_inode_lock(USER_QUOTA_SYSTEM_INODE)
               - blocks
                                            finds we need more space in
                                            quota file
                                            ...
                                            ocfs2_extend_no_holes()
                                              ocfs2_inode_lock(GLOBAL_BITMAP_SYSTEM_INODE)
                                                - deadlocks waiting for
                                                  downconvert thread

We solve the problem by postponing dropping of the last dquot reference to
a workqueue if it happens from the downconvert thread.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ocfs2/ocfs2.h        |  5 +++++
 fs/ocfs2/quota.h        |  2 ++
 fs/ocfs2/quota_global.c | 35 +++++++++++++++++++++++++++++++++++
 fs/ocfs2/super.c        |  8 ++++++++
 4 files changed, 50 insertions(+)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 3a903470c794..1f023ae39379 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -30,6 +30,7 @@
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/list.h>
+#include <linux/llist.h>
 #include <linux/rbtree.h>
 #include <linux/workqueue.h>
 #include <linux/kref.h>
@@ -418,6 +419,10 @@ struct ocfs2_super
 	struct ocfs2_dentry_lock *dentry_lock_list;
 	struct work_struct dentry_lock_work;
 
+	/* List of dquot structures to drop last reference to */
+	struct llist_head dquot_drop_list;
+	struct work_struct dquot_drop_work;
+
 	wait_queue_head_t		osb_mount_event;
 
 	/* Truncate log info */
diff --git a/fs/ocfs2/quota.h b/fs/ocfs2/quota.h
index d5ab56cbe5c5..f266d67df3c6 100644
--- a/fs/ocfs2/quota.h
+++ b/fs/ocfs2/quota.h
@@ -28,6 +28,7 @@ struct ocfs2_dquot {
 	unsigned int dq_use_count;	/* Number of nodes having reference to this entry in global quota file */
 	s64 dq_origspace;	/* Last globally synced space usage */
 	s64 dq_originodes;	/* Last globally synced inode usage */
+	struct llist_node list;	/* Member of list of dquots to drop */
 };
 
 /* Description of one chunk to recover in memory */
@@ -110,6 +111,7 @@ int ocfs2_read_quota_phys_block(struct inode *inode, u64 p_block,
 int ocfs2_create_local_dquot(struct dquot *dquot);
 int ocfs2_local_release_dquot(handle_t *handle, struct dquot *dquot);
 int ocfs2_local_write_dquot(struct dquot *dquot);
+void ocfs2_drop_dquot_refs(struct work_struct *work);
 
 extern const struct dquot_operations ocfs2_quota_operations;
 extern struct quota_format_type ocfs2_quota_format;
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index d7b5108789e2..b990a62cff50 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -10,6 +10,7 @@
 #include <linux/jiffies.h>
 #include <linux/writeback.h>
 #include <linux/workqueue.h>
+#include <linux/llist.h>
 
 #include <cluster/masklog.h>
 
@@ -679,6 +680,27 @@ static int ocfs2_calc_qdel_credits(struct super_block *sb, int type)
 	       OCFS2_INODE_UPDATE_CREDITS;
 }
 
+void ocfs2_drop_dquot_refs(struct work_struct *work)
+{
+	struct ocfs2_super *osb = container_of(work, struct ocfs2_super,
+					       dquot_drop_work);
+	struct llist_node *list;
+	struct ocfs2_dquot *odquot, *next_odquot;
+
+	list = llist_del_all(&osb->dquot_drop_list);
+	llist_for_each_entry_safe(odquot, next_odquot, list, list) {
+		/* Drop the reference we acquired in ocfs2_dquot_release() */
+		dqput(&odquot->dq_dquot);
+	}
+}
+
+/*
+ * Called when the last reference to dquot is dropped. If we are called from
+ * downconvert thread, we cannot do all the handling here because grabbing
+ * quota lock could deadlock (the node holding the quota lock could need some
+ * other cluster lock to proceed but with blocked downconvert thread we cannot
+ * release any lock).
+ */
 static int ocfs2_release_dquot(struct dquot *dquot)
 {
 	handle_t *handle;
@@ -694,6 +716,19 @@ static int ocfs2_release_dquot(struct dquot *dquot)
 	/* Check whether we are not racing with some other dqget() */
 	if (atomic_read(&dquot->dq_count) > 1)
 		goto out;
+	/* Running from downconvert thread? Postpone quota processing to wq */
+	if (current == osb->dc_task) {
+		/*
+		 * Grab our own reference to dquot and queue it for delayed
+		 * dropping.  Quota code rechecks after calling
+		 * ->release_dquot() and won't free dquot structure.
+		 */
+		dqgrab(dquot);
+		/* First entry on list -> queue work */
+		if (llist_add(&OCFS2_DQUOT(dquot)->list, &osb->dquot_drop_list))
+			queue_work(ocfs2_wq, &osb->dquot_drop_work);
+		goto out;
+	}
 	status = ocfs2_lock_global_qf(oinfo, 1);
 	if (status < 0)
 		goto out;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index d4e81e4a9b04..d6adb5b2b3a5 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1945,6 +1945,11 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	ocfs2_disable_quotas(osb);
 
+	/* All dquots should be freed by now */
+	WARN_ON(!llist_empty(&osb->dquot_drop_list));
+	/* Wait for worker to be done with the work structure in osb */
+	cancel_work_sync(&osb->dquot_drop_work);
+
 	ocfs2_shutdown_local_alloc(osb);
 
 	ocfs2_truncate_log_shutdown(osb);
@@ -2275,6 +2280,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	INIT_WORK(&osb->dentry_lock_work, ocfs2_drop_dl_inodes);
 	osb->dentry_lock_list = NULL;
 
+	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
+	init_llist_head(&osb->dquot_drop_list);
+
 	/* get some pseudo constants for clustersize bits */
 	osb->s_clustersize_bits =
 		le32_to_cpu(di->id2.i_super.s_clustersize_bits);
-- 
2.0.0

