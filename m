Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab3IVXgy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 19:36:54 -0400
Received: from imap.thunk.org ([74.207.234.97]:36130 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab3IVXgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 19:36:53 -0400
Date: Sun, 22 Sep 2013 19:36:41 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: =?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>,
        John Stultz <john.stultz@linaro.org>,
        Stephan Mueller <smueller@chronox.de>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH,RFC] random: make fast_mix() honor its name
Message-ID: <20130922233641.GE7321@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	=?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>,
	John Stultz <john.stultz@linaro.org>,
	Stephan Mueller <smueller@chronox.de>,
	LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20130911005047.GA13315@thunk.org>
 <20130912210717.GC3809@logfs.org>
 <20130912233155.GB5279@thunk.org>
 <20130916154026.GA23345@logfs.org>
 <20130921212510.GD8606@thunk.org>
 <20130921214118.GE8606@thunk.org>
 <20130922030553.GA21422@thunk.org>
 <523F5AB6.8070107@web.de>
 <20130922212752.GB7321@thunk.org>
 <20130922205334.GC4584@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130922205334.GC4584@logfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22, 2013 at 04:53:34PM -0400, Jörn Engel wrote:
> 
> And I want to keep that function.  Essentially the point of fast_mix()
> is to ratelimit _mix_pool_bytes().  Naïve ratelimiting would simply
> discard the input once the ratelimit has been reached.  My proposal is
> to still use the input bits, but use a really cheap mixing function.

Sure, but how cheap is "cheap"?  There's a balance here.  I don't buy
the argument that we must weaken the fast_mix() at all costs because
we have to drive the cost of fast_mix() to zero.  If we're going to do
that, to the limit fast_mix() should be a no-op, which is ridiculous.

So what I've suggested already makes fast_mix() much faster.  It's not
fast as what you've proposed, but it's pretty clear that my fast_mix()
is better at mixing the fast_mix pool.

> Your version of fast_mix() failed in the "really cheap" department.
> As a result, it showed up in profiles and at least one idiot (me)
> reverted to naïve ratelimiting.  It could have been worse, I was
> explicitly asked twice to just remove the call to
> add_interrupt_randomness().

Sure, but that's not _my_ problem.  If someone stupid adulterates
/dev/random, that's not my responsibility.  Most people aren't going
to be dealing with systems with truly stupid interrupt rates, and most
people aren't going to be tampering with the random driver.

I'm certainly willing to make fast_mix() faster, to reduce the
temptation for idiots to tamper with /dev/random, but we need to
balance the time of fast_mix() with the quality of its mixing, and to
remember what the common case is (and it's not 100k interrupts per
second!)

> And you should do the same for add_timer_randomness(), where again you
> have ratelimiting.  Once trickle_thresh is reached your code simply
> discards most randomness.  

In practice, we are using randomness in so many places (every single
time we start a process for ASLR, in lots of security-related programs
that use SSL libraries, etc.), that we are actually practically
*never* hitting trickle_thresh.

The trickle_thresh was added originally when add_timer_randomness()
was used for interrupts that used SA_SAMPLE_RANDOM.  Given that we
don't use add_timer_randomness() for that, but for things that happen
much more rarely (i.e., such as keyboard/mouse input), I'm probably
going to end up removing the trickle thresh_check altogether.

Regards,

					- Ted
