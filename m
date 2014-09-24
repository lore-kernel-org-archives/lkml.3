Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbaIXU1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:27:45 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:64751 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbaIXU1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:27:42 -0400
Date: Wed, 24 Sep 2014 21:27:39 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 08/11] perf/x86/intel: Add Intel Cache QoS Monitoring
 support
Message-ID: <20140924202739.GP18635@console-pimps.org>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
 <1411567455-31264-9-git-send-email-matt@console-pimps.org>
 <874mvx6kgl.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874mvx6kgl.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep, at 09:40:10AM, Andi Kleen wrote:
> Matt Fleming <matt@console-pimps.org> writes:
> >
> > diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
> > index 7e1fd4e08552..8abb18fbcd13 100644
> > --- a/arch/x86/kernel/cpu/Makefile
> > +++ b/arch/x86/kernel/cpu/Makefile
> > @@ -38,7 +38,7 @@ obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_knc.o perf_event_p4.o
> >  obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o
> >  obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore.o perf_event_intel_uncore_snb.o
> >  obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore_snbep.o perf_event_intel_uncore_nhmex.o
> > -obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_rapl.o
> > +obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_rapl.o perf_event_intel_cqm.o
> 
> What's missing to be able to make this a module?
 
Not sure, that's not something I'd thought of. I simply copied every
other PMU driver in this directory.

But as an experiment I tried it, and the only thing that appears to be
necessary is adding EXPORT_SYMBOL_GPL() to events_sysfs_show.

> > +
> > +	/*
> > +	 * Is @cpu a designated cqm reader?
> > +	 */
> > +	if (!cpumask_test_and_clear_cpu(cpu, &cqm_cpumask))
> > +		return;
> > +
> > +	for_each_online_cpu(i) {
> 
> Likely possible cpus to avoid races? Otherwise you'll need more locking.
 
I was under the impression that CPU_DOWN_PREPARE notifiers were
serialized against cpu hotplug. And reading the code, that does appear
to be so.

What race have you got in mind?

> > +static int __init intel_cqm_init(void)
> > +{
> > +	int i, cpu, ret;
> > +
> > +	if (!cpu_has(&boot_cpu_data, X86_FEATURE_CQM_OCCUP_LLC))
> > +		return -ENODEV;
> 
> This should use cpufeature.h
 
What? Please be more explicit.

> > +
> > +	cqm_l3_scale = boot_cpu_data.x86_cache_occ_scale;
> > +
> > +	/*
> > +	 * It's possible that not all resources support the same number
> > +	 * of RMIDs. Instead of making scheduling much more complicated
> > +	 * (where we have to match a task's RMID to a cpu that supports
> > +	 * that many RMIDs) just find the minimum RMIDs supported across
> > +	 * all cpus.
> > +	 *
> > +	 * Also, check that the scales match on all cpus.
> > +	 */
> > +	for_each_online_cpu(cpu) {
> 
> And this should take the cpu hotplug lock (although it may be
> latent at this point if it's only running at early initializion)
 
Good catch, this is racy. I'll fix this up.

> But in fact what good is the test then if you only
> every likely check cpu #0?

We don't, we check every online cpu, not just cpu 0.

-- 
Matt Fleming, Intel Open Source Technology Center
