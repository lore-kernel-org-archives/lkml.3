Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbaHNVRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 17:17:12 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53093 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbaHNVRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 17:17:11 -0400
Date: Thu, 14 Aug 2014 23:16:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, changcheng.liu@intel.com,
        xiaoming.wang@intel.com, souvik.k.chakravarty@intel.com
Subject: Re: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
 back to DEFAULT
Message-ID: <20140814211656.GV19379@twins.programming.kicks-ass.net>
References: <1407982309-4863-1-git-send-email-chuansheng.liu@intel.com>
 <CAKnoXLw3DrBAxCUWEkXtvCTf+E1w0xTHJSiSUY6Qd6xHXeGaoQ@mail.gmail.com>
 <20140814110040.GI16043@twins.programming.kicks-ass.net>
 <53EC9A29.8090408@linaro.org>
 <53ED263B.7030703@mit.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x/MiiZOMPHfEg/B6"
Content-Disposition: inline
In-Reply-To: <53ED263B.7030703@mit.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x/MiiZOMPHfEg/B6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 14, 2014 at 02:12:27PM -0700, Andy Lutomirski wrote:
> On 08/14/2014 04:14 AM, Daniel Lezcano wrote:
> > On 08/14/2014 01:00 PM, Peter Zijlstra wrote:
> >>
> >> So seeing how you're from @intel.com I'm assuming you're using x86 her=
e.
> >>
> >> I'm not seeing how this can be possible, MWAIT is interrupted by IPIs
> >> just fine, which means we'll fall out of the cpuidle_enter(), which
> >> means we'll cpuidle_reflect(), and then leave cpuidle_idle_call().
> >>
> >> It will indeed not leave the cpu_idle_loop() function and go right back
> >> into cpuidle_idle_call(), but that will then call cpuidle_select() whi=
ch
> >> should pick a new C state.
> >>
> >> So the interrupt _should_ work. If it doesn't you need to explain why.
> >=20
> > I think the issue is related to the poll_idle state, in
> > drivers/cpuidle/driver.c. This state is x86 specific and inserted in the
> > cpuidle table as the state 0 (POLL). There is no mwait for this state.
> > It is a bit confusing because this state is not listed in the acpi /
> > intel idle driver but inserted implicitly at the beginning of the idle
> > table by the cpuidle framework when the driver is registered.
> >=20
> > static int poll_idle(struct cpuidle_device *dev,
> >                 struct cpuidle_driver *drv, int index)
> > {
> >         local_irq_enable();
> >         if (!current_set_polling_and_test()) {
> >                 while (!need_resched())
> >                         cpu_relax();
> >         }
> >         current_clr_polling();
> >=20
> >         return index;
> > }
>=20
> As the most recent person to have modified this function, and as an
> avowed hater of pointless IPIs, let me ask a rather different question:
> why are you sending IPIs at all?  As of Linux 3.16, poll_idle actually
> supports the polling idle interface :)
>=20
> Can't you just do:
>=20
> if (set_nr_if_polling(rq->idle)) {
> 	trace_sched_wake_idle_without_ipi(cpu);
> } else {
> 	spin_lock_irqsave(&rq->lock, flags);
> 	if (rq->curr =3D=3D rq->idle)
> 		smp_send_reschedule(cpu);
> 	// else the CPU wasn't idle; nothing to do
> 	raw_spin_unlock_irqrestore(&rq->lock, flags);
> }
>=20
> In the common case (wake from C0, i.e. polling idle), this will skip the
> IPI entirely unless you race with idle entry/exit, saving a few more
> precious electrons and all of the latency involved in poking the APIC
> registers.

They could and they probably should, but that logic should _not_ live in
the cpuidle driver.

And as stated elsewhere in the thread; they also need to fix their
kick_all_cpus_sync() usage, because that's similarly wrecked.

--x/MiiZOMPHfEg/B6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT7SdIAAoJEHZH4aRLwOS6Y8AQAIZ8mOTQSYlXzJsXHlFJM/Lg
tWL7ZVd8anGVhNXmu/xm4wvhDsr4x4ptuQm2FjpCs6HQT34oVpqYxPkoxwezWhNM
ZIFImtG2tUu0f4KHR5OqmRzZdTf1UMc/IAQkOStfS8he91RudwF4AQWqQR8+zq/c
DEtyE3llAz5hOfrTksABdFmF1T/V57foxQy+AJgndZc7et2l7Y0mSRqbd4gOoVM9
w9Q3fdhl33v2sF2uI6BhskQqEfyDLsVhpHp/UH5M2KX3jdJ8bub2XEMUu5pWzR7q
lgRWx6pHBJwEtFHvVhmqX7AcPxw43/CoPHvofe4Qd/SWUX201hSssxgtsPHv9oW9
oJg0Oi446f0m9wyeLykKy1qEhOfgAA7gUv74Vetm3H5p1MgwXYENwKl2aBJkxwEH
VCU/8DaE5e/e8++WWG4+07KPet9e6wjKzXmiQ77MTwYBCTVUFbS402LmE2ASEPRa
tn7vC9zqwvcP1xZzWKF0bd5h8knEP6JWwCtjGxZrlag62T8INTFNE/ydAIuXA3Yx
nXM53QQRwZwo5W/EJa4LgGr5J+htrg+JEuFLtRtFMH+LF/3Kb4s9y11wpXZwrjpL
bqPlWn8rHnIHlYDaGJeNUiYGTqDEA6zOj7vPOO8HuX9v1itpGkuSaIu1IHiQnJUb
4cb7gS1NqKxuu5O6cCV5
=97q6
-----END PGP SIGNATURE-----

--x/MiiZOMPHfEg/B6--
