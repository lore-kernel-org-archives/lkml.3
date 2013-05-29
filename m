Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965808Ab3E2LIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:08:19 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:41622 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965643Ab3E2LIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:08:15 -0400
From: Glauber Costa <glommer@openvz.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>, <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, <cgroups@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, <devel@openvz.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Glauber Costa <glommer@openvz.org>
Subject: [PATCH v7 02/11] cgroup: implement CFTYPE_NO_PREFIX
Date: Wed, 29 May 2013 15:03:13 +0400
Message-Id: <1369825402-31046-3-git-send-email-glommer@openvz.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369825402-31046-1-git-send-email-glommer@openvz.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

When cgroup files are created, cgroup core automatically prepends the
name of the subsystem as prefix.  This patch adds CFTYPE_NO_PREFIX
which disables the automatic prefix.

This will be used to deprecate cpuacct which will make cpu create and
serve the cpuacct files.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Glauber Costa <glommer@openvz.org>
---
 include/linux/cgroup.h | 1 +
 kernel/cgroup.c        | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 5047355..5a8a093 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -397,6 +397,7 @@ struct cgroup_map_cb {
 #define CFTYPE_ONLY_ON_ROOT	(1U << 0)	/* only create on root cg */
 #define CFTYPE_NOT_ON_ROOT	(1U << 1)	/* don't create on root cg */
 #define CFTYPE_INSANE		(1U << 2)	/* don't create if sane_behavior */
+#define CFTYPE_NO_PREFIX	(1U << 3)	/* skip subsys prefix */
 
 #define MAX_CFTYPE_NAME		64
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2a99262..8bbeb4d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2681,7 +2681,8 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 	umode_t mode;
 	char name[MAX_CGROUP_TYPE_NAMELEN + MAX_CFTYPE_NAME + 2] = { 0 };
 
-	if (subsys && !(cgrp->root->flags & CGRP_ROOT_NOPREFIX)) {
+	if (subsys && !(cft->flags & CFTYPE_NO_PREFIX) &&
+		!(cgrp->root->flags & CGRP_ROOT_NOPREFIX)) {
 		strcpy(name, subsys->name);
 		strcat(name, ".");
 	}
-- 
1.8.1.4

