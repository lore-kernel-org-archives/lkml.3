Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242Ab3LXDwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 22:52:16 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:50883 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab3LXDwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 22:52:15 -0500
Message-ID: <52B9049D.4020403@linux.vnet.ibm.com>
Date: Tue, 24 Dec 2013 09:20:53 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, mikey@neuling.org,
        ak@linux.intel.com, eranian@google.com, acme@ghostprotocols.net,
        sukadev@linux.vnet.ibm.com, mingo@kernel.org
Subject: Re: [PATCH V4 08/10] powerpc, perf: Enable SW filtering in branch
 stack sampling framework
References: <20131209062146.EABBE2C00C1@ozlabs.org> <52B42394.4060705@linux.vnet.ibm.com> <1387855790.15093.1.camel@concordia>
In-Reply-To: <1387855790.15093.1.camel@concordia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122403-5564-0000-0000-00000B3F662F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2013 08:59 AM, Michael Ellerman wrote:
> On Fri, 2013-12-20 at 16:31 +0530, Anshuman Khandual wrote:
>> On 12/09/2013 11:51 AM, Michael Ellerman wrote:
>>> On Wed, 2013-04-12 at 10:32:40 UTC, Anshuman Khandual wrote:
>>>> +
>>>> +	if (bhrb_sw_filter & PERF_SAMPLE_BRANCH_IND_CALL) {
>>>> +		/* XL-form instruction */
>>>> +		if (instr_is_branch_xlform(*addr)) {
>>>> +
>>>> +			/* LR should be set */
>>>> +			if (is_branch_link_set(*addr)) {
>>>> +				/*
>>>> +			 	 * Conditional and unconditional
>>>> +			 	 * branch to CTR.
>>>> +			 	 */
>>>> +				if (is_xlform_ctr(*addr))
>>>> +					result = true;
>>>> +
>>>> +				/*
>>>> +			 	 * Conditional and unconditional
>>>> +			 	 * branch to LR.
>>>> +			 	 */
>>>> +				if (is_xlform_lr(*addr))
>>>> +					result = true;
>>>> +
>>>> +				/*
>>>> +			 	 * Conditional and unconditional
>>>> +			 	 * branch to TAR.
>>>> +			 	 */
>>>> +				if (is_xlform_tar(*addr))
>>>> +					result = true;
>>>
>>> What other kind of XL-Form branch is there?
>>
>> I am not sure. Do you know of any ?
> 
> That was my point. There are no other types, so you can just do:
> 
> 	if (bhrb_sw_filter & PERF_SAMPLE_BRANCH_IND_CALL)
> 		if (instr_is_branch_xlform(*addr) && is_branch_link_set(*addr))
> 			return true;
> 

Done

>>>> +	if (bhrb_sw_filter & PERF_SAMPLE_BRANCH_COND) {
>>>> +
>>>> +		/* I-form instruction - excluded */
>>>> +		if (instr_is_branch_iform(*addr))
>>>> +			goto out;
>>>> +
>>>> +		/* B-form or XL-form instruction */
>>>> +		if (instr_is_branch_bform(*addr) || instr_is_branch_xlform(*addr))  {
>>>> +
>>>> +			/* Not branch always  */
>>>> +			if (!is_bo_always(*addr)) {
>>>> +
>>>> +				/* Conditional branch to CTR register */
>>>> +				if (is_bo_ctr(*addr))
>>>> +					goto out;
>>>
>>> We might have discussed this but why not?
>>
>> Did not get that, discuss what ?
> 
> Why are we saying a conditional branch to the CTR is not a conditional branch?
> 
> It is conditional, so I think it should be included.
> 

I believe conditional branch to CTR register and the below conditional branch
with static hint are excluded when processed with BHRB PMU based filter IFM3,
Here the SW implemented filter try to match those exclusions, so that a user
should not see any difference in results whether the filter is processed
either in PMU or in SW.

>>>> +
>>>> +				/* CR[BI] conditional branch with static hint */
>>>
>>> A conditional branch with a static hint is still a conditional branch?
>>
>> No its not. 
> 
> Yes it is?
> 
> In fact they could be very interesting branches. Because the compiler or
> programmer has statically hinted them, if the hint is wrong they may be a major
> source of branch midpredicts.
> 
> 
>>>> +				if (is_bo_crbi_off(*addr) || is_bo_crbi_on(*addr)) {
>>>> +					if (is_bo_crbi_hint(*addr))
>>>> +						goto out;
>>>> +				}
>>>> +
>>>> +				result = true;
>>>> +			}
>>>> +		}
>>>> +	}
>>>> +out:
>>>> +	return result;
>>>> +}
> 
>>>> +	} else {
>>>> +		/*
>>>> +		 * Userspace address needs to be
>>>> +		 * copied first before analysis.
>>>> +		 */
>>>> +		pagefault_disable();
>>>> +		ret =  __get_user_inatomic(instr, (unsigned int __user *)addr);
>>>
>>> I suspect you borrowed this incantation from the callchain code. Unlike that
>>> code you don't fallback to reading the page tables directly.
>>>
>>> I'd rather see the accessor in the callchain code made generic and have you
>>> call it here.
>>
>> You have mentioned to take care of this issue yourself.
> 
> Yes I will.

Thanks !!

