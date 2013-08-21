Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab3HUFrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 01:47:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46913 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab3HUFrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 01:47:17 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kyungmin.park@samsung.com>, <balbi@ti.com>,
        <kishon@ti.com>, <jg1.han@samsung.com>, <s.nawrocki@samsung.com>,
        <kgene.kim@samsung.com>, <stern@rowland.harvard.edu>,
        <broonie@kernel.org>, <tomasz.figa@gmail.com>, <arnd@arndb.de>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <swarren@nvidia.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <akpm@linux-foundation.org>,
        <balajitk@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <linux@arm.linux.org.uk>
Subject: [PATCH v11 0/8] PHY framework
Date: Wed, 21 Aug 2013 11:16:05 +0530
Message-ID: <1377063973-22044-1-git-send-email-kishon@ti.com>
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

You can find this patch series @
git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git testing

I'll create a new branch *next* once this patch series is finalized. All the
PHY driver development that depends on PHY framework can be based on this
branch.

Did USB enumeration testing in panda and beagle after applying [1]

[1] -> https://lkml.org/lkml/2013/7/26/88

Changes from v10:
* fixed a mistake in devm_of_phy_provider_register macro which was carried over from earlier version.
* used ida_simple_get for obtaining the id.

Changes from v9:
* Fixed Greg's concern on having *find PHY by string* and changed it to Tomasz
  pseudo code.
* move omap-usb2 phy and twl4030-usb phy to drivers/phy
* made all the dependent drivers select GENERIC_PHY instead of having depends
  on
* Made PHY core to assign the id's (so changed the phy_create API).
* Adapted twl4030-usb to the new design.

Changes from v8:
* Added phy_set_drvdata and phy_get_drvdata in phy.h.
* Changed phy_create API not to take void *priv. private data should now be set
  using phy_set_drvdata now.
Changes from v7:
* Fixed Documentation
* Added to_phy, of_phy_provider_register and devm_of_phy_provider_register
* modified runtime_pm usage in phy_init, phy_exit, phy_power_on and
  phy_power_off. Now phy_power_on will enable the clocks and phy_power_off will
  disable the clocks.
* pm_runtime_no_callbacks() is added so that pm_runtime_get_sync doesn't fail
* modified other patches to adhere to the changes in the PHY framework
* removed usb: phy: twl4030: twl4030 shouldn't be subsys_initcall as it will
  be merged separately.
* reference counting has been added to protect phy ops when the PHY is shared
  by multiple consumers.

Changes from v6
* corrected few typos in Documentation
* Changed PHY Subsystem to *bool* in Kconfig (to avoid compilation errors when
  PHY Subsystem is kept as module and the dependent modules are built-in)
* Added if pm_runtime_enabled check before runtime pm calls.

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

Kishon Vijay Abraham I (8):
  drivers: phy: add generic PHY framework
  usb: phy: omap-usb2: use the new generic PHY framework
  usb: phy: twl4030: use the new generic PHY framework
  arm: omap3: twl: add phy consumer data in twl4030_usb_data
  ARM: dts: omap: update usb_otg_hs data
  usb: musb: omap2430: use the new generic PHY framework
  usb: phy: omap-usb2: remove *set_suspend* callback from omap-usb2
  usb: phy: twl4030-usb: remove *set_suspend* and *phy_init* ops

 .../devicetree/bindings/phy/phy-bindings.txt       |   66 ++
 Documentation/devicetree/bindings/usb/omap-usb.txt |    5 +
 Documentation/devicetree/bindings/usb/usb-phy.txt  |    6 +
 Documentation/phy.txt                              |  166 +++++
 MAINTAINERS                                        |    8 +
 arch/arm/boot/dts/omap3-beagle-xm.dts              |    2 +
 arch/arm/boot/dts/omap3-evm.dts                    |    2 +
 arch/arm/boot/dts/omap3-overo.dtsi                 |    2 +
 arch/arm/boot/dts/omap4.dtsi                       |    3 +
 arch/arm/boot/dts/twl4030.dtsi                     |    1 +
 arch/arm/mach-omap2/twl-common.c                   |   11 +
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    2 +
 drivers/phy/Kconfig                                |   41 ++
 drivers/phy/Makefile                               |    7 +
 drivers/phy/phy-core.c                             |  698 ++++++++++++++++++++
 drivers/{usb => }/phy/phy-omap-usb2.c              |   60 +-
 drivers/{usb => }/phy/phy-twl4030-usb.c            |   69 +-
 drivers/usb/musb/Kconfig                           |    1 +
 drivers/usb/musb/musb_core.h                       |    2 +
 drivers/usb/musb/omap2430.c                        |   26 +-
 drivers/usb/phy/Kconfig                            |   19 -
 drivers/usb/phy/Makefile                           |    2 -
 include/linux/i2c/twl.h                            |    2 +
 include/linux/phy/phy.h                            |  270 ++++++++
 25 files changed, 1397 insertions(+), 76 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/phy-bindings.txt
 create mode 100644 Documentation/phy.txt
 create mode 100644 drivers/phy/Kconfig
 create mode 100644 drivers/phy/Makefile
 create mode 100644 drivers/phy/phy-core.c
 rename drivers/{usb => }/phy/phy-omap-usb2.c (88%)
 rename drivers/{usb => }/phy/phy-twl4030-usb.c (94%)
 create mode 100644 include/linux/phy/phy.h

-- 
1.7.10.4

