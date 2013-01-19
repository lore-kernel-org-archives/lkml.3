Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab3ASUG1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 15:06:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64220 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab3ASUGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 15:06:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Soeren Moch <smoch@web.de>
Subject: Re: [PATCH v2] mm: dmapool: use provided gfp flags for all dma_alloc_coherent() calls
Date: Sat, 19 Jan 2013 20:05:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Jason Cooper <jason@lakedaemon.net>, Greg KH <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
References: <20121119144826.f59667b2.akpm@linux-foundation.org> <201301172026.45514.arnd@arndb.de> <50FABBED.1020905@web.de>
In-Reply-To: <50FABBED.1020905@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301192005.20093.arnd@arndb.de>
X-Provags-ID: V02:K0:hpLIMFHhe9r79Fne8XRQlnUUXylLigmVGhwB9vqj3MU
 T+g/v0qhk2OcyO5QjZCQ0q69z7PEHJrV0oEj2zDlfzGbeFCCWu
 ZOTzcH4dzSDcv5f+qqc/C18qISWZzmvL5nyQrNgs+4V/Hkwp2e
 dx8/hq0ZZBD/zkaZUvmau6SE/cbdBpMKHG7CAhlxsODsu7SEZN
 wcPeOScN8jx4JetBAd12X+D5wWCa7pdL+aG3iAskb836hzN/bw
 8Qz2YCxJOfb/OsZHcT4eMYWcxvpge6TDCdYIPwdK2FIrEeAo2I
 Gfq0+qkQVmGvoYzQsMswDezigNLR1FAzcCpwDHyMe6aYRYTvdi
 0A/arZZ32mvPnkV9ZjBA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 January 2013, Soeren Moch wrote:
> What I can see in the log: a lot of coherent mappings from sata_mv and 
> orion_ehci, a few from mv643xx_eth, no other coherent mappings.
> All coherent mappings are page aligned, some of them (from orion_ehci)
> are not really small (as claimed in __alloc_from_pool).

Right. Unfortunately, the output does not show which of the mappings
are atomic, so we still need to look through those that can be atomic
to understand what's going on. There are a few megabytes of coherent
mappings in total according to the output, but it seems that a significant
portion of them is atomic, which is a bit unexpected.

> I don't believe in a memory leak. When I restart vdr (the application
> utilizing the dvb sticks) then there is enough dma memory available
> again.

I found at least one source line that incorrectly uses an atomic
allocation, in ehci_mem_init():

                dma_alloc_coherent (ehci_to_hcd(ehci)->self.controller,
                        ehci->periodic_size * sizeof(__le32),
                        &ehci->periodic_dma, 0);

The last argument is the GFP_ flag, which should never be zero, as
that is implicit !wait. This function is called only once, so it
is not the actual culprit, but there could be other instances
where we accidentally allocate something as GFP_ATOMIC.

The total number of allocations I found for each type are

sata_mv: 66 pages (270336 bytes)
mv643xx_eth: 4 pages == (16384 bytes)
orion_ehci: 154 pages (630784 bytes)
orion_ehci (atomic): 256 pages (1048576 bytes)

from the distribution of the numbers, it seems that there is exactly 1 MB
of data allocated between bus addresses 0x1f90000 and 0x1f9ffff, allocated
in individual pages. This matches the size of your pool, so it's definitely
something coming from USB, and no single other allocation, but it does not
directly point to a specific line of code.

One thing I found was that the ARM dma-mapping code seems buggy in the way
that it does a bitwise and between the gfp mask and GFP_ATOMIC, which does
not work because GFP_ATOMIC is defined by the absence of __GFP_WAIT.

I believe we need the patch below, but it is not clear to me if that issue
is related to your problem or now.

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 6b2fb87..c57975f 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -640,7 +641,7 @@ static void *__dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
 
 	if (is_coherent || nommu())
 		addr = __alloc_simple_buffer(dev, size, gfp, &page);
-	else if (gfp & GFP_ATOMIC)
+	else if (!(gfp & __GFP_WAIT))
 		addr = __alloc_from_pool(size, &page);
 	else if (!IS_ENABLED(CONFIG_CMA))
 		addr = __alloc_remap_buffer(dev, size, gfp, prot, &page, caller);
@@ -1272,7 +1273,7 @@ static void *arm_iommu_alloc_attrs(struct device *dev, size_t size,
 	*handle = DMA_ERROR_CODE;
 	size = PAGE_ALIGN(size);
 
-	if (gfp & GFP_ATOMIC)
+	if (!(gfp & __GFP_WAIT))
 		return __iommu_alloc_atomic(dev, size, handle);
 
 	pages = __iommu_alloc_buffer(dev, size, gfp, attrs);
8<-------

There is one more code path I could find, which is usb_submit_urb() =>
usb_hcd_submit_urb => ehci_urb_enqueue() => submit_async() =>
qh_append_tds() => qh_make(GFP_ATOMIC) => ehci_qh_alloc() =>
dma_pool_alloc() => pool_alloc_page() => dma_alloc_coherent()

So even for a GFP_KERNEL passed into usb_submit_urb, the ehci driver
causes the low-level allocation to be GFP_ATOMIC, because 
qh_append_tds() is called under a spinlock. If we have hundreds
of URBs in flight, that will exhaust the pool rather quickly.

	Arnd
