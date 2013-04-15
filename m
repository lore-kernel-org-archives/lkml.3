Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934944Ab3DOXbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 19:31:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934113Ab3DOXaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 19:30:52 -0400
Date: Mon, 15 Apr 2013 16:30:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Pan, Zhenjie" <zhenjie.pan@intel.com>
Cc: "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "paulus@samba.org" <paulus@samba.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NMI: fix NMI period is not correct when cpu frequency
 changes issue.
Message-Id: <20130415163049.08498e3a8726f0bd6f4d6ebe@linux-foundation.org>
In-Reply-To: <F98D4B5C3D86834DB612ABF854C98B7FB54822@SHSMSX101.ccr.corp.intel.com>
References: <F98D4B5C3D86834DB612ABF854C98B7FB54822@SHSMSX101.ccr.corp.intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Apr 2013 03:47:42 +0000 "Pan, Zhenjie" <zhenjie.pan@intel.com> wrote:

> Watchdog use performance monitor of cpu clock cycle to generate NMI to detect hard lockup.
> But when cpu's frequency changes, the event period will also change.
> It's not as expected as the configuration.
> For example, set the NMI event handler period is 10 seconds when the cpu is 2.0GHz.
> If the cpu changes to 800MHz, the period will be 10*(2000/800)=25 seconds.
> So it may make hard lockup detect not work if the watchdog timeout is not long enough.
> Now, set a notifier to listen to the cpu frequency change.
> And dynamic re-config the NMI event to make the event period correct.
> 
> Signed-off-by: Pan Zhenjie <zhenjie.pan@intel.com>
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 1d795df..717fdac 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -564,7 +564,8 @@ extern void perf_pmu_migrate_context(struct pmu *pmu,
>  				int src_cpu, int dst_cpu);
>  extern u64 perf_event_read_value(struct perf_event *event,
>  				 u64 *enabled, u64 *running);
> -
> +extern void perf_dynamic_adjust_period(struct perf_event *event,
> +						u64 sample_period);
>  
>  struct perf_sample_data {
>  	u64				type;
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 59412d0..96596d1 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -37,6 +37,7 @@
>  #include <linux/ftrace_event.h>
>  #include <linux/hw_breakpoint.h>
>  #include <linux/mm_types.h>
> +#include <linux/math64.h>
>  
>  #include "internal.h"
>  
> @@ -2428,6 +2429,42 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count, bo
>  	}
>  }
>  
> +static int perf_percpu_dynamic_adjust_period(void *info)
> +{
> +	struct perf_event *event = (struct perf_event *)info;

The cast of void * is unneeded and is somewhat undesirable, as it might
suppress valid warnings if the type of `info' is later changed.

> +	s64 left;
> +	u64 old_period = event->hw.sample_period;
> +	u64 new_period = event->attr.sample_period;
> +	u64 shift = 0;
> +
> +	/* precision is enough */
> +	while (old_period > 0xF && new_period > 0xF) {
> +		old_period >>= 1;
> +		new_period >>= 1;
> +		shift++;
> +	}
> +
> +	event->pmu->stop(event, PERF_EF_UPDATE);
> +
> +	left = local64_read(&event->hw.period_left);
> +	left = (s64)div64_u64(left * (event->attr.sample_period >> shift),
> +		(event->hw.sample_period >> shift));
> +	local64_set(&event->hw.period_left, left);
> +
> +	event->hw.sample_period = event->attr.sample_period;
> +
> +	event->pmu->start(event, PERF_EF_RELOAD);
> +
> +	return 0;
> +}
>
> ...
>
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -28,6 +28,7 @@
>  #include <asm/irq_regs.h>
>  #include <linux/kvm_para.h>
>  #include <linux/perf_event.h>
> +#include <linux/cpufreq.h>
>  
>  int watchdog_enabled = 1;
>  int __read_mostly watchdog_thresh = 10;
> @@ -470,6 +471,31 @@ static void watchdog_nmi_disable(unsigned int cpu)
>  	}
>  	return;
>  }
> +
> +static int watchdog_cpufreq_transition(struct notifier_block *nb,
> +					unsigned long val, void *data)
> +{
> +	struct perf_event *event;
> +	struct cpufreq_freqs *freq = data;
> +
> +	if (val == CPUFREQ_POSTCHANGE) {
> +		event = per_cpu(watchdog_ev, freq->cpu);
> +		perf_dynamic_adjust_period(event,
> +				(u64)freq->new * 1000 * watchdog_thresh);

I think this will break the build if CONFIG_PERF_EVENTS=n and
CONFIG_LOCKUP_DETECTOR=y.  I was able to create such a config for
powerpc.  If I'm reading it correctly, CONFIG_PERF_EVENTS cannot be
disabled on x86_64?  If so, what the heck?

> +	}
> +
> +	return 0;
> +}
> +
> +static int __init watchdog_cpufreq(void)
> +{
> +	static struct notifier_block watchdog_nb;
> +	watchdog_nb.notifier_call = watchdog_cpufreq_transition;
> +	cpufreq_register_notifier(&watchdog_nb, CPUFREQ_TRANSITION_NOTIFIER);
> +
> +	return 0;
> +}
> +late_initcall(watchdog_cpufreq);

Overall the patch looks desirable, but it increases the kernel size by
several hundred bytes when CONFIG_CPU_FREQ=n.  It should produce no
code in this case!  Take a look at the magic in
register_hotcpu_notifier(), the way in which it causes all the code to
be removed by the compiler in the CONFIG_HOTPLUG_CPU=n case.  That
trick can be used here.

Also, your patch is a bit buggy - it left watchdog_nb.priority
uninitialized.  Easily fixed with


	static struct notifier_block watchdog_nb = {
		.notifier_call = watchdog_cpufreq_transition,
		.priority = ??,
	};

and that will result in less code generation as well.

Finally, Don's (good) questions about this patch remain unanswered - please
do attend to that.
