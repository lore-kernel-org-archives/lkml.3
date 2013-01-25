Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab3AYCdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:33:55 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:46330 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284Ab3AYCdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:33:47 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <tony@atomide.com>, <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <linux@arm.linux.org.uk>, <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <gregkh@linuxfoundation.org>, <kishon@ti.com>
Subject: [PATCH v2 0/6] USB: Add support for multiple PHYs of same type
Date: Fri, 25 Jan 2013 08:03:20 +0530
Message-ID: <1359081206-5602-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for adding multiple PHY's (of same type).
The binding information has to be present in the PHY library (otg.c) in
order for it to return the appropriate PHY whenever the USB controller
request for the PHY. So added a new API usb_bind_phy() to pass the binding
information. This API should be called by platform specific initialization
code.

So the binding should be done something like
usb_bind_phy("musb-hdrc.0.auto", 0, "omap-usb2.1.auto"); specifying the USB
controller device name, index, and the PHY device name.
I have done this binding for OMAP platforms, but it should be done for
all the platforms.

After this design, the phy can be got by passing the USB controller device
pointer and the index.

Changes from v1:
* made *usb_bind_phy* return an interget instead of struct usb_phy_bind *
* made *__usb_find_phy_dev* return -EPROBE_DEFER if the usb_phy_bind entry has
  device names filled but phy is NULL.
* Added of_node_put(node) corresponding to of_parse_phandle.

Developed this patch series on
git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git xceiv
after applying "usb: musb: add driver for control module" patch series
and "ARM: dts: omap: add dt data for MUSB"

I've kept this patch series and all the patch series to follow in a single branch
git://gitorious.org/linux-usb/linux-usb.git omap5-with-palmas
(changes up to 23b4dfa2ab7052569cd88acc6383c4b1a8e8a482)

Did basic enumeration testing in omap4 panda and omap3 beagle.

Kishon Vijay Abraham I (6):
  usb: otg: Add an API to bind the USB controller and PHY
  usb: otg: utils: add facilities in phy lib to support multiple PHYs
    of same type
  ARM: OMAP: USB: Add phy binding information
  drivers: usb: musb: omap: make use of the new PHY lib APIs
  usb: otg: add device tree support to otg library
  USB: MUSB: OMAP: get PHY by phandle for dt boot

 arch/arm/mach-omap2/board-2430sdp.c          |    2 +
 arch/arm/mach-omap2/board-3430sdp.c          |    2 +
 arch/arm/mach-omap2/board-4430sdp.c          |    2 +
 arch/arm/mach-omap2/board-cm-t35.c           |    2 +
 arch/arm/mach-omap2/board-devkit8000.c       |    2 +
 arch/arm/mach-omap2/board-igep0020.c         |    2 +
 arch/arm/mach-omap2/board-ldp.c              |    2 +
 arch/arm/mach-omap2/board-omap3beagle.c      |    2 +
 arch/arm/mach-omap2/board-omap3evm.c         |    2 +
 arch/arm/mach-omap2/board-omap3logic.c       |    2 +
 arch/arm/mach-omap2/board-omap3pandora.c     |    2 +
 arch/arm/mach-omap2/board-omap3stalker.c     |    2 +
 arch/arm/mach-omap2/board-omap3touchbook.c   |    2 +
 arch/arm/mach-omap2/board-omap4panda.c       |    2 +
 arch/arm/mach-omap2/board-overo.c            |    2 +
 arch/arm/mach-omap2/board-rm680.c            |    2 +
 arch/arm/mach-omap2/board-zoom-peripherals.c |    2 +
 drivers/usb/musb/omap2430.c                  |    7 +-
 drivers/usb/otg/otg.c                        |  235 +++++++++++++++++++++++++-
 drivers/usb/otg/twl4030-usb.c                |    3 +-
 drivers/usb/phy/omap-usb2.c                  |    3 +-
 include/linux/usb/phy.h                      |   43 +++++
 22 files changed, 321 insertions(+), 4 deletions(-)

-- 
1.7.9.5

