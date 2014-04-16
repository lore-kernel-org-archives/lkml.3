Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbaDPToK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 15:44:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbaDPToI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 15:44:08 -0400
Date: Wed, 16 Apr 2014 12:44:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH v3 1/5] x86: make dma_alloc_coherent() return zeroed
 memory if CMA is enabled
Message-Id: <20140416124406.b6a3f8c9f6e7eb7328ebb5cb@linux-foundation.org>
In-Reply-To: <1397567329-3771-2-git-send-email-akinobu.mita@gmail.com>
References: <1397567329-3771-1-git-send-email-akinobu.mita@gmail.com>
	<1397567329-3771-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014 22:08:45 +0900 Akinobu Mita <akinobu.mita@gmail.com> wrote:

> Calling dma_alloc_coherent() with __GFP_ZERO must return zeroed memory.
> 
> But when the contiguous memory allocator (CMA) is enabled on x86 and
> the memory region is allocated by dma_alloc_from_contiguous(), it
> doesn't return zeroed memory.  Because dma_generic_alloc_coherent()
> forgot to fill the memory region with zero if it was allocated by
> dma_alloc_from_contiguous()
> 
> Most implementations of dma_alloc_coherent() return zeroed memory
> regardless of whether __GFP_ZERO is specified.  So this fixes it by
> unconditionally zeroing the allocated memory region.
> 
> Alternatively, we could fix dma_alloc_from_contiguous() to return
> zeroed out memory and remove memset() from all caller of it.  But we
> can't simply remove the memset on arm because __dma_clear_buffer() is
> used there for ensuring cache flushing and it is used in many places.
> Of course we can do redundant memset in dma_alloc_from_contiguous(),
> but I think this patch is less impact for fixing this problem.

But this patch does a duplicated memset if the page was allocated by
alloc_pages_node()?

Would it not be better to pass the gfp_t to dma_alloc_from_contiguous()
and have it implement __GFP_ZERO?  That will fix thsi inefficiency,
will be symmetrical with the other underlying allocators and should
permit the appropriate fixups in arm?


> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -97,7 +97,6 @@ void *dma_generic_alloc_coherent(struct device *dev, size_t size,
>  
>  	dma_mask = dma_alloc_coherent_mask(dev, flag);
>  
> -	flag |= __GFP_ZERO;
>  again:
>  	page = NULL;
>  	/* CMA can be used only in the context which permits sleeping */
> @@ -120,7 +119,7 @@ again:
>  
>  		return NULL;
>  	}
> -
> +	memset(page_address(page), 0, size);
>  	*dma_addr = addr;
>  	return page_address(page);
>  }
> -- 
> 1.8.3.2
