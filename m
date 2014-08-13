Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbaHMRax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 13:30:53 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38764 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaHMRaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 13:30:52 -0400
Date: Wed, 13 Aug 2014 19:30:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com, rafael@kernel.org
Subject: Re: [PATCH v5 tip/core/rcu 15/16] rcu: Make RCU-tasks wait for idle
 tasks
Message-ID: <20140813173020.GN3588@twins.programming.kicks-ass.net>
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1407797345-28227-15-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140813081215.GB9918@twins.programming.kicks-ass.net>
 <20140813124818.GQ4752@linux.vnet.ibm.com>
 <20140813134025.GN9918@twins.programming.kicks-ass.net>
 <20140813141217.GU4752@linux.vnet.ibm.com>
 <20140813144219.GQ9918@twins.programming.kicks-ass.net>
 <20140813172407.GM3588@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2gg7fA5kVn3CgPY0"
Content-Disposition: inline
In-Reply-To: <20140813172407.GM3588@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2gg7fA5kVn3CgPY0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 07:24:07PM +0200, Peter Zijlstra wrote:
> On Wed, Aug 13, 2014 at 04:42:19PM +0200, Peter Zijlstra wrote:
> > Auditing all idle functions will be somewhat of a pain, but its entirely
> > doable. Looking at this stuff, it appears we can clean it up massively;
> > see how the generic cpuidle code already has the broadcast logic in, so
> > we can remove that from the drivers by setting the right flags.
> >=20
> > We can similarly pull out the leave_mm() call by adding a
> > CPUIDLE_FLAG_TLB_FLUSH. At which point all we'd need to do is mark the
> > intel_idle (and all other cpuidle_state::enter functions with __notrace.
>=20
> This removes the broadcast stuff from intel_idle.c; processor_idle.c hurts
> my brain, but something similar should be possible.
>=20

And this moves the leave_mm() bit to generic code.

---
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -101,14 +101,6 @@ static int intel_idle_cpu_init(int cpu);
 static struct cpuidle_state *cpuidle_state_table;
=20
 /*
- * Set this flag for states where the HW flushes the TLB for us
- * and so we don't need cross-calls to keep it consistent.
- * If this flag is set, SW flushes the TLB, so even if the
- * HW doesn't do the flushing, this flag is safe to use.
- */
-#define CPUIDLE_FLAG_TLB_FLUSHED	0x10000
-
-/*
  * MWAIT takes an 8-bit "hint" in EAX "suggesting"
  * the C-state (top nibble) and sub-state (bottom nibble)
  * 0x00 means "MWAIT(C1)", 0x10 means "MWAIT(C2)" etc.
@@ -508,14 +500,6 @@ static int intel_idle(struct cpuidle_dev
 	unsigned long ecx =3D 1; /* break on interrupt flag */
 	struct cpuidle_state *state =3D &drv->states[index];
 	unsigned long eax =3D flg2MWAIT(state->flags);
-	int cpu =3D smp_processor_id();
-
-	/*
-	 * leave_mm() to avoid costly and often unnecessary wakeups
-	 * for flushing the user TLB's associated with the active mm.
-	 */
-	if (state->flags & CPUIDLE_FLAG_TLB_FLUSHED)
-		leave_mm(cpu);
=20
 	mwait_idle_with_hints(eax, ecx);
=20
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -56,6 +56,7 @@ struct cpuidle_state {
 #define CPUIDLE_FLAG_TIME_VALID	(0x01) /* is residency time measurable? */
 #define CPUIDLE_FLAG_COUPLED	(0x02) /* state applies to multiple cpus */
 #define CPUIDLE_FLAG_TIMER_STOP (0x04)  /* timer is stopped on this state =
*/
+#define CPUIDLE_FLAG_TLB_FLUSHED (0x08) /* TLBs are flushed on this state =
*/
=20
 #define CPUIDLE_DRIVER_FLAGS_MASK (0xFFFF0000)
=20
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -79,7 +79,7 @@ static void cpuidle_idle_call(void)
 	struct cpuidle_device *dev =3D __this_cpu_read(cpuidle_devices);
 	struct cpuidle_driver *drv =3D cpuidle_get_cpu_driver(dev);
 	int next_state, entered_state;
-	unsigned int broadcast;
+	unsigned int broadcast, flags;
=20
 	/*
 	 * Check if the idle task must be rescheduled. If it is the
@@ -135,7 +135,16 @@ static void cpuidle_idle_call(void)
 		goto exit_idle;
 	}
=20
-	broadcast =3D drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP;
+	flags =3D drv->states[next_state].flags;
+
+	/*
+	 * leave_mm() to avoid costly and often unnecessary wakeups
+	 * for flushing the user TLB's associated with the active mm.
+	 */
+	if (flags & CPUIDLE_FLAG_TLB_FLUSHED)
+		leave_mm(dev->cpu);
+
+	broadcast =3D flags & CPUIDLE_FLAG_TIMER_STOP;
=20
 	/*
 	 * Tell the time framework to switch to a broadcast timer

--2gg7fA5kVn3CgPY0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT66CsAAoJEHZH4aRLwOS6mIkP/jjCJ2y9OC4w4YIJgxBT1ogJ
P11lif3tcdfoutjbYnQMeQR3BeZo5KCrgo252O6AIUYNlRkFGPx15lAGgGlDMaq4
RPZFfBFheFZb/m6YFpAVAdhiJQScDscS4y3bJNpjPu1twphM7oUHO+A9r01hkBvu
5DLr98+vpcV4bD1EqTIkXPvaw+YkbaQ2ZXRgcO4+5laggh0ae1+QaOnFNCVF866Z
T5XnuWEVGQbJPh+KHSpOsHEqEBBaoYeLYiavn28i5qzjN+lfgggIz8kJLDYpmQFY
Inze+2mMz5c5qYW3WTwSBKKuNhAsobj74TfMy4p9y2DzohFozbEAqJnDYOFuk4JT
eonRdw3BfxyLLfPiFrvs+2PD/QTnPjmANv4rdpLSqNkNnt3h75g7SVl5XjwoEnEd
e/9ozywLbbpynXFfZECBHBIMd7BGeTqXyGLqsfCCSGdniY/qWP4wKekJs5Q8AI2u
e24A2QaV+bFcpORiapnJngn3qjQ9tpQ+MDPqjfPHywMw7uwerpLMSe9ktgOvzovN
+TAzTVmxLyMN6nTIahTf2Q38rYfLbKxs+u6UjXPn1BwoW7hUKdPOP5dKgGFgYs30
vclDhPtzQRa4cc3q5ABoftwawhWUWsnB4xUSqbC3VLXybkg4ZKE9VZaZC5IWpEcK
C0nmXz7hbGd6YVC5AY/6
=5hZo
-----END PGP SIGNATURE-----

--2gg7fA5kVn3CgPY0--
