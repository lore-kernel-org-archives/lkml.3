Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3AOAT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 19:19:26 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:63253 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab3AOATY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 19:19:24 -0500
MIME-Version: 1.0
In-Reply-To: <20130114154914.6d69eb27.akpm@linux-foundation.org>
References: <1357941108-14138-1-git-send-email-ccross@android.com>
	<20130114154914.6d69eb27.akpm@linux-foundation.org>
Date: Mon, 14 Jan 2013 16:19:23 -0800
X-Google-Sender-Auth: MN4DC1awLZbD5kGIz1WY97eFAcU
Message-ID: <CAMbhsRR29Zhje9mGtUwHfUsX+eFsggYkVMHPyQ+zgrGUp_rqTQ@mail.gmail.com>
Subject: Re: [PATCH v2] hardlockup: detect hard lockups without NMIs using
 secondary cpus
From: Colin Cross <ccross@android.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        liu chuansheng <chuansheng.liu@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 3:49 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 11 Jan 2013 13:51:48 -0800
> Colin Cross <ccross@android.com> wrote:
>
>> Emulate NMIs on systems where they are not available by using timer
>> interrupts on other cpus.  Each cpu will use its softlockup hrtimer
>> to check that the next cpu is processing hrtimer interrupts by
>> verifying that a counter is increasing.
>
> Seems sensible.
>
>> This patch is useful on systems where the hardlockup detector is not
>> available due to a lack of NMIs, for example most ARM SoCs.
>> Without this patch any cpu stuck with interrupts disabled can
>> cause a hardware watchdog reset with no debugging information,
>> but with this patch the kernel can detect the lockup and panic,
>> which can result in useful debugging info.
>
> But we don't get the target cpu's stack, yes?  That's a pretty big loss.

It's a huge loss, but its still useful.  For one, it can separate
"linux locked up one cpu" bugs from "the whole cpu complex stopped
responding" bugs, which are much more common than you would hope on
ARM cpus.  Also, as a separate patch I'm hoping to add reading the
DBGPCSR register of both cpus during panic, which will at least give
you the PC of the cpu that is stuck.

>>
>> ...
>>
>> +#ifdef CONFIG_HARDLOCKUP_DETECTOR_OTHER_CPU
>> +static unsigned int watchdog_next_cpu(unsigned int cpu)
>> +{
>> +     cpumask_t cpus = watchdog_cpus;
>
> cpumask_t can be tremendously huge and putting one on the stack is
> risky.  Can we use watchdog_cpus directly here?  Perhaps with a lock?
> or take a copy into a static local, with a lock?

Sure, I can use a lock around it.  I'm used to very small numbers of cpus.

>> +     unsigned int next_cpu;
>> +
>> +     next_cpu = cpumask_next(cpu, &cpus);
>> +     if (next_cpu >= nr_cpu_ids)
>> +             next_cpu = cpumask_first(&cpus);
>> +
>> +     if (next_cpu == cpu)
>> +             return nr_cpu_ids;
>> +
>> +     return next_cpu;
>> +}
>> +
>> +static int is_hardlockup_other_cpu(unsigned int cpu)
>> +{
>> +     unsigned long hrint = per_cpu(hrtimer_interrupts, cpu);
>> +
>> +     if (per_cpu(hrtimer_interrupts_saved, cpu) == hrint)
>> +             return 1;
>> +
>> +     per_cpu(hrtimer_interrupts_saved, cpu) = hrint;
>> +     return 0;
>> +}
>
> This could return a bool type.

I based it on is_hardlockup, but I can convert it to a bool.

