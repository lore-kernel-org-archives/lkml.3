Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366AbaFCGve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 02:51:34 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:45260 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342AbaFCGvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 02:51:31 -0400
Date: Tue, 3 Jun 2014 08:51:25 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.16 merge window #1
Message-ID: <20140603085125.5c73be02@mschwide>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060306-0542-0000-0000-000009472C9E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:

The biggest change in this patchset is conversion from the bootmem
bitmaps to the memblock code. This conversion requires two common
code patches to introduce the 'physmem' memblock list.

We experimented with ticket spinlocks but in the end decided against
them as they perform poorly on virtualized systems. But the spinlock
cleanup and some small improvements are included.

The uaccess code got another optimization, the get_user/put_user calls
are now inline again for kernel compiles targeted at z10 or newer
machines. This makes the text segment shorter and the code gets a
little bit faster.

And as always some bug fixes.

Christian Borntraeger (1):
      s390/lowcore: reserve 96 bytes for IRB in lowcore

Gerald Schaefer (1):
      s390/spinlock: fix system hang with spin_retry <= 0

Heiko Carstens (4):
      s390/cmma: remove "cmma disable" code in case of dump again
      s390/uaccess: provide inline variants of get_user/put_user
      s390: require mvcos facility for z10 and newer machines
      s390/facilities: remove extract-cpu-time facility check

Jeff Mahoney (1):
      s390/appldata: add slab.h for kzalloc/kfree

Julia Lawall (1):
      s390/oprofile: make return of 0 explicit

Martin Schwidefsky (8):
      s390/uaccess: simplify control register updates
      s390: split TIF bits into CIF, PIF and TIF bits
      s390/spinlock,rwlock: always to a load-and-test first
      s390/rwlock: add missing local_irq_restore calls
      s390/spinlock: refactor arch_spin_lock_wait[_flags]
      s390/time: cast tv_nsec to u64 prior to shift in update_vsyscall
      s390/boot: fix boot of compressed kernel built with gcc 4.9
      s390/lowcore: replace lowcore irb array with a per-cpu variable

Michael Holzheu (3):
      s390/dump: Remove CONFIG_ZFCPDUMP
      s390/zfcpdump: Update documentation in zfcpdump.txt
      s390/smp: Avoid busy loop after halt and "begin" on z/VM

Philipp Hachtmann (5):
      mm/memblock: Do some refactoring, enhance API
      mm/memblock: add physical memory list
      s390/mm: Convert bootmem to memblock
      s390/spinlock: cleanup spinlock code
      s390/spinlock: optimize spinlock code sequence

Randy Dunlap (1):
      s390: fix new ccwgroup.h kernel-doc warning

Sebastian Ott (6):
      s390/pci: improve state check when processing hotplug events
      s390/pci: use macro for attribute creation
      s390/pci: use pdev->dev.groups for attribute creation
      s390/pci: add some new arch specific pci attributes
      s390/cio: fix multiple structure definitions
      s390/cio: remove weird assignment during argument evaluation

 Documentation/s390/zfcpdump.txt        |   73 ++---
 arch/s390/Kconfig                      |   14 +-
 arch/s390/appldata/appldata_mem.c      |    1 +
 arch/s390/boot/compressed/Makefile     |    2 +-
 arch/s390/include/asm/ccwdev.h         |    2 +-
 arch/s390/include/asm/ccwgroup.h       |    2 +
 arch/s390/include/asm/chpid.h          |   11 +
 arch/s390/include/asm/futex.h          |    4 +-
 arch/s390/include/asm/lowcore.h        |   25 +-
 arch/s390/include/asm/mmu_context.h    |   43 ++-
 arch/s390/include/asm/pci.h            |   12 +-
 arch/s390/include/asm/pci_clp.h        |   10 +-
 arch/s390/include/asm/processor.h      |   22 ++
 arch/s390/include/asm/ptrace.h         |   22 ++
 arch/s390/include/asm/setup.h          |   16 +-
 arch/s390/include/asm/smp.h            |    5 +-
 arch/s390/include/asm/spinlock.h       |  129 +++++----
 arch/s390/include/asm/spinlock_types.h |    6 +-
 arch/s390/include/asm/switch_to.h      |    1 -
 arch/s390/include/asm/syscall.h        |    2 +-
 arch/s390/include/asm/thread_info.h    |   34 +--
 arch/s390/include/asm/uaccess.h        |   30 +++
 arch/s390/kernel/asm-offsets.c         |    3 +-
 arch/s390/kernel/compat_signal.c       |    2 +-
 arch/s390/kernel/crash_dump.c          |   83 +++---
 arch/s390/kernel/early.c               |    6 +
 arch/s390/kernel/entry.S               |   87 +++---
 arch/s390/kernel/entry64.S             |   82 +++---
 arch/s390/kernel/head.S                |    8 +-
 arch/s390/kernel/head31.S              |    1 -
 arch/s390/kernel/nmi.c                 |    8 +-
 arch/s390/kernel/process.c             |    6 +-
 arch/s390/kernel/ptrace.c              |    4 +-
 arch/s390/kernel/setup.c               |  459 ++++++++++++--------------------
 arch/s390/kernel/signal.c              |   12 +-
 arch/s390/kernel/smp.c                 |   20 +-
 arch/s390/kernel/time.c                |    2 +-
 arch/s390/kernel/topology.c            |    4 +-
 arch/s390/kvm/kvm-s390.c               |    2 +-
 arch/s390/lib/spinlock.c               |  157 ++++++-----
 arch/s390/lib/uaccess.c                |   10 +-
 arch/s390/mm/fault.c                   |    2 +-
 arch/s390/mm/mem_detect.c              |  130 +++------
 arch/s390/mm/page-states.c             |   10 -
 arch/s390/mm/pgtable.c                 |   10 +-
 arch/s390/mm/vmem.c                    |   30 +--
 arch/s390/oprofile/hwsampler.c         |   14 +-
 arch/s390/pci/pci.c                    |    6 +-
 arch/s390/pci/pci_clp.c                |   10 +
 arch/s390/pci/pci_event.c              |    5 +-
 arch/s390/pci/pci_sysfs.c              |  135 +++++-----
 drivers/s390/char/Makefile             |    2 +-
 drivers/s390/char/zcore.c              |   44 +--
 drivers/s390/cio/ccwreq.c              |    4 +-
 drivers/s390/cio/chp.c                 |    2 +-
 drivers/s390/cio/chp.h                 |    2 +-
 drivers/s390/cio/chsc.h                |   11 -
 drivers/s390/cio/chsc_sch.c            |    2 +-
 drivers/s390/cio/cio.c                 |    9 +-
 drivers/s390/cio/cio.h                 |    2 +
 drivers/s390/cio/device_fsm.c          |    4 +-
 drivers/s390/cio/device_ops.c          |   13 +-
 drivers/s390/cio/eadm_sch.c            |    2 +-
 drivers/s390/net/qeth_core_main.c      |   12 +-
 include/linux/memblock.h               |   79 +++++-
 mm/Kconfig                             |    3 +
 mm/memblock.c                          |  205 +++++++++-----
 67 files changed, 1061 insertions(+), 1109 deletions(-)

