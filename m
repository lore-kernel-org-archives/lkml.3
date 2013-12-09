Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760786Ab3LIGWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 01:22:03 -0500
Received: from ozlabs.org ([203.10.76.45]:56939 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760606Ab3LIGVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 01:21:48 -0500
In-Reply-To: <1386153162-11225-10-git-send-email-khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        khandual@linux.vnet.ibm.com
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: mikey@neuling.org, ak@linux.intel.com, eranian@google.com,
        acme@ghostprotocols.net, sukadev@linux.vnet.ibm.com, mingo@kernel.org
Subject: Re: [PATCH V4 09/10] power8, perf: Change BHRB branch filter configuration
Message-Id: <20131209062147.51F822C00C5@ozlabs.org>
Date: Mon,  9 Dec 2013 17:21:47 +1100 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-12 at 10:32:41 UTC, Anshuman Khandual wrote:
> Powerpc kernel now supports SW based branch filters for book3s systems with some
> specifc requirements while dealing with HW supported branch filters in order to
> achieve overall OR semantics prevailing in perf branch stack sampling framework.
> This patch adapts the BHRB branch filter configuration to meet those protocols.
> POWER8 PMU does support 3 branch filters (out of which two are getting used in
> perf branch stack) which are mutually exclussive and cannot be ORed with each
> other. This implies that PMU can only handle one HW based branch filter request
> at any point of time. For all other combinations PMU will pass it on to the SW.
> 
> Also the combination of PERF_SAMPLE_BRANCH_ANY_CALL and PERF_SAMPLE_BRANCH_COND
> can now be handled in SW, hence we dont error them out anymore.
> 
> diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.c
> index 03c5b8d..6021349 100644
> --- a/arch/powerpc/perf/power8-pmu.c
> +++ b/arch/powerpc/perf/power8-pmu.c
> @@ -561,7 +561,56 @@ static int power8_generic_events[] = {
>  
>  static u64 power8_bhrb_filter_map(u64 branch_sample_type, u64 *filter_mask)
>  {
> -	u64 pmu_bhrb_filter = 0;
> +	u64 x, tmp, pmu_bhrb_filter = 0;
> +	*filter_mask = 0;
> +
> +	/* No branch filter requested */
> +	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY) {
> +		*filter_mask = PERF_SAMPLE_BRANCH_ANY;
> +		return pmu_bhrb_filter;
> +	}
> +
> +	/*
> +	 * P8 does not support oring of PMU HW branch filters. Hence
> +	 * if multiple branch filters are requested which includes filters
> +	 * supported in PMU, still go ahead and clear the PMU based HW branch
> +	 * filter component as in this case all the filters will be processed
> + 	 * in SW.

Leading space there.

> +	 */
> +	tmp = branch_sample_type;
> +
> +	/* Remove privilege filters before comparison */
> +	tmp &= ~PERF_SAMPLE_BRANCH_USER;
> +	tmp &= ~PERF_SAMPLE_BRANCH_KERNEL;
> +	tmp &= ~PERF_SAMPLE_BRANCH_HV;
> +
> +	for_each_branch_sample_type(x) {
> +		/* Ignore privilege requests */
> +		if ((x == PERF_SAMPLE_BRANCH_USER) || (x == PERF_SAMPLE_BRANCH_KERNEL) || (x == PERF_SAMPLE_BRANCH_HV))
> +			continue;
> +
> +		if (!(tmp & x))
> +			continue;
> +
> +               /* Supported HW PMU filters */
> +		if (tmp & PERF_SAMPLE_BRANCH_ANY_CALL) {
> +			tmp &= ~PERF_SAMPLE_BRANCH_ANY_CALL;
> +			if (tmp) {
> +				pmu_bhrb_filter = 0;
> +				*filter_mask = 0;
> +				return pmu_bhrb_filter;
> +			}
> +		}
> +
> +		if (tmp & PERF_SAMPLE_BRANCH_COND) {
> +			tmp &= ~PERF_SAMPLE_BRANCH_COND;
> +			if (tmp) {
> +				pmu_bhrb_filter = 0;
> +				*filter_mask = 0;
> +				return pmu_bhrb_filter;
> +			}
> +		}
> +	}

>  
>  	/* BHRB and regular PMU events share the same privilege state
>  	 * filter configuration. BHRB is always recorded along with a
> @@ -570,34 +619,20 @@ static u64 power8_bhrb_filter_map(u64 branch_sample_type, u64 *filter_mask)
>  	 * PMU event, we ignore any separate BHRB specific request.
>  	 */
>  
> -	/* No branch filter requested */
> -	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY)
> -		return pmu_bhrb_filter;
> -
> -	/* Invalid branch filter options - HW does not support */
> -	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY_RETURN)
> -		return -1;
> -
> -	if (branch_sample_type & PERF_SAMPLE_BRANCH_IND_CALL)
> -		return -1;
> -
> +	/* Supported individual branch filters */
>  	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY_CALL) {
>  		pmu_bhrb_filter |= POWER8_MMCRA_IFM1;
> +		*filter_mask    |= PERF_SAMPLE_BRANCH_ANY_CALL;
>  		return pmu_bhrb_filter;
>  	}
>  
>  	if (branch_sample_type & PERF_SAMPLE_BRANCH_COND) {
>  		pmu_bhrb_filter |= POWER8_MMCRA_IFM3;
> +		*filter_mask    |= PERF_SAMPLE_BRANCH_COND;
>  		return pmu_bhrb_filter;
>  	}
>  
> -	/* PMU does not support ANY combination of HW BHRB filters */
> -	if ((branch_sample_type & PERF_SAMPLE_BRANCH_ANY_CALL) &&
> -			(branch_sample_type & PERF_SAMPLE_BRANCH_COND))
> -		return -1;
> -
> -	/* Every thing else is unsupported */
> -	return -1;
> +	return pmu_bhrb_filter;
>  }


As I said in my comments on version 3 which you ignored:

    I think it would be clearer if we actually checked for the possibilities we
    allow and let everything else fall through, eg:

        /* Ignore user/kernel/hv bits */
        branch_sample_type &= ~PERF_SAMPLE_BRANCH_PLM_ALL;

        if (branch_sample_type == PERF_SAMPLE_BRANCH_ANY)
                return 0;

        if (branch_sample_type == PERF_SAMPLE_BRANCH_ANY_CALL)
                return POWER8_MMCRA_IFM1;
 
        if (branch_sample_type == PERF_SAMPLE_BRANCH_COND)
                return POWER8_MMCRA_IFM3;
        
        return -1;


cheers
