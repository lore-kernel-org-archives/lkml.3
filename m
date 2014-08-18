Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbaHRRIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 13:08:32 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:38028 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaHRRI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 13:08:29 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
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
        linux-usb@vger.kernel.org, Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH v2 0/9] Tegra xHCI support
Date: Mon, 18 Aug 2014 10:08:16 -0700
Message-Id: <1408381705-3623-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for xHCI on NVIDIA Tegra SoCs.  This includes:
 - adding a driver for the mailbox used to communicate with the xHCI
   controller's firmware,
 - extending the XUSB pad controller driver to support the USB PHY
   types (UTMI, HSIC, and USB3), and
 - adding a xHCI host-controller driver.

Based on 3.17-rc1, Jassi Brar's common mailbox framework [0], and my
xHCI modules series [1].

Tested on Venice2, Jetson TK1, and Big with a variety of USB2.0 and
USB3.0 memory sticks and ethernet dongles using controller firmware from
the ChromiumOS tree [2].  I've asked NVIDIA to submit firmware to the
linux-firmware package.

Notes:
 - HSIC support is mostly untested and I think there are still some issues
   to work out there.  I do have a Tegra124 board with a HSIC hub so I'll
   try to sort those out later.
 - The XUSB padctl driver doesn't play nice with the existing Tegra USB2.0
   PHY driver, so all ports should be assigned to the XHCI controller.

Based on work by:
  a lot of people, but from what I can tell from the L4T tree [3], the
  original authors of the Tegra xHCI driver are:
    Ajay Gupta <ajayg@nvidia.com>
    Bharath Yadav <byadav@nvidia.com>

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

[0] https://lkml.org/lkml/2014/8/1/200
[1] https://lkml.org/lkml/2014/8/18/504
[2] http://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/xhci-firmware-2014.05.09.00.00.tbz2
[3] git://nv-tegra.nvidia.com/linux-3.10.git

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

 .../bindings/mailbox/nvidia,tegra124-xusb-mbox.txt |   30 +
 .../pinctrl/nvidia,tegra124-xusb-padctl.txt        |   52 +-
 .../bindings/usb/nvidia,tegra124-xhci.txt          |  101 ++
 arch/arm/boot/dts/tegra124-jetson-tk1.dts          |   48 +-
 arch/arm/boot/dts/tegra124-venice2.dts             |   79 +-
 arch/arm/boot/dts/tegra124.dtsi                    |   40 +
 drivers/mailbox/Kconfig                            |    3 +
 drivers/mailbox/Makefile                           |    2 +
 drivers/mailbox/tegra-xusb-mailbox.c               |  279 +++++
 drivers/pinctrl/Kconfig                            |    1 +
 drivers/pinctrl/pinctrl-tegra-xusb.c               | 1170 +++++++++++++++++++-
 drivers/usb/host/Kconfig                           |    9 +
 drivers/usb/host/Makefile                          |    1 +
 drivers/usb/host/xhci-tegra.c                      |  893 +++++++++++++++
 include/dt-bindings/mailbox/tegra-xusb-mailbox.h   |    7 +
 include/dt-bindings/pinctrl/pinctrl-tegra-xusb.h   |   20 +
 include/soc/tegra/xusb.h                           |   52 +
 17 files changed, 2706 insertions(+), 81 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mailbox/nvidia,tegra124-xusb-mbox.txt
 create mode 100644 Documentation/devicetree/bindings/usb/nvidia,tegra124-xhci.txt
 create mode 100644 drivers/mailbox/tegra-xusb-mailbox.c
 create mode 100644 drivers/usb/host/xhci-tegra.c
 create mode 100644 include/dt-bindings/mailbox/tegra-xusb-mailbox.h
 create mode 100644 include/soc/tegra/xusb.h

-- 
2.1.0.rc2.206.gedb03e5

