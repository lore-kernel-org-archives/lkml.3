Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab3LFU2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:28:05 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:49364 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab3LFU2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:28:00 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, vdavydov@parallels.com,
        Tejun Heo <tj@kernel.org>, kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH 2/7] cgroup: make for_each_subsys() useable under cgroup_root_mutex
Date: Fri,  6 Dec 2013 15:27:47 -0500
Message-Id: <1386361672-27791-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386361672-27791-1-git-send-email-tj@kernel.org>
References: <1386361672-27791-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to use for_each_subsys() in cgroupfs_root handling where only
cgroup_root_mutex is held.  The only way cgroup_subsys[] can change is
through module load/unload, make cgroup_[un]load_subsys() grab
cgroup_root_mutex too and update the lockdep annotation in
for_each_subsys() to allow either cgroup_mutex or cgroup_root_mutex.

* Lockdep annotation is moved from inner 'if' condition to outer 'for'
  init caluse.  There's no reason to execute the assertion every loop.

* Loop index @i is renamed to @ssid.  Indices iterating through subsys
  will be [re]named to @ssid gradually.

v2: cgroup_assert_mutex_or_root_locked() caused build failure if
    !CONFIG_LOCKEDP.  Conditionalize its definition.  The build failure
    was reported by kbuild test bot.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Li Zefan <lizefan@huawei.com>
Cc: kbuild test robot <fengguang.wu@intel.com>
---
 kernel/cgroup.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c22eecb..4a7fb40 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -98,6 +98,14 @@ static DEFINE_MUTEX(cgroup_root_mutex);
 			   lockdep_is_held(&cgroup_mutex),		\
 			   "cgroup_mutex or RCU read lock required");
 
+#ifdef CONFIG_LOCKDEP
+#define cgroup_assert_mutex_or_root_locked()				\
+	WARN_ON_ONCE(debug_locks && (!lockdep_is_held(&cgroup_mutex) &&	\
+				     !lockdep_is_held(&cgroup_root_mutex)))
+#else
+#define cgroup_assert_mutex_or_root_locked()	do { } while (0)
+#endif
+
 /*
  * cgroup destruction makes heavy use of work items and there can be a lot
  * of concurrent destructions.  Use a separate workqueue so that cgroup
@@ -237,14 +245,15 @@ static int notify_on_release(const struct cgroup *cgrp)
 /**
  * for_each_subsys - iterate all loaded cgroup subsystems
  * @ss: the iteration cursor
- * @i: the index of @ss, CGROUP_SUBSYS_COUNT after reaching the end
+ * @ssid: the index of @ss, CGROUP_SUBSYS_COUNT after reaching the end
  *
- * Should be called under cgroup_mutex.
+ * Iterates through all loaded subsystems.  Should be called under
+ * cgroup_mutex or cgroup_root_mutex.
  */
-#define for_each_subsys(ss, i)						\
-	for ((i) = 0; (i) < CGROUP_SUBSYS_COUNT; (i)++)			\
-		if (({ lockdep_assert_held(&cgroup_mutex);		\
-		       !((ss) = cgroup_subsys[i]); })) { }		\
+#define for_each_subsys(ss, ssid)					\
+	for (({ cgroup_assert_mutex_or_root_locked(); (ssid) = 0; });	\
+	     (ssid) < CGROUP_SUBSYS_COUNT; (ssid)++)			\
+		if (!((ss) = cgroup_subsys[(ssid)])) { }		\
 		else
 
 /**
@@ -4592,6 +4601,7 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
 	cgroup_init_cftsets(ss);
 
 	mutex_lock(&cgroup_mutex);
+	mutex_lock(&cgroup_root_mutex);
 	cgroup_subsys[ss->subsys_id] = ss;
 
 	/*
@@ -4641,10 +4651,12 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
 		goto err_unload;
 
 	/* success! */
+	mutex_unlock(&cgroup_root_mutex);
 	mutex_unlock(&cgroup_mutex);
 	return 0;
 
 err_unload:
+	mutex_unlock(&cgroup_root_mutex);
 	mutex_unlock(&cgroup_mutex);
 	/* @ss can't be mounted here as try_module_get() would fail */
 	cgroup_unload_subsys(ss);
@@ -4674,6 +4686,7 @@ void cgroup_unload_subsys(struct cgroup_subsys *ss)
 	BUG_ON(ss->root != &cgroup_dummy_root);
 
 	mutex_lock(&cgroup_mutex);
+	mutex_lock(&cgroup_root_mutex);
 
 	offline_css(cgroup_css(cgroup_dummy_top, ss));
 
@@ -4708,6 +4721,7 @@ void cgroup_unload_subsys(struct cgroup_subsys *ss)
 	ss->css_free(cgroup_css(cgroup_dummy_top, ss));
 	RCU_INIT_POINTER(cgroup_dummy_top->subsys[ss->subsys_id], NULL);
 
+	mutex_unlock(&cgroup_root_mutex);
 	mutex_unlock(&cgroup_mutex);
 }
 EXPORT_SYMBOL_GPL(cgroup_unload_subsys);
-- 
1.8.4.2

