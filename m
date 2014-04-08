Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbaDHGyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 02:54:41 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:42520 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaDHGyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 02:54:39 -0400
Date: Tue, 8 Apr 2014 08:54:33 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.15 merge window #2
Message-ID: <20140408085433.290230eb@mschwide>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040806-2966-0000-0000-00000ADADF6A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
The second part of Heikos uaccess rework, the page table walker for uaccess
is now a thing of the past (yay!)

The code change to fix the theoretical TLB flush problem allows us to
add a TLB flush optimization for zEC12, this machine has new instructions
that allow to do CPU local TLB flushes for single pages and for all pages
of a specific address space.

Plus the usual bug fixing and some more cleanup.

Christian Borntraeger (1):
      kvm/s390: also set guest pages back to stable on kexec/kdump

Gerald Schaefer (1):
      s390/sclp: add timeout for queued requests

Heiko Carstens (2):
      s390/bitops,atomic: add missing memory barriers
      s390/uaccess: rework uaccess code - fix locking issues

Ingo Tuchscherer (1):
      s390/zcrypt: add length check for aligned data to avoid overflow in msg-type 6

Martin Schwidefsky (3):
      s390/3270: fix crash with multiple reset device requests
      s390/mm,tlb: safeguard against speculative TLB creation
      s390/mm,tlb: optimize TLB flushing for zEC12

Thomas Gleixner (3):
      s390/tape: Use del_timer_sync()
      s390/tape: Add missing destroy_timer_on_stack()
      lcs: Add missing destroy_timer_on_stack()

Thomas Huth (2):
      s390/irq: Add defines for external interruption codes
      s390/irq: Use defines for external interruption codes

 arch/s390/include/asm/atomic.h        |   70 +++--
 arch/s390/include/asm/bitops.h        |   41 +--
 arch/s390/include/asm/futex.h         |   66 ++++-
 arch/s390/include/asm/irq.h           |   17 +-
 arch/s390/include/asm/mmu.h           |    2 +
 arch/s390/include/asm/mmu_context.h   |   45 +++-
 arch/s390/include/asm/pgtable.h       |  128 ++++++---
 arch/s390/include/asm/setup.h         |    3 +
 arch/s390/include/asm/switch_to.h     |    1 +
 arch/s390/include/asm/thread_info.h   |    2 +
 arch/s390/include/asm/tlb.h           |   14 +-
 arch/s390/include/asm/tlbflush.h      |  115 ++++++--
 arch/s390/include/asm/uaccess.h       |    2 -
 arch/s390/kernel/asm-offsets.c        |    1 +
 arch/s390/kernel/early.c              |    2 +
 arch/s390/kernel/entry.S              |   24 +-
 arch/s390/kernel/entry64.S            |   24 +-
 arch/s390/kernel/irq.c                |   10 +-
 arch/s390/kernel/perf_cpum_cf.c       |    6 +-
 arch/s390/kernel/perf_cpum_sf.c       |    6 +-
 arch/s390/kernel/runtime_instr.c      |    3 +-
 arch/s390/kernel/sclp.S               |    5 +-
 arch/s390/kernel/smp.c                |   10 +-
 arch/s390/kernel/time.c               |    6 +-
 arch/s390/kvm/diag.c                  |    4 +
 arch/s390/lib/Makefile                |    2 +-
 arch/s390/lib/uaccess.c               |  407 ++++++++++++++++++++++++++++
 arch/s390/lib/uaccess.h               |   16 --
 arch/s390/lib/uaccess_mvcos.c         |  263 ------------------
 arch/s390/lib/uaccess_pt.c            |  471 ---------------------------------
 arch/s390/mm/fault.c                  |   53 ++--
 arch/s390/mm/hugetlbpage.c            |    5 +-
 arch/s390/mm/init.c                   |    7 +-
 arch/s390/mm/pgtable.c                |   12 +-
 arch/s390/mm/vmem.c                   |    2 -
 arch/s390/oprofile/hwsampler.c        |    4 +-
 drivers/s390/block/dasd_diag.c        |    4 +-
 drivers/s390/char/raw3270.c           |    9 +-
 drivers/s390/char/sclp.c              |   88 +++++-
 drivers/s390/char/sclp.h              |    9 +
 drivers/s390/char/sclp_cmd.c          |   17 +-
 drivers/s390/char/tape_std.c          |    3 +-
 drivers/s390/crypto/zcrypt_api.c      |    4 +-
 drivers/s390/crypto/zcrypt_msgtype6.c |   18 +-
 drivers/s390/kvm/kvm_virtio.c         |    2 +-
 drivers/s390/net/lcs.c                |    1 +
 net/iucv/iucv.c                       |    6 +-
 47 files changed, 1031 insertions(+), 979 deletions(-)
 create mode 100644 arch/s390/lib/uaccess.c
 delete mode 100644 arch/s390/lib/uaccess.h
 delete mode 100644 arch/s390/lib/uaccess_mvcos.c
 delete mode 100644 arch/s390/lib/uaccess_pt.c

