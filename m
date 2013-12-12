Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab3LLNmC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 08:42:02 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:43047 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab3LLNl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:41:59 -0500
Message-ID: <52A9BD23.9010902@linaro.org>
Date: Thu, 12 Dec 2013 21:41:55 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: H Peter Anvin <hpa@zytor.com>, Linux-X86 <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] x86: mm: Account for the of CPUs that must be flushed
 during a TLB range flush
References: <1386849309-22584-1-git-send-email-mgorman@suse.de> <1386849309-22584-4-git-send-email-mgorman@suse.de>
In-Reply-To: <1386849309-22584-4-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 07:55 PM, Mel Gorman wrote:
> X86 TLB range flushing uses a balance point to decide if a single global TLB
> flush or multiple single page flushes would perform best.  This patch takes into
> account how many CPUs must be flushed.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  arch/x86/mm/tlb.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
> index 09b8cb8..0cababa 100644
> --- a/arch/x86/mm/tlb.c
> +++ b/arch/x86/mm/tlb.c
> @@ -217,6 +217,9 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
>  	act_entries = mm->total_vm > act_entries ? act_entries : mm->total_vm;
>  	nr_base_pages = (end - start) >> PAGE_SHIFT;
>  
> +	/* Take the number of CPUs to range flush into account */
> +	nr_base_pages *= cpumask_weight(mm_cpumask(mm));
> +

flush range calculation base on per cpu, since no matter how many cpus
in the process, tlb flush and refill time won't change.
>  	/* tlb_flushall_shift is on balance point, details in commit log */
>  	if (nr_base_pages > act_entries || has_large_page(mm, start, end)) {
>  		count_vm_event(NR_TLB_LOCAL_FLUSH_ALL);
> 


-- 
Thanks
    Alex
