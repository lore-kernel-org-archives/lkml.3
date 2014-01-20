Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbaATEF3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 23:05:29 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:44987 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbaATEFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 23:05:25 -0500
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH-v2 1/3] percpu_ida: Make percpu_ida_alloc + callers accept task state bitmask
Date: Mon, 20 Jan 2014 03:44:44 +0000
Message-Id: <1390189486-13579-2-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1390189486-13579-1-git-send-email-nab@linux-iscsi.org>
References: <1390189486-13579-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <kmo@daterainc.com>

This patch changes percpu_ida_alloc() + callers to accept task state
bitmask for prepare_to_wait() for code like target/iscsi that needs
it for interruptible sleep, that is provided in a subsequent patch.

It now expects TASK_UNINTERRUPTIBLE when the caller is able to sleep
waiting for a new tag, or TASK_RUNNING when the caller cannot sleep,
and is forced to return a negative value when no tags are available.

v2 changes:
  - Include blk-mq + tcm_fc + vhost/scsi + target/iscsi changes
  - Drop signal_pending_state() call

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: <stable@vger.kernel.org> #3.12+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 block/blk-mq-tag.c                       |    6 ++++--
 drivers/target/iscsi/iscsi_target_util.c |    8 ++++++--
 drivers/target/tcm_fc/tfc_cmd.c          |    2 +-
 drivers/vhost/scsi.c                     |    2 +-
 include/linux/percpu_ida.h               |    3 ++-
 lib/percpu_ida.c                         |   12 ++++++------
 6 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index d64a02f..5d70edc 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -36,7 +36,8 @@ static unsigned int __blk_mq_get_tag(struct blk_mq_tags *tags, gfp_t gfp)
 {
 	int tag;
 
-	tag = percpu_ida_alloc(&tags->free_tags, gfp);
+	tag = percpu_ida_alloc(&tags->free_tags, (gfp & __GFP_WAIT) ?
+			       TASK_UNINTERRUPTIBLE : TASK_RUNNING);
 	if (tag < 0)
 		return BLK_MQ_TAG_FAIL;
 	return tag + tags->nr_reserved_tags;
@@ -52,7 +53,8 @@ static unsigned int __blk_mq_get_reserved_tag(struct blk_mq_tags *tags,
 		return BLK_MQ_TAG_FAIL;
 	}
 
-	tag = percpu_ida_alloc(&tags->reserved_tags, gfp);
+	tag = percpu_ida_alloc(&tags->reserved_tags, (gfp & __GFP_WAIT) ?
+			       TASK_UNINTERRUPTIBLE : TASK_RUNNING);
 	if (tag < 0)
 		return BLK_MQ_TAG_FAIL;
 	return tag;
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 0819e68..9b8e1db 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -156,9 +156,13 @@ struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *conn, gfp_t gfp_mask)
 {
 	struct iscsi_cmd *cmd;
 	struct se_session *se_sess = conn->sess->se_sess;
-	int size, tag;
+	int size, tag, state = (gfp_mask & __GFP_WAIT) ? TASK_UNINTERRUPTIBLE :
+				TASK_RUNNING;
+
+	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, state);
+	if (tag < 0)
+		return NULL;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, gfp_mask);
 	size = sizeof(struct iscsi_cmd) + conn->conn_transport->priv_size;
 	cmd = (struct iscsi_cmd *)(se_sess->sess_cmd_map + (tag * size));
 	memset(cmd, 0, size);
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 479ec56..8b2c1aa 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -438,7 +438,7 @@ static void ft_recv_cmd(struct ft_sess *sess, struct fc_frame *fp)
 	struct se_session *se_sess = sess->se_sess;
 	int tag;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, GFP_ATOMIC);
+	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
 	if (tag < 0)
 		goto busy;
 
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 84488a8..2d084fb 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -728,7 +728,7 @@ vhost_scsi_get_tag(struct vhost_virtqueue *vq,
 	}
 	se_sess = tv_nexus->tvn_se_sess;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, GFP_ATOMIC);
+	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
 	if (tag < 0) {
 		pr_err("Unable to obtain tag for tcm_vhost_cmd\n");
 		return ERR_PTR(-ENOMEM);
diff --git a/include/linux/percpu_ida.h b/include/linux/percpu_ida.h
index 1900bd0..f5cfdd6 100644
--- a/include/linux/percpu_ida.h
+++ b/include/linux/percpu_ida.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 #include <linux/bitops.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <linux/spinlock_types.h>
 #include <linux/wait.h>
 #include <linux/cpumask.h>
@@ -61,7 +62,7 @@ struct percpu_ida {
 /* Max size of percpu freelist, */
 #define IDA_DEFAULT_PCPU_SIZE	((IDA_DEFAULT_PCPU_BATCH_MOVE * 3) / 2)
 
-int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp);
+int percpu_ida_alloc(struct percpu_ida *pool, int state);
 void percpu_ida_free(struct percpu_ida *pool, unsigned tag);
 
 void percpu_ida_destroy(struct percpu_ida *pool);
diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index 9d054bf..a48ce2e 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -132,22 +132,22 @@ static inline unsigned alloc_local_tag(struct percpu_ida_cpu *tags)
 /**
  * percpu_ida_alloc - allocate a tag
  * @pool: pool to allocate from
- * @gfp: gfp flags
+ * @state: task state for prepare_to_wait
  *
  * Returns a tag - an integer in the range [0..nr_tags) (passed to
  * tag_pool_init()), or otherwise -ENOSPC on allocation failure.
  *
  * Safe to be called from interrupt context (assuming it isn't passed
- * __GFP_WAIT, of course).
+ * TASK_UNINTERRUPTIBLE, of course).
  *
  * @gfp indicates whether or not to wait until a free id is available (it's not
  * used for internal memory allocations); thus if passed __GFP_WAIT we may sleep
  * however long it takes until another thread frees an id (same semantics as a
  * mempool).
  *
- * Will not fail if passed __GFP_WAIT.
+ * Will not fail if passed TASK_UNINTERRUPTIBLE.
  */
-int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp)
+int percpu_ida_alloc(struct percpu_ida *pool, int state)
 {
 	DEFINE_WAIT(wait);
 	struct percpu_ida_cpu *tags;
@@ -174,7 +174,7 @@ int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp)
 		 *
 		 * global lock held and irqs disabled, don't need percpu lock
 		 */
-		prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
+		prepare_to_wait(&pool->wait, &wait, state);
 
 		if (!tags->nr_free)
 			alloc_global_tags(pool, tags);
@@ -191,7 +191,7 @@ int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp)
 		spin_unlock(&pool->lock);
 		local_irq_restore(flags);
 
-		if (tag >= 0 || !(gfp & __GFP_WAIT))
+		if (tag >= 0 || state == TASK_RUNNING)
 			break;
 
 		schedule();
-- 
1.7.10.4

