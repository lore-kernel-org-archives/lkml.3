Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbaJ1WbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:31:25 -0400
Received: from mail-ie0-f201.google.com ([209.85.223.201]:33937 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240AbaJ1W2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:28:00 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org
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
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: [PATCH RESEND V4 0/9] Tegra xHCI support
Date: Tue, 28 Oct 2014 15:27:47 -0700
Message-Id: <1414535277-15645-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for xHCI on NVIDIA Tegra SoCs.  This includes:
 - patches 1 and 2: adding a driver for the mailbox used to communicate
   with the xHCI controller's firmware,
 - patches 3 and 4: extending the XUSB pad controller driver to support
   the USB PHY types (UTMI, HSIC, and USB3),
 - patches 5 and 6: adding a xHCI host-controller driver, and
 - patches 7, 8, and 9: updating the relevant DT files.

The PHY and host drivers have compile-time dependencies on the mailbox
driver, and the host driver has compile-time dependencies on the PHY
driver.  It is probably best if these all get merged through the Tegra
tree.  This series still needs ACKs from the relevant maintainers for
the mailbox and xHCI host drivers and their device-tree bindings.

Tested on Venice2, Jetson TK1, and Big with a variety of USB2.0 and
USB3.0 memory sticks and ethernet dongles using controller firmware
recently posted by Andrew Chew [0].

Based on v3.18-rc2.  All other dependencies (xHCI modules and mailbox
series) have been merged.

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

Changes from RFC:
 - Dropped Tegra114 support.
 - Split out mailbox into separate driver.
 - Stopped using child xhci-plat device in xHCI host-controller driver.
 - Added PHY support to Thierry's XUSB padctl driver instead of in a separate
   USB PHY driver.
 - Added Jetson TK1 support.
 - Misc. cleanups.

[0] https://patchwork.ozlabs.org/patch/400110/
[1] git://nv-tegra.nvidia.com/linux-3.10.git

Andrew Bresticker (9):
  of: Add NVIDIA Tegra XUSB mailbox binding
  mailbox: Add NVIDIA Tegra XUSB mailbox driver
  of: Update Tegra XUSB pad controller binding for USB
  pinctrl: tegra-xusb: Add USB PHY support
  of: Add NVIDIA Tegra xHCI controller binding
  usb: xhci: Add NVIDIA Tegra xHCI host-controller driver
  ARM: tegra: Add Tegra124 XUSB mailbox and xHCI controller
  ARM: tegra: jetson-tk1: Add xHCI support
  ARM: tegra: venice2: Add xHCI support

 .../bindings/mailbox/nvidia,tegra124-xusb-mbox.txt |   32 +
 .../pinctrl/nvidia,tegra124-xusb-padctl.txt        |   56 +-
 .../bindings/usb/nvidia,tegra124-xhci.txt          |  104 ++
 arch/arm/boot/dts/tegra124-jetson-tk1.dts          |   46 +-
 arch/arm/boot/dts/tegra124-venice2.dts             |   79 +-
 arch/arm/boot/dts/tegra124.dtsi                    |   41 +
 drivers/mailbox/Kconfig                            |    3 +
 drivers/mailbox/Makefile                           |    2 +
 drivers/mailbox/tegra-xusb-mailbox.c               |  290 +++++
 drivers/pinctrl/Kconfig                            |    1 +
 drivers/pinctrl/pinctrl-tegra-xusb.c               | 1233 +++++++++++++++++++-
 drivers/usb/host/Kconfig                           |    9 +
 drivers/usb/host/Makefile                          |    1 +
 drivers/usb/host/xhci-tegra.c                      |  907 ++++++++++++++
 include/dt-bindings/pinctrl/pinctrl-tegra-xusb.h   |   20 +
 include/soc/tegra/xusb.h                           |   53 +
 16 files changed, 2797 insertions(+), 80 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mailbox/nvidia,tegra124-xusb-mbox.txt
 create mode 100644 Documentation/devicetree/bindings/usb/nvidia,tegra124-xhci.txt
 create mode 100644 drivers/mailbox/tegra-xusb-mailbox.c
 create mode 100644 drivers/usb/host/xhci-tegra.c
 create mode 100644 include/soc/tegra/xusb.h

-- 
2.1.0.rc2.206.gedb03e5

