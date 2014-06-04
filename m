Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaFDLOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:14:07 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:58646 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbaFDLNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:13:38 -0400
From: nyushchenko@dev.rtsoft.ru
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru
Subject: [PATCH 00/21] add and use devm_irq_of_parse_and_map()
Date: Wed,  4 Jun 2014 15:13:00 +0400
Message-Id: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently many device tree aware drivers use irq_of_parse_and_map() to get
IRQ number and then devm_request_irq() to set up IRQ handler.

This causes a problem for exit path and for error paths: undo action for
irq_of_parse_and_map() is irq_dispose_mapping() that must not be called
while IRQ handler is defined, but devres moves free_irq() out of driver
so driver does not have safe place to call irq_dispose_mapping().

So many drivers do not call irq_dispose_mapping() at all, others call it
while IRQ handler is defined (which is incorrect and causes error messages
in logs), even others refuse to use devres for managing IRQ handlers.

This patchset adds devres version of irq_of_parse_and_map(), and updates
in-tree users of both devres and irq_of_parse_and_map() to use
devm_irq_of_parse_and_map() instead.

[PATCH 01/21] irq: add devres version of OF IRQ mapping routines
[PATCH 02/21] ata: use devm_irq_of_parse_and_map() where appropriate
[PATCH 03/21] exynos5440-cpufreq: use devm_irq_of_parse_and_map()
[PATCH 04/21] omap-sham: use devm_irq_of_parse_and_map()
[PATCH 05/21] dma: use devm_irq_of_parse_and_map() where appropriate
[PATCH 06/21] mpc85xx_edac: use devm_irq_of_parse_and_map()
[PATCH 07/21] gpio: use devm_irq_of_parse_and_map() where
[PATCH 08/21] i2c: use devm_irq_of_parse_and_map() where appropriate
[PATCH 09/21] apbps2: use devm_irq_of_parse_and_map()
[PATCH 10/21] media: use devm_irq_of_parse_and_map() where
[PATCH 11/21] mfd: use devm_irq_of_parse_and_map() where appropriate
[PATCH 12/21] mpc5121_nfc: use devm_irq_of_parse_and_map()
[PATCH 13/21] net/can: use devm_irq_of_parse_and_map() where
[PATCH 14/21] net/ethernet: use devm_irq_of_parse_and_map() where
[PATCH 15/21] pinctrl: use devm_irq_of_parse_and_map() where
[PATCH 16/21] bq24190_charger: use devm_irq_of_parse_and_map()
[PATCH 17/21] rtc-mpc5121: use devm_irq_of_parse_and_map()
[PATCH 18/21] spi: use devm_irq_of_parse_and_map() where appropriate
[PATCH 19/21] exynos_tmu: use devm_irq_of_parse_and_map()
[PATCH 20/21] usb: use devm_irq_of_parse_and_map() where appropriate
[PATCH 21/21] at91sam9_wdt: use devm_irq_of_parse_and_map()

 drivers/ata/pata_mpc52xx.c                         |   24 +++++-----
 drivers/ata/sata_mv.c                              |    5 ++-
 drivers/cpufreq/exynos5440-cpufreq.c               |    4 +-
 drivers/crypto/omap-sham.c                         |    4 +-
 drivers/dma/moxart-dma.c                           |    4 +-
 drivers/dma/mpc512x_dma.c                          |   14 ++----
 drivers/dma/mv_xor.c                               |   18 +++-----
 drivers/dma/sirf-dma.c                             |   23 ++++------
 drivers/edac/mpc85xx_edac.c                        |   41 ++++++++++++-----
 drivers/gpio/gpio-adnp.c                           |    4 +-
 drivers/gpio/gpio-mcp23s08.c                       |    5 ++-
 drivers/i2c/busses/i2c-mpc.c                       |   12 ++---
 drivers/i2c/busses/i2c-mv64xxx.c                   |    2 +-
 drivers/i2c/busses/i2c-st.c                        |    6 +--
 drivers/i2c/busses/i2c-wmt.c                       |    6 +--
 drivers/input/serio/apbps2.c                       |    6 ++-
 drivers/media/platform/exynos4-is/fimc-is.c        |   14 +++---
 drivers/media/platform/fsl-viu.c                   |   25 ++++-------
 drivers/mfd/max8997.c                              |    4 +-
 drivers/mfd/max8998.c                              |    4 +-
 drivers/mtd/nand/mpc5121_nfc.c                     |    6 +--
 drivers/net/can/grcan.c                            |   11 ++---
 drivers/net/can/mscan/mpc5xxx_can.c                |   11 ++---
 drivers/net/can/sja1000/sja1000_platform.c         |    2 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |    6 +--
 drivers/net/ethernet/arc/emac_main.c               |    6 +--
 drivers/net/ethernet/marvell/mvneta.c              |   15 +++----
 drivers/net/ethernet/moxa/moxart_ether.c           |    4 +-
 .../net/ethernet/samsung/sxgbe/sxgbe_platform.c    |   24 ++++------
 drivers/of/irq.c                                   |   24 ++++++++++
 drivers/pinctrl/pinctrl-bcm2835.c                  |    6 ++-
 drivers/pinctrl/pinctrl-exynos.c                   |   11 ++---
 drivers/pinctrl/pinctrl-exynos5440.c               |    2 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |    6 ++-
 drivers/pinctrl/pinctrl-s3c24xx.c                  |    6 +--
 drivers/pinctrl/pinctrl-s3c64xx.c                  |    6 +--
 drivers/pinctrl/pinctrl-single.c                   |    6 ++-
 drivers/pinctrl/pinctrl-sunxi.c                    |    6 +--
 drivers/power/bq24190_charger.c                    |    2 +-
 drivers/rtc/rtc-mpc5121.c                          |   38 ++++++++--------
 drivers/spi/spi-bcm2835.c                          |    2 +-
 drivers/spi/spi-mpc512x-psc.c                      |    9 +++-
 drivers/spi/spi.c                                  |    8 +++-
 drivers/thermal/samsung/exynos_tmu.c               |    2 +-
 drivers/usb/gadget/gr_udc.c                        |   17 ++++---
 drivers/usb/host/ehci-grlib.c                      |   11 ++---
 drivers/usb/host/ehci-orion.c                      |    3 +-
 drivers/usb/host/ehci-ppc-of.c                     |   11 ++---
 drivers/usb/host/ehci-xilinx-of.c                  |    8 ++--
 drivers/usb/host/ohci-ppc-of.c                     |    7 +--
 drivers/watchdog/at91sam9_wdt.c                    |   12 ++---
 include/linux/irqdomain.h                          |    3 ++
 include/linux/of_irq.h                             |   12 +++++
 kernel/irq/irqdomain.c                             |   47 ++++++++++++++++++++


