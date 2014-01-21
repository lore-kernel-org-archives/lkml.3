Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbaAULT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 06:19:57 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:15190 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754122AbaAULTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 06:19:54 -0500
Date: Tue, 21 Jan 2014 11:19:20 +0000
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
Message-ID: <20140121111920.GB14830@arm.com>
References: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
 <1389111587-5923-12-git-send-email-morten.rasmussen@arm.com>
 <20140120164926.GB23051@amd.pavel.ucw.cz>
 <20140120171010.GB29971@arm.com>
 <20140120171752.GC29971@arm.com>
 <20140120174745.GA25439@amd.pavel.ucw.cz>
 <20140120180322.GI29971@arm.com>
 <20140120191546.GA26780@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120191546.GA26780@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 07:15:46PM +0000, Pavel Machek wrote:
> On Mon 2014-01-20 18:03:22, Catalin Marinas wrote:
> > On Mon, Jan 20, 2014 at 05:47:45PM +0000, Pavel Machek wrote:
> > > On Mon 2014-01-20 17:17:52, Catalin Marinas wrote:
> > > > On Mon, Jan 20, 2014 at 05:10:29PM +0000, Catalin Marinas wrote:
> > > > > On Mon, Jan 20, 2014 at 04:49:26PM +0000, Pavel Machek wrote:
> > > > > > > To save energy, the higher frequencies should be avoided and only used
> > > > > > > when the application performance requirements can not be satisfied
> > > > > > > otherwise (e.g. spread tasks across more cpus if possible).
> > > > > > 
> > > > > > I argue this is untrue for any task where user waits for its
> > > > > > completion with screen on. (And that's quite important subset).
> > > > > > 
> > > > > > Lets take Nokia n900 as an example. 
> > > > > > 
> > > > > > (source http://wiki.maemo.org/N900_Hardware_Power_Consumption)
> > > > > > 
> > > > > > Sleeping CPU: 2mA
> > > > > > Screen on: 230mA
> > > > > > CPU loaded: 250mA
> > > > > > 
> > > > > > Now, lets believe your numbers and pretend system can operate at 33%
> > > > > > of speed with 11% power consumption.
> > > > > > 
> > > > > > Lets take task that takes 10 seconds on max frequency:
> > > > > > 
> > > > > >       ~ 10s * 470mA     	     	    = 4700mAs
> > > > > > 
> > > > > > You suggest running at 33% speed, instead; that means 30 seconds on
> > > > > > low requency.
> > > > > > 
> > > > > > CPU on low: 25mA (assumed).
> > > > > > 
> > > > > >      ~ 30s * 255mA			    = 7650mAs
> > > > > > 
> > > > > > Hmm. So race to idle is good thing on Intel machines, and it is good
> > > > > > thing on ARM design I have access to.
> > > > > 
> > > > > Race to idle doesn't mean that the screen goes off as well. Let's say
> > > > > the screen stays on for 1 min and the CPU needs to be running for 10s
> > > > > over this minute, in the first case you have:
> > > > > 
> > > > > 	10s & 250mA + 60s * 230mA = 16300mAs
> > > > > 
> > > > > in the second case you have:
> > > > > 
> > > > > 	30s * 25mA + 60s * 230mA = 14550mAs
> > > > > 
> > > > > That's a 1750mAs difference. There are of course other parts drawing
> > > > > current but simple things like the above really make a difference in the
> > > > > mobile space, both in terms of battery and thermal budget.
> > > > 
> > > > BTW, the proper way to calculate this is to use the energy rather than
> > > > current x time. This would be J = Ohm * A^2 * s = V^2 / Ohm * s (so the
> > > > impact of the current is even bigger).
> > > 
> > > You are claiming that energy is proportional to current squared?
> > > 
> > > I stand by numbers. Energy is proportional to values I quoted,
> > > provided constant voltage.
> > 
> > The big advantage of frequency scaling is that you can scale down the
> > voltage, making the power proportional to the voltage squared (or
> > current squared for a constant resistance).
> 
> I was talking battery voltage; so multiple my numbers by 3.6V and
> you'll get Joules.

That's where we were talking about different things. What I was
referring to was the actual current used by the CPU which is different
from the one drawn from battery for that CPU (because of voltage
translation). But with a low-loss voltage regulator, we could pretend
that the corresponding power used by the CPU is the same at the battery
level.

> Can you point out problem with my numbers or not?

I agree with your equivalent battery current for the CPU (minor thing, I
get about 12% power consumption at 33% performance from Morten's
numbers, irrelevant).

The other thing I didn't agree with was the screen on vs race to idle
but I'll follow up separately.

-- 
Catalin
