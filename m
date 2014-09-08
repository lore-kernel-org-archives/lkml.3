Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbaIHP24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:28:56 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:41617 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbaIHP2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:28:55 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH v3 0/5] arm: Implement arch_trigger_all_cpu_backtrace
Date: Mon,  8 Sep 2014 16:28:30 +0100
Message-Id: <1410190115-32604-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409931198-22600-1-git-send-email-daniel.thompson@linaro.org>
References: <1409931198-22600-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements arch_trigger_all_cpu_backtrace for arm.

Non-maskable signalling relies on the kernel being able to access FIQ
and therefore, for devices that implement TrustZone, it will work only on
systems that boot the kernel in secure mode.

Tested on Freescale iMX.6 (both via SysRq-l and by deliberately locking
up the kernel with CONFIG_DEBUG_SPINLOCK=y).

Changes since v2:

* Removed redundant header guards from arch/arm64/include/asm/fiq.h
  (review of Catalin Marinas).

* Moved svc_exit_via_fiq macro to entry-header.S (review of Nicolas
  Pitre).

Changes since v1:

* Restructured to sit nicely on a similar FYI patchset from Russell
  King. It now effectively replaces the work in progress final patch
  with something much more complete.

* Implemented (and tested) a Thumb-2 implementation of svc_exit_via_fiq
  (review of Nicolas Pitre)

* Dropped the GIC group 0 workaround patch. The issue of FIQ interrupts
  being acknowledged by the IRQ handler does still exist but should be
  harmless because the IRQ handler will still wind up calling
  ipi_cpu_backtrace().

* Removed any dependency on CONFIG_FIQ; all cpu backtrace effectively
  becomes a platform feature (although the use of non-maskable
  interrupts to implement it is best effort rather than guaranteed).

* Better comments highlighting usage of RAZ/WI registers (and parts of
  registers) in the GIC code.

Changes *before* v1:

* This patchset is a hugely cut-down successor to "[PATCH v11 00/19]
  arm: KGDB NMI/FIQ support". Thanks to Thomas Gleixner for suggesting
  the new structure. For historic details see:
        https://lkml.org/lkml/2014/9/2/227

* Fix bug in __fiq_abt (no longer passes a bad struct pt_regs value).
  In fixing this we also remove the useless indirection previously
  found in the fiq_handler macro.

* Make default fiq handler "always on" by migrating from fiq.c to
  traps.c and replace do_unexp_fiq with the new handler (review
  of Russell King).

* Add arm64 version of fiq.h (review of Russell King)

* Removed conditional branching and code from irq-gic.c, this is
  replaced by much simpler code that relies on the GIC specification's
  heavy use of read-as-zero/write-ignored (review of Russell King)


Daniel Thompson (3):
  arm: fiq: Replace default FIQ handler
  arm64: Introduce dummy version of asm/fiq.h
  irqchip: gic: Add support for IPI FIQ

Russell King (2):
  ARM: remove unused do_unexp_fiq() function
  ARM: add basic support for on-demand backtrace of other CPUs

 arch/arm/include/asm/irq.h      |   5 ++
 arch/arm/include/asm/smp.h      |   3 +
 arch/arm/kernel/entry-armv.S    |  95 ++++++++++++++++++++---
 arch/arm/kernel/entry-header.S  |  47 ++++++++++++
 arch/arm/kernel/setup.c         |   8 +-
 arch/arm/kernel/smp.c           |  64 ++++++++++++++++
 arch/arm/kernel/traps.c         |  32 +++++++-
 arch/arm64/include/asm/fiq.h    |   8 ++
 drivers/irqchip/irq-gic.c       | 165 +++++++++++++++++++++++++++++++++++++---
 include/linux/irqchip/arm-gic.h |   3 +
 10 files changed, 407 insertions(+), 23 deletions(-)
 create mode 100644 arch/arm64/include/asm/fiq.h

--
1.9.3

