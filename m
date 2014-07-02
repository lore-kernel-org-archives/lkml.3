Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbaGBXvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 19:51:09 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:56154 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbaGBXvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 19:51:06 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/5] cgroup: make CFTYPE_ONLY_ON_DFL and CFTYPE_NO_ internal to cgroup core
Date: Wed,  2 Jul 2014 19:50:55 -0400
Message-Id: <1404345055-8196-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404345055-8196-1-git-send-email-tj@kernel.org>
References: <1404345055-8196-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup now distinguishes cftypes for the default and legacy
hierarchies more explicitly by using separate arrays and
CFTYPE_ONLY_ON_DFL and CFTYPE_INSANE should be and are used only
inside cgroup core proper.  Let's make it clear that the flags are
internal by prefixing them with double underscores.

CFTYPE_INSANE is renamed to __CFTYPE_NOT_ON_DFL for consistency.  The
two flags are also collected and assigned bits >= 16 so that they
aren't mixed with the published flags.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 6 ++++--
 kernel/cgroup.c        | 8 ++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 62a2be1..c047887c 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -376,9 +376,11 @@ struct css_set {
 enum {
 	CFTYPE_ONLY_ON_ROOT	= (1 << 0),	/* only create on root cgrp */
 	CFTYPE_NOT_ON_ROOT	= (1 << 1),	/* don't create on root cgrp */
-	CFTYPE_INSANE		= (1 << 2),	/* don't create if sane_behavior */
 	CFTYPE_NO_PREFIX	= (1 << 3),	/* (DON'T USE FOR NEW FILES) no subsys prefix */
-	CFTYPE_ONLY_ON_DFL	= (1 << 4),	/* only on default hierarchy */
+
+	/* internal flags, do not use outside cgroup core proper */
+	__CFTYPE_ONLY_ON_DFL	= (1 << 16),	/* only on default hierarchy */
+	__CFTYPE_NOT_ON_DFL	= (1 << 17),	/* not on default hierarchy */
 };
 
 #define MAX_CFTYPE_NAME		64
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 94cdb7b..028ebf1 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2921,9 +2921,9 @@ static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
 
 	for (cft = cfts; cft->name[0] != '\0'; cft++) {
 		/* does cft->flags tell us to skip this file on @cgrp? */
-		if ((cft->flags & CFTYPE_ONLY_ON_DFL) && !cgroup_on_dfl(cgrp))
+		if ((cft->flags & __CFTYPE_ONLY_ON_DFL) && !cgroup_on_dfl(cgrp))
 			continue;
-		if ((cft->flags & CFTYPE_INSANE) && cgroup_on_dfl(cgrp))
+		if ((cft->flags & __CFTYPE_NOT_ON_DFL) && cgroup_on_dfl(cgrp))
 			continue;
 		if ((cft->flags & CFTYPE_NOT_ON_ROOT) && !cgroup_parent(cgrp))
 			continue;
@@ -3104,7 +3104,7 @@ int cgroup_add_dfl_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 	struct cftype *cft;
 
 	for (cft = cfts; cft && cft->name[0] != '\0'; cft++)
-		cft->flags |= CFTYPE_ONLY_ON_DFL;
+		cft->flags |= __CFTYPE_ONLY_ON_DFL;
 	return cgroup_add_cftypes(ss, cfts);
 }
 
@@ -3121,7 +3121,7 @@ int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 	struct cftype *cft;
 
 	for (cft = cfts; cft && cft->name[0] != '\0'; cft++)
-		cft->flags |= CFTYPE_INSANE;
+		cft->flags |= __CFTYPE_NOT_ON_DFL;
 	return cgroup_add_cftypes(ss, cfts);
 }
 
-- 
1.9.3

