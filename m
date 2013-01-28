Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab3A1Laz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:30:55 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49589 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674Ab3A1Lau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:30:50 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <linux@arm.linux.org.uk>, <sameo@linux.intel.com>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 00/30] USB: omap-ehci: Move PHY management to PHY driver
Date: Mon, 28 Jan 2013 13:30:01 +0200
Message-ID: <1359372631-8180-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The OMAP's High Speed Host controller can interface to ULPI/UTMI
PHYs transparently i.e. whithout requiring the device drivers to
access the PHY. However, the OS must ensure that the PHY has the necessary
resources (power/clock/reset) enabled before it is used.

Till now, the omap-ehci driver was managing the power and reset of the PHY
whereas, clock enabling was left to the bootloader or board files.

In this patchset we make the NOP PHY driver (nop-usb-xceiv.c) handle
all the PHY resources that are available so that it can be used by
platforms like OMAP.

The board files add the PHY as a platform device and use usb_bind_phy()
(API introduced in [2]) to bind the PHY device to the controller's port.
The ehci-omap driver then uses usb_get_phy_dev() to get the PHY device
associated to the controller's port.

All this results in a much cleaner code and makes USB PHY resource management
work properly on OMAP.

NOTE: Tested on 4460ES-B1 Panda and BeagleBoard C4 only. Other boards are only
build tested.

Patches are based on Linux-3.8-rc5 and depend on

[1] [PATCH v9 00/20] OMAP USB Host cleanup
https://lkml.org/lkml/2013/1/23/155

[2] [PATCH v2 0/6] USB: Add support for multiple PHYs of same type
https://lkml.org/lkml/2013/1/24/876

v2:
- Added Alan's patch to split ehci-omap into separate driver
- Addressed Russell King's comments on usage of clk/regulator framework.
- Adapted all board using ehci-omap to using the PHY mechanism.

The following changes since commit e18d48b7f7e563664a41d4658b8cc15679ee4745:

  usb: otg: utils: add facilities in phy lib to support multiple PHYs of same type (2013-01-28 12:20:54 +0200)

  git://github.com/rogerq/linux.git linux-usbhost15

---
Alan Stern (1):
  USB: EHCI: split ehci-omap out to a separate driver

Roger Quadros (29):
  usb: phy: nop: use devm_kzalloc()
  usb: phy: nop: Manage PHY clock
  usb: phy: nop: Handle power supply regulator for the PHY
  usb: phy: nop: Handle RESET for the PHY
  usb: phy: nop: use new PHY API to register PHY
  mfd: omap-usb-host: update nports in platform_data
  mfd: omap-usb-host: Remove PHY reset handling code
  USB: ehci-omap: Use devm_request_and_ioremap()
  USB: ehci-omap: Use PHY APIs to get the PHY device and put it out of
    suspend
  usb: ehci-omap: Remove PHY reset handling code
  usb: ehci-omap: Remove PHY regulator handling code
  ARM: OMAP2+: omap4panda: Provide USB Host's PHY platform data
  ARM: OMAP2+: omap4panda: Adapt to ehci-omap changes
  ARM: OMAP3: Beagle: Adapt to ehci-omap changes
  ARM: OMAP3: 3430SDP: Adapt to ehci-omap changes
  ARM: OMAP3: 3630SDP: Adapt to ehci-omap changes
  ARM: OMAP: AM3517crane: Adapt to ehci-omap changes
  ARM: OMAP: AM3517evm: Adapt to ehci-omap changes
  ARM: OMAP3: cm-t35: Adapt to ehci-omap changes
  ARM: OMAP3: cm-t3517: Adapt to ehci-omap changes
  ARM: OMAP: devkit8000: Adapt to ehci-omap changes
  ARM: OMAP3: igep0020: Adapt to ehci-omap changes
  ARM: OMAP3: omap3evm: Adapt to ehci-omap changes
  ARM: OMAP3: omap3pandora: Adapt to ehci-omap changes
  ARM: OMAP3: omap3stalker: Adapt to ehci-omap changes
  ARM: OMAP3: omap3touchbook: Adapt to ehci-omap changes
  ARM: OMAP3: overo: Adapt to ehci-omap changes
  ARM: OMAP: zoom: Adapt to ehci-omap changes
  ARM: OMAP: USB: Remove unused fields from struct
    usbhs_omap_platform_data

 arch/arm/mach-omap2/board-3430sdp.c        |   99 +++++++++++-
 arch/arm/mach-omap2/board-3630sdp.c        |  100 +++++++++++-
 arch/arm/mach-omap2/board-am3517crane.c    |   95 ++++++++++--
 arch/arm/mach-omap2/board-am3517evm.c      |   66 +++++++-
 arch/arm/mach-omap2/board-cm-t35.c         |   95 ++++++++++-
 arch/arm/mach-omap2/board-cm-t3517.c       |   97 +++++++++++-
 arch/arm/mach-omap2/board-devkit8000.c     |   20 ++-
 arch/arm/mach-omap2/board-igep0020.c       |  112 +++++++++++--
 arch/arm/mach-omap2/board-omap3beagle.c    |   93 ++++++++++-
 arch/arm/mach-omap2/board-omap3evm.c       |   63 ++++++--
 arch/arm/mach-omap2/board-omap3pandora.c   |   54 +++++-
 arch/arm/mach-omap2/board-omap3stalker.c   |   52 +++++-
 arch/arm/mach-omap2/board-omap3touchbook.c |   62 ++++++-
 arch/arm/mach-omap2/board-omap4panda.c     |  123 ++++++++++----
 arch/arm/mach-omap2/board-overo.c          |   55 ++++++-
 arch/arm/mach-omap2/board-zoom.c           |   56 ++++++-
 drivers/mfd/omap-usb-host.c                |   48 +------
 drivers/usb/host/Kconfig                   |    2 +-
 drivers/usb/host/Makefile                  |    1 +
 drivers/usb/host/ehci-hcd.c                |    6 +-
 drivers/usb/host/ehci-omap.c               |  245 +++++++++++-----------------
 drivers/usb/otg/nop-usb-xceiv.c            |  106 +++++++++++--
 include/linux/platform_data/usb-omap.h     |    3 -
 include/linux/usb/nop-usb-xceiv.h          |    1 +
 24 files changed, 1288 insertions(+), 366 deletions(-)

-- 
1.7.4.1

