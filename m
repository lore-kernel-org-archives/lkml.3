Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaEIEt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 00:49:56 -0400
Received: from ozlabs.org ([103.22.144.67]:58724 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbaEIEty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 00:49:54 -0400
Date: Fri, 9 May 2014 14:49:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the tip tree with the pm tree
Message-ID: <20140509144947.1dcd9098@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/sNmt7wKtKJpK+8e8tMyrBE3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/sNmt7wKtKJpK+8e8tMyrBE3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
kernel/sched/idle.c between commit 52c324f8a87b ("cpuidle: Combine
cpuidle_enabled() with cpuidle_select()") from the pm tree and commit
37352273ad48 ("sched/idle: Reflow cpuidle_idle_call()") from the tip
tree.

I fixed it up (I hope - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/sched/idle.c
index a8f12247ce7c,34083c9ac976..000000000000
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@@ -101,77 -98,74 +98,69 @@@ static void cpuidle_idle_call(void
  	rcu_idle_enter();
 =20
  	/*
 -	 * Check if the cpuidle framework is ready, otherwise fallback
 -	 * to the default arch specific idle method
 +	 * Ask the cpuidle framework to choose a convenient idle state.
 +	 * Fall back to the default arch specific idle method on errors.
  	 */
 -	if (cpuidle_enabled(drv, dev)) {
 +	next_state =3D cpuidle_select(drv, dev);
 +
- 	ret =3D next_state;
- 	if (ret >=3D 0) {
++	if (next_state < 0) {
+ use_default:
  		/*
- 		 * The idle task must be scheduled, it is pointless to
- 		 * go to idle, just update no idle residency and get
- 		 * out of this function
+ 		 * We can't use the cpuidle framework, let's use the default
+ 		 * idle routine.
  		 */
- 		if (current_clr_polling_and_test()) {
- 			dev->last_residency =3D 0;
- 			entered_state =3D next_state;
+ 		if (current_clr_polling_and_test())
  			local_irq_enable();
- 		} else {
- 			broadcast =3D !!(drv->states[next_state].flags &
- 				       CPUIDLE_FLAG_TIMER_STOP);
-=20
- 			if (broadcast)
- 				/*
- 				 * Tell the time framework to switch
- 				 * to a broadcast timer because our
- 				 * local timer will be shutdown. If a
- 				 * local timer is used from another
- 				 * cpu as a broadcast timer, this call
- 				 * may fail if it is not available
- 				 */
- 				ret =3D clockevents_notify(
- 					CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
- 					&dev->cpu);
-=20
- 			if (ret >=3D 0) {
- 				trace_cpu_idle_rcuidle(next_state, dev->cpu);
-=20
- 				/*
- 				 * Enter the idle state previously
- 				 * returned by the governor
- 				 * decision. This function will block
- 				 * until an interrupt occurs and will
- 				 * take care of re-enabling the local
- 				 * interrupts
- 				 */
- 				entered_state =3D cpuidle_enter(drv, dev,
- 							      next_state);
-=20
- 				trace_cpu_idle_rcuidle(PWR_EVENT_EXIT,
- 						       dev->cpu);
-=20
- 				if (broadcast)
- 					clockevents_notify(
- 						CLOCK_EVT_NOTIFY_BROADCAST_EXIT,
- 						&dev->cpu);
-=20
- 				/*
- 				 * Give the governor an opportunity to reflect on the
- 				 * outcome
- 				 */
- 				cpuidle_reflect(dev, entered_state);
- 			}
- 		}
+ 		else
+ 			arch_cpu_idle();
+=20
+ 		goto exit_idle;
+ 	}
+=20
+ 	/*
 -	 * Ask the governor to choose an idle state it thinks
 -	 * it is convenient to go to. There is *always* a
 -	 * convenient idle state
 -	 */
 -	next_state =3D cpuidle_select(drv, dev);
 -
 -	/*
+ 	 * The idle task must be scheduled, it is pointless to
+ 	 * go to idle, just update no idle residency and get
+ 	 * out of this function
+ 	 */
+ 	if (current_clr_polling_and_test()) {
+ 		dev->last_residency =3D 0;
+ 		entered_state =3D next_state;
+ 		local_irq_enable();
+ 		goto exit_idle;
  	}
 =20
+ 	broadcast =3D !!(drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP=
);
+=20
  	/*
- 	 * We can't use the cpuidle framework, let's use the default
- 	 * idle routine
+ 	 * Tell the time framework to switch to a broadcast timer
+ 	 * because our local timer will be shutdown. If a local timer
+ 	 * is used from another cpu as a broadcast timer, this call may
+ 	 * fail if it is not available
  	 */
- 	if (ret < 0)
- 		arch_cpu_idle();
+ 	if (broadcast &&
 -	    clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu))
++	    clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu) < 0)
+ 		goto use_default;
 =20
+ 	trace_cpu_idle_rcuidle(next_state, dev->cpu);
+=20
+ 	/*
+ 	 * Enter the idle state previously returned by the governor decision.
+ 	 * This function will block until an interrupt occurs and will take
+ 	 * care of re-enabling the local interrupts
+ 	 */
+ 	entered_state =3D cpuidle_enter(drv, dev, next_state);
+=20
+ 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
+=20
+ 	if (broadcast)
+ 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
+=20
+ 	/*
+ 	 * Give the governor an opportunity to reflect on the outcome
+ 	 */
+ 	cpuidle_reflect(dev, entered_state);
+=20
+ exit_idle:
  	__current_set_polling();
 =20
  	/*

--Sig_/sNmt7wKtKJpK+8e8tMyrBE3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTbF5vAAoJEMDTa8Ir7ZwVOoEP/1//AeKYCr5WfCxPEbrOktDx
SIe20pvUDPX5TD/gHJdVxo6SIhBlwFoifp3u55xLt1mnzHLxJ9AecgEElv2Vumfi
yvShwvevLI4L6d5yRYN5t/hUf6v2q447NqPM3Be+GwWfE9ZSboVizkPaIrhWSpl+
mVXGuLDcYrpaRGN09Dwnc/EorVKygVs1W6NRC6J9GI/erUOPogkS6iH61bBvi2xr
9FVNpCssuEd2Wgc0p+PQJCbrOwuTotI6eM1L2JH0Z4GvYjVTJLYY3iwbVwGMWCR5
uLMXLCUfap9qBLCa6sGk0QouW4NLh1Efga/O06dQsA49c0XFeCFpLyXzmcPemcQ/
9jMeDnIMsJWOlLr2J6haAoI+F3I+kbQhSuvZXReXSeW4Y2/lomj4G7zvMZdWju31
gIGeDF0/cnoBLg5PG8btyl+R4mPTqqaNOMFEIgNmjHXkw7O+VX2hBlAFCikxTZbj
E+5eCuiiE+Kkb6tQfNakYF4vIlA6LFjPSJX0p0oYp8k7YFZfOXeFoka1hiNSvXXc
tht562HWMdj6vMFBg6uMiRCYyBvW/XSzyUZ0IavvYtwjfq+EoBsra8dvlSyLe8nL
wnhi/9DT0LM/sgLVIE/3bQ7Gilk799+hC4g2F4D3c3q2N6DIUdpwCWj5N6mhNsvM
Hgv5rk1zjAhftqG36jMn
=wqNo
-----END PGP SIGNATURE-----

--Sig_/sNmt7wKtKJpK+8e8tMyrBE3--
