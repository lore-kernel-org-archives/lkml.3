Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaE1RFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:05:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:43853 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaE1RFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:05:40 -0400
Date: Wed, 28 May 2014 19:05:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, eranian@google.com
Subject: Re: [RFC PATCH 6/7] perf, x86: large PEBS interrupt threshold
Message-ID: <20140528170531.GT30445@twins.programming.kicks-ass.net>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
 <1401257890-30535-7-git-send-email-zheng.z.yan@intel.com>
 <20140528081053.GP11096@twins.programming.kicks-ass.net>
 <20140528145831.GH29957@tassilo.jf.intel.com>
 <20140528153548.GY11096@twins.programming.kicks-ass.net>
 <20140528160847.GJ29957@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AA+5rdMLl4Meq7d7"
Content-Disposition: inline
In-Reply-To: <20140528160847.GJ29957@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AA+5rdMLl4Meq7d7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 09:08:47AM -0700, Andi Kleen wrote:
> On Wed, May 28, 2014 at 05:35:48PM +0200, Peter Zijlstra wrote:
> > On Wed, May 28, 2014 at 07:58:31AM -0700, Andi Kleen wrote:

> > > When a PEBS counter overflows it clears its respective GLOBAL_STATUS =
bit
> > > automatically.
> >=20
> > That's an ambiguous statement; did you mean to say a PEBS enabled
> > counter will not raise its bit in GLOBAL_STATUS on counter overflow?
>=20
> Let's revisit how PEBS works:
>=20
> - The counter overflows and sets the GLOBAL_STATUS bit
> - The PEBS assist is armed
> - The counter triggers again
> - The PEBS assist fires and delivers a PEBS record
> - Finally it clears the GLOBAL_STATUS
> - When the threshold is reached it raises an PMI
>=20
> So the GLOBAL_STATUS bit is visible between the first overflow and the en=
d=20
> of the PEBS record delivery.

OK, so that's something entirely different from what you initially said,
but it is what I thought it did -- you said that it clears on overflow,
but it clears after recording.

Lets denote the above steps as A-F and then consider the following
scenario (hmm, while drawing the states I ended up with something
different than I thought):

	Counter0	Counter1

	 0A
	 0B

			 1A
			 1B

	 0C-E
	 0F

<PMI>
			 1C-E
			 1F


If we get the PMI (where denoted) we can actually reconstruct which
event triggered, by looking at which bit(s) flipped between the recorded
state and the current state (due to E coming before F)

Now, admittedly we don't actually do that, but the below patch
implements that (I think, its not been near a compiler).

Hmm,.. .oO I think we might be able to do something similar with
multi-events, look at the next records ->state, and use the current MSR
value when there's no next record.

Thoughts?

---
 arch/x86/kernel/cpu/perf_event.h          |  2 +-
 arch/x86/kernel/cpu/perf_event_intel.c    |  2 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 21 +++++++--------------
 3 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_ev=
