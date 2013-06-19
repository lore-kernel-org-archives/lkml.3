Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934479Ab3FSOGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 10:06:25 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49942 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933869Ab3FSOGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 10:06:22 -0400
From: Roger Quadros <rogerq@ti.com>
To: <stern@rowland.harvard.edu>, <tony@atomide.com>
CC: <balbi@ti.com>, <ruslan.bilovol@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 0/6] Suspend USB Host controller on bus suspend
Date: Wed, 19 Jun 2013 17:05:47 +0300
Message-ID: <1371650753-11452-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series attempts to suspend the OMAP EHCI host controller on USB
Bus suspend. This will cause its parent, the OMAP USB Host Module as well
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
board in patch 5. So this is tested only on omap3beagle-xm board.

As the omap-ehci controller driver needs to do some additional work to put
itself into suspend/resume and make sure it is resumed to process an interrupt,
we need to be able to override irq, bus_suspend, and bus_resume handlers. This
provision is done in patch 3.

Patch 2 uses pinctrl framework to toggle USB host pins from DEFAULT state
when active to IDLE state with wakeups enabled while in suspend.

Patch 5 implements the suspend feature in ehci-omap driver and ensures that
we don't loose events while in suspend.

Please let me know what you think about it. I'm not 100% confident about
tackling interrupt when the device is runtime suspended in patch 5. Please
let me know if a race condition is possible here.

[1] - OMAP pinctrl wakeup support
http://thread.gmane.org/gmane.linux.ports.arm.omap/99010/focus=99041

cheers,
-roger

Roger Quadros (6):
  mfd: omap-usb-host: move initialization to module_init()
  mfd: omap-usb-host: Put pins in IDLE state on suspend
  USB: ehci: allow controller drivers to override irq &
    bus_suspend/resume
  USB: ehci-omap: Suspend the controller during bus suspend
  ARM: dts: omap3beagle-xm: Add idle state pins for USB host
  ARM: OMAP3: Enable Hardware Save and Restore for USB Host

 arch/arm/boot/dts/omap3-beagle-xm.dts       |   29 ++++++++--
 arch/arm/mach-omap2/powerdomains3xxx_data.c |    8 +--
 drivers/mfd/omap-usb-host.c                 |   56 +++++++++++++++---
 drivers/mfd/omap-usb-tll.c                  |    8 +--
 drivers/usb/host/ehci-hcd.c                 |    9 +++-
 drivers/usb/host/ehci-hub.c                 |    6 +-
 drivers/usb/host/ehci-omap.c                |   82 +++++++++++++++++++++++++++
 drivers/usb/host/ehci.h                     |    6 ++
 8 files changed, 172 insertions(+), 32 deletions(-)

-- 
1.7.4.1

