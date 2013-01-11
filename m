Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab3AKFeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 00:34:04 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:34437 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab3AKFeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 00:34:02 -0500
MIME-Version: 1.0
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A200DD9@SHSMSX101.ccr.corp.intel.com>
References: <1357783059-13923-1-git-send-email-ccross@android.com>
	<27240C0AC20F114CBF8149A2696CBE4A200DD9@SHSMSX101.ccr.corp.intel.com>
Date: Thu, 10 Jan 2013 21:34:00 -0800
X-Google-Sender-Auth: sCXoAsxZe0xss_ZFQ9EXuA8dP_o
Message-ID: <CAMbhsRS5S=bRWOAA_ft3josCX9kvarrqPX-sLnO02vB0NfZJ+w@mail.gmail.com>
Subject: Re: [PATCH] hardlockup: detect hard lockups without NMIs using
 secondary cpus
From: Colin Cross <ccross@android.com>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 5:39 PM, Liu, Chuansheng
<chuansheng.liu@intel.com> wrote:
>
>
>> -----Original Message-----
>> From: Colin Cross [mailto:ccross@android.com]
>> Sent: Thursday, January 10, 2013 9:58 AM
>> To: linux-kernel@vger.kernel.org
>> Cc: Andrew Morton; Don Zickus; Ingo Molnar; Thomas Gleixner; Liu,
>> Chuansheng; linux-arm-kernel@lists.infradead.org; Colin Cross
>> Subject: [PATCH] hardlockup: detect hard lockups without NMIs using
>> secondary cpus
>>
>> Emulate NMIs on systems where they are not available by using timer
>> interrupts on other cpus.  Each cpu will use its softlockup hrtimer
>> to check that the next cpu is processing hrtimer interrupts by
>> verifying that a counter is increasing.
>>
>> This patch is useful on systems where the hardlockup detector is not
>> available due to a lack of NMIs, for example most ARM SoCs.
>> Without this patch any cpu stuck with interrupts disabled can
>> cause a hardware watchdog reset with no debugging information,
>> but with this patch the kernel can detect the lockup and panic,
>> which can result in useful debugging info.
>>
>> Signed-off-by: Colin Cross <ccross@android.com>
>> +static void watchdog_check_hardlockup_other_cpu(void)
>> +{
>> +     int cpu;
>> +     cpumask_t cpus = watchdog_cpus;
>> +
>> +     /*
>> +      * Test for hardlockups every 3 samples.  The sample period is
>> +      *  watchdog_thresh * 2 / 5, so 3 samples gets us back to slightly over
>> +      *  watchdog_thresh (over by 20%).
>> +      */
>> +     if (__this_cpu_read(hrtimer_interrupts) % 3 != 0)
>> +             return;
>> +
>> +     /* check for a hardlockup on the next cpu */
>> +     cpu = cpumask_next(smp_processor_id(), &cpus);
>> +     if (cpu >= nr_cpu_ids)
>> +             cpu = cpumask_first(&cpus);
>> +     if (cpu == smp_processor_id())
>> +             return;
>> +
>> +     smp_rmb();
>> +
>> +     if (per_cpu(watchdog_nmi_touch, cpu) == true) {
>> +             per_cpu(watchdog_nmi_touch, cpu) = false;
>> +             return;
>> +     }
>> +
>> +     if (is_hardlockup_other_cpu(cpu)) {
>> +             /* only warn once */
> One possible case for new hotplug CPU that false hardlockup case.
> 1/ Assume CPU1, CPU2 are online, CPU3 is being hotplug:
> CPU3:                                            CPU2:
> watchdog_nmi_enable()
>  per_cpu(watchdog_nmi_touch, cpu) = true;
>  cpumask_set_cpu(cpu, &watchdog_cpus);
>                                                  watchdog_check_hardlockup_other_cpu()
>                                                    per_cpu(watchdog_nmi_touch, cpu) = false; == > Here cpu is CPU3
>
> 2/ Before CPU3's first hrtimer interrupt coming, CPU2 is been offlined.
>   Then CPU1's next CPU is CPU3. But we can not use CPU3's watchdog_nmi_touch to defense
>   false CPU3 hardlock more. When CPU1's hrtimer interrupt coming, it is possible report CPU3
>   false hard lockup.
>
> Is it the case?

Yes, this is the same race condition I pointed out in reply to Don
Zickus earlier in the thread.  I think the easiest solution is to set
per_cpu(watchdog_nmi_touch, next_cpu) = true during cpu offlining.
