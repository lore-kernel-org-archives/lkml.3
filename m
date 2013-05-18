Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818Ab3ERDFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:05:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23572 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757249Ab3ERDA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:27 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=eszwTjopA8AA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=5D882c9abpsA:10 a=pGLkceISAAAA:8 a=jAfPOIUMAAAA:8 a=VwQbUJbxAAAA:8 a=Op-mwl0xAAAA:8 a=nb1rjUjmG5ne69zbq8QA:9 a=MSl-tDqOz04A:10 a=gE_ZUhsuebIA:10 a=d4CUUju0HPYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021654.510598803@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Chris Ball <cjb@laptop.org>
Subject: [ 079/136 ] mmc: at91/avr32/atmel-mci: fix DMA-channel leak on module unload
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0079-mmc-at91-avr32-atmel-mci-fix-DMA-channel-leak-on-mod.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

[ Upstream commit 91cf54feecf815bec0b6a8d6d9dbd0e219f2f2cc ]

Fix regression introduced by commit 796211b7953 ("mmc: atmel-mci: add
pdc support and runtime capabilities detection") which removed the need
for CONFIG_MMC_ATMELMCI_DMA but kept the Kconfig-entry as well as the
compile guards around dma_release_channel() in remove(). Consequently,
DMA is always enabled (if supported), but the DMA-channel is not
released on module unload unless the DMA-config option is selected.

Remove the no longer used CONFIG_MMC_ATMELMCI_DMA option completely.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/configs/at91sam9g45_defconfig |    1 -
 arch/avr32/configs/favr-32_defconfig   |    1 -
 arch/avr32/configs/merisc_defconfig    |    1 -
 drivers/mmc/host/Kconfig               |   10 ----------
 drivers/mmc/host/atmel-mci.c           |    2 --
 5 files changed, 15 deletions(-)

diff --git a/arch/arm/configs/at91sam9g45_defconfig b/arch/arm/configs/at91sam9g45_defconfig
index 606d48f..8aab786 100644
--- a/arch/arm/configs/at91sam9g45_defconfig
+++ b/arch/arm/configs/at91sam9g45_defconfig
@@ -173,7 +173,6 @@ CONFIG_MMC=y
 # CONFIG_MMC_BLOCK_BOUNCE is not set
 CONFIG_SDIO_UART=m
 CONFIG_MMC_ATMELMCI=y
-CONFIG_MMC_ATMELMCI_DMA=y
 CONFIG_LEDS_ATMEL_PWM=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/avr32/configs/favr-32_defconfig b/arch/avr32/configs/favr-32_defconfig
index 19973b0..59e4cc9 100644
--- a/arch/avr32/configs/favr-32_defconfig
+++ b/arch/avr32/configs/favr-32_defconfig
@@ -122,7 +122,6 @@ CONFIG_USB_G_SERIAL=m
 CONFIG_USB_CDC_COMPOSITE=m
 CONFIG_MMC=y
 CONFIG_MMC_ATMELMCI=y
-CONFIG_MMC_ATMELMCI_DMA=y
 CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_ATMEL_PWM=m
diff --git a/arch/avr32/configs/merisc_defconfig b/arch/avr32/configs/merisc_defconfig
index 3befab9..65de443 100644
--- a/arch/avr32/configs/merisc_defconfig
+++ b/arch/avr32/configs/merisc_defconfig
@@ -102,7 +102,6 @@ CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_LOGO=y
 CONFIG_MMC=y
 CONFIG_MMC_ATMELMCI=y
-CONFIG_MMC_ATMELMCI_DMA=y
 CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_ATMEL_PWM=y
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index aa131b3..1449469 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -300,16 +300,6 @@ config MMC_ATMELMCI
 
 endchoice
 
-config MMC_ATMELMCI_DMA
-	bool "Atmel MCI DMA support"
-	depends on MMC_ATMELMCI && (AVR32 || ARCH_AT91SAM9G45) && DMA_ENGINE
-	help
-	  Say Y here to have the Atmel MCI driver use a DMA engine to
-	  do data transfers and thus increase the throughput and
-	  reduce the CPU utilization.
-
-	  If unsure, say N.
-
 config MMC_MSM
 	tristate "Qualcomm SDCC Controller Support"
 	depends on MMC && ARCH_MSM
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index a53c7c4..79d0095 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -2407,10 +2407,8 @@ static int __exit atmci_remove(struct platform_device *pdev)
 	atmci_readl(host, ATMCI_SR);
 	clk_disable(host->mck);
 
-#ifdef CONFIG_MMC_ATMELMCI_DMA
 	if (host->dma.chan)
 		dma_release_channel(host->dma.chan);
-#endif
 
 	free_irq(platform_get_irq(pdev, 0), host);
 	iounmap(host->regs);
-- 
1.7.10.4


