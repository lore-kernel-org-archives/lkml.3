Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaGVSHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 14:07:32 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:54275 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaGVSHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 14:07:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv4 5/5] arm64: Add atomic pool for non-coherent and CMA allocations.
Date: Tue, 22 Jul 2014 20:06:44 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Laura Abbott <lauraa@codeaurora.org>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Riley <davidriley@chromium.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Ritesh Harjain <ritesh.harjani@gmail.com>
References: <1404324218-4743-1-git-send-email-lauraa@codeaurora.org> <1404324218-4743-6-git-send-email-lauraa@codeaurora.org>
In-Reply-To: <1404324218-4743-6-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201407222006.44666.arnd@arndb.de>
X-Provags-ID: V02:K0:PpvizUT4KXFLpUZ9PhxNslFxv6zMwLYidhe4FZEgwKL
 0x9Pq3WvVUSwKDMj6bKZODTESqWAPbRqwrKpbORKC/JA1WNdGW
 xGVrwxKyooj2FxmafuNdrMh3EOnOnGzEgQm3Cnk3VJj7dLE6uz
 7L72NHNar2ZI+r35+l2eGnggtKEF9RGnqWJnt3UEJpOIHun0tY
 I0bNLklB9ABFqPrFkNilQ/CNnEPL1aE5rFmV1XtZgZTzYVXbrx
 tabv6rgBZPcBuQK4tBQsXNpuYGdYIsVSjmT/E0LlS/of1etKzC
 Cj8u+LSQR4HmeX8fBwFfhOPWnBO/p900V8rm9rF2MbTZUFzxXi
 o96gkLIn4cgsX7CLu5I4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 July 2014, Laura Abbott wrote:
> +       pgprot_t prot = __pgprot(PROT_NORMAL_NC);
> +       unsigned long nr_pages = atomic_pool_size >> PAGE_SHIFT;
> +       struct page *page;
> +       void *addr;
> +
> +
> +       if (dev_get_cma_area(NULL))
> +               page = dma_alloc_from_contiguous(NULL, nr_pages,
> +                                       get_order(atomic_pool_size));
> +       else
> +               page = alloc_pages(GFP_KERNEL, get_order(atomic_pool_size));
> +
> +
> +       if (page) {
> +               int ret;
> +
> +               atomic_pool = gen_pool_create(PAGE_SHIFT, -1);
> +               if (!atomic_pool)
> +                       goto free_page;
> +
> +               addr = dma_common_contiguous_remap(page, atomic_pool_size,
> +                                       VM_USERMAP, prot, atomic_pool_init);
> +

I just stumbled over this thread and noticed the code here: When you do
alloc_pages() above, you actually get pages that are already mapped into
the linear kernel mapping as cacheable pages. Your new
dma_common_contiguous_remap tries to map them as noncacheable. This
seems broken because it allows the CPU to treat both mappings as
cacheable, and that won't be coherent with device DMA.

> +               if (!addr)
> +                       goto destroy_genpool;
> +
> +               memset(addr, 0, atomic_pool_size);
> +               __dma_flush_range(addr, addr + atomic_pool_size);

It also seems weird to flush the cache on a virtual address of
an uncacheable mapping. Is that well-defined? In the CMA case, the
original mapping should already be uncached here, so you don't need
to flush it. In the alloc_pages() case, I think you need to unmap
the pages from the linear mapping instead.

	Arnd
