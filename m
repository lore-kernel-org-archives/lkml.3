Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab3EVHOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 03:14:19 -0400
Received: from ozlabs.org ([203.10.76.45]:46484 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042Ab3EVHOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 03:14:16 -0400
Message-ID: <1369206855.12874.9.camel@concordia>
Subject: Re: [PATCH 1/2] powerpc, perf: Ignore separate BHRB privilege state
 filter request
From: Michael Ellerman <michael@ellerman.id.au>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, mikey@neuling.org
Date: Wed, 22 May 2013 17:14:15 +1000
In-Reply-To: <1369201667-9048-2-git-send-email-khandual@linux.vnet.ibm.com>
References: <1369201667-9048-1-git-send-email-khandual@linux.vnet.ibm.com>
	 <1369201667-9048-2-git-send-email-khandual@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-22 at 11:17 +0530, Anshuman Khandual wrote:
> Completely ignore BHRB privilege state filter request as we are
> already configuring MMCRA register with privilege state filtering
> attribute for the accompanying PMU event. This would help achieve
> cleaner user space interaction for BHRB.

Your description from patch 0 should be here.


> diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.c
> index f7d1c4f..8ed323d 100644
> --- a/arch/powerpc/perf/power8-pmu.c
> +++ b/arch/powerpc/perf/power8-pmu.c
> @@ -525,16 +525,17 @@ static u64 power8_bhrb_filter_map(u64 branch_sample_type)
>  	u64 pmu_bhrb_filter = 0;
>  	u64 br_privilege = branch_sample_type & ONLY_PLM;
>  
> -	/* BHRB and regular PMU events share the same prvillege state
> +	/* BHRB and regular PMU events share the same prvilege state

Please spell "privilege" correctly.

>  	 * filter configuration. BHRB is always recorded along with a
> -	 * regular PMU event. So privilege state filter criteria for BHRB
> -	 * and the companion PMU events has to be the same. As a default
> -	 * "perf record" tool sets all privillege bits ON when no filter
> -	 * criteria is provided in the command line. So as along as all
> -	 * privillege bits are ON or they are OFF, we are good to go.
> +	 * regular PMU event. So privilege state filter criteria for
> +	 * the BHRB and the companion PMU events has to be the same.
> +	 * Separate BHRB privillege state filter requests would be
> +	 * ignored.
>  	 */

This comment doesn't make sense to me with the updated code.

It still says "privilege state filter criteria for the BHRB and the
companion PMU events has to be the same".

But they don't, right?

What it should say is "we ignore the privilege bits in the branch sample
type because they are handled by the underlying PMC configuration" - or
something like that.

> -	if ((br_privilege != 7) && (br_privilege != 0))
> -		return -1;
> +
> +	if (br_privilege)
> +		pr_info("BHRB privilege state filter request %llx ignored\n",
> +								br_privilege);

Don't do that. Ignoring the br_privilege is either the right thing to do
in which case we do it and print nothing, or it doesn't make sense and
we reject it.

cheers

