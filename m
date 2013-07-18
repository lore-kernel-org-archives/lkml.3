Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522Ab3GRGrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 02:47:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34652 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756448Ab3GRGrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 02:47:07 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kyungmin.park@samsung.com>, <balbi@ti.com>,
        <kishon@ti.com>, <jg1.han@samsung.com>, <s.nawrocki@samsung.com>,
        <kgene.kim@samsung.com>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <arnd@arndb.de>,
        <swarren@nvidia.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <akpm@linux-foundation.org>,
        <balajitk@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>
Subject: [PATCH 00/15] PHY framework
Date: Thu, 18 Jul 2013 12:16:09 +0530
Message-ID: <1374129984-765-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a generic PHY framework that provides a set of APIs for the PHY drivers
to create/destroy a PHY and APIs for the PHY users to obtain a reference to
the PHY with or without using phandle.

This framework will be of use only to devices that uses external PHY (PHY
functionality is not embedded within the controller).

The intention of creating this framework is to bring the phy drivers spread
all over the Linux kernel to drivers/phy to increase code re-use and to
increase code maintainability.

Comments to make PHY as bus wasn't done because PHY devices can be part of
other bus and making a same device attached to multiple bus leads to bad
design.

If the PHY driver has to send notification on connect/disconnect, the PHY
driver should make use of the extcon framework. Using this susbsystem
to use extcon framwork will have to be analysed.

Exynos MIPI CSIS/DSIM PHY and Displayport PHY have started using this
framework. Have included those patches also in this series.

twl4030-usb and omap-usb2 have also been adapted to this framework.

These patches are also available @
git://gitorious.org/linuxphy/linuxphy.git tags/phy-for-v3.12

Jingoo Han (3):
  phy: Add driver for Exynos DP PHY
  video: exynos_dp: remove non-DT support for Exynos Display Port
  video: exynos_dp: Use the generic PHY driver

Kishon Vijay Abraham I (8):
  drivers: phy: add generic PHY framework
  usb: phy: omap-usb2: use the new generic PHY framework
  usb: phy: twl4030: use the new generic PHY framework
  ARM: OMAP: USB: Add phy binding information
  ARM: dts: omap: update usb_otg_hs data
  usb: musb: omap2430: use the new generic PHY framework
  usb: phy: omap-usb2: remove *set_suspend* callback from omap-usb2
  usb: phy: twl4030-usb: remove *set_suspend* and *phy_init* ops

Sylwester Nawrocki (4):
  phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
  video: exynos_mipi_dsim: Use the generic PHY driver
  exynos4-is: Use the generic MIPI CSIS PHY driver
  ARM: Samsung: Remove the MIPI PHY setup code

 .../devicetree/bindings/phy/phy-bindings.txt       |   66 +++
 .../devicetree/bindings/phy/samsung-phy.txt        |   22 +
 Documentation/devicetree/bindings/usb/omap-usb.txt |    5 +
 Documentation/devicetree/bindings/usb/usb-phy.txt  |    6 +
 .../devicetree/bindings/video/exynos_dp.txt        |   18 +-
 Documentation/phy.txt                              |  129 +++++
 MAINTAINERS                                        |    7 +
 arch/arm/boot/dts/omap3-beagle-xm.dts              |    2 +
 arch/arm/boot/dts/omap3-evm.dts                    |    2 +
 arch/arm/boot/dts/omap3-overo.dtsi                 |    2 +
 arch/arm/boot/dts/omap4.dtsi                       |    3 +
 arch/arm/boot/dts/twl4030.dtsi                     |    1 +
 arch/arm/mach-exynos/include/mach/regs-pmu.h       |    5 -
 arch/arm/mach-omap2/usb-musb.c                     |    3 +
 arch/arm/mach-s5pv210/include/mach/regs-clock.h    |    4 -
 arch/arm/plat-samsung/Kconfig                      |    5 -
 arch/arm/plat-samsung/Makefile                     |    1 -
 arch/arm/plat-samsung/setup-mipiphy.c              |   60 ---
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    2 +
 drivers/media/platform/exynos4-is/mipi-csis.c      |   16 +-
 drivers/phy/Kconfig                                |   28 +
 drivers/phy/Makefile                               |    7 +
 drivers/phy/phy-core.c                             |  544 ++++++++++++++++++++
 drivers/phy/phy-exynos-dp-video.c                  |  111 ++++
 drivers/phy/phy-exynos-mipi-video.c                |  169 ++++++
 drivers/usb/musb/Kconfig                           |    1 +
 drivers/usb/musb/musb_core.c                       |    1 +
 drivers/usb/musb/musb_core.h                       |    3 +
 drivers/usb/musb/omap2430.c                        |   26 +-
 drivers/usb/phy/Kconfig                            |    1 +
 drivers/usb/phy/phy-omap-usb2.c                    |   60 ++-
 drivers/usb/phy/phy-twl4030-usb.c                  |   63 ++-
 drivers/video/exynos/Kconfig                       |    2 +-
 drivers/video/exynos/exynos_dp_core.c              |  132 ++---
 drivers/video/exynos/exynos_dp_core.h              |  110 ++++
 drivers/video/exynos/exynos_dp_reg.c               |    2 -
 drivers/video/exynos/exynos_mipi_dsi.c             |   19 +-
 include/linux/phy/phy.h                            |  344 +++++++++++++
 include/linux/platform_data/mipi-csis.h            |   11 +-
 include/linux/usb/musb.h                           |    3 +
 include/video/exynos_dp.h                          |  131 -----
 include/video/exynos_mipi_dsim.h                   |    6 +-
 43 files changed, 1746 insertions(+), 389 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/phy-bindings.txt
 create mode 100644 Documentation/devicetree/bindings/phy/samsung-phy.txt
 create mode 100644 Documentation/phy.txt
 delete mode 100644 arch/arm/plat-samsung/setup-mipiphy.c
 create mode 100644 drivers/phy/Kconfig
 create mode 100644 drivers/phy/Makefile
 create mode 100644 drivers/phy/phy-core.c
 create mode 100644 drivers/phy/phy-exynos-dp-video.c
 create mode 100644 drivers/phy/phy-exynos-mipi-video.c
 create mode 100644 include/linux/phy/phy.h
 delete mode 100644 include/video/exynos_dp.h

-- 
1.7.10.4

