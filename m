Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab3GJQSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 12:18:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55447 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab3GJQSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 12:18:33 -0400
From: Roger Quadros <rogerq@ti.com>
To: <stern@rowland.harvard.edu>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <sergei.shtylyov@cogentembedded.com>, <khilman@linaro.org>,
        <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH 0/6] USB: Implement runtime idling and remote wakeup for OMAP EHCI controller
Date: Wed, 10 Jul 2013 19:17:55 +0300
Message-ID: <1373473081-27181-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series implements suspend/resume for the OMAP EHCI host controller during
runtime idle. This will cause its parent, the OMAP USB Host Module as well
as the USB TLL Module to be put in suspend and hence allow the USB power domain
to be put in a lower power state. Then we no longer prevent the rest of the OMAP
SoC from entering lower power states like RETention or OFF mode when
USB (or system) is suspended. This was one of the main reason why EHCI_OMAP
is still not enabled in OMAP2 defconfig.

In order for remote wakeup or hub events (connect/disconnect) to be detected
while in suspend, we need to rely on the IO daisy chaining mechanism on OMAP.
This is nothing but configuring a pin to be wakeup capable and triggering an
interrupt on any pin activity while the hardware module or the entire SoC is
in sleep state. For this to work, we rely on the wakeup feature added to the
omap-pinctrl-single driver in [1]. This takes care of routing IO pad wakeup
interrupt to the right driver's interrupt handler (i.e. ehci_irq in our case).

The pin state information for DEFAULT and IDLE is specified for the omap3beagle-xm
board in patch 2. So this is tested only on omap3beagle-xm board.

Patch 4 takes care of switching the pin states between DEFAULT and IDLE during
idle/active mode using the pinctrl framework.

Patch 5 takes care of handling the wakeup IRQ when the USB controller is suspended
and Hardware is not accessible.

Patch 6 implements runtime and system suspend/resume for the OMAP EHCI controller

Changelog:
v1:
- addressed review comments on RFC patchset
- Special case handling of controllers that can generate wakeup IRQ when
suspended is done in HCD core instead of ehci-hcd.
- Patches based on linus/master commit 496322bc91e35007ed754184dcd447a02b6dd685
with the following patches on top

[1] - OMAP pinctrl wakeup support
http://thread.gmane.org/gmane.linux.ports.arm.omap/99010/focus=99041
This does not apply cleanly though. Tony has agreed to post a revision anytime soon.

[2] - [PATCH v5 0/2] ARM: dts: Add USB host support for Beagle-xm
http://thread.gmane.org/gmane.linux.drivers.devicetree/39291

[3] - USB-EHCI-Fix-resume-signalling-on-remote-wakeup.patch
http://thread.gmane.org/gmane.linux.usb.general/89608

cheers,
-roger

---
Roger Quadros (6):
  ARM: OMAP3: Enable Hardware Save and Restore for USB Host
  ARM: dts: omap3beagle-xm: Add idle state pins for USB host
  mfd: omap-usb-host: move initialization to module_init()
  mfd: omap-usb-host: Put pins in IDLE state on suspend
  USB: Support wakeup IRQ for suspended controllers
  USB: ehci-omap: Implement suspend/resume

 arch/arm/boot/dts/omap3-beagle-xm.dts       |   29 ++++++++++---
 arch/arm/mach-omap2/powerdomains3xxx_data.c |    8 +---
 drivers/mfd/omap-usb-host.c                 |   45 ++++++++++--------
 drivers/mfd/omap-usb-tll.c                  |   20 +--------
 drivers/usb/core/hcd.c                      |   21 ++++++++-
 drivers/usb/host/ehci-omap.c                |   64 ++++++++++++++++++++++++++-
 include/linux/usb/hcd.h                     |    3 +
 7 files changed, 136 insertions(+), 54 deletions(-)

-- 
1.7.4.1

