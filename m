Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbaEPRKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:10:06 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:48954 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbaEPRKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:10:03 -0400
Date: Fri, 16 May 2014 13:09:59 -0400
From: Tejun Heo <tj@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        ARM kernel mailing list 
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 cgroup/for-3.16] cgroup: introduce CSS_NO_REF and skip
 refcnting on normal root csses
Message-ID: <20140516170959.GG5379@htj.dyndns.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org>
 <1399670015-23463-10-git-send-email-tj@kernel.org>
 <53751062.2050401@wwwdotorg.org>
 <53753823.2090402@wwwdotorg.org>
 <20140516143718.GA5379@htj.dyndns.org>
 <20140516154330.GB5379@htj.dyndns.org>
 <537643F9.1030303@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537643F9.1030303@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

9395a4500404 ("cgroup: enable refcnting for root csses") enabled
reference counting for root csses (cgroup_subsys_states) so that
cgroup's self csses can be used to manage the lifetime of the
containing cgroups.

Unfortunately, this change was incorrect.  During early init,
cgrp_dfl_root self css refcnt is used.  percpu_ref can't initialized
during early init and its initialization is deferred till
cgroup_init() time.  This means that cpu was using percpu_ref which
wasn't properly initialized.  Due to the way percpu variables are laid
out on x86, this didn't blow up immediately on x86 but ended up
incrementing and decrementing the percpu variable at offset zero,
whatever it may be; however, on other archs, this caused fault and
early boot failure.

As cgroup self csses for root cgroups of non-dfl hierarchies need
working refcounting, we can't revert 9395a4500404.  This patch adds
CSS_NO_REF which explicitly inhibits reference counting on the css and
sets it on all normal (non-self) csses and cgroup_dfl_root self css.

v2: cgrp_dfl_root.self is the offending one.  Set the flag on it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Stephen Warren <swarren@wwwdotorg.org>
Fixes: 9395a4500404 ("cgroup: enable refcnting for root csses")
---
Hello,

Can you try this one instead?

Thanks.

 include/linux/cgroup.h |   11 ++++++++---
 kernel/cgroup.c        |   11 +++++++++--
 2 files changed, 17 insertions(+), 5 deletions(-)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -77,6 +77,7 @@ struct cgroup_subsys_state {
 
 /* bits in struct cgroup_subsys_state flags field */
 enum {
+	CSS_NO_REF	= (1 << 0), /* no reference counting for this css */
 	CSS_ONLINE	= (1 << 1), /* between ->css_online() and ->css_offline() */
 };
 
@@ -88,7 +89,8 @@ enum {
  */
 static inline void css_get(struct cgroup_subsys_state *css)
 {
-	percpu_ref_get(&css->refcnt);
+	if (!(css->flags & CSS_NO_REF))
+		percpu_ref_get(&css->refcnt);
 }
 
 /**
@@ -103,7 +105,9 @@ static inline void css_get(struct cgroup
  */
 static inline bool css_tryget_online(struct cgroup_subsys_state *css)
 {
-	return percpu_ref_tryget_live(&css->refcnt);
+	if (!(css->flags & CSS_NO_REF))
+		return percpu_ref_tryget_live(&css->refcnt);
+	return true;
 }
 
 /**
@@ -114,7 +118,8 @@ static inline bool css_tryget_online(str
  */
 static inline void css_put(struct cgroup_subsys_state *css)
 {
-	percpu_ref_put(&css->refcnt);
+	if (!(css->flags & CSS_NO_REF))
+		percpu_ref_put(&css->refcnt);
 }
 
 /* bits in struct cgroup flags field */
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4593,11 +4593,17 @@ static void __init cgroup_init_subsys(st
 	/* We don't handle early failures gracefully */
 	BUG_ON(IS_ERR(css));
 	init_and_link_css(css, ss, &cgrp_dfl_root.cgrp);
+
+	/*
+	 * Root csses are never destroyed and we can't initialize
+	 * percpu_ref during early init.  Disable refcnting.
+	 */
+	css->flags |= CSS_NO_REF;
+
 	if (early) {
 		/* allocation can't be done safely during early init */
 		css->id = 1;
 	} else {
-		BUG_ON(percpu_ref_init(&css->refcnt, css_release));
 		css->id = cgroup_idr_alloc(&ss->css_idr, css, 1, 2, GFP_KERNEL);
 		BUG_ON(css->id < 0);
 	}
@@ -4636,6 +4642,8 @@ int __init cgroup_init_early(void)
 	int i;
 
 	init_cgroup_root(&cgrp_dfl_root, &opts);
+	cgrp_dfl_root.cgrp.self.flags |= CSS_NO_REF;
+
 	RCU_INIT_POINTER(init_task.cgroups, &init_css_set);
 
 	for_each_subsys(ss, i) {
@@ -4684,7 +4692,6 @@ int __init cgroup_init(void)
 			struct cgroup_subsys_state *css =
 				init_css_set.subsys[ss->id];
 
-			BUG_ON(percpu_ref_init(&css->refcnt, css_release));
 			css->id = cgroup_idr_alloc(&ss->css_idr, css, 1, 2,
 						   GFP_KERNEL);
 			BUG_ON(css->id < 0);
