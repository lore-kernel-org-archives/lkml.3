Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423186Ab3FUPHC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 11:07:02 -0400
Received: from service87.mimecast.com ([91.220.42.44]:59036 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423052Ab3FUPHA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:07:00 -0400
Date: Fri, 21 Jun 2013 16:06:56 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, "alex.shi@intel.com" <alex.shi@intel.com>,
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
Message-ID: <20130621150656.GK5460@e103034-lin>
References: <20130530134718.GB32728@e103034-lin>
 <20130531105204.GE30394@gmail.com>
 <20130614160522.GG32728@e103034-lin>
 <51C07ABC.2080704@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <51C07ABC.2080704@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 21 Jun 2013 15:06:54.0310 (UTC) FILETIME=[F7440860:01CE6E90]
X-MC-Unique: 113062116065704401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 04:20:28PM +0100, Arjan van de Ven wrote:
> On 6/14/2013 9:05 AM, Morten Rasmussen wrote:
> 
> > Looking at the discussion it seems that people have slightly different
> > views, but most agree that the goal is an integrated scheduling,
> > frequency, and idle policy like you pointed out from the beginning.
> 
> 
> ... except that such a solution does not really work for Intel hardware.
> 
> The OS does not get to really pick the CPU "frequency" (never mind that
> frequency is not what gets controlled), the hardware picks the frequency.
> The OS can do some level of requests (best to think of this as a percentage
> more than frequency) but what you actually get is more often than not
> what you asked for.
> 
> You can look in hindsight what kind of performance you got (from some basic
> counters in MSRs), and the scheduler can use that to account backwards to what some process
> got. But to predict what you will get in the future...... that's near impossible
> on any realistic system nowadays (and even more so in the future).

The proposed power scheduler doesn't have to drive p-state selection if
it doesn't make sense for the particular platform. The aim of the power
scheduler is integration of power policies in general.

> 
> Treating "frequency" (well "performance) and idle separately is also a false thing to do
> (yes I know in 3.9/3.10 we still do that for Intel hw, but we're working
> on fixing that). They are by no means separate things. One guy's idle state
> is the other guys power budget (and thus performance)!.
> 

I agree.


Based on our discussions so far, where it has become more clear where
Intel is heading, and Ingo's reply I think we have three ways to ahead
with the power-aware scheduling work. Each with their advantages and
disadvantages:

1. We work on a generic power scheduler with appropriate abstractions
that will work for all of us. Current and future Intel p-state policies
will be implemented through the power scheduler.

Pros: We can arrive at fairly standard solution with standard tunables.
There will be one interface to the scheduler.

Cons: Finding a suitable platform abstraction for the power scheduler.

2. Like 1, but we introduce a CONFIG_SCHED_POWER as suggested by Ingo,
that makes it all go away.

Pros: Intel can keep intel_pstate.c others can use the power scheduler
or their own driver.

Cons: Different platform specific drivers may need different interfaces
to the scheduler. Harder to define cross-platform tunables.

3. We go for independent platform specific power policy driver that may
or may not use existing frameworks, like intel_pstate.c.

Pros: No need to find common platform abstraction. Power policy is
implemented in arch/* and won't affect others.

Cons: Same as 2. Everybody would have to implement their own frequency,
idle and thermal solutions. Potential duplication of functionality.


In my opinion we should aim for 1., but start out with a
CONFIG_SCHED_POWER and see where we get to. Feedback from everybody is
essential to arrive at a generic solution.

Morten