ent.h
index 3b2f9bdd974b..a71f6bd05f19 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -445,7 +445,7 @@ struct x86_pmu {
 			pebs_active	:1,
 			pebs_broken	:1;
 	int		pebs_record_size;
-	void		(*drain_pebs)(struct pt_regs *regs);
+	void		(*drain_pebs)(struct pt_regs *regs, u64 status);
 	struct event_constraint *pebs_constraints;
 	void		(*pebs_aliases)(struct perf_event *event);
 	int 		max_pebs_events;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/p=
erf_event_intel.c
index adb02aa62af5..3371310f200e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1386,7 +1386,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	 */
 	if (__test_and_clear_bit(62, (unsigned long *)&status)) {
 		handled++;
-		x86_pmu.drain_pebs(regs);
+		x86_pmu.drain_pebs(regs, status);
 	}
=20
 	/*
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cp=
u/perf_event_intel_ds.c
index 980970cb744d..0ad62addff7f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -953,7 +953,7 @@ static void __intel_pmu_pebs_event(struct perf_event *e=
vent,
 		x86_pmu_stop(event, 0);
 }
=20
-static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
+static void intel_pmu_drain_pebs_core(struct pt_regs *iregs, u64 status)
 {
 	struct cpu_hw_events *cpuc =3D &__get_cpu_var(cpu_hw_events);
 	struct debug_store *ds =3D cpuc->ds;
@@ -994,13 +994,12 @@ static void intel_pmu_drain_pebs_core(struct pt_regs =
*iregs)
 	__intel_pmu_pebs_event(event, iregs, at);
 }
=20
-static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
+static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs, u64 status)
 {
 	struct cpu_hw_events *cpuc =3D &__get_cpu_var(cpu_hw_events);
 	struct debug_store *ds =3D cpuc->ds;
 	struct perf_event *event =3D NULL;
 	void *at, *top;
-	u64 status =3D 0;
 	int bit;
=20
 	if (!x86_pmu.pebs_active)
@@ -1024,28 +1023,22 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs=
 *iregs)
=20
 	for (; at < top; at +=3D x86_pmu.pebs_record_size) {
 		struct pebs_record_nhm *p =3D at;
+		u64 rec_status =3D (p->status ^ status) & (cpuc->pebs_enabled & 0xFFFFFF=
FF);
=20
-		for_each_set_bit(bit, (unsigned long *)&p->status,
+		for_each_set_bit(bit, (unsigned long *)&rec_status,
 				 x86_pmu.max_pebs_events) {
 			event =3D cpuc->events[bit];
 			if (!test_bit(bit, cpuc->active_mask))
 				continue;
=20
-			WARN_ON_ONCE(!event);
-
-			if (!event->attr.precise_ip)
+			if (WARN_ON_ONCE(!event))
 				continue;
=20
-			if (__test_and_set_bit(bit, (unsigned long *)&status))
+			if (!event->attr.precise_ip)
 				continue;
=20
-			break;
+			__intel_pmu_pebs_event(event, iregs, at);
 		}
-
-		if (!event || bit >=3D x86_pmu.max_pebs_events)
-			continue;
-
-		__intel_pmu_pebs_event(event, iregs, at);
 	}
 }
=20

--AA+5rdMLl4Meq7d7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThhdbAAoJEHZH4aRLwOS6kecP/34TTRA2qL8M9d6ZYCFAhPon
c/CHPQ0Lue/ij7IVMhGSS5N1x+h44hpZubiWYUeRMYIvmdytLUWVOGunmSKMvpeW
O0cA71xs4Yg1JCI1xO5yLMBob+py1vOB0vDV0MHBEYmh7kG6NpRy2EDbvHIZNArG
mVfH5nb687phHCG2rf49DISuXqkc0cNBjmV5UMsClY7IXJy0BSttzGfesAgnIL7u
dzaSadclCpeL50e2F98iYwU+Sxnw/Dac+qvhSZhS6oRKYkVxPO6TafTeP6/4CTgl
BzBZGTpHviKy7aAEaRrmdvWtSdHXNyUxeHzwbaw/ySbEHU5kJVwprgkGgnbAHLBB
RDsMHha/L8GiuTC//HXMWHYiIj/IH71TLzatRYlK3Sc/Jd4suRoRvUc0sfYNDqXt
M0oyA1+2mZU7YCBzHNBih+Y6qVaD4RbfPeFOrosjNgj6NbvhTv90Q9vpGhV0Ir4c
CmtKC9FDu1JnclIecoH4B07vnPy0hPQZgLjUQmiGAFTDcZwA6/BNl6sU6uEgFEzN
hHBx4vkmwzE4t6XKRtWHR88gAvLe3Pas3Knjt6OKO1SMZzsZjKvucSctoi7h/Xbd
cw9ivTnPjsKHRNpb0omDjzTiZ2riPhgp3gv7PZXJ4wGkamiUv/71EdA2qnpbMOx/
nG0DyCHsUbGdmL/dShqb
=wCwt
-----END PGP SIGNATURE-----

--AA+5rdMLl4Meq7d7--
