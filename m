Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab3HaN7y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 09:59:54 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:42317 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab3HaN7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 09:59:53 -0400
Date: Sat, 31 Aug 2013 09:59:49 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/9] cgroup: make for_each_subsys() useable under
 cgroup_root_mutex
Message-ID: <20130831135949.GB26539@htj.dyndns.org>
References: <1377723829-22814-1-git-send-email-tj@kernel.org>
 <1377723829-22814-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377723829-22814-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
Cc: kbuild test robot <fengguang.wu@intel.com>
---
 kernel/cgroup.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -93,6 +93,14 @@ static DEFINE_MUTEX(cgroup_root_mutex);
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
  * Generate an array of cgroup subsystem pointers. At boot time, this is
  * populated with the built in subsystems, and modular subsystems are
@@ -291,14 +299,15 @@ static int notify_on_release(const struc
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
@@ -4911,6 +4920,7 @@ int __init_or_module cgroup_load_subsys(
 	cgroup_init_cftsets(ss);
 
 	mutex_lock(&cgroup_mutex);
+	mutex_lock(&cgroup_root_mutex);
 	cgroup_subsys[ss->subsys_id] = ss;
 
 	/*
@@ -4966,10 +4976,12 @@ int __init_or_module cgroup_load_subsys(
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
@@ -4999,6 +5011,7 @@ void cgroup_unload_subsys(struct cgroup_
 	BUG_ON(ss->root != &cgroup_dummy_root);
 
 	mutex_lock(&cgroup_mutex);
+	mutex_lock(&cgroup_root_mutex);
 
 	offline_css(cgroup_css(cgroup_dummy_top, ss));
 
@@ -5037,6 +5050,7 @@ void cgroup_unload_subsys(struct cgroup_
 	ss->css_free(cgroup_css(cgroup_dummy_top, ss));
 	RCU_INIT_POINTER(cgroup_dummy_top->subsys[ss->subsys_id], NULL);
 
+	mutex_unlock(&cgroup_root_mutex);
 	mutex_unlock(&cgroup_mutex);
 }
 EXPORT_SYMBOL_GPL(cgroup_unload_subsys);
