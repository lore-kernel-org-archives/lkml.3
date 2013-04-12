Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab3DLXLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 19:11:18 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:60821 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab3DLXLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 19:11:11 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, glommer@parallels.com, vgoyal@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/4] move cgroupfs_root to include/linux/cgroup.h
Date: Fri, 12 Apr 2013 16:10:57 -0700
Message-Id: <1365808259-31073-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365808259-31073-1-git-send-email-tj@kernel.org>
References: <1365808259-31073-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While controllers shouldn't be accessing cgroupfs_root directly, it
being hidden inside kern/cgroup.c makes somethings pretty silly.  This
makes routing hierarchy-wide settings which need to be visible to
controllers cumbersome.

We're gonna add another hierarchy-wide setting which needs to be
accessed from controllers.  Move cgroupfs_root and its flags to the
header file so that we can access root settings with inline helpers.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/cgroup.c        | 57 --------------------------------------------------
 2 files changed, 57 insertions(+), 57 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 45aee0f..b21881e 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -19,6 +19,7 @@
 #include <linux/idr.h>
 #include <linux/workqueue.h>
 #include <linux/xattr.h>
+#include <linux/fs.h>
 
 #ifdef CONFIG_CGROUPS
 
@@ -238,6 +239,62 @@ struct cgroup {
 	struct simple_xattrs xattrs;
 };
 
+#define MAX_CGROUP_ROOT_NAMELEN 64
+
+/* cgroupfs_root->flags */
+enum {
+	CGRP_ROOT_NOPREFIX	= (1 << 1), /* mounted subsystems have no named prefix */
+	CGRP_ROOT_XATTR		= (1 << 2), /* supports extended attributes */
+};
+
+/*
+ * A cgroupfs_root represents the root of a cgroup hierarchy, and may be
+ * associated with a superblock to form an active hierarchy.  This is
+ * internal to cgroup core.  Don't access directly from controllers.
+ */
+struct cgroupfs_root {
+	struct super_block *sb;
+
+	/*
+	 * The bitmask of subsystems intended to be attached to this
+	 * hierarchy
+	 */
+	unsigned long subsys_mask;
+
+	/* Unique id for this hierarchy. */
+	int hierarchy_id;
+
+	/* The bitmask of subsystems currently attached to this hierarchy */
+	unsigned long actual_subsys_mask;
+
+	/* A list running through the attached subsystems */
+	struct list_head subsys_list;
+
+	/* The root cgroup for this hierarchy */
+	struct cgroup top_cgroup;
+
+	/* Tracks how many cgroups are currently defined in hierarchy.*/
+	int number_of_cgroups;
+
+	/* A list running through the active hierarchies */
+	struct list_head root_list;
+
+	/* All cgroups on this root, cgroup_mutex protected */
+	struct list_head allcg_list;
+
+	/* Hierarchy-specific flags */
+	unsigned long flags;
+
+	/* IDs for cgroups in this hierarchy */
+	struct ida cgroup_ida;
+
+	/* The path to use for release notifications. */
+	char release_agent_path[PATH_MAX];
+
+	/* The name for this hierarchy - may be empty */
+	char name[MAX_CGROUP_ROOT_NAMELEN];
+};
+
 /*
  * A css_set is a structure holding pointers to a set of
  * cgroup_subsys_state objects. This saves space in the task struct
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a372eaa..8848070 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -30,7 +30,6 @@
 #include <linux/cred.h>
 #include <linux/ctype.h>
 #include <linux/errno.h>
-#include <linux/fs.h>
 #include <linux/init_task.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
@@ -104,56 +103,6 @@ static struct cgroup_subsys *subsys[CGROUP_SUBSYS_COUNT] = {
 #include <linux/cgroup_subsys.h>
 };
 
-#define MAX_CGROUP_ROOT_NAMELEN 64
-
-/*
- * A cgroupfs_root represents the root of a cgroup hierarchy,
- * and may be associated with a superblock to form an active
- * hierarchy
- */
-struct cgroupfs_root {
-	struct super_block *sb;
-
-	/*
-	 * The bitmask of subsystems intended to be attached to this
-	 * hierarchy
-	 */
-	unsigned long subsys_mask;
-
-	/* Unique id for this hierarchy. */
-	int hierarchy_id;
-
-	/* The bitmask of subsystems currently attached to this hierarchy */
-	unsigned long actual_subsys_mask;
-
-	/* A list running through the attached subsystems */
-	struct list_head subsys_list;
-
-	/* The root cgroup for this hierarchy */
-	struct cgroup top_cgroup;
-
-	/* Tracks how many cgroups are currently defined in hierarchy.*/
-	int number_of_cgroups;
-
-	/* A list running through the active hierarchies */
-	struct list_head root_list;
-
-	/* All cgroups on this root, cgroup_mutex protected */
-	struct list_head allcg_list;
-
-	/* Hierarchy-specific flags */
-	unsigned long flags;
-
-	/* IDs for cgroups in this hierarchy */
-	struct ida cgroup_ida;
-
-	/* The path to use for release notifications. */
-	char release_agent_path[PATH_MAX];
-
-	/* The name for this hierarchy - may be empty */
-	char name[MAX_CGROUP_ROOT_NAMELEN];
-};
-
 /*
  * The "rootnode" hierarchy is the "dummy hierarchy", reserved for the
  * subsystems that are otherwise unattached - it never has more than a
@@ -296,12 +245,6 @@ bool cgroup_is_descendant(struct cgroup *cgrp, struct cgroup *ancestor)
 }
 EXPORT_SYMBOL_GPL(cgroup_is_descendant);
 
-/* cgroupfs_root->flags */
-enum {
-	CGRP_ROOT_NOPREFIX	= (1 << 1), /* mounted subsystems have no named prefix */
-	CGRP_ROOT_XATTR		= (1 << 2), /* supports extended attributes */
-};
-
 static int cgroup_is_releasable(const struct cgroup *cgrp)
 {
 	const int bits =
-- 
1.8.1.4

