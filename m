Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaIBNBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:01:18 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:50932 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaIBNBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:01:16 -0400
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
Subject: [PATCH v11 00/19] arm: KGDB NMI/FIQ support
Date: Tue,  2 Sep 2014 14:00:34 +0100
Message-Id: <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org>
References: <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org>
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

Changes since v10:

- Removed use of RCU notifier chains to encourage code review by
  ensuring no driver can use FIQ without touching code in arch/arm/kernel
  (Russell King)

Changes since v9:

- Split PL011 code movement into a seperate patch (Peter Hurley)
- Use container_of() to convert pointers to uart_amba_port (Peter
  Hurley)
- Clean up redundant code from pl011_poll_init (Peter Hurley)
- Call do_unexp_fiq() if we receive a FIQ and CONFIG_FIQ is not set.
- Ensure irq-gic.c does not call FIQ functions unless CONFIG_FIQ is set.
- Introduced patch to avoid ttyNMI0 being enabled by default
  (replaces architecture dependant enable/disable logic).
- Fixed bug in kgdb_fiq_enable_nmi() that causes SysRq-g (non-NMI
  debugging) to wedge the debugger.

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

Daniel Thompson (18):
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
  serial: kgdb_nmi: No CON_ENABLED by default
  serial: amba-pl011: Use container_of() to get uart_amba_port
  serial: amba-pl011: Move pl011_hwinit()
  serial: amba-pl011: Pass FIQ information to KGDB.
  serial: asc: Add support for KGDB's FIQ/NMI mode
  serial: asc: Adopt readl_/writel_relaxed()
  serial: imx: Add support for KGDB's FIQ/NMI mode

Dirk Behme (1):
  serial: imx: clean up imx_poll_get_char()

 arch/arm/Kconfig                |   2 +
 arch/arm/Kconfig.debug          |  19 +++
 arch/arm/include/asm/fiq.h      |  17 +++
 arch/arm/include/asm/hardirq.h  |   2 +-
 arch/arm/include/asm/kgdb.h     |   5 +
 arch/arm/include/asm/smp.h      |   7 +
 arch/arm/kernel/entry-armv.S    | 129 +++++++++++++++--
 arch/arm/kernel/fiq.c           | 146 ++++++++++++++++++-
 arch/arm/kernel/kgdb.c          | 112 ++++++++++++++-
 arch/arm/kernel/setup.c         |   8 +-
 arch/arm/kernel/smp.c           |  15 ++
 arch/arm/mach-versatile/core.c  |   2 +-
 drivers/irqchip/irq-gic.c       | 302 +++++++++++++++++++++++++++++++++++++---
 drivers/irqchip/irq-vic.c       |  92 +++++++++---
 drivers/tty/serial/Kconfig      |   2 +-
 drivers/tty/serial/amba-pl011.c | 143 +++++++++++--------
 drivers/tty/serial/imx.c        |  88 +++++++-----
 drivers/tty/serial/kgdb_nmi.c   |   5 +-
 drivers/tty/serial/st-asc.c     |  27 +++-
 include/linux/irqchip/arm-gic.h |   3 +
 include/linux/irqchip/arm-vic.h |   6 +-
 21 files changed, 975 insertions(+), 157 deletions(-)

--
1.9.3

