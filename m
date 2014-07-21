Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613AbaGUOr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:47:58 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:53797 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932519AbaGUOr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:47:56 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, Marex Vasut <marex@denx.de>,
        Harro Haan <hrhaan@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>
Subject: [PATCH RFC 0/9] Fix INTACK for FIQ support on ARM Cortex A9
Date: Mon, 21 Jul 2014 15:47:11 +0100
Message-Id: <1405954040-30399-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users of the recently proposed extensions to the FIQ infrastructure
have reported a problem which causes the interrupt dispatcher in
irq-gic.c (running as a normal IRQ handler) to try to acknowledge
group 0 interrupts (group 0 should raise FIQ).

The problem occurs because the GICv1 found in Cortex A9 implementations
explicitly uses the security state (normal or trusted world) to
determine whether the interrupt controller should acknowledge group 0
interrupts. For FIQ to be useful as an NMI on Cortex A9 the kernel must
run in in trusted world hence by default the GIC allows the CPU to
acknowledge group 0 interrupts.

Two workarounds have been proposed, one which retrospectively corrects
the problem if it is observed and one which uses the ARM MMU section
flags to ensure the GIC driver can read INTACK from the current security
context. The later workaround, which is both more invasive and higher
performance[1], is presented in this patchset.

This patchset depends upon my own patchset for ARM providing additional
FIQ infrastructure but does contain the changes to the GIC driver
required to support FIQ. The effect of this is that workaround code
is found primarily in patches 5, 6 and 7.

[1]
http://thread.gmane.org/gmane.linux.ports.arm.kernel/331027/focus=1748892

Daniel Thompson (6):
  irqchip: gic: Provide support for interrupt grouping
  irqchip: gic: Add support for FIQ management
  irqchip: gic: Remove spin locks from eoi_irq
  arm: mm: Avoid ioremap_page_range() for non-secure mappings
  irqchip: gic: Use non-secure aliased register set when FIQ is enabled
  arm: imx: non-secure aliased mapping of GIC registers

Marek Vasut (3):
  ARM: dump the status of NS bit in L1 PTE
  ARM: Add L1 PTE non-secure mapping
  ARM: socfpga: Map the GIC CPU registers as MT_DEVICE_NS

 arch/arm/include/asm/io.h                   |   5 +-
 arch/arm/include/asm/mach/map.h             |   4 +-
 arch/arm/include/asm/pgtable-2level-hwdef.h |   1 +
 arch/arm/mach-imx/mach-imx6q.c              |  11 ++
 arch/arm/mach-socfpga/socfpga.c             |   8 +
 arch/arm/mm/dump.c                          |   5 +
 arch/arm/mm/ioremap.c                       |   4 +
 arch/arm/mm/mmu.c                           |  13 +-
 drivers/irqchip/irq-gic.c                   | 240 ++++++++++++++++++++++++++--
 include/linux/irqchip/arm-gic.h             |   4 +-
 10 files changed, 273 insertions(+), 22 deletions(-)

--
1.9.3

