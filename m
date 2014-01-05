Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559AbaAER5J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 12:57:09 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:27719 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaAER5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 12:57:07 -0500
X-IronPort-AV: E=Sophos;i="4.95,608,1384300800"; 
   d="scan'208";a="87713268"
Date: Sun, 5 Jan 2014 17:56:16 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <david.vrabel@citrix.com>, <hpa@zytor.com>
Subject: Re: [PATCH v13 06/19] xen/mmu: Cleanup xen_pagetable_p2m_copy a
 bit.
In-Reply-To: <1388777916-1328-7-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1401051756090.8667@kaball.uk.xensource.com>
References: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com> <1388777916-1328-7-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jan 2014, Konrad Rzeszutek Wilk wrote:
> Stefano noticed that the code runs only under 64-bit so
> the comments about 32-bit are pointless.
> 
> Also we change the condition for xen_revector_p2m_tree
> returning the same value (because it could not allocate
> a swath of space to put the new P2M in) or it had been
> called once already. In such we return early from the
> function.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  arch/x86/xen/mmu.c | 40 ++++++++++++++++++++--------------------
>  1 file changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index c140eff..9d74249 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1209,29 +1209,29 @@ static void __init xen_pagetable_p2m_copy(void)
>  
>  	size = PAGE_ALIGN(xen_start_info->nr_pages * sizeof(unsigned long));
>  
> -	/* On 32-bit, we get zero so this never gets executed. */
>  	new_mfn_list = xen_revector_p2m_tree();
> -	if (new_mfn_list && new_mfn_list != xen_start_info->mfn_list) {
> -		/* using __ka address and sticking INVALID_P2M_ENTRY! */
> -		memset((void *)xen_start_info->mfn_list, 0xff, size);
> -
> -		/* We should be in __ka space. */
> -		BUG_ON(xen_start_info->mfn_list < __START_KERNEL_map);
> -		addr = xen_start_info->mfn_list;
> -		/* We roundup to the PMD, which means that if anybody at this stage is
> -		 * using the __ka address of xen_start_info or xen_start_info->shared_info
> -		 * they are in going to crash. Fortunatly we have already revectored
> -		 * in xen_setup_kernel_pagetable and in xen_setup_shared_info. */
> -		size = roundup(size, PMD_SIZE);
> -		xen_cleanhighmap(addr, addr + size);
> -
> -		size = PAGE_ALIGN(xen_start_info->nr_pages * sizeof(unsigned long));
> -		memblock_free(__pa(xen_start_info->mfn_list), size);
> -		/* And revector! Bye bye old array */
> -		xen_start_info->mfn_list = new_mfn_list;
> -	} else
> +	/* No memory or already called. */
> +	if (!new_mfn_list || new_mfn_list == xen_start_info->mfn_list)
>  		return;
>  
> +	/* using __ka address and sticking INVALID_P2M_ENTRY! */
> +	memset((void *)xen_start_info->mfn_list, 0xff, size);
> +
> +	/* We should be in __ka space. */
> +	BUG_ON(xen_start_info->mfn_list < __START_KERNEL_map);
> +	addr = xen_start_info->mfn_list;
> +	/* We roundup to the PMD, which means that if anybody at this stage is
> +	 * using the __ka address of xen_start_info or xen_start_info->shared_info
> +	 * they are in going to crash. Fortunatly we have already revectored
> +	 * in xen_setup_kernel_pagetable and in xen_setup_shared_info. */
> +	size = roundup(size, PMD_SIZE);
> +	xen_cleanhighmap(addr, addr + size);
> +
> +	size = PAGE_ALIGN(xen_start_info->nr_pages * sizeof(unsigned long));
> +	memblock_free(__pa(xen_start_info->mfn_list), size);
> +	/* And revector! Bye bye old array */
> +	xen_start_info->mfn_list = new_mfn_list;
> +
>  	/* At this stage, cleanup_highmap has already cleaned __ka space
>  	 * from _brk_limit way up to the max_pfn_mapped (which is the end of
>  	 * the ramdisk). We continue on, erasing PMD entries that point to page
> -- 
> 1.8.3.1
> 
