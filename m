Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbaJVOgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:36:17 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:40689 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbaJVOgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:36:12 -0400
MIME-Version: 1.0
In-Reply-To: <20141022132749.GB15126@krava.brq.redhat.com>
References: <1412872486-2930-1-git-send-email-eranian@google.com>
	<1412872486-2930-12-git-send-email-eranian@google.com>
	<20141022132749.GB15126@krava.brq.redhat.com>
Date: Wed, 22 Oct 2014 16:36:12 +0200
Message-ID: <CABPqkBQAXsCsUDTbY-UdOSTtKZKmL4ahEGOTZ7ZqXanYFk5AtA@mail.gmail.com>
Subject: Re: [PATCH v2 11/12] perf/x86: make HT bug workaround conditioned on
 HT enabled
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Liang, Kan" <kan.liang@intel.com>, Borislav Petkov <bp@alien8.de>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 3:27 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Thu, Oct 09, 2014 at 06:34:45PM +0200, Stephane Eranian wrote:
>
> SNIP
>
>> + */
>> +static __init int fixup_ht_bug(void)
>> +{
>> +     int cpu = smp_processor_id();
>> +     int w, c;
>> +     /*
>> +      * problem not present on this CPU model, nothing to do
>> +      */
>> +     if (!(x86_pmu.flags & PMU_FL_EXCL_ENABLED))
>> +             return 0;
>> +
>> +     w = cpumask_weight(topology_thread_cpumask(cpu));
>> +     if (w > 1) {
>> +             pr_info("CPU erratum BJ122, BV98, HSD29 worked around\n");
>> +             return 0;
>> +     }
>> +
>> +     watchdog_nmi_disable_all();
>> +
>> +     x86_pmu.flags &= ~(PMU_FL_EXCL_CNTRS | PMU_FL_EXCL_ENABLED);
>> +
>> +     x86_pmu.commit_scheduling = NULL;
>> +     x86_pmu.start_scheduling = NULL;
>> +     x86_pmu.stop_scheduling = NULL;
>> +
>> +     watchdog_nmi_enable_all();
>
> if you build with CONFIG_LOCKUP_DETECTOR=n it wont link:
>
>   LD      init/built-in.o
> arch/x86/built-in.o: In function `fixup_ht_bug':
> /root/linux/arch/x86/kernel/cpu/perf_event_intel.c:3267: undefined reference to `watchdog_nmi_disable_all'
> /root/linux/arch/x86/kernel/cpu/perf_event_intel.c:3275: undefined reference to `watchdog_nmi_enable_all'
>
> I think you need watchdog_nmi_(enable|disable)_all stubs out of kernel/watchdog.c
>
Good catch. In fact the stub cannot be in watchdog.c because it may
not even get compiled. Needs to be
in watchdog.h. I fixed that now.
Thanks
