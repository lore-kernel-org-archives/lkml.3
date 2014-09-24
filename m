Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaIXW0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 18:26:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51185 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaIXW0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 18:26:08 -0400
Date: Wed, 24 Sep 2014 15:26:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 2/3] drivers: dma-coherent: add initialization from
 device tree
Message-Id: <20140924152606.4f4daa63d01c55b69b1ec617@linux-foundation.org>
In-Reply-To: <1410434561-9294-3-git-send-email-m.szyprowski@samsung.com>
References: <1410434561-9294-1-git-send-email-m.szyprowski@samsung.com>
	<1410434561-9294-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014 13:22:40 +0200 Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> Initialization procedure of dma coherent pool has been split into two
> parts, so memory pool can now be initialized without assigning to
> particular struct device. Then initialized region can be assigned to
> more than one struct device. To protect from concurent allocations from
> different devices, a spinlock has been added to dma_coherent_mem
> structure. The last part of this patch adds support for handling
> 'shared-dma-pool' reserved-memory device tree nodes.
> 
> --- a/drivers/base/dma-coherent.c
> +++ b/drivers/base/dma-coherent.c
> @@ -14,11 +14,14 @@ struct dma_coherent_mem {
>  	int		size;
>  	int		flags;
>  	unsigned long	*bitmap;
> +	spinlock_t	spinlock;

A bit of documentation would be nice: explain what the lock protects,
that it is irq-safe, etc.

>  };
>  
> -int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
> -				dma_addr_t device_addr, size_t size, int flags)
> +static int dma_init_coherent_memory(phys_addr_t phys_addr, dma_addr_t device_addr,
> +			     size_t size, int flags,
> +			     struct dma_coherent_mem **mem)
>  {
> +	struct dma_coherent_mem *dma_mem = NULL;

The only reason to initialise this is so we can kfree() it without
checking.  In which case we don't need label free1_out?

--- a/drivers/base/dma-coherent.c~drivers-dma-coherent-add-initialization-from-device-tree-fix
+++ a/drivers/base/dma-coherent.c
@@ -40,7 +40,7 @@ static int dma_init_coherent_memory(phys
 		goto out;
 	dma_mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
 	if (!dma_mem->bitmap)
-		goto free1_out;
+		goto out;
 
 	dma_mem->virt_base = mem_base;
 	dma_mem->device_base = device_addr;
@@ -56,9 +56,8 @@ static int dma_init_coherent_memory(phys
 
 	return DMA_MEMORY_IO;
 
- free1_out:
+out:
 	kfree(dma_mem);
- out:
 	if (mem_base)
 		iounmap(mem_base);
 	return 0;
_

