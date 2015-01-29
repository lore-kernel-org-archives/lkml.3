Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbbA2LOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:14:38 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:4617 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbbA2LOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:14:31 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Ralf Baechle <ralf@linux-mips.org>, <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Jason Wessel <jason.wessel@windriver.com>,
        <kgdb-bugreport@lists.sourceforge.net>
Subject: [PATCH 0/9] Add MIPS EJTAG Fast Debug Channel TTY driver
Date: Thu, 29 Jan 2015 11:14:05 +0000
Message-ID: <1422530054-7976-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.110]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds a TTY, console, and KGDB driver for the MIPS Fast
Debug Channel (FDC) hardware, for communicating with a debugger via an
EJTAG probe. 16 TTY ports are created per FDC device, corresponding to
the 16 FDC channels. Each VPE usually has its own FDC instance.

This patchset depends on my recent CDMM bus patchset (the FDC is in the
per-CPU CDMM region), and my recent MIPS timer & perf counter IRQ
sharing patchset (the FDC IRQ is a local CPU IRQ which may similarly
share CPU IRQ lines with the other local IRQs).

Patches 1 to 6 add the necessary architecture bits for the FDC
interrupt, and a workaround in the MIPS idle code to avoid the wait
instruction on certain cores if FDC driver is enabled.

Finally patches 7-9 add the main TTY/console driver, wire up some early
console code, and implement KGDB operations & magic sysrq.

Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Andrew Bresticker <abrestic@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-mips@linux-mips.org
Cc: kgdb-bugreport@lists.sourceforge.net

James Hogan (9):
  MIPS: Add architectural FDC IRQ fields
  MIPS: Read CPU IRQ line that FDC to routed to
  irqchip: mips-gic: Don't treat FDC IRQ as percpu devid
  irqchip: mips-gic: Add function for retrieving FDC IRQ
  MIPS: Malta: Implement get_c0_fdc_int()
  MIPS: idle: Workaround wait + FDC problems
  tty: Add MIPS EJTAG Fast Debug Channel TTY driver
  MIPS, ttyFDC: Add early FDC console support
  ttyFDC: Implement KGDB IO operations.

 arch/mips/include/asm/cdmm.h     |   11 +
 arch/mips/include/asm/irq.h      |    3 +
 arch/mips/include/asm/mipsregs.h |    4 +
 arch/mips/kernel/idle.c          |   13 +-
 arch/mips/kernel/setup.c         |    2 +
 arch/mips/kernel/traps.c         |   11 +
 arch/mips/mti-malta/malta-time.c |   16 +
 drivers/irqchip/irq-mips-gic.c   |   38 +-
 drivers/tty/Kconfig              |   47 ++
 drivers/tty/Makefile             |    1 +
 drivers/tty/mips_ejtag_fdc.c     | 1303 ++++++++++++++++++++++++++++++++++++++
 include/linux/irqchip/mips-gic.h |    1 +
 12 files changed, 1443 insertions(+), 7 deletions(-)
 create mode 100644 drivers/tty/mips_ejtag_fdc.c

-- 
2.0.5

