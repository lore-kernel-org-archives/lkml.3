Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaBJDLq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 22:11:46 -0500
Received: from mga14.intel.com ([143.182.124.37]:33877 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbaBJDLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 22:11:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,815,1384329600"; 
   d="scan'208";a="472516921"
Message-ID: <52F8436E.8090907@intel.com>
Date: Mon, 10 Feb 2014 11:11:42 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
CC: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, ak@linux.intel.com
Subject: Re: [PATCH v1 03/10] perf/x86/uncore: do not assume PCI fixed ctrs
 have more than 32 bits
References: <1391432142-18723-1-git-send-email-eranian@google.com> <1391432142-18723-4-git-send-email-eranian@google.com>
In-Reply-To: <1391432142-18723-4-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2014 08:55 PM, Stephane Eranian wrote:
> The current code assumes all PCI fixed counters implement more than
> 32-bit hardware counters. The actual width is then round up to 64 to
> enable base + 8 * idx calculations.
> 
> Not all PMUs necessarily implement counters with more than 32-bits.
> The patch makes the uncore_pci_perf_ctr() function dynamically
> determine the actual bits width of a pci perf counter.
> 
> This patch paves the way for handling more than one uncore fixed
> counter per PMU box.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_uncore.h |   31 ++++++++++++++++---------
>  1 file changed, 20 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
> index 77dc9a5..f5549cf 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
> @@ -548,10 +548,29 @@ unsigned uncore_pci_event_ctl(struct intel_uncore_box *box, int idx)
>  	return idx * 4 + box->pmu->type->event_ctl;
>  }
>  
> +static inline int uncore_perf_ctr_bits(struct intel_uncore_box *box)
> +{
> +	return box->pmu->type->perf_ctr_bits;
> +}
> +
> +static inline int uncore_fixed_ctr_bits(struct intel_uncore_box *box)
> +{
> +	return box->pmu->type->fixed_ctr_bits;
> +}
> +
>  static inline
>  unsigned uncore_pci_perf_ctr(struct intel_uncore_box *box, int idx)
>  {
> -	return idx * 8 + box->pmu->type->perf_ctr;
> +	int bits, bytes;
> +
> +	if (idx == UNCORE_PMC_IDX_FIXED)
> +		bits = uncore_fixed_ctr_bits(box);
> +	else
> +		bits = uncore_perf_ctr_bits(box);
> +
> +	bytes = round_up(bits, 8);

should this be "round_up(bits, 32) / 8" ?

Regards
Yan, Zheng

> +
> +	return idx * bytes + box->pmu->type->perf_ctr;
>  }
>  
>  static inline unsigned uncore_msr_box_offset(struct intel_uncore_box *box)
> @@ -633,16 +652,6 @@ unsigned uncore_perf_ctr(struct intel_uncore_box *box, int idx)
>  		return uncore_msr_perf_ctr(box, idx);
>  }
>  
> -static inline int uncore_perf_ctr_bits(struct intel_uncore_box *box)
> -{
> -	return box->pmu->type->perf_ctr_bits;
> -}
> -
> -static inline int uncore_fixed_ctr_bits(struct intel_uncore_box *box)
> -{
> -	return box->pmu->type->fixed_ctr_bits;
> -}
> -
>  static inline int uncore_num_counters(struct intel_uncore_box *box)
>  {
>  	return box->pmu->type->num_counters;
> 

