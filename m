Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbaGBNPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:15:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:60760 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbaGBNPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:15:15 -0400
Date: Wed, 2 Jul 2014 15:15:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@linaro.org>,
        Paul Turner <pjt@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: select 'idle' cfs_rq per task-group to prevent
 tg-internal imbalance
Message-ID: <20140702131507.GM3588@twins.programming.kicks-ass.net>
References: <53A11A89.5000602@linux.vnet.ibm.com>
 <20140623094251.GS19860@laptop.programming.kicks-ass.net>
 <53A8F1DE.2060908@linux.vnet.ibm.com>
 <20140701082020.GL6758@twins.programming.kicks-ass.net>
 <53B273A2.5050500@linux.vnet.ibm.com>
 <20140701085658.GM6758@twins.programming.kicks-ass.net>
 <53B372C6.5000107@linux.vnet.ibm.com>
 <20140702124918.GE19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3xQkynibq3FKlJyM"
Content-Disposition: inline
In-Reply-To: <20140702124918.GE19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3xQkynibq3FKlJyM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 02, 2014 at 02:49:18PM +0200, Peter Zijlstra wrote:
> Clearly I need to go take out all these things because people don't seem
> to know this and SCHED_DEBUG isn't a big enough hint. Tedious.

Maybe this would be enough clue?

---
 include/linux/kernel.h       |  1 +
 include/linux/sched/sysctl.h |  6 +++++
 kernel/panic.c               |  2 ++
 kernel/sched/core.c          | 59 +++++++++++++++++++++++++++++++++++-----=
----
 kernel/sched/fair.c          |  3 +++
 kernel/sched/sched.h         |  2 ++
 kernel/sysctl.c              | 18 +++++++-------
 7 files changed, 70 insertions(+), 21 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 4c52907a6d8b..e2dd5ca9e6bf 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -470,6 +470,7 @@ extern enum system_states {
 #define TAINT_FIRMWARE_WORKAROUND	11
 #define TAINT_OOT_MODULE		12
 #define TAINT_UNSIGNED_MODULE		13
+#define TAINT_DEBUG			14
=20
 extern const char hex_asc[];
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index 596a0e007c62..9d8f04bc555d 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -60,6 +60,12 @@ extern unsigned int sysctl_sched_time_avg;
 extern unsigned int sysctl_timer_migration;
 extern unsigned int sysctl_sched_shares_window;
=20
+int sched_debug_proc_dointvec_minmax(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp, loff_t *ppos);
+
+int sched_debug_proc_doulongvec_minmax(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp, loff_t *ppos);
+
 int sched_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *length,
 		loff_t *ppos);
diff --git a/kernel/panic.c b/kernel/panic.c
index 62e16cef9cc2..e407bf59546c 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -224,6 +224,7 @@ static const struct tnt tnts[] =3D {
 	{ TAINT_FIRMWARE_WORKAROUND,	'I', ' ' },
 	{ TAINT_OOT_MODULE,		'O', ' ' },
 	{ TAINT_UNSIGNED_MODULE,	'E', ' ' },
+	{ TAINT_DEBUG,			'G', ' ' },
 };
=20
 /**
@@ -243,6 +244,7 @@ static const struct tnt tnts[] =3D {
  *  'I' - Working around severe firmware bug.
  *  'O' - Out-of-tree module has been loaded.
  *  'E' - Unsigned module has been loaded.
+ *  'G' - The user fiddled with nonstandard settings.
  *
  *	The string is overwritten by the next call to print_tainted().
  */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f11515cf070b..851f6bf6abea 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -159,6 +159,36 @@ const_debug unsigned int sysctl_sched_features =3D
 #undef SCHED_FEAT
=20
 #ifdef CONFIG_SCHED_DEBUG
+void sched_debug_taint(void)
+{
+	static bool once;
+
+	if (once)
+		return;
+
+	once =3D true;
+	add_taint(TAINT_DEBUG, true);
+	printk(KERN_WARN "Tained kernel 'G' -- poking at debug settings.\n");
+}
+
+int sched_debug_proc_dointvec_minmax(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	if (write)
+		sched_debug_taint();
+
+	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+}
+
+int sched_debug_proc_doulongvec_minmax(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	if (write)
+		sched_debug_taint();
+
+	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
+}
+
 #define SCHED_FEAT(name, enabled)	\
 	#name ,
