Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaKQWo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 17:44:57 -0500
Received: from mail-vc0-f202.google.com ([209.85.220.202]:33610 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbaKQWlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 17:41:47 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, linux-tegra@vger.kernel.org
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: [PATCH V5 00/12] Tegra xHCI support
Date: Mon, 17 Nov 2014 14:41:30 -0800
Message-Id: <1416264102-1323-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for xHCI on NVIDIA Tegra SoCs.  This includes:
 - patches 1, 2, and 3: minor cleanups for mailbox framework and xHCI,
 - patches 4 and 5: adding a driver for the mailbox used to communicate
   with the xHCI controller's firmware,
 - patches 6 and 7: extending the XUSB pad controller driver to support
   the USB PHY types (UTMI, HSIC, and USB3),
 - patches 8 and 9: adding a xHCI host-controller driver, and
 - patches 10, 11, and 12: updating the relevant DT files.

The mailbox driver (patch 5) has a compile-time dependency on patch 2 and
a run-time dependency on patch 3.  Both the PHY (patch 7) and host (patch 9)
drivers have compile-time dependencies on the mailbox driver.  The host
driver also has a run-time dependency on patch 1.  Because of this, this
entire series should probably go through the Tegra tree.  Patches 11 and 12
should probably not be merged until the controller firmware [0] lands in
linux-firmware since they disable the EHCI controllers.

Tested on Venice2, Jetson TK1, and Big with a variety of USB2.0 and
USB3.0 memory sticks and ethernet dongles.  This has also been tested,
with additional out-of-tree patches, on a Tegra132-based board.

Based on v3.18-rc5.  A branch with the entire series is available at:
  https://github.com/abrestic/linux/commits/tegra-xhci-v5

Notes:
 - HSIC support is mostly untested and I think there are still some issues
   to work out there.  I do have a Tegra124 board with a HSIC hub so I'll
   try to sort those out later.
 - The XUSB padctl driver doesn't play nice with the existing Tegra USB2.0
   PHY driver, so all ports should be assigned to the XHCI controller.

Based on work by:
  a lot of people, but from what I can tell from the L4T tree [1], the
  original authors of the Tegra xHCI driver are:
    Ajay Gupta <ajayg@nvidia.com>
    Bharath Yadav <byadav@nvidia.com>

Changes from v4:
 - Made USB support optional in padctl driver.
 - Made usb3-port a pinconfig property again.
 - Cleaned up mbox_request_channel() error handling and allowed it to defer
   probing (patch 3).
 - Minor xHCI (patch 1) and mailbox framework (patch 2) cleanups suggested
   by Thierry.
 - Addressed Thierry's review comments.

Changes from v3:
 - Fixed USB2.0 flakiness on Jetson-TK1.
 - Switched to 32-bit DMA mask for host.
 - Addressed Stephen's review comments.

Chagnes from v2:
 - Dropped mailbox channel specifier.  The mailbox driver allocates virtual
   channels backed by the single physical channel.
 - Added support for HS_CURR_LEVEL adjustment pinconfig property, which
   will be required for the Blaze board.
 - Addressed Stephen's review comments.

Changes from v1:
 - Converted mailbox driver to use the common mailbox framework.
 - Fixed up host driver so that it can now be built and used as a module.
 - Addressed Stephen's review comments.
 - Misc. cleanups.

Andrew Bresticker (11):
  xhci: Set shared HCD's hcd_priv in xhci_gen_setup
  mailbox: Make struct mbox_controller's ops field const
  of: Add NVIDIA Tegra XUSB mailbox binding
  mailbox: Add NVIDIA Tegra XUSB mailbox driver
  of: Update Tegra XUSB pad controller binding for USB
  pinctrl: tegra-xusb: Add USB PHY support
  of: Add NVIDIA Tegra xHCI controller binding
  usb: xhci: Add NVIDIA Tegra xHCI host-controller driver
  ARM: tegra: Add Tegra124 XUSB mailbox and xHCI controller
  ARM: tegra: jetson-tk1: Add xHCI support
  ARM: tegra: venice2: Add xHCI support

Benson Leung (1):
  mailbox: Fix up error handling in mbox_request_channel()

 .../bindings/mailbox/nvidia,tegra124-xusb-mbox.txt |   32 +
 .../pinctrl/nvidia,tegra124-xusb-padctl.txt        |   63 +-
 .../bindings/usb/nvidia,tegra124-xhci.txt          |  104 ++
 arch/arm/boot/dts/tegra124-jetson-tk1.dts          |   46 +-
 arch/arm/boot/dts/tegra124-venice2.dts             |   79 +-
 arch/arm/boot/dts/tegra124.dtsi                    |   41 +
 drivers/mailbox/Kconfig                            |    3 +
 drivers/mailbox/Makefile                           |    2 +
 drivers/mailbox/mailbox.c                          |   11 +-
 drivers/mailbox/tegra-xusb-mailbox.c               |  280 +++++
 drivers/pinctrl/Kconfig                            |    1 +
 drivers/pinctrl/pinctrl-tegra-xusb.c               | 1262 +++++++++++++++++++-
 drivers/usb/host/Kconfig                           |    9 +
 drivers/usb/host/Makefile                          |    1 +
 drivers/usb/host/xhci-pci.c                        |    5 -
 drivers/usb/host/xhci-plat.c                       |    5 -
 drivers/usb/host/xhci-tegra.c                      |  930 +++++++++++++++
 drivers/usb/host/xhci.c                            |    6 +-
 include/dt-bindings/pinctrl/pinctrl-tegra-xusb.h   |    7 +
 include/linux/mailbox_controller.h                 |    2 +-
 include/soc/tegra/xusb.h                           |   50 +
 21 files changed, 2852 insertions(+), 87 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mailbox/nvidia,tegra124-xusb-mbox.txt
 create mode 100644 Documentation/devicetree/bindings/usb/nvidia,tegra124-xhci.txt
 create mode 100644 drivers/mailbox/tegra-xusb-mailbox.c
 create mode 100644 drivers/usb/host/xhci-tegra.c
 create mode 100644 include/soc/tegra/xusb.h

-- 
2.1.0.rc2.206.gedb03e5

