Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbaIWF4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:56:35 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:42255 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536AbaIWFzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:55:32 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: kmo@daterainc.com, axboe@kernel.dk, hch@infradead.org, hannes@cmpxchg.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 8/9] percpu_ref: add PERCPU_REF_INIT_* flags
Date: Tue, 23 Sep 2014 01:55:17 -0400
Message-Id: <1411451718-17807-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411451718-17807-1-git-send-email-tj@kernel.org>
References: <1411451718-17807-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the recent addition of percpu_ref_reinit(), percpu_ref now can be
used as a persistent switch which can be turned on and off repeatedly
where turning off maps to killing the ref and waiting for it to drain;
however, there currently isn't a way to initialize a percpu_ref in its
off (killed and drained) state, which can be inconvenient for certain
persistent switch use cases.

Similarly, percpu_ref_switch_to_atomic/percpu() allow dynamic
selection of operation mode; however, currently a newly initialized
percpu_ref is always in percpu mode making it impossible to avoid the
latency overhead of switching to atomic mode.

This patch adds @flags to percpu_ref_init() and implements the
following flags.

* PERCPU_REF_INIT_ATOMIC	: start ref in atomic mode
* PERCPU_REF_INIT_DEAD		: start ref killed and drained

These flags should be able to serve the above two use cases.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 block/blk-mq.c                  |  2 +-
 fs/aio.c                        |  4 ++--
 include/linux/percpu-refcount.h | 18 +++++++++++++++++-
 kernel/cgroup.c                 |  7 ++++---
 lib/percpu-refcount.c           | 24 +++++++++++++++++++-----
 5 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 702df07..3f6e6f5 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1777,7 +1777,7 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 		goto err_hctxs;
 
 	if (percpu_ref_init(&q->mq_usage_counter, blk_mq_usage_counter_release,
-			    GFP_KERNEL))
+			    0, GFP_KERNEL))
 		goto err_map;
 
 	setup_timer(&q->timeout, blk_mq_rq_timer, (unsigned long) q);
diff --git a/fs/aio.c b/fs/aio.c
index 93fbcc0f..9b6d5d6 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -666,10 +666,10 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 
 	INIT_LIST_HEAD(&ctx->active_reqs);
 
-	if (percpu_ref_init(&ctx->users, free_ioctx_users, GFP_KERNEL))
+	if (percpu_ref_init(&ctx->users, free_ioctx_users, 0, GFP_KERNEL))
 		goto err;
 
-	if (percpu_ref_init(&ctx->reqs, free_ioctx_reqs, GFP_KERNEL))
+	if (percpu_ref_init(&ctx->reqs, free_ioctx_reqs, 0, GFP_KERNEL))
 		goto err;
 
 	ctx->cpu = alloc_percpu(struct kioctx_cpu);
diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index e41ca20..5f84bf0 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -61,6 +61,21 @@ enum {
 	__PERCPU_REF_ATOMIC_DEAD = __PERCPU_REF_ATOMIC | __PERCPU_REF_DEAD,
 };
 
+/* @flags for percpu_ref_init() */
+enum {
+	/*
+	 * Start w/ ref == 1 in atomic mode.  Can be switched to percpu
+	 * operation using percpu_ref_switch_to_percpu().
+	 */
+	PERCPU_REF_INIT_ATOMIC	= 1 << 0,
+
+	/*
+	 * Start dead w/ ref == 0 in atomic mode.  Must be revived with
+	 * percpu_ref_reinit() before used.  Implies INIT_ATOMIC.
+	 */
+	PERCPU_REF_INIT_DEAD	= 1 << 1,
+};
+
 struct percpu_ref {
 	atomic_long_t		count;
 	/*
@@ -74,7 +89,8 @@ struct percpu_ref {
 };
 
 int __must_check percpu_ref_init(struct percpu_ref *ref,
-				 percpu_ref_func_t *release, gfp_t gfp);
+				 percpu_ref_func_t *release, unsigned int flags,
+				 gfp_t gfp);
 void percpu_ref_exit(struct percpu_ref *ref);
 void percpu_ref_switch_to_atomic(struct percpu_ref *ref,
 				 percpu_ref_func_t *confirm_switch);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 589b4d8..e2fbcc1 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1628,7 +1628,8 @@ static int cgroup_setup_root(struct cgroup_root *root, unsigned int ss_mask)
 		goto out;
 	root_cgrp->id = ret;
 
-	ret = percpu_ref_init(&root_cgrp->self.refcnt, css_release, GFP_KERNEL);
+	ret = percpu_ref_init(&root_cgrp->self.refcnt, css_release, 0,
+			      GFP_KERNEL);
 	if (ret)
 		goto out;
 
@@ -4487,7 +4488,7 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss,
 
 	init_and_link_css(css, ss, cgrp);
 
-	err = percpu_ref_init(&css->refcnt, css_release, GFP_KERNEL);
+	err = percpu_ref_init(&css->refcnt, css_release, 0, GFP_KERNEL);
 	if (err)
 		goto err_free_css;
 
@@ -4555,7 +4556,7 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 		goto out_unlock;
 	}
 
-	ret = percpu_ref_init(&cgrp->self.refcnt, css_release, GFP_KERNEL);
+	ret = percpu_ref_init(&cgrp->self.refcnt, css_release, 0, GFP_KERNEL);
 	if (ret)
 		goto out_free_cgrp;
 
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index 548b19e..74ec33e 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -45,27 +45,41 @@ static unsigned long __percpu *percpu_count_ptr(struct percpu_ref *ref)
  * percpu_ref_init - initialize a percpu refcount
  * @ref: percpu_ref to initialize
  * @release: function which will be called when refcount hits 0
+ * @flags: PERCPU_REF_INIT_* flags
  * @gfp: allocation mask to use
  *
- * Initializes the refcount in single atomic counter mode with a refcount of 1;
- * analagous to atomic_long_set(ref, 1).
+ * Initializes @ref.  If @flags is zero, @ref starts in percpu mode with a
+ * refcount of 1; analagous to atomic_long_set(ref, 1).  See the
+ * definitions of PERCPU_REF_INIT_* flags for flag behaviors.
  *
  * Note that @release must not sleep - it may potentially be called from RCU
  * callback context by percpu_ref_kill().
  */
 int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release,
-		    gfp_t gfp)
+		    unsigned int flags, gfp_t gfp)
 {
+	unsigned long start_count = 0;
+
 	BUILD_BUG_ON(__PERCPU_REF_ATOMIC_DEAD &
 		     ~(__alignof__(unsigned long) - 1));
 
-	atomic_long_set(&ref->count, 1 + PERCPU_COUNT_BIAS);
-
 	ref->percpu_count_ptr =
 		(unsigned long)alloc_percpu_gfp(unsigned long, gfp);
 	if (!ref->percpu_count_ptr)
 		return -ENOMEM;
 
+	if (flags & (PERCPU_REF_INIT_ATOMIC | PERCPU_REF_INIT_DEAD))
+		ref->percpu_count_ptr |= __PERCPU_REF_ATOMIC;
+	else
+		start_count += PERCPU_COUNT_BIAS;
+
+	if (flags & PERCPU_REF_INIT_DEAD)
+		ref->percpu_count_ptr |= __PERCPU_REF_DEAD;
+	else
+		start_count++;
+
+	atomic_long_set(&ref->count, start_count);
+
 	ref->release = release;
 	return 0;
 }
-- 
1.9.3

