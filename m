Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbaHONIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 09:08:54 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:61129 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaHONIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 09:08:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140815061917.GX19379@twins.programming.kicks-ass.net>
References: <1408046230-16439-1-git-send-email-ashwin.chaugule@linaro.org>
	<20140814205143.GY6758@twins.programming.kicks-ass.net>
	<CAJ5Y-ebgJi8Ngxg1X+h7KMundGZPFhYC0hr0Sog6htj=czszgQ@mail.gmail.com>
	<20140815061917.GX19379@twins.programming.kicks-ass.net>
Date: Fri, 15 Aug 2014 09:08:50 -0400
Message-ID: <CAJ5Y-eaLxCG7dDao00pozXBL2dxPS7tf=xGfaz3O_xfRHtQZnA@mail.gmail.com>
Subject: Re: [RFC 0/3] Experimental patchset for CPPC
From: Ashwin Chaugule <ashwin.chaugule@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mike Turquette <mike.turquette@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Arjan van de Ven <arjan@linux.intel.com>, mingo@kernel.org,
        len.brown@intel.com, rjw@rjwysocki.net,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-acpi@vger.kernel.org,
        cpufreq@vger.kernel.org, Patch Tracking <patches@linaro.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 15 August 2014 02:19, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Aug 14, 2014 at 05:56:10PM -0400, Ashwin Chaugule wrote:
>> On 14 August 2014 16:51, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Thu, Aug 14, 2014 at 03:57:07PM -0400, Ashwin Chaugule wrote:
>> >>
>> >>
>> >> What is CPPC:
>> >> =============
>> >>
>> >> CPPC is the new interface for CPU performance control between the OS and the
>> >> platform defined in ACPI 5.0+. The interface is built on an abstract
>> >> representation of CPU performance rather than raw frequency.  Basic operation
>> >> consists of:
>> >
>> > Why do we want this? Typically we've ignored ACPI and gone straight to
>> > MSR access, intel_pstate and intel_idle were created especially to avoid
>> > ACPI, so why return to it.
>> >
>> > Also, the whole interface sounds like trainwreck (one would not expect
>> > anything else from ACPI).
>> >
>> > So _why_?
>>
>> The overall idea is that tying the notion of CPU performance to CPU
>> frequency is no longer true these days.[1]. So, using some direction
>> from an OS , the platforms want to be able to decide how to adjust CPU
>> performance by using knowledge that may be very platform specific.
>> e.g. through the use of performance counters, thermal budgets and
>> other system specific constraints. So, CPPC describes a way for the OS
>> to request performance within certain bounds and then letting the
>> platform optimize it within those constraints. Expressing CPU
>> performance in an abstract way, should also help keep things uniform
>> across various architecture implementations.
>
>> [1]- https://plus.google.com/+ArjanvandeVen/posts/dLn9T4ehywL
>> [2] - http://git.linaro.org/people/ashwin.chaugule/leg-kernel.git/blob/236d901d31fb06fda798880c9ca09d65123c5dd9:/drivers/cpufreq/cppc_x86.c
>
> Yeah, I'm so not clicking in that; if you want to make an argument make
> it here.
>
> In any case; that's all nice and shiny that the 'hardware' works like
> that. But have these people considered how we're supposed to use it?
>
> How should we know what to do with a new task? Do we stack it on a busy
> CPU, do we wake an idle cpu and how are we going to tell which is the
> 'best' option.
>
> How are we going to do DVFS like accounting if we don't know wtf the
> hardware can or will do.
>
> And how can you design these interfaces and hardware without at least
> partially knowing the answer to these questions.

Although, the CPPC descriptor table and the spec dont describe the
algorithm, it still gives
a good enough idea of how the platform would react.  I'll try to
summarize it briefly. I have a few more register specific details in
the cover letter if needed.

e.g.:

(1) The OS can read from the platform what each CPU is capable of at
the moment. Highest, Lowest CPU performance bounds which are
essentially the thresholds at which this CPU can deliver. The platform
can even tell us a "guaranteed performance value" at that moment. This
is the level the CPU is expected to deliver taking into account all
the possible constraints. (e.g. thermal, power budgets etc.). If the
"guaranteed" value changes due to some reason, the platform raises a
notification, so the OS can reevaluate.

(2) When an OS requests a specific performance value, it supplies a
Max, Min and Desired value. The platform is expected to deliver CPU
performance within this range. The Delivered performance register
should reflect what the platform decided.

(3) If the OS knows that it needs to step up or lower the CPU
performance value for a specific period of time, then it sets the Time
Window and Performance Reduction Tolerance register in addition to
Max, Min, and Desired. This will force the platform to deliver CPU
performance which on average over the Time Window equals the value in
Performance Reduction.

So, its not as though the OS is left completely blind. The platform
maintains updated information about CPUs performance capabilities and
relies on hints from the OS to make decisions and it also feeds back
what it decides.

If the OS only looks at Highest, Lowest, Delivered registers and only
writes to Desired, then we're not really any different than how we do
things today in the CPUFreq layer. Or even in the case of
intel_pstate, if you map Desired to PERF_CTL and get value of
Delivered by using aperf/mperf ratios (as my experimental driver
does), then we can still maintain the existing system performance. It
seems like if an OS can make use of the additional information then it
should be net win for overall power savings and performance
enhancement. Also, using the CPPC descriptors, we should be able to
have one driver across X86 and ARM64. (possibly others too.)

So I'm still learning about the scheduler and dont have enough
knowledge yet. Hence this discussion with you guys. Hopefully with the
above flow, you can see that:

(a) we can plug the cppc driver to the existing infrastructure and not
change anything really. (except the freq domain awareness issues I
mentioned earlier) (short term)

(b) we come up with ways to provide the bounds around a Desired value
using the information from the platform. (long term)

I briefly looked at the x86 HWP (Hardware Performance States) in the
s/w manual again. Its essentially an implementation of CPPC. It seems
like X86 has implemented most if not all these registers as MSRs. I'm
really interested in knowing if anyone there is/has been working on
using them and what they found.


Cheers,
Ashwin
