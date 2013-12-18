Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab3LRAIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 19:08:11 -0500
Received: from ozlabs.org ([203.10.76.45]:60303 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950Ab3LRAIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 19:08:09 -0500
Message-ID: <1387325285.19507.1.camel@concordia>
Subject: Re: [PATCH V4 09/10] power8, perf: Change BHRB branch filter
 configuration
From: Michael Ellerman <mpe@ellerman.id.au>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, mikey@neuling.org,
        ak@linux.intel.com, eranian@google.com, acme@ghostprotocols.net,
        sukadev@linux.vnet.ibm.com, mingo@kernel.org
Date: Wed, 18 Dec 2013 11:08:05 +1100
In-Reply-To: <52AAC356.1000308@linux.vnet.ibm.com>
References: <20131209062147.51F822C00C5@ozlabs.org>
	 <52AAC356.1000308@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-13 at 13:50 +0530, Anshuman Khandual wrote:
> On 12/09/2013 11:51 AM, Michael Ellerman wrote:
> > 
> > As I said in my comments on version 3 which you ignored:
> > 
> >     I think it would be clearer if we actually checked for the possibilities we
> >     allow and let everything else fall through, eg:
> > 
> > Â Â Â Â Â Â Â Â /* Ignore user/kernel/hv bits */
> > Â Â Â Â Â Â Â Â branch_sample_type &= ~PERF_SAMPLE_BRANCH_PLM_ALL;
> > 
> > Â Â Â Â Â Â Â Â if (branch_sample_type == PERF_SAMPLE_BRANCH_ANY)
> > Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â return 0;
> > 
> > Â Â Â Â Â Â Â Â if (branch_sample_type == PERF_SAMPLE_BRANCH_ANY_CALL)
> > Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â return POWER8_MMCRA_IFM1;
> > Â 
> > Â Â Â Â Â Â Â Â if (branch_sample_type == PERF_SAMPLE_BRANCH_COND)
> > Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â return POWER8_MMCRA_IFM3;
> > Â Â Â Â Â Â Â Â 
> > Â Â Â Â Â Â Â Â return -1;
> > 
> 
> Hey Michael,
> 
> This patch only adds support for the PERF_SAMPLE_BRANCH_COND filter, if the
> over all code flow does not clearly suggest that all combinations of any of
> these HW filters are invalid, then we can go with one more patch to clean
> that up before or after this patch but not here in this patch. Finally the
> code section here will look something like this. Does it sound good ?

Better, but not quite.

> static u64 power8_bhrb_filter_map(u64 branch_sample_type)
> {
>         u64 pmu_bhrb_filter = 0;
> 
>         /* BHRB and regular PMU events share the same privilege state
>          * filter configuration. BHRB is always recorded along with a
>          * regular PMU event. As the privilege state filter is handled
>          * in the basic PMC configuration of the accompanying regular
>          * PMU event, we ignore any separate BHRB specific request.
>          */
> 
>         /* Ignore user, kernel, hv bits */
>         branch_sample_type &= ~PERF_SAMPLE_BRANCH_PLM_ALL;
> 
>         if (branch_sample_type == PERF_SAMPLE_BRANCH_ANY)
>                 return pmu_bhrb_filter;

return 0;

> 
> 
>         if (branch_sample_type == PERF_SAMPLE_BRANCH_ANY_CALL) {
>                 pmu_bhrb_filter |= POWER8_MMCRA_IFM1;
>                 return pmu_bhrb_filter;

return POWER8_MMCRA_IFM1;

>         }
> 
>         if (branch_sample_type == PERF_SAMPLE_BRANCH_COND) {
>                 pmu_bhrb_filter |= POWER8_MMCRA_IFM3;
>                 return pmu_bhrb_filter;

return POWER8_MMCRA_IFM3;

>         }
> 
>         /* Every thing else is unsupported */
>         return -1;
> }

cheers


