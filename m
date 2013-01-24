Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab3AXKx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:53:28 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:47235 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab3AXKwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:52:39 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 00/71] Synopsys ARC Linux kernel Port (Part #1)
Date: Thu, 24 Jan 2013 16:20:14 +0530
Message-ID: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset based off-of 3.8-rc4, adds the Linux kernel port to ARC700
processor family (750D and 770D) from Synopsys. I would be greatful for
further review and feedback.

Salient points about v3 patchset
-------------------------------
* All of the feedback from v2 patchseries has been addressed.
* series sent in 2 parts, with other part containing patches not touched
  since v2.

About ARC Cores
----------------
ARC700 is highly configurable and power efficient 32-bit RISC core with MMU.
It is embedded in SoCs deployed in TV Set Top boxes, Digital Media Players,
all the way to Network-on-Chips.

More information is available @
 http://www.synopsys.com/IP/ProcessorIP/ARCProcessors/Pages/default.aspx

The GNU tool-chain, based off of gcc 4.4  + uClibc 0.9.30.3 is also available
from github. Please refer to Readme.md in "toolchain" repository also in same
hierarchy as kernel above.

---
v3:
=========================================================================

Review comments (with #<xx> patch in series addressing them)

#01 * Kbuild trace_clock.h inclusion - [split aggregate 3.8 patch]
#02 * Build system patch moved towards start of series
#02 * Dropped line continuation from Makefiles, Removed conditional HOTPLUG (Sam)
#02 * Removed empty vmlinux.lds.h (Sam)
#11 * _TIF_WORK_MASK needs to use the exact bits needed (Al Viro)
#17 * squashed generic clone patch into syscall patch (Al Viro)
#17 * split/squashed sys_execve removal bits into syscall patch (Al Viro)
#18 * split/squashed kernel_execve bits into process creation patch (Al Viro)
#18 * squashed switch-to-saner-execve into process creation patch (Al Viro)
#18 * squashed switch-to-generic-kernel-thread patch into process creation patch
#18 * cpu_idle() - fix a race between need_resched and sleep (Arnd)
#20 * task_pt_regs(current) => current_pt_regs()  (Al Viro)
#20 * altstack changes [split aggregate 3.8 patch] into signal handling (Al Viro)
#29 * include asm/cacheflush.h in io.h [split aggregate 3.8 patch]
#29 * Implemented __raw_{read,write}{b,w,l} for ARC with inline asm (Arnd)
#29 * early ioremap requiring MMU needs to bail out
#30 * switched from bootmem to memblock (Arnd)
#32 * dtb folder folded into dts to be consistent with other arches (Rob)
#32 * Using generic dtb build rule (Rob)
#33 * skeleton.dtsi no longer contains board references (Rob)
#34 * default DT is a board specific file (angel4) and not skeleton (Rob)
#42 * module helpers only defined when module unwinder really needs them (Arnd)
#44 * Removed CONFIG_ARC_HAS_IPI glue to enable SMP across platforms (Arnd)
#57 * hostlink driver converted/simplified using misc_register (Arnd)
#58 * UAPI - added a placeholder comment to empty setup.h (David)
#62 * struct machine_desc - arrange the callbacks in order of their call (Arnd)

Bug fixes (since v2)

#02 * ARC_SERIAL_BAUD depends on SERIAL_ARC_CONSOLE as well
#18 * RTSC fix in big-endian configuration (Noam Camus)
#21 * in_syscall() broken because checking of pt_regs->orig_r8 vs. pt_regs->event
#21 * syscall restarting infrastructure Big Endian safe
#22 * syscall restarting broken because not checking pt_regs->event
#23 * Changelog typo
#34 * cleanup static platform device for early arc-uart
#44 * Added CPU active notifier to secondary boot
#69 * Update defconfig for tmpfs, ext2, ....
    * make allyesconfig fixes
#06   * Missing ; in EXPORT_SYMBOL() in extable.c
#29   * Missing dma_sync_single_range_for_{cpu,device}
#29   * Missing dma_mmap_coherent/dma_get_sgtable
#48   * Missing regs_return_value() in ptrace.h for kprobes self-test
#70   * missing serial.h


v2:
=========================================================================
Changes for RFC v1 review:

* Reworked arc_local_irq_enable() with WARN_ONCE for buggy drivers (tglx)
* struct pt_regs wrapped under #ifdef __KERNEL__ (Jonas)
* returning to user mode (Al Viro)
  * re-enable interrupts before handling TIF_SIGPENDING/TIF_NOTIFY_RESUME
  * Don't discard callee-regs after handling signal
  * After TIF_NOTIFY_RESUME processing, loop back to start of TIF_* checks
* Reworked init_IRQ() to not use irq_modify_status() at all (tglx)
* Removed legacy syscalls (Arnd)
* cpu_idle to use schedule_preempt_disabled API (tglx)
* clocksource/clockevent code renamed/reworked (tglx)
* Removed possible live-lock in sched_clock() (tglx)
* Ensured that syscalls are not restarted multiple times (Al Viro)
* Support for DeviceTree based dynamic platform device registration (Arnd)
* clock-speed / mem-size extracted from Device Tree (Arnd)
* multi-platform-image - Non-exclusive platform selection in build (Arnd)
* multi-platform-image - Non-exclusive boards selection in build (Arnd)
* Fix the issue in switch to generic_execve (Al Viro)
* defconfigs need to be created using savedefconfig (Arnd)
* Remove support for legacy ptrace POKEUSR/PEEKUSR ABI (Arnd)
* module stubs need not be defined in Arch code (Arnd)
* Low Level Event Capture completely taken out (Arnd)
* Unaligned access runtime controlled using 2 sysctl knobs (Arnd)
* using io accessors for programming BVCI Latency Unit (Arnd)

Other fixes:

* 3.7 -> 3.8 upstream changes
  * Rebased off of 3.8-rc4
  * UAPI Disintegration using scripts provided David Howells
  * Generic clone/fork/vfork
  * switch to saner kernel_execve semantics (GENERIC_KERNEL_EXECVE)
  * Altstack consolidation tracking changes
  * trace_clock.h introduction, cacheflush.h inclusion removal from io.h
* bitops
  * test_and_clear_bit() was SETing the bit instead of CLEARing
  * test_and_*_bit() workaround a gas bug where a bitpos > 31 is not reported
    by doing __builtin_constant_p() check early
* uaccess
  * Added support for non-inline copy_{to,from}_user() for -Os
  * Optimised {get,put}_user() by overriding asm-generic versions
* Timers
  * split Process scheduling/Timers patch into two.
  * Add support for 64bit timestamp counter using RTSC instruction.
* Others
  * Move the incore intc chip handler out of platform code into common code
  * cpu_ide() to use the rcu_idle_* calls


patchset history
-----------------
[v2]	: https://lkml.org/lkml/2013/1/18/182

[RFC v1]: https://lkml.org/lkml/2012/11/7/114
          https://lkml.org/lkml/2012/11/12/121

Gilad Ben-Yossef (1):
  ARC: Add support for ioremap_prot API

Mischa Jonker (1):
  ARC: kgdb support

Vineet Gupta (69):
  ARC: Generic Headers
  ARC: Build system: Makefiles, Kconfig, Linker script
  ARC: irqflags - Interrupt enabling/disabling at in-core intc
  ARC: Atomic/bitops/cmpxchg/barriers
  asm-generic headers: uaccess.h to conditionally define segment_eq()
  ARC: uaccess friends
  asm-generic: uaccess: Allow arches to over-ride __{get,put}_user_fn()
  ARC: [optim] uaccess __{get,put}_user() optimised
  asm-generic headers: Allow yet more arch overrides in checksum.h
  ARC: Checksum/byteorder/swab routines
  ARC: Fundamental ARCH data-types/defines
  ARC: Spinlock/rwlock/mutex primitives
  ARC: String library
  ARC: Low level IRQ/Trap/Exception Handling
  ARC: Interrupt Handling
  ARC: Non-MMU Exception Handling
  ARC: Syscall support (no-legacy-syscall ABI)
  ARC: Process-creation/scheduling/idle-loop
  ARC: Timers/counters/delay management
  ARC: Signal handling
  ARC: [Review] Preparing to fix incorrect syscall restarts due to
    signals
  ARC: [Review] Prevent incorrect syscall restarts
  ARC: Cache Flush Management
  ARC: Page Table Management
  ARC: MMU Context Management
  ARC: MMU Exception Handling
  ARC: TLB flush Handling
  ARC: Page Fault handling
  ARC: I/O and DMA Mappings
  ARC: Boot #1: low-level, setup_arch(), /proc/cpuinfo, mem init
  ARC: [plat-arcfpga] Static platform device for CONFIG_SERIAL_ARC
  ARC: [DeviceTree] Basic support
  ARC: [DeviceTree] Convert some Kconfig items to runtime values
  ARC: [plat-arcfpga]: Enabling DeviceTree for Angel4 board
  ARC: Last bits (stubs) to get to a running kernel with UART
  ARC: [plat-arcfpga] defconfig
  ARC: [optim] Cache "current" in Register r25
  ARC: ptrace support
  ARC: Futex support
  ARC: OProfile support
  ARC: Support for high priority interrupts in the in-core intc
  ARC: Module support
  ARC: Diagnostics: show_regs() etc
  ARC: SMP support
  ARC: DWARF2 .debug_frame based stack unwinder
  ARC: stacktracing APIs based on dw2 unwinder
  ARC: disassembly (needed by kprobes/kgdb/unaligned-access-emul)
  ARC: kprobes support
  sysctl: Enable PARISC "unaligned-trap" to be used cross-arch
  ARC: Unaligned access emulation
  ARC: Boot #2: Verbose Boot reporting / feature verification
  ARC: [plat-arfpga] BVCI Latency Unit setup
  perf, ARC: Enable building perf tools for ARC
  ARC: perf support (software counters only)
  ARC: Support for single cycle Close Coupled Mem (CCM)
  ARC: Hostlink Pseudo-Driver for Metaware Debugger
  ARC: UAPI Disintegrate arch/arc/include/asm
  ARC: [Review] Multi-platform image #1: Kconfig enablement
  ARC: Fold boards sub-menu into platform/SoC menu
  ARC: [Review] Multi-platform image #2: Board callback Infrastructure
  ARC: [Review] Multi-platform image #3: switch to board callback
  ARC: [Review] Multi-platform image #4: Isolate platform headers
  ARC: [Review] Multi-platform image #5: NR_IRQS defined by ARC core
  ARC: [Review] Multi-platform image #6: cpu-to-dma-addr optional
  ARC: [Review] Multi-platform image #7: SMP common code to use
    callbacks
  ARC: [Review] Multi-platform image #8: platform registers SMP
    callbacks
  ARC: [plat-arcfpga] defconfig for fully loaded ARC Linux
  ARC: Provide a default serial.h for uart drivers needing BASE_BAUD
  ARC: Add self to MAINTAINERS

 .../devicetree/bindings/arc/interrupts.txt         |   24 +
 MAINTAINERS                                        |    6 +
 arch/arc/Kbuild                                    |    2 +
 arch/arc/Kconfig                                   |  456 +++++++
 arch/arc/Kconfig.debug                             |   34 +
 arch/arc/Makefile                                  |  126 ++
 arch/arc/boot/Makefile                             |   26 +
 arch/arc/boot/dts/Makefile                         |   14 +
 arch/arc/boot/dts/angel4.dts                       |   55 +
 arch/arc/boot/dts/skeleton.dts                     |   10 +
 arch/arc/boot/dts/skeleton.dtsi                    |   37 +
 arch/arc/configs/fpga_defconfig                    |   61 +
 arch/arc/include/asm/Kbuild                        |   49 +
 arch/arc/include/asm/arcregs.h                     |  433 +++++++
 arch/arc/include/asm/asm-offsets.h                 |    9 +
 arch/arc/include/asm/atomic.h                      |  232 ++++
 arch/arc/include/asm/barrier.h                     |   42 +
 arch/arc/include/asm/bitops.h                      |  516 ++++++++
 arch/arc/include/asm/bug.h                         |   37 +
 arch/arc/include/asm/cache.h                       |   75 ++
 arch/arc/include/asm/cacheflush.h                  |   67 +
 arch/arc/include/asm/checksum.h                    |  101 ++
 arch/arc/include/asm/clk.h                         |   22 +
 arch/arc/include/asm/cmpxchg.h                     |  143 +++
 arch/arc/include/asm/current.h                     |   32 +
 arch/arc/include/asm/defines.h                     |   56 +
 arch/arc/include/asm/delay.h                       |   68 +
 arch/arc/include/asm/disasm.h                      |  116 ++
 arch/arc/include/asm/dma-mapping.h                 |  221 ++++
 arch/arc/include/asm/dma.h                         |   14 +
 arch/arc/include/asm/elf.h                         |   97 ++
 arch/arc/include/asm/entry.h                       |  724 +++++++++++
 arch/arc/include/asm/exec.h                        |   15 +
 arch/arc/include/asm/futex.h                       |  151 +++
 arch/arc/include/asm/io.h                          |  105 ++
 arch/arc/include/asm/irq.h                         |   25 +
 arch/arc/include/asm/irqflags.h                    |  153 +++
 arch/arc/include/asm/kdebug.h                      |   19 +
 arch/arc/include/asm/kgdb.h                        |   61 +
 arch/arc/include/asm/kprobes.h                     |   62 +
 arch/arc/include/asm/linkage.h                     |   63 +
 arch/arc/include/asm/mach_desc.h                   |   85 ++
 arch/arc/include/asm/mmu.h                         |   23 +
 arch/arc/include/asm/mmu_context.h                 |  213 ++++
 arch/arc/include/asm/module.h                      |   28 +
 arch/arc/include/asm/mutex.h                       |   18 +
 arch/arc/include/asm/page.h                        |  109 ++
 arch/arc/include/asm/perf_event.h                  |   13 +
 arch/arc/include/asm/pgalloc.h                     |  134 ++
 arch/arc/include/asm/pgtable.h                     |  405 ++++++
 arch/arc/include/asm/processor.h                   |  151 +++
 arch/arc/include/asm/prom.h                        |   14 +
 arch/arc/include/asm/ptrace.h                      |  135 ++
 arch/arc/include/asm/sections.h                    |   18 +
 arch/arc/include/asm/segment.h                     |   24 +
 arch/arc/include/asm/serial.h                      |   25 +
 arch/arc/include/asm/setup.h                       |   37 +
 arch/arc/include/asm/smp.h                         |  130 ++
 arch/arc/include/asm/spinlock.h                    |  144 +++
 arch/arc/include/asm/spinlock_types.h              |   35 +
 arch/arc/include/asm/string.h                      |   40 +
 arch/arc/include/asm/switch_to.h                   |   41 +
 arch/arc/include/asm/syscall.h                     |   72 ++
 arch/arc/include/asm/syscalls.h                    |   29 +
 arch/arc/include/asm/thread_info.h                 |  121 ++
 arch/arc/include/asm/timex.h                       |   18 +
 arch/arc/include/asm/tlb-mmu1.h                    |  104 ++
 arch/arc/include/asm/tlb.h                         |   58 +
 arch/arc/include/asm/tlbflush.h                    |   28 +
 arch/arc/include/asm/uaccess.h                     |  751 +++++++++++
 arch/arc/include/asm/unaligned.h                   |   29 +
 arch/arc/include/asm/unwind.h                      |  163 +++
 arch/arc/include/uapi/asm/Kbuild                   |   11 +
 arch/arc/include/uapi/asm/byteorder.h              |   18 +
 arch/arc/include/uapi/asm/cachectl.h               |   28 +
 arch/arc/include/uapi/asm/page.h                   |   39 +
 arch/arc/include/uapi/asm/ptrace.h                 |   46 +
 arch/arc/include/uapi/asm/setup.h                  |    6 +
 arch/arc/include/uapi/asm/sigcontext.h             |   23 +
 arch/arc/include/uapi/asm/signal.h                 |   27 +
 arch/arc/include/uapi/asm/swab.h                   |   98 ++
 arch/arc/include/uapi/asm/unistd.h                 |   34 +
 arch/arc/kernel/Makefile                           |   33 +
 arch/arc/kernel/arc_hostlink.c                     |   58 +
 arch/arc/kernel/arcksyms.c                         |   56 +
 arch/arc/kernel/asm-offsets.c                      |   49 +
 arch/arc/kernel/clk.c                              |   21 +
 arch/arc/kernel/ctx_sw.c                           |  109 ++
 arch/arc/kernel/ctx_sw_asm.S                       |   58 +
 arch/arc/kernel/devtree.c                          |  113 ++
 arch/arc/kernel/disasm.c                           |  538 ++++++++
 arch/arc/kernel/entry.S                            |  839 ++++++++++++
 arch/arc/kernel/fpu.c                              |   55 +
 arch/arc/kernel/head.S                             |  111 ++
 arch/arc/kernel/irq.c                              |  273 ++++
 arch/arc/kernel/kgdb.c                             |  205 +++
 arch/arc/kernel/kprobes.c                          |  525 ++++++++
 arch/arc/kernel/module.c                           |  145 +++
 arch/arc/kernel/process.c                          |  235 ++++
 arch/arc/kernel/ptrace.c                           |  158 +++
 arch/arc/kernel/reset.c                            |   33 +
 arch/arc/kernel/setup.c                            |  471 +++++++
 arch/arc/kernel/signal.c                           |  363 ++++++
 arch/arc/kernel/smp.c                              |  332 +++++
 arch/arc/kernel/stacktrace.c                       |  254 ++++
 arch/arc/kernel/sys.c                              |   18 +
 arch/arc/kernel/time.c                             |  299 +++++
 arch/arc/kernel/traps.c                            |  170 +++
 arch/arc/kernel/troubleshoot.c                     |  322 +++++
 arch/arc/kernel/unaligned.c                        |  245 ++++
 arch/arc/kernel/unwind.c                           | 1329 ++++++++++++++++++++
 arch/arc/kernel/vmlinux.lds.S                      |  163 +++
 arch/arc/lib/Makefile                              |    9 +
 arch/arc/lib/memcmp.S                              |  124 ++
 arch/arc/lib/memcpy-700.S                          |   66 +
 arch/arc/lib/memset.S                              |   59 +
 arch/arc/lib/strchr-700.S                          |  123 ++
 arch/arc/lib/strcmp.S                              |   96 ++
 arch/arc/lib/strcpy-700.S                          |   70 +
 arch/arc/lib/strlen.S                              |   83 ++
 arch/arc/mm/Makefile                               |   10 +
 arch/arc/mm/cache_arc700.c                         |  771 ++++++++++++
 arch/arc/mm/dma.c                                  |   94 ++
 arch/arc/mm/extable.c                              |   63 +
 arch/arc/mm/fault.c                                |  228 ++++
 arch/arc/mm/init.c                                 |  187 +++
 arch/arc/mm/ioremap.c                              |   91 ++
 arch/arc/mm/tlb.c                                  |  645 ++++++++++
 arch/arc/mm/tlbex.S                                |  408 ++++++
 arch/arc/oprofile/Makefile                         |    9 +
 arch/arc/oprofile/common.c                         |   22 +
 arch/arc/plat-arcfpga/Kconfig                      |   84 ++
 arch/arc/plat-arcfpga/Makefile                     |   12 +
 arch/arc/plat-arcfpga/include/plat/irq.h           |   31 +
 arch/arc/plat-arcfpga/include/plat/memmap.h        |   31 +
 arch/arc/plat-arcfpga/include/plat/smp.h           |  118 ++
 arch/arc/plat-arcfpga/irq.c                        |   25 +
 arch/arc/plat-arcfpga/platform.c                   |  226 ++++
 arch/arc/plat-arcfpga/smp.c                        |  171 +++
 arch/parisc/Kconfig                                |    1 +
 include/asm-generic/checksum.h                     |    4 +
 include/asm-generic/uaccess.h                      |   14 +-
 init/Kconfig                                       |    8 +
 kernel/sysctl.c                                    |    5 +
 lib/checksum.c                                     |    2 +
 tools/perf/perf.h                                  |    6 +
 146 files changed, 19559 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arc/interrupts.txt
 create mode 100644 arch/arc/Kbuild
 create mode 100644 arch/arc/Kconfig
 create mode 100644 arch/arc/Kconfig.debug
 create mode 100644 arch/arc/Makefile
 create mode 100644 arch/arc/boot/Makefile
 create mode 100644 arch/arc/boot/dts/Makefile
 create mode 100644 arch/arc/boot/dts/angel4.dts
 create mode 100644 arch/arc/boot/dts/skeleton.dts
 create mode 100644 arch/arc/boot/dts/skeleton.dtsi
 create mode 100644 arch/arc/configs/fpga_defconfig
 create mode 100644 arch/arc/include/asm/Kbuild
 create mode 100644 arch/arc/include/asm/arcregs.h
 create mode 100644 arch/arc/include/asm/asm-offsets.h
 create mode 100644 arch/arc/include/asm/atomic.h
 create mode 100644 arch/arc/include/asm/barrier.h
 create mode 100644 arch/arc/include/asm/bitops.h
 create mode 100644 arch/arc/include/asm/bug.h
 create mode 100644 arch/arc/include/asm/cache.h
 create mode 100644 arch/arc/include/asm/cacheflush.h
 create mode 100644 arch/arc/include/asm/checksum.h
 create mode 100644 arch/arc/include/asm/clk.h
 create mode 100644 arch/arc/include/asm/cmpxchg.h
 create mode 100644 arch/arc/include/asm/current.h
 create mode 100644 arch/arc/include/asm/defines.h
 create mode 100644 arch/arc/include/asm/delay.h
 create mode 100644 arch/arc/include/asm/disasm.h
 create mode 100644 arch/arc/include/asm/dma-mapping.h
 create mode 100644 arch/arc/include/asm/dma.h
 create mode 100644 arch/arc/include/asm/elf.h
 create mode 100644 arch/arc/include/asm/entry.h
 create mode 100644 arch/arc/include/asm/exec.h
 create mode 100644 arch/arc/include/asm/futex.h
 create mode 100644 arch/arc/include/asm/io.h
 create mode 100644 arch/arc/include/asm/irq.h
 create mode 100644 arch/arc/include/asm/irqflags.h
 create mode 100644 arch/arc/include/asm/kdebug.h
 create mode 100644 arch/arc/include/asm/kgdb.h
 create mode 100644 arch/arc/include/asm/kprobes.h
 create mode 100644 arch/arc/include/asm/linkage.h
 create mode 100644 arch/arc/include/asm/mach_desc.h
 create mode 100644 arch/arc/include/asm/mmu.h
 create mode 100644 arch/arc/include/asm/mmu_context.h
 create mode 100644 arch/arc/include/asm/module.h
 create mode 100644 arch/arc/include/asm/mutex.h
 create mode 100644 arch/arc/include/asm/page.h
 create mode 100644 arch/arc/include/asm/perf_event.h
 create mode 100644 arch/arc/include/asm/pgalloc.h
 create mode 100644 arch/arc/include/asm/pgtable.h
 create mode 100644 arch/arc/include/asm/processor.h
 create mode 100644 arch/arc/include/asm/prom.h
 create mode 100644 arch/arc/include/asm/ptrace.h
 create mode 100644 arch/arc/include/asm/sections.h
 create mode 100644 arch/arc/include/asm/segment.h
 create mode 100644 arch/arc/include/asm/serial.h
 create mode 100644 arch/arc/include/asm/setup.h
 create mode 100644 arch/arc/include/asm/smp.h
 create mode 100644 arch/arc/include/asm/spinlock.h
 create mode 100644 arch/arc/include/asm/spinlock_types.h
 create mode 100644 arch/arc/include/asm/string.h
 create mode 100644 arch/arc/include/asm/switch_to.h
 create mode 100644 arch/arc/include/asm/syscall.h
 create mode 100644 arch/arc/include/asm/syscalls.h
 create mode 100644 arch/arc/include/asm/thread_info.h
 create mode 100644 arch/arc/include/asm/timex.h
 create mode 100644 arch/arc/include/asm/tlb-mmu1.h
 create mode 100644 arch/arc/include/asm/tlb.h
 create mode 100644 arch/arc/include/asm/tlbflush.h
 create mode 100644 arch/arc/include/asm/uaccess.h
 create mode 100644 arch/arc/include/asm/unaligned.h
 create mode 100644 arch/arc/include/asm/unwind.h
 create mode 100644 arch/arc/include/uapi/asm/Kbuild
 create mode 100644 arch/arc/include/uapi/asm/byteorder.h
 create mode 100644 arch/arc/include/uapi/asm/cachectl.h
 create mode 100644 arch/arc/include/uapi/asm/page.h
 create mode 100644 arch/arc/include/uapi/asm/ptrace.h
 create mode 100644 arch/arc/include/uapi/asm/setup.h
 create mode 100644 arch/arc/include/uapi/asm/sigcontext.h
 create mode 100644 arch/arc/include/uapi/asm/signal.h
 create mode 100644 arch/arc/include/uapi/asm/swab.h
 create mode 100644 arch/arc/include/uapi/asm/unistd.h
 create mode 100644 arch/arc/kernel/Makefile
 create mode 100644 arch/arc/kernel/arc_hostlink.c
 create mode 100644 arch/arc/kernel/arcksyms.c
 create mode 100644 arch/arc/kernel/asm-offsets.c
 create mode 100644 arch/arc/kernel/clk.c
 create mode 100644 arch/arc/kernel/ctx_sw.c
 create mode 100644 arch/arc/kernel/ctx_sw_asm.S
 create mode 100644 arch/arc/kernel/devtree.c
 create mode 100644 arch/arc/kernel/disasm.c
 create mode 100644 arch/arc/kernel/entry.S
 create mode 100644 arch/arc/kernel/fpu.c
 create mode 100644 arch/arc/kernel/head.S
 create mode 100644 arch/arc/kernel/irq.c
 create mode 100644 arch/arc/kernel/kgdb.c
 create mode 100644 arch/arc/kernel/kprobes.c
 create mode 100644 arch/arc/kernel/module.c
 create mode 100644 arch/arc/kernel/process.c
 create mode 100644 arch/arc/kernel/ptrace.c
 create mode 100644 arch/arc/kernel/reset.c
 create mode 100644 arch/arc/kernel/setup.c
 create mode 100644 arch/arc/kernel/signal.c
 create mode 100644 arch/arc/kernel/smp.c
 create mode 100644 arch/arc/kernel/stacktrace.c
 create mode 100644 arch/arc/kernel/sys.c
 create mode 100644 arch/arc/kernel/time.c
 create mode 100644 arch/arc/kernel/traps.c
 create mode 100644 arch/arc/kernel/troubleshoot.c
 create mode 100644 arch/arc/kernel/unaligned.c
 create mode 100644 arch/arc/kernel/unwind.c
 create mode 100644 arch/arc/kernel/vmlinux.lds.S
 create mode 100644 arch/arc/lib/Makefile
 create mode 100644 arch/arc/lib/memcmp.S
 create mode 100644 arch/arc/lib/memcpy-700.S
 create mode 100644 arch/arc/lib/memset.S
 create mode 100644 arch/arc/lib/strchr-700.S
 create mode 100644 arch/arc/lib/strcmp.S
 create mode 100644 arch/arc/lib/strcpy-700.S
 create mode 100644 arch/arc/lib/strlen.S
 create mode 100644 arch/arc/mm/Makefile
 create mode 100644 arch/arc/mm/cache_arc700.c
 create mode 100644 arch/arc/mm/dma.c
 create mode 100644 arch/arc/mm/extable.c
 create mode 100644 arch/arc/mm/fault.c
 create mode 100644 arch/arc/mm/init.c
 create mode 100644 arch/arc/mm/ioremap.c
 create mode 100644 arch/arc/mm/tlb.c
 create mode 100644 arch/arc/mm/tlbex.S
 create mode 100644 arch/arc/oprofile/Makefile
 create mode 100644 arch/arc/oprofile/common.c
 create mode 100644 arch/arc/plat-arcfpga/Kconfig
 create mode 100644 arch/arc/plat-arcfpga/Makefile
 create mode 100644 arch/arc/plat-arcfpga/include/plat/irq.h
 create mode 100644 arch/arc/plat-arcfpga/include/plat/memmap.h
 create mode 100644 arch/arc/plat-arcfpga/include/plat/smp.h
 create mode 100644 arch/arc/plat-arcfpga/irq.c
 create mode 100644 arch/arc/plat-arcfpga/platform.c
 create mode 100644 arch/arc/plat-arcfpga/smp.c

-- 
1.7.4.1

