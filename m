Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935867Ab3DJNiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:38:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59268 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab3DJNiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:38:03 -0400
Date: Wed, 10 Apr 2013 06:37:48 -0700
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-60fed7891d4115be0ed7ff9ce6851eda80533c64@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
In-Reply-To: <5155367B.2060506@huawei.com>
References: <5155367B.2060506@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Split cpuacct code out of sched.h
Git-Commit-ID: 60fed7891d4115be0ed7ff9ce6851eda80533c64
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 06:37:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60fed7891d4115be0ed7ff9ce6851eda80533c64
Gitweb:     http://git.kernel.org/tip/60fed7891d4115be0ed7ff9ce6851eda80533c64
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Fri, 29 Mar 2013 14:36:43 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 10 Apr 2013 13:54:16 +0200

sched: Split cpuacct code out of sched.h

Add cpuacct.h and let sched.h include it.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/5155367B.2060506@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/cpuacct.h | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h   | 48 +---------------------------------------------
 2 files changed, 53 insertions(+), 47 deletions(-)

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
index 3bd15a4..8116cf8 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -7,6 +7,7 @@
 #include <linux/stop_machine.h>
 
 #include "cpupri.h"
+#include "cpuacct.h"
 
 extern __read_mostly int scheduler_running;
 
@@ -950,14 +951,6 @@ static const u32 prio_to_wmult[40] = {
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
 #define ENQUEUE_WAKEUP		1
 #define ENQUEUE_HEAD		2
 #ifdef CONFIG_SMP
@@ -1054,45 +1047,6 @@ extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime
 
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
