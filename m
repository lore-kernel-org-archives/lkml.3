Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab3LLIqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 03:46:40 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:48034 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab3LLIqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 03:46:39 -0500
Message-ID: <52A9779B.1030003@linux.vnet.ibm.com>
Date: Thu, 12 Dec 2013 14:15:15 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
CC: mikey@neuling.org, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        eranian@google.com, linuxppc-dev@ozlabs.org, acme@ghostprotocols.net,
        sukadev@linux.vnet.ibm.com, mingo@kernel.org
Subject: Re: [PATCH V4 08/10] powerpc, perf: Enable SW filtering in branch
 stack sampling framework
References: <20131209062146.EABBE2C00C1@ozlabs.org> <52A6AD61.4050408@linux.vnet.ibm.com>
In-Reply-To: <52A6AD61.4050408@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121208-1618-0000-0000-0000051F65DC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 11:27 AM, Anshuman Khandual wrote:
> On 12/09/2013 11:51 AM, Michael Ellerman wrote:
>> This code was already in need of some unindentation, and now it's just
>> ridiculous.
>>
>> To start with at the beginning of this routine we have:
>>
>> while (..) {
>> 	if (!val)
>> 		break;
>> 	else {
>> 		// Bulk of the logic
>> 		...
>> 	}
>> }
>>
>> That should almost always become:
>>
>> while (..) {
>> 	if (!val)
>> 		break;
>>
>> 	// Bulk of the logic
>> 	...
>> }
>>
>>
>> But in this case that's not enough. Please send a precursor patch which moves
>> this logic out into a helper function.
> 
> Hey Michael,
> 
> I believe this patch should be able to take care of this.
> 
> commit d66d729715cabe0cfd8e34861a6afa8ad639ddf3
> Author: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> Date:   Tue Dec 10 11:10:06 2013 +0530
> 
>     power, perf: Clean up BHRB processing
>     
>     This patch cleans up some indentation problem and re-organizes the
>     BHRB processing code with an additional helper function.
>     
>     Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> 
> diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
> index 29b89e8..9ae96c5 100644
> --- a/arch/powerpc/perf/core-book3s.c
> +++ b/arch/powerpc/perf/core-book3s.c
> @@ -400,11 +400,20 @@ static __u64 power_pmu_bhrb_to(u64 addr)
>  	return target - (unsigned long)&instr + addr;
>  }
> 
> +void update_branch_entry(struct cpu_hw_events *cpuhw, int u_index, u64 from, u64 to, int pred)
> +{
> +	cpuhw->bhrb_entries[u_index].from = from;
> +	cpuhw->bhrb_entries[u_index].to = to;
> +	cpuhw->bhrb_entries[u_index].mispred = pred;
> +	cpuhw->bhrb_entries[u_index].predicted = ~pred;
> +	return;
> +}
> +
>  /* Processing BHRB entries */
>  void power_pmu_bhrb_read(struct cpu_hw_events *cpuhw)
>  {
>  	u64 val;
> -	u64 addr;
> +	u64 addr, tmp;
>  	int r_index, u_index, pred;
> 
>  	r_index = 0;
> @@ -415,62 +424,54 @@ void power_pmu_bhrb_read(struct cpu_hw_events *cpuhw)
>  		if (!val)
>  			/* Terminal marker: End of valid BHRB entries */
>  			break;
> -		else {
> -			addr = val & BHRB_EA;
> -			pred = val & BHRB_PREDICTION;
> 
> -			if (!addr)
> -				/* invalid entry */
> -				continue;
> +		addr = val & BHRB_EA;
> +		pred = val & BHRB_PREDICTION;
> 
> -			/* Branches are read most recent first (ie. mfbhrb 0 is
> -			 * the most recent branch).
> -			 * There are two types of valid entries:
> -			 * 1) a target entry which is the to address of a
> -			 *    computed goto like a blr,bctr,btar.  The next
> -			 *    entry read from the bhrb will be branch
> -			 *    corresponding to this target (ie. the actual
> -			 *    blr/bctr/btar instruction).
> -			 * 2) a from address which is an actual branch.  If a
> -			 *    target entry proceeds this, then this is the
> -			 *    matching branch for that target.  If this is not
> -			 *    following a target entry, then this is a branch
> -			 *    where the target is given as an immediate field
> -			 *    in the instruction (ie. an i or b form branch).
> -			 *    In this case we need to read the instruction from
> -			 *    memory to determine the target/to address.
> +		if (!addr)
> +			/* invalid entry */
> +			continue;
> +
> +		/* Branches are read most recent first (ie. mfbhrb 0 is
> +		 * the most recent branch).
> +		 * There are two types of valid entries:
> +		 * 1) a target entry which is the to address of a
> +		 *    computed goto like a blr,bctr,btar.  The next
> +		 *    entry read from the bhrb will be branch
> +		 *    corresponding to this target (ie. the actual
> +		 *    blr/bctr/btar instruction).
> +		 * 2) a from address which is an actual branch.  If a
> +		 *    target entry proceeds this, then this is the
> +		 *    matching branch for that target.  If this is not
> +		 *    following a target entry, then this is a branch
> +		 *    where the target is given as an immediate field
> +		 *    in the instruction (ie. an i or b form branch).
> +		 *    In this case we need to read the instruction from
> +		 *    memory to determine the target/to address.
> +		 */
> +		if (val & BHRB_TARGET) {
> +			/* Target branches use two entries
> +			 * (ie. computed gotos/XL form)
>  			 */
> +			tmp = addr;
> 
> +			/* Get from address in next entry */
> +			val = read_bhrb(r_index++);
> +			addr = val & BHRB_EA;
>  			if (val & BHRB_TARGET) {
> -				/* Target branches use two entries
> -				 * (ie. computed gotos/XL form)
> -				 */
> -				cpuhw->bhrb_entries[u_index].to = addr;
> -				cpuhw->bhrb_entries[u_index].mispred = pred;
> -				cpuhw->bhrb_entries[u_index].predicted = ~pred;
> -
> -				/* Get from address in next entry */
> -				val = read_bhrb(r_index++);
> -				addr = val & BHRB_EA;
> -				if (val & BHRB_TARGET) {
> -					/* Shouldn't have two targets in a
> -					   row.. Reset index and try again */
> -					r_index--;
> -					addr = 0;
> -				}
> -				cpuhw->bhrb_entries[u_index].from = addr;
> -			} else {
> -				/* Branches to immediate field 
> -				   (ie I or B form) */
> -				cpuhw->bhrb_entries[u_index].from = addr;
> -				cpuhw->bhrb_entries[u_index].to =
> -					power_pmu_bhrb_to(addr);
> -				cpuhw->bhrb_entries[u_index].mispred = pred;
> -				cpuhw->bhrb_entries[u_index].predicted = ~pred;
> +				/* Shouldn't have two targets in a
> +				   row.. Reset index and try again */
> +				r_index--;
> +				addr = 0;
>  			}
> -			u_index++;
> -
> +			update_branch_entry(cpuhw, u_index, addr, tmp, pred);
> +		} else {
> +			/* Branches to immediate field 
> +			   (ie I or B form) */
> +			tmp = power_pmu_bhrb_to(addr);
> +			update_branch_entry(cpuhw, u_index, addr, tmp, pred);
>  		}
> +		u_index++;
>  	}
>  	cpuhw->bhrb_stack.nr = u_index;
>  	return;

Hey Michael,

Does the patch looks okay ? In which case will send it out separately. Do let
me know. Thank you.

Regards
Anshuman

