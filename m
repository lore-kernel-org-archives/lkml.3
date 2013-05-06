Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab3EFNEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 09:04:12 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:47679 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab3EFNEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 09:04:11 -0400
Message-ID: <5187A144.9080307@linux.vnet.ibm.com>
Date: Mon, 06 May 2013 17:55:40 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc, perf: Fix processing conditions for invalid
 BHRB entries
References: <1367831206-16331-1-git-send-email-khandual@linux.vnet.ibm.com> <24261.1367838705@ale.ozlabs.ibm.com>
In-Reply-To: <24261.1367838705@ale.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050612-0260-0000-0000-000002ED7F79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 04:41 PM, Michael Neuling wrote:
> Anshuman Khandual <khandual@linux.vnet.ibm.com> wrote:
> 
>> Fixing some conditions during BHRB entry processing.
> 
> I think we can simplify this a lot more... something like the below.
> 

I feel that the conditional handling of the invalid BHRB entries should be
present which would help us during the debug and also could be used for more
granular branch classification or error handling later on.

> Also, this marks the "to" address as all 1s, which is better poison
> value since it's possible to branch to/from 0x0.
>

Agreed.


> diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
> index c627843..d410d65 100644
> --- a/arch/powerpc/perf/core-book3s.c
> +++ b/arch/powerpc/perf/core-book3s.c
> @@ -1463,65 +1463,45 @@ void power_pmu_bhrb_read(struct cpu_hw_events *cpuhw)
>  {
>  	u64 val;
>  	u64 addr;
> -	int r_index, u_index, target, pred;
> +	int r_index, u_index, pred;
> 
>  	r_index = 0;
>  	u_index = 0;
>  	while (r_index < ppmu->bhrb_nr) {
>  		/* Assembly read function */
> -		val = read_bhrb(r_index);
> +		val = read_bhrb(r_index++);
> 
>  		/* Terminal marker: End of valid BHRB entries */
> -		if (val == 0) {
> +		if (!val) {
>  			break;
>  		} else {
>  			/* BHRB field break up */
>  			addr = val & BHRB_EA;
>  			pred = val & BHRB_PREDICTION;
> -			target = val & BHRB_TARGET;
> 
> -			/* Probable Missed entry: Not applicable for POWER8 */
> -			if ((addr == 0) && (target == 0) && (pred == 1)) {
> -				r_index++;
> +			if (!addr)
> +				/* invalid entry */
>  				continue;
> -			}
> -
> -			/* Real Missed entry: Power8 based missed entry */
> -			if ((addr == 0) && (target == 1) && (pred == 1)) {
> -				r_index++;
> -				continue;
> -			}
> 
> -			/* Reserved condition: Not a valid entry  */
> -			if ((addr == 0) && (target == 1) && (pred == 0)) {
> -				r_index++;
> -				continue;
> -			}
> -
> -			/* Is a target address */
>  			if (val & BHRB_TARGET) {
>  				/* First address cannot be a target address */
> -				if (r_index == 0) {
> -					r_index++;
> +				if (r_index == 0)
>  					continue;
> -				}
> 
>  				/* Update target address for the previous entry */
>  				cpuhw->bhrb_entries[u_index - 1].to = addr;
>  				cpuhw->bhrb_entries[u_index - 1].mispred = pred;
>  				cpuhw->bhrb_entries[u_index - 1].predicted = ~pred;
> -
> -				/* Dont increment u_index */
> -				r_index++;
>  			} else {
>  				/* Update address, flags for current entry */
>  				cpuhw->bhrb_entries[u_index].from = addr;
> +				cpuhw->bhrb_entries[u_index].to =
> +					0xffffffffffffffff;
>  				cpuhw->bhrb_entries[u_index].mispred = pred;
>  				cpuhw->bhrb_entries[u_index].predicted = ~pred;
> 
>  				/* Successfully popullated one entry */
>  				u_index++;
> -				r_index++;
>  			}
>  		}
>  	}
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 

