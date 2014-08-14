Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaHNGQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 02:16:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:48485 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbaHNGQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 02:16:31 -0400
Message-ID: <1407996977.5490.56.camel@pasglop>
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Thu, 14 Aug 2014 16:16:17 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are some more powerpc bits for 3.17, essentially fixes.

The biggest series, also aimed at -stable, is from Aneesh and is the result
of weeks and weeks of debugging to find out why the heck or THP implementation
was occasionally triggering multi-hit errors in our level 1 TLB. It ended up
being a combination of issues including subtleties as to how we should
invalidate those special 'MPSS' pages we use to allow the use of 16M pages
inside 4K/64K "base page size" segments (you really have to love our MMU !)

Another interesting one in the "OMG" category is the series from Michael
adding memory barriers to spin_is_locked(). That's also the result of many
days of debugging to figure out why the semaphore code would occasionally
crash in ways that made no sense. It ended up being some creative lock
stacking that was defeated by the fact that our locks allow a load inside
the locked section to be re-ordered with the load of the lock value itself
(I'm still of two mind about whether to kill that once and for all by putting
a heavier barrier back into our lock implementation...). The fixes come with
a long explanation in the cset comments, feel free to read it if you feel
like having a headache today.

Cheers,
Ben.

The following changes since commit 58d08e3b2c2033354b91467da33deffa06360c28:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/olof/chrome-platform (2014-08-10 11:13:58 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

for you to fetch changes up to 9e813308a5c18c58f9ccae1ec72ed4e14eaf9025:

  powerpc/thp: Add tracepoints to track hugepage invalidate (2014-08-13 18:20:42 +1000)

----------------------------------------------------------------
Alistair Popple (1):
      powerpc/ppc476: Disable BTAC

Aneesh Kumar K.V (8):
      powerpc/thp: Add write barrier after updating the valid bit
      powerpc/thp: Don't recompute vsid and ssize in loop on invalidate
      powerpc/thp: Invalidate old 64K based hash page mapping before insert of 4k pte
      powerpc/thp: Handle combo pages in invalidate
      powerpc/thp: Invalidate with vpn in loop
      powerpc/thp: Use ACCESS_ONCE when loading pmdp
      powerpc/mm: Use read barrier when creating real_pte
      powerpc/thp: Add tracepoints to track hugepage invalidate

Anton Blanchard (1):
      powerpc: Hard disable interrupts in xmon

Benjamin Herrenschmidt (1):
      powerpc/boot: Use correct zlib types for comparison

Gavin Shan (3):
      powerpc/powernv: Fix IOMMU group lost
      powerpc/pseries: Failure on removing device node
      powerpc/pseries: Avoid deadlock on removing ddw

Guenter Roeck (1):
      powerpc: Fix "attempt to move .org backwards" error

Himangi Saraogi (1):
      powerpc/perf/hv-24x7: Use kmem_cache_free

Michael Ellerman (3):
      powerpc: Add smp_mb() to arch_spin_is_locked()
      powerpc: Add smp_mb()s to arch_spin_unlock_wait()
      powerpc: Add POWER8 features to CPU_FTRS_POSSIBLE/ALWAYS

Nishanth Aravamudan (2):
      powerpc: remove duplicate definition of TEXASR_FS
      powerpc: reorder per-cpu NUMA information's initialization

Scott Wood (1):
      powerpc/nohash: Split __early_init_mmu() into boot and secondary

Thomas Falcon (1):
      powerpc/pseries/hvcserver: Fix endian issue in hvcs_get_partner_info

Vasant Hegde (2):
      printk: Add function to return log buffer address and size
      powerpc/powernv: Interface to register/unregister opal dump region

 arch/powerpc/boot/gunzip_util.c                 |   4 +-
 arch/powerpc/include/asm/cputable.h             |   6 +-
 arch/powerpc/include/asm/machdep.h              |   6 +-
 arch/powerpc/include/asm/opal.h                 |  11 +++
 arch/powerpc/include/asm/pgtable-ppc64.h        |   2 +-
 arch/powerpc/include/asm/pte-hash64-64k.h       |  30 +++++--
 arch/powerpc/include/asm/reg.h                  |   3 +-
 arch/powerpc/include/asm/spinlock.h             |   1 +
 arch/powerpc/kernel/exceptions-64s.S            | 110 +++++++++++------------
 arch/powerpc/kernel/head_44x.S                  |   4 +-
 arch/powerpc/kernel/iommu.c                     |  38 ++++----
 arch/powerpc/kernel/smp.c                       |  11 ++-
 arch/powerpc/lib/locks.c                        |   4 +
 arch/powerpc/mm/hash_native_64.c                |  40 +++------
 arch/powerpc/mm/hugepage-hash64.c               |  88 ++++++++++++++++---
 arch/powerpc/mm/numa.c                          |  13 ++-
 arch/powerpc/mm/pgtable_64.c                    |  44 ++++++----
 arch/powerpc/mm/tlb_hash64.c                    |   6 +-
 arch/powerpc/mm/tlb_nohash.c                    | 111 ++++++++++++++----------
 arch/powerpc/perf/hv-24x7.c                     |   2 +-
 arch/powerpc/platforms/powernv/opal-wrappers.S  |   2 +
 arch/powerpc/platforms/powernv/opal.c           |  23 +++++
 arch/powerpc/platforms/powernv/pci-ioda.c       |   2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c |   2 +-
 arch/powerpc/platforms/pseries/hvcserver.c      |   4 +-
 arch/powerpc/platforms/pseries/iommu.c          |  20 +++--
 arch/powerpc/platforms/pseries/lpar.c           |  20 ++---
 arch/powerpc/xmon/xmon.c                        |   3 +
 include/linux/printk.h                          |   3 +
 include/trace/events/thp.h                      |  88 +++++++++++++++++++
 kernel/printk/printk.c                          |  12 +++
 31 files changed, 490 insertions(+), 223 deletions(-)
 create mode 100644 include/trace/events/thp.h


