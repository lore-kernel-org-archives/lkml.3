Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab3KZGGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 01:06:25 -0500
Received: from ozlabs.org ([203.10.76.45]:47961 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103Ab3KZGGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 01:06:20 -0500
In-Reply-To: <1381906617-11392-3-git-send-email-khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: mikey@neuling.org, sukadev@linux.vnet.ibm.com, michaele@au1.ibm.com,
        eranian@google.com
Subject: RE: [V3 02/10] powerpc, perf: Enable conditional branch filter for POWER8
Message-Id: <20131126060619.48B5D2C00BC@ozlabs.org>
Date: Tue, 26 Nov 2013 17:06:19 +1100 (EST)
From: michael@ozlabs.org (mpe@ellerman.id.au)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-16-10 at 06:56:49 UTC, Anshuman Khandual wrote:
> Enables conditional branch filter support for POWER8
> utilizing MMCRA register based filter and also invalidates
> a BHRB branch filter combination involving conditional
> branches.
> 
> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> ---
>  arch/powerpc/perf/power8-pmu.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.c
> index 2ee4a70..6e28587 100644
> --- a/arch/powerpc/perf/power8-pmu.c
> +++ b/arch/powerpc/perf/power8-pmu.c
> @@ -580,11 +580,21 @@ static u64 power8_bhrb_filter_map(u64 branch_sample_type)
>  	if (branch_sample_type & PERF_SAMPLE_BRANCH_IND_CALL)
>  		return -1;
>  
> +	/* Invalid branch filter combination - HW does not support */
> +	if ((branch_sample_type & PERF_SAMPLE_BRANCH_ANY_CALL) &&
> +			(branch_sample_type & PERF_SAMPLE_BRANCH_COND))
> +		return -1;

What this doesn't make obvious is that the hardware doesn't support any
combinations. It just happens that these are the only two possibilities we
allow, and so this is the only combination we have to disallow.

>
>  	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY_CALL) {
>  		pmu_bhrb_filter |= POWER8_MMCRA_IFM1;
>  		return pmu_bhrb_filter;
>  	}
>  
> +	if (branch_sample_type & PERF_SAMPLE_BRANCH_COND) {
> +		pmu_bhrb_filter |= POWER8_MMCRA_IFM3;
> +		return pmu_bhrb_filter;
> +	}
> +
>  	/* Every thing else is unsupported */
>  	return -1;
>  }

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
