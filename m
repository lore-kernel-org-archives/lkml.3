Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab3JCPN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:13:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53166 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab3JCPNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:13:21 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>, <balbi@ti.com>
CC: <bcousson@baylibre.com>, <tony@atomide.com>, <george.cherian@ti.com>,
        <kishon@ti.com>, <bigeasy@linutronix.de>,
        <sergei.shtylyov@cogentembedded.com>, <thomas.langer@lantiq.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v8 0/8][RESEND] phy: omap-usb: Support multiple instances and new types
Date: Thu, 3 Oct 2013 18:12:29 +0300
Message-ID: <1380813157-22311-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I was initially pushing this series through Felipe, but now that PHY framework
is in your usb-next tree, Felipe has asked me to send it to you.

We need this for 3.13.
There are more patches related to USB support for TI's DRA7 SoC and SATA support
for OMAP5 that depend on this series.

This patchset does the following:

* Get rid of omap_control_usb platform data as we support DT only.

* Restructure and add support for new PHY types. We now support the following
four types

 TYPE_OTGHS - if it has otghs_control mailbox register (e.g. on OMAP4)
 TYPE_USB2 - if it has Power down bit in control_dev_conf register. e.g. USB2 PHY
 TYPE_PIPE3 - if it has DPLL and individual Rx & Tx power control. e.g. USB3 PHY or SATA PHY
 TYPE_DRA7USB2 - if it has both power down and power aux registers. e.g. USB2 PHY on DRA7

* Get rid of "ti,type" DT property and introduce compatible strings for each type.

* Have only one power control API "omap_control_usb_phy_power()" instead of a
different one for each PHY type.

* Get rid of omap_get_control_dev() so that we can support multiple instances
of the control device. We take advantage of the fact that omap control USB device
is only present on OMAP4 onwards and hence only supports DT boot. The users
of control USB device can get a reference to it from the device node's phandle.

Patches are based on greg/usb-next.

*NOTE: Patches 7 and 8 need to go through Benoit Cousson's OMAP DTS tree.

You can also find the patches in branch
 usb-control-module
in git tree
 git://github.com/rogerq/linux.git

v8:
- Rebased on top of greg/usb-next to avoid conflicts
- Removed patches 9 and 10 as they are not applicable

v7:
- Rebased on v3.12-rc1
- Updated DT compatibility ID for better readability
- Renamed TYPE_OMAP4 to TYPE_OTGHS, TYPE_USB3 to TYPE_PIPE3 and TYPE_DRA7 to
  TYPE_DRA7USB2

v6:
- addressed review comment about usage of control_usb before allocation.

v5:
- fixed whitespace alignment issues.

v4:
- removed "ti,has-mailbox" from omap-usb binding document example.

v3:
- return -EINVAL instead of -ENODEV on probe failure.
- pass device type data through of_device_id table.
- get rid of "ti,mailbox" property and "has_mailbox" from musb platform data.

v2:
- get rid of "ti,type" property and introduce compatible strings for each device type.

cheers,
-roger

Roger Quadros (8):
  usb: phy: omap-control: Get rid of platform data
  usb: phy: omap: Add new device types and remove
    omap_control_usb3_phy_power()
  usb: phy: omap-usb2: Don't use omap_get_control_dev()
  usb: phy: omap-usb3: Don't use omap_get_control_dev()
  usb: musb: omap2430: Don't use omap_get_control_dev()
  ARM: dts: omap4: update omap-control-usb nodes
  usb: phy: omap: get rid of omap_get_control_dev()
  ARM: dts: omap5: update omap-control-usb node

 Documentation/devicetree/bindings/usb/omap-usb.txt |   34 ++--
 arch/arm/boot/dts/omap4.dtsi                       |   20 ++-
 arch/arm/boot/dts/omap5.dtsi                       |   20 ++-
 drivers/phy/phy-omap-usb2.c                        |   31 +++-
 drivers/usb/musb/omap2430.c                        |   25 ++-
 drivers/usb/phy/phy-omap-control.c                 |  208 ++++++++++---------
 drivers/usb/phy/phy-omap-usb3.c                    |   32 +++-
 include/linux/usb/musb.h                           |    2 -
 include/linux/usb/omap_control_usb.h               |   33 ++--
 9 files changed, 220 insertions(+), 185 deletions(-)

-- 
1.7.4.1

