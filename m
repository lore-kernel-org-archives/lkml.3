Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaHOQlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:41:05 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:51790 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaHOQlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:41:02 -0400
MIME-Version: 1.0
In-Reply-To: <53EE2BAA.1020603@linux.intel.com>
References: <1408046230-16439-1-git-send-email-ashwin.chaugule@linaro.org>
	<20140814205143.GY6758@twins.programming.kicks-ass.net>
	<CAJ5Y-ebgJi8Ngxg1X+h7KMundGZPFhYC0hr0Sog6htj=czszgQ@mail.gmail.com>
	<20140815061917.GX19379@twins.programming.kicks-ass.net>
	<CAJ5Y-eaLxCG7dDao00pozXBL2dxPS7tf=xGfaz3O_xfRHtQZnA@mail.gmail.com>
	<53EE0E5B.3050004@linux.intel.com>
	<53EE10CB.7040001@linux.intel.com>
	<CAJ5Y-eZiRyGroems7J2oH05ybbbivM-okm3gFz7Mkuu8ceeCDQ@mail.gmail.com>
	<53EE2BAA.1020603@linux.intel.com>
Date: Fri, 15 Aug 2014 12:41:00 -0400
Message-ID: <CAJ5Y-eZZz=SrkONt029eZ0AsEZ6xFhW4cmcaEVZ8=8Ls9r5+zA@mail.gmail.com>
Subject: Re: [RFC 0/3] Experimental patchset for CPPC
From: Ashwin Chaugule <ashwin.chaugule@linaro.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mike Turquette <mike.turquette@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>, mingo@kernel.org,
        len.brown@intel.com, rjw@rjwysocki.net,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-acpi@vger.kernel.org,
        cpufreq@vger.kernel.org, Patch Tracking <patches@linaro.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 15 August 2014 11:47, Arjan van de Ven <arjan@linux.intel.com> wrote:
> On 8/15/2014 7:24 AM, Ashwin Chaugule wrote:
>>>> we've found that so far that there are two reasonable options
>>>> 1) Let the OS device (old style)
>>>> 2) Let the hardware decide (new style)
>>>>
>>>> 2) is there in practice today in the turbo range (which is increasingly
>>>> the whole thing)
>>>> and the hardware can make decisions about power budgetting on a
>>>> timescale
>>>> the OS
>>>> can never even dream of, so once you give control the the hardware (with
>>>> CPPC or native)
>>>> it's normally better to just get out of the way as OS.
>>>>
>>>
>>
>> Interesting. This sounds like X86 plans to use the Autonomous bits
>> that got added to the CPPC spec. (v5.1)?
>
>
> if and when x86/Intel implement that, we will certainly evaluate it to see
> how it behaves... but based on todays use of the hw control of the actual
> p-state... I would expect that evaluation to pass.
>
>
> note that on todays multi-core x96 systems, in practice you operate mostly
> in the turbo range (I am ignoring mostly-idle workloads since there the
> p-state isn't nearly as relevant anyway); all it takes for one of the cores
> to request
> a turbo-range state, and the whole chip operates in turbo mode.. and in
> turbo mode
> the hardware already picks the frequency/voltage.

x96 - Wonder what that has! ;)

So, this I think brings back my point of Freq domain awareness (or
lack of) in todays governors. On X86, it seems as though, the h/w can
take care of "Freq voting rights" among CPUs and it knows to ignore a
request after the requestor goes to sleep. That way the other CPUs in
the domain dont unnecessarily operate under a higher freq/voltage and
their vote can become current. Also on X86, all CPUs are assumed to
have the same min, max operating points?

This may not be true on ARM (or others). So if the h/w isnt capable of
automatically updating freq/voltage for a domain, then the OS needs to
provide that. And I think we can achieve that through the knowledge of
system topology and having a centralized CPU policy governor for each
domain. If each CPU in the domain is capable of making decisions on
behalf of everyone in that domain, then we can at least get past the
problem of "stale CPU freq votes". (replace freq with performance in
CPPC terms).

e.g. to make my point clear, assume there are 3 cpus in the system.

C0, C1 are in one domain and C2 is in another.

If C0 asks for 3Ghz and C1 asks for 1Ghz, the h/w delivers 3Ghz. But
now C0 goes to sleep. With todays governors, we dont reevaluate and
so, C1 continues to get 3Ghz even though it doesnt need it. Maybe X86
can figure out that C0 is asleep and so it should now deliver 1Ghz,
but ARM does not have that AFAIK. So we need the governor to
reevaluate between C0 and C1 (preferably through aperf/mperf like
ratios, rather than the broken p-state assumptions) and send a new
request to ask for 1Ghz.

>
> with the current (and more so, past) Linux behavior, even at moderate loads
> you end up
> there; the more cores you have the more true that becomes.
>
>> I agree that the platform can
>> make decisions on a much finer timescale. But even in the
>> non-Autonomous mode, by providing the bounds around a Desired Value,
>> the OS can get out of the way knowing that the platform would deliver
>> something in the range it requested. If the OS can provide bounds, it
>> seems to me that the platform can make more optimum decisions, rather
>> than trying to guess whats running (or not).
>
>
> I highly question that the OS can provide intelligent bounds.
>

Agreed. This is a challenging problem. Hence the wider discussion.

> When are you going to request an upper bound that is lower than maximum?
> (don't say thermals, there are other mechanisms for controlling thermals
> that work much better than direct P state control). Are you still going to
> do that
> even if sometimes lower frequencies end up costing more battery?
> (race-to-halt and all that)

Maybe the answer is that in the short term, we always request for MAX
in the (Max, Min, Desired) tuple. Although I suspect some platforms
will still use P state controls for thermal mitigation.

>
>
> I can see cases where you bump the minimum for QoS reasons, but even there I
> would
> dare to say that at best the OS will be doing wild-ass guesses.

Right. I see Min being used for QoS too.

Cheers,
Ashwin
