Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab3KCMlm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 07:41:42 -0500
Received: from imap.thunk.org ([74.207.234.97]:53755 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab3KCMlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 07:41:40 -0500
Date: Sun, 3 Nov 2013 07:41:35 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Stephan Mueller <smueller@chronox.de>
Cc: Pavel Machek <pavel@ucw.cz>, sandy harris <sandyinchina@gmail.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
Message-ID: <20131103124135.GB32091@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>, Pavel Machek <pavel@ucw.cz>,
	sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
References: <2579337.FPgJGgHYdz@tauon>
 <7861469.OAmn4h8An0@tauon>
 <20131102110112.GA16231@amd.pavel.ucw.cz>
 <3537770.iLHXPOXMiU@tauon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3537770.iLHXPOXMiU@tauon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 03, 2013 at 08:20:34AM +0100, Stephan Mueller wrote:
> Another friend of mine mentioned that he assumes the rise and fall times 
> of transistors varies very slightly and could be the main reason for the 
> jitter. I do not think that this is really the case, because our gates 
> that form the CPU instructions comprise of many transistors. The 
> combined raise/fall jitter should cancel each other out.

The whole point of using a clocked architecture for digital circuitry
is to avoid differences in the rise/fall times of transitors to lead
to non-deterministic behavior --- which is important if you want to
make sure that 2 * 2 == 4 and not 3.99999999.....

The one place where you might find differences is when you have
different subsystems which are clocked using different clock sources,
and then there's extra circuitry that has to be needed to handle
interfacing between those differently clocked circuit areas.

The problem, though is that over time, these boundaries can change; it
may be that on certain chipsets, things that had been in different
clock circuits, have later been integrated onto a single
system-on-chip device and all run off of a single clock source.

> That said, the full root cause is is not really known at this time 
> considering that major chip vendors have no real clue either.

I have trouble beliving that statement; they might not be willing to
comment, since to do so would expose a internal CPU designs which they
consider secret, or worse, it might cause people to depend on certain
implementation details which might not be true in future chipsets ---
which may either tie their hands, or they may even know that it won't
be true for CPU version currently under development but not yet
released.

Sandy Harris pointed out a very good paper that I would definitely
recommend that people read:

http://lwn.net/images/conf/rtlws11/random-hardware.pdf

It basically describes some efforts made in 2009 by folks to do
exactly the sort of experiments I was advocating.  What I actually
think is more important, though, is not the doing of the experiments,
but the development the tools to do these experiments.  If people can
create kernel modules (and they have to be done in the kernel, since
you need to be able to disable interrupts, L1 caches, etc., while you
run these tests), then it will be possible to do these experiments
each time a new CPU comes out from Intel, or each time an ARM hardware
vendor comes out with a new ARM SOC.

It's important that these tests are done all time, and not, "OK, we
did some tests in 2009 or 2013, and things looked good, and we don't
have to worry about this any more; CPU-generated entropy is guaranteed
to be good!"  We need to make sure we can easily do these tests all
the time, for every new piece of hardware out there --- and when we
can't explain where the entropy is coming from, we need to be doubly
on our guard.

Regards,

					- Ted

