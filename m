Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbaJ3CTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 22:19:41 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:61073 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757540AbaJ3CTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 22:19:39 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: arnd@arndb.de, f.fainelli@gmail.com, tglx@linutronix.de,
        jason@lakedaemon.net, ralf@linux-mips.org, lethal@linux-sh.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mbizon@freebox.fr, jogo@openwrt.org, linux-mips@linux-mips.org
Subject: [PATCH V2 00/15] genirq endian fixes; bcm7120/brcmstb IRQ updates
Date: Wed, 29 Oct 2014 19:17:53 -0700
Message-Id: <1414635488-14137-1-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know if this will make everyone 100% happy but hopefully we're
inching slightly closer to a solution...

V1->V2:

 - Rework big endian support per the discussion on the list
 - Get rid of the global compile-time irq_reg_{readl,writel} accessors
   and make them private to generic-chip.c, so that on multiplatform
   kernels, different irqchip drivers can specify different MMIO behavior
 - Rebase on Linus's head of tree

Patch 06/15 still feels a bit like premature optimization to me.  Perhaps
we can drop it if nobody reports a measurable performance advantage in
any known configuration?


Kevin Cernekee (15):
  irqchip: Replace irq_reg_{readl,writel} with {readl,writel}
  sh: Eliminate unused irq_reg_{readl,writel} accessors
  genirq: Generic chip: Move irq_reg_{readl,writel} accessors into
    generic-chip.c
  genirq: Generic chip: Change irq_reg_{readl,writel} arguments
  genirq: Generic chip: Add big endian I/O accessors
  genirq: Generic chip: Optimize for fixed-endian systems
  irqchip: brcmstb-l2: Eliminate dependency on ARM code
  irqchip: bcm7120-l2: Eliminate bad IRQ check
  irqchip: Remove ARM dependency for bcm7120-l2 and brcmstb-l2
  irqchip: bcm7120-l2: Make sure all register accesses use base+offset
  irqchip: bcm7120-l2: Fix missing nibble in gc->unused mask
  irqchip: bcm7120-l2: Use gc->mask_cache to simplify suspend/resume
    functions
  irqchip: bcm7120-l2: Extend driver to support 64+ bit controllers
  irqchip: Decouple bcm7120-l2 from brcmstb-l2
  irqchip: bcm7120-l2: Enable big endian register accesses on BE kernels

 .../interrupt-controller/brcm,bcm7120-l2-intc.txt  |  26 +++-
 arch/arm/mach-bcm/Kconfig                          |   1 +
 arch/sh/boards/mach-se/7343/irq.c                  |   3 -
 arch/sh/boards/mach-se/7722/irq.c                  |   3 -
 drivers/irqchip/Kconfig                            |   8 +-
 drivers/irqchip/Makefile                           |   4 +-
 drivers/irqchip/irq-atmel-aic.c                    |  40 ++---
 drivers/irqchip/irq-atmel-aic5.c                   |  63 ++++----
 drivers/irqchip/irq-bcm7120-l2.c                   | 169 +++++++++++++--------
 drivers/irqchip/irq-brcmstb-l2.c                   |   7 +-
 drivers/irqchip/irq-sunxi-nmi.c                    |   4 +-
 drivers/irqchip/irq-tb10x.c                        |   4 +-
 include/linux/irq.h                                |   8 +-
 kernel/irq/Kconfig                                 |   5 +
 kernel/irq/Makefile                                |   1 +
 kernel/irq/generic-chip.c                          |  51 +++++--
 16 files changed, 237 insertions(+), 160 deletions(-)

-- 
2.1.1

