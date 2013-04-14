Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab3DNShO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 14:37:14 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:51298 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab3DNShL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 14:37:11 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, kay@vrfy.org, greg@kroah.com,
        lennart@poettering.net, daniel@zonque.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/4] cgroup: drop hierarchy_id_lock
Date: Sun, 14 Apr 2013 11:36:57 -0700
Message-Id: <1365964619-14762-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365964619-14762-1-git-send-email-tj@kernel.org>
References: <1365964619-14762-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that hierarchy_id alloc / free are protected by the cgroup
mutexes, there's no need for this separate lock.  Drop it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 823cb56..e15bdb7 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -237,9 +237,13 @@ struct cgroup_event {
 static LIST_HEAD(roots);
 static int root_count;
 
+/*
+ * Hierarchy ID allocation and mapping.  It follows the same exclusion
+ * rules as other root ops - both cgroup_mutex and cgroup_root_mutex for
+ * writes, either for reads.
+ */
 static DEFINE_IDA(hierarchy_ida);
 static int next_hierarchy_id;
-static DEFINE_SPINLOCK(hierarchy_id_lock);
 
 /* dummytop is a shorthand for the dummy hierarchy's top cgroup */
 #define dummytop (&rootnode.top_cgroup)
@@ -1456,10 +1460,12 @@ static int cgroup_init_root_id(struct cgroupfs_root *root)
 {
 	int ret;
 
+	lockdep_assert_held(&cgroup_mutex);
+	lockdep_assert_held(&cgroup_root_mutex);
+
 	do {
 		if (!ida_pre_get(&hierarchy_ida, GFP_KERNEL))
 			return -ENOMEM;
-		spin_lock(&hierarchy_id_lock);
 		/* Try to allocate the next unused ID */
 		ret = ida_get_new_above(&hierarchy_ida, next_hierarchy_id,
 					&root->hierarchy_id);
@@ -1472,18 +1478,17 @@ static int cgroup_init_root_id(struct cgroupfs_root *root)
 			/* Can only get here if the 31-bit IDR is full ... */
 			BUG_ON(ret);
 		}
-		spin_unlock(&hierarchy_id_lock);
 	} while (ret);
 	return 0;
 }
 
 static void cgroup_exit_root_id(struct cgroupfs_root *root)
 {
+	lockdep_assert_held(&cgroup_mutex);
+	lockdep_assert_held(&cgroup_root_mutex);
+
 	if (root->hierarchy_id) {
-		spin_lock(&hierarchy_id_lock);
 		ida_remove(&hierarchy_ida, root->hierarchy_id);
-		spin_unlock(&hierarchy_id_lock);
-
 		root->hierarchy_id = 0;
 	}
 }
@@ -4656,8 +4661,14 @@ int __init cgroup_init(void)
 	hash_add(css_set_table, &init_css_set.hlist, key);
 
 	/* allocate id for the dummy hierarchy */
+	mutex_lock(&cgroup_mutex);
+	mutex_lock(&cgroup_root_mutex);
+
 	BUG_ON(cgroup_init_root_id(&rootnode));
 
+	mutex_unlock(&cgroup_root_mutex);
+	mutex_unlock(&cgroup_mutex);
+
 	cgroup_kobj = kobject_create_and_add("cgroup", fs_kobj);
 	if (!cgroup_kobj) {
 		err = -ENOMEM;
-- 
1.8.1.4

