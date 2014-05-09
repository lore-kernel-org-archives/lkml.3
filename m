Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbaEIVNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:13:52 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:47782 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757754AbaEIVNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:13:49 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 8/9] cgroup: enable refcnting for root csses
Date: Fri,  9 May 2014 17:13:34 -0400
Message-Id: <1399670015-23463-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399670015-23463-1-git-send-email-tj@kernel.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, css_get(), css_tryget() and css_tryget_online() are noops
for root csses as an optimization; however, we're planning to use css
refcnts to track of cgroup lifetime too and root cgroups also need to
be reference counted.  Since css has been converted to percpu_refcnt,
the overhead of refcnting is miniscule and this optimization isn't too
meaningful anymore.  Furthermore, controllers which optimize the root
cgroup often never even invoke these functions in their hot paths.

This patch enables refcnting for root csses too.  This makes CSS_ROOT
flag unused and removes it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 10 ++--------
 kernel/cgroup.c        |  6 +++---
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 160fcc6..286e39e 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -77,7 +77,6 @@ struct cgroup_subsys_state {
 
 /* bits in struct cgroup_subsys_state flags field */
 enum {
-	CSS_ROOT	= (1 << 0), /* this CSS is the root of the subsystem */
 	CSS_ONLINE	= (1 << 1), /* between ->css_online() and ->css_offline() */
 };
 
@@ -89,9 +88,7 @@ enum {
  */
 static inline void css_get(struct cgroup_subsys_state *css)
 {
-	/* We don't need to reference count the root state */
-	if (!(css->flags & CSS_ROOT))
-		percpu_ref_get(&css->refcnt);
+	percpu_ref_get(&css->refcnt);
 }
 
 /**
@@ -106,8 +103,6 @@ static inline void css_get(struct cgroup_subsys_state *css)
  */
 static inline bool css_tryget_online(struct cgroup_subsys_state *css)
 {
-	if (css->flags & CSS_ROOT)
-		return true;
 	return percpu_ref_tryget_live(&css->refcnt);
 }
 
@@ -119,8 +114,7 @@ static inline bool css_tryget_online(struct cgroup_subsys_state *css)
  */
 static inline void css_put(struct cgroup_subsys_state *css)
 {
-	if (!(css->flags & CSS_ROOT))
-		percpu_ref_put(&css->refcnt);
+	percpu_ref_put(&css->refcnt);
 }
 
 /* bits in struct cgroup flags field */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b382383..5a31e61 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4157,8 +4157,6 @@ static void init_and_link_css(struct cgroup_subsys_state *css,
 	if (cgrp->parent) {
 		css->parent = cgroup_css(cgrp->parent, ss);
 		css_get(css->parent);
-	} else {
-		css->flags |= CSS_ROOT;
 	}
 
 	BUG_ON(cgroup_css(cgrp, ss));
@@ -4581,9 +4579,10 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 	BUG_ON(IS_ERR(css));
 	init_and_link_css(css, ss, &cgrp_dfl_root.cgrp);
 	if (early) {
-		/* idr_alloc() can't be called safely during early init */
+		/* allocation can't be done safely during early init */
 		css->id = 1;
 	} else {
+		BUG_ON(percpu_ref_init(&css->refcnt, css_release));
 		css->id = cgroup_idr_alloc(&ss->css_idr, css, 1, 2, GFP_KERNEL);
 		BUG_ON(css->id < 0);
 	}
@@ -4670,6 +4669,7 @@ int __init cgroup_init(void)
 			struct cgroup_subsys_state *css =
 				init_css_set.subsys[ss->id];
 
+			BUG_ON(percpu_ref_init(&css->refcnt, css_release));
 			css->id = cgroup_idr_alloc(&ss->css_idr, css, 1, 2,
 						   GFP_KERNEL);
 			BUG_ON(css->id < 0);
-- 
1.9.0

