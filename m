Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbaHMRYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 13:24:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:45632 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaHMRYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 13:24:23 -0400
Date: Wed, 13 Aug 2014 19:24:07 +0200
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
Message-ID: <20140813172407.GM3588@twins.programming.kicks-ass.net>
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1407797345-28227-15-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140813081215.GB9918@twins.programming.kicks-ass.net>
 <20140813124818.GQ4752@linux.vnet.ibm.com>
 <20140813134025.GN9918@twins.programming.kicks-ass.net>
 <20140813141217.GU4752@linux.vnet.ibm.com>
 <20140813144219.GQ9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GN/IAAAoV4GJoJGS"
Content-Disposition: inline
In-Reply-To: <20140813144219.GQ9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GN/IAAAoV4GJoJGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 04:42:19PM +0200, Peter Zijlstra wrote:
> Auditing all idle functions will be somewhat of a pain, but its entirely
> doable. Looking at this stuff, it appears we can clean it up massively;
> see how the generic cpuidle code already has the broadcast logic in, so
> we can remove that from the drivers by setting the right flags.
>=20
> We can similarly pull out the leave_mm() call by adding a
> CPUIDLE_FLAG_TLB_FLUSH. At which point all we'd need to do is mark the
> intel_idle (and all other cpuidle_state::enter functions with __notrace.

This removes the broadcast stuff from intel_idle.c; processor_idle.c hurts
my brain, but something similar should be possible.

---
 drivers/idle/intel_idle.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 4d140bbbe100..6613d4ee60ce 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -508,11 +508,8 @@ static int intel_idle(struct cpuidle_device *dev,
 	unsigned long ecx =3D 1; /* break on interrupt flag */
 	struct cpuidle_state *state =3D &drv->states[index];
 	unsigned long eax =3D flg2MWAIT(state->flags);
-	unsigned int cstate;
 	int cpu =3D smp_processor_id();
=20
-	cstate =3D (((eax) >> MWAIT_SUBSTATE_SIZE) & MWAIT_CSTATE_MASK) + 1;
-
 	/*
 	 * leave_mm() to avoid costly and often unnecessary wakeups
 	 * for flushing the user TLB's associated with the active mm.
@@ -520,14 +517,8 @@ static int intel_idle(struct cpuidle_device *dev,
 	if (state->flags & CPUIDLE_FLAG_TLB_FLUSHED)
 		leave_mm(cpu);
=20
-	if (!(lapic_timer_reliable_states & (1 << (cstate))))
-		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
-
 	mwait_idle_with_hints(eax, ecx);
=20
-	if (!(lapic_timer_reliable_states & (1 << (cstate))))
-		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
-
 	return index;
 }
=20
@@ -670,6 +661,7 @@ static int __init intel_idle_probe(void)
 {
 	unsigned int eax, ebx, ecx;
 	const struct x86_cpu_id *id;
+	int i;
=20
 	if (max_cstate =3D=3D 0) {
 		pr_debug(PREFIX "disabled\n");
@@ -705,6 +697,15 @@ static int __init intel_idle_probe(void)
 	else
 		on_each_cpu(__setup_broadcast_timer, (void *)true, 1);
=20
+	for (i =3D 0; cpuidle_state_table[i].enter; i++) {
+		struct cpuidle_state *state =3D &cpuidle_state_table[i];
+		int cstate =3D ((flg2MWAIT(state->flags) >> MWAIT_SUBSTATE_SIZE) &=20
+				MWAIT_CSTATE_MASK) + 1;
+
+		if (!(lapic_timer_reliable_states & (1 << cstate)))
+			state->flags |=3D CPUIDLE_FLAG_TIMER_STOP;
+	}
+
 	pr_debug(PREFIX "v" INTEL_IDLE_VERSION
 		" model 0x%X\n", boot_cpu_data.x86_model);
=20

--GN/IAAAoV4GJoJGS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6582AAoJEHZH4aRLwOS6n74QAIzMrbTgNbn81md5M0Mijz2F
+ZTh/y4Ex1wekZW2K+g2pvNF9D0LwxypPNb085CSXXzlXYfWtdxQebWYIUEO3Ac5
PmKNBPXkuI6YH0/psQkay4tvOBFk/IZOu9puMmx2vczJxHWElOErnOe9lUUc2K6V
7EDMmU7vNZrhsHnHzJqna5yaLoiznxZ849+9eVug+XWMSLEhbm+5vGUH3a4udcS+
zQJGtKwCUHmJ9sRAOmU1CmdWrVmbA8WLT5cQw3yGoHMPZybl+JcgLskGh6ifEqpt
d/VPR+utmCudhYNwWhELqn8YKf5P0F6e+IGOUyNS4WlHSLZvZa0EnSdS4GVP7K/U
z8ijJ7f3/YsEbVvt9lOWyWE7tlxRobHQnUyAeMubFsAzVBc/rwWAMUQBmnFxO6BF
6qviyd/KdRDUutscWjV9AKA0q3WMmHotqbFbjphfghlH6B11fiAFa8Wr7x/DxR13
tC9wj3L0H1lUYDfoX+5QvKtiRSib6Xeq1muzrhmhJbjcAoksZ+GZymtt2NB0skOC
7lJFJWIKmuI5GDauiJtIXnIs1kZbJSC9a2tlBScBQB1JALc0vhXLdLf9ZU0PgfZQ
JlVsNbO3v2CEYWRlIdUK6euJw8CHo440QLrk/eAaXtLD6OkJzCTOWlZRSdR0yHrl
Exzc+t1cfSVxZVhOrUg2
=Znus
-----END PGP SIGNATURE-----

--GN/IAAAoV4GJoJGS--
