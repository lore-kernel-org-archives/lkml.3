Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762643AbaGRWlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 18:41:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:46880 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaGRWlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 18:41:12 -0400
Date: Sat, 19 Jul 2014 00:41:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Baruch Siach <baruch@tkos.co.il>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] sched_clock: Track monotonic raw clock
Message-ID: <20140718224100.GV3588@twins.programming.kicks-ass.net>
References: <1405705419-4194-1-git-send-email-pawel.moll@arm.com>
 <20140718191338.GF3935@laptop>
 <CALAqxLX4ia_dBO-oNY1XMnSrJdDZc87EneHj9WcxtOZaupZaCg@mail.gmail.com>
 <20140718193417.GG3935@laptop>
 <53C97995.2090500@linaro.org>
 <20140718202250.GR9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7XuS4gr/+Xj300Yp"
Content-Disposition: inline
In-Reply-To: <20140718202250.GR9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7XuS4gr/+Xj300Yp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2014 at 10:22:50PM +0200, Peter Zijlstra wrote:
> So the generic stuff seems optimized for 32bit arch, short clocks and
> seems to hard assume the clock is globally consistent.
>=20
> The x86 sched_clock code is optimized for 64bit, has a full 64bit clock
> and cannot ever assume the thing is globally consistent (until Intel/AMD
> stop making the TSC register writable -- including, and maybe
> especially, for SMM).
>=20
> There is just not much that overlaps there.

So something that might be usable for all of us would be the
'abstracted' control loop.

So the problem is, given a Set Point (CLOCK_MONOTONIC_RAW), a Process
Variable (sched_clock) compute a Control Output (multiplier).

If that were implemented with an interface like:


struct sched_clock_cl; /* Control Loop state */

/**
 * sched_clock_cl_init - intialize the control loop
 */
extern void sched_clock_cl_init(struct sched_clock_cl *sccl, u32 mult, u32 =
shift);

/**
 * sched_clock_cl_update - compute a new multiplier for sched_clock
 * @sccl - pointer to control loop state structure
 * @sp - current set-point, aka. CLOCK_MONOTONIC_RAW
 * @pv - current process-variable, aka. sched_clock()
 */
extern u32 sched_clock_cl_update(struct sched_clock_cl *sccl, u64 sp, u64 p=
v);


That way I can run one per-cpu and try and keep each individual CPU
synced up to CLOCK_MONOTONIC_RAW, thereby also providing some inter-cpu
guarantee (due to max error bounds on the control loop, etc..).

And you can run a single instance for the generic sched_clock code,
since that's globally consistent.

And we'd all still be using the same control loop logic.

Now, I already mentioned max error bounds, and I've not yet looked at
your actual control loop, but that is something to keep in mind, we want
something that's limited.

If we can do this (and I'm fairly sure we can) we can in fact kill some
rather ugly code.

--7XuS4gr/+Xj300Yp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTyaJ1AAoJEHZH4aRLwOS6sAsP/1IN3/S99hJ5vgiuZLWn6fUT
alsYagr/pELaef1GwwQAsyFDsUB1AeAwXdQVglDV2xiGbhwXAHcmB/ev4KMLw8yN
eRjD/LMqswjl4ZzLvFhfkfnNlau7+UxAL6Pqr8rSXJvL8hORGe2Fty2ASd5g1SPp
hA4HcUwU88cNYHDZaXfB0saEXK7sdrcvjizwJqGkMNGbmp+TGYPtrtpSRszzWuyx
w7qYMpMSJq8o/JwMOTMjOLFYOyGYTDePsAPUXH0LOgaHY5graLfcMSPqNiTKaZ4H
cNYRejd83fwswKTU0ougPGIQ6u98Rnk5p0H9+RvojR6sQmZi/g80HxBdqgjmp1Tz
10Ie4tBNr7fucNswLoUQcTAX7aWBAvZFQLjxyvdx+lEjmteGBtKgrpTzM1BLN5jr
1uILr8E//hovjS8AdFp/mEJXR0cWCjXo30LnCytCsXsQqRKQ5nEs4+60lFasV/Uq
HJfTyHuIRw4dU4PcQzDuVrkNWtnWmrr9ZoizPd8Gum4n2NajU8qXF+QpqUfpJXLB
WqH7vaFI82cND3NCh8G4aOAnDAgbUT/rOZUTQJnKIdMGp7M++NSFZClPoiiaaji8
cOqj5eaPUlwQ0grb3+42CaUawYc2yHUcrAZArmm+Gse9qAprtAP2tBKnEmBbTX3n
SedMu9sQpLKkRWJWEw6c
=+UwI
-----END PGP SIGNATURE-----

--7XuS4gr/+Xj300Yp--
