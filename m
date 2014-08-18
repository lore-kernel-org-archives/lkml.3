Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaHRNlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 09:41:16 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:48532 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaHRNlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 09:41:14 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>
Subject: [PATCH v9 00/16] arm: KGDB NMI/FIQ support
Date: Mon, 18 Aug 2014 14:40:48 +0100
Message-Id: <1408369264-14242-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404979427-12943-1-git-send-email-daniel.thompson@linaro.org>
References: <1404979427-12943-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset makes it possible to use kgdb's NMI infrastructure on ARM
platforms.

The patches are seperated into three distinct groups:

1. arm specific changes; these provide multi-platform support for FIQ
   (including raising an IPI using FIQ to ensure effective SMP support)
   and extend ARM KGDB support to use the features provided.

2. irqchip changes; updates to the gic and vic drivers to provide
   support for routing certain interrupt sources to FIQ.

3. serial changes; driver support to allow the UART interrupt to be
   routed to FIQ. The already mainlined kgdb NMI infrastructure (mostly
   found in drivers/tty/serial/kgdb_nmi.c) will re-route the kgdb
   console UART's interrupt signal from IRQ to FIQ. Naturally the UART
   will no longer function normally and will instead be managed by kgdb
   using the polled I/O functions. Any character delivered to the UART
   causes the kgdb handler function to be called.

Tested on qemu (versatile), STiH416 (B2020 board) and Freescale i.MX6
quad (wandboard).

Changes since v8:

- Significant rework to separate the FIQ exception handler from kgdb.
  This allows other features typically implemented using NMI on x86
  to reuse the same exception handling code (Russell King)
- Reunited arch/arm and driver code into a single patch series again.
- Added support for raising IPIs using FIQ (makes kgdb quiesce must
  more robust).
- Introduced a workaround for GICv1 devices to avoid FIQs being
  spuriously handled as IRQs.

Changes since v7:

- Introduced ack_fiq() to complement eoi_fiq(). Without this it is
  not possible to meet the GIC specification (previous versions worked
  when tested but are unpredictable according to the specification).
  ack_fiq() also makes is possible for drivers for devices with multiple
  interrupt lines to discover the interrupt source correctly.

Changes since v6:

- Corrected off-by-one comparison in has_fiq() (Nicolas Pitre)
- Rewrote the FIQ stack initialization (Nicolas Pitre). This fixes a
  serious data corruption bug due to bad stack mismanagement.
- Introduced __fiq_abt to ensure lr_abt and spsr_abt are saved and
  restored if we fast-interrupt an abort (Russell King).
- Significantly improved the commenting of the exception handlers.
- Added a call to trace_hardirqs_on() if we clear the I bit as we
  exit the exception handler.

Changes since v5:

- Separated anything not strictly impacting arch/arm.
- Fixed a spurious add/remove of code within the series (there was
  broken code in intermediate patches)

For previous changes see:
http://thread.gmane.org/gmane.linux.ports.arm.kernel/333901

Daniel Thompson (15):
  arm: fiq: Add callbacks to manage FIQ routings
  arm: fiq: Allow ACK and EOI to be passed to the intc
  arm: fiq: Replace default FIQ handler
  arm: smp: Introduce a special IPI signalled using FIQ
  arm: KGDB/KDB FIQ support
  irqchip: gic: Provide support for interrupt grouping
  irqchip: gic: Add support for FIQ management
  irqchip: gic: Remove spin locks from eoi_irq
  irqchip: gic: Add support for IPI FIQ
  irqchip: gic: Group 0 workaround.
  irqchip: vic: Add support for FIQ management
  serial: amba-pl011: Pass FIQ information to KGDB.
  serial: asc: Add support for KGDB's FIQ/NMI mode
  serial: asc: Adopt readl_/writel_relaxed()
  serial: imx: Add support for KGDB's FIQ/NMI mode

Dirk Behme (1):
  serial: imx: clean up imx_poll_get_char()

 arch/arm/Kconfig                |   2 +
 arch/arm/Kconfig.debug          |  19 +++
 arch/arm/include/asm/fiq.h      |  18 +++
 arch/arm/include/asm/hardirq.h  |   2 +-
 arch/arm/include/asm/kgdb.h     |   4 +
 arch/arm/include/asm/smp.h      |   7 +
 arch/arm/kernel/entry-armv.S    | 125 ++++++++++++++--
 arch/arm/kernel/fiq.c           | 139 +++++++++++++++++-
 arch/arm/kernel/kgdb.c          | 115 ++++++++++++++-
 arch/arm/kernel/setup.c         |   8 +-
 arch/arm/kernel/smp.c           |  15 ++
 arch/arm/mach-versatile/core.c  |   2 +-
 drivers/irqchip/irq-gic.c       | 307 +++++++++++++++++++++++++++++++++++++---
 drivers/irqchip/irq-vic.c       |  92 +++++++++---
 drivers/tty/serial/Kconfig      |   2 +-
 drivers/tty/serial/amba-pl011.c |  94 +++++++-----
 drivers/tty/serial/imx.c        |  88 +++++++-----
 drivers/tty/serial/st-asc.c     |  27 +++-
 include/linux/irqchip/arm-vic.h |   6 +-
 19 files changed, 934 insertions(+), 138 deletions(-)

--
1.9.3

