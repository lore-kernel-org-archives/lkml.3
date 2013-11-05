Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab3KENPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 08:15:15 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44945 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab3KENPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 08:15:12 -0500
From: Sricharan R <r.sricharan@ti.com>
To: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>, <rnayak@ti.com>,
        <marc.zyngier@arm.com>, <grant.likely@linaro.org>,
        <mark.rutland@arm.com>, <robherring2@gmail.com>, <tglx@linutronix.de>,
        <santosh.shilimkar@ti.com>, <galak@codeaurora.org>,
        <r.sricharan@ti.com>
Subject: [PATCH V3 0/7] DRIVERS: IRQCHIP: Add support for crossbar IP
Date: Tue, 5 Nov 2013 18:44:10 +0530
Message-ID: <1383657257-3458-1-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some socs have a large number of interrupts requests to service
the needs of its many peripherals and subsystems. All of the interrupt
requests lines from the subsystems are not needed at the same
time, so they have to be muxed to the controllers appropriately.
In such places a interrupt controllers are preceded by an
IRQ CROSSBAR that provides flexibility in muxing the device interrupt
requests to the controller inputs.

This series models the peripheral interrupts that can be routed through
the crossbar to the GIC as 'routable-irqs'. The routable irqs are added
in a separate linear domain inside the GIC. The registered routable domain's
callback are invoked as a part of the GIC's callback, which in turn should
allocate a free irq line and configure the IP accordingly. So every peripheral
in the dts files mentions the fixed crossbar number as its interrupt. A free
gic line for that gets allocated and configured when the peripheral interrupts
are mapped.

The minimal crossbar driver to track and allocate free GIC lines and configure the
crossbar is added here, along with the DT bindings.

V3:
   Addressed few more comments from Thomas Gleixner <tglx@linutronix.de>

   Rebased patches 3,4,5,7 which updates the DTS file on top of below branch
	   git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt.git
	   for_3.13/dts

   Rebased patches 1,2,6 on top of 3.12 mainline
   Updated Commit tags

V2:
   Addressed Thomas Gleixner <tglx@linutronix.de> comments and
   Kumar Gala <galak@codeaurora.org>

   Split updating the DRA7.dtsi file for adding the routable-irqs

Previous discussions that led to this is at
	https://lkml.org/lkml/2013/9/18/540

The V1,V2 post of these patches is at
      [V1]  https://lkml.org/lkml/2013/9/30/283
      [V2]  http://www.spinics.net/lists/linux-omap/msg99540.html

Sricharan R (7):
  DRIVERS: IRQCHIP: IRQ-GIC: Add support for routable irqs
  DRIVERS: IRQCHIP: CROSSBAR: Add support for Crossbar IP
  ARM: DTS: DRA: Add crossbar device binding
  ARM: DTS: DRA: Replace peripheral interrupt numbers with crossbar
    inputs
  ARM: DTS: DRA7: Add routable-irqs property for gic node
  ARM: OMAP4+: Correct Wakeup-gen code to use physical irq number
  ARM: DRA: Enable Crossbar IP support for DRA7XX

 Documentation/devicetree/bindings/arm/gic.txt      |    6 +
 .../devicetree/bindings/arm/omap/crossbar.txt      |   27 +++
 arch/arm/boot/dts/dra7.dtsi                        |   95 +++++----
 arch/arm/mach-omap2/Kconfig                        |    1 +
 arch/arm/mach-omap2/omap-wakeupgen.c               |    4 +-
 arch/arm/mach-omap2/omap4-common.c                 |    4 +
 drivers/irqchip/Kconfig                            |    8 +
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-crossbar.c                     |  206 ++++++++++++++++++++
 drivers/irqchip/irq-gic.c                          |   81 +++++++-
 include/linux/irqchip/arm-gic.h                    |    8 +-
 include/linux/irqchip/irq-crossbar.h               |   11 ++
 12 files changed, 396 insertions(+), 56 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/omap/crossbar.txt
 create mode 100644 drivers/irqchip/irq-crossbar.c
 create mode 100644 include/linux/irqchip/irq-crossbar.h

-- 
1.7.9.5

