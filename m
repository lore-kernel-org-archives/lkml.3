Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab3KGRYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 12:24:10 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:36584 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab3KGRYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 12:24:08 -0500
MIME-Version: 1.0
In-Reply-To: <20131106105258.GH10651@twins.programming.kicks-ass.net>
References: <1383670886-30827-1-git-send-email-eranian@google.com>
	<1383670886-30827-4-git-send-email-eranian@google.com>
	<20131106105258.GH10651@twins.programming.kicks-ass.net>
Date: Thu, 7 Nov 2013 18:24:06 +0100
Message-ID: <CABPqkBQg6wdW-1ijL61fmOJAiSNix6mmN-+2GUztim2VN1C1Ew@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] perf,x86: add Intel RAPL PMU support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

Working on it. Found other bugs and cleanups, so I will respin the
entire series.
It will be easier that way.


On Wed, Nov 6, 2013 at 11:52 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Nov 05, 2013 at 06:01:25PM +0100, Stephane Eranian wrote:
>> +static void rapl_exit_cpu(int cpu)
>> +{
>> +     int i, phys_id = topology_physical_package_id(cpu);
>> +
>> +     spin_lock(&rapl_hotplug_lock);
>> +
>> +     /* if CPU not in RAPL mask, nothing to do */
>> +     if (!cpumask_test_and_clear_cpu(cpu, &rapl_cpu_mask))
>> +             goto skip;
>> +
>> +     /* find a new cpu on same package */
>> +     for_each_online_cpu(i) {
>> +             if (i == cpu || i == 0)
>> +                     continue;
>> +             if (phys_id == topology_physical_package_id(i)) {
>> +                     cpumask_set_cpu(i, &rapl_cpu_mask);
>> +                     break;
>> +             }
>> +     }
>> +
>> +     WARN_ON(cpumask_empty(&rapl_cpu_mask));
>> +skip:
>> +     spin_unlock(&rapl_hotplug_lock);
>> +}
>
>> +static int rapl_cpu_notifier(struct notifier_block *self,
>> +                          unsigned long action, void *hcpu)
>> +{
>
>> +     /* select the cpu that collects uncore events */
>> +     switch (action & ~CPU_TASKS_FROZEN) {
>> +     case CPU_DOWN_FAILED:
>> +     case CPU_STARTING:
>> +             rapl_init_cpu(cpu);
>> +             break;
>> +     case CPU_DOWN_PREPARE:
>> +             rapl_exit_cpu(cpu);
>> +             break;
>> +     default:
>> +             break;
>> +     }
>> +
>> +     return NOTIFY_OK;
>> +}
>
> All other uncore drivers call perf_pmu_migrate_context() when the CPU
> the events are registered on goes away.. ?
