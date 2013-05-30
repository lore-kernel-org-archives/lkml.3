Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967655Ab3E3Gng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 02:43:36 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:46198 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967574Ab3E3Gnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 02:43:31 -0400
Date: Thu, 30 May 2013 08:43:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.jf.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH 4/6] perf, x86: Move NMI clearing to end of PMI handler v2
Message-ID: <20130530064327.GC5310@gmail.com>
References: <1369261073-1275-1-git-send-email-andi@firstfloor.org>
 <1369261073-1275-5-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369261073-1275-5-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> This avoids some problems with spurious PMIs on Haswell.
> Haswell seems to behave more like P4 in this regard. Do
> the same thing as the P4 perf handler by unmasking
> the NMI only at the end. Shouldn't make any difference
> for earlier family 6 cores.
> 
> Tested on Haswell, IvyBridge, Westmere, Saltwell (Atom)
> 
> v2: Enable only for Haswell
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event.h       |  1 +
>  arch/x86/kernel/cpu/perf_event_intel.c | 22 +++++++++++++---------
>  2 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
> index d2c3b42..a3887a3 100644
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -378,6 +378,7 @@ struct x86_pmu {
>  	struct event_constraint *event_constraints;
>  	struct x86_pmu_quirk *quirks;
>  	int		perfctr_second_write;
> +	bool		late_ack;
>  
>  	/*
>  	 * sysfs attrs
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 2164f39..b7442ff 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1184,16 +1184,12 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
>  
>  	cpuc = &__get_cpu_var(cpu_hw_events);
>  
> -	/*
> -	 * Some chipsets need to unmask the LVTPC in a particular spot
> -	 * inside the nmi handler.  As a result, the unmasking was pushed
> -	 * into all the nmi handlers.
> -	 *
> -	 * This handler doesn't seem to have any issues with the unmasking
> -	 * so it was left at the top.
> +	/* 
> +	 * No known reason to not always do late ACK,
> +	 * but just in case do it opt-in.
>  	 */
> -	apic_write(APIC_LVTPC, APIC_DM_NMI);
> -
> +	if (!x86_pmu.late_ack)
> +		apic_write(APIC_LVTPC, APIC_DM_NMI);
>  	intel_pmu_disable_all();
>  	handled = intel_pmu_drain_bts_buffer();
>  	status = intel_pmu_get_status();
> @@ -1253,6 +1249,13 @@ again:
>  
>  done:
>  	intel_pmu_enable_all(0);
> +	/*
> +	 * Only unmask the NMI after the overflow counters
> +	 * have been reset. This avoids spurious NMIs on
> +	 * Haswell CPUs.
> +	 */
> +	if (x86_pmu.late_ack)
> +		apic_write(APIC_LVTPC, APIC_DM_NMI);
>  	return handled;
>  }
>  
> @@ -2257,6 +2260,7 @@ __init int intel_pmu_init(void)
>  	case 70:
>  	case 71:
>  	case 63:
> +		x86_pmu.late_ack = true;
>  		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
>  		       sizeof(hw_cache_event_ids));
>  		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs,

Ok - this is a lot less intrusive solution.

Once the dust has settled we can try setting late_ack for all models, and 
if that works out without regressing, we can switch to the late ack method 
altogether.

Thanks,

	Ingo
