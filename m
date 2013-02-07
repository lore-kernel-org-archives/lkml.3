Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab3BGPrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:47:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057Ab3BGPrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:47:15 -0500
Date: Thu, 7 Feb 2013 09:46:59 -0600
From: Clark Williams <williams@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] sched: move sched.h sysctl bits into separate header
Message-ID: <20130207094659.06dced96@riff.lan>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PQo=aL_tk07NCk7A.LmahrI"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/PQo=aL_tk07NCk7A.LmahrI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Move the sysctl-related bits from include/linux/sched.h into
a new file: include/linux/sched/sysctl.h. Then update source
files requiring access to those bits by including the new
header file.

Signed-off-by: Clark Williams <williams@redhat.com>
---
 block/blk-exec.c             |  1 +
 include/linux/sched.h        | 91 -----------------------------------------
 include/linux/sched/sysctl.h | 97 ++++++++++++++++++++++++++++++++++++++++=
++++
 init/init_task.c             |  1 +
 kernel/hrtimer.c             |  1 +
 kernel/sched/sched.h         |  1 +
 kernel/sysctl.c              |  1 +
 kernel/timer.c               |  1 +
 mm/mmap.c                    |  1 +
 mm/mremap.c                  |  1 +
 10 files changed, 105 insertions(+), 91 deletions(-)
 create mode 100644 include/linux/sched/sysctl.h

diff --git a/block/blk-exec.c b/block/blk-exec.c
index 74638ec..c88202f 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -5,6 +5,7 @@
 #include <linux/module.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
+#include <linux/sched/sysctl.h>
=20
 #include "blk.h"
=20
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 924e42a..ab8a7c8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -304,19 +304,6 @@ static inline void lockup_detector_init(void)
 }
 #endif
=20
-#ifdef CONFIG_DETECT_HUNG_TASK
-extern unsigned int  sysctl_hung_task_panic;
-extern unsigned long sysctl_hung_task_check_count;
-extern unsigned long sysctl_hung_task_timeout_secs;
-extern unsigned long sysctl_hung_task_warnings;
-extern int proc_dohung_task_timeout_secs(struct ctl_table *table, int writ=
e,
-					 void __user *buffer,
-					 size_t *lenp, loff_t *ppos);
-#else
-/* Avoid need for ifdefs elsewhere in the code */
-enum { sysctl_hung_task_timeout_secs =3D 0 };
-#endif
-
 /* Attach to any functions which should be ignored in wchan output. */
 #define __sched		__attribute__((__section__(".sched.text")))
=20
@@ -338,23 +325,6 @@ extern int mutex_spin_on_owner(struct mutex *lock, str=
uct task_struct *owner);
 struct nsproxy;
 struct user_namespace;
=20
-/*
- * Default maximum number of active map areas, this limits the number of v=
mas
- * per mm struct. Users can overwrite this number by sysctl but there is a
- * problem.
- *
- * When a program's coredump is generated as ELF format, a section is crea=
ted
- * per a vma. In ELF, the number of sections is represented in unsigned sh=
ort.
- * This means the number of sections should be smaller than 65535 at cored=
ump.
- * Because the kernel adds some informative sections to a image of program=
 at
- * generating coredump, we need some margin. The number of extra sections =
is
- * 1-3 now and depends on arch. We use "5" as safe margin, here.
- */
-#define MAPCOUNT_ELF_CORE_MARGIN	(5)
-#define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
-
-extern int sysctl_max_map_count;
-
 #include <linux/aio.h>
=20
 #ifdef CONFIG_MMU
@@ -1221,12 +1191,6 @@ struct sched_rt_entity {
 #endif
 };
=20
-/*
- * default timeslice is 100 msecs (used only for SCHED_RR tasks).
- * Timeslices get refilled after they expire.
- */
-#define RR_TIMESLICE		(100 * HZ / 1000)
-
 struct rcu_node;
