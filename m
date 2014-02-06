Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbaBFTsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 14:48:31 -0500
Received: from honeysuckle.london.02.net ([87.194.255.144]:44877 "EHLO
	honeysuckle.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaBFTs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 14:48:29 -0500
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Feb 2014 14:48:29 EST
From: Mark Davies <junk@eslaf.co.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vince@deater.net>, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf,x86,p6: Add userspace RDPMC quirk for P6
References: <20140205102718.GF3229@twins.programming.kicks-ass.net>
	<alpine.DEB.2.02.1402051415190.16225@pianoman.cluster.toy>
	<20140205192012.GL2936@laptop.programming.kicks-ass.net>
	<20140205194851.GE5126@laptop.programming.kicks-ass.net>
Date: Thu, 06 Feb 2014 19:41:37 +0000
In-Reply-To: <20140205194851.GE5126@laptop.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Wed, 5 Feb 2014 20:48:51 +0100")
Message-ID: <871tzgxc3y.fsf@gw.eslaf.co.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter

As I reported the problem I thought I better contribute by testing the
fix.

I took the patch below and managed to change the 3.4.78 code to match
and tried to boot my Pentium Pro system but it hung as before. After
some investigation I discovered the quirk is not being run, in fact no
quirks were being run in init_hw_perf_events as x86_pmu.quirks was NULL.

The problem as far as I can see is that the quirk is added to x86_pmu in
p6_pmu_init but then x86_pmu is reassigned at the end of that function
(x86_pmu = p6_pmu) resetting x86_pmu.quirks to NULL. x86_pmu looks like
it is reassigned again in intel_pmu_init to either core_pmu or intel_pmu
after the call to p6_pmu_init so I am not sure which x86_pmu.quirks
init_hw_perf_events tries to use.

Hopefully that makes sense.

Mark Davies

On Wed, Feb 05 2014, Peter Zijlstra wrote:

> On Wed, Feb 05, 2014 at 08:20:12PM +0100, Peter Zijlstra wrote:
>> On Wed, Feb 05, 2014 at 02:16:43PM -0500, Vince Weaver wrote:
>> > On Wed, 5 Feb 2014, Peter Zijlstra wrote:
>> > 
>> > > P6 class machines can die hard when PCE gets enabled due to CPU
>> > > errata. The safe way it so disable it by default and keep it disabled.
>> > > 
>> > > See errata 26:
>> > 
>> > so you take an errata applicable to a subset of Pentium Pro steppings and 
>> > apply it to the whole p6 line (which includes the whole way up to Pentium 
>> > III)?
>> > 
>> > Or am I missing something in the documentation you link to?
>> 
>> I forgot it went all the way to P-III, let me try and find the other
>> erratas.
>
> OK, Just checked the P-II errata and its not there anymore, so I suppose
> only Family 6 model 1 should have this quirk.
>
> Updated patch below.
>
> ---
> Subject: perf,x86,p6: Add userspace RDPMC quirk for PPro
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Wed Feb 5 11:17:46 CET 2014
>
> PPro machines can die hard when PCE gets enabled due to CPU errata. The
> safe way it so disable it by default and keep it disabled.
>
> See errata 26:
>
> http://download.intel.com/design/archives/processors/pro/docs/24268935.pdf
>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Reported-by: Mark Davies <junk@eslaf.co.uk>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/n/tip-jnbn0qpt3t7ogk4c2q79yq90@git.kernel.org
> ---
>  arch/x86/kernel/cpu/perf_event.c    |    6 +++++-
>  arch/x86/kernel/cpu/perf_event.h    |    1 +
>  arch/x86/kernel/cpu/perf_event_p6.c |   35 +++++++++++++++++++++++++----------
>  3 files changed, 31 insertions(+), 11 deletions(-)
>
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1521,6 +1521,8 @@ static int __init init_hw_perf_events(vo
>  
>  	pr_cont("%s PMU driver.\n", x86_pmu.name);
>  
> +	x86_pmu.attr_rdpmc = 1; /* enable userspace RDPMC usage by default */
> +
>  	for (quirk = x86_pmu.quirks; quirk; quirk = quirk->next)
>  		quirk->func();
>  
> @@ -1534,7 +1536,6 @@ static int __init init_hw_perf_events(vo
>  		__EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_counters) - 1,
>  				   0, x86_pmu.num_counters, 0, 0);
>  
> -	x86_pmu.attr_rdpmc = 1; /* enable userspace RDPMC usage by default */
>  	x86_pmu_format_group.attrs = x86_pmu.format_attrs;
>  
>  	if (x86_pmu.event_attrs)
> @@ -1820,6 +1821,9 @@ static ssize_t set_attr_rdpmc(struct dev
>  	if (ret)
>  		return ret;
>  
> +	if (x86_pmu.attr_rdpmc_broken)
> +		return -ENOTSUPP;
> +
>  	if (!!val != !!x86_pmu.attr_rdpmc) {
>  		x86_pmu.attr_rdpmc = !!val;
>  		smp_call_function(change_rdpmc, (void *)val, 1);
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -409,6 +409,7 @@ struct x86_pmu {
>  	/*
>  	 * sysfs attrs
>  	 */
> +	int		attr_rdpmc_broken;
>  	int		attr_rdpmc;
>  	struct attribute **format_attrs;
>  	struct attribute **event_attrs;
> --- a/arch/x86/kernel/cpu/perf_event_p6.c
> +++ b/arch/x86/kernel/cpu/perf_event_p6.c
> @@ -231,20 +231,35 @@ static __initconst const struct x86_pmu
>  
>  };
>  
> +static __init void p6_pmu_rdpmc_quirk(void)
> +{
> +	pr_warn("Userspace RDPMC support disabled due to CPU errata\n");
> +	x86_pmu.attr_rdpmc_broken = 1;
> +	x86_pmu.attr_rdpmc = 0;
> +}
> +
>  __init int p6_pmu_init(void)
>  {
>  	switch (boot_cpu_data.x86_model) {
> -	case 1:
> -	case 3:  /* Pentium Pro */
> -	case 5:
> -	case 6:  /* Pentium II */
> -	case 7:
> -	case 8:
> -	case 11: /* Pentium III */
> -	case 9:
> -	case 13:
> -		/* Pentium M */
> +	case  1: /* Pentium Pro */
> +		x86_add_quirk(p6_pmu_rdpmc_quirk);
>  		break;
> +
> +	case  3: /* Pentium II - Klamath */
> +	case  5: /* Pentium II - Deschutes */
> +	case  6: /* Pentium II - Mendocino */
> +		break;
> +
> +	case  7: /* Pentium III - Katmai */
> +	case  8: /* Pentium III - Coppermine */
> +	case 10: /* Pentium III Xeon */
> +	case 11: /* Pentium III - Tualatin */
> +		break;
> +
> +	case  9: /* Pentium M - Banias */
> +	case 13: /* Pentium M - Dothan */
> +		break;
> +
>  	default:
>  		pr_cont("unsupported p6 CPU model %d ",
>  			boot_cpu_data.x86_model);
