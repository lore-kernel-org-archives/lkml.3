Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934041AbaFRGVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 02:21:42 -0400
Received: from mail-ve0-f201.google.com ([209.85.128.201]:43044 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933819AbaFRGVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 02:21:40 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH v1 0/9] Tegra XHCI support
Date: Tue, 17 Jun 2014 23:16:11 -0700
Message-Id: <1403072180-4944-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for XHCI on NVIDIA Tegra SoCs.  This includes:
 - extending the XUSB pad controller driver to support the USB PHY
   types (UTMI, HSIC, and USB3),
 - adding a driver for the mailbox used to communicate with the XHCI
   controller's firmware, and
 - adding a XHCI host-controller driver.

Based on Stephen Warren's for-next branch plus Thierry Reding's XUSB
pad controller driver [1].

Tested on Venice2 and Jetson TK1 with a variety of USB2.0 and USB3.0 memory
sticks and ethernet dongles using controller firmware from the ChromiumOS
tree [2].

Notes:
 - HSIC support is mostly untested and I think there are still some issues
   to work out there.  I do have a Tegra124 board with a HSIC hub so I'll
   try to sort those out later.
 - The XUSB padctl driver doesn't play nice with the existing Tegra USB2.0
   PHY driver, so all ports should be assigned to the XHCI controller.

Based on work by:
  a lot of people, but from what I can tell from the L4T tree [3], the
  original authors of the Tegra XHCI driver are:
    Ajay Gupta <ajayg@nvidia.com>
    Bharath Yadav <byadav@nvidia.com>

Changes from RFC:
 - Dropped Tegra114 support.
 - Split out mailbox into separate driver.
 - Stopped using child xhci-plat device in XHCI host-controller driver.
 - Added PHY support to Thierry's XUSB padctl driver instead of in a separate
   USB PHY driver.
 - Added Jetson TK1 support.
 - Misc. cleanups.

[1] http://patchwork.ozlabs.org/patch/360458/
[2] http://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/xhci-firmware-2014.05.09.00.00.tbz2
[3] git://nv-tegra.nvidia.com/linux-3.10.git

Andrew Bresticker (9):
  of: Add NVIDIA Tegra XUSB mailbox binding
  mailbox: Add NVIDIA Tegra XUSB mailbox driver
  of: Update Tegra XUSB pad controller binding for USB
  pinctrl: tegra-xusb: Add USB PHY support
  of: Add NVIDIA Tegra XHCI controller binding
  usb: xhci: Add NVIDIA Tegra XHCI host-controller driver
  ARM: tegra: Add Tegra124 XUSB mailbox and XHCI controller
  ARM: tegra: jetson-tk1: Add XHCI support
  ARM: tegra: venice2: Add XHCI support

 .../bindings/mailbox/nvidia,tegra124-xusb-mbox.txt |   25 +
 .../pinctrl/nvidia,tegra124-xusb-padctl.txt        |   53 +-
 .../bindings/usb/nvidia,tegra124-xhci.txt          |   76 ++
 arch/arm/boot/dts/tegra124-jetson-tk1.dts          |   43 +-
 arch/arm/boot/dts/tegra124-venice2.dts             |   72 +-
 arch/arm/boot/dts/tegra124.dtsi                    |   31 +
 drivers/mailbox/Kconfig                            |    7 +
 drivers/mailbox/Makefile                           |    2 +
 drivers/mailbox/tegra-xusb-mbox.c                  |  308 ++++++
 drivers/pinctrl/pinctrl-tegra-xusb.c               | 1106 +++++++++++++++++++-
 drivers/usb/host/Kconfig                           |   12 +
 drivers/usb/host/Makefile                          |    2 +
 drivers/usb/host/xhci-tegra.c                      |  900 ++++++++++++++++
 include/dt-bindings/pinctrl/pinctrl-tegra-xusb.h   |    7 +
 include/linux/tegra-xusb-mbox.h                    |   98 ++
 15 files changed, 2673 insertions(+), 69 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mailbox/nvidia,tegra124-xusb-mbox.txt
 create mode 100644 Documentation/devicetree/bindings/usb/nvidia,tegra124-xhci.txt
 create mode 100644 drivers/mailbox/tegra-xusb-mbox.c
 create mode 100644 drivers/usb/host/xhci-tegra.c
 create mode 100644 include/linux/tegra-xusb-mbox.h

-- 
2.0.0.526.g5318336

