Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaHJQrY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 12:47:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33160 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaHJQrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 12:47:22 -0400
Date: Sun, 10 Aug 2014 18:46:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140810164633.GK3588@twins.programming.kicks-ass.net>
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140808191326.GE3935@laptop>
 <20140808205826.GG5821@linux.vnet.ibm.com>
 <20140809061514.GK9918@twins.programming.kicks-ass.net>
 <20140809160137.GJ5821@linux.vnet.ibm.com>
 <20140809181920.GO9918@twins.programming.kicks-ass.net>
 <20140810012612.GN5821@linux.vnet.ibm.com>
 <20140810081254.GS9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cKDw3XFoqocuprIa"
Content-Disposition: inline
In-Reply-To: <20140810081254.GS9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cKDw3XFoqocuprIa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 10, 2014 at 10:12:54AM +0200, Peter Zijlstra wrote:
> > Steven covered this earlier in this thread.  One addition might be "For
> > the same reason that event tracing provides the _rcuidle suffix."
>=20
> I really don't think its worth the cost.

Entirely untested, but something like the below shrinks the
amount of code called under rcu_idle.

Also, why are trace_cpu_idle*() not inside rcu_idle_{enter,exit}() ?
Doesn't seem to make sense to duplicate all that.

Also, the .cpu argument to trace_cpu_idle() seems silly, how is that
_ever_ going to be any other cpu than the current?

Also, the below removes all trace_.*_rcuidle() usage.

---
 arch/x86/kernel/process.c |  2 --
 kernel/sched/idle.c       | 34 ++++++++++++++++++++--------------
 2 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index f804dc935d2a..9fc3fc123887 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -307,9 +307,7 @@ void arch_cpu_idle(void)
  */
 void default_idle(void)
 {
-	trace_cpu_idle_rcuidle(1, smp_processor_id());
 	safe_halt();
-	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 }
 #ifdef CONFIG_APM_MODULE
 EXPORT_SYMBOL(default_idle);
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 9f1608f99819..591c08b0e66a 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -44,13 +44,13 @@ __setup("hlt", cpu_idle_nopoll_setup);
=20
 static inline int cpu_idle_poll(void)
 {
+	trace_cpu_idle(0, smp_processor_id());
 	rcu_idle_enter();
-	trace_cpu_idle_rcuidle(0, smp_processor_id());
 	local_irq_enable();
 	while (!tif_need_resched())
 		cpu_relax();
-	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 	rcu_idle_exit();
+	trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
 	return 1;
 }
=20
@@ -97,13 +97,6 @@ static void cpuidle_idle_call(void)
 	stop_critical_timings();
=20
 	/*
-	 * Tell the RCU framework we are entering an idle section,
-	 * so no more rcu read side critical sections and one more
-	 * step to the grace period
-	 */
-	rcu_idle_enter();
-
-	/*
 	 * Ask the cpuidle framework to choose a convenient idle state.
 	 * Fall back to the default arch idle method on errors.
 	 */
@@ -114,10 +107,15 @@ static void cpuidle_idle_call(void)
 		 * We can't use the cpuidle framework, let's use the default
 		 * idle routine.
 		 */
-		if (current_clr_polling_and_test())
+		if (current_clr_polling_and_test()) {
 			local_irq_enable();
-		else
+		} else {
+			trace_cpu_idle(0, smp_processor_id());
+			rcu_idle_enter();
 			arch_cpu_idle();
+			rcu_idle_exit();
+			trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
+		}
=20
 		goto exit_idle;
 	}
@@ -147,7 +145,14 @@ static void cpuidle_idle_call(void)
 	    clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu))
 		goto use_default;
=20
-	trace_cpu_idle_rcuidle(next_state, dev->cpu);
+	trace_cpu_idle(next_state, dev->cpu);
+
+	/*
+	 * Tell the RCU framework we are entering an idle section,
+	 * so no more rcu read side critical sections and one more
+	 * step to the grace period
+	 */
+	rcu_idle_enter();
=20
 	/*
 	 * Enter the idle state previously returned by the governor decision.
@@ -156,7 +161,9 @@ static void cpuidle_idle_call(void)
 	 */
 	entered_state =3D cpuidle_enter(drv, dev, next_state);
=20
-	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
+	rcu_idle_exit();
+
+	trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
=20
 	if (broadcast)
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
@@ -175,7 +182,6 @@ static void cpuidle_idle_call(void)
 	if (WARN_ON_ONCE(irqs_disabled()))
 		local_irq_enable();
=20
-	rcu_idle_exit();
 	start_critical_timings();
 }
=20

--cKDw3XFoqocuprIa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT56HpAAoJEHZH4aRLwOS6xhkP/2w+YFsUCD1fiikL/rpfwe2+
w4QVlPwhtfe1IfnkVdNLJmSio80qzG84FM6XJI/R0SBZKCFMUO7e+V6STxgJNvfs
E3aesOLgtLOjgxwoxHMRgc7nKcojhX4X5X32ZL4d3fSMCQxOuDjrHRjfNWLmxuE+
thbtbxQWpM16nUQUDVxZqWtwiYf2Q+qxq8pzh+AsETXTVc99/k4bZoXrMTKx9zMz
PfPZICrShnOxVvVY5cUTlnLBZPbUxanfnhFksxNaft2Nj5pekhUEer4GVwroXCKC
CfznP+C5OPhdnzr3p22X2FYDyR2NYgTtaakZIEUDPwNT8eC9unsMtIbVIBjh+eqL
gRUEOy4Vai7BKTp8ygHYyDdWyLHdLDFRvzC3P6boqWzfKw+7P0WcHwn+ylIXbcXQ
/PKfaaUpeLqo+uTIUhCy1SEFAXKS+ddyAKT6/QD7Owr0NxFLKo5IqZrZfhoOYtb5
MpCWiqIagvYZN3c1KlDN1XKYZxp8eI77owHtLfpI1lioDQXkoE2OUNggNdvv/jnV
i7xUC1o4JrlRiu93/VbYLDHw/Ma4QjNRX3eYEkv2gRS/It14Y07x04WwO9jcccSu
WR+QaAKIHXyvaM7lUfovMiUr5Er8D8in+7GH15w0a4AKUsaTQDSlZHlzN2sR/YLF
dY3Z/TuT2cP7+Y3E/4o4
=gEZF
-----END PGP SIGNATURE-----

--cKDw3XFoqocuprIa--
