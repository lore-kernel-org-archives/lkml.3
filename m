Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab3IXIyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:54:39 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37614 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab3IXIyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:54:35 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <bcousson@baylibre.com>, <tony@atomide.com>
CC: <p.zabel@pengutronix.de>, <broonie@kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v3 00/10] USB: phy: phy-nop: Manage RESET GPIO in the driver
Date: Tue, 24 Sep 2013 11:53:46 +0300
Message-ID: <1380012836-29900-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Modelling the RESET line as a regulator supply wasn't a good idea
as it abuses the regulator framework and makes adaptation
code/data more complex.

Instead, manage the RESET gpio line directly in the driver.

This also makes us easy to migrate to a dedicated GPIO RESET controller
whenever it becomes available.

Apart from RESET line changes this series also adds USB host support
fro beagle-xm and fixes USB OTG port on beagle.

The full series is avilable at
	git://github.com/rogerq/linux.git
in branch
	phy-reset

*NOTE:* As there are changes to platform data, Patch 1 needs to be shared
between the arm-soc tree and usb tree.

Patch 1 is available at repo
	git://github.com/rogerq/linux.git
in branch
	phy-reset-common

Patch 2 contains the phy-nop driver changes
Patches 3 and 4 adapt legacy boot code to the phy-nop driver changes.
Patches 5, 6 and 7 adapt DT data to the binding changes.
Patch 8 is cleanup of omap3-beagle DT.
Patch 9 adds USB host support to omap3-beagle-xm using the new binding.
Patch 10 fixes USB OTG port on beagle.

Patches are based on v3.12-rc1

Tested leacy boot on omap3-beagle and omap3-beagle-xm
Tested DT boot on omap3-beagle, omap3-beagle-xm and omap4-panda-es

v3:
- Fix the Initial state of RESET line at probe time.
- Update hsusb3_reset line on omap5-uevm as well.
- Add patch 10 that fixes USB OTG port on beagle.

v2:
- Added RESET GPIO polarity feature
- Changed to gpio_set_value_cansleep()

cheers,
-roger

Roger Quadros (10):
  usb: phy: generic: Add gpio_reset to platform data
  usb: phy: generic: Don't use regulator framework for RESET line
  ARM: OMAP2+: omap-usb-host: Get rid of platform_data from struct
    usbhs_phy_data
  ARM: OMAP2+: usb-host: Adapt to USB phy-nop RESET line changes
  ARM: dts: omap3-beagle: Use reset-gpios for hsusb2_reset
  ARM: dts: omap4-panda: Use reset-gpios for hsusb1_reset
  ARM: dts: omap5-uevm: Use reset-gpios for hsusb2/3_reset
  ARM: dts: omap3-beagle: Make USB host pin naming consistent
  ARM: dts: omap3-beagle-xm: Add USB Host support
  ARM: dts: omap3-beagle: Add USB OTG PHY details

 .../devicetree/bindings/usb/usb-nop-xceiv.txt      |    7 +-
 arch/arm/boot/dts/omap3-beagle-xm.dts              |   65 +++++++++++++--
 arch/arm/boot/dts/omap3-beagle.dts                 |   44 +++++------
 arch/arm/boot/dts/omap4-panda-common.dtsi          |   18 +----
 arch/arm/boot/dts/omap5-uevm.dts                   |   26 +------
 arch/arm/mach-omap2/board-omap3beagle.c            |    6 --
 arch/arm/mach-omap2/usb-host.c                     |   18 ++--
 arch/arm/mach-omap2/usb.h                          |    1 -
 drivers/usb/phy/phy-am335x.c                       |    2 +-
 drivers/usb/phy/phy-generic.c                      |   84 +++++++++++++-------
 drivers/usb/phy/phy-generic.h                      |    6 +-
 include/linux/usb/usb_phy_gen_xceiv.h              |    3 +-
 12 files changed, 153 insertions(+), 127 deletions(-)

-- 
1.7.4.1

