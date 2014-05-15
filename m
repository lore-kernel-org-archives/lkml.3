Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaEOKSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 06:18:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54424 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753824AbaEOKSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 06:18:09 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v6 00/17] USB support for Armada 38x and Armada 375
Date: Thu, 15 May 2014 12:17:25 +0200
Message-Id: <1400149062-32661-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch set adds the USB support for the Armada 38x and Armada 375
SOCs. These SoCs use an xHCI but still need specific initialization,
mainly to setup the MBus memory windows. They also have another USB
controller for EHCI, identical to the one used on other mvebu SOCs.

This series is also available in
the branch USB-375-38x-3.15-rc1-V6
https://github.com/MISL-EBU-System-SW/mainline-public.git

Unless the DT maintainers were opposed to it, patches 1 to 9 can now
go to the USB subsystem and 10 to 19 to the arm-soc subsystem through
the mvebu.

Thanks,

Gregory

Changes between v5 and v6:

 * Added Acked-by from Alan Stern on patch 5.

 * Added Acked-by from Mathias Nyman on patches 6 to 9.

 * Added Acked-by from Felipe Balbi on patch 7.

 * Removed the patches introducing the usb-cluster support using the
   phy framework waiting for a cleaner implementation of it.

Changes between v4 and v5:

 * Fixed a compile time problem when CONFIG_USB_XHCI_MVEBU was
   disabled. Noticed by Shimoda, Yoshihiro
   <yoshihiro.shimoda.uh@renesas.com>.

 * Added Acked-by from Alan Stern on patches 1 to 4.

Changes between v3 and v4:

 * Additional patch that removes the use of of_irq_parse_and_map() in
   ehci-orion, and just uses platform_get_irq() instead, to avoid a
   different case between DT and non-T.

 * Additional patch that renames the ehci-orion error handling goto
   labels to have more meaningful names, in preparation for handling
   of additional error cases in followup patches.

 * Additional patch to update the ehci-orion Device Tree binding
   documentation.

 * Merge of 375/38x XHCI support patches: one patch for the driver,
   one patch for the Device Tree binding documentation (instead of one
   patch of these, for each SoC).

 * Update of the XHCI Device Tree binding documentation to indicate
   the new optional clocks property.

 * Update of armada-375.dtsi to add missing spaces in the phy-names
   definition.

 * Update of armada-38x.dtsi to use 0x4000 instead of 0x3fff for the
   register area length. Noticed by Andrew Lunn.

 * Changed the PHY driver Kconfig option to only be enabled either
   when MACH_ARMADA_375 or COMPILE_TEST are enabled. In the previous
   version, the PHY driver was always enabled, regardless of the
   platform.

 * Various improvements to the PHY driver:

    - Rename USB2_PHY_CONFIG_ENABLE to USB2_PHY_CONFIG_DISABLE, as
      suggested by Ezequiel Garcia.
    - Simplify the logic of armada375_usb_phy_init() by handling the
      !cluster_phy->enable case first.
    - Use devm_ioremap_resource() in the ->probe() function instead of
      of_iomap().
    - Bail out from ->probe() when a PHY cannot be created.
    - Fix typos in comments.

 * Reworded the Kconfig prompt and help text of XHCI_MVEBU to indicate
   that it's for both 375 and 38x (it was only indicating 38x until
   now).

 * Changed the Makefile bit of the xhci-mvebu driver according to the
   suggestion of Felipe Balbi, so that things work properly when
   CONFIG_USB_XHCI_MVEBU is 'm'.

 * Various improvements in the ehci-orion driver:

    - Use better goto labels for error handling in ->probe().
    - Use devm_phy_optional_get() instead of devm_phy_get(), which
      allows to handle EPROBE_DEFER cases nicely.
    - Call phy_power_off() when needed (probe error handling, and
      remove).
    - Use __initconst instead of __initdata for override structure, as
      noticed by checkpatch.
    - Fix use after free errors noticed by Felipe Balbi.

 * Various improvements to the XHCI driver:

    - Don't make xhci_mvebu_mbus_config() an __init function, since
      it's called from probe(), which isn't in __init.
    - Don't use the buggy 'priv[0]' solution implemented in the
      previous version of the patch set (see in
      http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/253871.html
      the details of why it doesn't work). Instead, add a 'struct
      clk*' field in xhci_hcd to support the clock in xhci-plat,
      exactly like xhci_hcd has msix_count and msix_entries for
      xhci-pci.
    - Misc minor code style improvements.

Gregory CLEMENT (14):
  usb: ehci-orion: fix clock reference leaking
  usb: ehci-orion: add optional PHY support
  usb: host: xhci-plat: sort the headers in alphabetic order
  usb: host: xhci-plat: add clock support
  usb: host: xhci-plat: add support for the Armada 375/38x XHCI
    controllers
  Documentation: dt-bindings: update xhci-platform DT binding
  ARM: mvebu: add USB3 support for Armada 38x
  ARM: mvebu: add USB3 support for Armada 375
  ARM: configs: enable XHCI mvebu support in mvebu_v7_defconfig
  ARM: configs: enable XHCI mvebu support in multi_v7_defconfig
  ARM: mvebu: add Device Tree description of xHCI controllers on Armada
    38x
  ARM: mvebu: add Device Tree description of the EHCI controller on
    Armada 38x
  ARM: mvebu: add Device Tree description of the xHCI controller on
    Armada 375
  ARM: mvebu: add Device Tree description of the EHCI controller on
    Armada 375

Thomas Petazzoni (3):
  usb: ehci-orion: use platform_get_irq() for DT probing
  usb: ehci-orion: rename error goto labels in ehci_orion_drv_probe()
  Documentation: dt-bindings: update ehci-orion binding documentation

 .../devicetree/bindings/usb/ehci-orion.txt         |  5 ++
 Documentation/devicetree/bindings/usb/usb-xhci.txt |  7 +-
 arch/arm/boot/dts/armada-375-db.dts                |  8 ++
 arch/arm/boot/dts/armada-375.dtsi                  | 24 ++++++
 arch/arm/boot/dts/armada-385-db.dts                | 12 +++
 arch/arm/boot/dts/armada-385-rd.dts                |  4 +
 arch/arm/boot/dts/armada-38x.dtsi                  | 25 ++++++
 arch/arm/configs/multi_v7_defconfig                |  1 +
 arch/arm/configs/mvebu_v7_defconfig                |  1 +
 arch/arm/mach-mvebu/Kconfig                        |  2 +
 drivers/usb/host/Kconfig                           |  8 ++
 drivers/usb/host/Makefile                          |  3 +
 drivers/usb/host/ehci-orion.c                      | 92 +++++++++++++++-------
 drivers/usb/host/xhci-mvebu.c                      | 72 +++++++++++++++++
 drivers/usb/host/xhci-mvebu.h                      | 21 +++++
 drivers/usb/host/xhci-plat.c                       | 42 +++++++++-
 drivers/usb/host/xhci.h                            |  2 +
 17 files changed, 297 insertions(+), 32 deletions(-)
 create mode 100644 drivers/usb/host/xhci-mvebu.c
 create mode 100644 drivers/usb/host/xhci-mvebu.h

-- 
1.8.1.2

