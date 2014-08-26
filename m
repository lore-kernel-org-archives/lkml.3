Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbaHZAn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 20:43:59 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:48497 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818AbaHZAnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 20:43:42 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: cl@linux-foundation.org, Tejun Heo <tj@kernel.org>,
        Kent Overstreet <koverstreet@google.com>,
        Benjamin LaHaise <bcrl@kvack.org>, Li Zefan <lizefan@huawei.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/3] percpu-refcount: add @gfp to percpu_ref_init()
Date: Mon, 25 Aug 2014 20:43:32 -0400
Message-Id: <1409013812-21700-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409013812-21700-1-git-send-email-tj@kernel.org>
References: <1409013812-21700-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Percpu allocator now supports allocation mask.  Add @gfp to
percpu_ref_init() so that !GFP_KERNEL allocation masks can be used
with percpu_refs too.

This patch doesn't make any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_tpg.c | 3 ++-
 fs/aio.c                         | 4 ++--
 include/linux/percpu-refcount.h  | 3 ++-
 kernel/cgroup.c                  | 6 +++---
 lib/percpu-refcount.c            | 6 ++++--
 5 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index fddfae6..4ab6da3 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -819,7 +819,8 @@ int core_tpg_add_lun(
 {
 	int ret;
 
-	ret = percpu_ref_init(&lun->lun_ref, core_tpg_lun_ref_release);
+	ret = percpu_ref_init(&lun->lun_ref, core_tpg_lun_ref_release,
+			      GFP_KERNEL);
 	if (ret < 0)
 		return ret;
 
diff --git a/fs/aio.c b/fs/aio.c
index bd7ec2c..93fbcc0f 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -666,10 +666,10 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 
 	INIT_LIST_HEAD(&ctx->active_reqs);
 
-	if (percpu_ref_init(&ctx->users, free_ioctx_users))
+	if (percpu_ref_init(&ctx->users, free_ioctx_users, GFP_KERNEL))
 		goto err;
 
-	if (percpu_ref_init(&ctx->reqs, free_ioctx_reqs))
+	if (percpu_ref_init(&ctx->reqs, free_ioctx_reqs, GFP_KERNEL))
 		goto err;
 
 	ctx->cpu = alloc_percpu(struct kioctx_cpu);
diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 3dfbf23..ee83251 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -49,6 +49,7 @@
 #include <linux/kernel.h>
 #include <linux/percpu.h>
 #include <linux/rcupdate.h>
+#include <linux/gfp.h>
 
 struct percpu_ref;
 typedef void (percpu_ref_func_t)(struct percpu_ref *);
@@ -66,7 +67,7 @@ struct percpu_ref {
 };
 
 int __must_check percpu_ref_init(struct percpu_ref *ref,
-				 percpu_ref_func_t *release);
+				 percpu_ref_func_t *release, gfp_t gfp);
 void percpu_ref_reinit(struct percpu_ref *ref);
 void percpu_ref_exit(struct percpu_ref *ref);
 void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7dc8788..589b4d8 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1628,7 +1628,7 @@ static int cgroup_setup_root(struct cgroup_root *root, unsigned int ss_mask)
 		goto out;
 	root_cgrp->id = ret;
 
-	ret = percpu_ref_init(&root_cgrp->self.refcnt, css_release);
+	ret = percpu_ref_init(&root_cgrp->self.refcnt, css_release, GFP_KERNEL);
 	if (ret)
 		goto out;
 
@@ -4487,7 +4487,7 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss,
 
 	init_and_link_css(css, ss, cgrp);
 
-	err = percpu_ref_init(&css->refcnt, css_release);
+	err = percpu_ref_init(&css->refcnt, css_release, GFP_KERNEL);
 	if (err)
 		goto err_free_css;
 
@@ -4555,7 +4555,7 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 		goto out_unlock;
 	}
 
-	ret = percpu_ref_init(&cgrp->self.refcnt, css_release);
+	ret = percpu_ref_init(&cgrp->self.refcnt, css_release, GFP_KERNEL);
 	if (ret)
 		goto out_free_cgrp;
 
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index fe5a334..ff99032 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -40,6 +40,7 @@ static unsigned __percpu *pcpu_count_ptr(struct percpu_ref *ref)
  * percpu_ref_init - initialize a percpu refcount
  * @ref: percpu_ref to initialize
  * @release: function which will be called when refcount hits 0
+ * @gfp: allocation mask to use
  *
  * Initializes the refcount in single atomic counter mode with a refcount of 1;
  * analagous to atomic_set(ref, 1).
@@ -47,11 +48,12 @@ static unsigned __percpu *pcpu_count_ptr(struct percpu_ref *ref)
  * Note that @release must not sleep - it may potentially be called from RCU
  * callback context by percpu_ref_kill().
  */
-int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release)
+int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release,
+		    gfp_t gfp)
 {
 	atomic_set(&ref->count, 1 + PCPU_COUNT_BIAS);
 
-	ref->pcpu_count_ptr = (unsigned long)alloc_percpu(unsigned);
+	ref->pcpu_count_ptr = (unsigned long)alloc_percpu_gfp(unsigned, gfp);
 	if (!ref->pcpu_count_ptr)
 		return -ENOMEM;
 
-- 
1.9.3

