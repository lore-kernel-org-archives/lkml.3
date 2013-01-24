Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab3AXPR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:17:29 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:45644 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239Ab3AXPR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:17:26 -0500
From: Lord Glauber Costa of Sealand <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        ccross@google.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH v6 02/12] cgroup: implement CFTYPE_NO_PREFIX
Date: Thu, 24 Jan 2013 19:17:32 +0400
Message-Id: <1359040662-8055-3-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359040662-8055-1-git-send-email-glommer@parallels.com>
References: <1359040662-8055-1-git-send-email-glommer@parallels.com>
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
Cc: Glauber Costa <glommer@parallels.com>
---
 include/linux/cgroup.h | 1 +
 kernel/cgroup.c        | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 7d73905..7d193f9 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -277,6 +277,7 @@ struct cgroup_map_cb {
 /* cftype->flags */
 #define CFTYPE_ONLY_ON_ROOT	(1U << 0)	/* only create on root cg */
 #define CFTYPE_NOT_ON_ROOT	(1U << 1)	/* don't create on root cg */
+#define CFTYPE_NO_PREFIX	(1U << 2)	/* skip subsys prefix */
 
 #define MAX_CFTYPE_NAME		64
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4855892..2f98398 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2723,7 +2723,8 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 
 	simple_xattrs_init(&cft->xattrs);
 
-	if (subsys && !test_bit(ROOT_NOPREFIX, &cgrp->root->flags)) {
+	if (subsys && !(cft->flags & CFTYPE_NO_PREFIX) &&
+	    !test_bit(ROOT_NOPREFIX, &cgrp->root->flags)) {
 		strcpy(name, subsys->name);
 		strcat(name, ".");
 	}
-- 
1.8.1

