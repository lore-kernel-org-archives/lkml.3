Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab3LSVLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 16:11:47 -0500
Received: from seketeli.net ([91.121.166.71]:38294 "EHLO ms.seketeli.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756211Ab3LSVLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 16:11:44 -0500
From: Apelete Seketeli <apelete@seketeli.net>
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH] arch: mips: update platform data for JZ4740 usb device controller
Date: Thu, 19 Dec 2013 22:11:43 +0100
Message-Id: <1387487503-26161-2-git-send-email-apelete@seketeli.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387487503-26161-1-git-send-email-apelete@seketeli.net>
References: <1387487503-26161-1-git-send-email-apelete@seketeli.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform data already available in tree for JZ4740 USB Device
Controller was previously used by an out-of-tree USB gadget driver
which was not relying on the musb driver and was written by Ingenic
and the Qi-Hardware community.

Update platform data for JZ4740 USB device controller to be used with
musb driver.

Signed-off-by: Apelete Seketeli <apelete@seketeli.net>
---
 arch/mips/include/asm/mach-jz4740/platform.h |    1 +
 arch/mips/jz4740/board-qi_lb60.c             |    1 +
 arch/mips/jz4740/platform.c                  |   40 +++++++++++++++-----------
 3 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/arch/mips/include/asm/mach-jz4740/platform.h b/arch/mips/include/asm/mach-jz4740/platform.h
index 05988c2..069b43a 100644
--- a/arch/mips/include/asm/mach-jz4740/platform.h
+++ b/arch/mips/include/asm/mach-jz4740/platform.h
@@ -21,6 +21,7 @@
 
 extern struct platform_device jz4740_usb_ohci_device;
 extern struct platform_device jz4740_udc_device;
+extern struct platform_device jz4740_udc_xceiv_device;
 extern struct platform_device jz4740_mmc_device;
 extern struct platform_device jz4740_rtc_device;
 extern struct platform_device jz4740_i2c_device;
diff --git a/arch/mips/jz4740/board-qi_lb60.c b/arch/mips/jz4740/board-qi_lb60.c
index 8a5ec0e..c01900e 100644
--- a/arch/mips/jz4740/board-qi_lb60.c
+++ b/arch/mips/jz4740/board-qi_lb60.c
@@ -427,6 +427,7 @@ static struct platform_device qi_lb60_audio_device = {
 
 static struct platform_device *jz_platform_devices[] __initdata = {
 	&jz4740_udc_device,
+	&jz4740_udc_xceiv_device,
 	&jz4740_mmc_device,
 	&jz4740_nand_device,
 	&qi_lb60_keypad,
diff --git a/arch/mips/jz4740/platform.c b/arch/mips/jz4740/platform.c
index df65677..1be41e2 100644
--- a/arch/mips/jz4740/platform.c
+++ b/arch/mips/jz4740/platform.c
@@ -21,6 +21,8 @@
 
 #include <linux/dma-mapping.h>
 
+#include <linux/usb/musb.h>
+
 #include <asm/mach-jz4740/platform.h>
 #include <asm/mach-jz4740/base.h>
 #include <asm/mach-jz4740/irq.h>
@@ -56,29 +58,35 @@ struct platform_device jz4740_usb_ohci_device = {
 	.resource	= jz4740_usb_ohci_resources,
 };
 
-/* UDC (USB gadget controller) */
-static struct resource jz4740_usb_gdt_resources[] = {
-	{
-		.start	= JZ4740_UDC_BASE_ADDR,
-		.end	= JZ4740_UDC_BASE_ADDR + 0x1000 - 1,
-		.flags	= IORESOURCE_MEM,
+/* USB Device Controller */
+struct platform_device jz4740_udc_xceiv_device = {
+	.name = "usb_phy_gen_xceiv",
+	.id   = 0,
+};
+
+static struct resource jz4740_udc_resources[] = {
+	[0] = {
+		.start = JZ4740_UDC_BASE_ADDR,
+		.end   = JZ4740_UDC_BASE_ADDR + 0x10000 - 1,
+		.flags = IORESOURCE_MEM,
 	},
-	{
-		.start	= JZ4740_IRQ_UDC,
-		.end	= JZ4740_IRQ_UDC,
-		.flags	= IORESOURCE_IRQ,
+	[1] = {
+		.start = JZ4740_IRQ_UDC,
+		.end   = JZ4740_IRQ_UDC,
+		.flags = IORESOURCE_IRQ,
+		.name  = "mc",
 	},
 };
 
 struct platform_device jz4740_udc_device = {
-	.name		= "jz-udc",
-	.id		= -1,
-	.dev = {
-		.dma_mask = &jz4740_udc_device.dev.coherent_dma_mask,
+	.name = "musb-jz4740",
+	.id   = -1,
+	.dev  = {
+		.dma_mask          = &jz4740_udc_device.dev.coherent_dma_mask,
 		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
-	.num_resources	= ARRAY_SIZE(jz4740_usb_gdt_resources),
-	.resource	= jz4740_usb_gdt_resources,
+	.num_resources = ARRAY_SIZE(jz4740_udc_resources),
+	.resource      = jz4740_udc_resources,
 };
 
 /* MMC/SD controller */
-- 
1.7.10.4

