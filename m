Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933787AbaCTPyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:54:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091AbaCTPyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:54:43 -0400
Date: Thu, 20 Mar 2014 11:54:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Muli Ben-Yehuda <muli@cs.technion.ac.il>,
        "Jon D. Mason" <jdmason@kudzu.us>, "H. Peter Anvin" <hpa@zytor.com>,
        Baoquan He <bhe@redhat.com>, kexec@lists.infradead.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, WANG Chao <chaowang@redhat.com>
Subject: Re: [PATCH v2] x86, calgary: use 8M TCE table size by default
Message-ID: <20140320155411.GC29549@redhat.com>
References: <1394463120-26999-1-git-send-email-chaowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394463120-26999-1-git-send-email-chaowang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi hpa,

I am wondering how to make progress on calgary issue now. We do want to
cleanup kexec-tools code and move to passing memory ranges in bootparams.

I see two choices here.

- Take this patch in so that new kernel code will work with modified
  kexec-tools without any user intervention. (Both first and second kernel
  need to be new). 

- Don't take this patch in and calgary will be broken with new
  kexec-tools. And that will always require manual user intervention
  from user to force passing memmap on command line.

I kind of prefer the first option so that even if there are some calgary
machines out there, they will work automatically with new kernel and
will require manual intervention only for old kernels and new kexec-tool
cobination.

But I can live with second option too if that's everybody agrees to and
hopefully we don't get lots of reports of breaking kdump with kexec-tools
upgrade.

Thanks
Vivek

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