=20
 enum perf_event_task_context {
@@ -2034,58 +1998,7 @@ extern void wake_up_idle_cpu(int cpu);
 static inline void wake_up_idle_cpu(int cpu) { }
 #endif
=20
-extern unsigned int sysctl_sched_latency;
-extern unsigned int sysctl_sched_min_granularity;
-extern unsigned int sysctl_sched_wakeup_granularity;
-extern unsigned int sysctl_sched_child_runs_first;
-
-enum sched_tunable_scaling {
-	SCHED_TUNABLESCALING_NONE,
-	SCHED_TUNABLESCALING_LOG,
-	SCHED_TUNABLESCALING_LINEAR,
-	SCHED_TUNABLESCALING_END,
-};
-extern enum sched_tunable_scaling sysctl_sched_tunable_scaling;
-
-extern unsigned int sysctl_numa_balancing_scan_delay;
-extern unsigned int sysctl_numa_balancing_scan_period_min;
-extern unsigned int sysctl_numa_balancing_scan_period_max;
-extern unsigned int sysctl_numa_balancing_scan_period_reset;
-extern unsigned int sysctl_numa_balancing_scan_size;
-extern unsigned int sysctl_numa_balancing_settle_count;
-
-#ifdef CONFIG_SCHED_DEBUG
-extern unsigned int sysctl_sched_migration_cost;
-extern unsigned int sysctl_sched_nr_migrate;
-extern unsigned int sysctl_sched_time_avg;
-extern unsigned int sysctl_timer_migration;
-extern unsigned int sysctl_sched_shares_window;
-
-int sched_proc_update_handler(struct ctl_table *table, int write,
-		void __user *buffer, size_t *length,
-		loff_t *ppos);
-#endif
-#ifdef CONFIG_SCHED_DEBUG
-static inline unsigned int get_sysctl_timer_migration(void)
-{
-	return sysctl_timer_migration;
-}
-#else
-static inline unsigned int get_sysctl_timer_migration(void)
-{
-	return 1;
-}
-#endif
-extern unsigned int sysctl_sched_rt_period;
-extern int sysctl_sched_rt_runtime;
-
-int sched_rt_handler(struct ctl_table *table, int write,
-		void __user *buffer, size_t *lenp,
-		loff_t *ppos);
-
 #ifdef CONFIG_SCHED_AUTOGROUP
-extern unsigned int sysctl_sched_autogroup_enabled;
-
 extern void sched_autogroup_create_attach(struct task_struct *p);
 extern void sched_autogroup_detach(struct task_struct *p);
 extern void sched_autogroup_fork(struct signal_struct *sig);
@@ -2101,10 +2014,6 @@ static inline void sched_autogroup_fork(struct signa=
l_struct *sig) { }
 static inline void sched_autogroup_exit(struct signal_struct *sig) { }
 #endif
=20
-#ifdef CONFIG_CFS_BANDWIDTH
-extern unsigned int sysctl_sched_cfs_bandwidth_slice;
-#endif
-
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
 extern void rt_mutex_setprio(struct task_struct *p, int prio);
diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
new file mode 100644
index 0000000..bac914e
--- /dev/null
+++ b/include/linux/sched/sysctl.h
@@ -0,0 +1,97 @@
+#ifndef _SCHED_SYSCTL_H
+#define _SCHED_SYSCTL_H
+
+#ifdef CONFIG_DETECT_HUNG_TASK
+extern unsigned int  sysctl_hung_task_panic;
+extern unsigned long sysctl_hung_task_check_count;
+extern unsigned long sysctl_hung_task_timeout_secs;
+extern unsigned long sysctl_hung_task_warnings;
+extern int proc_dohung_task_timeout_secs(struct ctl_table *table, int writ=
e,
+					 void __user *buffer,
+					 size_t *lenp, loff_t *ppos);
+#else
+/* Avoid need for ifdefs elsewhere in the code */
+enum { sysctl_hung_task_timeout_secs =3D 0 };
+#endif
+
+/*
+ * Default maximum number of active map areas, this limits the number of v=
mas
+ * per mm struct. Users can overwrite this number by sysctl but there is a
+ * problem.
+ *
+ * When a program's coredump is generated as ELF format, a section is crea=
ted
+ * per a vma. In ELF, the number of sections is represented in unsigned sh=
ort.
+ * This means the number of sections should be smaller than 65535 at cored=
ump.
+ * Because the kernel adds some informative sections to a image of program=
 at
+ * generating coredump, we need some margin. The number of extra sections =
is
+ * 1-3 now and depends on arch. We use "5" as safe margin, here.
+ */
+#define MAPCOUNT_ELF_CORE_MARGIN	(5)
+#define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
+
+extern int sysctl_max_map_count;
+
+extern unsigned int sysctl_sched_latency;
+extern unsigned int sysctl_sched_min_granularity;
+extern unsigned int sysctl_sched_wakeup_granularity;
+extern unsigned int sysctl_sched_child_runs_first;
+
+enum sched_tunable_scaling {
+	SCHED_TUNABLESCALING_NONE,
+	SCHED_TUNABLESCALING_LOG,
+	SCHED_TUNABLESCALING_LINEAR,
+	SCHED_TUNABLESCALING_END,
+};
+extern enum sched_tunable_scaling sysctl_sched_tunable_scaling;
+
+extern unsigned int sysctl_numa_balancing_scan_delay;
+extern unsigned int sysctl_numa_balancing_scan_period_min;
+extern unsigned int sysctl_numa_balancing_scan_period_max;
+extern unsigned int sysctl_numa_balancing_scan_period_reset;
+extern unsigned int sysctl_numa_balancing_scan_size;
+extern unsigned int sysctl_numa_balancing_settle_count;
+
+#ifdef CONFIG_SCHED_DEBUG
+extern unsigned int sysctl_sched_migration_cost;
+extern unsigned int sysctl_sched_nr_migrate;
+extern unsigned int sysctl_sched_time_avg;
+extern unsigned int sysctl_timer_migration;
+extern unsigned int sysctl_sched_shares_window;
+
+int sched_proc_update_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *length,
+		loff_t *ppos);
+#endif
+#ifdef CONFIG_SCHED_DEBUG
+static inline unsigned int get_sysctl_timer_migration(void)
+{
+	return sysctl_timer_migration;
+}
+#else
+static inline unsigned int get_sysctl_timer_migration(void)
+{
+	return 1;
+}
+#endif
+extern unsigned int sysctl_sched_rt_period;
+extern int sysctl_sched_rt_runtime;
+
+#ifdef CONFIG_CFS_BANDWIDTH
+extern unsigned int sysctl_sched_cfs_bandwidth_slice;
+#endif
+
+#ifdef CONFIG_SCHED_AUTOGROUP
+extern unsigned int sysctl_sched_autogroup_enabled;
+#endif
+
+/*
+ * default timeslice is 100 msecs (used only for SCHED_RR tasks).
+ * Timeslices get refilled after they expire.
+ */
+#define RR_TIMESLICE		(100 * HZ / 1000)
+
+int sched_rt_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos);
+
+#endif /* _SCHED_SYSCTL_H */
diff --git a/init/init_task.c b/init/init_task.c
index 8b2f399..a031ad1 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -2,6 +2,7 @@
 #include <linux/export.h>
 #include <linux/mqueue.h>
 #include <linux/sched.h>
