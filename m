Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702AbaAHWXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:23:18 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:36866 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaAHWXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:23:14 -0500
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <alpine.DEB.2.10.1401081613370.4410@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1401081613370.4410@vincent-weaver-1.um.maine.edu>
Date: Wed, 8 Jan 2014 23:23:13 +0100
Message-ID: <CAMsRxf+1Wng7MxWmBp57J3XS8jQsXtsgNuC1nu-v8MRu_R-vEA@mail.gmail.com>
Subject: Re: [patch/rfc] perf on raspberry-pi without overflow interrupt
From: Stephane Eranian <eranian@googlemail.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vince,

I ran into the same problem myself on my Raspberry PI. In fact,
I am really frustrated by ARM platforms not having that IRQ handled
properly. It is pretty common for manufacturers not to provide the code
to route the IRQ, even though the HW does support it. Sometimes the
specs on how to do this are not even public it seems.

Having the PMU IRQ setup properly would make using the PMU on ARM
a lot more attractive.



On Wed, Jan 8, 2014 at 10:28 PM, Vince Weaver <vincent.weaver@maine.edu> wrote:
>
>
> I'm working on getting the hardware performance counters working on a
> Raspberry-Pi (BCM2835/ARM/1176).
>
> The counters are there, but the overflow interrupt is not hooked up so the
> init code disables perf_event.
>
> The following patch enables perf_event and it works fine for simple
> "perf stat" type workloads.  perf record and anything requiring sampling
> doesn't work (as expected).
>
> I thought I would have to add a periodic timer to catch counter overflows,
> but it turns out that's unnecessary.  From what I can tell even though the
> nPMUIRQ interrupt is not hooked up, the overflows are marked in the status
> register and this is noticed and handled at context-switch time.  So as
> long as the counters overflow less frequently than the context switch
> interval the registers don't overflow.
>
> So my question, is a patch like this acceptable?
>
> Should the perf_event interface handle setups like this better and work
> fine in aggregate mode but return ENOTSUP if a sampled or overflow event
> is attempted?
>
> Vince
>
>
> Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
>
> diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
> index d85055c..ff1a752 100644
> --- a/arch/arm/kernel/perf_event_cpu.c
> +++ b/arch/arm/kernel/perf_event_cpu.c
> @@ -97,8 +97,8 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)
>
>         irqs = min(pmu_device->num_resources, num_possible_cpus());
>         if (irqs < 1) {
> -               pr_err("no irqs for PMUs defined\n");
> -               return -ENODEV;
> +               printk_once("no irqs for PMUs defined, enabling anyway\n");
> +               return 0;
>         }
>
>         for (i = 0; i < irqs; ++i) {
