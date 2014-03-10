Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbaCJPqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:46:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbaCJPqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:46:01 -0400
Date: Mon, 10 Mar 2014 11:45:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: WANG Chao <chaowang@redhat.com>
Cc: Muli Ben-Yehuda <muli@cs.technion.ac.il>,
        "Jon D. Mason" <jdmason@kudzu.us>, "H. Peter Anvin" <hpa@zytor.com>,
        Baoquan He <bhe@redhat.com>, kexec@lists.infradead.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86, calgary: use 8M TCE table size by default
Message-ID: <20140310154531.GC4352@redhat.com>
References: <1394463120-26999-1-git-send-email-chaowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394463120-26999-1-git-send-email-chaowang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 10:52:00PM +0800, WANG Chao wrote:
> New kexec-tools wants to pass kdump kernel needed memmap via E820
> directly, instead of memmap=exactmap. This makes saved_max_pfn not
> be passed down to 2nd kernel. To keep 1st kernel and 2nd kernel using
> the same TCE table size, Muli suggest to hard code the size to max (8M).
> 
> We can't get rid of saved_max_pfn this time, for backward compatibility
> with old first kernel and new second kernel. However new first kernel
> and old second kernel can not work unfortunately.
> 
> v2->v1:
> - retain saved_max_pfn so new 2nd kernel can work with old 1st kernel
>   from Vivek
> 
> Signed-off-by: WANG Chao <chaowang@redhat.com>

This patch looks good to me. This will use saved_max_pfn to determine
table size and retain backward compatibility with old kernel (if user
uses right kexec cmdline option --pass-memmap).

For others (majority of the cases), both first kernel and second kernel
will use 8M of calgary table. 8M does sound a lot in terms of memory but
assumption here is that there might be only some machines with calgary
hardware and only these will pay the penalty of this increased memory 
usage. This sounds better than exporting table size to user space.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek

> ---
>  arch/x86/kernel/pci-calgary_64.c | 31 +++++++++++++++++++------------
>  1 file changed, 19 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
> index 299d493..0497f71 100644
> --- a/arch/x86/kernel/pci-calgary_64.c
> +++ b/arch/x86/kernel/pci-calgary_64.c
> @@ -1207,23 +1207,31 @@ error:
>  	return ret;
>  }
>  
> -static inline int __init determine_tce_table_size(u64 ram)
> +static inline int __init determine_tce_table_size(void)
>  {
>  	int ret;
>  
>  	if (specified_table_size != TCE_TABLE_SIZE_UNSPECIFIED)
>  		return specified_table_size;
>  
> -	/*
> -	 * Table sizes are from 0 to 7 (TCE_TABLE_SIZE_64K to
> -	 * TCE_TABLE_SIZE_8M). Table size 0 has 8K entries and each
> -	 * larger table size has twice as many entries, so shift the
> -	 * max ram address by 13 to divide by 8K and then look at the
> -	 * order of the result to choose between 0-7.
> -	 */
> -	ret = get_order(ram >> 13);
> -	if (ret > TCE_TABLE_SIZE_8M)
> +	if (is_kdump_kernel() && saved_max_pfn) {
> +		/*
> +		 * Table sizes are from 0 to 7 (TCE_TABLE_SIZE_64K to
> +		 * TCE_TABLE_SIZE_8M). Table size 0 has 8K entries and each
> +		 * larger table size has twice as many entries, so shift the
> +		 * max ram address by 13 to divide by 8K and then look at the
> +		 * order of the result to choose between 0-7.
> +		 */
> +		ret = get_order((saved_max_pfn * PAGE_SIZE) >> 13);
> +		if (ret > TCE_TABLE_SIZE_8M)
> +			ret = TCE_TABLE_SIZE_8M;
> +	} else {
> +		/*
> +		 * Use 8M by default (suggested by Muli) if it's not
> +		 * kdump kernel and saved_max_pfn isn't set.
> +		 */
>  		ret = TCE_TABLE_SIZE_8M;
> +	}
>  
>  	return ret;
>  }
> @@ -1418,8 +1426,7 @@ int __init detect_calgary(void)
>  		return -ENOMEM;
>  	}
>  
> -	specified_table_size = determine_tce_table_size((is_kdump_kernel() ?
> -					saved_max_pfn : max_pfn) * PAGE_SIZE);
> +	specified_table_size = determine_tce_table_size();
>  
>  	for (bus = 0; bus < MAX_PHB_BUS_NUM; bus++) {
>  		struct calgary_bus_info *info = &bus_info[bus];
> -- 
> 1.8.5.3
