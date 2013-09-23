Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab3IWBez (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 21:34:55 -0400
Received: from longford.logfs.org ([213.229.74.203]:57953 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab3IWBex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 21:34:53 -0400
Date: Sun, 22 Sep 2013 20:16:23 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: =?utf-8?Q?J=C3=B6rg-Volker?= Peetz <jvpeetz@web.de>,
        John Stultz <john.stultz@linaro.org>,
        Stephan Mueller <smueller@chronox.de>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH,RFC] random: make fast_mix() honor its name
Message-ID: <20130923001623.GD4584@logfs.org>
References: <20130912210717.GC3809@logfs.org>
 <20130912233155.GB5279@thunk.org>
 <20130916154026.GA23345@logfs.org>
 <20130921212510.GD8606@thunk.org>
 <20130921214118.GE8606@thunk.org>
 <20130922030553.GA21422@thunk.org>
 <523F5AB6.8070107@web.de>
 <20130922212752.GB7321@thunk.org>
 <20130922205334.GC4584@logfs.org>
 <20130922233641.GE7321@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130922233641.GE7321@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 September 2013 19:36:41 -0400, Theodore Ts'o wrote:
> On Sun, Sep 22, 2013 at 04:53:34PM -0400, Jörn Engel wrote:
> > 
> > And I want to keep that function.  Essentially the point of fast_mix()
> > is to ratelimit _mix_pool_bytes().  Naïve ratelimiting would simply
> > discard the input once the ratelimit has been reached.  My proposal is
> > to still use the input bits, but use a really cheap mixing function.
> 
> Sure, but how cheap is "cheap"?  There's a balance here.  I don't buy
> the argument that we must weaken the fast_mix() at all costs because
> we have to drive the cost of fast_mix() to zero.  If we're going to do
> that, to the limit fast_mix() should be a no-op, which is ridiculous.

Agreed.  We always have a tradeoff between quality and cost.  And I
repeat yet again that driving the cost down is important, because it
allows us to collect entropy more often.  The schedule is an entropy
source I would like to tap.

> So what I've suggested already makes fast_mix() much faster.  It's not
> fast as what you've proposed, but it's pretty clear that my fast_mix()
> is better at mixing the fast_mix pool.

Agreed.

> > Your version of fast_mix() failed in the "really cheap" department.
> > As a result, it showed up in profiles and at least one idiot (me)
> > reverted to naïve ratelimiting.  It could have been worse, I was
> > explicitly asked twice to just remove the call to
> > add_interrupt_randomness().
> 
> Sure, but that's not _my_ problem.  If someone stupid adulterates
> /dev/random, that's not my responsibility.  Most people aren't going
> to be dealing with systems with truly stupid interrupt rates, and most
> people aren't going to be tampering with the random driver.

This is where I don't agree.  I very much care even about the plastic
routers running some variant of Linux modified by some embedded
engineers under insane time pressure.  If you leave them an incentive
to cripple the random generator, some of them will.  If you find
source code with a maliciously crippled random generator, the author
has plausible deniability.

So this should be _our_ problem.  Maybe not yours specifically, but
certainly that of kernel developers in general.

> I'm certainly willing to make fast_mix() faster, to reduce the
> temptation for idiots to tamper with /dev/random, but we need to
> balance the time of fast_mix() with the quality of its mixing, and to
> remember what the common case is (and it's not 100k interrupts per
> second!)

How about we switch between the two mixing functions depending on the
interrupt load?  If this CPU has seen fewer than 1000 interrupts in
the last second, use the better one, otherwise us the cheaper one?

I don't really like the idea too much.  But it would cover both the
common case and my particular degenerated one.

> In practice, we are using randomness in so many places (every single
> time we start a process for ASLR, in lots of security-related programs
> that use SSL libraries, etc.), that we are actually practically
> *never* hitting trickle_thresh.
> 
> The trickle_thresh was added originally when add_timer_randomness()
> was used for interrupts that used SA_SAMPLE_RANDOM.  Given that we
> don't use add_timer_randomness() for that, but for things that happen
> much more rarely (i.e., such as keyboard/mouse input), I'm probably
> going to end up removing the trickle thresh_check altogether.

Makes sense to me.

Jörn

--
Doubt is not a pleasant condition, but certainty is an absurd one.
-- Voltaire
