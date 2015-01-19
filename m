Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbbASRwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 12:52:44 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49003 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbbASRwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 12:52:42 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <tony@atomide.com>, <myungjoo.ham@samsung.com>,
        <cw00.choi@samsung.com>
CC: <george.cherian@ti.com>, <nsekhar@ti.com>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 0/5] extcon: usb: Introduce USB GPIO extcon driver. Fix DRA7 USB.
Date: Mon, 19 Jan 2015 19:52:17 +0200
Message-ID: <1421689942-10201-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On DRA7 EVMs the USB ID pin is connected to a GPIO line. The USB drivers
(dwc3 + dwc3-omap) depend on extcon framework to get the USB cable state
(USB or USB-Host) to put the controller in the right mode.

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

Tested on DRA7-evm and DRA72-evm.

cheers,
-roger
[1] - https://lkml.org/lkml/2014/11/3/513

Roger Quadros (5):
  extcon: gpio-usb: Introduce gpio usb extcon driver
  usb: extcon: Fix USB-Host cable name
  ARM: dts: dra7-evm: Add extcon nodes for USB
  ARM: dts: dra72-evm: Add extcon nodes for USB
  ARM: omap2plus_defconfig: Enable PCF857X and EXTCON_GPIO_USB

 .../devicetree/bindings/extcon/extcon-usb.txt      |  20 ++
 arch/arm/boot/dts/dra7-evm.dts                     |  31 +++
 arch/arm/boot/dts/dra72-evm.dts                    |  31 +++
 arch/arm/configs/omap2plus_defconfig               |   2 +
 drivers/extcon/Kconfig                             |   7 +
 drivers/extcon/Makefile                            |   1 +
 drivers/extcon/extcon-gpio-usb.c                   | 225 +++++++++++++++++++++
 drivers/extcon/extcon-palmas.c                     |  18 +-
 drivers/usb/dwc3/dwc3-omap.c                       |   6 +-
 drivers/usb/phy/phy-omap-otg.c                     |   4 +-
 drivers/usb/phy/phy-tahvo.c                        |   8 +-
 11 files changed, 335 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-usb.txt
 create mode 100644 drivers/extcon/extcon-gpio-usb.c

-- 
2.1.0

