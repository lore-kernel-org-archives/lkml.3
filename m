Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaIXQ63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:58:29 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:52651 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaIXQ61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:58:27 -0400
Message-ID: <5422F82B.40507@mentor.com>
Date: Wed, 24 Sep 2014 11:58:19 -0500
From: Nathan Lynch <Nathan_Lynch@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Christopher Covington <cov@codeaurora.org>,
        Will Deacon <will.deacon@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Doug Anderson <dianders@chromium.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Sonny Rao <sonnyrao@chromium.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] arm_arch_timer: VDSO preparation, code consolidation
References: <1411052390-27238-1-git-send-email-nathan_lynch@mentor.com> <20140922153919.GQ25809@arm.com> <20140922223022.GO5182@n2100.arm.linux.org.uk> <5420BE92.7050504@mentor.com> <5422D138.8000002@codeaurora.org> <5422D616.7060807@mentor.com> <20140924145025.GX5182@n2100.arm.linux.org.uk>
In-Reply-To: <20140924145025.GX5182@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 09:50 AM, Russell King - ARM Linux wrote:
> On Wed, Sep 24, 2014 at 09:32:54AM -0500, Nathan Lynch wrote:
>> On 09/24/2014 09:12 AM, Christopher Covington wrote:
>>> Hi Nathan,
>>>
>>> On 09/22/2014 08:28 PM, Nathan Lynch wrote:
>>>> Hmm, this patch set is merely exposing the hardware counter when it is
>>>> present for the VDSO's use; I take it you have no objection to that?
>>>>
>>>> While the 32-bit ARM VDSO I've posted (in a different thread) exploits a
>>>> facility that is required by the virtualization option in the
>>>> architecture, its utility is not limited to guest operating systems.
>>>
>>> Just to clarify, were the performance improvements you measured from a
>>> virtualized guest or native?
>>
>> Yeah I should have been explicit about this.  My tests and measurements
>> (and all test results I've received from others, I believe) have been on
>> native/host kernels, not guests.
> 
> Have there been any measurements on systems without the architected
> timers?

I do test on iMX6 regularly.  Afraid I don't have any pre-v7 hardware to
check though.

Here's a report from you from an earlier submission that shows little/no
impact:

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/267552.html

But admittedly vdsotest is just doing rudimentary microbenchmarking.

Running a lttng-ust workload that emits tracepoints as fast as possible
(lttng-ust calls clock_gettime and getcpu on every tracepoint), I see
about 1% degradation on iMX6.


>>> I count 18 dts* files that have "arm,armv7-timer", including platforms with
>>> Krait, Exynos, and Tegra processors.
>>
>> Yup.
> 
> That's not the full story.  Almost every ARM to date has not had an
> architected timer.  Architected timers are a recent addition - as
> pointed out, a Cortex A7/A12/A15 invention.  Most of the platforms I
> see are Cortex A9 which doesn't have any architected timers.
> 
> Yes, it may be fun to work on new hardware and make that perform
> much better than previous, but we should not loose sight that there
> is older hardware out there, and we shouldn't unnecessarily penalise
> it when adding new features.

Agreed, of course, and I'll include more detailed results from systems
without the architected timer in future submissions.


> What we /need/ to know is what the effect providing a VDSO in an
> environment without an architected timer (so using the VDSO fallback
> functions calling the syscalls) and having glibc use it is compared
> to the current situation where there is no VDSO for glibc to use.
> 
> If you can show that there's no difference, then I'm happy to go with
> always providing the VDSO.  If there's a detrimental effect (which I
> suspect there may be, since we now have to have glibc test to see if
> the VDSO is there, jump to the VDSO, the VDSO then tests whether we
> have an architected timer, and then we finally get to issue the
> syscall), then we must avoid providing the VDSO on systems which have
> no architected timer.

One point I would like to raise is that the VDSO provides (or could be
made to provide) acceleration for APIs that are unrelated to the
architected timer:

- clock_gettime with CLOCK_REALTIME_COARSE and CLOCK_MONOTONIC_COARSE.
This is currently included.

- getcpu, which I had planned on submitting later.

I don't know whether the coarse clock support is compelling; they don't
seem to be commonly used.  But there is a nice 4-5x speedup for those on
iMX6.

getcpu, on the other hand, is one of the two system calls lttng-ust uses
in every tracepoint emitted, and I would like to have it available in
the VDSO on all systems capable of supporting the implementation, which
may take the form of co-opting TPIDRURW or some other register.

So the question of whether to provide the VDSO may not hinge on whether
the architected timer is available.

None of which is to argue that unnecessarily degrading gettimeofday
performance on some systems for the benefit of others is acceptable.

