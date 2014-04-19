Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbaDSOex (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 10:34:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58692 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283AbaDSOe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 10:34:27 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v2 5/7] ARM: dma: Use dma_pfn_offset for dma address translation
Date: Sat, 19 Apr 2014 10:32:50 -0400
Message-ID: <1397917972-6293-6-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397917972-6293-1-git-send-email-santosh.shilimkar@ti.com>
References: <1397917972-6293-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

In most of cases DMA addresses can be performed using offset value of
 Bus address space relatively to physical address space as following:

PFN->DMA:
 __pfn_to_phys(pfn + [-]dma_pfn_offset)

DMA->PFN:
 __phys_to_pfn(dma_addr) + [-]dma_pfn_offset

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/include/asm/dma-mapping.h |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index e701a4d..8c12149 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -58,22 +58,31 @@ static inline int dma_set_mask(struct device *dev, u64 mask)
 #ifndef __arch_pfn_to_dma
 static inline dma_addr_t pfn_to_dma(struct device *dev, unsigned long pfn)
 {
-	return (dma_addr_t)__pfn_to_bus(pfn);
+	if (!dev)
+		return DMA_ERROR_CODE;
+	return (dma_addr_t)__pfn_to_bus(pfn - dev->dma_pfn_offset);
 }
 
 static inline unsigned long dma_to_pfn(struct device *dev, dma_addr_t addr)
 {
-	return __bus_to_pfn(addr);
+	if (!dev)
+		return 0;
+	return __bus_to_pfn(addr) + dev->dma_pfn_offset;
 }
 
 static inline void *dma_to_virt(struct device *dev, dma_addr_t addr)
 {
-	return (void *)__bus_to_virt((unsigned long)addr);
+	if (!dev)
+		return NULL;
+	return (void *)__bus_to_virt(__pfn_to_bus(dma_to_pfn(dev, addr)));
 }
 
 static inline dma_addr_t virt_to_dma(struct device *dev, void *addr)
 {
-	return (dma_addr_t)__virt_to_bus((unsigned long)(addr));
+	if (!dev)
+		return DMA_ERROR_CODE;
+	return pfn_to_dma(dev,
+			   __bus_to_pfn(__virt_to_bus((unsigned long)(addr))));
 }
 
 #else
-- 
1.7.9.5

