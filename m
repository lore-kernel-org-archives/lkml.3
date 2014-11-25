Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaKYHUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 02:20:36 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:58254 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaKYHUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 02:20:25 -0500
X-Originating-IP: 50.43.41.112
Date: Mon, 24 Nov 2014 23:20:13 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux-Next <linux-next@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Catalina Mocanu <catalina.mocanu@gmail.com>
Subject: Re: linux-next: manual merge of the tiny tree with the tip tree
Message-ID: <20141125072013.GB1691@thin>
References: <20141125170315.13157c60@canb.auug.org.au>
 <20141125061645.GA15512@gmail.com>
 <CALAqxLUKM7VyB6MW=-Mm+NA2pOEtD1CP3FxrmA_1gCucGon4hA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLUKM7VyB6MW=-Mm+NA2pOEtD1CP3FxrmA_1gCucGon4hA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 10:30:10PM -0800, John Stultz wrote:
> On Mon, Nov 24, 2014 at 10:16 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> >> Hi Josh,
> >>
> >> Today's linux-next merge of the tiny tree got a conflict in
> >> kernel/time/Makefile between commit fd866e2b116b ("time: Rename
> >> udelay_test.c to test_udelay.c") from the tip tree and commit
> >> d1f6d68d03ea ("kernel: time: Compile out NTP support") from the tiny
> >> tree.
> >
> > So I think a timer subsystem commit d1f6d68d03ea with this
> > magnitude of linecount increase:
> >
> >  Signed-off-by: Catalina Mocanu <catalina.mocanu@gmail.com>
> >  [josh: Handle CONFIG_COMPAT=y.]
> >  Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> >  Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> >  ---
> >   drivers/pps/Kconfig        |  2 +-
> >   include/linux/timex.h      | 15 +++++++++++++--
> >   init/Kconfig               | 10 ++++++++++
> >   kernel/compat.c            |  8 ++++++--
> >   kernel/sys_ni.c            |  4 ++++
> >   kernel/time/Makefile       |  3 ++-
> >   kernel/time/ntp_internal.h | 28 ++++++++++++++++++++++++++++
> >   kernel/time/posix-timers.c |  2 ++
> >   kernel/time/time.c         |  2 ++
> >   kernel/time/timekeeping.c  |  2 ++
> >   10 files changed, 70 insertions(+), 6 deletions(-)
> >
> > at minimum needs the ack of timer folks, before it can be
> > committed to Git. Or is the tiny tree plan to submit all
> > patches to the appropriate subsystem or gather acks, before
> > sending it upstream?
> 
> Yea.  From first glance d1f6d68d03ea looks fairly broken.
> 
> Returning 0 for ntp_tick_length() (which should be the current tick
> length in NTP_SCALE_SHIFT shifted ns), seems like it would cause major
> timekeeping problems.

Ouch, yeah; I'm impressed the kernel successfully booted that way (which
I did test).

Computing the tick_length to return seems to require a div_u64; is it
safe to initialize a static const with the result of calling div_u64, or
does the intializer need manual constant-folding to make the expression
compile-time computable?

Going by the logic in ntp_update_frequency, it looks like the stub
ntp_tick_length needs to return:

tick_length_base = 0;
tick_usec = TICK_USEC;
second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ) << NTP_SCALE_SHIFT;
new_base = div_u64(second_length, NTP_INTERVAL_FREQ);
tick_length += new_base - tick_length_base;

(tick_length starts out 0, gets new_base - 0 added initially, and every
subsequent time gets 0 added since tick_length_base won't change.)

Substituting and simplifying:

tick_length = new_base
            = div_u64(second_length, NTP_INTERVAL_FREQ)
            = div_u64((TICK_USEC * NSEC_PER_USEC * USER_HZ) << NTP_SCALE_SHIFT, NTP_INTERVAL_FREQ)

The numerator there could potentially be simplified, but I don't see an
obvious way around the division by NTP_INTERVAL_FREQ (defined as HZ).

- Josh Triplett
