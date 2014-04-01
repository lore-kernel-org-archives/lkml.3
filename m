Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaDAQLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:11:06 -0400
Received: from smarthost01b.mail.zen.net.uk ([212.23.1.3]:37838 "EHLO
	smarthost01b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752652AbaDAQK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:10:59 -0400
Message-ID: <1396368657.3681.17.camel@linaro1.home>
Subject: Bug(?) in patch "arm64: Implement coherent DMA API based on
 swiotlb" (was Re: [GIT PULL] arm64 patches for 3.15)
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Liviu Dudau <liviu.dudau@arm.com>
Date: Tue, 01 Apr 2014 17:10:57 +0100
In-Reply-To: <20140331175230.GA7480@arm.com>
References: <20140331175230.GA7480@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01b-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-31 at 18:52 +0100, Catalin Marinas wrote:
> The following changes since commit cfbf8d4857c26a8a307fb7cd258074c9dcd8c691:
> 
>   Linux 3.14-rc4 (2014-02-23 17:40:03 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux tags/arm64-upstream
> 
> for you to fetch changes up to 196adf2f3015eacac0567278ba538e3ffdd16d0e:
> 
>   arm64: Remove pgprot_dmacoherent() (2014-03-24 10:35:35 +0000)

I may have spotted a bug in commit 7363590d2c46 (arm64: Implement
coherent DMA API based on swiotlb), see my inline comment below...

[...]
> diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
> index 1ea9f26..97fcef5 100644
> --- a/arch/arm64/mm/cache.S
> +++ b/arch/arm64/mm/cache.S
> @@ -166,3 +166,81 @@ ENTRY(__flush_dcache_area)
>  	dsb	sy
>  	ret
>  ENDPROC(__flush_dcache_area)
> +
> +/*
> + *	__dma_inv_range(start, end)
> + *	- start   - virtual start address of region
> + *	- end     - virtual end address of region
> + */
> +__dma_inv_range:
> +	dcache_line_size x2, x3
> +	sub	x3, x2, #1
> +	bic	x0, x0, x3
> +	bic	x1, x1, x3

Why is the 'end' value in x1 above rounded down to be cache aligned?
This means the cache invalidate won't include the cache line containing
the final bytes of the region, unless it happened to already be cache
line aligned. This looks especially suspect as the other two cache
operations added in the same patch (below) don't do that.

> +1:	dc	ivac, x0			// invalidate D / U line
> +	add	x0, x0, x2
> +	cmp	x0, x1
> +	b.lo	1b
> +	dsb	sy
> +	ret
> +ENDPROC(__dma_inv_range)
> +
> +/*
> + *	__dma_clean_range(start, end)
> + *	- start   - virtual start address of region
> + *	- end     - virtual end address of region
> + */
> +__dma_clean_range:
> +	dcache_line_size x2, x3
> +	sub	x3, x2, #1
> +	bic	x0, x0, x3
> +1:	dc	cvac, x0			// clean D / U line
> +	add	x0, x0, x2
> +	cmp	x0, x1
> +	b.lo	1b
> +	dsb	sy
> +	ret
> +ENDPROC(__dma_clean_range)
> +
> +/*
> + *	__dma_flush_range(start, end)
> + *	- start   - virtual start address of region
> + *	- end     - virtual end address of region
> + */
> +ENTRY(__dma_flush_range)
> +	dcache_line_size x2, x3
> +	sub	x3, x2, #1
> +	bic	x0, x0, x3
> +1:	dc	civac, x0			// clean & invalidate D / U line
> +	add	x0, x0, x2
> +	cmp	x0, x1
> +	b.lo	1b
> +	dsb	sy
> +	ret
> +ENDPROC(__dma_flush_range)

[...]

-- 
Tixy


