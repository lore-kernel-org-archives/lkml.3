Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab3ETKwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:52:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55913 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab3ETKwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:08 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>, Chris Ball <cjb@laptop.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 001/115] mmc: at91/avr32/atmel-mci: fix DMA-channel leak on module unload
Date: Mon, 20 May 2013 11:50:01 +0100
Message-Id: <1369047116-9378-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/configs/at91sam9g45_defconfig |  1 -
 arch/avr32/configs/favr-32_defconfig   |  1 -
 arch/avr32/configs/merisc_defconfig    |  1 -
 drivers/mmc/host/Kconfig               | 10 ----------
 drivers/mmc/host/atmel-mci.c           |  2 --
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
index 1a69c63..77e998b 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -2401,10 +2401,8 @@ static int __exit atmci_remove(struct platform_device *pdev)
 	atmci_readl(host, ATMCI_SR);
 	clk_disable(host->mck);
 
-#ifdef CONFIG_MMC_ATMELMCI_DMA
 	if (host->dma.chan)
 		dma_release_channel(host->dma.chan);
-#endif
 
 	free_irq(platform_get_irq(pdev, 0), host);
 	iounmap(host->regs);
-- 
1.8.1.2

