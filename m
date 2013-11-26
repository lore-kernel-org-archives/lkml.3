Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab3KZKlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 05:41:39 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:56084 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab3KZKlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 05:41:37 -0500
Message-ID: <52947A8E.1040200@linux.vnet.ibm.com>
Date: Tue, 26 Nov 2013 16:10:14 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "mpe@ellerman.id.au" <michael@ozlabs.org>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, mikey@neuling.org,
        sukadev@linux.vnet.ibm.com, eranian@google.com, michaele@au1.ibm.com
Subject: Re: [V3 02/10] powerpc, perf: Enable conditional branch filter for
 POWER8
References: <20131126060619.48B5D2C00BC@ozlabs.org>
In-Reply-To: <20131126060619.48B5D2C00BC@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112610-5490-0000-0000-0000048DFAE1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 11:36 AM, mpe@ellerman.id.au wrote:
> On Wed, 2013-16-10 at 06:56:49 UTC, Anshuman Khandual wrote:
>> Enables conditional branch filter support for POWER8
>> utilizing MMCRA register based filter and also invalidates
>> a BHRB branch filter combination involving conditional
>> branches.
>>
>> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
>> ---
>>  arch/powerpc/perf/power8-pmu.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.c
>> index 2ee4a70..6e28587 100644
>> --- a/arch/powerpc/perf/power8-pmu.c
>> +++ b/arch/powerpc/perf/power8-pmu.c
>> @@ -580,11 +580,21 @@ static u64 power8_bhrb_filter_map(u64 branch_sample_type)
>>  	if (branch_sample_type & PERF_SAMPLE_BRANCH_IND_CALL)
>>  		return -1;
>>  
>> +	/* Invalid branch filter combination - HW does not support */
>> +	if ((branch_sample_type & PERF_SAMPLE_BRANCH_ANY_CALL) &&
>> +			(branch_sample_type & PERF_SAMPLE_BRANCH_COND))
>> +		return -1;
> 
> What this doesn't make obvious is that the hardware doesn't support any
> combinations. It just happens that these are the only two possibilities we
> allow, and so this is the only combination we have to disallow.
> 
>>
>>  	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY_CALL) {
>>  		pmu_bhrb_filter |= POWER8_MMCRA_IFM1;
>>  		return pmu_bhrb_filter;
>>  	}
>>  
>> +	if (branch_sample_type & PERF_SAMPLE_BRANCH_COND) {
>> +		pmu_bhrb_filter |= POWER8_MMCRA_IFM3;
>> +		return pmu_bhrb_filter;
>> +	}
>> +
>>  	/* Every thing else is unsupported */
>>  	return -1;
>>  }
> 
> I think it would be clearer if we actually checked for the possibilities we
> allow and let everything else fall through, eg:
> 
> 	/* Ignore user/kernel/hv bits */
> 	branch_sample_type &= ~PERF_SAMPLE_BRANCH_PLM_ALL;
> 
> 	if (branch_sample_type == PERF_SAMPLE_BRANCH_ANY)
> 		return 0;
> 
> 	if (branch_sample_type == PERF_SAMPLE_BRANCH_ANY_CALL)
> 		return POWER8_MMCRA_IFM1;
> 
> 	if (branch_sample_type == PERF_SAMPLE_BRANCH_COND)
> 		return POWER8_MMCRA_IFM3;
> 	
> 	return -1;
> 

Please look at the 9th patch (power8, perf: Change BHRB branch filter configuration).
All these issues are taken care of in this patch. It clearly indicates that any combination
of HW BHRB filters will not be supported in the PMU and hence zero out the HW filter component
and processes all of those filters in the SW.

