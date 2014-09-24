Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaIXW2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 18:28:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51202 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbaIXW2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 18:28:30 -0400
Date: Wed, 24 Sep 2014 15:28:28 -0700
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
Message-Id: <20140924152828.9d4a4836ca25cadbb02a2f93@linux-foundation.org>
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
> ...
>
> +static int rmem_dma_device_init(struct reserved_mem *rmem, struct device *dev)
> +{
> +	struct dma_coherent_mem *mem = rmem->priv;
> +	if (!mem &&
> +	    dma_init_coherent_memory(rmem->base, rmem->base, rmem->size,
> +				     DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE,
> +				     &mem) != DMA_MEMORY_MAP) {
> +		pr_info("Reserved memory: failed to init DMA memory pool at %pa, size %ld MiB\n",
> +			&rmem->base, (unsigned long)rmem->size / SZ_1M);

pr_info() seems inappropriate here.  It's an error, so pr_err()?

> +		return -ENODEV;
> +	}
> +	rmem->priv = mem;
> +	dma_assign_coherent_memory(dev, mem);
> +	return 0;
> +}
>
> ...
>
> +static int __init rmem_dma_setup(struct reserved_mem *rmem)
> +{
> +	unsigned long node = rmem->fdt_node;
> +
> +	if (of_get_flat_dt_prop(node, "reusable", NULL))
> +		return -EINVAL;
> +
> +#ifdef CONFIG_ARM
> +	if (!of_get_flat_dt_prop(node, "no-map", NULL)) {
> +		pr_info("Reserved memory: regions without no-map are not yet supported\n");

Same here.

> +		return -EINVAL;
> +	}
> +#endif
> +
> +	rmem->ops = &rmem_dma_ops;
> +	pr_info("Reserved memory: created DMA memory pool at %pa, size %ld MiB\n",
> +		&rmem->base, (unsigned long)rmem->size / SZ_1M);

This *is* an appropriate use of pr_info().

> +	return 0;
> +}
> +RESERVEDMEM_OF_DECLARE(dma, "shared-dma-pool", rmem_dma_setup);
> +#endif

