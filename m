Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127Ab3EFXs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:48:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36185 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932879Ab3EFW5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:57:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Chris Ball <cjb@laptop.org>
Subject: [ 58/63] mmc: at91/avr32/atmel-mci: fix DMA-channel leak on module unload
Date: Mon,  6 May 2013 15:56:36 -0700
Message-Id: <20130506225328.672999136@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506225314.802167948@linuxfoundation.org>
References: <20130506225314.802167948@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 91cf54feecf815bec0b6a8d6d9dbd0e219f2f2cc upstream.

Fix regression introduced by commit 796211b7953 ("mmc: atmel-mci: add
pdc support and runtime capabilities detection") which removed the need
for CONFIG_MMC_ATMELMCI_DMA but kept the Kconfig-entry as well as the
compile guards around dma_release_channel() in remove(). Consequently,
DMA is always enabled (if supported), but the DMA-channel is not
released on module unload unless the DMA-config option is selected.

Remove the no longer used CONFIG_MMC_ATMELMCI_DMA option completely.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/configs/at91sam9g45_defconfig |    1 -
 arch/avr32/configs/favr-32_defconfig   |    1 -
 arch/avr32/configs/merisc_defconfig    |    1 -
 drivers/mmc/host/Kconfig               |   10 ----------
 drivers/mmc/host/atmel-mci.c           |    2 --
 5 files changed, 15 deletions(-)

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
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -297,16 +297,6 @@ config MMC_ATMELMCI
 
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
 config MMC_IMX
 	tristate "Motorola i.MX Multimedia Card Interface support"
 	depends on ARCH_MX1
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -2190,10 +2190,8 @@ static int __exit atmci_remove(struct pl
 	atmci_readl(host, ATMCI_SR);
 	clk_disable(host->mck);
 
-#ifdef CONFIG_MMC_ATMELMCI_DMA
 	if (host->dma.chan)
 		dma_release_channel(host->dma.chan);
-#endif
 
 	free_irq(platform_get_irq(pdev, 0), host);
 	iounmap(host->regs);


