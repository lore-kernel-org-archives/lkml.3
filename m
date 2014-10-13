Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaJMKxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 06:53:40 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:50464 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbaJMKxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 06:53:37 -0400
Date: Mon, 13 Oct 2014 12:53:32 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.18 merge window
Message-ID: <20141013125332.2bbd316d@mschwide>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101310-0025-0000-0000-000001DC8368
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:

This patch set contains the main portion of the changes for 3.18 in regard
to the s390 architecture. It is a bit bigger than usual, mainly because of
a new driver and the vector extension patches.

The interesting bits are:
 - Quite a bit of work on the tracing front. Uprobes is enabled and
   the ftrace code is reworked to get some of the lost performance back
   if CONFIG_FTRACE is enabled.
 - To improve boot time with CONFIG_DEBIG_PAGEALLOC, support for the 
   IPTE range facility is added.
 - The rwlock code is re-factored to improve writer fairness and to be
   able to use the interlocked-access instructions.
 - The kernel part for the support of the vector extension is added.
 - The device driver to access the CD/DVD on the HMC is added, this
   will hopefully come in handy to improve the installation process.
 - Add support for control-unit initiated reconfiguration.
 - The crypto device driver is enhanced to enable the additional AP
   domains and to allow the new crypto hardware to be used.
 - Bug fixes.

Christian Borntraeger (1):
      s390/head.s: use zero as address for stfl

Heiko Carstens (14):
      s390: remove unused MACHINE_FLAG_RRBM
      Documentation/kprobes: add s390 to list of supported architectures
      s390: pass march flag to assembly files as well
      s390/ftrace: optimize function graph caller code
      s390/ftrace: add HAVE_DYNAMIC_FTRACE_WITH_REGS support
      s390/ftrace: enforce DYNAMIC_FTRACE if FUNCTION_TRACER is selected
      s390/kprobes: remove unused jprobe_return_end()
      s390/ftrace: optimize mcount code
      s390/spinlock: optimize spin_unlock code
      s390/vmemmap: remove memset call from vmemmap_populate()
      s390/mm: remove change bit override support
      s390/mm: make use of ipte range facility
      s390/ftrace: remove 31 bit ftrace support
      s390/ftrace: simplify enabling/disabling of ftrace_graph_caller

Ingo Tuchscherer (3):
      s390/zcrypt: support for extended number of ap domains
      s390/zcrypt: Fixed possible race condition in zcrypt module handling
      s390/zcrypt: Toleration of new crypto hardware

Jan Willeke (2):
      s390/uprobes: common library for kprobes and uprobes
      s390/uprobes: architecture backend for uprobes

Martin Schwidefsky (14):
      s390/vdso: replace stck with stcke
      s390/vdso: add vdso support for coarse clocks
      s390/sclp: reduce dependency on event type masks
      s390/rwlock: use directed yield for write-locked rwlocks
      s390/rwlock: remove interrupt-enabling rwlock variant.
      s390/rwlock: improve writer fairness
      s390/rwlock: use the interlocked-access facility 1 instructions
      s390/topology: call set_sched_topology early
      s390/setup: correct 4-level kernel page table detection
      s390/vtime: do not reset idle data on CPU hotplug
      s390/nohz: use a per-cpu flag for arch_needs_cpu
      s390/idle: consolidate idle functions and definitions
      s390: add support for vector extension
      s390/disassembler: add vector instructions

Michael Holzheu (1):
      s390/kdump: add support for vector extension

Ralf Hoppe (1):
      s390/hmcdrv: HMC drive CD/DVD access

