Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbbAZMPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:15:46 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37097 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbbAZMPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:15:43 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <tony@atomide.com>, <myungjoo.ham@samsung.com>,
        <cw00.choi@samsung.com>
CC: <george.cherian@ti.com>, <nsekhar@ti.com>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v2 0/7] extcon: usb: Introduce USB GPIO extcon driver. Fix DRA7 & AM57xx USB.
Date: Mon, 26 Jan 2015 14:15:25 +0200
Message-ID: <1422274532-9488-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Still hoping this can make into 3.20 else we have USB peripheral mode broken on
DRA7-evm, DRA72-evm and AM57xx-beagle-x15.

On DRA7 and AM57xx EVMs the USB ID pin is connected to a GPIO line.
The USB drivers (dwc3 + dwc3-omap) depend on extcon framework to get the
USB cable state (USB or USB-Host) to put the controller in the right mode.

There were earlier attempts [1] to get this working by trying to patch up
the existing GPIO extcon driver.

This series attemts to take a different approach by introducing a new
USB specific extcon driver to handle the USB ID GPIO pin and
interpret a right USB cable state.

The reasoning to introduce this new driver is:
1) The existing GPIO extcon driver doesn't understand USB cable states
and it can't handle more than one cable per instance.
   
For the USB case we need to handle at least 2 cable states.
    a) USB (attach/detach)
    b) USB-Host (attach/detach)
and could possible include more states like
    c) Fast-charger (attach/detach)
    d) Slow-charger (attach/detach)
    
2) This USB specific driver can be easily updated in the future to
handle VBUS events, or charger detect events, in case it happens
to be available on GPIO for any platform.

3) The DT implementation is very easy. You just need one extcon node per USB
instead of one extcon node per cable state as in case of [1].

4) The cable state string doesn't need to be encoded in the device tree
as in case of [1].

5) With only ID event available, you can simulate a USB-peripheral attach
when USB-Host is detacted instead of hacking the USB driver to do the same.

Tested on DRA7-evm, DRA72-evm and AM57xx-beagle-x15

Changelog:
v2
- Addressed review comments.
- Fixed auto load of extcon-usb-gpio driver when used as module.
- Fixed up AM57xx USB.

--
cheers,
-roger
[1] - https://lkml.org/lkml/2014/11/3/513

Roger Quadros (7):
  extcon: usb-gpio: Introduce gpio usb extcon driver
  usb: extcon: Fix USB-Host cable name
  ARM: dts: dra7-evm: Add extcon nodes for USB
  ARM: dts: dra72-evm: Add extcon nodes for USB
  ARM: dts: am57xx-beagle-x15: Add extcon nodes for USB
  ARM: dts: am57xx-beagle-x15: Fix USB2 mode
  ARM: omap2plus_defconfig: Enable EXTCON_GPIO_USB

 .../devicetree/bindings/extcon/extcon-usb-gpio.txt |  20 ++
 arch/arm/boot/dts/am57xx-beagle-x15.dts            |  37 ++++
 arch/arm/boot/dts/dra7-evm.dts                     |  31 +++
 arch/arm/boot/dts/dra72-evm.dts                    |  31 +++
 arch/arm/configs/omap2plus_defconfig               |   1 +
 drivers/extcon/Kconfig                             |   7 +
 drivers/extcon/Makefile                            |   1 +
 drivers/extcon/extcon-palmas.c                     |  18 +-
 drivers/extcon/extcon-usb-gpio.c                   | 214 +++++++++++++++++++++
 drivers/usb/dwc3/dwc3-omap.c                       |   6 +-
 drivers/usb/phy/phy-omap-otg.c                     |   4 +-
 drivers/usb/phy/phy-tahvo.c                        |   8 +-
 12 files changed, 360 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-usb-gpio.txt
 create mode 100644 drivers/extcon/extcon-usb-gpio.c

-- 
2.1.0

