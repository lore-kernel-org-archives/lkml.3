Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab3DCMzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:55:01 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35753 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761976Ab3DCMyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:54:54 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <akpm@linux-foundation.org>, <swarren@wwwdotorg.org>,
        <sylvester.nawrocki@gmail.com>, <rob@landley.net>
CC: <netdev@vger.kernel.org>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tony@atomide.com>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <b-cousson@ti.com>, <linux@arm.linux.org.uk>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <kishon@ti.com>, <mchehab@redhat.com>,
        <santosh.shilimkar@ti.com>, <broonie@opensource.wolfsonmicro.com>,
        <swarren@nvidia.com>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v5 0/6] Generic PHY Framework
Date: Wed, 3 Apr 2013 18:23:48 +0530
Message-ID: <1364993634-6378-1-git-send-email-kishon@ti.com>
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

This patch series is developed on linus tree HEAD. Once the patch series gets
finalised I'll resend omap-usb2 and twl4030 part based on Felipe's tree.

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

Kishon Vijay Abraham I (6):
  drivers: phy: add generic PHY framework
  usb: phy: omap-usb2: use the new generic PHY framework
  usb: otg: twl4030: use the new generic PHY framework
  ARM: OMAP: USB: Add phy binding information
  ARM: dts: omap: update usb_otg_hs data
  usb: musb: omap2430: use the new generic PHY framework

 Documentation/ABI/testing/sysfs-class-phy          |   15 +
 .../devicetree/bindings/phy/phy-bindings.txt       |   67 +++
 Documentation/devicetree/bindings/usb/omap-usb.txt |    5 +
 Documentation/devicetree/bindings/usb/usb-phy.txt  |    6 +
 Documentation/phy.txt                              |  113 ++++
 MAINTAINERS                                        |    7 +
 arch/arm/boot/dts/omap3.dtsi                       |    2 +
 arch/arm/boot/dts/omap4.dtsi                       |    3 +
 arch/arm/boot/dts/twl4030.dtsi                     |    1 +
 arch/arm/mach-omap2/usb-musb.c                     |    7 +-
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    2 +
 drivers/phy/Kconfig                                |   13 +
 drivers/phy/Makefile                               |    5 +
 drivers/phy/phy-core.c                             |  616 ++++++++++++++++++++
 drivers/usb/musb/musb_core.h                       |    2 +
 drivers/usb/musb/omap2430.c                        |   22 +-
 drivers/usb/otg/twl4030-usb.c                      |   37 ++
 drivers/usb/phy/omap-usb2.c                        |   48 ++
 include/linux/phy/phy.h                            |  228 ++++++++
 20 files changed, 1194 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-phy
 create mode 100644 Documentation/devicetree/bindings/phy/phy-bindings.txt
 create mode 100644 Documentation/phy.txt
 create mode 100644 drivers/phy/Kconfig
 create mode 100644 drivers/phy/Makefile
 create mode 100644 drivers/phy/phy-core.c
 create mode 100644 include/linux/phy/phy.h

-- 
1.7.10.4

