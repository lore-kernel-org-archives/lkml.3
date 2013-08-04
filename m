Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab3HDQHi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 12:07:38 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:57666 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab3HDQHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 12:07:35 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@gmail.com>
Subject: [PATCH 1/5] cgroup: implement CFTYPE_NO_PREFIX
Date: Sun,  4 Aug 2013 12:07:22 -0400
Message-Id: <1375632446-2581-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375632446-2581-1-git-send-email-tj@kernel.org>
References: <1375632446-2581-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When cgroup files are created, cgroup core automatically prepends the
name of the subsystem as prefix.  This patch adds CFTYPE_NO_ which
disables the automatic prefix.  This is to work around historical
baggages and shouldn't be used for new files.

This will be used to move "cgroup.event_control" from cgroup core to
memcg.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@gmail.com>
---
 include/linux/cgroup.h | 1 +
 kernel/cgroup.c        | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index c40e508..30d6ec4 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -405,6 +405,7 @@ enum {
 	CFTYPE_ONLY_ON_ROOT	= (1 << 0),	/* only create on root cgrp */
 	CFTYPE_NOT_ON_ROOT	= (1 << 1),	/* don't create on root cgrp */
 	CFTYPE_INSANE		= (1 << 2),	/* don't create if sane_behavior */
+	CFTYPE_NO_PREFIX	= (1 << 3),	/* (DON'T USE FOR NEW FILES) no subsys prefix */
 };
 
 #define MAX_CFTYPE_NAME		64
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c02a288..1b87e2b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2749,7 +2749,8 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cftype *cft)
 	umode_t mode;
 	char name[MAX_CGROUP_TYPE_NAMELEN + MAX_CFTYPE_NAME + 2] = { 0 };
 
-	if (cft->ss && !(cgrp->root->flags & CGRP_ROOT_NOPREFIX)) {
+	if (cft->ss && !(cft->flags & CFTYPE_NO_PREFIX) &&
+	    !(cgrp->root->flags & CGRP_ROOT_NOPREFIX)) {
 		strcpy(name, cft->ss->name);
 		strcat(name, ".");
 	}
-- 
1.8.3.1

