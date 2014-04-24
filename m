Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbaDXVCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:02:33 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:36167 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbaDXVC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:02:29 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
        mhocko@suse.cz, nasa4836@gmail.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/6] cgroup: update init_css() into init_and_link_css()
Date: Thu, 24 Apr 2014 17:02:12 -0400
Message-Id: <1398373333-1521-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398373333-1521-1-git-send-email-tj@kernel.org>
References: <1398373333-1521-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_css() takes the cgroup the new css belongs to as an argument and
initializes the new css's ->cgroup and ->parent pointers but doesn't
acquire the matching reference counts.  After the previous patch,
create_css() puts init_css() and reference acquisition right next to
each other.  Let's move reference acquistion into init_css() and
rename the function to init_and_link_css().  This makes sense and is
easier to follow.  This makes the root csses to hold a reference on
cgrp_dfl_root.cgrp, which is harmless.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0e2c401..f1c98c5 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4109,17 +4109,21 @@ static void css_release(struct percpu_ref *ref)
 	call_rcu(&css->rcu_head, css_free_rcu_fn);
 }
 
-static void init_css(struct cgroup_subsys_state *css, struct cgroup_subsys *ss,
-		     struct cgroup *cgrp)
+static void init_and_link_css(struct cgroup_subsys_state *css,
+			      struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
+	cgroup_get(cgrp);
+
 	css->cgroup = cgrp;
 	css->ss = ss;
 	css->flags = 0;
 
-	if (cgrp->parent)
+	if (cgrp->parent) {
 		css->parent = cgroup_css(cgrp->parent, ss);
-	else
+		css_get(css->parent);
+	} else {
 		css->flags |= CSS_ROOT;
+	}
 
 	BUG_ON(cgroup_css(cgrp, ss));
 }
@@ -4185,9 +4189,7 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
 	if (IS_ERR(css))
 		return PTR_ERR(css);
 
-	init_css(css, ss, cgrp);
-	cgroup_get(cgrp);
-	css_get(css->parent);
+	init_and_link_css(css, ss, cgrp);
 
 	err = percpu_ref_init(&css->refcnt, css_release);
 	if (err)
@@ -4656,7 +4658,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
 	css = ss->css_alloc(cgroup_css(&cgrp_dfl_root.cgrp, ss));
 	/* We don't handle early failures gracefully */
 	BUG_ON(IS_ERR(css));
-	init_css(css, ss, &cgrp_dfl_root.cgrp);
+	init_and_link_css(css, ss, &cgrp_dfl_root.cgrp);
 
 	/* Update the init_css_set to contain a subsys
 	 * pointer to this state - since the subsystem is
-- 
1.9.0

