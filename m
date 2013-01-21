Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab3AUKJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:09:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56034 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab3AUKJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:09:43 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 00/33] Sanitize devm_request_and_ioremap()
Date: Mon, 21 Jan 2013 11:08:53 +0100
Message-Id: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
X-Provags-ID: V02:K0:PX2y0RGOHboJRqEtN0bDa2z71BwBTXUwZv725rfXwAB
 fqS6ZgIL5DxVCTdJcUi+OJ4aaNOVV4KGuG4R1o53m1o1KyAbNe
 hPzsRJ4HabABRoGl/7KoGguBsJUp3wf+60hJAT5OVKUb+e6ngY
 3uwVOe0SUOi+G7w5pShsi45+zqwHK6IMbtMKw4B2IJHZHw6sL3
 F1kpe+yDvP78llnQ5ei2LTN5T1V8PLVAzpfXhMPO4ymnHeZp1+
 26hgmHIhYK3HCJAOHb5Ushr35ucLs4cBMnx/VS2rZs7b9xlEBb
 B5uckSCs5SMxs4P98QXtE5dcrRs+LTyf3oTegkyD4UzVyTGDWq
 jcNhYAlIxOaKAS7Pm7c48fgaLuNgnMT/sUWgbQ57EMFELAWx1z
 iFtnSL6MEzxugGJGIcyoW44QK+DOEn3n2M/QopyJA+PKKaB0DD
 WgcM6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent discussions about the lack of a meaningful error code returned by
devm_request_and_ioremap() have triggered this patch series. One common
issue is that the function returns NULL in all failure cases, making it
impossible to determine what went wrong exactly. Another problem is that
people can't seem to agree on what error code to return in case where
the function fails. Both of these problems lead to inconsistent usage.

This series attempts to fix this by providing a replacement function,
devm_ioremap_resource(), which returns a pointer to the remapped memory
region on success and an ERR_PTR()-encoded error code on failure. Users
can check for failure using the IS_ERR() macro and determine the exact
cause by extracting the error code using PTR_ERR().

Patch 1 adds the new devm_ioremap_resource() function, which is really
just a renamed version of devm_request_and_ioremap() that returns
ERR_PTR()-encoded error codes on failure and makes the old function a
wrapper around it, returning NULL in case of devm_ioremap_resource()
failure. Furthermore the patch marks devm_request_and_ioremap() as a
deprecated function to make it clear that it should no longer be used.
A semantic patch is included that was used to convert the bulk of the
existing calls to devm_request_and_ioremap() to the new API. The patch
is far from perfect and a few occurrences had to be converted or fixed
up manually.

The remaining patches convert each subsystem separately to use the new
API.

Thierry

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Wolfram Sang <w.sang@pengutronix.de>

