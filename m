Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab3C1EOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 00:14:06 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:28671 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab3C1EOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 00:14:04 -0400
Message-ID: <5153C316.1000703@huawei.com>
Date: Thu, 28 Mar 2013 12:12:06 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] sched: Split cpuacct out of sched.h
References: <5153C2D6.7050103@huawei.com>
In-Reply-To: <5153C2D6.7050103@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cpuacct.h and let sched.h include it.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/sched/cpuacct.h | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h   | 49 +----------------------------------------------
 2 files changed, 53 insertions(+), 48 deletions(-)
 create mode 100644 kernel/sched/cpuacct.h

diff --git a/kernel/sched/cpuacct.h b/kernel/sched/cpuacct.h
new file mode 100644
index 0000000..a7f3d4a
--- /dev/null
+++ b/kernel/sched/cpuacct.h
@@ -0,0 +1,52 @@
+/* Time spent by the tasks of the cpu accounting group executing in ... */
+enum cpuacct_stat_index {
+	CPUACCT_STAT_USER,	/* ... user mode */
+	CPUACCT_STAT_SYSTEM,	/* ... kernel mode */
+
+	CPUACCT_STAT_NSTATS,
+};
+
+#ifdef CONFIG_CGROUP_CPUACCT
+
+#include <linux/cgroup.h>
+/* track cpu usage of a group of tasks and its child groups */
+struct cpuacct {
+	struct cgroup_subsys_state css;
+	/* cpuusage holds pointer to a u64-type object on every cpu */
+	u64 __percpu *cpuusage;
+	struct kernel_cpustat __percpu *cpustat;
+};
+
+extern struct cgroup_subsys cpuacct_subsys;
+extern struct cpuacct root_cpuacct;
+
+/* return cpu accounting group corresponding to this container */
+static inline struct cpuacct *cgroup_ca(struct cgroup *cgrp)
+{
+	return container_of(cgroup_subsys_state(cgrp, cpuacct_subsys_id),
+			    struct cpuacct, css);
+}
+
+/* return cpu accounting group to which this task belongs */
+static inline struct cpuacct *task_ca(struct task_struct *tsk)
+{
+	return container_of(task_subsys_state(tsk, cpuacct_subsys_id),
+			    struct cpuacct, css);
+}
+
+static inline struct cpuacct *parent_ca(struct cpuacct *ca)
+{
+	if (!ca || !ca->css.cgroup->parent)
+		return NULL;
+	return cgroup_ca(ca->css.cgroup->parent);
+}
+
+extern void cpuacct_charge(struct task_struct *tsk, u64 cputime);
+
+#else
+
+static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime)
+{
+}
+
+#endif
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index cc03cfd..5bfcaba 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -7,6 +7,7 @@
 #include <linux/stop_machine.h>
 
 #include "cpupri.h"
+#include "cpuacct.h"
 
 extern __read_mostly int scheduler_running;
 
@@ -856,15 +857,6 @@ static const u32 prio_to_wmult[40] = {
  /*  15 */ 119304647, 148102320, 186737708, 238609294, 286331153,
 };
 
-/* Time spent by the tasks of the cpu accounting group executing in ... */
-enum cpuacct_stat_index {
-	CPUACCT_STAT_USER,	/* ... user mode */
-	CPUACCT_STAT_SYSTEM,	/* ... kernel mode */
-
-	CPUACCT_STAT_NSTATS,
-};
-
-
 #define sched_class_highest (&stop_sched_class)
 #define for_each_class(class) \
    for (class = sched_class_highest; class; class = class->next)
@@ -904,45 +896,6 @@ extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime
 
 extern void update_idle_cpu_load(struct rq *this_rq);
 
-#ifdef CONFIG_CGROUP_CPUACCT
-#include <linux/cgroup.h>
-/* track cpu usage of a group of tasks and its child groups */
-struct cpuacct {
-	struct cgroup_subsys_state css;
-	/* cpuusage holds pointer to a u64-type object on every cpu */
-	u64 __percpu *cpuusage;
-	struct kernel_cpustat __percpu *cpustat;
-};
-
-extern struct cgroup_subsys cpuacct_subsys;
-extern struct cpuacct root_cpuacct;
-
-/* return cpu accounting group corresponding to this container */
-static inline struct cpuacct *cgroup_ca(struct cgroup *cgrp)
-{
-	return container_of(cgroup_subsys_state(cgrp, cpuacct_subsys_id),
-			    struct cpuacct, css);
-}
-
-/* return cpu accounting group to which this task belongs */
-static inline struct cpuacct *task_ca(struct task_struct *tsk)
-{
-	return container_of(task_subsys_state(tsk, cpuacct_subsys_id),
-			    struct cpuacct, css);
-}
-
-static inline struct cpuacct *parent_ca(struct cpuacct *ca)
-{
-	if (!ca || !ca->css.cgroup->parent)
-		return NULL;
-	return cgroup_ca(ca->css.cgroup->parent);
-}
-
-extern void cpuacct_charge(struct task_struct *tsk, u64 cputime);
-#else
-static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
-#endif
-
 #ifdef CONFIG_PARAVIRT
 static inline u64 steal_ticks(u64 steal)
 {
-- 
1.8.0.2
