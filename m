Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935948Ab3DJNoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:44:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59355 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759688Ab3DJNoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:44:03 -0400
Date: Wed, 10 Apr 2013 06:43:45 -0700
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-d1712796a880bea0a44739941116001923f3275b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
In-Reply-To: <515536D5.2080401@huawei.com>
References: <515536D5.2080401@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/cpuacct: Clean up cpuacct.h
Git-Commit-ID: d1712796a880bea0a44739941116001923f3275b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 06:43:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1712796a880bea0a44739941116001923f3275b
Gitweb:     http://git.kernel.org/tip/d1712796a880bea0a44739941116001923f3275b
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Fri, 29 Mar 2013 14:38:13 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 10 Apr 2013 13:54:19 +0200

sched/cpuacct: Clean up cpuacct.h

Now most of the code in cpuacct.h can be moved to cpuacct.c

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/515536D5.2080401@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
index b2f79ad1..51cd76e 100644
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