Thierry Reding (33):
  lib: devres: Introduce devm_ioremap_resource()
  ARM: Convert to devm_ioremap_resource()
  MIPS: Convert to devm_ioremap_resource()
  amba: Convert to devm_ioremap_resource()
  ata: Convert to devm_ioremap_resource()
  char: Convert to devm_ioremap_resource()
  dma: Convert to devm_ioremap_resource()
  gpio: Convert to devm_ioremap_resource()
  drm: Convert to devm_ioremap_resource()
  i2c: Convert to devm_ioremap_resource()
  iio: Convert to devm_ioremap_resource()
  Input: Convert to devm_ioremap_resource()
  iommu: Convert to devm_ioremap_resource()
  media: Convert to devm_ioremap_resource()
  memory: Convert to devm_ioremap_resource()
  mfd: Convert to devm_ioremap_resource()
  misc: Convert to devm_ioremap_resource()
  mmc: Convert to devm_ioremap_resource()
  mtd: Convert to devm_ioremap_resource()
  net: Convert to devm_ioremap_resource()
  pinctrl: Convert to devm_ioremap_resource()
  power: Convert to devm_ioremap_resource()
  pwm: Convert to devm_ioremap_resource()
  rtc: Convert to devm_ioremap_resource()
  spi: Convert to devm_ioremap_resource()
  staging: Convert to devm_ioremap_resource()
  thermal: Convert to devm_ioremap_resource()
  serial: Convert to devm_ioremap_resource()
  usb: Convert to devm_ioremap_resource()
  video: Convert to devm_ioremap_resource()
  w1: Convert to devm_ioremap_resource()
  watchdog: Convert to devm_ioremap_resource()
  ASoC: Convert to devm_ioremap_resource()

 Documentation/driver-model/devres.txt              |  3 +-
 arch/arm/mach-omap2/gpmc.c                         |  8 +-
 arch/arm/mach-tegra/tegra2_emc.c                   |  8 +-
 arch/arm/plat-omap/dmtimer.c                       |  8 +-
 arch/arm/plat-samsung/adc.c                        |  8 +-
 arch/mips/lantiq/xway/dma.c                        |  5 +-
 arch/mips/lantiq/xway/gptu.c                       |  8 +-
 arch/mips/pci/pci-lantiq.c                         | 12 +--
 drivers/amba/tegra-ahb.c                           |  7 +-
 drivers/ata/pata_ep93xx.c                          |  7 +-
 drivers/char/hw_random/exynos-rng.c                |  9 ++-
 drivers/char/hw_random/omap-rng.c                  |  6 +-
 drivers/char/hw_random/tx4939-rng.c                |  7 +-
 drivers/dma/dw_dmac.c                              |  7 +-
 drivers/dma/imx-dma.c                              |  7 +-
 drivers/dma/mmp_pdma.c                             |  7 +-
 drivers/dma/mmp_tdma.c                             |  7 +-
 drivers/dma/tegra20-apb-dma.c                      | 10 +--
 drivers/gpio/gpio-mvebu.c                          | 16 ++--
 drivers/gpio/gpio-mxs.c                            |  9 ++-
 drivers/gpio/gpio-spear-spics.c                    |  8 +-
 drivers/gpio/gpio-stp-xway.c                       |  9 +--
 drivers/gpio/gpio-tegra.c                          |  9 +--
 drivers/gpu/drm/exynos/exynos_drm_fimc.c           |  8 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |  8 +-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c            |  7 +-
 drivers/gpu/drm/exynos/exynos_drm_gsc.c            |  8 +-
 drivers/gpu/drm/exynos/exynos_drm_rotator.c        |  8 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c               |  8 +-
 drivers/gpu/drm/tegra/dc.c                         |  8 +-
 drivers/gpu/drm/tegra/hdmi.c                       |  6 +-
 drivers/gpu/drm/tegra/host1x.c                     |  6 +-
 drivers/i2c/busses/i2c-at91.c                      |  6 +-
 drivers/i2c/busses/i2c-imx.c                       |  6 +-
 drivers/i2c/busses/i2c-ocores.c                    |  7 +-
 drivers/i2c/busses/i2c-omap.c                      |  8 +-
 drivers/i2c/busses/i2c-rcar.c                      |  8 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |  7 +-
 drivers/i2c/busses/i2c-sirf.c                      |  7 +-
 drivers/i2c/busses/i2c-stu300.c                    |  6 +-
 drivers/i2c/busses/i2c-tegra.c                     |  8 +-
 drivers/i2c/busses/i2c-xlr.c                       |  9 +--
 drivers/iio/adc/at91_adc.c                         |  6 +-
 drivers/input/keyboard/spear-keyboard.c            |  8 +-
 drivers/input/serio/arc_ps2.c                      |  7 +-
 drivers/iommu/tegra-smmu.c                         |  7 +-
 drivers/media/platform/exynos-gsc/gsc-core.c       |  8 +-
 drivers/media/platform/mx2_emmaprp.c               |  6 +-
 drivers/media/platform/s3c-camif/camif-core.c      |  8 +-
 drivers/media/platform/s5p-fimc/fimc-core.c        |  8 +-
 drivers/media/platform/s5p-fimc/fimc-lite.c        |  8 +-
 drivers/media/platform/s5p-fimc/mipi-csis.c        |  8 +-
 drivers/media/platform/s5p-g2d/g2d.c               |  8 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |  8 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  8 +-
 drivers/media/platform/soc_camera/mx2_camera.c     | 12 +--
 drivers/memory/emif.c                              |  8 +-
 drivers/memory/tegra20-mc.c                        |  7 +-
 drivers/memory/tegra30-mc.c                        |  7 +-
 drivers/mfd/intel_msic.c                           |  9 +--
 drivers/misc/atmel-ssc.c                           |  8 +-
 drivers/mmc/host/dw_mmc-pltfm.c                    |  7 +-
 drivers/mmc/host/mxs-mmc.c                         |  6 +-
 drivers/mmc/host/sdhci-s3c.c                       |  7 +-
 drivers/mtd/devices/spear_smi.c                    |  7 +-
 drivers/mtd/maps/autcpu12-nvram.c                  |  9 +--
 drivers/mtd/maps/lantiq-flash.c                    |  8 +-
 drivers/mtd/nand/fsmc_nand.c                       | 33 ++++----
 drivers/mtd/nand/lpc32xx_mlc.c                     |  9 +--
 drivers/mtd/nand/lpc32xx_slc.c                     |  8 +-
 drivers/mtd/nand/mxc_nand.c                        | 12 +--
 drivers/mtd/nand/s3c2410.c                         |  7 +-
 drivers/mtd/nand/txx9ndfmc.c                       |  7 +-
 drivers/net/can/grcan.c                            |  8 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  9 +--
 drivers/pinctrl/pinctrl-at91.c                     |  7 +-
 drivers/pinctrl/pinctrl-bcm2835.c                  |  6 +-
 drivers/pinctrl/pinctrl-coh901.c                   |  8 +-
 drivers/pinctrl/pinctrl-exynos5440.c               |  8 +-
 drivers/pinctrl/pinctrl-falcon.c                   | 13 ++--
 drivers/pinctrl/pinctrl-imx.c                      |  6 +-
 drivers/pinctrl/pinctrl-nomadik.c                  |  6 +-
 drivers/pinctrl/pinctrl-pxa3xx.c                   |  7 +-
 drivers/pinctrl/pinctrl-samsung.c                  |  8 +-
 drivers/pinctrl/pinctrl-u300.c                     |  6 +-
 drivers/pinctrl/pinctrl-xway.c                     |  9 +--
 drivers/pinctrl/spear/pinctrl-plgpio.c             |  8 +-
 drivers/power/jz4740-battery.c                     |  7 +-
 drivers/pwm/pwm-imx.c                              |  6 +-
 drivers/pwm/pwm-lpc32xx.c                          |  6 +-
 drivers/pwm/pwm-mxs.c                              |  6 +-
 drivers/pwm/pwm-puv3.c                             |  6 +-
 drivers/pwm/pwm-pxa.c                              |  6 +-
 drivers/pwm/pwm-spear.c                            |  6 +-
 drivers/pwm/pwm-tegra.c                            |  6 +-
 drivers/pwm/pwm-tiecap.c                           |  6 +-
 drivers/pwm/pwm-tiehrpwm.c                         |  6 +-
 drivers/pwm/pwm-tipwmss.c                          |  6 +-
 drivers/pwm/pwm-vt8500.c                           |  6 +-
 drivers/rtc/rtc-s3c.c                              |  8 +-
 drivers/rtc/rtc-snvs.c                             |  6 +-
 drivers/rtc/rtc-spear.c                            |  8 +-
 drivers/rtc/rtc-tegra.c                            |  8 +-
 drivers/spi/spi-ep93xx.c                           |  7 +-
 drivers/spi/spi-mxs.c                              |  6 +-
 drivers/spi/spi-omap2-mcspi.c                      |  7 +-
 drivers/spi/spi-s3c64xx.c                          |  7 +-
 drivers/spi/spi-sirf.c                             |  7 +-
 drivers/spi/spi-tegra20-sflash.c                   |  8 +-
 drivers/spi/spi-tegra20-slink.c                    |  8 +-
 drivers/staging/iio/adc/mxs-lradc.c                |  7 +-
 drivers/staging/nvec/nvec.c                        |  8 +-
 drivers/staging/omap-thermal/omap-bandgap.c        | 11 +--
 drivers/thermal/exynos_thermal.c                   |  8 +-
 drivers/tty/serial/sccnxp.c                        |  8 +-
 drivers/usb/chipidea/usbmisc_imx6q.c               |  6 +-
 drivers/usb/gadget/bcm63xx_udc.c                   | 13 ++--
 drivers/usb/gadget/s3c-hsotg.c                     |  7 +-
 drivers/usb/gadget/s3c-hsudc.c                     |  7 +-
 drivers/usb/host/ehci-atmel.c                      |  7 +-
 drivers/usb/host/ehci-grlib.c                      |  9 +--
 drivers/usb/host/ehci-mxc.c                        |  7 +-
 drivers/usb/host/ehci-platform.c                   |  7 +-
 drivers/usb/host/ehci-ppc-of.c                     |  8 +-
 drivers/usb/host/ehci-sead3.c                      |  8 +-
 drivers/usb/host/ehci-sh.c                         |  7 +-
 drivers/usb/host/ehci-vt8500.c                     |  8 +-
 drivers/usb/host/ehci-xilinx-of.c                  |  8 +-
 drivers/usb/host/ohci-nxp.c                        |  7 +-
 drivers/usb/host/ohci-platform.c                   |  7 +-
 drivers/usb/host/ohci-s3c2410.c                    |  7 +-
 drivers/usb/musb/musb_dsps.c                       |  7 +-
 drivers/usb/musb/omap2430.c                        |  4 +-
 drivers/usb/otg/mxs-phy.c                          |  6 +-
 drivers/usb/phy/mv_u3d_phy.c                       |  8 +-
 drivers/usb/phy/omap-usb2.c                        |  8 +-
 drivers/usb/renesas_usbhs/common.c                 |  9 +--
 drivers/video/exynos/exynos_dp_core.c              |  8 +-
 drivers/video/jz4740_fb.c                          |  6 +-
 drivers/video/omap2/dss/hdmi.c                     |  8 +-
 drivers/video/omap2/vrfb.c                         |  9 +--
 drivers/video/s3c-fb.c                             |  7 +-
 drivers/w1/masters/omap_hdq.c                      |  8 +-
 drivers/watchdog/ar7_wdt.c                         |  8 +-
 drivers/watchdog/dw_wdt.c                          |  6 +-
 drivers/watchdog/imx2_wdt.c                        |  8 +-
 drivers/watchdog/jz4740_wdt.c                      |  6 +-
 drivers/watchdog/lantiq_wdt.c                      |  8 +-
 drivers/watchdog/max63xx_wdt.c                     |  7 +-
 drivers/watchdog/pnx4008_wdt.c                     |  6 +-
 drivers/watchdog/txx9wdt.c                         |  6 +-
 include/linux/device.h                             |  3 +-
 lib/devres.c                                       | 57 ++++++++++----
 scripts/coccinelle/api/devm_ioremap_resource.cocci | 90 ++++++++++++++++++++++
 sound/soc/cirrus/ep93xx-ac97.c                     |  7 +-
 sound/soc/cirrus/ep93xx-i2s.c                      |  6 +-
 sound/soc/codecs/jz4740.c                          |  6 +-
 sound/soc/fsl/imx-audmux.c                         |  6 +-
 sound/soc/fsl/imx-ssi.c                            |  7 +-
 sound/soc/kirkwood/kirkwood-i2s.c                  |  8 +-
 sound/soc/mxs/mxs-saif.c                           |  8 +-
 sound/soc/pxa/mmp-sspa.c                           |  6 +-
 162 files changed, 686 insertions(+), 681 deletions(-)
 create mode 100644 scripts/coccinelle/api/devm_ioremap_resource.cocci

-- 
1.8.1

