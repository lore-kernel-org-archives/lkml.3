Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab3C2Gjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 02:39:47 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:62982 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab3C2Gjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 02:39:45 -0400
Message-ID: <515536D5.2080401@huawei.com>
Date: Fri, 29 Mar 2013 14:38:13 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 7/7] cpuacct: Clean up cpuacct.h
References: <5155365F.1010203@huawei.com>
In-Reply-To: <5155365F.1010203@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now most of the code in cpuacct.h can be moved to cpuacct.c

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/sched/cpuacct.c | 44 +++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched/cpuacct.h | 46 ----------------------------------------------
 2 files changed, 43 insertions(+), 47 deletions(-)

diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 071ae8d..9305fd2 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -16,7 +16,49 @@
  * (balbir@in.ibm.com).
  */
 
-struct cpuacct root_cpuacct;
+/* Time spent by the tasks of the cpu accounting group executing in ... */
+enum cpuacct_stat_index {
+	CPUACCT_STAT_USER,	/* ... user mode */
+	CPUACCT_STAT_SYSTEM,	/* ... kernel mode */
+
+	CPUACCT_STAT_NSTATS,
+};
+
+/* track cpu usage of a group of tasks and its child groups */
+struct cpuacct {
+	struct cgroup_subsys_state css;
+	/* cpuusage holds pointer to a u64-type object on every cpu */
+	u64 __percpu *cpuusage;
+	struct kernel_cpustat __percpu *cpustat;
+};
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
+static inline struct cpuacct *__parent_ca(struct cpuacct *ca)
+{
+	return cgroup_ca(ca->css.cgroup->parent);
+}
+
+static inline struct cpuacct *parent_ca(struct cpuacct *ca)
+{
+	if (!ca->css.cgroup->parent)
+		return NULL;
+	return cgroup_ca(ca->css.cgroup->parent);
+}
+
+static struct cpuacct root_cpuacct;
 
 /* create a new cpu accounting group */
 static struct cgroup_subsys_state *cpuacct_css_alloc(struct cgroup *cgrp)
diff --git a/kernel/sched/cpuacct.h b/kernel/sched/cpuacct.h
index b2f79ad..51cd76e 100644
--- a/kernel/sched/cpuacct.h
+++ b/kernel/sched/cpuacct.h
@@ -1,51 +1,5 @@
-/* Time spent by the tasks of the cpu accounting group executing in ... */
-enum cpuacct_stat_index {
-	CPUACCT_STAT_USER,	/* ... user mode */
-	CPUACCT_STAT_SYSTEM,	/* ... kernel mode */
-
-	CPUACCT_STAT_NSTATS,
-};
-
 #ifdef CONFIG_CGROUP_CPUACCT
 
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
-static inline struct cpuacct *__parent_ca(struct cpuacct *ca)
-{
-	return cgroup_ca(ca->css.cgroup->parent);
-}
-
-static inline struct cpuacct *parent_ca(struct cpuacct *ca)
-{
-	if (!ca->css.cgroup->parent)
-		return NULL;
-	return cgroup_ca(ca->css.cgroup->parent);
-}
-
 extern void cpuacct_init(void);
 extern void cpuacct_charge(struct task_struct *tsk, u64 cputime);
 extern void cpuacct_account_field(struct task_struct *p, int index, u64 val);
-- 
1.8.0.2
