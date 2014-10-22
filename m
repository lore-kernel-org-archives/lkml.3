Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaJVN2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:28:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbaJVN2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:28:37 -0400
Date: Wed, 22 Oct 2014 15:27:49 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, kan.liang@intel.com, bp@alien8.de,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH v2 11/12] perf/x86: make HT bug workaround conditioned on
 HT enabled
Message-ID: <20141022132749.GB15126@krava.brq.redhat.com>
References: <1412872486-2930-1-git-send-email-eranian@google.com>
 <1412872486-2930-12-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412872486-2930-12-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 06:34:45PM +0200, Stephane Eranian wrote:

SNIP

> + */
> +static __init int fixup_ht_bug(void)
> +{
> +	int cpu = smp_processor_id();
> +	int w, c;
> +	/*
> +	 * problem not present on this CPU model, nothing to do
> +	 */
> +	if (!(x86_pmu.flags & PMU_FL_EXCL_ENABLED))
> +		return 0;
> +
> +	w = cpumask_weight(topology_thread_cpumask(cpu));
> +	if (w > 1) {
> +		pr_info("CPU erratum BJ122, BV98, HSD29 worked around\n");
> +		return 0;
> +	}
> +
> +	watchdog_nmi_disable_all();
> +
> +	x86_pmu.flags &= ~(PMU_FL_EXCL_CNTRS | PMU_FL_EXCL_ENABLED);
> +
> +	x86_pmu.commit_scheduling = NULL;
> +	x86_pmu.start_scheduling = NULL;
> +	x86_pmu.stop_scheduling = NULL;
> +
> +	watchdog_nmi_enable_all();

if you build with CONFIG_LOCKUP_DETECTOR=n it wont link:

  LD      init/built-in.o
arch/x86/built-in.o: In function `fixup_ht_bug':
/root/linux/arch/x86/kernel/cpu/perf_event_intel.c:3267: undefined reference to `watchdog_nmi_disable_all'
/root/linux/arch/x86/kernel/cpu/perf_event_intel.c:3275: undefined reference to `watchdog_nmi_enable_all'

I think you need watchdog_nmi_(enable|disable)_all stubs out of kernel/watchdog.c

jirka
