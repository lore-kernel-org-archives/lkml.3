Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaGJIFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:05:41 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:50922 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaGJIFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:05:36 -0400
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
Subject: [PATCH v8 0/4] arm: KGDB NMI/FIQ support
Date: Thu, 10 Jul 2014 09:03:43 +0100
Message-Id: <1404979427-12943-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404118391-3850-1-git-send-email-daniel.thompson@linaro.org>
References: <1404118391-3850-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset makes it possible to use kgdb's NMI infrastructure on ARM
platforms.

The patches have been previously circulated as part of a large patchset
mixing together ARM architecture code and driver changes
(http://thread.gmane.org/gmane.linux.ports.arm.kernel/333901 ). This
patchset is dramatically cut down to include only the arch/arm code. The
driver code (irqchip and tty/serial) will follow when/if the arch code
is accepted.

The first two patches modify the FIQ infrastructure to allow interrupt
controller drivers to register callbacks (the fiq_chip structure) to
manage FIQ routings and to ACK and EOI the FIQ. This makes it possible
to use FIQ in multi-platform kernels and with recent ARM interrupt
controllers.

The remaining two patches provide architecture support for KGDB's NMI
feature (and rely upon the preceding changes to the FIQ code).

Tested on qemu (versatile), STiH416 (B2020 board) and Freescale i.MX6
quad (wandboard).

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

Anton Vorontsov (2):
  ARM: Move some macros from entry-armv to entry-header
  ARM: Add KGDB/KDB FIQ debugger generic code

Daniel Thompson (2):
  arm: fiq: Add callbacks to manage FIQ routings
  arm: fiq: Allow ACK and EOI to be passed to the intc

 arch/arm/Kconfig                 |   2 +
 arch/arm/Kconfig.debug           |  18 +++++
 arch/arm/include/asm/fiq.h       |  17 ++++
 arch/arm/include/asm/kgdb.h      |   7 ++
 arch/arm/kernel/Makefile         |   1 +
 arch/arm/kernel/entry-armv.S     | 151 +----------------------------------
 arch/arm/kernel/entry-header.S   | 164 +++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/fiq.c            | 122 ++++++++++++++++++++++++++++-
 arch/arm/kernel/kgdb_fiq.c       | 132 +++++++++++++++++++++++++++++++
 arch/arm/kernel/kgdb_fiq_entry.S | 130 +++++++++++++++++++++++++++++++
 10 files changed, 592 insertions(+), 152 deletions(-)
 create mode 100644 arch/arm/kernel/kgdb_fiq.c
 create mode 100644 arch/arm/kernel/kgdb_fiq_entry.S

--
1.9.3

