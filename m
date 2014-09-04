Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbaIDQDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:03:52 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40158 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaIDQDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:03:50 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH v1 0/6] arm: Implement arch_trigger_all_cpu_backtrace
Date: Thu,  4 Sep 2014 17:03:34 +0100
Message-Id: <1409846620-14542-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
References: <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements arch_trigger_all_cpu_backtrace for arm.

Non-maskable signalling relies on the kernel being able to access FIQ
and therefore, for devices that implement TrustZone, it will work only on
systems that boot the kernel in secure mode.

Tested on Freescale iMX.6 (both via SysRq-l and by deliberately locking
up the kernel with CONFIG_DEBUG_SPINLOCK=y).

Changes *before* v1:

- This patchset is a hugely cut-down successor to "[PATCH v11 00/19]
  arm: KGDB NMI/FIQ support". Thanks to Thomas Gleixner for suggesting
  the new structure. For historic details see:
        https://lkml.org/lkml/2014/9/2/227

- Fix bug in __fiq_abt (no longer passes a bad struct pt_regs value).
  In fixing this we also remove the useless indirection previously
  found in the fiq_handler macro.

- Make default fiq handler "always on" by migrating from fiq.c to
  traps.c and replace do_unexp_fiq with the new handler (Russell
  King).

- Add arm64 version of fiq.h (Russell King)

- Removed conditional branching and code from irq-gic.c, this is
  replaced by much simpler code that relies on the GIC specification's
  heavy use of read-as-zero/write-ignored (Russell King)


Daniel Thompson (5):
  arm: fiq: Replace default FIQ handler
  arm: smp: Introduce a non-maskable IPI
  arm64: Introduce dummy version of asm/fiq.h
  irqchip: gic: Add support for IPI FIQ
  irqchip: gic: Group 0 workaround.

Russell King (1):
  arm: Implement arch_trigger_all_cpu_backtrace

 arch/arm/Kconfig.debug          |  14 +++
 arch/arm/include/asm/hardirq.h  |   2 +-
 arch/arm/include/asm/irq.h      |   5 +
 arch/arm/include/asm/smp.h      |   7 ++
 arch/arm/kernel/entry-armv.S    | 110 ++++++++++++++++++--
 arch/arm/kernel/setup.c         |   8 +-
 arch/arm/kernel/smp.c           |  67 ++++++++++++
 arch/arm/kernel/traps.c         |  34 +++++-
 arch/arm64/include/asm/fiq.h    |  18 ++++
 drivers/irqchip/irq-gic.c       | 223 +++++++++++++++++++++++++++++++++++++---
 include/linux/irqchip/arm-gic.h |   3 +
 11 files changed, 464 insertions(+), 27 deletions(-)
 create mode 100644 arch/arm64/include/asm/fiq.h

--
1.9.3

