Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbaHMSR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 14:17:26 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35277 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaHMSRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 14:17:24 -0400
Date: Wed, 13 Aug 2014 20:16:59 +0200
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
Message-ID: <20140813181659.GO3588@twins.programming.kicks-ass.net>
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
	protocol="application/pgp-signature"; boundary="LQv0vi9oZBoYbpa7"
Content-Disposition: inline
In-Reply-To: <20140813172407.GM3588@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQv0vi9oZBoYbpa7
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

Still hurts my brain; esp. acpi_idle_enter_bm() which calls a massive
lot of code to disable busmastering, but maybe its doable, we need that
__notrace detectoring.


Also, someone needs to double check this; preferably LenB or Rafael who
have seen this driver before. Teh pain.

---
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -171,32 +171,11 @@ static void lapic_timer_propagate_broadc
 				 (void *)pr, 1);
 }
=20
-/* Power(C) State timer broadcast control */
-static void lapic_timer_state_broadcast(struct acpi_processor *pr,
-				       struct acpi_processor_cx *cx,
-				       int broadcast)
-{
-	int state =3D cx - pr->power.states;
-
-	if (state >=3D pr->power.timer_broadcast_on_state) {
-		unsigned long reason;
-
-		reason =3D broadcast ?  CLOCK_EVT_NOTIFY_BROADCAST_ENTER :
-			CLOCK_EVT_NOTIFY_BROADCAST_EXIT;
-		clockevents_notify(reason, &pr->id);
-	}
-}
-
 #else
=20
 static void lapic_timer_check_state(int state, struct acpi_processor *pr,
 				   struct acpi_processor_cx *cstate) { }
 static void lapic_timer_propagate_broadcast(struct acpi_processor *pr) { }
-static void lapic_timer_state_broadcast(struct acpi_processor *pr,
-				       struct acpi_processor_cx *cx,
-				       int broadcast)
-{
-}
=20
 #endif
=20
@@ -717,19 +696,10 @@ static inline void acpi_idle_do_entry(st
 static int acpi_idle_enter_c1(struct cpuidle_device *dev,
 		struct cpuidle_driver *drv, int index)
 {
-	struct acpi_processor *pr;
 	struct acpi_processor_cx *cx =3D per_cpu(acpi_cstate[index], dev->cpu);
=20
-	pr =3D __this_cpu_read(processors);
-
-	if (unlikely(!pr))
-		return -EINVAL;
-
-	lapic_timer_state_broadcast(pr, cx, 1);
 	acpi_idle_do_entry(cx);
=20
-	lapic_timer_state_broadcast(pr, cx, 0);
-
 	return index;
 }
=20
@@ -785,22 +755,8 @@ static int acpi_idle_enter_simple(struct
 		return acpi_idle_enter_c1(dev, drv, CPUIDLE_DRIVER_STATE_START);
 #endif
=20
-	/*
-	 * Must be done before busmaster disable as we might need to
-	 * access HPET !
-	 */
-	lapic_timer_state_broadcast(pr, cx, 1);
-
-	if (cx->type =3D=3D ACPI_STATE_C3)
-		ACPI_FLUSH_CPU_CACHE();
-
-	/* Tell the scheduler that we are going deep-idle: */
-	sched_clock_idle_sleep_event();
 	acpi_idle_do_entry(cx);
=20
-	sched_clock_idle_wakeup_event(0);
-
-	lapic_timer_state_broadcast(pr, cx, 0);
 	return index;
 }
=20
@@ -843,16 +799,6 @@ static int acpi_idle_enter_bm(struct cpu
 		}
 	}
