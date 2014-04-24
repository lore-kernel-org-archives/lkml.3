Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbaDXVDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:03:31 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:53211 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbaDXVC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:02:28 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
        mhocko@suse.cz, nasa4836@gmail.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] cgroup: use RCU free in create_css() failure path
Date: Thu, 24 Apr 2014 17:02:11 -0400
Message-Id: <1398373333-1521-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398373333-1521-1-git-send-email-tj@kernel.org>
References: <1398373333-1521-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when create_css() fails in the middle, the half-initialized
css is freed by invoking cgroup_subsys->css_free() directly.  This
patch updates the function so that it invokes RCU free path instead.
As the RCU free path puts the parent css and owning cgroup, their
references are now acquired right after a new css is successfully
allocated.

This doesn't make any visible difference now but is to enable
implementing css->id and RCU protected lookup by such IDs.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7cb9c08..0e2c401 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4185,12 +4185,14 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
 	if (IS_ERR(css))
 		return PTR_ERR(css);
 
+	init_css(css, ss, cgrp);
+	cgroup_get(cgrp);
+	css_get(css->parent);
+
 	err = percpu_ref_init(&css->refcnt, css_release);
 	if (err)
 		goto err_free_css;
 
-	init_css(css, ss, cgrp);
-
 	err = cgroup_populate_dir(cgrp, 1 << ss->id);
 	if (err)
 		goto err_free_percpu_ref;
@@ -4199,9 +4201,6 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
 	if (err)
 		goto err_clear_dir;
 
-	cgroup_get(cgrp);
-	css_get(css->parent);
-
 	if (ss->broken_hierarchy && !ss->warned_broken_hierarchy &&
 	    parent->parent) {
 		pr_warn("%s (%d) created nested cgroup for controller \"%s\" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.\n",
@@ -4218,7 +4217,7 @@ err_clear_dir:
 err_free_percpu_ref:
 	percpu_ref_cancel_init(&css->refcnt);
 err_free_css:
-	ss->css_free(css);
+	call_rcu(&css->rcu_head, css_free_rcu_fn);
 	return err;
 }
 
-- 
1.9.0

