Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaBJDRQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 22:17:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:13568 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbaBJDRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 22:17:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,815,1384329600"; 
   d="scan'208";a="472518682"
Message-ID: <52F844BA.2050602@intel.com>
Date: Mon, 10 Feb 2014 11:17:14 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
CC: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, ak@linux.intel.com
Subject: Re: [PATCH v1 07/10] perf/x86/uncore: allow more than one fixed counter
 per box
References: <1391432142-18723-1-git-send-email-eranian@google.com> <1391432142-18723-8-git-send-email-eranian@google.com>
In-Reply-To: <1391432142-18723-8-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2014 08:55 PM, Stephane Eranian wrote:
> This patch modifies some of the helper functions to support
> more than one fixed counter per uncore PCI PMU box.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c |    4 ++--
>  arch/x86/kernel/cpu/perf_event_intel_uncore.h |   22 +++++++++++++---------
>  2 files changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> index 2980994c..69a4ad0 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -2777,8 +2777,8 @@ static void uncore_assign_hw_event(struct intel_uncore_box *box, struct perf_eve
>  	hwc->idx = idx;
>  	hwc->last_tag = ++box->tags[idx];
>  
> -	if (hwc->idx == UNCORE_PMC_IDX_FIXED) {
> -		hwc->event_base = uncore_fixed_ctr(box);
> +	if (hwc->idx >= UNCORE_PMC_IDX_FIXED) {
> +		hwc->event_base = uncore_fixed_ctr(box, idx);
>  		hwc->config_base = uncore_fixed_ctl(box);
>  		return;
>  	}
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
> index 433c180..c63a3ff 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
> @@ -538,9 +538,18 @@ static inline unsigned uncore_pci_fixed_ctl(struct intel_uncore_box *box)
>  	return box->pmu->type->fixed_ctl;
>  }
>  
> -static inline unsigned uncore_pci_fixed_ctr(struct intel_uncore_box *box)
> +static inline int uncore_fixed_ctr_bits(struct intel_uncore_box *box)
> +{
> +	return box->pmu->type->fixed_ctr_bits;
> +}
> +
> +static inline unsigned uncore_pci_fixed_ctr(struct intel_uncore_box *box,
> +					    int idx)
>  {
> -	return box->pmu->type->fixed_ctr;
> +	int bits = uncore_fixed_ctr_bits(box);
> +	int bytes = round_up(bits, 8);
> +
> +	return idx * bytes + box->pmu->type->fixed_ctr;
>  }

should this be:
int bytes = round_up(bits, 32) / 8;
return (idx - UNCORE_PMC_IDX_FIXED) * bytes + box->pmu->type->fixed_ctr;
?

Regards
Yan, Zheng

>  
>  static inline
> @@ -554,11 +563,6 @@ static inline int uncore_perf_ctr_bits(struct intel_uncore_box *box)
>  	return box->pmu->type->perf_ctr_bits;
>  }
>  
> -static inline int uncore_fixed_ctr_bits(struct intel_uncore_box *box)
> -{
> -	return box->pmu->type->fixed_ctr_bits;
> -}
> -
>  static inline
>  unsigned uncore_pci_perf_ctr(struct intel_uncore_box *box, int idx)
>  {
> @@ -627,10 +631,10 @@ unsigned uncore_fixed_ctl(struct intel_uncore_box *box)
>  }
>  
>  static inline
> -unsigned uncore_fixed_ctr(struct intel_uncore_box *box)
> +unsigned uncore_fixed_ctr(struct intel_uncore_box *box, int idx)
>  {
>  	if (box->pci_dev)
> -		return uncore_pci_fixed_ctr(box);
> +		return uncore_pci_fixed_ctr(box, idx);
>  	else
>  		return uncore_msr_fixed_ctr(box);
>  }
> 

