Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091AbaJ3Bs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 21:48:59 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:31190 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924AbaJ3Bs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 21:48:58 -0400
Subject: [PATCH] MIPS: DMA: fix coherent alloc in non-coherent systems
To: <linux-mips@linux-mips.org>, <nbd@openwrt.org>, <yanh@lemote.com>,
        <linux-kernel@vger.kernel.org>, <ralf@linux-mips.org>,
        <alex.smith@imgtec.com>, <taohl@lemote.com>, <chenhc@lemote.com>,
        <blogic@openwrt.org>
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
Date: Wed, 29 Oct 2014 18:48:52 -0700
Message-ID: <20141030014753.13189.48344.stgit@linux-yegoshin>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.65.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A default dma_alloc_coherent() fails to alloc a coherent memory on non-coherent
systems in case of device->coherent_dma_mask covering the whole memory space.

In case of non-coherent systems the coherent memory on MIPS is restricted by
size of un-cachable segment and should be located in ZONE_DMA.

Added __GFP_DMA flag in case of non-coherent systems to enforce an allocation
of coherent memory in ZONE_DMA.

Signed-off-by: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
---
 .../include/asm/mach-cavium-octeon/dma-coherence.h |    2 +-
 arch/mips/include/asm/mach-generic/dma-coherence.h |    2 +-
 arch/mips/include/asm/mach-ip27/dma-coherence.h    |    2 +-
 arch/mips/include/asm/mach-ip32/dma-coherence.h    |    2 +-
 arch/mips/include/asm/mach-jazz/dma-coherence.h    |    2 +-
 .../mips/include/asm/mach-loongson/dma-coherence.h |    2 +-
 arch/mips/mm/dma-default.c                         |   11 ++++++++---
 7 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h b/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
index f9f4486..fe0b465 100644
--- a/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
+++ b/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
@@ -52,7 +52,7 @@ static inline int plat_dma_supported(struct device *dev, u64 mask)
 	return 0;
 }
 
-static inline int plat_device_is_coherent(struct device *dev)
+static inline int plat_device_is_coherent(const struct device *dev)
 {
 	return 1;
 }
diff --git a/arch/mips/include/asm/mach-generic/dma-coherence.h b/arch/mips/include/asm/mach-generic/dma-coherence.h
index b4563df..2283996 100644
--- a/arch/mips/include/asm/mach-generic/dma-coherence.h
+++ b/arch/mips/include/asm/mach-generic/dma-coherence.h
@@ -47,7 +47,7 @@ static inline int plat_dma_supported(struct device *dev, u64 mask)
 	return 1;
 }
 
-static inline int plat_device_is_coherent(struct device *dev)
+static inline int plat_device_is_coherent(const struct device *dev)
 {
 #ifdef CONFIG_DMA_COHERENT
 	return 1;
diff --git a/arch/mips/include/asm/mach-ip27/dma-coherence.h b/arch/mips/include/asm/mach-ip27/dma-coherence.h
index 4ffddfd..c7767e3 100644
--- a/arch/mips/include/asm/mach-ip27/dma-coherence.h
+++ b/arch/mips/include/asm/mach-ip27/dma-coherence.h
@@ -58,7 +58,7 @@ static inline int plat_dma_supported(struct device *dev, u64 mask)
 	return 1;
 }
 
-static inline int plat_device_is_coherent(struct device *dev)
+static inline int plat_device_is_coherent(const struct device *dev)
 {
 	return 1;		/* IP27 non-cohernet mode is unsupported */
 }
diff --git a/arch/mips/include/asm/mach-ip32/dma-coherence.h b/arch/mips/include/asm/mach-ip32/dma-coherence.h
index 104cfbc..a6b6a55 100644
--- a/arch/mips/include/asm/mach-ip32/dma-coherence.h
+++ b/arch/mips/include/asm/mach-ip32/dma-coherence.h
@@ -80,7 +80,7 @@ static inline int plat_dma_supported(struct device *dev, u64 mask)
 	return 1;
 }
 
-static inline int plat_device_is_coherent(struct device *dev)
+static inline int plat_device_is_coherent(const struct device *dev)
 {
 	return 0;		/* IP32 is non-cohernet */
 }
diff --git a/arch/mips/include/asm/mach-jazz/dma-coherence.h b/arch/mips/include/asm/mach-jazz/dma-coherence.h
index 949003e..57c1a6c 100644
--- a/arch/mips/include/asm/mach-jazz/dma-coherence.h
+++ b/arch/mips/include/asm/mach-jazz/dma-coherence.h
@@ -48,7 +48,7 @@ static inline int plat_dma_supported(struct device *dev, u64 mask)
 	return 1;
 }
 
-static inline int plat_device_is_coherent(struct device *dev)
+static inline int plat_device_is_coherent(const struct device *dev)
 {
 	return 0;
 }
diff --git a/arch/mips/include/asm/mach-loongson/dma-coherence.h b/arch/mips/include/asm/mach-loongson/dma-coherence.h
index 6a90275..555d21b 100644
--- a/arch/mips/include/asm/mach-loongson/dma-coherence.h
+++ b/arch/mips/include/asm/mach-loongson/dma-coherence.h
@@ -69,7 +69,7 @@ static inline int plat_dma_supported(struct device *dev, u64 mask)
 	return 1;
 }
 
-static inline int plat_device_is_coherent(struct device *dev)
+static inline int plat_device_is_coherent(const struct device *dev)
 {
 #ifdef CONFIG_DMA_NONCOHERENT
 	return 0;
diff --git a/arch/mips/mm/dma-default.c b/arch/mips/mm/dma-default.c
index 42c819a..36e2237 100644
--- a/arch/mips/mm/dma-default.c
+++ b/arch/mips/mm/dma-default.c
@@ -69,7 +69,7 @@ static inline int cpu_needs_post_dma_flush(struct device *dev)
 		boot_cpu_type() == CPU_BMIPS5000);
 }
 
-static gfp_t massage_gfp_flags(const struct device *dev, gfp_t gfp)
+static gfp_t massage_gfp_flags(const struct device *dev, gfp_t gfp, int coherent)
 {
 	gfp_t dma_flag;
 
@@ -81,6 +81,11 @@ static gfp_t massage_gfp_flags(const struct device *dev, gfp_t gfp)
 		dma_flag = __GFP_DMA;
 	else
 #endif
+#ifdef CONFIG_ZONE_DMA
+	     if (coherent && !plat_device_is_coherent(dev))
+			dma_flag = __GFP_DMA;
+	else
+#endif
 #if defined(CONFIG_ZONE_DMA32) && defined(CONFIG_ZONE_DMA)
 	     if (dev->coherent_dma_mask < DMA_BIT_MASK(32))
 			dma_flag = __GFP_DMA;
@@ -111,7 +116,7 @@ void *dma_alloc_noncoherent(struct device *dev, size_t size,
 {
 	void *ret;
 
-	gfp = massage_gfp_flags(dev, gfp);
+	gfp = massage_gfp_flags(dev, gfp, 0);
 
 	ret = (void *) __get_free_pages(gfp, get_order(size));
 
@@ -132,7 +137,7 @@ static void *mips_dma_alloc_coherent(struct device *dev, size_t size,
 	if (dma_alloc_from_coherent(dev, size, dma_handle, &ret))
 		return ret;
 
-	gfp = massage_gfp_flags(dev, gfp);
+	gfp = massage_gfp_flags(dev, gfp, 1);
 
 	ret = (void *) __get_free_pages(gfp, get_order(size));
 

