Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab3BGPrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:47:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629Ab3BGPrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:47:16 -0500
Date: Thu, 7 Feb 2013 09:47:04 -0600
From: Clark Williams <williams@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] sched/rt: add a tuning knob to allow changing SCHED_RR
 timeslice
Message-ID: <20130207094704.13751796@riff.lan>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Iy9_9oopTN6Q=ZXPMloHTkv"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Iy9_9oopTN6Q=ZXPMloHTkv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Add a /proc/sys/kernel scheduler knob named sched_rr_timeslice_ms
that allows global changing of the SCHED_RR timeslice value. User
visable value is in milliseconds but is stored as jiffies.  Setting
to 0 (zero) resets to the default (currently 100ms).

Signed-off-by: Clark Williams <williams@redhat.com>
---
 include/linux/sched/sysctl.h | 15 ++++++++++++++-
 kernel/sched/core.c          | 19 +++++++++++++++++++
 kernel/sched/rt.c            |  6 ++++--
 kernel/sysctl.c              |  7 +++++++
 4 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index bac914e..d2bb0ae 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -73,6 +73,13 @@ static inline unsigned int get_sysctl_timer_migration(vo=
id)
 	return 1;
 }
 #endif
+
+/*
+ *  control realtime throttling:
+ *
+ *  /proc/sys/kernel/sched_rt_period_us
+ *  /proc/sys/kernel/sched_rt_runtime_us
+ */
 extern unsigned int sysctl_sched_rt_period;
 extern int sysctl_sched_rt_runtime;
=20
@@ -90,7 +97,13 @@ extern unsigned int sysctl_sched_autogroup_enabled;
  */
 #define RR_TIMESLICE		(100 * HZ / 1000)
=20
-int sched_rt_handler(struct ctl_table *table, int write,
+extern int sched_rr_timeslice;
+
+extern int sched_rr_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos);
+
+extern int sched_rt_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
=20
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 26058d0..1c39c33 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7508,6 +7508,25 @@ static int sched_rt_global_constraints(void)
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
=20
+int sched_rr_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos)
+{
+	int ret;
+	static DEFINE_MUTEX(mutex);
+
+	mutex_lock(&mutex);
+	ret =3D proc_dointvec(table, write, buffer, lenp, ppos);
+	/* make sure that internally we keep jiffies */
+	/* also, writing zero resets timeslice to default */
+	if (!ret && write) {
+		sched_rr_timeslice =3D sched_rr_timeslice <=3D 0 ?
+			RR_TIMESLICE : msecs_to_jiffies(sched_rr_timeslice);
+	}
+	mutex_unlock(&mutex);
+	return ret;
+}
+
 int sched_rt_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos)
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 839718d..127a2c4 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -7,6 +7,8 @@
=20
 #include <linux/slab.h>
=20
+int sched_rr_timeslice =3D RR_TIMESLICE;
+
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun=
);
=20
 struct rt_bandwidth def_rt_bandwidth;
@@ -2016,7 +2018,7 @@ static void task_tick_rt(struct rq *rq, struct task_s=
truct *p, int queued)
 	if (--p->rt.time_slice)
 		return;
=20
-	p->rt.time_slice =3D RR_TIMESLICE;
+	p->rt.time_slice =3D sched_rr_timeslice;
=20
 	/*
 	 * Requeue to the end of queue if we (and all of our ancestors) are the
@@ -2047,7 +2049,7 @@ static unsigned int get_rr_interval_rt(struct rq *rq,=
 struct task_struct *task)
 	 * Time slice is 0 for SCHED_FIFO tasks
 	 */
 	if (task->policy =3D=3D SCHED_RR)
-		return RR_TIMESLICE;
+		return sched_rr_timeslice;
 	else
 		return 0;
 }
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 7357e23..4fc9be9 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -404,6 +404,13 @@ static struct ctl_table kern_table[] =3D {
 		.mode		=3D 0644,
 		.proc_handler	=3D sched_rt_handler,
 	},
+	{
+		.procname	=3D "sched_rr_timeslice_ms",
+		.data		=3D &sched_rr_timeslice,
+		.maxlen		=3D sizeof(int),
+		.mode		=3D 0644,
+		.proc_handler	=3D sched_rr_handler,
+	},
 #ifdef CONFIG_SCHED_AUTOGROUP
 	{
 		.procname	=3D "sched_autogroup_enabled",
--=20
1.8.1


--Sig_/Iy9_9oopTN6Q=ZXPMloHTkv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlETzHgACgkQHyuj/+TTEp09AgCeIQgGwjU3dX2Kxszv/gMEotpt
8xUAoL0ODwNr20/qG0aIp5xvDuonIWwY
=pflf
-----END PGP SIGNATURE-----

--Sig_/Iy9_9oopTN6Q=ZXPMloHTkv--
