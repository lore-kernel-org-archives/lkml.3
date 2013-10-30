Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3J3O6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:58:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43216 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab3J3O6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:58:12 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>, <rnayak@ti.com>,
        <marc.zyngier@arm.com>, <grant.likely@linaro.org>,
        <mark.rutland@arm.com>, <robherring2@gmail.com>, <tglx@linutronix.de>,
        <santosh.shilimkar@ti.com>, <r.sricharan@ti.com>
Subject: [PATCH V2 0/7] DRIVERS: IRQCHIP: Add support for crossbar IP
Date: Wed, 30 Oct 2013 20:27:13 +0530
Message-ID: <1383145040-15852-1-git-send-email-r.sricharan@ti.com>
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

V2:
   Addressed Thomas Gleixner <tglx@linutronix.de> comments and
   Kumar Gala <galak@codeaurora.org>

   Split updating the DRA7.dtsi file for adding the routable-irqs
   property in to a separate patch

Previous discussions that led to this is at
	https://lkml.org/lkml/2013/9/18/540

The V1 post of these patches is at
        https://lkml.org/lkml/2013/9/30/283

Sricharan R (7):
  DRIVERS: IRQCHIP: IRQ-GIC: Add support for routable irqs
  DRIVERS: IRQCHIP: CROSSBAR: Add support for Crossbar IP
  ARM: DTS: DRA: Add crossbar device binding
  ARM: DTS: DRA: Replace peripheral interrupt numbers with crossbar
    inputs.
  ARM: DTS: DRA7: Add routable-irqs property for gic node
  ARM: OMAP4+: Correct Wakeup-gen code to use physical irq number
  ARM: DRA: Enable Crossbar IP support for DRA7XX

 Documentation/devicetree/bindings/arm/gic.txt      |    6 +
 .../devicetree/bindings/arm/omap/crossbar.txt      |   41 ++--
 arch/arm/boot/dts/dra7.dtsi                        |  102 ++++++----
 arch/arm/mach-omap2/Kconfig                        |    2 +-
 arch/arm/mach-omap2/omap-wakeupgen.c               |    4 +-
 arch/arm/mach-omap2/omap4-common.c                 |    4 +
 drivers/irqchip/Kconfig                            |    8 +
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-crossbar.c                     |  206 ++++++++++++++++++++
 drivers/irqchip/irq-gic.c                          |   83 +++++++-
 include/linux/irqchip/arm-gic.h                    |    8 +-
 include/linux/irqchip/irq-crossbar.h               |   11 ++
 12 files changed, 401 insertions(+), 75 deletions(-)
 create mode 100644 drivers/irqchip/irq-crossbar.c
 create mode 100644 include/linux/irqchip/irq-crossbar.h

-- 
1.7.9.5

