Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab3D2KFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 06:05:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36512 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757623Ab3D2KEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 06:04:35 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@linaro.org>, <tony@atomide.com>, <balbi@ti.com>,
        <kishon@ti.com>, <arnd@arndb.de>, <swarren@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <sylvester.nawrocki@gmail.com>
CC: <rob.herring@calxeda.com>, <rob@landley.net>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <benoit.cousson@linaro.org>, <mchehab@redhat.com>,
        <akpm@linux-foundation.org>, <cesarb@cesarb.net>,
        <davem@davemloft.net>, <rnayak@ti.com>, <shawn.guo@linaro.org>,
        <santosh.shilimkar@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <nsekhar@ti.com>
Subject: [PATCH v6 0/9] Generic PHY Framework
Date: Mon, 29 Apr 2013 15:33:23 +0530
Message-ID: <1367229812-30574-1-git-send-email-kishon@ti.com>
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

Making omap-usb2 and twl4030 to use this framework is provided as a sample.

This patch series is developed on linux-next tree.

Changes from v5:
* removed the new sysfs entries as it dint have any new information other than
  what is already there in /sys/devices/...
* removed a bunch of APIs added to get the PHY and now only phy_get and
  devm_phy_get are used.
* Added new APIs to register/unregister the PHY provider. This is needed for
  dt boot case.
* Enabled pm runtime and incorporated the comments given by Alan Stern in a
  different patch series by Gautam.
* Removed the *phy_bind* API. Now the phy binding information should be passed
  using the platform data to the controller devices.
* Fixed a few typos.

Changes from v4:
* removed of_phy_get_with_args/devm_of_phy_get_with_args. Now the *phy providers*
  should use their custom implementation of of_xlate or use of_phy_xlate to get
  *phy instance* from *phy providers*.
* Added of_phy_xlate to be used by *phy providers* if it provides only one PHY.
* changed phy_core from having subsys_initcall to module_init.
* other minor fixes.

Changes from v3:
* Changed the return value of PHY APIs to ENOSYS
* Added APIs of_phy_get_with_args/devm_of_phy_get_with_args to support getting
  PHYs if the same IP implements multiple PHYs.
* modified phy_bind API so that the binding information can now be _updated_.
  In effect of this removed the binding information added in board files and
  added only in usb-musb.c. If a particular board uses a different phy binding,
  it can update it in board file after usb_musb_init().
* Added Documentation/devicetree/bindings/phy/phy-bindings.txt for dt binding
  information.

Changes from v2:
* removed phy_descriptor structure completely so changed the APIs which were
  taking phy_descriptor as parameters
* Added 2 more APIs *of_phy_get_byname* and *devm_of_phy_get_byname* to be used
  by PHY user drivers which has *phy* and *phy-names* binding in the dt data
* Fixed a few typos
* Removed phy_list and we now use class_dev_iter_init, class_dev_iter_next and
  class_dev_iter_exit for traversing through the phy list. (Note we still need
  phy_bind list and phy_bind_mutex).
* Changed the sysfs entry name from *bind* to *phy_bind*.

Changes from v1:
* Added Documentation for the PHY framework
* Added few more APIs mostly w.r.t devres
* Modified omap-usb2 and twl4030 to make use of the new framework

Did USB enumeration testing in panda and beagle.

Kishon Vijay Abraham I (9):
  drivers: phy: add generic PHY framework
  usb: phy: omap-usb2: use the new generic PHY framework
  usb: phy: twl4030: use the new generic PHY framework
  usb: phy: twl4030: twl4030 shouldn't be subsys_initcall
  ARM: OMAP: USB: Add phy binding information
  ARM: dts: omap: update usb_otg_hs data
  usb: musb: omap2430: use the new generic PHY framework
  usb: phy: omap-usb2: remove *set_suspend* callback from omap-usb2
  usb: phy: twl4030-usb: remove *set_suspend* and *phy_init* ops

 .../devicetree/bindings/phy/phy-bindings.txt       |   66 +++
 Documentation/devicetree/bindings/usb/omap-usb.txt |    5 +
 Documentation/devicetree/bindings/usb/usb-phy.txt  |    6 +
 Documentation/phy.txt                              |  123 +++++
 MAINTAINERS                                        |    7 +
 arch/arm/boot/dts/omap3.dtsi                       |    2 +
 arch/arm/boot/dts/omap4.dtsi                       |    3 +
 arch/arm/boot/dts/twl4030.dtsi                     |    1 +
 arch/arm/mach-omap2/usb-musb.c                     |    6 +-
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    2 +
 drivers/phy/Kconfig                                |   13 +
 drivers/phy/Makefile                               |    5 +
 drivers/phy/phy-core.c                             |  539 ++++++++++++++++++++
 drivers/usb/musb/musb_core.c                       |    1 +
 drivers/usb/musb/musb_core.h                       |    3 +
 drivers/usb/musb/omap2430.c                        |   29 +-
 drivers/usb/phy/phy-omap-usb2.c                    |   50 +-
 drivers/usb/phy/phy-twl4030-usb.c                  |   69 +--
 include/linux/phy/phy.h                            |  248 +++++++++
 include/linux/usb/musb.h                           |    3 +
 21 files changed, 1122 insertions(+), 61 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/phy-bindings.txt
 create mode 100644 Documentation/phy.txt
 create mode 100644 drivers/phy/Kconfig
 create mode 100644 drivers/phy/Makefile
 create mode 100644 drivers/phy/phy-core.c
 create mode 100644 include/linux/phy/phy.h

-- 
1.7.10.4

