Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab3CAHGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 02:06:45 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:13336 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab3CAHGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 02:06:44 -0500
Message-ID: <5130537C.5010608@huawei.com>
Date: Fri, 1 Mar 2013 15:06:36 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 2/2] cgroup: avoid accessing modular cgroup subsys structure
 without locking
References: <5130535F.7060201@huawei.com>
In-Reply-To: <5130535F.7060201@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

subsys[i] is set to NULL in cgroup_unload_subsys() at modular unload,
and that's protected by cgroup_mutex, and then the memory *subsys[i]
resides will be freed.

So this is unsafe without any locking:

  if (!ss || ss->module)
  ...

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h | 11 +++++++++--
 kernel/cgroup.c        | 32 ++++++++++++++++++--------------
 2 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 75c6ec1..3ac6bb0 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -46,12 +46,19 @@ extern const struct file_operations proc_cgroup_operations;
 
 /* Define the enumeration of all builtin cgroup subsystems */
 #define SUBSYS(_x) _x ## _subsys_id,
-#define IS_SUBSYS_ENABLED(option) IS_ENABLED(option)
 enum cgroup_subsys_id {
+#define IS_SUBSYS_ENABLED(option) IS_BUILTIN(option)
 #include <linux/cgroup_subsys.h>
+#undef IS_SUBSYS_ENABLED
+	CGROUP_BUILTIN_SUBSYS_COUNT,
+
+	__CGROUP_SUBSYS_TEMP_PLACEHOLDER = CGROUP_BUILTIN_SUBSYS_COUNT - 1,
+
+#define IS_SUBSYS_ENABLED(option) IS_MODULE(option)
+#include <linux/cgroup_subsys.h>
+#undef IS_SUBSYS_ENABLED
 	CGROUP_SUBSYS_COUNT,
 };
-#undef IS_SUBSYS_ENABLED
 #undef SUBSYS
 
 /* Per-subsystem/per-cgroup state maintained by the system. */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f4554cc..29273db 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4944,17 +4944,17 @@ void cgroup_post_fork(struct task_struct *child)
 	 * and addition to css_set.
 	 */
 	if (need_forkexit_callback) {
-		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
+		/*
+		 * fork/exit callbacks are supported only for builtin
+		 * subsystems, and the builtin section of the subsys
+		 * array is immutable, so we don't need to lock the
+		 * subsys array here. On the other hand, modular section
+		 * of the array can be freed at module unload, so we
+		 * can't touch that.
+		 */
+		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
 			struct cgroup_subsys *ss = subsys[i];
 
-			/*
-			 * fork/exit callbacks are supported only for
-			 * builtin subsystems and we don't need further
-			 * synchronization as they never go away.
-			 */
-			if (!ss || ss->module)
-				continue;
-
 			if (ss->fork)
 				ss->fork(child);
 		}
@@ -5019,13 +5019,17 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 	tsk->cgroups = &init_css_set;
 
 	if (run_callbacks && need_forkexit_callback) {
-		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
+		/*
+		 * fork/exit callbacks are supported only for builtin
+		 * subsystems, and the builtin section of the subsys
+		 * array is immutable, so we don't need to lock the
+		 * subsys array here. On the other hand, modular section
+		 * of the array can be freed at module unload, so we
+		 * can't touch that.
+		 */
+		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
 			struct cgroup_subsys *ss = subsys[i];
 
-			/* modular subsystems can't use callbacks */
-			if (!ss || ss->module)
-				continue;
-
 			if (ss->exit) {
 				struct cgroup *old_cgrp =
 					rcu_dereference_raw(cg->subsys[i])->cgroup;
-- 
1.8.0.2