Stefan Haberland (3):
      s390/tape: fix MTIOCGET ioctl to report blocksize
      s390/dasd: fix infinite loop during format
      s390/dasd: add support for control unit initiated reconfiguration

 Documentation/kprobes.txt               |   1 +
 arch/s390/Kconfig                       |  11 +-
 arch/s390/Makefile                      |  17 +-
 arch/s390/include/asm/barrier.h         |   6 +-
 arch/s390/include/asm/cputime.h         |  26 +--
 arch/s390/include/asm/dis.h             |  13 +-
 arch/s390/include/asm/elf.h             |   3 +-
 arch/s390/include/asm/ftrace.h          |   9 +-
 arch/s390/include/asm/idle.h            |  26 +++
 arch/s390/include/asm/ipl.h             |   4 +-
 arch/s390/include/asm/irq.h             |   1 +
 arch/s390/include/asm/kprobes.h         |   4 +
 arch/s390/include/asm/lowcore.h         |  21 +-
 arch/s390/include/asm/nmi.h             |   2 +-
 arch/s390/include/asm/pgtable.h         |  25 ++-
 arch/s390/include/asm/processor.h       |  12 +-
 arch/s390/include/asm/ptrace.h          |   6 +
 arch/s390/include/asm/setup.h           |   6 +-
 arch/s390/include/asm/sigp.h            |   6 +-
 arch/s390/include/asm/smp.h             |   2 -
 arch/s390/include/asm/spinlock.h        | 135 +++++++++---
 arch/s390/include/asm/spinlock_types.h  |   1 +
 arch/s390/include/asm/switch_to.h       |  61 +++++-
 arch/s390/include/asm/thread_info.h     |   3 +
 arch/s390/include/asm/uprobes.h         |  42 ++++
 arch/s390/include/asm/vdso.h            |  18 +-
 arch/s390/include/asm/vtimer.h          |   2 -
 arch/s390/include/uapi/asm/sigcontext.h |  20 +-
 arch/s390/include/uapi/asm/types.h      |   4 +
 arch/s390/include/uapi/asm/ucontext.h   |  15 +-
 arch/s390/kernel/Makefile               |   8 +-
 arch/s390/kernel/asm-offsets.c          |   9 +-
 arch/s390/kernel/compat_linux.h         |   9 +
 arch/s390/kernel/compat_signal.c        | 212 +++++++++++++-----
 arch/s390/kernel/crash_dump.c           |  58 ++++-
 arch/s390/kernel/dis.c                  | 245 ++++++++++++++++++++-
 arch/s390/kernel/early.c                |   4 +-
 arch/s390/kernel/entry.h                |   6 +-
 arch/s390/kernel/entry64.S              |  17 +-
 arch/s390/kernel/ftrace.c               | 139 +++++-------
 arch/s390/kernel/head.S                 |   2 +-
 arch/s390/kernel/idle.c                 | 124 +++++++++++
 arch/s390/kernel/irq.c                  |   3 +-
 arch/s390/kernel/kprobes.c              | 159 +-------------
 arch/s390/kernel/machine_kexec.c        |   8 +-
 arch/s390/kernel/mcount.S               |  86 ++++----
 arch/s390/kernel/mcount64.S             |  62 ------
 arch/s390/kernel/nmi.c                  |  16 ++
 arch/s390/kernel/pgm_check.S            |   2 +-
 arch/s390/kernel/process.c              |  24 ---
 arch/s390/kernel/processor.c            |   4 +-
 arch/s390/kernel/ptrace.c               | 254 +++++++++++++++++-----
 arch/s390/kernel/setup.c                |  13 +-
 arch/s390/kernel/signal.c               | 296 +++++++++++++++++++------
 arch/s390/kernel/smp.c                  |  80 +++----
 arch/s390/kernel/time.c                 |  13 ++
 arch/s390/kernel/topology.c             |  18 +-
 arch/s390/kernel/traps.c                | 115 +++++++++-
 arch/s390/kernel/uprobes.c              | 332 ++++++++++++++++++++++++++++
 arch/s390/kernel/vdso32/clock_getres.S  |  11 +-
 arch/s390/kernel/vdso32/clock_gettime.S |  32 ++-
 arch/s390/kernel/vdso32/gettimeofday.S  |   4 +-
 arch/s390/kernel/vdso64/clock_getres.S  |   8 +-
 arch/s390/kernel/vdso64/clock_gettime.S |  32 ++-
 arch/s390/kernel/vdso64/gettimeofday.S  |   4 +-
 arch/s390/kernel/vtime.c                |  77 +------
 arch/s390/lib/Makefile                  |   2 +
 arch/s390/lib/delay.c                   |   4 +-
 arch/s390/lib/probes.c                  | 159 ++++++++++++++
 arch/s390/lib/spinlock.c                | 105 +++++----
 arch/s390/mm/dump_pagetables.c          |   5 +-
 arch/s390/mm/hugetlbpage.c              |   2 +-
 arch/s390/mm/pageattr.c                 |  38 +++-
 arch/s390/mm/vmem.c                     |   8 +-
 drivers/s390/block/dasd.c               |  33 ++-
 drivers/s390/block/dasd_devmap.c        |  24 +++
 drivers/s390/block/dasd_eckd.c          | 372 +++++++++++++++++++++++++++++++-
 drivers/s390/block/dasd_eckd.h          |  63 +++++-
 drivers/s390/block/dasd_int.h           |  10 +-
 drivers/s390/char/Kconfig               |  13 ++
 drivers/s390/char/Makefile              |   3 +
 drivers/s390/char/diag_ftp.c            | 237 ++++++++++++++++++++
 drivers/s390/char/diag_ftp.h            |  21 ++
 drivers/s390/char/hmcdrv_cache.c        | 252 ++++++++++++++++++++++
 drivers/s390/char/hmcdrv_cache.h        |  24 +++
 drivers/s390/char/hmcdrv_dev.c          | 370 +++++++++++++++++++++++++++++++
 drivers/s390/char/hmcdrv_dev.h          |  14 ++
 drivers/s390/char/hmcdrv_ftp.c          | 343 +++++++++++++++++++++++++++++
 drivers/s390/char/hmcdrv_ftp.h          |  63 ++++++
 drivers/s390/char/hmcdrv_mod.c          |  64 ++++++
 drivers/s390/char/sclp.h                |   2 +
 drivers/s390/char/sclp_diag.h           |  89 ++++++++
 drivers/s390/char/sclp_early.c          |   2 +-
 drivers/s390/char/sclp_ftp.c            | 275 +++++++++++++++++++++++
 drivers/s390/char/sclp_ftp.h            |  21 ++
 drivers/s390/char/sclp_rw.c             |  13 +-
 drivers/s390/char/sclp_vt220.c          |   4 -
 drivers/s390/char/tape_char.c           |   4 +-
 drivers/s390/char/zcore.c               |  18 +-
 drivers/s390/cio/airq.c                 |   2 +-
 drivers/s390/cio/cio.c                  |   2 +-
 drivers/s390/crypto/ap_bus.c            |  30 ++-
 drivers/s390/crypto/ap_bus.h            |   7 +-
 drivers/s390/crypto/zcrypt_api.c        |   7 +-
 include/linux/tick.h                    |   2 +-
 include/uapi/linux/elf.h                |   2 +
 kernel/time/tick-sched.c                |   2 +-
 scripts/recordmcount.c                  |   4 -
 scripts/recordmcount.pl                 |   7 -
 109 files changed, 4738 insertions(+), 972 deletions(-)
 create mode 100644 arch/s390/include/asm/idle.h
 create mode 100644 arch/s390/include/asm/uprobes.h
 create mode 100644 arch/s390/kernel/idle.c
 delete mode 100644 arch/s390/kernel/mcount64.S
 create mode 100644 arch/s390/kernel/uprobes.c
 create mode 100644 arch/s390/lib/probes.c
 create mode 100644 drivers/s390/char/diag_ftp.c
 create mode 100644 drivers/s390/char/diag_ftp.h
 create mode 100644 drivers/s390/char/hmcdrv_cache.c
 create mode 100644 drivers/s390/char/hmcdrv_cache.h
 create mode 100644 drivers/s390/char/hmcdrv_dev.c
 create mode 100644 drivers/s390/char/hmcdrv_dev.h
 create mode 100644 drivers/s390/char/hmcdrv_ftp.c
 create mode 100644 drivers/s390/char/hmcdrv_ftp.h
 create mode 100644 drivers/s390/char/hmcdrv_mod.c
 create mode 100644 drivers/s390/char/sclp_diag.h
 create mode 100644 drivers/s390/char/sclp_ftp.c
 create mode 100644 drivers/s390/char/sclp_ftp.h

