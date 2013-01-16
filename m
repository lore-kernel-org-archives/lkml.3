Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab3APPER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:04:17 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:46117 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148Ab3APPCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:02:34 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-sh@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <balbi@ti.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <horms@verge.net.au>, <magnus.damm@gmail.com>, <cbou@mail.ru>,
        <dwmw2@infradead.org>, <alexander.shishkin@linux.intel.com>,
        <gregkh@linuxfoundation.org>, <leoli@freescale.com>,
        <eric.y.miao@gmail.com>, <haojian.zhuang@gmail.com>,
        <stern@rowland.harvard.edu>, <kishon@ti.com>
Subject: [RFC PATCH 0/6] USB: Add multiple PHYs of same type
Date: Wed, 16 Jan 2013 20:30:56 +0530
Message-ID: <1358348462-27693-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New platforms are being added which has multiple PHY's (of same type) and
which has multiple USB controllers. The binding information has to be
present in the PHY library (otg.c) in order for it to return the
appropriate PHY whenever the USB controller request for the PHY. So
added a new API to pass the binding information. This API should be
called by platform specific initialization code.

So the binding should be done something like
usb_bind_phy("musb-hdrc.0.auto", 0, "omap-usb2.1.auto"); specifying the USB
controller device name, index, and the PHY device name.
I have done this binding for OMAP platforms, but it should be done for
all the platforms.

After this design, the phy can be got by passing the USB controller device
pointer and the index.

Developed this patch series on
git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git xceiv
after applying "usb: musb: add driver for control module" patch series.

Did basic enumeration testing in omap4 panda, omap4 sdp and omap3 beagle.

Kishon Vijay Abraham I (6):
  usb: otg: Add an API to bind the USB controller and PHY
  ARM: OMAP: USB: Add phy binding information
  usb: otg: utils: change the phy lib to support multiple PHYs of same
    type
  ARM: dts: OMAP: Add phandle to bind PHY with USB controller
  usb: otg: add device tree support to otg library
  USB: MUSB: OMAP: get PHY by phandle for dt boot

 Documentation/devicetree/bindings/usb/omap-usb.txt |    2 +
 arch/arm/boot/dts/omap3.dtsi                       |    1 +
 arch/arm/boot/dts/omap4.dtsi                       |    3 +-
 arch/arm/boot/dts/twl4030.dtsi                     |    2 +-
 arch/arm/mach-omap2/usb-musb.c                     |    7 +-
 arch/arm/mach-shmobile/board-marzen.c              |    2 +-
 drivers/power/ab8500_charger.c                     |    2 +-
 drivers/power/isp1704_charger.c                    |    2 +-
 drivers/power/pda_power.c                          |    2 +-
 drivers/power/twl4030_charger.c                    |    2 +-
 drivers/usb/chipidea/udc.c                         |    2 +-
 drivers/usb/dwc3/core.c                            |    4 +-
 drivers/usb/gadget/fsl_udc_core.c                  |    2 +-
 drivers/usb/gadget/mv_udc_core.c                   |    2 +-
 drivers/usb/gadget/omap_udc.c                      |    2 +-
 drivers/usb/gadget/pxa25x_udc.c                    |    2 +-
 drivers/usb/gadget/pxa27x_udc.c                    |    2 +-
 drivers/usb/gadget/s3c-hsudc.c                     |    2 +-
 drivers/usb/host/ehci-fsl.c                        |    2 +-
 drivers/usb/host/ehci-msm.c                        |    2 +-
 drivers/usb/host/ehci-mv.c                         |    2 +-
 drivers/usb/host/ehci-tegra.c                      |    2 +-
 drivers/usb/host/ohci-omap.c                       |    2 +-
 drivers/usb/musb/am35x.c                           |    2 +-
 drivers/usb/musb/blackfin.c                        |    2 +-
 drivers/usb/musb/da8xx.c                           |    2 +-
 drivers/usb/musb/davinci.c                         |    2 +-
 drivers/usb/musb/musb_dsps.c                       |    2 +-
 drivers/usb/musb/omap2430.c                        |    7 +-
 drivers/usb/musb/tusb6010.c                        |    2 +-
 drivers/usb/musb/ux500.c                           |    2 +-
 drivers/usb/otg/ab8500-usb.c                       |    3 +-
 drivers/usb/otg/fsl_otg.c                          |    5 +-
 drivers/usb/otg/gpio_vbus.c                        |    3 +-
 drivers/usb/otg/isp1301_omap.c                     |    3 +-
 drivers/usb/otg/msm_otg.c                          |    3 +-
 drivers/usb/otg/mv_otg.c                           |    3 +-
 drivers/usb/otg/nop-usb-xceiv.c                    |    3 +-
 drivers/usb/otg/otg.c                              |  175 ++++++++++++++++----
 drivers/usb/otg/twl4030-usb.c                      |    3 +-
 drivers/usb/phy/mv_u3d_phy.c                       |    3 +-
 drivers/usb/phy/omap-usb2.c                        |   11 +-
 drivers/usb/phy/rcar-phy.c                         |    3 +-
 include/linux/usb/phy.h                            |   42 ++++-
 44 files changed, 245 insertions(+), 89 deletions(-)

-- 
1.7.9.5

