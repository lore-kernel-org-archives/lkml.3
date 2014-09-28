Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbaI1UlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 16:41:19 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36086 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbaI1UlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 16:41:18 -0400
Date: Sun, 28 Sep 2014 15:41:15 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Peter Hurley <peter@hurleysoftware.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        iommu@lists.linux-foundation.org
Subject: Re: [PATCH 1/2] x86: don't unnecessarily call
 dma_alloc_from_contiguous()
Message-ID: <20140928154115.6d77541d@as>
In-Reply-To: <1411919524-3666-1-git-send-email-akinobu.mita@gmail.com>
References: <1411919524-3666-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014 00:52:03 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> If CONFIG_DMA_CMA is enabled, dma_generic_alloc_coherent() tries to
> allocate memory region by dma_alloc_from_contiguous() before trying to
> use alloc_pages().
> 
> This wastes CMA region by small DMA-coherent buffers which can be
> allocated by alloc_pages().  And it also causes performance degradation,
> as this is trying to drive _all_ dma mapping allocations through a
> _very_ small window, reported by Peter Hurley.
> 
> This fixes it by trying to allocate by alloc_pages() first in
> dma_generic_alloc_coherent() as dma_alloc_from_contiguous should be
> called only for huge allocation.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Reported-by: Peter Hurley <peter@hurleysoftware.com>
> Cc: Peter Hurley <peter@hurleysoftware.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Don Dutile <ddutile@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: x86@kernel.org
> Cc: iommu@lists.linux-foundation.org
> ---
>  arch/x86/kernel/pci-dma.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index a25e202..0402266 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -99,20 +99,20 @@ void *dma_generic_alloc_coherent(struct device *dev, size_t size,
>  
>  	flag &= ~__GFP_ZERO;
>  again:
> -	page = NULL;
> +	page = alloc_pages_node(dev_to_node(dev), flag | __GFP_NOWARN,
> +				get_order(size));

Shouldn't you be doing this only in the case where order is relatively
small? Like < PAGE_ALLOC_COSTLY_ORDER or so?

>  	/* CMA can be used only in the context which permits sleeping */
> -	if (flag & __GFP_WAIT) {
> +	if (!page && (flag & __GFP_WAIT)) {
>  		page = dma_alloc_from_contiguous(dev, count, get_order(size));
>  		if (page && page_to_phys(page) + size > dma_mask) {
>  			dma_release_from_contiguous(dev, page, count);
>  			page = NULL;
>  		}
>  	}
> -	/* fallback */
> -	if (!page)
> -		page = alloc_pages_node(dev_to_node(dev), flag, get_order(size));
> -	if (!page)
> +	if (!page) {
> +		warn_alloc_failed(flag, get_order(size), NULL);
>  		return NULL;
> +	}
>  
>  	addr = page_to_phys(page);
>  	if (addr + size > dma_mask) {

