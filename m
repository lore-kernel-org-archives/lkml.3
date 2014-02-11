Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbaBKTGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:06:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbaBKTGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.12 059/107] percpu_ida: Make percpu_ida_alloc + callers accept task state bitmask
Date: Tue, 11 Feb 2014 11:05:25 -0800
Message-Id: <20140211184749.882428337@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kmo@daterainc.com>

commit 6f6b5d1ec56acdeab0503d2b823f6f88a0af493e upstream.

This patch changes percpu_ida_alloc() + callers to accept task state
bitmask for prepare_to_wait() for code like target/iscsi that needs
it for interruptible sleep, that is provided in a subsequent patch.

It now expects TASK_UNINTERRUPTIBLE when the caller is able to sleep
waiting for a new tag, or TASK_RUNNING when the caller cannot sleep,
and is forced to return a negative value when no tags are available.

v2 changes:
  - Include blk-mq + tcm_fc + vhost/scsi + target/iscsi changes
  - Drop signal_pending_state() call
v3 changes:
  - Only call prepare_to_wait() + finish_wait() when != TASK_RUNNING
    (PeterZ)

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target_util.c |    8 ++++++--
 drivers/vhost/scsi.c                     |    2 +-
 include/linux/percpu_ida.h               |    3 ++-
 lib/percpu_ida.c                         |   16 +++++++++-------
 4 files changed, 18 insertions(+), 11 deletions(-)

--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -156,9 +156,13 @@ struct iscsi_cmd *iscsit_allocate_cmd(st
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
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -728,7 +728,7 @@ vhost_scsi_get_tag(struct vhost_virtqueu
 	}
 	se_sess = tv_nexus->tvn_se_sess;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, GFP_ATOMIC);
+	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
 	if (tag < 0) {
 		pr_err("Unable to obtain tag for tcm_vhost_cmd\n");
 		return ERR_PTR(-ENOMEM);
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
@@ -51,7 +52,7 @@ struct percpu_ida {
 	} ____cacheline_aligned_in_smp;
 };
 
-int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp);
+int percpu_ida_alloc(struct percpu_ida *pool, int state);
 void percpu_ida_free(struct percpu_ida *pool, unsigned tag);
 
 void percpu_ida_destroy(struct percpu_ida *pool);
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -142,22 +142,22 @@ static inline unsigned alloc_local_tag(s
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
@@ -184,7 +184,8 @@ int percpu_ida_alloc(struct percpu_ida *
 		 *
 		 * global lock held and irqs disabled, don't need percpu lock
 		 */
-		prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
+		if (state != TASK_RUNNING)
+			prepare_to_wait(&pool->wait, &wait, state);
 
 		if (!tags->nr_free)
 			alloc_global_tags(pool, tags);
@@ -201,7 +202,7 @@ int percpu_ida_alloc(struct percpu_ida *
 		spin_unlock(&pool->lock);
 		local_irq_restore(flags);
 
-		if (tag >= 0 || !(gfp & __GFP_WAIT))
+		if (tag >= 0 || state == TASK_RUNNING)
 			break;
 
 		schedule();
@@ -209,8 +210,9 @@ int percpu_ida_alloc(struct percpu_ida *
 		local_irq_save(flags);
 		tags = this_cpu_ptr(pool->tag_cpu);
 	}
+	if (state != TASK_RUNNING)
+		finish_wait(&pool->wait, &wait);
 
-	finish_wait(&pool->wait, &wait);
 	return tag;
 }
 EXPORT_SYMBOL_GPL(percpu_ida_alloc);


