Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab3FWKzP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 06:55:15 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:62645 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab3FWKzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 06:55:11 -0400
Date: Sun, 23 Jun 2013 12:55:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: power-efficient scheduling design
Message-ID: <20130623105505.GC20084@gmail.com>
References: <20130530134718.GB32728@e103034-lin>
 <20130531105204.GE30394@gmail.com>
 <20130614160522.GG32728@e103034-lin>
 <51C07ABC.2080704@linux.intel.com>
 <20130621150656.GK5460@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130621150656.GK5460@e103034-lin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Morten Rasmussen <morten.rasmussen@arm.com> wrote:

> On Tue, Jun 18, 2013 at 04:20:28PM +0100, Arjan van de Ven wrote:
> > On 6/14/2013 9:05 AM, Morten Rasmussen wrote:
> > 
> > > Looking at the discussion it seems that people have slightly different
> > > views, but most agree that the goal is an integrated scheduling,
> > > frequency, and idle policy like you pointed out from the beginning.
> > 
> > 
> > ... except that such a solution does not really work for Intel hardware.
> > 
> > The OS does not get to really pick the CPU "frequency" (never mind 
> > that frequency is not what gets controlled), the hardware picks the 
> > frequency. The OS can do some level of requests (best to think of this 
> > as a percentage more than frequency) but what you actually get is more 
> > often than not what you asked for.
> > 
> > You can look in hindsight what kind of performance you got (from some 
> > basic counters in MSRs), and the scheduler can use that to account 
> > backwards to what some process got. But to predict what you will get 
> > in the future...... that's near impossible on any realistic system 
> > nowadays (and even more so in the future).
> 
> The proposed power scheduler doesn't have to drive p-state selection if 
> it doesn't make sense for the particular platform. The aim of the power 
> scheduler is integration of power policies in general.

Exactly.

> > Treating "frequency" (well "performance) and idle separately is also a 
> > false thing to do (yes I know in 3.9/3.10 we still do that for Intel 
> > hw, but we're working on fixing that). They are by no means separate 
> > things. One guy's idle state is the other guys power budget (and thus 
> > performance)!.
> 
> I agree.
> 
> Based on our discussions so far, where it has become more clear where 
> Intel is heading, and Ingo's reply I think we have three ways to ahead 
> with the power-aware scheduling work. Each with their advantages and 
> disadvantages:
> 
> 1. We work on a generic power scheduler with appropriate abstractions 
> that will work for all of us. Current and future Intel p-state policies 
> will be implemented through the power scheduler.
> 
> Pros: We can arrive at fairly standard solution with standard tunables. 
> There will be one interface to the scheduler.

This is what we prefer really, made available under CONFIG_SCHED_POWER=y.

With CONFIG_SCHED_POWER=y, or if low level facilities are not (yet) 
available then the kernel falls back to legacy (current) behavior.

> Cons: Finding a suitable platform abstraction for the power scheduler.

Just do it incrementally. Start from the dumbest possible state: all CPUs 
are powered up fully, there's no idle state selection essentially. Then go 
for the biggest effect first and add the ability to idle in a lower power 
state (with new functions and a low level driver that implements this for 
the platform with no policy embedded into it - just p-state switching 
logic), and combine that with task packing.

Then do small, measured steps to integrate more and more facilities, the 
ability to turn off more and more hardware, etc. The more basic steps you 
can figure out to iterate this, the better.

Important: it's not a problem that the initial code won't outperform the 
current kernel's performance. It should outperform the _initial_ 'dumb'
code in the first step. Then the next step should outperform the previous 
step, etc.

The quality of this iterative approach will eventually surpass the 
combined effect of currently available but non-integrated facilities.

Since this can be done without touching all the other existing facilities 
it's fundamentally non-intrusive.

An initial implementation should probably cover just two platforms, a 
modern ARM platform and Intel - those two are far enough from each other 
so that if a generic approach helps both we are reasonably certain that 
the generalization makes sense.

The new code could live under a new file in kernel/sched/power.c, to 
separate it out in a tidy fashion, and to make it easy to understand.

> 2. Like 1, but we introduce a CONFIG_SCHED_POWER as suggested by Ingo, 
> that makes it all go away.

That's not really what CONFIG_SCHED_POWER should do: its purpose is to 
allow a 'legacy power saving mode' that makes any new logic go away.

> Pros: Intel can keep intel_pstate.c others can use the power scheduler 
> or their own driver.
> 
> Cons: Different platform specific drivers may need different interfaces 
> to the scheduler. Harder to define cross-platform tunables.
> 
> 3. We go for independent platform specific power policy driver that may 
> or may not use existing frameworks, like intel_pstate.c.

And that's a NAK from the scheduler maintainers.

Thanks,

	Ingo