>> +static void watchdog_check_hardlockup_other_cpu(void)
>> +{
>> +     unsigned int next_cpu;
>> +
>> +     /*
>> +      * Test for hardlockups every 3 samples.  The sample period is
>> +      *  watchdog_thresh * 2 / 5, so 3 samples gets us back to slightly over
>> +      *  watchdog_thresh (over by 20%).
>> +      */
>> +     if (__this_cpu_read(hrtimer_interrupts) % 3 != 0)
>> +             return;
>
> The hardwired interval Seems Wrong.  watchdog_thresh is tunable at runtime.
>
> The comment could do with some fleshing out.  *why* do we want to test
> at an interval "slightly over watchdog_thresh"?  What's going on here?

I'll reword it.  We don't want to be slightly over watchdog_thresh,
ideally we would be exactly at watchdog_thresh.  However, since this
relies on the hrtimer interrupts that are scheduled at watchdog_thresh
* 2 / 5, there is no multiple of hrtimer_interrupts that will result
in watchdog_thresh.  watchdog_thresh * 2 / 5 * 3 (watchdog_thresh *
1.2) is the closest I can get to testing for a hardlockup once every
watchdog_thresh seconds.

>> +     /* check for a hardlockup on the next cpu */
>> +     next_cpu = watchdog_next_cpu(smp_processor_id());
>> +     if (next_cpu >= nr_cpu_ids)
>> +             return;
>> +
>> +     smp_rmb();
>
> Mystery barrier (always) needs an explanatory comment, please.

OK.  Will add:  smp_rmb matches smp_wmb in watchdog_nmi_enable and
watchdog_nmi_disable to ensure watchdog_nmi_touch is updated for a cpu
before any other cpu sees it is online.

>> +     if (per_cpu(watchdog_nmi_touch, next_cpu) == true) {
>> +             per_cpu(watchdog_nmi_touch, next_cpu) = false;
>> +             return;
>> +     }
>
> I wonder if a well-timed CPU plug/unplug could result in two CPUs
> simultaneously checking one other CPU's state.

It can, which is why I set watchdog_nmi_touch for a cpu when it comes
online or when the previous cpu goes offline.  That should prevent a
false positive by preventing the first cpu that checks from updating
hrtimer_interrupts_saved.

>> +     if (is_hardlockup_other_cpu(next_cpu)) {
>> +             /* only warn once */
>> +             if (per_cpu(hard_watchdog_warn, next_cpu) == true)
>> +                     return;
>> +
>> +             if (hardlockup_panic)
>> +                     panic("Watchdog detected hard LOCKUP on cpu %u", next_cpu);
>> +             else
>> +                     WARN(1, "Watchdog detected hard LOCKUP on cpu %u", next_cpu);
>
> I suggest we use messages here which make it clear to people who read
> kernel output that this was triggered by hrtimers, not by NMI.  Most
> importantly because people will need to know that the CPU which locked
> up is *not this CPU* and that any backtrace from the reporting CPU is
> misleading.
>
> Also, there was never any sense in making the LOCKUP all-caps ;)

I'll change to "hrtimer watchdog on cpu %u detected hard lockup on cpu
%u".  Given the discussion above about the lack of backtraces on the
affected cpu, I'll also change the WARN to pr_warn, since the
backtrace of the warning cpu is misleading.  The panic will still get
the backtrace of the detecting cpu, but hopefully the clearer message
will avoid confusing people.

>> +             per_cpu(hard_watchdog_warn, next_cpu) = true;
>> +     } else {
>> +             per_cpu(hard_watchdog_warn, next_cpu) = false;
>> +     }
>> +}
>> +#else
>> +static inline void watchdog_check_hardlockup_other_cpu(void) { return; }
>> +#endif
>> +
>>
>> ...
>>
>> --- a/lib/Kconfig.debug
>> +++ b/lib/Kconfig.debug
>> @@ -191,15 +191,27 @@ config LOCKUP_DETECTOR
>>         The overhead should be minimal.  A periodic hrtimer runs to
>>         generate interrupts and kick the watchdog task every 4 seconds.
>>         An NMI is generated every 10 seconds or so to check for hardlockups.
>> +       If NMIs are not available on the platform, every 12 seconds the
>
> hm.  Is the old "4 seconds" still true/accurate/complete?

Yes, unless watchdog_thresh is changed on the command line or at run
time.  I can update the message to clarify that 4 seconds is the
default.

>> +       hrtimer interrupt on one cpu will be used to check for hardlockups
>> +       on the next cpu.
>>
>>         The frequency of hrtimer and NMI events and the soft and hard lockup
>>         thresholds can be controlled through the sysctl watchdog_thresh.
>>
>> -config HARDLOCKUP_DETECTOR
>> +config HARDLOCKUP_DETECTOR_NMI
>>       def_bool y
>>       depends on LOCKUP_DETECTOR && !HAVE_NMI_WATCHDOG
>>       depends on PERF_EVENTS && HAVE_PERF_EVENTS_NMI
>
> Confused.  I'd have expected this to depend on HAVE_NMI_WATCHDOG,
> rather than -no-that.  What does "HAVE_NMI_WATCHDOG" actually mean and
> what's happening here?

HAVE_NMI_WATCHDOG used to be called ARCH_HAS_NMI_WATCHDOG, which was a
little clearer.  I believe it means that the architecture has its own
NMI watchdog implementation, and doesn't require this perf-based one.
