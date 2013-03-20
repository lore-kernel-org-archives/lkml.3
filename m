Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684Ab3CTJOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:14:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59802 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab3CTJNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:13:01 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <akpm@linux-foundation.org>, <rob@landley.net>
CC: <davem@davemloft.net>, <cesarb@cesarb.net>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <kishon@ti.com>, <mchehab@redhat.com>, <santosh.shilimkar@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <swarren@nvidia.com>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3 0/6] Generic PHY Framework
Date: Wed, 20 Mar 2013 14:41:59 +0530
Message-ID: <1363770725-13717-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a generic PHY framework that provides a set of APIs for the PHY drivers
to create/destroy a PHY and APIs for the PHY users to obtain a reference to
the PHY with or without using phandle. To obtain a reference to the PHY
without using phandle, the platform specfic intialization code (say from board
file) should have already called phy_bind with the binding information. The
binding information consists of phy's device name, phy user device name and an
index. The index is used when the same phy user binds to mulitple phys.

This framework will be of use only to devices that uses external PHY (PHY
functionality is not embedded within the controller).

The intention of creating this framework is to bring the phy drivers spread
all over the Linux kernel to drivers/phy to increase code re-use and to
increase code maintainability.

Comments to make PHY as bus wasn't done because PHY devices can be part of
other bus and making a same device attached to multiple bus leads to bad
design.

Making omap-usb2 and twl4030 to use this framework is provided as a sample.

This patch series is developed on 3.9-rc3. Once the patch series gets finalised
I'll resend omap-usb2 and twl4030 part based on Felipe's tree.

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
Kishon Vijay Abraham I (6):
  drivers: phy: add generic PHY framework
  usb: phy: omap-usb2: use the new generic PHY framework
  usb: otg: twl4030: use the new generic PHY framework
  ARM: OMAP: USB: Add phy binding information
  ARM: dts: omap: update usb_otg_hs data
  usb: musb: omap2430: use the new generic PHY framework

 Documentation/ABI/testing/sysfs-class-phy          |   15 +
 Documentation/devicetree/bindings/usb/omap-usb.txt |    5 +
 Documentation/phy.txt                              |  108 ++++
 MAINTAINERS                                        |    7 +
 arch/arm/boot/dts/omap3.dtsi                       |    2 +
 arch/arm/boot/dts/omap4.dtsi                       |    2 +
 arch/arm/mach-omap2/board-2430sdp.c                |    2 +
 arch/arm/mach-omap2/board-3430sdp.c                |    2 +
 arch/arm/mach-omap2/board-4430sdp.c                |    2 +
 arch/arm/mach-omap2/board-cm-t35.c                 |    2 +
 arch/arm/mach-omap2/board-devkit8000.c             |    2 +
 arch/arm/mach-omap2/board-igep0020.c               |    2 +
 arch/arm/mach-omap2/board-ldp.c                    |    2 +
 arch/arm/mach-omap2/board-omap3beagle.c            |    2 +
 arch/arm/mach-omap2/board-omap3evm.c               |    2 +
 arch/arm/mach-omap2/board-omap3logic.c             |    2 +
 arch/arm/mach-omap2/board-omap3pandora.c           |    2 +
 arch/arm/mach-omap2/board-omap3stalker.c           |    2 +
 arch/arm/mach-omap2/board-omap3touchbook.c         |    2 +
 arch/arm/mach-omap2/board-omap4panda.c             |    2 +
 arch/arm/mach-omap2/board-overo.c                  |    2 +
 arch/arm/mach-omap2/board-rm680.c                  |    2 +
 arch/arm/mach-omap2/board-rx51.c                   |    2 +
 arch/arm/mach-omap2/board-zoom-peripherals.c       |    2 +
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    2 +
 drivers/phy/Kconfig                                |   13 +
 drivers/phy/Makefile                               |    5 +
 drivers/phy/phy-core.c                             |  574 ++++++++++++++++++++
 drivers/usb/musb/musb_core.h                       |    2 +
 drivers/usb/musb/omap2430.c                        |   22 +-
 drivers/usb/otg/twl4030-usb.c                      |   36 ++
 drivers/usb/phy/omap-usb2.c                        |   47 ++
 include/linux/phy/phy.h                            |  218 ++++++++
 34 files changed, 1090 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-phy
 create mode 100644 Documentation/phy.txt
 create mode 100644 drivers/phy/Kconfig
 create mode 100644 drivers/phy/Makefile
 create mode 100644 drivers/phy/phy-core.c
 create mode 100644 include/linux/phy/phy.h

-- 
1.7.10.4

