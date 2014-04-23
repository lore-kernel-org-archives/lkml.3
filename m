Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbaDWO6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:58:06 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:63503 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616AbaDWO6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:58:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140423144538.GN11096@twins.programming.kicks-ass.net>
References: <1394739386-22260-1-git-send-email-venkateshs@google.com>
	<CABPqkBRm8Ux15UY2+hF1TZdVsgVbYV+9XPiuh9m497Mr3oJ0Wg@mail.gmail.com>
	<20140423144538.GN11096@twins.programming.kicks-ass.net>
Date: Wed, 23 Apr 2014 16:49:55 +0200
Message-ID: <CABPqkBT5xg+zQ45dugHiXM5XFYi+V3gsBmANevx25fE0S0iNXA@mail.gmail.com>
Subject: Re: [PATCH] perf/x86/intel: Use rdmsrl_safe when initializing RAPL PMU.
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Venkatesh Srinivas <venkateshs@google.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 4:45 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Apr 23, 2014 at 04:31:32PM +0200, Stephane Eranian wrote:
>> On Thu, Mar 13, 2014 at 8:36 PM, Venkatesh Srinivas
>> <venkateshs@google.com> wrote:
>> > CPUs which should support the RAPL counters according to
>> > Family/Model/Stepping may still issue #GP when attempting to access
>> > the RAPL MSRs. This may happen when Linux is running under KVM and
>> > we are passing-through host F/M/S data, for example. Use rdmsrl_safe
>> > to first access the RAPL_POWER_UNIT MSR; if this fails, do not
>> > attempt to use this PMU.
>> >
>> > Signed-off-by: Venkatesh Srinivas <venkateshs@google.com>
>> > ---
>> >  arch/x86/kernel/cpu/perf_event_intel_rapl.c | 12 +++++++++---
>> >  1 file changed, 9 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
>> > index 5ad35ad..95700e5 100644
>> > --- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
>> > +++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
>> > @@ -511,6 +511,7 @@ static int rapl_cpu_prepare(int cpu)
>> >         struct rapl_pmu *pmu = per_cpu(rapl_pmu, cpu);
>> >         int phys_id = topology_physical_package_id(cpu);
>> >         u64 ms;
>> > +       u64 msr_rapl_power_unit_bits;
>> >
>> >         if (pmu)
>> >                 return 0;
>> > @@ -518,6 +519,9 @@ static int rapl_cpu_prepare(int cpu)
>> >         if (phys_id < 0)
>> >                 return -1;
>> >
>> > +       if (!rdmsrl_safe(MSR_RAPL_POWER_UNIT, &msr_rapl_power_unit_bits))
>> > +               return -1;
>> > +
>> I have a problem with this patch on native hardware. This
>> rdmsrl_safe() systematically
>> fails when I know the MSR is perfectly valid on the CPU. Consequently, RAPL PMU
>> is disabled when I tried on IvyBridge and Haswell CPUs.
>>
>> I don't know the internals of rdmsrl_safe(). Maybe it is invoked too
>> early in the boot process.
>
> Weird; so the way it works is that it adds an exception table entry for
> the wrmsr instruction, so when the wrmsr generates a fault due to being
> an invalid msr the fault handler looks at the exception table, and finds
> the entry, which instructs it to continue execution at the error path
> and return -EFAULT.
>
On your machine, booted with 3.15-rc2, do you have /sys/devices/power?
If not, and you have at least an SNB, you should have RAPL and that
RAPL_UNIT MSR.

Proof is that if you read that MSR using /dev/cpu/msr it works just fine:
# modprobe msr
# rdmsr 0x606
a1003

So something is broken somewhere.
