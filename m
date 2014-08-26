Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbaHZTyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 15:54:21 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:46549 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbaHZTyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 15:54:20 -0400
Message-ID: <1409082240.28990.104.camel@misato.fc.hp.com>
Subject: Re: [PATCH 1/3] x86: Make page cache mode a real type
From: Toshi Kani <toshi.kani@hp.com>
To: Juergen Gross <jgross@suse.com>
Cc: stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, hpa@zytor.com, x86@kernel.org
Date: Tue, 26 Aug 2014 13:44:00 -0600
In-Reply-To: <1409033783-12136-2-git-send-email-jgross@suse.com>
References: <1409033783-12136-1-git-send-email-jgross@suse.com>
	 <1409033783-12136-2-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-26 at 08:16 +0200, Juergen Gross wrote:
> At the moment there are a lot of places that handle setting or getting
> the page cache mode by treating the pgprot bits equal to the cache mode.
> This is only true because there are a lot of assumptions about the setup
> of the PAT MSR. Otherwise the cache type needs to get translated into
> pgprot bits and vice versa.
> 
> This patch tries to prepare for that by introducing a seperate type
> for the cache mode and adding functions to translate between those and pgprot
> values.
> 
> To avoid too much performance penalty the translation between cache mode
> and pgprot values is done via tables which contain the relevant information.
> Write-back cache mode is hard-wired to be 0, all other modes are configurable
> via those tables. For large pages there are translation functions as the
> PAT bit is located at different positions in the ptes of 4k and large pages.
> 
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>

Hi Juergen,

Thanks for the updates!  A few comments below...

> @@ -73,6 +73,9 @@ void *kmap_atomic_prot_pfn(unsigned long pfn, pgprot_t prot)
>  /*
>   * Map 'pfn' using protections 'prot'
>   */
> +#define __PAGE_KERNEL_WC	(__PAGE_KERNEL | \
> +				 cachemode2protval(_PAGE_CACHE_MODE_WC))
> +
>  void __iomem *
>  iomap_atomic_prot_pfn(unsigned long pfn, pgprot_t prot)
>  {
> @@ -82,12 +85,14 @@ iomap_atomic_prot_pfn(unsigned long pfn, pgprot_t prot)
>  	 * MTRR is UC or WC.  UC_MINUS gets the real intention, of the
>  	 * user, which is "WC if the MTRR is WC, UC if you can't do that."
>  	 */
> -	if (!pat_enabled && pgprot_val(prot) == pgprot_val(PAGE_KERNEL_WC))
> -		prot = PAGE_KERNEL_UC_MINUS;
> +	if (!pat_enabled && pgprot_val(prot) == __PAGE_KERNEL_WC)
> +		prot = __pgprot(__PAGE_KERNEL |
> +				protval_pagemode(_PAGE_CACHE_MODE_UC_MINUS));

protval_pagemode() should be cachemode2protval().
 
>  /*
> diff --git a/drivers/video/fbdev/vermilion/vermilion.c b/drivers/video/fbdev/vermilion/vermilion.c
> index 048a666..6bbc559 100644
> --- a/drivers/video/fbdev/vermilion/vermilion.c
> +++ b/drivers/video/fbdev/vermilion/vermilion.c
> @@ -1004,13 +1004,15 @@ static int vmlfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
>  	struct vml_info *vinfo = container_of(info, struct vml_info, info);
>  	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
>  	int ret;
> +	unsigned long prot;
>  
>  	ret = vmlfb_vram_offset(vinfo, offset);
>  	if (ret)
>  		return -EINVAL;
>  
> -	pgprot_val(vma->vm_page_prot) |= _PAGE_PCD;
> -	pgprot_val(vma->vm_page_prot) &= ~_PAGE_PWT;
> +	prot = pgprot_val(vma->vm_page_prot) & ~_PAGE_CACHE_MASK;
> +	pgprot_val(vma->vm_page_prot) =
> +		prot | cachemode2protval(_PAGE_CACHE_MODE_UC);

This cache mode should be _PAGE_CACHE_MODE_UC_MINUS as the original code
only sets the PCD bit.

Thanks,
-Toshi

