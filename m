Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbaIOXvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:51:36 -0400
Received: from mail-pa0-f73.google.com ([209.85.220.73]:47062 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbaIOXve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 19:51:34 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>, Jonas Gorski <jogo@openwrt.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/24] MIPS GIC cleanup, part 1
Date: Mon, 15 Sep 2014 16:51:03 -0700
Message-Id: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current MIPS GIC driver and the platform code using it are rather
ugly and could use a good cleanup before adding device-tree support [0].
This major issues addressed in this series are converting the GIC (and
platforms using it) to use IRQ domains and properly mapping interrupts
through the GIC instead of using it transparently.  For part 2 I plan
on: updating the driver to use proper iomem accessors, cleaning up and
moving the GIC clocksource driver to drivers/clocksource/, adding DT
support, and possibly converting the GIC driver to use generic irqchip.

Patches 1-16 are cleanups for the existing GIC driver and prepare platforms
using it for the switch to IRQ domains and using the GIC in a non-transparent
way.

Patches 17-24 convert the GIC driver to use IRQ domains and updates the
platforms using it to properly map GIC interrupts instead of using the static
routing tables to make the GIC appear transparent.

I've tested this series on Malta and, with additional patches, on the
DT-enabled Danube platform.  Unfortunately I do not have SEAD-3 hardware,
so that has only been compile tested.  Compile tested on all other affected
architectures (ath79, ralink, lantiq).

[0] https://lkml.org/lkml/2014/9/5/542

Andrew Bresticker (24):
  MIPS: Always use IRQ domains for CPU IRQs
  MIPS: Rename mips_cpu_intc_init() -> mips_cpu_irq_of_init()
  MIPS: Provide a generic plat_irq_dispatch
  MIPS: Set vint handler when mapping CPU interrupts
  MIPS: i8259: Use IRQ domains
  MIPS: Add hook to get C0 performance counter interrupt
  MIPS: smp-cps: Enable all hardware interrupts on secondary CPUs
  MIPS: Remove gic_{enable,disable}_interrupt()
  MIPS: sead3: Remove sead3-serial.c
  MIPS: sead3: Do not overlap CPU/GIC IRQ ranges
  MIPS: Malta: Move MSC01 interrupt base
  MIPS: Move MIPS_GIC_IRQ_BASE into platform irq.h
  MIPS: Move GIC to drivers/irqchip/
  irqchip: mips-gic: Implement generic irq_ack/irq_eoi callbacks
  irqchip: mips-gic: Implement irq_set_type callback
  irqchip: mips-gic: Fix gic_set_affinity() return value
  irqchip: mips-gic: Use IRQ domains
  irqchip: mips-gic: Stop using per-platform mapping tables
  irqchip: mips-gic: Probe for number of external interrupts
  irqchip: mips-gic: Use separate edge/level irq_chips
  irqchip: mips-gic: Support local interrupts
  irqchip: mips-gic: Remove unnecessary globals
  MIPS: Malta: Use generic plat_irq_dispatch
  MIPS: sead3: Use generic plat_irq_dispatch

 Documentation/devicetree/bindings/mips/cpu_irq.txt |   4 +-
 arch/mips/Kconfig                                  |  12 +-
 arch/mips/ath79/irq.c                              |   1 -
 arch/mips/ath79/setup.c                            |   5 +
 arch/mips/include/asm/gic.h                        |  82 ++-
 arch/mips/include/asm/irq_cpu.h                    |   4 +-
 arch/mips/include/asm/mach-generic/irq.h           |   6 +
 arch/mips/include/asm/mach-malta/irq.h             |   1 -
 arch/mips/include/asm/mach-sead3/irq.h             |   1 -
 arch/mips/include/asm/mips-boards/maltaint.h       |  24 +-
 arch/mips/include/asm/mips-boards/sead3int.h       |  15 +-
 arch/mips/include/asm/time.h                       |   1 +
 arch/mips/kernel/Makefile                          |   1 -
 arch/mips/kernel/cevt-gic.c                        |  14 +-
 arch/mips/kernel/cevt-r4k.c                        |   4 +-
 arch/mips/kernel/i8259.c                           |  24 +-
 arch/mips/kernel/irq-gic.c                         | 402 --------------
 arch/mips/kernel/irq_cpu.c                         |  45 +-
 arch/mips/kernel/perf_event_mipsxx.c               |  23 +-
 arch/mips/kernel/smp-cps.c                         |   4 +-
 arch/mips/kernel/smp-mt.c                          |   4 +-
 arch/mips/lantiq/irq.c                             |   8 +-
 arch/mips/mti-malta/malta-int.c                    | 307 ++---------
 arch/mips/mti-malta/malta-time.c                   |  39 +-
 arch/mips/mti-sead3/sead3-ehci.c                   |   8 +-
 arch/mips/mti-sead3/sead3-int.c                    | 121 +----
 arch/mips/mti-sead3/sead3-net.c                    |  14 +-
 arch/mips/mti-sead3/sead3-platform.c               |  18 +-
 arch/mips/mti-sead3/sead3-serial.c                 |  45 --
 arch/mips/mti-sead3/sead3-time.c                   |  35 +-
 arch/mips/oprofile/op_model_mipsxx.c               |  18 +-
 arch/mips/ralink/irq.c                             |  10 +-
 drivers/irqchip/Kconfig                            |   4 +
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-mips-gic.c                     | 597 +++++++++++++++++++++
 35 files changed, 867 insertions(+), 1035 deletions(-)
 delete mode 100644 arch/mips/kernel/irq-gic.c
 delete mode 100644 arch/mips/mti-sead3/sead3-serial.c
 create mode 100644 drivers/irqchip/irq-mips-gic.c

-- 
2.1.0.rc2.206.gedb03e5

