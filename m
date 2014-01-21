Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbaAULnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 06:43:00 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:19589 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754179AbaAULm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 06:42:58 -0500
Date: Tue, 21 Jan 2014 11:42:25 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "markgross@thegnar.org" <markgross@thegnar.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [11/11] system 1: Saving energy using DVFS
Message-ID: <20140121114225.GC14830@arm.com>
References: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
 <1389111587-5923-12-git-send-email-morten.rasmussen@arm.com>
 <20140120164926.GB23051@amd.pavel.ucw.cz>
 <20140120171010.GB29971@arm.com>
 <20140120181208.GC25439@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120181208.GC25439@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 06:12:08PM +0000, Pavel Machek wrote:
> > > Sleeping CPU: 2mA
> > > Screen on: 230mA
> > > CPU loaded: 250mA
> > > 
> > > Now, lets believe your numbers and pretend system can operate at 33%
> > > of speed with 11% power consumption.
> > > 
> > > Lets take task that takes 10 seconds on max frequency:
> > > 
> > >       ~ 10s * 470mA     	     	    = 4700mAs
> > > 
> > > You suggest running at 33% speed, instead; that means 30 seconds on
> > > low requency.
> > > 
> > > CPU on low: 25mA (assumed).
> > > 
> > >      ~ 30s * 255mA			    = 7650mAs
> > > 
> > > Hmm. So race to idle is good thing on Intel machines, and it is good
> > > thing on ARM design I have access to.
> > 
> > Race to idle doesn't mean that the screen goes off as well. Let's say
> > the screen stays on for 1 min and the CPU needs to be running for 10s
> > over this minute, in the first case you have:
> > 
> > 	10s & 250mA + 60s * 230mA = 16300mAs
> > 
> > in the second case you have:
> > 
> > 	30s * 25mA + 60s * 230mA = 14550mAs
> > 
> > That's a 1750mAs difference. There are of course other parts drawing
> > current but simple things like the above really make a difference in the
> > mobile space, both in terms of battery and thermal budget.
> 
> Aha, I noticed the values are now the other way around. [And notice
> that if user _does_ lock/turn off the screen after the operation,
> difference between power consumptions is factor of two. People do turn
> off screens before putting phone back in pocket.]

It depends on the use-case, that's why the problem is so complicated.
Race-to-idle may work well if just checking bus timetables but not if
you are watching video or listening to music (the latter with screen
off).

> You are right that as long as user does _not_ wait for the computation
> result, running at low frequency might make sense. That may be true on
> cellphone so fast that all the actions are "instant". I have yet to
> see such cellphone. That probably means that staying on low frequency
> normally and going to high after cpu is busy for 100msec or so is
> right thing: if cpu is busy for 100msec, it probably means user is
> waiting for the result.

I'm talking about use-cases where a task (or multiple threads) are
running and only loading the CPU partially (audio or video playback).
Here you have an average number of instructions to execute per decoded
frame in a certain time. Once the frame is decoded, the CPU can go idle,
so you can choose whether to race to idle or run at lower frequency (and
lower energy per the same number of frame decoding instructions) with
less idle time. There are modern platforms where the latter behaviour is
more efficient.

I would really like race to idle to be true for all cases, it would
simplify the kernel and we could just remove cpufreq, always running the
CPUs at max frequency. But so far I don't see Intel ignoring this
problem either, they keep developing a pstate driver which changes the
P-states based on average CPU load.

(we can complicate the problem further by considering memory vs CPU
bound threads)

> But it depends on the numbers you did not tell us. I'm pretty sure
> N900 does _not_ have 11% power consuption at 33% performance; I just
> assumed so for sake of argument.
> 
> So, really, details are needed.

If that's the only issue to be addressed, I'm happy to ignore the
frequency scaling initially and focus on idle. But since people still do
frequency scaling and this would interfere with the scheduler, we have
to (1) normalise the task load as much as possible (frequency invariant
load tracking) and (2) scheduler power model should take into account
the cost of placing tasks on CPUs at different P-states. With such
simplification we can leave the P-state selection to cpufreq and see how
far we can get in terms of power efficiency.

-- 
Catalin
