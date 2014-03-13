Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaCMBBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 21:01:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:46757 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaCMBBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 21:01:21 -0400
Date: Thu, 13 Mar 2014 02:01:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: joeyli <jlee@suse.com>, Julian Wollrath <jwollrath@web.de>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Stultz <john.stultz@linaro.org>,
        "Ted Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
In-Reply-To: <alpine.DEB.2.02.1403130049500.18573@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.02.1403130154560.18573@ionos.tec.linutronix.de>
References: <20140310110410.5b2218f6@ilfaris> <alpine.DEB.2.02.1403121722030.18573@ionos.tec.linutronix.de> <alpine.DEB.2.02.1403121729060.18573@ionos.tec.linutronix.de> <1554867.utJVyPuT6A@vostro.rjw.lan>
 <alpine.DEB.2.02.1403130049500.18573@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2014, Thomas Gleixner wrote:

> On Thu, 13 Mar 2014, Rafael J. Wysocki wrote:
> > Thus follow the original idea to execute acpi_early_init() before
> > efi_enter_virtual_mode() to help the EFI people for now and we can
> > revisit the other problem that commit 73f7d1ca3263 attempted to
> > address in the future (if really necessary).
> 
> It's not necessary at all. In fact we really want to get rid of the
> arch specific cmos stuff which is an historical leftover.
> 
> I talked to John Stultz earlier today and he agrees that there are
> only a few trivial things to add to the RTC subsystem to make this
> work.
> 
> From the timekeeping POV there is absolutely no need to set the wall
> clock time early. The kernel boot phase does not care about wall time
> at all. We should have it done before we hit userspace, but not even
> that is a hard requirement.
> 
> That TAD/EFI time mess is not going to happen before that is solved.

Though there was one odd request versus randomness to take the RTC
into account very early on boot. I really can't make any sense of it.

How helpful is entropy which is added by something which can be
reevaluated by looking at the boot time? The randomness factor of the
standard 1 sec resolution is not that amazing either.

Why don't we make use of the inherent randomness of todays cpus which
will help ALL architectures and systems independent of early RTC
availablity? Something along these lines will add a way better initial
entropy than any RTC can provide:

u64 random_init(void)
{
	u64 i = 0, tmp = SEED, t = sched_clock();
	u64 rnd = (long) t;

	for (; (sched_clock() < (t + X) && i < MINLOOPS; tmp += SOMETHING, i++)
	      rnd = some_useful_rng_algo(rnd, tmp, sched_clock());

	return rnd;
}

Tune X and MINLOOPS to your needs and place the call of random_init()
to a point where most sane systems have reached the point where a high
resolution sched_clock is available and the system is
preemtible. That's the case quite early in the boot process. Add a
synchronization point to finalize that before we have any serious
user.

Even if no high resolution sched clock is available at this point the
randomness of the call versus the breakout of the loop will be unique
per boot process and way better than anything we have right now all
across the architecture space.

Add some randomness injection from the sched_clock() based runtime of
the various initcalls to it and we have a way better baseline than we
have now for all of our architectures.

Enforcing some early RTC availability for the sake of randomness does
not make sense when we do not exploit better sources which are
available on all systems in the first place.

Thanks,

	tglx
