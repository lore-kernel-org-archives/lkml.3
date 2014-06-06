Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbaFFOA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 10:00:59 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:43266 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751015AbaFFOA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 10:00:58 -0400
Date: Fri, 6 Jun 2014 15:00:37 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] arm64 patches for 3.16
Message-ID: <20140606140030.GA32685@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 patches below for 3.16. In addition, there are
core ftrace patches required for arm64 support which were pulled from
branch provided by Steve Rostedt (https://lkml.org/lkml/2014/5/27/289)
so they'll go into mainline either via the arm64 or the ftrace tree.

There are a couple merge conflicts with tip/arm64-efi and sched patches
already merged into your next branch. The conflict resolution is below
but please let me know if you prefer a different pull request with
tip/arm64-efi merged into my tree (TIF_POLLING_NRFLAG removal vs
TIF_SYSCALL_* addition and support for identity memory mapping
conflicting with pgprot clean-up).

The following changes since commit d6d211db37e75de2ddc3a4f979038c40df7cc79c:

  Linux 3.15-rc5 (2014-05-09 13:10:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux tags/arm64-upstream

for you to fetch changes up to 9358d755bd5cba8965ea79f2a446e689323409f9:

  arm64: kernel: initialize broadcast hrtimer based clock event device (2014-05-30 17:48:13 +0100)

----------------------------------------------------------------
- Optimised assembly string/memory routines (based on the AArch64 Cortex
  Strings library contributed to glibc but re-licensed under GPLv2)
- Optimised crypto algorithms making use of the ARMv8 crypto extensions
  (together with kernel API for using FPSIMD instructions in interrupt
  context)
- Ftrace support
- CPU topology parsing from DT
- ESR_EL1 (Exception Syndrome Register) exposed to user space signal
  handlers for SIGSEGV/SIGBUS (useful to emulation tools like Qemu)
- 1GB section linear mapping if applicable
- Barriers usage clean-up
- Default pgprot clean-up

-------- Conflict resolution -----------------------

diff --cc arch/arm64/include/asm/thread_info.h
index 7b8e3a2a00fb,9c086c63f911..e40b6d06d515
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@@ -99,7 -103,12 +102,11 @@@ static inline struct thread_info *curre
  #define TIF_SIGPENDING		0
  #define TIF_NEED_RESCHED	1
  #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
+ #define TIF_FOREIGN_FPSTATE	3	/* CPU's FP state is not current's */
  #define TIF_SYSCALL_TRACE	8
+ #define TIF_SYSCALL_AUDIT	9
+ #define TIF_SYSCALL_TRACEPOINT	10
+ #define TIF_SECCOMP		11
 -#define TIF_POLLING_NRFLAG	16
  #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
  #define TIF_FREEZE		19
  #define TIF_RESTORE_SIGMASK	20
diff --cc arch/arm64/mm/mmu.c
index 4a829a210bb6,3a729de96f15..c43f1dd19489
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@@ -192,17 -158,6 +160,16 @@@ static void __init alloc_init_pmd(pud_
  {
  	pmd_t *pmd;
  	unsigned long next;
 +	pmdval_t prot_sect;
 +	pgprot_t prot_pte;
 +
 +	if (map_io) {
- 		prot_sect = PMD_TYPE_SECT | PMD_SECT_AF |
- 			    PMD_ATTRINDX(MT_DEVICE_nGnRE);
++		prot_sect = PROT_SECT_DEVICE_nGnRE;
 +		prot_pte = __pgprot(PROT_DEVICE_nGnRE);
 +	} else {
- 		prot_sect = prot_sect_kernel;
++		prot_sect = PROT_SECT_NORMAL_EXEC;
 +		prot_pte = PAGE_KERNEL_EXEC;
 +	}
  
  	/*
  	 * Check for initial section mappings in the pgd/pud and remove them.
@@@ -242,7 -195,30 +209,30 @@@ static void __init alloc_init_pud(pgd_
  
  	do {
  		next = pud_addr_end(addr, end);
- 		alloc_init_pmd(pud, addr, next, phys, map_io);
+ 
+ 		/*
+ 		 * For 4K granule only, attempt to put down a 1GB block
+ 		 */
 -		if ((PAGE_SHIFT == 12) &&
++		if (!map_io && (PAGE_SHIFT == 12) &&
+ 		    ((addr | next | phys) & ~PUD_MASK) == 0) {
+ 			pud_t old_pud = *pud;
+ 			set_pud(pud, __pud(phys | PROT_SECT_NORMAL_EXEC));
+ 
+ 			/*
+ 			 * If we have an old value for a pud, it will
+ 			 * be pointing to a pmd table that we no longer
+ 			 * need (from swapper_pg_dir).
+ 			 *
+ 			 * Look up the old pmd table and free it.
+ 			 */
+ 			if (!pud_none(old_pud)) {
+ 				phys_addr_t table = __pa(pmd_offset(&old_pud, 0));
+ 				memblock_free(table, PAGE_SIZE);
+ 				flush_tlb_all();
+ 			}
+ 		} else {
 -			alloc_init_pmd(pud, addr, next, phys);
++			alloc_init_pmd(pud, addr, next, phys, map_io);
+ 		}
  		phys += next - addr;
  	} while (pud++, addr = next, addr != end);
  }


----------------------------------------------------------------
AKASHI Takahiro (12):
      arm64: make a single hook to syscall_trace() for all syscall features
      arm64: split syscall_trace() into separate functions for enter/exit
      arm64: Add regs_return_value() in syscall.h
      arm64: is_compat_task is defined both in asm/compat.h and linux/compat.h
      ftrace: Make CALLER_ADDRx macros more generic
      arm64: add __ASSEMBLY__ in asm/insn.h
      arm64: Add 'notrace' attribute to unwind_frame() for ftrace
      ftrace: Add arm64 support to recordmcount
      arm64: Add ftrace support
      arm64: ftrace: Add dynamic ftrace support
      arm64: ftrace: Add CALLER_ADDRx macros
      arm64: ftrace: Add system call tracepoint

Ard Biesheuvel (11):
      asm-generic: allow generic unaligned access if the arch supports it
      arm64: add abstractions for FPSIMD state manipulation
      arm64: defer reloading a task's FPSIMD state to userland resume
      arm64: add support for kernel mode NEON in interrupt context
      arm64/crypto: SHA-1 using ARMv8 Crypto Extensions
      arm64/crypto: SHA-224/SHA-256 using ARMv8 Crypto Extensions
      arm64/crypto: GHASH secure hash using ARMv8 Crypto Extensions
      arm64/crypto: AES using ARMv8 Crypto Extensions
      arm64/crypto: AES in CCM mode using ARMv8 Crypto Extensions
      arm64: pull in <asm/simd.h> from asm-generic
      arm64/crypto: AES-ECB/CBC/CTR/XTS using ARMv8 NEON and Crypto Extensions

Arun KS (2):
      arm64: Fix machine_shutdown() definition
      arm64: Fix deadlock scenario with smp_send_stop()

Bjorn Helgaas (1):
      arm64: Make atomic64_t() return "long", not "long long"

Catalin Marinas (9):
      arm64: Implement cache_line_size() based on CTR_EL0.CWG
      arm64: Remove boot thread synchronisation for spin-table release method
      arm64: Provide read/write fault information in compat signal handlers
      arm64: Remove the aux_context structure
      arm64: Expose ESR_EL1 information to user when SIGSEGV/SIGBUS
      arm64: Introduce execute-only page access permissions
      arm64: Clean up the default pgprot setting
      Merge tag 'for-3.16' of git://git.linaro.org/people/ard.biesheuvel/linux-arm into upstream
      Revert "arm64: Introduce execute-only page access permissions"

Geoff Levand (1):
      arm64: Fix linker script entry point

Larry Bassel (1):
      arm64: Support arch_irq_work_raise() via self IPIs

Lorenzo Pieralisi (1):
      arm64: kernel: initialize broadcast hrtimer based clock event device

Mark Brown (2):
      arm64: topology: Initialise default topology state immediately
      arm64: topology: Add support for topology DT bindings

Steve Capper (2):
      arm64: mm: Create gigabyte kernel logical mappings where possible
      arm64: mm: Optimise tlb flush logic where we have >4K granule

Will Deacon (10):
      arm64: xchg: prevent warning if return value is unused
      arm64: barriers: make use of barrier options with explicit barriers
      arm64: barriers: wire up new barrier options
      arm64: barriers: use barrier() instead of smp_mb() when !SMP
      arm64: head: fix cache flushing and barriers in set_cpu_boot_mode_flag
      arm64: kvm: use inner-shareable barriers for inner-shareable maintenance
      arm64: mm: use inner-shareable barriers for inner-shareable maintenance
      arm64: debug: avoid accessing mdscr_el1 on fault paths where possible
      arm64: defconfig: enable a few more common/useful options in defconfig
      Merge branch 'ftrace/arm64' of git://git.kernel.org/.../rostedt/linux-trace into for-next/core

Zi Shen Lim (1):
      arm64: sched: Remove unused mc_capable() and smt_capable()

zhichang.yuan (6):
      arm64: lib: Implement optimized memcpy routine
      arm64: lib: Implement optimized memmove routine
      arm64: lib: Implement optimized memset routine
      arm64: lib: Implement optimized memcmp routine
      arm64: lib: Implement optimized string compare routines
      arm64: lib: Implement optimized string length routines

 arch/arm/include/asm/ftrace.h            |  10 +-
 arch/arm64/Kconfig                       |  12 +
 arch/arm64/Makefile                      |   1 +
 arch/arm64/configs/defconfig             |  36 ++-
 arch/arm64/crypto/Kconfig                |  53 +++
 arch/arm64/crypto/Makefile               |  38 +++
 arch/arm64/crypto/aes-ce-ccm-core.S      | 222 +++++++++++++
 arch/arm64/crypto/aes-ce-ccm-glue.c      | 297 +++++++++++++++++
 arch/arm64/crypto/aes-ce-cipher.c        | 155 +++++++++
 arch/arm64/crypto/aes-ce.S               | 133 ++++++++
 arch/arm64/crypto/aes-glue.c             | 446 ++++++++++++++++++++++++++
 arch/arm64/crypto/aes-modes.S            | 532 +++++++++++++++++++++++++++++++
 arch/arm64/crypto/aes-neon.S             | 382 ++++++++++++++++++++++
 arch/arm64/crypto/ghash-ce-core.S        |  95 ++++++
 arch/arm64/crypto/ghash-ce-glue.c        | 155 +++++++++
 arch/arm64/crypto/sha1-ce-core.S         | 153 +++++++++
 arch/arm64/crypto/sha1-ce-glue.c         | 174 ++++++++++
 arch/arm64/crypto/sha2-ce-core.S         | 156 +++++++++
 arch/arm64/crypto/sha2-ce-glue.c         | 255 +++++++++++++++
 arch/arm64/include/asm/Kbuild            |   1 +
 arch/arm64/include/asm/assembler.h       |  23 +-
 arch/arm64/include/asm/atomic.h          |   2 +-
 arch/arm64/include/asm/barrier.h         |  20 +-
 arch/arm64/include/asm/cache.h           |  13 +-
 arch/arm64/include/asm/cacheflush.h      |   4 +-
 arch/arm64/include/asm/cachetype.h       |  11 +
 arch/arm64/include/asm/cmpxchg.h         |   7 +-
 arch/arm64/include/asm/compat.h          |   5 -
 arch/arm64/include/asm/esr.h             |   6 +-
 arch/arm64/include/asm/fpsimd.h          |  23 ++
 arch/arm64/include/asm/fpsimdmacros.h    |  35 ++
 arch/arm64/include/asm/ftrace.h          |  59 ++++
 arch/arm64/include/asm/hardirq.h         |   2 +-
 arch/arm64/include/asm/insn.h            |   2 +
 arch/arm64/include/asm/io.h              |   8 -
 arch/arm64/include/asm/neon.h            |   6 +-
 arch/arm64/include/asm/pgtable-hwdef.h   |   2 +
 arch/arm64/include/asm/pgtable.h         | 107 ++++---
 arch/arm64/include/asm/processor.h       |   1 +
 arch/arm64/include/asm/ptrace.h          |   5 +
 arch/arm64/include/asm/sigcontext.h      |  31 --
 arch/arm64/include/asm/string.h          |  15 +
 arch/arm64/include/asm/syscall.h         |   1 +
 arch/arm64/include/asm/thread_info.h     |  17 +-
 arch/arm64/include/asm/tlbflush.h        |  44 ++-
 arch/arm64/include/asm/topology.h        |   3 -
 arch/arm64/include/asm/unistd.h          |   2 +
 arch/arm64/include/uapi/asm/sigcontext.h |   7 +
 arch/arm64/kernel/Makefile               |   7 +-
 arch/arm64/kernel/arm64ksyms.c           |   9 +
 arch/arm64/kernel/entry-fpsimd.S         |  24 ++
 arch/arm64/kernel/entry-ftrace.S         | 218 +++++++++++++
 arch/arm64/kernel/entry.S                |  90 ++----
 arch/arm64/kernel/fpsimd.c               | 186 +++++++++--
 arch/arm64/kernel/ftrace.c               | 176 ++++++++++
 arch/arm64/kernel/head.S                 |   8 +-
 arch/arm64/kernel/hw_breakpoint.c        |   2 +-
 arch/arm64/kernel/process.c              |  49 ++-
 arch/arm64/kernel/ptrace.c               |  62 ++--
 arch/arm64/kernel/return_address.c       |  55 ++++
 arch/arm64/kernel/setup.c                |  16 +-
 arch/arm64/kernel/signal.c               |  52 ++-
 arch/arm64/kernel/signal32.c             |  16 +-
 arch/arm64/kernel/smp.c                  |  19 ++
 arch/arm64/kernel/smp_spin_table.c       |  39 +--
 arch/arm64/kernel/stacktrace.c           |   2 +-
 arch/arm64/kernel/time.c                 |   3 +
 arch/arm64/kernel/topology.c             | 212 +++++++++++-
 arch/arm64/kernel/traps.c                |   7 +-
 arch/arm64/kernel/vmlinux.lds.S          |   2 +-
 arch/arm64/kvm/hyp.S                     |  12 +-
 arch/arm64/kvm/sys_regs.c                |   4 +-
 arch/arm64/lib/Makefile                  |   1 +
 arch/arm64/lib/memcmp.S                  | 258 +++++++++++++++
 arch/arm64/lib/memcpy.S                  | 192 +++++++++--
 arch/arm64/lib/memmove.S                 | 190 +++++++++--
 arch/arm64/lib/memset.S                  | 207 ++++++++++--
 arch/arm64/lib/strcmp.S                  | 234 ++++++++++++++
 arch/arm64/lib/strlen.S                  | 126 ++++++++
 arch/arm64/lib/strncmp.S                 | 310 ++++++++++++++++++
 arch/arm64/lib/strnlen.S                 | 171 ++++++++++
 arch/arm64/mm/Makefile                   |   2 +-
 arch/arm64/mm/cache.S                    |   6 +-
 arch/arm64/mm/dma-mapping.c              |   2 +-
 arch/arm64/mm/fault.c                    |   8 +-
 arch/arm64/mm/mmu.c                      |  64 ++--
 arch/arm64/mm/proc.S                     |   2 +-
 arch/arm64/mm/tlb.S                      |  71 -----
 arch/blackfin/include/asm/ftrace.h       |  11 +-
 arch/parisc/include/asm/ftrace.h         |  10 +-
 arch/sh/include/asm/ftrace.h             |  10 +-
 arch/xtensa/include/asm/ftrace.h         |  14 +-
 include/asm-generic/unaligned.h          |  21 +-
 include/linux/ftrace.h                   |  34 +-
 scripts/recordmcount.c                   |   7 +
 scripts/recordmcount.pl                  |   5 +
 96 files changed, 6390 insertions(+), 603 deletions(-)
 create mode 100644 arch/arm64/crypto/Kconfig
 create mode 100644 arch/arm64/crypto/Makefile
 create mode 100644 arch/arm64/crypto/aes-ce-ccm-core.S
 create mode 100644 arch/arm64/crypto/aes-ce-ccm-glue.c
 create mode 100644 arch/arm64/crypto/aes-ce-cipher.c
 create mode 100644 arch/arm64/crypto/aes-ce.S
 create mode 100644 arch/arm64/crypto/aes-glue.c
 create mode 100644 arch/arm64/crypto/aes-modes.S
 create mode 100644 arch/arm64/crypto/aes-neon.S
 create mode 100644 arch/arm64/crypto/ghash-ce-core.S
 create mode 100644 arch/arm64/crypto/ghash-ce-glue.c
 create mode 100644 arch/arm64/crypto/sha1-ce-core.S
 create mode 100644 arch/arm64/crypto/sha1-ce-glue.c
 create mode 100644 arch/arm64/crypto/sha2-ce-core.S
 create mode 100644 arch/arm64/crypto/sha2-ce-glue.c
 create mode 100644 arch/arm64/include/asm/ftrace.h
 delete mode 100644 arch/arm64/include/asm/sigcontext.h
 create mode 100644 arch/arm64/kernel/entry-ftrace.S
 create mode 100644 arch/arm64/kernel/ftrace.c
 create mode 100644 arch/arm64/kernel/return_address.c
 create mode 100644 arch/arm64/lib/memcmp.S
 create mode 100644 arch/arm64/lib/strcmp.S
 create mode 100644 arch/arm64/lib/strlen.S
 create mode 100644 arch/arm64/lib/strncmp.S
 create mode 100644 arch/arm64/lib/strnlen.S
 delete mode 100644 arch/arm64/mm/tlb.S

-- 
Catalin
