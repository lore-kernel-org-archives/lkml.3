Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbbAWOWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:22:53 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:64184 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbbAWOWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:22:51 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>
Subject: [PATCH 3.19-rc2 v15 0/8] irq/arm: Implement arch_trigger_all_cpu_backtrace
Date: Fri, 23 Jan 2015 14:22:24 +0000
Message-Id: <1422022952-31552-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset modifies the GIC driver to allow it, on supported
platforms, to route IPI interrupts to FIQ. It then uses this
feature to implement arch_trigger_all_cpu_backtrace for arm.
In order to neatly (and safely) bring in the changes for the arm
we also make the sched_clock implementation NMI-safe and rearrange
some of the existing x86 NMI code to make it architecture neutral.

This patchset touches a fairly large number of different sub-systems
(irq, generic sched_clock, printk, x86, arm). However, of the eight
patches, five fall under one of tglx's maintainerships (either through
irq, time or x86). Thus unless there are objections I'd like to gather
acks from some of the folks Cc:ed on the patches. Then I can wrap it up
nicely and send it to Thomas.

The patches have been runtime tested on two systems capable of
supporting FIQ (Freescale i.MX6 and STiH416) and two that do not
(vexpress-a9 and Qualcomm Snapdragon 600), the changes to the x86
logic were tested on qemu and all patches have been compile tested
on x86, arm and arm64.

Note: On platforms not capable of supporting FIQ, the IPI to generate a
      backtrace will fall back to using IRQ for propagation instead.
      The backtrace logic contains a timeout to we will not wedge the
      requesting CPU if other CPUs are not responsive.

v15:

* Added a patch to make sched_clock safe to call from NMI (Stephen
  Boyd). Note that sched_clock() is not called by the NMI handlers that
  have been added for the arm but it could be called if tools such as
  ftrace are deployed.

* Fixed some warnings picked up during bisectability testing.

v14:

* Moved a nmi_vprintk() and friends from arch/x86/kernel/apic/hw_nmi.c
  to printk.c (Steven Rostedt)

v13:

* Updated the code to print the backtrace to replicate Steven Rostedt's
  x86 work to make SysRq-l safe. This is pretty much a total rewrite of
  patches 4 and 5.

v12:

* Squash first two patches into a single one and re-describe
  (Thomas Gleixner).

* Improve description of "irqchip: gic: Make gic_raise_softirq FIQ-safe"
  (Thomas Gleixner).

v11:

* Optimized gic_raise_softirq() by replacing a register read with
  a memory read (Jason Cooper).

v10:

* Add a further patch to optimize away some of the locking on systems
  where CONFIG_BL_SWITCHER is not set (Marc Zyngier). Compiles OK with
  exynos_defconfig (which is the only defconfig to set this option).

* Whitespace fixes in patch 4. That patch previously used spaces for
  alignment of new constants but the rest of the file used tabs.

v9:

* Improved documentation and structure of initial patch (now initial
  two patches) to make gic_raise_softirq() safe to call from FIQ
  (Thomas Gleixner).

* Avoid masking interrupts during gic_raise_softirq(). The use of the
  read lock makes this redundant (because we can safely re-enter the
  function).

v8:

* Fixed build on arm64 causes by a spurious include file in irq-gic.c.

v7-2 (accidentally released twice with same number):

* Fixed boot regression on vexpress-a9 (reported by Russell King).

* Rebased on v3.18-rc3; removed one patch from set that is already
  included in mainline.

* Dropped arm64/fiq.h patch from the set (still useful but not related
  to issuing backtraces).

v7:

* Re-arranged code within the patch series to fix a regression
  introduced midway through the series and corrected by a later patch
  (testing by Olof's autobuilder). Tested offending patch in isolation
  using defconfig identified by the autobuilder.

v6:

* Renamed svc_entry's call_trace argument to just trace (example code
  from Russell King).

* Fixed mismatched ENDPROC() in __fiq_abt (example code from Russell
  King).

* Modified usr_entry to optional avoid calling into the trace code and
  used this in FIQ entry from usr path. Modified corresponding exit code
  to avoid calling into trace code and the scheduler (example code from
  Russell King).

* Ensured the default FIQ register state is restored when the default
  FIQ handler is reinstalled (example code from Russell King).

* Renamed no_fiq_insn to dfl_fiq_insn to reflect the effect of adopting
  a default FIQ handler.

* Re-instated fiq_safe_migration_lock and associated logic in
  gic_raise_softirq(). gic_raise_softirq() is called by wake_up_klogd()
  in the console unlock logic.

v5:

* Rebased on 3.17-rc4.

* Removed a spurious line from the final "glue it together" patch
  that broke the build.

v4:

* Replaced push/pop with stmfd/ldmfd respectively (review of Nicolas
  Pitre).

* Really fix bad pt_regs pointer generation in __fiq_abt.

* Remove fiq_safe_migration_lock and associated logic in
  gic_raise_softirq() (review of Russell King)

* Restructured to introduce the default FIQ handler first, before the
  new features (review of Russell King).

v3:

* Removed redundant header guards from arch/arm64/include/asm/fiq.h
  (review of Catalin Marinas).

* Moved svc_exit_via_fiq macro to entry-header.S (review of Nicolas
  Pitre).

v2:

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


Daniel Thompson (8):
  irqchip: gic: Optimize locking in gic_raise_softirq
  irqchip: gic: Make gic_raise_softirq FIQ-safe
  irqchip: gic: Introduce plumbing for IPI FIQ
  sched_clock: Avoid deadlock during read from NMI
  printk: Simple implementation for NMI backtracing
  x86/nmi: Use common printk functions
  ARM: Add support for on-demand backtrace of other CPUs
  ARM: Fix on-demand backtrace triggered by IRQ

 arch/Kconfig                    |   3 +
 arch/arm/Kconfig                |   1 +
 arch/arm/include/asm/hardirq.h  |   2 +-
 arch/arm/include/asm/irq.h      |   5 +
 arch/arm/include/asm/smp.h      |   3 +
 arch/arm/kernel/smp.c           |  81 ++++++++++++++++
 arch/arm/kernel/traps.c         |   8 +-
 arch/x86/Kconfig                |   1 +
 arch/x86/kernel/apic/hw_nmi.c   |  97 ++-----------------
 drivers/irqchip/irq-gic.c       | 203 +++++++++++++++++++++++++++++++++++++---
 include/linux/irqchip/arm-gic.h |   8 ++
 include/linux/printk.h          |  22 +++++
 kernel/printk/printk.c          | 122 ++++++++++++++++++++++++
 kernel/time/sched_clock.c       | 157 ++++++++++++++++++++-----------
 14 files changed, 549 insertions(+), 164 deletions(-)

--
1.9.3

