Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964801AbaFRBIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 21:08:36 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:43440 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932704AbaFRBIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 21:08:17 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org, kmo@daterainc.com
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Benjamin LaHaise <bcrl@kvack.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH 5/6] percpu-refcount: require percpu_ref to be exited explicitly
Date: Tue, 17 Jun 2014 21:08:04 -0400
Message-Id: <1403053685-28240-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403053685-28240-1-git-send-email-tj@kernel.org>
References: <1403053685-28240-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, a percpu_ref undoes percpu_ref_init() automatically by
freeing the allocated percpu area when the percpu_ref is killed.
While seemingly convenient, this has the following niggles.

* It's impossible to re-init a released reference counter without
  going through re-allocation.

* In the similar vein, it's impossible to initialize a percpu_ref
  count with static percpu variables.

* We need and have an explicit destructor anyway for failure paths -
  percpu_ref_cancel_init().

This patch removes the automatic percpu counter freeing in
percpu_ref_kill_rcu() and repurposes percpu_ref_cancel_init() into a
generic destructor now named percpu_ref_exit().  percpu_ref_destroy()
is considered but it gets confusing with percpu_ref_kill() while
"exit" clearly indicates that it's the counterpart of
percpu_ref_init().

All percpu_ref_cancel_init() users are updated to invoke
percpu_ref_exit() instead and explicit percpu_ref_exit() calls are
added to the destruction path of all percpu_ref users.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 drivers/target/target_core_tpg.c |  4 +++-
 fs/aio.c                         |  6 ++++--
 include/linux/percpu-refcount.h  |  6 ++----
 kernel/cgroup.c                  |  8 +++++---
 lib/percpu-refcount.c            | 33 ++++++++++-----------------------
 5 files changed, 24 insertions(+), 33 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index c036595..fddfae6 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -825,7 +825,7 @@ int core_tpg_add_lun(
 
 	ret = core_dev_export(dev, tpg, lun);
 	if (ret < 0) {
-		percpu_ref_cancel_init(&lun->lun_ref);
+		percpu_ref_exit(&lun->lun_ref);
 		return ret;
 	}
 
@@ -880,5 +880,7 @@ int core_tpg_post_dellun(
 	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
 	spin_unlock(&tpg->tpg_lun_lock);
 
+	percpu_ref_exit(&lun->lun_ref);
+
 	return 0;
 }
diff --git a/fs/aio.c b/fs/aio.c
index 5e0d7f9..ea1bc2e 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -506,6 +506,8 @@ static void free_ioctx(struct work_struct *work)
 
 	aio_free_ring(ctx);
 	free_percpu(ctx->cpu);
+	percpu_ref_exit(&ctx->reqs);
+	percpu_ref_exit(&ctx->users);
 	kmem_cache_free(kioctx_cachep, ctx);
 }
 
@@ -715,8 +717,8 @@ err_ctx:
 err:
 	mutex_unlock(&ctx->ring_lock);
 	free_percpu(ctx->cpu);
-	percpu_ref_cancel_init(&ctx->reqs);
-	percpu_ref_cancel_init(&ctx->users);
+	percpu_ref_exit(&ctx->reqs);
+	percpu_ref_exit(&ctx->users);
 	kmem_cache_free(kioctx_cachep, ctx);
 	pr_debug("error allocating ioctx %d\n", err);
 	return ERR_PTR(err);
diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 6f8cd4c..0ddd283 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -57,9 +57,7 @@ struct percpu_ref {
 	atomic_t		count;
 	/*
 	 * The low bit of the pointer indicates whether the ref is in percpu
-	 * mode; if set, then get/put will manipulate the atomic_t (this is a
-	 * hack because we need to keep the pointer around for
-	 * percpu_ref_kill_rcu())
+	 * mode; if set, then get/put will manipulate the atomic_t.
 	 */
 	unsigned long		pcpu_count_ptr;
 	percpu_ref_func_t	*release;
@@ -69,7 +67,7 @@ struct percpu_ref {
 
 int __must_check percpu_ref_init(struct percpu_ref *ref,
 				 percpu_ref_func_t *release);
-void percpu_ref_cancel_init(struct percpu_ref *ref);
+void percpu_ref_exit(struct percpu_ref *ref);
 void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 				 percpu_ref_func_t *confirm_kill);
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7868fc3..c06aa5e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1638,7 +1638,7 @@ destroy_root:
 exit_root_id:
 	cgroup_exit_root_id(root);
 cancel_ref:
-	percpu_ref_cancel_init(&root_cgrp->self.refcnt);
+	percpu_ref_exit(&root_cgrp->self.refcnt);
 out:
 	free_cgrp_cset_links(&tmp_links);
 	return ret;
@@ -4133,6 +4133,8 @@ static void css_free_work_fn(struct work_struct *work)
 		container_of(work, struct cgroup_subsys_state, destroy_work);
 	struct cgroup *cgrp = css->cgroup;
 
+	percpu_ref_exit(&css->refcnt);
+
 	if (css->ss) {
 		/* css free path */
 		if (css->parent)
@@ -4330,7 +4332,7 @@ err_list_del:
 err_free_id:
 	cgroup_idr_remove(&ss->css_idr, css->id);
 err_free_percpu_ref:
-	percpu_ref_cancel_init(&css->refcnt);
+	percpu_ref_exit(&css->refcnt);
 err_free_css:
 	call_rcu(&css->rcu_head, css_free_rcu_fn);
 	return err;
@@ -4441,7 +4443,7 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 out_free_id:
 	cgroup_idr_remove(&root->cgroup_idr, cgrp->id);
 out_cancel_ref:
-	percpu_ref_cancel_init(&cgrp->self.refcnt);
+	percpu_ref_exit(&cgrp->self.refcnt);
 out_free_cgrp:
 	kfree(cgrp);
 out_unlock:
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index 94e5b62..ac42991 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -61,36 +61,25 @@ int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release)
 EXPORT_SYMBOL_GPL(percpu_ref_init);
 
 /**
- * percpu_ref_cancel_init - cancel percpu_ref_init()
- * @ref: percpu_ref to cancel init for
+ * percpu_ref_exit - undo percpu_ref_init()
+ * @ref: percpu_ref to exit
  *
- * Once a percpu_ref is initialized, its destruction is initiated by
- * percpu_ref_kill() and completes asynchronously, which can be painful to
- * do when destroying a half-constructed object in init failure path.
- *
- * This function destroys @ref without invoking @ref->release and the
- * memory area containing it can be freed immediately on return.  To
- * prevent accidental misuse, it's required that @ref has finished
- * percpu_ref_init(), whether successful or not, but never used.
- *
- * The weird name and usage restriction are to prevent people from using
- * this function by mistake for normal shutdown instead of
- * percpu_ref_kill().
+ * This function exits @ref.  The caller is responsible for ensuring that
+ * @ref is no longer in active use.  The usual places to invoke this
+ * function from are the @ref->release() callback or in init failure path
+ * where percpu_ref_init() succeeded but other parts of the initialization
+ * of the embedding object failed.
  */
-void percpu_ref_cancel_init(struct percpu_ref *ref)
+void percpu_ref_exit(struct percpu_ref *ref)
 {
 	unsigned __percpu *pcpu_count = pcpu_count_ptr(ref);
-	int cpu;
-
-	WARN_ON_ONCE(atomic_read(&ref->count) != 1 + PCPU_COUNT_BIAS);
 
 	if (pcpu_count) {
-		for_each_possible_cpu(cpu)
-			WARN_ON_ONCE(*per_cpu_ptr(pcpu_count, cpu));
 		free_percpu(pcpu_count);
+		ref->pcpu_count_ptr = PCPU_REF_DEAD;
 	}
 }
-EXPORT_SYMBOL_GPL(percpu_ref_cancel_init);
+EXPORT_SYMBOL_GPL(percpu_ref_exit);
 
 static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 {
@@ -102,8 +91,6 @@ static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 	for_each_possible_cpu(cpu)
 		count += *per_cpu_ptr(pcpu_count, cpu);
 
-	free_percpu(pcpu_count);
-
 	pr_debug("global %i pcpu %i", atomic_read(&ref->count), (int) count);
 
 	/*
-- 
1.9.3

