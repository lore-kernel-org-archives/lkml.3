Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab3CBVkk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 16:40:40 -0500
Received: from multi.imgtec.com ([194.200.65.239]:17058 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab3CBVkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 16:40:39 -0500
Message-ID: <513271C2.5090909@imgtec.com>
Date: Sat, 2 Mar 2013 21:40:18 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arnd <arnd@arndb.de>, linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT PULL] late arch/metag fixes for v3.9-rc1
References: <5130DD94.2060408@imgtec.com> <CA+55aFw9qvUdrtEk_83-gEjZMTceONk=AuVsHuTtqOj=jpVPQg@mail.gmail.com> <5130F978.9040604@imgtec.com> <5131D2F0.2010705@imgtec.com> <CA+55aFx1wKChQmAWgQR0iOdKr0bhLn7RLsZHj5ZuVVOtk8FXMw@mail.gmail.com> <51324D92.5090100@imgtec.com>
In-Reply-To: <51324D92.5090100@imgtec.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_03_02_21_40_37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's the arch/metag tree for v3.9-rc1, based on v3.8. Details can be
found in tag message.

The hard conflicts when merging are all trivial. There is a build fix
required after merging though. Commit 373d4d ("taint: add explicit flag
to show whether lock dep is still OK") adds a flags argument to
add_taint that causes:

arch/metag/kernel/traps.c In function 'die':
arch/metag/kernel/traps.c +110 : error: too few arguments to function 'add_taint'

The fix is like the others in the aforementioned commit:

diff --git a/arch/metag/kernel/traps.c b/arch/metag/kernel/traps.c
index 5cad156..8961f24 100644
--- a/arch/metag/kernel/traps.c
+++ b/arch/metag/kernel/traps.c
@@ -107,7 +107,7 @@ void die(const char *str, struct pt_regs *regs, long err,
 	       task_pid_nr(current), task_stack_page(current) + THREAD_SIZE);
 
 	bust_spinlocks(0);
-	add_taint(TAINT_DIE);
+	add_taint(TAINT_DIE, LOCKDEP_NOW_UNRELIABLE);
 	if (kexec_should_crash(current))
 		crash_kexec(regs);
 
The other integration issues expected are all harmless, so I'm happy to
fix these up in a later set of patches if you prefer:

* arch/metag/Kconfig: CONFIG_METAG selects GENERIC_SIGALTSTACK which no
  longer exists since d64008a ("burying unused conditionals")
* arch/metag/Kconfig: CONFIG_METAG selects HAVE_IRQ_WORK which no longer
  exists since cf9b286 ("metag: remove select CONFIG_HAVE_IRQ_WORK")
* arch/metag/Kconfig: defines ARCH_NO_VIRT_TO_BUS which no longer does
  anything since 887cbce0 ("arch Kconfig: centralise
  CONFIG_ARCH_NO_VIRT_TO_BUS")
* arch/metag/configs/*: CONFIG_EXPERIMENTAL=y no longer needed

Please consider pulling.

Thanks
James

The following changes since commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200:

  Linux 3.8 (2013-02-18 15:58:34 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jhogan/metag.git tags/metag-v3.9-rc1-v4

for you to fetch changes up to c60ac31542e93499b58dcfc1e3f6550ba5b5728e:

  metag: Provide dma_get_sgtable() (2013-03-02 20:11:17 +0000)

----------------------------------------------------------------
ImgTec Meta architecture changes for v3.9-rc1

This adds core architecture support for Imagination's Meta processor
cores, followed by some later miscellaneous arch/metag cleanups and
fixes which I kept separate to ease review:

 - Support for basic Meta 1 (ATP) and Meta 2 (HTP) core architecture
 - A few fixes all over, particularly for symbol prefixes
 - A few privilege protection fixes
 - Several cleanups (setup.c includes, split out a lot of metag_ksyms.c)
 - Fix some missing exports
 - Convert hugetlb to use vm_unmapped_area()
 - Copy device tree to non-init memory
 - Provide dma_get_sgtable()

Signed-off-by: James Hogan <james.hogan@imgtec.com>

----------------------------------------------------------------
James Hogan (61):
      asm-generic/io.h: check CONFIG_VIRT_TO_BUS
      asm-generic/unistd.h: handle symbol prefixes in cond_syscall
      Revert some of "binfmt_elf: cleanups"
      Add HAVE_64BIT_ALIGNED_ACCESS
      trace/ring_buffer: handle 64bit aligned structs
      metag: Add MAINTAINERS entry
      metag: Headers for core arch constants
      metag: Header for core memory mapped registers
      metag: Boot
      metag: TBX header
      metag: TBX source
      metag: Cache/TLB handling
      metag: Memory management
      metag: Memory handling
      metag: Huge TLB
      metag: Highmem support
      metag: TCM support
      metag: Signal handling
      metag: Device tree
      metag: ptrace
      metag: Time keeping
      metag: Traps
      metag: IRQ handling
      metag: Internal and external irqchips
      metag: System Calls
      metag: Scheduling/Process management
      metag: Module support
      metag: Atomics, locks and bitops
      metag: Basic documentation
      metag: SMP support
      metag: DMA
      metag: Optimised library functions
      metag: Stack unwinding
      metag: Various other headers
      mm: define VM_GROWSUP for CONFIG_METAG
      Kconfig.debug: add METAG to dependency lists
      metag: Build infrastructure
      metag: Perf
      metag: ftrace support
      scripts/checkstack.pl: Add metag support
      metag: Add JTAG Debug Adapter (DA) support
      metag: add __init to metag_cache_probe()
      metag: add boot time LNKGET/LNKSET check
      perf: Enable building perf tools for Meta
      metag: kernel/setup.c: sort includes
      metag: make TXPRIVEXT bits explicit
      metag: protect more non-MMU memory regions
      metag: export metag_code_cache_flush_all
      metag: export clear_page and copy_page
      metag: hugetlb: convert to vm_unmapped_area()
      genksyms: fix metag symbol prefix on crc symbols
      metag: move irq enable out of irqflags.h on SMP
      metag: move traps.c exports out of metag_ksyms.c
      metag: move kick.c exports out of metag_ksyms.c
      metag: move setup.c exports out of metag_ksyms.c
      metag: move usercopy.c exports out of metag_ksyms.c
      metag: move mm/init.c exports out of metag_ksyms.c
      metag: cleanup metag_ksyms.c includes
      metag: copy devicetree to non-init memory
      metag: prom.h: remove declaration of metag_dt_memblock_reserve()
      metag: Provide dma_get_sgtable()

 Documentation/00-INDEX                             |    2 +
 .../devicetree/bindings/metag/meta-intc.txt        |   82 ++
 Documentation/kernel-parameters.txt                |    4 +
 Documentation/metag/00-INDEX                       |    4 +
 Documentation/metag/kernel-ABI.txt                 |  256 ++++
 MAINTAINERS                                        |   12 +
 arch/Kconfig                                       |   16 +
 arch/metag/Kconfig                                 |  295 ++++
 arch/metag/Kconfig.debug                           |   40 +
 arch/metag/Kconfig.soc                             |   55 +
 arch/metag/Makefile                                |   87 ++
 arch/metag/boot/.gitignore                         |    4 +
 arch/metag/boot/Makefile                           |   68 +
 arch/metag/boot/dts/Makefile                       |   16 +
 arch/metag/boot/dts/skeleton.dts                   |   10 +
 arch/metag/boot/dts/skeleton.dtsi                  |   14 +
 arch/metag/configs/meta1_defconfig                 |   41 +
 arch/metag/configs/meta2_defconfig                 |   42 +
 arch/metag/configs/meta2_smp_defconfig             |   43 +
 arch/metag/include/asm/Kbuild                      |   54 +
 arch/metag/include/asm/atomic.h                    |   53 +
 arch/metag/include/asm/atomic_lnkget.h             |  234 ++++
 arch/metag/include/asm/atomic_lock1.h              |  160 +++
 arch/metag/include/asm/barrier.h                   |   85 ++
 arch/metag/include/asm/bitops.h                    |  132 ++
 arch/metag/include/asm/bug.h                       |   12 +
 arch/metag/include/asm/cache.h                     |   23 +
 arch/metag/include/asm/cacheflush.h                |  250 ++++
 arch/metag/include/asm/cachepart.h                 |   42 +
 arch/metag/include/asm/checksum.h                  |   92 ++
 arch/metag/include/asm/clock.h                     |   51 +
 arch/metag/include/asm/cmpxchg.h                   |   65 +
 arch/metag/include/asm/cmpxchg_irq.h               |   42 +
 arch/metag/include/asm/cmpxchg_lnkget.h            |   86 ++
 arch/metag/include/asm/cmpxchg_lock1.h             |   48 +
 arch/metag/include/asm/core_reg.h                  |   35 +
 arch/metag/include/asm/cpu.h                       |   14 +
 arch/metag/include/asm/da.h                        |   43 +
 arch/metag/include/asm/delay.h                     |   29 +
 arch/metag/include/asm/div64.h                     |   12 +
 arch/metag/include/asm/dma-mapping.h               |  190 +++
 arch/metag/include/asm/elf.h                       |  128 ++
 arch/metag/include/asm/fixmap.h                    |   99 ++
 arch/metag/include/asm/ftrace.h                    |   23 +
 arch/metag/include/asm/global_lock.h               |  100 ++
 arch/metag/include/asm/gpio.h                      |    4 +
 arch/metag/include/asm/highmem.h                   |   62 +
 arch/metag/include/asm/hugetlb.h                   |   86 ++
 arch/metag/include/asm/hwthread.h                  |   40 +
 arch/metag/include/asm/io.h                        |  165 +++
 arch/metag/include/asm/irq.h                       |   32 +
 arch/metag/include/asm/irqflags.h                  |   93 ++
 arch/metag/include/asm/l2cache.h                   |  258 ++++
 arch/metag/include/asm/linkage.h                   |    7 +
 arch/metag/include/asm/mach/arch.h                 |   86 ++
 arch/metag/include/asm/metag_isa.h                 |   81 ++
 arch/metag/include/asm/metag_mem.h                 | 1106 +++++++++++++++
 arch/metag/include/asm/metag_regs.h                | 1184 ++++++++++++++++
 arch/metag/include/asm/mman.h                      |   11 +
 arch/metag/include/asm/mmu.h                       |   77 ++
 arch/metag/include/asm/mmu_context.h               |  113 ++
 arch/metag/include/asm/mmzone.h                    |   42 +
 arch/metag/include/asm/module.h                    |   37 +
 arch/metag/include/asm/page.h                      |  128 ++
 arch/metag/include/asm/perf_event.h                |    4 +
 arch/metag/include/asm/pgalloc.h                   |   79 ++
 arch/metag/include/asm/pgtable.h                   |  370 +++++
 arch/metag/include/asm/processor.h                 |  202 +++
 arch/metag/include/asm/prom.h                      |   23 +
 arch/metag/include/asm/ptrace.h                    |   60 +
 arch/metag/include/asm/setup.h                     |    8 +
 arch/metag/include/asm/smp.h                       |   29 +
 arch/metag/include/asm/sparsemem.h                 |   13 +
 arch/metag/include/asm/spinlock.h                  |   22 +
 arch/metag/include/asm/spinlock_lnkget.h           |  249 ++++
 arch/metag/include/asm/spinlock_lock1.h            |  184 +++
 arch/metag/include/asm/spinlock_types.h            |   20 +
 arch/metag/include/asm/stacktrace.h                |   20 +
 arch/metag/include/asm/string.h                    |   13 +
 arch/metag/include/asm/switch.h                    |   21 +
 arch/metag/include/asm/syscall.h                   |  104 ++
 arch/metag/include/asm/syscalls.h                  |   39 +
 arch/metag/include/asm/tbx.h                       | 1425 ++++++++++++++++++++
 arch/metag/include/asm/tcm.h                       |   30 +
 arch/metag/include/asm/thread_info.h               |  155 +++
 arch/metag/include/asm/tlb.h                       |   36 +
 arch/metag/include/asm/tlbflush.h                  |   77 ++
 arch/metag/include/asm/topology.h                  |   53 +
 arch/metag/include/asm/traps.h                     |   48 +
 arch/metag/include/asm/uaccess.h                   |  241 ++++
 arch/metag/include/asm/unistd.h                    |   12 +
 arch/metag/include/asm/user_gateway.h              |   44 +
 arch/metag/include/uapi/asm/Kbuild                 |   13 +
 arch/metag/include/uapi/asm/byteorder.h            |    1 +
 arch/metag/include/uapi/asm/ptrace.h               |  113 ++
 arch/metag/include/uapi/asm/resource.h             |    7 +
 arch/metag/include/uapi/asm/sigcontext.h           |   31 +
 arch/metag/include/uapi/asm/siginfo.h              |    8 +
 arch/metag/include/uapi/asm/swab.h                 |   26 +
 arch/metag/include/uapi/asm/unistd.h               |   21 +
 arch/metag/kernel/.gitignore                       |    1 +
 arch/metag/kernel/Makefile                         |   39 +
 arch/metag/kernel/asm-offsets.c                    |   14 +
 arch/metag/kernel/cachepart.c                      |  124 ++
 arch/metag/kernel/clock.c                          |   53 +
 arch/metag/kernel/core_reg.c                       |  117 ++
 arch/metag/kernel/da.c                             |   23 +
 arch/metag/kernel/devtree.c                        |  114 ++
 arch/metag/kernel/dma.c                            |  507 +++++++
 arch/metag/kernel/ftrace.c                         |  126 ++
 arch/metag/kernel/ftrace_stub.S                    |   76 ++
 arch/metag/kernel/head.S                           |   57 +
 arch/metag/kernel/irq.c                            |  323 +++++
 arch/metag/kernel/kick.c                           |  101 ++
 arch/metag/kernel/machines.c                       |   20 +
 arch/metag/kernel/metag_ksyms.c                    |   49 +
 arch/metag/kernel/module.c                         |  284 ++++
 arch/metag/kernel/perf/Makefile                    |    3 +
 arch/metag/kernel/perf/perf_event.c                |  861 ++++++++++++
 arch/metag/kernel/perf/perf_event.h                |  106 ++
 arch/metag/kernel/perf_callchain.c                 |   96 ++
 arch/metag/kernel/process.c                        |  461 +++++++
 arch/metag/kernel/ptrace.c                         |  380 ++++++
 arch/metag/kernel/setup.c                          |  631 +++++++++
 arch/metag/kernel/signal.c                         |  344 +++++
 arch/metag/kernel/smp.c                            |  575 ++++++++
 arch/metag/kernel/stacktrace.c                     |  187 +++
 arch/metag/kernel/sys_metag.c                      |  180 +++
 arch/metag/kernel/tbiunexp.S                       |   22 +
 arch/metag/kernel/tcm.c                            |  151 +++
 arch/metag/kernel/time.c                           |   15 +
 arch/metag/kernel/topology.c                       |   77 ++
 arch/metag/kernel/traps.c                          |  995 ++++++++++++++
 arch/metag/kernel/user_gateway.S                   |   97 ++
 arch/metag/kernel/vmlinux.lds.S                    |   71 +
 arch/metag/lib/Makefile                            |   22 +
 arch/metag/lib/ashldi3.S                           |   33 +
 arch/metag/lib/ashrdi3.S                           |   33 +
 arch/metag/lib/checksum.c                          |  168 +++
 arch/metag/lib/clear_page.S                        |   17 +
 arch/metag/lib/cmpdi2.S                            |   32 +
 arch/metag/lib/copy_page.S                         |   20 +
 arch/metag/lib/delay.c                             |   56 +
 arch/metag/lib/div64.S                             |  108 ++
 arch/metag/lib/divsi3.S                            |  100 ++
 arch/metag/lib/ip_fast_csum.S                      |   32 +
 arch/metag/lib/lshrdi3.S                           |   33 +
 arch/metag/lib/memcpy.S                            |  185 +++
 arch/metag/lib/memmove.S                           |  345 +++++
 arch/metag/lib/memset.S                            |   86 ++
 arch/metag/lib/modsi3.S                            |   38 +
 arch/metag/lib/muldi3.S                            |   44 +
 arch/metag/lib/ucmpdi2.S                           |   27 +
 arch/metag/lib/usercopy.c                          | 1354 +++++++++++++++++++
 arch/metag/mm/Kconfig                              |  153 +++
 arch/metag/mm/Makefile                             |   19 +
 arch/metag/mm/cache.c                              |  521 +++++++
 arch/metag/mm/extable.c                            |   15 +
 arch/metag/mm/fault.c                              |  239 ++++
 arch/metag/mm/highmem.c                            |  133 ++
 arch/metag/mm/hugetlbpage.c                        |  259 ++++
 arch/metag/mm/init.c                               |  451 +++++++
 arch/metag/mm/ioremap.c                            |   89 ++
 arch/metag/mm/l2cache.c                            |  192 +++
 arch/metag/mm/maccess.c                            |   68 +
 arch/metag/mm/mmu-meta1.c                          |  157 +++
 arch/metag/mm/mmu-meta2.c                          |  207 +++
 arch/metag/mm/numa.c                               |   81 ++
 arch/metag/tbx/Makefile                            |   21 +
 arch/metag/tbx/tbicore.S                           |  136 ++
 arch/metag/tbx/tbictx.S                            |  366 +++++
 arch/metag/tbx/tbictxfpu.S                         |  190 +++
 arch/metag/tbx/tbidefr.S                           |  175 +++
 arch/metag/tbx/tbidspram.S                         |  161 +++
 arch/metag/tbx/tbilogf.S                           |   48 +
 arch/metag/tbx/tbipcx.S                            |  451 +++++++
 arch/metag/tbx/tbiroot.S                           |   87 ++
 arch/metag/tbx/tbisoft.S                           |  237 ++++
 arch/metag/tbx/tbistring.c                         |  114 ++
 arch/metag/tbx/tbitimer.S                          |  207 +++
 drivers/clocksource/Kconfig                        |    5 +
 drivers/clocksource/Makefile                       |    1 +
 drivers/clocksource/metag_generic.c                |  198 +++
 drivers/irqchip/Makefile                           |    2 +
 drivers/irqchip/irq-metag-ext.c                    |  868 ++++++++++++
 drivers/irqchip/irq-metag.c                        |  343 +++++
 fs/binfmt_elf.c                                    |    4 +
 include/asm-generic/io.h                           |    2 +
 include/asm-generic/unistd.h                       |    9 +-
 include/clocksource/metag_generic.h                |   21 +
 include/linux/irqchip/metag-ext.h                  |   33 +
 include/linux/irqchip/metag.h                      |   24 +
 include/linux/mm.h                                 |    2 +
 include/uapi/linux/elf.h                           |    2 +
 kernel/trace/ring_buffer.c                         |    6 +-
 lib/Kconfig.debug                                  |    4 +-
 scripts/checkstack.pl                              |    8 +-
 scripts/genksyms/genksyms.c                        |    3 +-
 scripts/recordmcount.c                             |   13 +
 tools/perf/perf.h                                  |    6 +
 200 files changed, 26942 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/metag/meta-intc.txt
 create mode 100644 Documentation/metag/00-INDEX
 create mode 100644 Documentation/metag/kernel-ABI.txt
 create mode 100644 arch/metag/Kconfig
 create mode 100644 arch/metag/Kconfig.debug
 create mode 100644 arch/metag/Kconfig.soc
 create mode 100644 arch/metag/Makefile
 create mode 100644 arch/metag/boot/.gitignore
 create mode 100644 arch/metag/boot/Makefile
 create mode 100644 arch/metag/boot/dts/Makefile
 create mode 100644 arch/metag/boot/dts/skeleton.dts
 create mode 100644 arch/metag/boot/dts/skeleton.dtsi
 create mode 100644 arch/metag/configs/meta1_defconfig
 create mode 100644 arch/metag/configs/meta2_defconfig
 create mode 100644 arch/metag/configs/meta2_smp_defconfig
 create mode 100644 arch/metag/include/asm/Kbuild
 create mode 100644 arch/metag/include/asm/atomic.h
 create mode 100644 arch/metag/include/asm/atomic_lnkget.h
 create mode 100644 arch/metag/include/asm/atomic_lock1.h
 create mode 100644 arch/metag/include/asm/barrier.h
 create mode 100644 arch/metag/include/asm/bitops.h
 create mode 100644 arch/metag/include/asm/bug.h
 create mode 100644 arch/metag/include/asm/cache.h
 create mode 100644 arch/metag/include/asm/cacheflush.h
 create mode 100644 arch/metag/include/asm/cachepart.h
 create mode 100644 arch/metag/include/asm/checksum.h
 create mode 100644 arch/metag/include/asm/clock.h
 create mode 100644 arch/metag/include/asm/cmpxchg.h
 create mode 100644 arch/metag/include/asm/cmpxchg_irq.h
 create mode 100644 arch/metag/include/asm/cmpxchg_lnkget.h
 create mode 100644 arch/metag/include/asm/cmpxchg_lock1.h
 create mode 100644 arch/metag/include/asm/core_reg.h
 create mode 100644 arch/metag/include/asm/cpu.h
 create mode 100644 arch/metag/include/asm/da.h
 create mode 100644 arch/metag/include/asm/delay.h
 create mode 100644 arch/metag/include/asm/div64.h
 create mode 100644 arch/metag/include/asm/dma-mapping.h
 create mode 100644 arch/metag/include/asm/elf.h
 create mode 100644 arch/metag/include/asm/fixmap.h
 create mode 100644 arch/metag/include/asm/ftrace.h
 create mode 100644 arch/metag/include/asm/global_lock.h
 create mode 100644 arch/metag/include/asm/gpio.h
 create mode 100644 arch/metag/include/asm/highmem.h
 create mode 100644 arch/metag/include/asm/hugetlb.h
 create mode 100644 arch/metag/include/asm/hwthread.h
 create mode 100644 arch/metag/include/asm/io.h
 create mode 100644 arch/metag/include/asm/irq.h
 create mode 100644 arch/metag/include/asm/irqflags.h
 create mode 100644 arch/metag/include/asm/l2cache.h
 create mode 100644 arch/metag/include/asm/linkage.h
 create mode 100644 arch/metag/include/asm/mach/arch.h
 create mode 100644 arch/metag/include/asm/metag_isa.h
 create mode 100644 arch/metag/include/asm/metag_mem.h
 create mode 100644 arch/metag/include/asm/metag_regs.h
 create mode 100644 arch/metag/include/asm/mman.h
 create mode 100644 arch/metag/include/asm/mmu.h
 create mode 100644 arch/metag/include/asm/mmu_context.h
 create mode 100644 arch/metag/include/asm/mmzone.h
 create mode 100644 arch/metag/include/asm/module.h
 create mode 100644 arch/metag/include/asm/page.h
 create mode 100644 arch/metag/include/asm/perf_event.h
 create mode 100644 arch/metag/include/asm/pgalloc.h
 create mode 100644 arch/metag/include/asm/pgtable.h
 create mode 100644 arch/metag/include/asm/processor.h
 create mode 100644 arch/metag/include/asm/prom.h
 create mode 100644 arch/metag/include/asm/ptrace.h
 create mode 100644 arch/metag/include/asm/setup.h
 create mode 100644 arch/metag/include/asm/smp.h
 create mode 100644 arch/metag/include/asm/sparsemem.h
 create mode 100644 arch/metag/include/asm/spinlock.h
 create mode 100644 arch/metag/include/asm/spinlock_lnkget.h
 create mode 100644 arch/metag/include/asm/spinlock_lock1.h
 create mode 100644 arch/metag/include/asm/spinlock_types.h
 create mode 100644 arch/metag/include/asm/stacktrace.h
 create mode 100644 arch/metag/include/asm/string.h
 create mode 100644 arch/metag/include/asm/switch.h
 create mode 100644 arch/metag/include/asm/syscall.h
 create mode 100644 arch/metag/include/asm/syscalls.h
 create mode 100644 arch/metag/include/asm/tbx.h
 create mode 100644 arch/metag/include/asm/tcm.h
 create mode 100644 arch/metag/include/asm/thread_info.h
 create mode 100644 arch/metag/include/asm/tlb.h
 create mode 100644 arch/metag/include/asm/tlbflush.h
 create mode 100644 arch/metag/include/asm/topology.h
 create mode 100644 arch/metag/include/asm/traps.h
 create mode 100644 arch/metag/include/asm/uaccess.h
 create mode 100644 arch/metag/include/asm/unistd.h
 create mode 100644 arch/metag/include/asm/user_gateway.h
 create mode 100644 arch/metag/include/uapi/asm/Kbuild
 create mode 100644 arch/metag/include/uapi/asm/byteorder.h
 create mode 100644 arch/metag/include/uapi/asm/ptrace.h
 create mode 100644 arch/metag/include/uapi/asm/resource.h
 create mode 100644 arch/metag/include/uapi/asm/sigcontext.h
 create mode 100644 arch/metag/include/uapi/asm/siginfo.h
 create mode 100644 arch/metag/include/uapi/asm/swab.h
 create mode 100644 arch/metag/include/uapi/asm/unistd.h
 create mode 100644 arch/metag/kernel/.gitignore
 create mode 100644 arch/metag/kernel/Makefile
 create mode 100644 arch/metag/kernel/asm-offsets.c
 create mode 100644 arch/metag/kernel/cachepart.c
 create mode 100644 arch/metag/kernel/clock.c
 create mode 100644 arch/metag/kernel/core_reg.c
 create mode 100644 arch/metag/kernel/da.c
 create mode 100644 arch/metag/kernel/devtree.c
 create mode 100644 arch/metag/kernel/dma.c
 create mode 100644 arch/metag/kernel/ftrace.c
 create mode 100644 arch/metag/kernel/ftrace_stub.S
 create mode 100644 arch/metag/kernel/head.S
 create mode 100644 arch/metag/kernel/irq.c
 create mode 100644 arch/metag/kernel/kick.c
 create mode 100644 arch/metag/kernel/machines.c
 create mode 100644 arch/metag/kernel/metag_ksyms.c
 create mode 100644 arch/metag/kernel/module.c
 create mode 100644 arch/metag/kernel/perf/Makefile
 create mode 100644 arch/metag/kernel/perf/perf_event.c
 create mode 100644 arch/metag/kernel/perf/perf_event.h
 create mode 100644 arch/metag/kernel/perf_callchain.c
 create mode 100644 arch/metag/kernel/process.c
 create mode 100644 arch/metag/kernel/ptrace.c
 create mode 100644 arch/metag/kernel/setup.c
 create mode 100644 arch/metag/kernel/signal.c
 create mode 100644 arch/metag/kernel/smp.c
 create mode 100644 arch/metag/kernel/stacktrace.c
 create mode 100644 arch/metag/kernel/sys_metag.c
 create mode 100644 arch/metag/kernel/tbiunexp.S
 create mode 100644 arch/metag/kernel/tcm.c
 create mode 100644 arch/metag/kernel/time.c
 create mode 100644 arch/metag/kernel/topology.c
 create mode 100644 arch/metag/kernel/traps.c
 create mode 100644 arch/metag/kernel/user_gateway.S
 create mode 100644 arch/metag/kernel/vmlinux.lds.S
 create mode 100644 arch/metag/lib/Makefile
 create mode 100644 arch/metag/lib/ashldi3.S
 create mode 100644 arch/metag/lib/ashrdi3.S
 create mode 100644 arch/metag/lib/checksum.c
 create mode 100644 arch/metag/lib/clear_page.S
 create mode 100644 arch/metag/lib/cmpdi2.S
 create mode 100644 arch/metag/lib/copy_page.S
 create mode 100644 arch/metag/lib/delay.c
 create mode 100644 arch/metag/lib/div64.S
 create mode 100644 arch/metag/lib/divsi3.S
 create mode 100644 arch/metag/lib/ip_fast_csum.S
 create mode 100644 arch/metag/lib/lshrdi3.S
 create mode 100644 arch/metag/lib/memcpy.S
 create mode 100644 arch/metag/lib/memmove.S
 create mode 100644 arch/metag/lib/memset.S
 create mode 100644 arch/metag/lib/modsi3.S
 create mode 100644 arch/metag/lib/muldi3.S
 create mode 100644 arch/metag/lib/ucmpdi2.S
 create mode 100644 arch/metag/lib/usercopy.c
 create mode 100644 arch/metag/mm/Kconfig
 create mode 100644 arch/metag/mm/Makefile
 create mode 100644 arch/metag/mm/cache.c
 create mode 100644 arch/metag/mm/extable.c
 create mode 100644 arch/metag/mm/fault.c
 create mode 100644 arch/metag/mm/highmem.c
 create mode 100644 arch/metag/mm/hugetlbpage.c
 create mode 100644 arch/metag/mm/init.c
 create mode 100644 arch/metag/mm/ioremap.c
 create mode 100644 arch/metag/mm/l2cache.c
 create mode 100644 arch/metag/mm/maccess.c
 create mode 100644 arch/metag/mm/mmu-meta1.c
 create mode 100644 arch/metag/mm/mmu-meta2.c
 create mode 100644 arch/metag/mm/numa.c
 create mode 100644 arch/metag/tbx/Makefile
 create mode 100644 arch/metag/tbx/tbicore.S
 create mode 100644 arch/metag/tbx/tbictx.S
 create mode 100644 arch/metag/tbx/tbictxfpu.S
 create mode 100644 arch/metag/tbx/tbidefr.S
 create mode 100644 arch/metag/tbx/tbidspram.S
 create mode 100644 arch/metag/tbx/tbilogf.S
 create mode 100644 arch/metag/tbx/tbipcx.S
 create mode 100644 arch/metag/tbx/tbiroot.S
 create mode 100644 arch/metag/tbx/tbisoft.S
 create mode 100644 arch/metag/tbx/tbistring.c
 create mode 100644 arch/metag/tbx/tbitimer.S
 create mode 100644 drivers/clocksource/metag_generic.c
 create mode 100644 drivers/irqchip/irq-metag-ext.c
 create mode 100644 drivers/irqchip/irq-metag.c
 create mode 100644 include/clocksource/metag_generic.h
 create mode 100644 include/linux/irqchip/metag-ext.h
 create mode 100644 include/linux/irqchip/metag.h

