Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab3HTISy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:18:54 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:35909 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab3HTISw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:18:52 -0400
Date: Tue, 20 Aug 2013 10:18:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, mm: Add comments for step_size shift
Message-ID: <20130820081848.GB11072@gmail.com>
References: <1376546616-17489-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376546616-17489-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> As request by hpa, add comments for why we choose 5 for
> step size shift.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
> Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
> 
> ---
>  arch/x86/mm/init.c |   21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/arch/x86/mm/init.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/init.c
> +++ linux-2.6/arch/x86/mm/init.c
> @@ -395,8 +395,23 @@ static unsigned long __init init_range_m
>  	return mapped_ram_size;
>  }
>  
> -/* (PUD_SHIFT-PMD_SHIFT)/2 */
> -#define STEP_SIZE_SHIFT 5
> +static unsigned long __init get_new_step_size(unsigned long step_size)
> +{
> +	/*
> +	 * initial mapped size is PMD_SIZE, aka 2M.
> +	 * We can not set step_size to be PUD_SIZE aka 1G yet.
> +	 * In worse case, when 1G is cross the 1G boundary, and
> +	 * PG_LEVEL_2M is not set, we will need 1+1+512 pages (aka 2M + 8k)
> +	 * to map 1G range with PTE. Use 5 as shift for now.
> +	 */

This is much more readable:

+       /*
+        * initial mapped size is PMD_SIZE (2M).
+        * We can not set step_size to be PUD_SIZE (1G) yet.
+        * In the worst case, when we cross the 1G boundary, and
+        * PG_LEVEL_2M is not set, we will need 1+1+512 pages (2M+8k)
+        * to map 1G range with PTE. Use 5 as shift for now.
+        */


> +	unsigned long new_step_size = step_size << 5;
> +
> +	if (new_step_size > step_size)
> +		step_size = new_step_size;
> +
> +	return  step_size;
> +}
> +
>  void __init init_mem_mapping(void)
>  {
>  	unsigned long end, real_end, start, last_start;
> @@ -445,7 +460,7 @@ void __init init_mem_mapping(void)
>  		min_pfn_mapped = last_start >> PAGE_SHIFT;
>  		/* only increase step_size after big range get mapped */
>  		if (new_mapped_ram_size > mapped_ram_size)
> -			step_size <<= STEP_SIZE_SHIFT;
> +			step_size = get_new_step_size(step_size);
>  		mapped_ram_size += new_mapped_ram_size;
>  	}

As-is the changelog claims it only adds comments - but it 
obviously does more than that ...

Yinghai, for the 1001st time, please use the customary 
changelog style we use in the kernel:

  " Current code does (A), this has a problem when (B).
    We can improve this doing (C), because (D)."

I'm also going to suggest something radical: how about you 
keep this sugestion of mine in mind for _all_ future 
patches so I don't have to repeat it for every 3rd patch 
like I had to for the past 4 years, non-stop? Okay?

Thanks,

	Ingo
