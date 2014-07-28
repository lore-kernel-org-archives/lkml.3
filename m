Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaG1V22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:28:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33655 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbaG1VRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:17:32 -0400
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        <bcousson@baylibre.com>, <linux@arm.linux.org.uk>,
        <khilman@deeprootsystems.com>, <tglx@linutronix.de>,
        <jason@lakedaemon.net>, <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 00/35] arm: omap: move intc to drivers/irqchip/
Date: Mon, 28 Jul 2014 16:15:48 -0500
Message-ID: <1406582183-696-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

here's another rebase of the original series moving INTC
to drivers.

There aren't many changes, only some fixes here and there
because of recent changes to irq_domain and irqchip.

I have also added a patch to enable INTC address space
protection so that only privileged modes can access
INTC's address space.

Patches tested on top of v3.17-rc7 with a beagle bone black,
the only plataform I have which still uses INTC.

Tony, if you can run your PM test cases on your side, I'd
be really glad.

cheers

Felipe Balbi (35):
  arm: omap: irq: make omap_irq_base global
  arm: omap: irq: define INTC_ILR0 register
  arm: omap: irq: start to remove irq_banks array
  arm: omap: irq: add a global omap_nr_irqs variable
  arm: omap: irq: remove rest of irq_banks usage
  arm: omap: irq: remove unused macro
  arm: omap: irq: switch over to intc_readl on omap_intc_handle_irq
  arm: omap: irq: remove unnecessary base_addr argument
  arm: omap: irq: rename omap3_intc_regs
  arm: omap: irq: always define omap3 support
  arm: omap: irq: reorganize code a little bit
  arm: omap: irq: make intc_of_init static
  arm: omap: irq: call set_handle_irq() from intc_of_init
  arm: omap: irq: use IRQCHIP_DECLARE macro
  arm: omap: irq: drop .handle_irq and .init_irq fields
  arm: omap: irq: add specific compatibles for omap3 and am33xx devices
  arm: omap: irq: use compatible flag to figure out number of IRQ lines
  arm: boot: dts: am33xx/omap3: fix intc compatible flag
  arm: omap: irq: drop ti,intc-size support
  arm: boot: dts: omap2/3/am33xx: drop ti,intc-size
  arm: omap: irq: move some more code around
  arm: omap: irq: call set_handle_irq() from .init_irq
  arm: omap: irq: drop omap3_intc_handle_irq()
  arm: omap: irq: drop omap2_intc_handle_irq()
  arm: omap: irq: remove unnecessary header
  arm: omap: irq: remove nr_irqs argument
  arm: omap: irq: introduce omap_nr_pending
  arm: omap: irq: get rid of ifdef hack
  arm: omap: intc: switch over to linear irq domain
  irqchip: add irq-omap-intc.h header
  arm: omap: irq: move irq.c to drivers/irqchip/
  irq: intc: minor improvement to omap_irq_pending()
  irq: intc: comment style cleanup
  irq: intc: remove unnecesary of_address_to_resource() call
  irq: intc: enable IP protection

 arch/arm/boot/dts/am33xx.dtsi              |   3 +-
 arch/arm/boot/dts/omap2.dtsi               |   1 -
 arch/arm/boot/dts/omap3.dtsi               |   3 +-
 arch/arm/mach-omap2/Kconfig                |   1 +
 arch/arm/mach-omap2/Makefile               |   3 +-
 arch/arm/mach-omap2/board-3430sdp.c        |   2 +-
 arch/arm/mach-omap2/board-am3517crane.c    |   2 +-
 arch/arm/mach-omap2/board-am3517evm.c      |   2 +-
 arch/arm/mach-omap2/board-cm-t35.c         |   3 +-
 arch/arm/mach-omap2/board-cm-t3517.c       |   2 +-
 arch/arm/mach-omap2/board-devkit8000.c     |   2 +-
 arch/arm/mach-omap2/board-generic.c        |  14 -
 arch/arm/mach-omap2/board-ldp.c            |   2 +-
 arch/arm/mach-omap2/board-omap3beagle.c    |   2 +-
 arch/arm/mach-omap2/board-omap3logic.c     |   3 +-
 arch/arm/mach-omap2/board-omap3pandora.c   |   2 +-
 arch/arm/mach-omap2/board-omap3stalker.c   |   2 +-
 arch/arm/mach-omap2/board-omap3touchbook.c |   2 +-
 arch/arm/mach-omap2/board-overo.c          |   2 +-
 arch/arm/mach-omap2/board-rx51.c           |   2 +-
 arch/arm/mach-omap2/board-ti8168evm.c      |   1 +
 arch/arm/mach-omap2/common.h               |  22 --
 arch/arm/mach-omap2/cpuidle34xx.c          |   1 +
 arch/arm/mach-omap2/irq.c                  | 380 ---------------------------
 arch/arm/mach-omap2/pm24xx.c               |   1 +
 arch/arm/mach-omap2/pm34xx.c               |   1 +
 drivers/irqchip/Kconfig                    |   5 +
 drivers/irqchip/Makefile                   |   1 +
 drivers/irqchip/irq-omap-intc.c            | 408 +++++++++++++++++++++++++++++
 include/linux/irqchip/irq-omap-intc.h      |  32 +++
 30 files changed, 468 insertions(+), 439 deletions(-)
 delete mode 100644 arch/arm/mach-omap2/irq.c
 create mode 100644 drivers/irqchip/irq-omap-intc.c
 create mode 100644 include/linux/irqchip/irq-omap-intc.h

-- 
2.0.1.563.g66f467c

