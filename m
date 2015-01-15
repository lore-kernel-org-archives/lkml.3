Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbbAOIES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 03:04:18 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:50697 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbbAOIEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 03:04:16 -0500
From: Stefan Agner <stefan@agner.ch>
To: tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com
Cc: u.kleine-koenig@pengutronix.de, shawn.guo@linaro.org,
        kernel@pengutronix.de, arnd@arndb.de, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH RESEND v3 0/3] irqchip: vf610-mscm: add support for MSCM interrupt router
Date: Thu, 15 Jan 2015 09:04:03 +0100
Message-Id: <1421309046-22452-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Splitted out version of the MSCM driver. My first driver based on the
routeable domain support and was part of the Vybrid Cortex-M4 support
patchset.

So far the MSCM interrupt router was initialized by the boot loader
and configured all interrupts for the Cortex-A5 CPU. There are two
use cases where a proper driver is necessary:
- To run Linux on the Cortex-M4. When the kernel is running on the
  non-preconfigured CPU, the interrupt router need to be configured
  properly.
- To support deeper sleep modes: LPSTOP clears the interrupt router
  configuration, hence a driver needs to restore the configuration
  on resume.
I created a seperate patchset for that driver which hopefully makes
it easier to get it into mergeable state.

Since I identified some registers likely to be used by other drivers
(e.g. CPU ID or the CPU Generate Interrupt Register) I also added
the "syscon" compatible string to make the registers available for
other drivers in case needed.

This resend version of this patchset is rebased on v3.19-rc4.

Changes since v2
- Use two cell layout for MSCM interrupt router
- Move peripheral interrupt properties to base device tree vfxxx.dtsi
- Use generic two cell xlate (irq_domain_xlate_twocell)
- Add syscon to compatible string
- Remove some line breaks for better readability

Changes since v1 (part of Vybrid Cortex-M4 support)
- Rewrite with irqdomain hierarchy
- Implemented as proper irqchip and move to driver/irqchip/
- Doesn't work on Cortex-M4 anymore (NVIC as parent is not yet
  implemented)

Stefan Agner (3):
  irqchip: vf610-mscm: add support for MSCM interrupt router
  irqchip: vf610-mscm: dt-bindings: add MSCM bindings
  ARM: dts: vf610: add Miscellaneous System Control Module (MSCM)

 .../bindings/arm/freescale/fsl,vf610-mscm.txt      |  19 +++
 arch/arm/boot/dts/vf500.dtsi                       | 128 +-------------
 arch/arm/boot/dts/vfxxx.dtsi                       |  42 +++++
 arch/arm/mach-imx/Kconfig                          |   1 +
 drivers/irqchip/Kconfig                            |  11 ++
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-vf610-mscm.c                   | 186 +++++++++++++++++++++
 7 files changed, 264 insertions(+), 124 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/freescale/fsl,vf610-mscm.txt
 create mode 100644 drivers/irqchip/irq-vf610-mscm.c

-- 
2.2.1

