Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab3G2O3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:29:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:4028 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725Ab3G2O3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:29:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,770,1367996400"; 
   d="scan'208";a="378333054"
Message-ID: <51F67C40.60701@linux.intel.com>
Date: Mon, 29 Jul 2013 07:29:20 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>, Rik van Riel <riel@redhat.com>,
        Jeremy Eder <jeder@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "youquan.song@intel.com" <youquan.song@intel.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: RFC:  revert request for cpuidle patches e11538d1 and 69a37bea
References: <20130726173306.GB17985@jeder.rdu.redhat.com> <51F2BC31.7000407@redhat.com> <51F2BF8C.7010308@linux.intel.com> <51F2C014.90102@redhat.com> <51F37290.5050101@linaro.org> <51F66A5A.9060901@linux.intel.com> <20130729141455.GA9590@e102568-lin.cambridge.arm.com>
In-Reply-To: <20130729141455.GA9590@e102568-lin.cambridge.arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/29/2013 7:14 AM, Lorenzo Pieralisi wrote:
>>
>>
>> btw this is largely a misunderstanding;
>> tasks are not the issue; tasks use timers and those are perfectly predictable.
>> It's interrupts that are not and the heuristics are for that.
>>
>> Now, if your hardware does the really-bad-for-power wake-all on any interrupt,
>> then the menu governor logic is not good for you; rather than looking at the next
>> timer on the current cpu you need to look at the earliest timer on the set of bundled
>> cpus as the upper bound of the next wake event.
>
> Yes, that's true and we have to look into this properly, but certainly
> a wake-up for a CPU in a package C-state is not beneficial to x86 CPUs either,
> or I am missing something ?

a CPU core isn't in a package C state, the system is.
(in a core C state the whole core is already powered down completely; a package C state
just also turns off the memory controller/etc)

package C states are global on x86 (not just per package); there's nothing one
can do there in terms of grouping/etc.


> Even if the wake-up interrupts just power up one of the CPUs in a package
> and leave other(s) alone, all HW state shared (ie caches) by those CPUs must
> be turned on. What I am asking is: this bundled next event is a concept
> that should apply to x86 CPUs too, or it is entirely managed in FW/HW
> and the kernel just should not care ?

on Intel x86 cpus, there's not really bundled concept. or rather, there is only 1 bundle
(which amounts to the same thing).
Yes in a multi-package setup there are some cache power effects... but there's
not a lot one can do there.
The other cores don't wake up, so they still make their own correct decisions.

> I still do not understand how this "bundled" next event is managed on
> x86 with the menu governor, or better why it is not managed at all, given
> the importance of package C-states.

package C states on x86 are basically OS invisible. The OS manages core level C states,
the hardware manages the rest.
The bundle part hurts you on a "one wakes all" system,
not because of package level power effects, but because others wake up prematurely
(compared to what they expected) which causes them to think future wakups will also
be earlier. All because they get the "what is the next known event" wrong,
and start correcting for known events instead of only for 'unpredictable' interrupts.
Things will go very wonky if you do that for sure.
(I've seen various simulation data on that, and the menu governor indeed acts quite poorly
for that)

>> And maybe even more special casing is needed... but I doubt it.
>
> I lost you here, can you elaborate pls ?

well.. just looking at the earliest timer might not be enough; that timer might be on a different
core that's still active, and may change after the current cpu has gone into an idle state.
Fun.
Coupled C states on this level are a PAIN in many ways, and tend to totally suck for power
due to this and the general "too much is active" reasons.

