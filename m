Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbaFWFGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 01:06:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbaFWFGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 01:06:06 -0400
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Salter <msalter@redhat.com>
Subject: [PATCH] arm64: make CONFIG_ZONE_DMA user settable
Date: Mon, 23 Jun 2014 01:05:24 -0400
Message-Id: <1403499924-11214-1-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 19e7640d1f (arm64: Replace ZONE_DMA32 with ZONE_DMA)
moves support for 32-bit DMA addressing into ZONE_DMA and renames
CONFIG_ZONE_DMA32 to CONFIG_ZONE_DMA.

Commit 2d5a5612bc (arm64: Limit the CMA buffer to 32-bit if ZONE_DMA)
forces the CMA buffer to be 32-bit addressable if CONFIG_ZONE_DMA is
defined.

These two patches pose a problem for platforms which have no 32-bit
addressable DRAM. If CONFIG_ZONE_DMA is turned on for such platforms,
CMA is unable to reserve a buffer for allocations. CONFIG_ZONE_DMA is
not user settable however, so there is no way to turn it off without
editing arch/arm64/Kconfig. Even if one edits Kconfig to turn off
CONFIG_ZONE_DMA, the kernel fails to build with such a config:

  arch/arm64/mm/init.c: In function ‘zone_sizes_init’:
  arch/arm64/mm/init.c:76:13: error: ‘ZONE_DMA’ undeclared (first use in this function)
     zone_size[ZONE_DMA] = max_dma - min;
               ^

This patch makes CONFIG_ZONE_DMA user settable and fixes the kernel
build when it is turned off.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/arm64/Kconfig   | 11 ++++++++---
 arch/arm64/mm/init.c |  8 ++++++--
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c8b1d0b..f669597 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -99,9 +99,6 @@ config GENERIC_CSUM
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config ZONE_DMA
-	def_bool y
-
 config ARCH_DMA_ADDR_T_64BIT
 	def_bool y
 
@@ -211,6 +208,14 @@ config HOTPLUG_CPU
 	  Say Y here to experiment with turning CPUs off and on.  CPUs
 	  can be controlled through /sys/devices/system/cpu.
 
+config ZONE_DMA
+	bool "32-bit DMA memory allocation"
+	def_bool y
+	help
+	  32-bit DMA memory allocation supports devices limited to 32-bit
+	  DMA addressing to allocate within the first 4GiB of address space.
+	  Disable if no such devices will be used.
+
 source kernel/Kconfig.preempt
 
 config HZ
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index f43db8a..c5415e2 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -69,12 +69,14 @@ static void __init zone_sizes_init(unsigned long min, unsigned long max)
 	memset(zone_size, 0, sizeof(zone_size));
 
 	/* 4GB maximum for 32-bit only capable devices */
-	if (IS_ENABLED(CONFIG_ZONE_DMA)) {
+#ifdef CONFIG_ZONE_DMA
+	{
 		unsigned long max_dma_phys =
 			(unsigned long)(dma_to_phys(NULL, DMA_BIT_MASK(32)) + 1);
 		max_dma = max(min, min(max, max_dma_phys >> PAGE_SHIFT));
 		zone_size[ZONE_DMA] = max_dma - min;
 	}
+#endif
 	zone_size[ZONE_NORMAL] = max - max_dma;
 
 	memcpy(zhole_size, zone_size, sizeof(zhole_size));
@@ -86,10 +88,12 @@ static void __init zone_sizes_init(unsigned long min, unsigned long max)
 		if (start >= max)
 			continue;
 
-		if (IS_ENABLED(CONFIG_ZONE_DMA) && start < max_dma) {
+#ifdef CONFIG_ZONE_DMA
+		if (start < max_dma) {
 			unsigned long dma_end = min(end, max_dma);
 			zhole_size[ZONE_DMA] -= dma_end - start;
 		}
+#endif
 
 		if (end > max_dma) {
 			unsigned long normal_end = min(end, max);
-- 
1.8.3.1

