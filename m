Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbaAFTdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 14:33:18 -0500
Received: from ni.piap.pl ([195.187.100.4]:56259 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899AbaAFTdR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 14:33:17 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <m338l6vldf.fsf@t19.piap.pl>
Date: Mon, 06 Jan 2014 20:33:15 +0100
In-Reply-To: <m338l6vldf.fsf@t19.piap.pl> ("Krzysztof =?utf-8?Q?Ha=C5=82as?=
 =?utf-8?Q?a=22's?= message of
	"Thu, 02 Jan 2014 09:27:56 +0100")
MIME-Version: 1.0
Message-ID: <m3d2k4x5vo.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH REPOST] ARM: Fix regression in IXP4xx network drivers DMA masks.
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20140106 #7262385, check: 20140106 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell et al.,

anything wrong with this fix?

the following patch is still needed with 3.13-rc6.
Affected are non-PCI devices using coherent allocations.

Without the patch:

# ifconfig eth0 up
net eth0: coherent DMA mask is unset
ifconfig: SIOCSIFFLAGS: Cannot allocate memory

IXP4xx: Fix DMA masks.

Now, devices will have 32-bit default DMA masks (0xFFFFFFFF) as per DMA API.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

diff --git a/arch/arm/mach-ixp4xx/common-pci.c b/arch/arm/mach-ixp4xx/common-pci.c
index 6d6bde3..cefb80b 100644
--- a/arch/arm/mach-ixp4xx/common-pci.c
+++ b/arch/arm/mach-ixp4xx/common-pci.c
@@ -316,32 +316,6 @@ static int abort_handler(unsigned long addr, unsigned int fsr, struct pt_regs *r
 }
 
 
-static int ixp4xx_needs_bounce(struct device *dev, dma_addr_t dma_addr, size_t size)
-{
-	return (dma_addr + size) >= SZ_64M;
-}
-
-/*
- * Setup DMA mask to 64MB on PCI devices. Ignore all other devices.
- */
-static int ixp4xx_pci_platform_notify(struct device *dev)
-{
-	if(dev->bus == &pci_bus_type) {
-		*dev->dma_mask =  SZ_64M - 1;
-		dev->coherent_dma_mask = SZ_64M - 1;
-		dmabounce_register_dev(dev, 2048, 4096, ixp4xx_needs_bounce);
-	}
-	return 0;
-}
-
-static int ixp4xx_pci_platform_notify_remove(struct device *dev)
-{
-	if(dev->bus == &pci_bus_type) {
-		dmabounce_unregister_dev(dev);
-	}
-	return 0;
-}
-
 void __init ixp4xx_pci_preinit(void)
 {
 	unsigned long cpuid = read_cpuid_id();
@@ -475,20 +449,8 @@ int ixp4xx_setup(int nr, struct pci_sys_data *sys)
 	pci_add_resource_offset(&sys->resources, &res[0], sys->io_offset);
 	pci_add_resource_offset(&sys->resources, &res[1], sys->mem_offset);
 
-	platform_notify = ixp4xx_pci_platform_notify;
-	platform_notify_remove = ixp4xx_pci_platform_notify_remove;
-
 	return 1;
 }
 
-int dma_set_coherent_mask(struct device *dev, u64 mask)
-{
-	if (mask >= SZ_64M - 1)
-		return 0;
-
-	return -EIO;
-}
-
 EXPORT_SYMBOL(ixp4xx_pci_read);
 EXPORT_SYMBOL(ixp4xx_pci_write);
-EXPORT_SYMBOL(dma_set_coherent_mask);
diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index 9edaf47..c03787c 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -30,8 +30,8 @@
 #include <linux/export.h>
 #include <linux/gpio.h>
 #include <linux/cpu.h>
+#include <linux/pci.h>
 #include <linux/sched_clock.h>
-
 #include <mach/udc.h>
 #include <mach/hardware.h>
 #include <mach/io.h>
@@ -40,7 +40,6 @@
 #include <asm/page.h>
 #include <asm/irq.h>
 #include <asm/system_misc.h>
-
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 #include <asm/mach/time.h>
@@ -578,6 +577,49 @@ void ixp4xx_restart(enum reboot_mode mode, const char *cmd)
 	}
 }
 
+#ifdef CONFIG_PCI
+static int ixp4xx_needs_bounce(struct device *dev, dma_addr_t dma_addr, size_t size)
+{
+	return (dma_addr + size) >= SZ_64M;
+}
+
+static int ixp4xx_platform_notify_remove(struct device *dev)
+{
+	if (dev->bus == &pci_bus_type)
+		dmabounce_unregister_dev(dev);
+
+	return 0;
+}
+#endif
+
+/*
+ * Setup DMA mask to 64MB on PCI devices and 4 GB on all other things.
+ */
+static int ixp4xx_platform_notify(struct device *dev)
+{
+#ifdef CONFIG_PCI
+	if (dev->bus == &pci_bus_type) {
+		dev->coherent_dma_mask = DMA_BIT_MASK(28); /* 64 MB */
+		dmabounce_register_dev(dev, 2048, 4096, ixp4xx_needs_bounce);
+	} else
+#endif
+		dev->coherent_dma_mask = DMA_BIT_MASK(32);
+
+	dev->dma_mask = &dev->coherent_dma_mask;
+	return 0;
+}
+
+int dma_set_coherent_mask(struct device *dev, u64 mask)
+{
+	if ((mask & DMA_BIT_MASK(28)) == DMA_BIT_MASK(28)) {
+		dev->coherent_dma_mask = mask;
+		return 0;
+	}
+
+	return -EIO;
+}
+EXPORT_SYMBOL(dma_set_coherent_mask);
+
 #ifdef CONFIG_IXP4XX_INDIRECT_PCI
 /*
  * In the case of using indirect PCI, we simply return the actual PCI
@@ -600,12 +642,16 @@ static void ixp4xx_iounmap(void __iomem *addr)
 	if (!is_pci_memory((__force u32)addr))
 		__iounmap(addr);
 }
+#endif
 
 void __init ixp4xx_init_early(void)
 {
+	platform_notify = ixp4xx_platform_notify;
+#ifdef CONFIG_PCI
+	platform_notify_remove = ixp4xx_platform_notify_remove;
+#endif
+#ifdef CONFIG_IXP4XX_INDIRECT_PCI
 	arch_ioremap_caller = ixp4xx_ioremap_caller;
 	arch_iounmap = ixp4xx_iounmap;
-}
-#else
-void __init ixp4xx_init_early(void) {}
 #endif
+}

-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
