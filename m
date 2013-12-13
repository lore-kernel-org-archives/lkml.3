Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab3LMIW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 03:22:26 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:56739 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3LMIWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 03:22:25 -0500
Message-ID: <52AAC356.1000308@linux.vnet.ibm.com>
Date: Fri, 13 Dec 2013 13:50:38 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, mikey@neuling.org,
        ak@linux.intel.com, eranian@google.com, acme@ghostprotocols.net,
        sukadev@linux.vnet.ibm.com, mingo@kernel.org
Subject: Re: [PATCH V4 09/10] power8, perf: Change BHRB branch filter configuration
References: <20131209062147.51F822C00C5@ozlabs.org>
In-Reply-To: <20131209062147.51F822C00C5@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121308-8878-0000-0000-00000A0D870F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 11:51 AM, Michael Ellerman wrote:
> 
> As I said in my comments on version 3 which you ignored:
> 
>     I think it would be clearer if we actually checked for the possibilities we
>     allow and let everything else fall through, eg:
> 
> Â Â Â Â Â Â Â Â /* Ignore user/kernel/hv bits */
> Â Â Â Â Â Â Â Â branch_sample_type &= ~PERF_SAMPLE_BRANCH_PLM_ALL;
> 
> Â Â Â Â Â Â Â Â if (branch_sample_type == PERF_SAMPLE_BRANCH_ANY)
> Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â return 0;
> 
> Â Â Â Â Â Â Â Â if (branch_sample_type == PERF_SAMPLE_BRANCH_ANY_CALL)
> Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â return POWER8_MMCRA_IFM1;
> Â 
> Â Â Â Â Â Â Â Â if (branch_sample_type == PERF_SAMPLE_BRANCH_COND)
> Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â return POWER8_MMCRA_IFM3;
> Â Â Â Â Â Â Â Â 
> Â Â Â Â Â Â Â Â return -1;
> 

Hey Michael,

This patch only adds support for the PERF_SAMPLE_BRANCH_COND filter, if the
over all code flow does not clearly suggest that all combinations of any of
these HW filters are invalid, then we can go with one more patch to clean
that up before or after this patch but not here in this patch. Finally the
code section here will look something like this. Does it sound good ?

static u64 power8_bhrb_filter_map(u64 branch_sample_type)
{
        u64 pmu_bhrb_filter = 0;

        /* BHRB and regular PMU events share the same privilege state
         * filter configuration. BHRB is always recorded along with a
         * regular PMU event. As the privilege state filter is handled
         * in the basic PMC configuration of the accompanying regular
         * PMU event, we ignore any separate BHRB specific request.
         */

        /* Ignore user, kernel, hv bits */
        branch_sample_type &= ~PERF_SAMPLE_BRANCH_PLM_ALL;

        if (branch_sample_type == PERF_SAMPLE_BRANCH_ANY)
                return pmu_bhrb_filter;


        if (branch_sample_type == PERF_SAMPLE_BRANCH_ANY_CALL) {
                pmu_bhrb_filter |= POWER8_MMCRA_IFM1;
                return pmu_bhrb_filter;
        }

        if (branch_sample_type == PERF_SAMPLE_BRANCH_COND) {
                pmu_bhrb_filter |= POWER8_MMCRA_IFM3;
                return pmu_bhrb_filter;
        }

        /* Every thing else is unsupported */
        return -1;
}

