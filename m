Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763094Ab3DCStc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 14:49:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760323Ab3DCStb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 14:49:31 -0400
Date: Wed, 3 Apr 2013 14:00:08 -0400
From: Don Zickus <dzickus@redhat.com>
To: "Pan, Zhenjie" <zhenjie.pan@intel.com>
Cc: "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "paulus@samba.org" <paulus@samba.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NMI: fix NMI period is not correct when cpu frequency
 changes issue.
Message-ID: <20130403180008.GF79013@redhat.com>
References: <F98D4B5C3D86834DB612ABF854C98B7FB54822@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F98D4B5C3D86834DB612ABF854C98B7FB54822@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 03:47:42AM +0000, Pan, Zhenjie wrote:
> Watchdog use performance monitor of cpu clock cycle to generate NMI to detect hard lockup.
> But when cpu's frequency changes, the event period will also change.
> It's not as expected as the configuration.
> For example, set the NMI event handler period is 10 seconds when the cpu is 2.0GHz.
> If the cpu changes to 800MHz, the period will be 10*(2000/800)=25 seconds.
> So it may make hard lockup detect not work if the watchdog timeout is not long enough.
> Now, set a notifier to listen to the cpu frequency change.
> And dynamic re-config the NMI event to make the event period correct.

The idea makes sense.  A quick glance and things seem ok.  How does it
look when you tested it?  How often was the frequency changing? Or the
callback being called?  That was always my concern, the cpu frequency was
jumping around to much causing thrashing by the watchdog.

Thanks for doing this work.  I didn't realize how easy it is to hook into
the cpufreq notifier.

Cheers,
Don

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
> +
> +void perf_dynamic_adjust_period(struct perf_event *event, u64 sample_period)
> +{
> +	event->attr.sample_period = sample_period;
> +	cpu_function_call(event->cpu, perf_percpu_dynamic_adjust_period, event);
> +}
> +EXPORT_SYMBOL_GPL(perf_dynamic_adjust_period);
> +
>  /*
>   * combine freq adjustment with unthrottling to avoid two passes over the
>   * events. At the same time, make sure, having freq events does not change
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 4a94467..34a953a 100644
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
>  #else
>  static int watchdog_nmi_enable(unsigned int cpu) { return 0; }
>  static void watchdog_nmi_disable(unsigned int cpu) { return; }
> -- 
> 1.7.9.5