+#include <linux/sched/sysctl.h>
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 6db7a5e..8a9aa59 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -44,6 +44,7 @@
 #include <linux/err.h>
 #include <linux/debugobjects.h>
 #include <linux/sched.h>
+#include <linux/sched/sysctl.h>
 #include <linux/timer.h>
=20
 #include <asm/uaccess.h>
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fc88644..ed8de30 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1,5 +1,6 @@
=20
 #include <linux/sched.h>
+#include <linux/sched/sysctl.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/stop_machine.h>
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c88878d..7357e23 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -61,6 +61,7 @@
 #include <linux/kmod.h>
 #include <linux/capability.h>
 #include <linux/binfmts.h>
+#include <linux/sched/sysctl.h>
=20
 #include <asm/uaccess.h>
 #include <asm/processor.h>
diff --git a/kernel/timer.c b/kernel/timer.c
index 367d008..3e13baf 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -39,6 +39,7 @@
 #include <linux/kallsyms.h>
 #include <linux/irq_work.h>
 #include <linux/sched.h>
+#include <linux/sched/sysctl.h>
 #include <linux/slab.h>
=20
 #include <asm/uaccess.h>
diff --git a/mm/mmap.c b/mm/mmap.c
index 35730ee..5dee4a0 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -32,6 +32,7 @@
 #include <linux/khugepaged.h>
 #include <linux/uprobes.h>
 #include <linux/rbtree_augmented.h>
+#include <linux/sched/sysctl.h>
=20
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
diff --git a/mm/mremap.c b/mm/mremap.c
index e1031e1..f9766f4 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -19,6 +19,7 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/mmu_notifier.h>
+#include <linux/sched/sysctl.h>
=20
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
--=20
1.8.1


--Sig_/PQo=aL_tk07NCk7A.LmahrI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlETzHMACgkQHyuj/+TTEp0E9ACfdLsqJH9z/KOV/eU+HHbHilta
vPwAoIwFk2zH+X5+tiM0hsu7VCFY/Uiq
=V8s8
-----END PGP SIGNATURE-----

--Sig_/PQo=aL_tk07NCk7A.LmahrI--