=20
-	acpi_unlazy_tlb(smp_processor_id());
-
-	/* Tell the scheduler that we are going deep-idle: */
-	sched_clock_idle_sleep_event();
-	/*
-	 * Must be done before busmaster disable as we might need to
-	 * access HPET !
-	 */
-	lapic_timer_state_broadcast(pr, cx, 1);
-
 	/*
 	 * disable bus master
 	 * bm_check implies we need ARB_DIS
@@ -884,9 +830,6 @@ static int acpi_idle_enter_bm(struct cpu
 		raw_spin_unlock(&c3_lock);
 	}
=20
-	sched_clock_idle_wakeup_event(0);
-
-	lapic_timer_state_broadcast(pr, cx, 0);
 	return index;
 }
=20
@@ -989,6 +932,7 @@ static int acpi_processor_setup_cpuidle_
 				state->flags |=3D CPUIDLE_FLAG_TIME_VALID;
=20
 			state->enter =3D acpi_idle_enter_c1;
+			state->flags |=3D CPUIDLE_FLAG_TIMER_STOP;
 			state->enter_dead =3D acpi_idle_play_dead;
 			drv->safe_state_index =3D count;
 			break;
@@ -996,15 +940,20 @@ static int acpi_processor_setup_cpuidle_
 			case ACPI_STATE_C2:
 			state->flags |=3D CPUIDLE_FLAG_TIME_VALID;
 			state->enter =3D acpi_idle_enter_simple;
+			state->flags |=3D CPUIDLE_FLAG_TIMER_STOP;
 			state->enter_dead =3D acpi_idle_play_dead;
 			drv->safe_state_index =3D count;
 			break;
=20
 			case ACPI_STATE_C3:
 			state->flags |=3D CPUIDLE_FLAG_TIME_VALID;
-			state->enter =3D pr->flags.bm_check ?
-					acpi_idle_enter_bm :
-					acpi_idle_enter_simple;
+			state->flags |=3D CPUIDLE_FLAG_TLB_FLUSHED;
+			state->flags |=3D CPUIDLE_FLAG_TIMER_STOP;
+			if (pr->flags.bm_check) {
+				state->enter =3D acpi_idle_enter_bm;
+			} else {
+				state->enter =3D acpi_idle_enter_simple;
+			}
 			break;
 		}
=20
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -152,9 +152,11 @@ static void cpuidle_idle_call(void)
 	 * is used from another cpu as a broadcast timer, this call may
 	 * fail if it is not available
 	 */
-	if (broadcast &&
-	    clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu))
-		goto use_default;
+	if (broadcast) {
+		if (clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu))
+			goto use_default;
+		sched_clock_idle_sleep_event();
+	}
=20
 	trace_cpu_idle_rcuidle(next_state, dev->cpu);
=20
@@ -167,8 +169,10 @@ static void cpuidle_idle_call(void)
=20
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
=20
-	if (broadcast)
+	if (broadcast) {
+		sched_clock_idle_wakeup_event(0);
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
+	}
=20
 	/*
 	 * Give the governor an opportunity to reflect on the outcome

--LQv0vi9oZBoYbpa7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT66ubAAoJEHZH4aRLwOS6Z4gP/2AvfLCG1KcSmSoDE0M2QZtK
/vL9R4LQ27cu6Ft9waplUHD/nhE1L3WqzLXbGOnol+NCJTidAEJRrmbVnDndox+S
fALUlRUBBvvdgDOk99aC9yxFS5cSmuUSvGsxX7FMbRXDyHIyb/vBSLzS9EHWeq77
5nG0kfHWDxZHAUGnMD1w0tAJMPTs+15kQPYs7CqNb1LR6qFgKZ/NdyPu6ZTdxrpG
9jFp3EOyjeGo/lKND3HGRsxne4qfceuRgZr4DBVCG1lcAKIKe8giFHsGUN27ujnS
ye6okgxMLdwkB1vT3G4GlJN8k+R9NG+IuyGwaQRLCKDDTGx+eC3p/yoNSw/q7mF1
56tDtkYRFZpNyjHQD7yRFBviZ8Ojlc/dvF7LcjqDsQWrnutCONnKnlZfma/7p7rY
oW7otRwzzpUpe12f2XzaCtZtv6QjaOQ0Lj4FkULgws9xY3anBgOqzWxyNLoJBbF4
wjhzn4vGMy1oZsL5ntSJ5yUkrisKEp7VH4bfBST8ielP/1OMux2X6xD6ezBVypJ5
Qu/zifCwVxpEnVMtGT8vyWgzQDlb9mULCCSZtc8EcG3Xri/suC+mcy8lz2EMKjNV
8uvEITkvqXQgPgCAwGNzBwKIKh5sSkaiNVWWxkUQ98dVein5nJ3Q+66h4uEuk/hj
ymRO6HW9Q7toQUDtgl5t
=4PbR
-----END PGP SIGNATURE-----

--LQv0vi9oZBoYbpa7--
