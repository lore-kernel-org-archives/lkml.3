Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966527Ab3HHUSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 16:18:25 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:47763 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966335Ab3HHUOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 16:14:07 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/14] cgroup: rename cgroup_subsys_state->dput_work and its callback function
Date: Thu,  8 Aug 2013 16:13:39 -0400
Message-Id: <1375992831-4650-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375992831-4650-1-git-send-email-tj@kernel.org>
References: <1375992831-4650-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

css (cgroup_subsys_state) will become RCU protected and there will be
two stages which require punting to work item during release.  To
prepare for using the work item for multiple times, rename
css->dput_work to css->destroy_work and css_dput_fn() to
css_free_work_fn() and move work item initialization from css init to
right before the actual usage.

This reorganization doesn't introduce any behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  2 +-
 kernel/cgroup.c        | 21 ++++++++++-----------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 8ec5b0f..12d66fe 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -80,7 +80,7 @@ struct cgroup_subsys_state {
 	struct css_id __rcu *id;
 
 	/* Used to put @cgroup->dentry on the last css_put() */
-	struct work_struct dput_work;
+	struct work_struct destroy_work;
 };
 
 /* bits in struct cgroup_subsys_state flags field */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 49ad96e..0b28097 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4259,10 +4259,10 @@ err:
 	return ret;
 }
 
-static void css_dput_fn(struct work_struct *work)
+static void css_free_work_fn(struct work_struct *work)
 {
 	struct cgroup_subsys_state *css =
-		container_of(work, struct cgroup_subsys_state, dput_work);
+		container_of(work, struct cgroup_subsys_state, destroy_work);
 
 	cgroup_dput(css->cgroup);
 }
@@ -4272,7 +4272,14 @@ static void css_release(struct percpu_ref *ref)
 	struct cgroup_subsys_state *css =
 		container_of(ref, struct cgroup_subsys_state, refcnt);
 
-	schedule_work(&css->dput_work);
+	/*
+	 * css holds an extra ref to @cgrp->dentry which is put on the last
+	 * css_put().  dput() requires process context, which css_put() may
+	 * be called without.  @css->destroy_work will be used to invoke
+	 * dput() asynchronously from css_put().
+	 */
+	INIT_WORK(&css->destroy_work, css_free_work_fn);
+	schedule_work(&css->destroy_work);
 }
 
 static void init_cgroup_css(struct cgroup_subsys_state *css,
@@ -4287,14 +4294,6 @@ static void init_cgroup_css(struct cgroup_subsys_state *css,
 		css->flags |= CSS_ROOT;
 	BUG_ON(cgroup_css(cgrp, ss->subsys_id));
 	cgrp->subsys[ss->subsys_id] = css;
-
-	/*
-	 * css holds an extra ref to @cgrp->dentry which is put on the last
-	 * css_put().  dput() requires process context, which css_put() may
-	 * be called without.  @css->dput_work will be used to invoke
-	 * dput() asynchronously from css_put().
-	 */
-	INIT_WORK(&css->dput_work, css_dput_fn);
 }
 
 /* invoke ->css_online() on a new CSS and mark it online if successful */
-- 
1.8.3.1

