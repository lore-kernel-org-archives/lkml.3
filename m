Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaG1O56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:57:58 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:51031 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaG1O5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:57:54 -0400
From: Stefan Agner <stefan@agner.ch>
To: peter.chen@freescale.com, s.hauer@pengutronix.de, shawn.guo@freescale.com
Cc: b35083@freescale.com, jingchang.lu@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH v2 0/7] vf610: Add USB support
Date: Mon, 28 Jul 2014 16:57:26 +0200
Message-Id: <cover.1406558450.git.stefan@agner.ch>
X-Mailer: git-send-email 2.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds USB support for Vybrid VF610 SoC. It extends the
clock framework to support the USB PHY cocks, extends the device
tree files and adds support for the non-core registers in the
usbmisc_imx driver.

This patchset needs the eSDHC registers length fix available in
Shawn's for-next branch, since that overlapped by chance the USB
areas.

The whole patchset proved to be working on a Colibri VF61 and
Freescale Tower VF65GS10. The first USB controller runs in
peripheral mode. I could successfully use RNDIS, however with some
stability issues: Suddenly the other side was not reachable anymore
and the interface needed to brought down and back up again. I'm
still investigating this.

The second USB controller, running in USB host mode, showed errors
when connecting devices behind a USB hub:

[  215.163507] usb usb1-port1: cannot reset (err = -32)
[  215.170498] usb usb1-port1: cannot reset (err = -32)
[  215.185120] usb usb1-port1: cannot reset (err = -32)
[  215.191345] usb usb1-port1: cannot reset (err = -32)
[  215.202487] usb usb1-port1: cannot reset (err = -32)
[  215.207718] usb usb1-port1: Cannot enable. Maybe the USB cable is bad?
[  215.219317] usb usb1-port1: unable to enumerate USB device

By extending the PHY driver with the MXS_PHY_NEED_IP_FIX flag, this
issue is resolved.

Changes in v2:
- Extended usbmisc_imx to support multiple instances
- Update DT documentation and compatible strings where necessary
- Add USB PHY flag MXS_PHY_NEED_IP_FIX
- Added patches to enable USB on Tower

Stefan Agner (7):
  ARM: dts: vf610: Add USB PHY and controller
  ARM: imx: clk-vf610: Add USBPHY clocks
  usb: phy: mxs: Add VF610 USB PHY support
  ARM: dts: vf610: Add usbmisc for non-core registers
  chipidea: usbmisc_imx: Add USB support for VF610 SoCs
  ARM: dts: vf610-colibri: Add USB support
  ARM: dts: vf610-twr: Add USB support

 Documentation/devicetree/bindings/usb/mxs-phy.txt  |  1 +
 .../devicetree/bindings/usb/usbmisc-imx.txt        |  1 +
 arch/arm/boot/dts/vf610-colibri.dts                | 10 ++++
 arch/arm/boot/dts/vf610-twr.dts                    | 10 ++++
 arch/arm/boot/dts/vf610.dtsi                       | 60 ++++++++++++++++++++--
 arch/arm/mach-imx/clk-vf610.c                      | 12 ++++-
 drivers/usb/chipidea/ci_hdrc_imx.c                 |  8 +++
 drivers/usb/chipidea/ci_hdrc_imx.h                 |  1 +
 drivers/usb/chipidea/usbmisc_imx.c                 | 52 +++++++++++++++----
 drivers/usb/phy/phy-mxs-usb.c                      |  6 +++
 include/dt-bindings/clock/vf610-clock.h            |  5 +-
 11 files changed, 149 insertions(+), 17 deletions(-)

-- 
2.0.2