=20
@@ -246,6 +276,8 @@ sched_feat_write(struct file *filp, const char __user *=
ubuf,
 	char *cmp;
 	int i;
=20
+	sched_debug_taint();
+
 	if (cnt > 63)
 		cnt =3D 63;
=20
@@ -1855,6 +1887,9 @@ int sysctl_numa_balancing(struct ctl_table *table, in=
t write,
 	int err;
 	int state =3D numabalancing_enabled;
=20
+	if (write)
+		sched_debug_taint();
+
 	if (write && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
=20
@@ -4956,31 +4991,31 @@ sd_alloc_ctl_domain_table(struct sched_domain *sd)
 		return NULL;
=20
 	set_table_entry(&table[0], "min_interval", &sd->min_interval,
-		sizeof(long), 0644, proc_doulongvec_minmax, false);
+		sizeof(long), 0644, sched_debug_proc_doulongvec_minmax, false);
 	set_table_entry(&table[1], "max_interval", &sd->max_interval,
-		sizeof(long), 0644, proc_doulongvec_minmax, false);
+		sizeof(long), 0644, sched_debug_proc_doulongvec_minmax, false);
 	set_table_entry(&table[2], "busy_idx", &sd->busy_idx,
-		sizeof(int), 0644, proc_dointvec_minmax, true);
+		sizeof(int), 0644, sched_debug_proc_dointvec_minmax, true);
 	set_table_entry(&table[3], "idle_idx", &sd->idle_idx,
-		sizeof(int), 0644, proc_dointvec_minmax, true);
+		sizeof(int), 0644, sched_debug_proc_dointvec_minmax, true);
 	set_table_entry(&table[4], "newidle_idx", &sd->newidle_idx,
-		sizeof(int), 0644, proc_dointvec_minmax, true);
+		sizeof(int), 0644, sched_debug_proc_dointvec_minmax, true);
 	set_table_entry(&table[5], "wake_idx", &sd->wake_idx,
-		sizeof(int), 0644, proc_dointvec_minmax, true);
+		sizeof(int), 0644, sched_debug_proc_dointvec_minmax, true);
 	set_table_entry(&table[6], "forkexec_idx", &sd->forkexec_idx,
-		sizeof(int), 0644, proc_dointvec_minmax, true);
+		sizeof(int), 0644, sched_debug_proc_dointvec_minmax, true);
 	set_table_entry(&table[7], "busy_factor", &sd->busy_factor,
-		sizeof(int), 0644, proc_dointvec_minmax, false);
+		sizeof(int), 0644, sched_debug_proc_dointvec_minmax, false);
 	set_table_entry(&table[8], "imbalance_pct", &sd->imbalance_pct,
-		sizeof(int), 0644, proc_dointvec_minmax, false);
+		sizeof(int), 0644, sched_debug_proc_dointvec_minmax, false);
 	set_table_entry(&table[9], "cache_nice_tries",
 		&sd->cache_nice_tries,
-		sizeof(int), 0644, proc_dointvec_minmax, false);
+		sizeof(int), 0644, sched_debug_proc_dointvec_minmax, false);
 	set_table_entry(&table[10], "flags", &sd->flags,
-		sizeof(int), 0644, proc_dointvec_minmax, false);
+		sizeof(int), 0644, sched_debug_proc_dointvec_minmax, false);
 	set_table_entry(&table[11], "max_newidle_lb_cost",
 		&sd->max_newidle_lb_cost,
-		sizeof(long), 0644, proc_doulongvec_minmax, false);
+		sizeof(long), 0644, sched_debug_proc_doulongvec_minmax, false);
 	set_table_entry(&table[12], "name", sd->name,
 		CORENAME_MAX_SIZE, 0444, proc_dostring, false);
 	/* &table[13] is terminator */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 923fe32db6b3..e09202eb348f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -577,6 +577,9 @@ int sched_proc_update_handler(struct ctl_table *table, =
int write,
 	int ret =3D proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 	int factor =3D get_update_sysctl_factor();
=20
+	if (write)
+		sched_debug_taint();
+
 	if (ret || !write)
 		return ret;
=20
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 0191ed563bdd..fa880ca9ee4a 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -874,6 +874,8 @@ static inline void __set_task_cpu(struct task_struct *p=
, unsigned int cpu)
 # define const_debug const
 #endif
=20
+extern void sched_debug_taint(void);
+
 extern const_debug unsigned int sysctl_sched_features;
=20
 #define SCHED_FEAT(name, enabled)	\
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 7de6555cfea0..f9810984f3ca 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -328,35 +328,35 @@ static struct ctl_table kern_table[] =3D {
 		.data		=3D &sysctl_sched_migration_cost,
 		.maxlen		=3D sizeof(unsigned int),
 		.mode		=3D 0644,
-		.proc_handler	=3D proc_dointvec,
+		.proc_handler	=3D sched_debug_proc_dointvec_minmax,
 	},
 	{
 		.procname	=3D "sched_nr_migrate",
 		.data		=3D &sysctl_sched_nr_migrate,
 		.maxlen		=3D sizeof(unsigned int),
 		.mode		=3D 0644,
-		.proc_handler	=3D proc_dointvec,
+		.proc_handler	=3D sched_debug_proc_dointvec_minmax,
 	},
 	{
 		.procname	=3D "sched_time_avg_ms",
 		.data		=3D &sysctl_sched_time_avg,
 		.maxlen		=3D sizeof(unsigned int),
 		.mode		=3D 0644,
-		.proc_handler	=3D proc_dointvec,
+		.proc_handler	=3D sched_debug_proc_dointvec_minmax,
 	},
 	{
 		.procname	=3D "sched_shares_window_ns",
 		.data		=3D &sysctl_sched_shares_window,
 		.maxlen		=3D sizeof(unsigned int),
 		.mode		=3D 0644,
-		.proc_handler	=3D proc_dointvec,
+		.proc_handler	=3D sched_debug_proc_dointvec_minmax,
 	},
 	{
 		.procname	=3D "timer_migration",
 		.data		=3D &sysctl_timer_migration,
 		.maxlen		=3D sizeof(unsigned int),
 		.mode		=3D 0644,
-		.proc_handler	=3D proc_dointvec_minmax,
+		.proc_handler	=3D sched_debug_proc_dointvec_minmax,
 		.extra1		=3D &zero,
 		.extra2		=3D &one,
 	},
@@ -367,28 +367,28 @@ static struct ctl_table kern_table[] =3D {
 		.data		=3D &sysctl_numa_balancing_scan_delay,
 		.maxlen		=3D sizeof(unsigned int),
 		.mode		=3D 0644,
-		.proc_handler	=3D proc_dointvec,
+		.proc_handler	=3D sched_debug_proc_dointvec_minmax,
 	},
 	{
 		.procname	=3D "numa_balancing_scan_period_min_ms",
 		.data		=3D &sysctl_numa_balancing_scan_period_min,
 		.maxlen		=3D sizeof(unsigned int),
 		.mode		=3D 0644,
-		.proc_handler	=3D proc_dointvec,
+		.proc_handler	=3D sched_debug_proc_dointvec_minmax,
 	},
 	{
 		.procname	=3D "numa_balancing_scan_period_max_ms",
 		.data		=3D &sysctl_numa_balancing_scan_period_max,
 		.maxlen		=3D sizeof(unsigned int),
 		.mode		=3D 0644,
-		.proc_handler	=3D proc_dointvec,
+		.proc_handler	=3D sched_debug_proc_dointvec_minmax,
 	},
 	{
 		.procname	=3D "numa_balancing_scan_size_mb",
 		.data		=3D &sysctl_numa_balancing_scan_size,
 		.maxlen		=3D sizeof(unsigned int),
 		.mode		=3D 0644,
-		.proc_handler	=3D proc_dointvec,
+		.proc_handler	=3D sched_debug_proc_dointvec_minmax,
 	},
 	{
 		.procname	=3D "numa_balancing",

--3xQkynibq3FKlJyM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTtAXbAAoJEHZH4aRLwOS6ey4QAKw9xWWeZXpTd4zdYVEkHPIq
GzMl736lXcOpm5d+keOTe+6di9I+EpcmtvSOVrWGJZxgnBLC40K37mHJOZWvVrat
xXpFb+0ICGYBKy1z8eMMv+Q3P4ElaWzlyxzXuH2AeHnCspJFNgcG3eY7BwvrFBz0
+GQme210qgJCDb26IinkAJdOvu/yOKyf1GWmWF5FUEQqmByMu7RI+vbS/kR+8lpI
8aar1J7hb5wIkwZLGNzuaC92j+pYHPaqTTBfFNrbQkKAYuozEq7fT+wDE2s4m1Z7
ZB7CuE/A33RulvirAg6L/vkrsZJVjrd+soBRYXLeXZFzK10wAAkWkoG8P+/MZ/o6
BkOBReX+i+san8dKGAUoFRVbryiuFydweh8cj1S2xKkQUwamhicyeN/cgLBuv2co
Vu5M0W0N5RCqKVa7+eStddo+UIEhLQj02fQ4IyxgTrHSNAJJessMPTXFIOXGHfFL
vsLaGRfyFHbm1mdZUeCiSOOR2DY5wMEYr4XbJOB4ZqCsx8GpQSV/iEObGUnBNLHc
uA/mJcdZrjJZQmiDTuwmwKcetu7b1b8vhJkQS7DdHs1ZEcNTrDT4Ok5LCxYczkWs
4fmLTnwWq+vr67tEtWAI0av8knOpUzlf3/l46/2xBSEkdG4jwCOE2/pck5kq6MlS
JyfDT1H21cgbiSw2qRU1
=dAR3
-----END PGP SIGNATURE-----

--3xQkynibq3FKlJyM--
