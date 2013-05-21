Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab3EUPVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 11:21:14 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:5138
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752134Ab3EUPVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 11:21:12 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 7
X-BigFish: VPS7(z329eq3cfckz98dI103dK1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
X-WSS-ID: 0MN5MMX-02-4AC-02
X-M-MSG: 
Date: Tue, 21 May 2013 10:20:58 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Robert Richter <rric@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Josh Boyer <jwboyer@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <gleb@redhat.com>
Subject: Re: Drop WARN on AMD lack of perfctrs
Message-ID: <20130521152058.GA8263@jshin-Toonie>
References: <20130516205558.GE8356@rric.localhost>
 <20130516213420.GB31393@pd.tnic>
 <20130517090451.GQ19669@dyad.programming.kicks-ass.net>
 <20130517091651.GB23035@pd.tnic>
 <20130517092741.GR19669@dyad.programming.kicks-ass.net>
 <20130517094551.GE23035@pd.tnic>
 <20130517103600.GG8356@rric.localhost>
 <20130517105730.GD5162@dyad.programming.kicks-ass.net>
 <20130521085630.GA1860@rric.localhost>
 <20130521110537.GG26912@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130521110537.GG26912@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 01:05:37PM +0200, Peter Zijlstra wrote:
> On Tue, May 21, 2013 at 10:56:30AM +0200, Robert Richter wrote:
> > On 17.05.13 12:57:30, Peter Zijlstra wrote:
> > > 
> > > So what about something like the below?
> > 
> > See my comments below, otherwise it looks fine to me.
> 
> I've been liberal and read an Ack there, holler if that needs be amended.
> 
> > There is the question about core performance counters and its
> > constraints on fam16h. Not sure if there are any. Cc'ing Jacob.
> 
> Currently the code doesn't work for Fam16h afaict, so I didn't wreck
> that did I?

Hi, right, Family 16h does not have perfctr_core, instead it still has
the 4 legacy performance counter registers just like Family 10h, and
so does not have any special constraints as 15h's perfctr_core does.

Thanks!

Acked-by: Jacob Shin <jacob.shin@amd.com>

> 
> > >  	/*
> > >  	 * If core performance counter extensions exists, we must use
> > >  	 * MSR_F15H_PERF_CTL/MSR_F15H_PERF_CTR msrs. See also
> > 
> > ... amd_pmu_addr_offset():
> > 
> >          * If core performance counter extensions exists, we must use
> >          * MSR_F15H_PERF_CTL/MSR_F15H_PERF_CTR msrs. See also
> >          * amd_pmu_addr_offset().
> > 
> 
> Done.
> 
> > > @@ -675,8 +670,7 @@ static int setup_perfctr_core(void)
> > >  	x86_pmu.perfctr		= MSR_F15H_PERF_CTR;
> > >  	x86_pmu.num_counters	= AMD64_NUM_COUNTERS_CORE;
> > >  
> > > -	printk(KERN_INFO "perf: AMD core performance counters detected\n");
> > > -
> > > +	pr_cont("core perfctr, ");
> > >  	return 0;
> > >  }
> > >  
> > > @@ -688,8 +682,8 @@ __init int amd_pmu_init(void)
> > >  
> > >  	x86_pmu = amd_pmu;
> > >  
> > > -	setup_event_constraints();
> > > -	setup_perfctr_core();
> > > +	if (cpu_has_perfctr_core && amd_core_pmu_init())
> > > +		return -ENODEV;
> > 
> > Better return result of amd_core_pmu_init().
> 
> Done.. that was admittedly a tad lazy of me :-)
> 
> ---
> Subject: perf, x86: Rework AMD PMU init code
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Fri, 17 May 2013 12:57:30 +0200
> 
> Josh reported that his QEMU is a bad hardware emulator and trips a
> WARN in the AMD PMU init code. He requested the WARN be turned into a
> pr_err() or similar.
> 
> While there, rework the code a little.
> 
> Reported-by: Josh Boyer <jwboyer@redhat.com>
> Acked-by: Robert Richter <rric@kernel.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/x86/kernel/cpu/perf_event_amd.c |   34 +++++++++++++++++-----------------
>  1 file changed, 17 insertions(+), 17 deletions(-)
> 
> --- a/arch/x86/kernel/cpu/perf_event_amd.c
> +++ b/arch/x86/kernel/cpu/perf_event_amd.c
> @@ -648,48 +648,48 @@ static __initconst const struct x86_pmu
>  	.cpu_dead		= amd_pmu_cpu_dead,
>  };
>  
> -static int setup_event_constraints(void)
> +__init int amd_core_pmu_init(void)
>  {
> -	if (boot_cpu_data.x86 == 0x15)
> +	if (!cpu_has_perfctr_core)
> +		return 0;
> +
> +	switch (boot_cpu_data.x86) {
> +	case 0x15:
> +		pr_cont("Fam15h ");
>  		x86_pmu.get_event_constraints = amd_get_event_constraints_f15h;
> -	return 0;
> -}
> +		break;
>  
> -static int setup_perfctr_core(void)
> -{
> -	if (!cpu_has_perfctr_core) {
> -		WARN(x86_pmu.get_event_constraints == amd_get_event_constraints_f15h,
> -		     KERN_ERR "Odd, counter constraints enabled but no core perfctrs detected!");
> +	default:
> +		pr_err("core perfctr but no constraints; unknown hardware!\n");
>  		return -ENODEV;
>  	}
>  
> -	WARN(x86_pmu.get_event_constraints == amd_get_event_constraints,
> -	     KERN_ERR "hw perf events core counters need constraints handler!");
> -
>  	/*
>  	 * If core performance counter extensions exists, we must use
>  	 * MSR_F15H_PERF_CTL/MSR_F15H_PERF_CTR msrs. See also
> -	 * x86_pmu_addr_offset().
> +	 * amd_pmu_addr_offset().
>  	 */
>  	x86_pmu.eventsel	= MSR_F15H_PERF_CTL;
>  	x86_pmu.perfctr		= MSR_F15H_PERF_CTR;
>  	x86_pmu.num_counters	= AMD64_NUM_COUNTERS_CORE;
>  
> -	printk(KERN_INFO "perf: AMD core performance counters detected\n");
> -
> +	pr_cont("core perfctr, ");
>  	return 0;
>  }
>  
>  __init int amd_pmu_init(void)
>  {
> +	int ret;
> +
>  	/* Performance-monitoring supported from K7 and later: */
>  	if (boot_cpu_data.x86 < 6)
>  		return -ENODEV;
>  
>  	x86_pmu = amd_pmu;
>  
> -	setup_event_constraints();
> -	setup_perfctr_core();
> +	ret = amd_core_pmu_init();
> +	if (ret)
> +		return ret;
>  
>  	/* Events are common for all AMDs */
>  	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
> 
> 

