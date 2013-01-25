Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab3AYVoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 16:44:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab3AYVoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 16:44:15 -0500
Date: Fri, 25 Jan 2013 15:43:53 -0600
From: Clark Williams <williams@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2] sched: add a tuning knob to allow changing RR
 tmeslice
Message-ID: <20130125154353.0d47d334@redhat.com>
In-Reply-To: <20130125183610.GA31022@gmail.com>
References: <20121108195113.2dd51d43@redhat.com>
	<20130124165955.GA9324@gmail.com>
	<20130124135427.1748d057@redhat.com>
	<20130125081916.GC25314@gmail.com>
	<20130125120256.52733b51@redhat.com>
	<20130125183610.GA31022@gmail.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CaIZ7uhGhfTg.1u3uuMhU=Y"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/CaIZ7uhGhfTg.1u3uuMhU=Y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Jan 2013 19:36:10 +0100
Ingo Molnar <mingo@kernel.org> wrote:

>=20
> * Clark Williams <williams@redhat.com> wrote:
>=20
> > > Shouldn't this be in kernel/sched/sched.h instead of the=20
> > > (already too large) linux/sched.h?
> >=20
> > I don't think that will work be cause kernel/sysctl.c needs=20
> > the externs and I doubt we want to include=20
> > kernel/sched/sched.h from there.
>=20
> Then at least introduce a new include/linux/sched_sysctl.h file=20
> please, and include it in sysctl.c and move this new knob there?
>=20
> Other scheduler related sysctl knobs can move there too later=20
> on, reducing the burden on sched.h.
>=20
> Thanks,
>=20
> 	Ingo


Like this?

commit 907d3684c01fcc5c6a985276f750d816f309651c
Author: Clark Williams <williams@redhat.com>
Date:   Fri Jan 25 14:43:05 2013 -0600

    [kernel] create include file for scheduler tuning knobs
   =20
    Create include/linux/sched_sysctl.h for scheduler tuning knob-related
    definitions, then move sysctl-related bits into it from
    include/linux/sched.h.
   =20
    Signed-off-by: Clark Williams <williams@redhat.com>

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5d0a7cf..c39e995 100644
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
@@ -1220,17 +1191,6 @@ struct sched_rt_entity {
 #endif
 };
=20
-/*
- * default timeslice is 100 msecs (used only for SCHED_RR tasks).
- * Timeslices get refilled after they expire.
- */
-#define RR_TIMESLICE		(100 * HZ / 1000)
-
-extern __read_mostly unsigned int sched_rr_timeslice;
-
-extern int sched_rr_handler(struct ctl_table *table, int write,
-		void __user *buffer, size_t *lenp,
-		loff_t *ppos);
 struct rcu_node;
=20
 enum perf_event_task_context {
@@ -2038,76 +1998,6 @@ extern void wake_up_idle_cpu(int cpu);
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
=20
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
diff --git a/include/linux/sched_sysctl.h b/include/linux/sched_sysctl.h
new file mode 100644
index 0000000..66e5faa
--- /dev/null
+++ b/include/linux/sched_sysctl.h
@@ -0,0 +1,133 @@
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
+ * allow user modification of global SCHED_RR timeslice
+ * through:
+ *
+ *    /proc/sys/kernel/sched_rr_timeslice_ms
+ */
+extern __read_mostly unsigned int sched_rr_timeslice;
+
+extern int sched_rr_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos);
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

--Sig_/CaIZ7uhGhfTg.1u3uuMhU=Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEC/JkACgkQHyuj/+TTEp1w9ACfZaJiyKpJqoC2Vms0W6XHAhqa
YD8AoJ/5XN4i7j+G/NxVxc7swrxLpd8+
=auNW
-----END PGP SIGNATURE-----

--Sig_/CaIZ7uhGhfTg.1u3uuMhU=Y--
