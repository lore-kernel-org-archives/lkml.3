Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab3A1Ubf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 15:31:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961Ab3A1Ubb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 15:31:31 -0500
Date: Mon, 28 Jan 2013 14:31:20 -0600
From: Clark Williams <williams@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] sched: move scheduler sysctl bits into dedicated header
 file
Message-ID: <20130128143120.1b60bfb6@redhat.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/id=4zuSjm6tzpwtXDuKDIiy"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/id=4zuSjm6tzpwtXDuKDIiy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Move all the scheduler sysctl-related bits out of include/linux/sched.h
into a new file include/linux/sched_sysctl.h.

Signed-off-by: Clark Williams <williams@redhat.com>
---
 include/linux/sched.h        | 102 +-----------------------------------
 include/linux/sched_sysctl.h | 121 +++++++++++++++++++++++++++++++++++++++=
++++
 2 files changed, 122 insertions(+), 101 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 924e42a..12e689e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -51,6 +51,7 @@ struct sched_param {
 #include <linux/cred.h>
 #include <linux/llist.h>
 #include <linux/uidgid.h>
+#include <linux/sched_sysctl.h>
=20
 #include <asm/processor.h>
=20
@@ -304,19 +305,6 @@ static inline void lockup_detector_init(void)
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
@@ -338,23 +326,6 @@ extern int mutex_spin_on_owner(struct mutex *lock, str=
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
@@ -2034,77 +2005,6 @@ extern void wake_up_idle_cpu(int cpu);
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
-#ifdef CONFIG_SCHED_AUTOGROUP
-extern unsigned int sysctl_sched_autogroup_enabled;
-
-extern void sched_autogroup_create_attach(struct task_struct *p);
-extern void sched_autogroup_detach(struct task_struct *p);
-extern void sched_autogroup_fork(struct signal_struct *sig);
-extern void sched_autogroup_exit(struct signal_struct *sig);
-#ifdef CONFIG_PROC_FS
-extern void proc_sched_autogroup_show_task(struct task_struct *p, struct s=
eq_file *m);
-extern int proc_sched_autogroup_set_nice(struct task_struct *p, int nice);
-#endif
-#else
-static inline void sched_autogroup_create_attach(struct task_struct *p) { }
-static inline void sched_autogroup_detach(struct task_struct *p) { }
-static inline void sched_autogroup_fork(struct signal_struct *sig) { }
-static inline void sched_autogroup_exit(struct signal_struct *sig) { }
-#endif
-
-#ifdef CONFIG_CFS_BANDWIDTH
-extern unsigned int sysctl_sched_cfs_bandwidth_slice;
-#endif
-
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
 extern void rt_mutex_setprio(struct task_struct *p, int prio);
diff --git a/include/linux/sched_sysctl.h b/include/linux/sched_sysctl.h
new file mode 100644
index 0000000..912adab
--- /dev/null
+++ b/include/linux/sched_sysctl.h
@@ -0,0 +1,121 @@
+#ifndef _SCHED_SYSCTL_H
+#define _SCHED_SYSCTL_H
+
+
+/* provide a home for sysctl scheduler tuning knobs */
+
+/*
+ * default timeslice is 100 msecs (used only for SCHED_RR tasks).
+ * Timeslices get refilled after they expire.
+ */
+#define RR_TIMESLICE		(100 * HZ / 1000)
+
+/*
+ *  control realtime throttling:
+ *
+ *  /proc/sys/kernel/sched_rt_period_us
+ *  /proc/sys/kernel/sched_rt_runtime_us
+ */
+extern unsigned int sysctl_sched_rt_period;
+extern int sysctl_sched_rt_runtime;
+
+extern int sched_rt_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos);
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
+
+#ifdef CONFIG_CFS_BANDWIDTH
+extern unsigned int sysctl_sched_cfs_bandwidth_slice;
+#endif
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
+#ifdef CONFIG_SCHED_AUTOGROUP
+extern unsigned int sysctl_sched_autogroup_enabled;
+
+extern void sched_autogroup_create_attach(struct task_struct *p);
+extern void sched_autogroup_detach(struct task_struct *p);
+extern void sched_autogroup_fork(struct signal_struct *sig);
+extern void sched_autogroup_exit(struct signal_struct *sig);
+#ifdef CONFIG_PROC_FS
+extern void proc_sched_autogroup_show_task(struct task_struct *p, struct s=
eq_file *m);
+extern int proc_sched_autogroup_set_nice(struct task_struct *p, int nice);
+#endif
+#else
+static inline void sched_autogroup_create_attach(struct task_struct *p) { }
+static inline void sched_autogroup_detach(struct task_struct *p) { }
+static inline void sched_autogroup_fork(struct signal_struct *sig) { }
+static inline void sched_autogroup_exit(struct signal_struct *sig) { }
+#endif
+
+#endif /* _SCHED_SYSCTL_H */
--=20
1.7.11.7


--Sig_/id=4zuSjm6tzpwtXDuKDIiy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEG4BgACgkQHyuj/+TTEp2XuwCbBTDLpzj8dFgwNqqC2IKDlhlm
HEsAoL7DXcMRUY/QFEgWtkxm4KE3a4x4
=CpJK
-----END PGP SIGNATURE-----

--Sig_/id=4zuSjm6tzpwtXDuKDIiy--
