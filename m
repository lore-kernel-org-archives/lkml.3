Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab3IJSZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 14:25:31 -0400
Received: from imap.thunk.org ([74.207.234.97]:57772 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab3IJSZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 14:25:30 -0400
Date: Tue, 10 Sep 2013 14:25:24 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Stephan Mueller <smueller@chronox.de>
Cc: LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many
 architectures
Message-ID: <20130910182524.GE29237@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>,
	LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net
References: <10005394.BRCyBMYWy3@tauon>
 <20130910150419.GA29237@thunk.org>
 <2722901.IcH4JOB8ab@tauon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2722901.IcH4JOB8ab@tauon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 06:54:38PM +0200, Stephan Mueller wrote:
> 
> Why do you say that clocksource is heavyweight? Yes, there is a bit more 
> code than for get_cycles, but that is all just leading to usually an 
> equally small clock read code as get_cycles.

I've had past experiences where a clock source can be *very*
expensive.  One such example was the IBM x440 server, where
gettimeofday() ended up requiring a fetching the clock across the
"scalability cable" (which connected up to 3 other boxes, each box
containing 4 CPU sockets --- this was a big, nasty NUMA system), and
it was expensive enough that a financial firm that was trying to get a
hard timestamp for every single stock transaction had its performance
hit massively.  And this was something running in userspace.  Remember
what I said, this is being done on *every* *single* *interrupt*.

The bigger problem is that people will scream about the performance
overhead, and then patches to remove the /dev/random hooks from the
core irq code will start showing up on LKML.  This is originally how
the SA_SAMPLE_RANDOM sampling got removed from device drivers, and I'm
sensitive to the fact that not everyone on LKML cares as much about
security, and many people are near fanatical about performance.  So I
don't want this to be a CONFIG option or a run-time option (since
distributions will be tempted to turn it off to win the performance
benchmarking war).  Maybe not right now, when everyone is all worked
up about the NSA.  But in the long term, I don't want anyone to have
an excuse to have the entropy sampling removed due to performance
reasons.

> Moreover, until having your proposed real fix, wouldn't it make sense to 
> have an interim patch to ensure we have entropy on the mentioned 
> platforms? I think /dev/random is critical enough to warrant some cache 
> miss even per interrupt?

We are already mixing in the IP from the saved irq registers, on every
single interrupt, so we are mixing in some entropy.  We would get more
entropy if we had a good cycle counter to mix in, but it's not the
case that we're completely exposed right now on those platforms which
don't have get_cycles() implemented.  If the system running so lock
step that the location of the interrupts is utterly predictable, then
it's not clear that using a clock source is going to help you....

Also note that the clocksource is not necessarily be the best choice;
it may not be the most fine grained sampling that we have available
(that is certainly be true for MIPS).  So doing something hacky
doesn't absolve us from the need to example every single platform that
as a no-op get_cycles() function.  (Well, at least those platforms
that we think really are going to be running security sensitive
systems ---- does anyone think we really have production systems
running m68k?  Maybe, but....)

If we believed that /dev/random was actually returning numbers which
are exploitable, because of this, I might agree with the "we must do
SOMETHING" attitude.  But I don't believe this to be the case.  Also
note that we're talking about embedded platforms, where upgrade cycles
are measured in years --- if you're lucky.  There are probably home
routers still stuck on 2.6, at which point they will be far more
succeptible to the problems described at http://factorable.net.

So I don't think we need to rush.  I'd much rather make sure we get
this fixed right.

					- Ted
