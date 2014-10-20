Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378AbaJTTEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:04:11 -0400
Received: from mail-oi0-f74.google.com ([209.85.218.74]:44083 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaJTTEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:04:09 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        John Crispin <blogic@openwrt.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/19] MIPS GIC cleanup, part 2
Date: Mon, 20 Oct 2014 12:03:47 -0700
Message-Id: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Second round of cleanups for the MIPS GIC drivers:
 - Patches 1 through 5 get rid of the ugly REG() macros and instead use
   proper iomem accessors.
 - Patches 6 and 7 move the GIC header to linux/irqchip/ and clean it up.
 - Patches 8 through 10 are misc. GIC irqchip cleanups.
 - Patches 11 and 12 combine the GIC clocksource and clockevent drivers and
   move them to drivers/clocksource/.
 - Patches 13 through 19 are various cleanups for the GIC clocksource driver.

Boot tested on Malta and (with additional out-of-tree patches) a platform
based on the IMG Pistachio SoC.  Build tested for SEAD-3.

Based on 3.18-rc1 + part 1 of my GIC cleanup series [0].  A tree with both
series is available at:
  https://github.com/abrestic/linux/commits/mips-gic-cleanup-pt2-v1

[0] https://lkml.org/lkml/2014/9/18/487

Andrew Bresticker (19):
  MIPS: Malta: Use gic_read_count() to read GIC timer
  irqchip: mips-gic: Export function to read counter width
  MIPS: sead3: Stop using GIC REG macros
  MIPS: Malta: Stop using GIC REG macros
  irqchip: mips-gic: Use proper iomem accessors
  MIPS: Move gic.h to include/linux/irqchip/mips-gic.h
  irqchip: mips-gic: Clean up header file
  irqchip: mips-gic: Clean up #includes
  irqchip: mips-gic: Remove gic_{pending,itrmask}_regs
  irqchip: mips-gic: Use GIC_SH_WEDGE_{SET,CLR} macros
  MIPS: Move GIC clocksource driver to drivers/clocksource/
  clocksource: mips-gic: Combine with GIC clockevent driver
  clocksource: mips-gic: Staticize local symbols
  clocksource: mips-gic: Move gic_frequency to clocksource driver
  clocksource: mips-gic: Remove gic_event_handler
  clocksource: mips-gic: Use percpu_dev_id
  clocksource: mips-gic: Use CPU notifiers to setup the timer
  clocksource: mips-gic: Use clockevents_config_and_register
  clocksource: mips-gic: Bump up rating of GIC timer

 arch/mips/Kconfig                                  |  21 +-
 arch/mips/include/asm/mips-boards/maltaint.h       |   2 +-
 arch/mips/include/asm/mips-boards/sead3int.h       |   2 +-
 arch/mips/include/asm/time.h                       |   5 +-
 arch/mips/kernel/Makefile                          |   2 -
 arch/mips/kernel/cevt-gic.c                        | 103 ---------
 arch/mips/kernel/cevt-r4k.c                        |   2 +-
 arch/mips/kernel/csrc-gic.c                        |  40 ----
 arch/mips/kernel/smp-cmp.c                         |   2 +-
 arch/mips/kernel/smp-cps.c                         |   2 +-
 arch/mips/kernel/smp-gic.c                         |   2 +-
 arch/mips/kernel/smp-mt.c                          |   2 +-
 arch/mips/mti-malta/malta-int.c                    |  15 +-
 arch/mips/mti-malta/malta-time.c                   |  20 +-
 arch/mips/mti-sead3/sead3-ehci.c                   |   2 +-
 arch/mips/mti-sead3/sead3-int.c                    |   9 +-
 arch/mips/mti-sead3/sead3-net.c                    |   2 +-
 arch/mips/mti-sead3/sead3-platform.c               |   2 +-
 arch/mips/mti-sead3/sead3-time.c                   |   2 +-
 drivers/clocksource/Kconfig                        |   4 +
 drivers/clocksource/Makefile                       |   1 +
 drivers/clocksource/mips-gic-timer.c               | 139 ++++++++++++
 drivers/irqchip/irq-mips-gic.c                     | 243 +++++++++++++--------
 .../asm/gic.h => include/linux/irqchip/mips-gic.h  | 203 +++--------------
 24 files changed, 363 insertions(+), 464 deletions(-)
 delete mode 100644 arch/mips/kernel/cevt-gic.c
 delete mode 100644 arch/mips/kernel/csrc-gic.c
 create mode 100644 drivers/clocksource/mips-gic-timer.c
 rename arch/mips/include/asm/gic.h => include/linux/irqchip/mips-gic.h (61%)

-- 
2.1.0.rc2.206.gedb03e5

