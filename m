Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaFNGni (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 02:43:38 -0400
Received: from imap.thunk.org ([74.207.234.97]:38676 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbaFNGng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 02:43:36 -0400
Date: Sat, 14 Jun 2014 02:43:30 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
Subject: Re: [RFC] random: is the IRQF_TIMER test working as intended?
Message-ID: <20140614064330.GE6447@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, hpa@linux.intel.com,
	linux-kernel@vger.kernel.org, mingo@kernel.org, price@mit.edu
References: <20140613155241.GA4265@thunk.org>
 <20140614045520.12333.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140614045520.12333.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2014 at 12:55:20AM -0400, George Spelvin wrote:
> I'm trying to understand the entropy credit computation in
> add_interrupt_randomness.  A few things confuse me, and I'm
> wondering if it's intended to be that way.

In general, yes.  It's intended this way.  I'm trying to be extremely
conservative with my entropy measurements, and part of it is because
there is generally a huge amount of interrupts available, at least on
desktop systems, and I'd much rather be very conservative than not.

The only downside to being slow is that it takes longer to generate a
GPG key since that uses /dev/random, but I'm OK with that....

> 1) Since the number of samples between spills to the input pool is
>    variable (with > 64 samples now possible due to the trylock), wouldn't
>    it make more sense to accumulate an entropy estimate?

In general, we probably will only retry a few times, so it's not
worth it.

> 2) Why only deny entropy credit for back-to-back timer interrupts?
>    If both both t2 - x and x - t1 are worth credit, why  not for t2 - t1?
>    It seems a lot better (not to mention simpler) to not credit any
>    timer interrupt, so x - t1 will get credit but not t2 - x.
> 3) Why only consider the status of the interrupts when spills occur?
>    This is the most confusing. The whole __IRQF_TIMER and last_timer_intr
>    logic simply skips over the intermediate samples, so it actually
>    detects timer interrupts 64 interrupt (or 1 second) apart.
>    Shouldn't that sort of thing actually be looking at *consecutive*
>    calls to add_interrupt_randomness?

What I'd probably do instead is to count the number of timer
interrupts, and if it's more than 50% time interrupts, give 0 bits of
credit, else give 1 bit of credit each time we push from the fast pool
to the input pool.  Yes, that's being super conservative.

Part of this is because on modern machines most of the oscillators are
driven off of a single clock, and because not all architectures have a
timestamp clock.  We could probably be more aggressive here x86
systems, but I wouldn't be comfortable more being aggressive on ARM
systems.  And so to keep things simple, I've only given a single
credit per push.

The other reason why I haven't been in a hurry to try to be more
aggressive about entropy credit is even with the current super
conservative estimates, on my T540 laptop, I get the "nonblocking pool
is initialized" message 2.8 seconds into the boot, which is before all
of my USB devices have been enumerated, and before the root file
system is mounted (4 seconds into the boot).  Since this is well
before the SSH host keys get generated in the init scripts after the
first boot, I figured it's quite good enough.  :-)

> 4) If the above logic denies credit, why deny credit for
>    arch_get_random_seed_long as well?

Whoops, that's a bug, that was caused when I reordered the
arch_get_random_sed_long so it would be done while the spinlock was
still taken.  Thanks for pointing that out.  I'll get that fixed on
the random.git tree's dev branch.

					- Ted
