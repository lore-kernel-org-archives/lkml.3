Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab3APXO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 18:14:27 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48107 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab3APXO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 18:14:26 -0500
Date: Wed, 16 Jan 2013 23:14:01 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Subhash Jadavani <subhashj@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org,
        asias@redhat.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] block: blk-merge: don't merge the pages with
	non-contiguous descriptors
Message-ID: <20130116231401.GV23505@n2100.arm.linux.org.uk>
References: <1358265681-25671-1-git-send-email-subhashj@codeaurora.org> <1358266794.10591.8.camel@dabdike.int.hansenpartnership.com> <50F64AC1.3040304@codeaurora.org> <1358332355.2384.11.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358332355.2384.11.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 10:32:35AM +0000, James Bottomley wrote:
> On Wed, 2013-01-16 at 12:07 +0530, Subhash Jadavani wrote:
> 
> > Now consider this call stack from MMC block driver (this is on the ARmv7 
> > based board):
> >      [   98.918174] [<c001b50c>] (v7_dma_inv_range+0x30/0x48) from 
> > [<c0017b8c>] (dma_cache_maint_page+0x1c4/0x24c)
> >      [   98.927819] [<c0017b8c>] (dma_cache_maint_page+0x1c4/0x24c) from 
> > [<c0017c28>] (___dma_page_cpu_to_dev+0x14/0x1c)
> >      [   98.937982] [<c0017c28>] (___dma_page_cpu_to_dev+0x14/0x1c) from 
> > [<c0017ff8>] (dma_map_sg+0x3c/0x114)
> 
> OK, so this is showing that ARM itself is making the assumption that the
> pages are contiguous in the page offset map.
> 
> Fix this by doing the increment via the pfn, which will do the right
> thing whatever the memory model.
> 
> Signed-off-by: James Bottomley <JBottomley@Parallels.com>

Ok.  What would you like the patch summary line for this to be -
the existing one seems to be a little wrong given the content of
this patch...

> 
> ---
> 
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index 6b2fb87..ab88c5b 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -809,7 +809,7 @@ static void dma_cache_maint_page(struct page *page, unsigned long offset,
>  			op(vaddr, len, dir);
>  		}
>  		offset = 0;
> -		page++;
> +		page = pfn_to_page(page_to_pfn(page) + 1);
>  		left -= len;
>  	} while (left);
>  }
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
