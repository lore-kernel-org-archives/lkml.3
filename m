Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbbAEKyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:54:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318AbbAEKyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:54:16 -0500
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 0/10] Replace _PAGE_NUMA with PAGE_NONE protections v5
Date: Mon,  5 Jan 2015 10:54:01 +0000
Message-Id: <1420455251-13644-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog since V4
o Rebase to 3.19-rc2						(mel)

Changelog since V3
o Minor comment update						(benh)
o Add ack'ed bys

Changelog since V2
o Rename *_protnone_numa to _protnone and extend docs		(linus)
o Rebase to mmotm-20141119 for pre-merge testing		(mel)
o Conver WARN_ON to VM_WARN_ON					(aneesh)

Changelog since V1
o ppc64 paranoia checks and clarifications			(aneesh)
o Fix trinity regression (hopefully)
o Reduce unnecessary TLB flushes				(mel)

Automatic NUMA balancing depends on protecting PTEs to trap a fault and
gather reference locality information. Very broadly speaking it marks PTEs
as not present and uses another bit to distinguish between NUMA hinting
faults and other types of faults. This approach is not universally loved,
ultimately resulted in swap space shrinking and has had a number of
problems with Xen support. This series is very heavily based on patches
from Linus and Aneesh to replace the existing PTE/PMD NUMA helper functions
with normal change protections that should be less problematic. This was
tested on a few different workloads that showed automatic NUMA balancing
was still active with mostly comparable results.

specjbb single JVM: There was negligible performance difference in the
	benchmark itself for short runs. However, system activity is
	higher and interrupts are much higher over time -- possibly TLB
	flushes. Migrations are also higher. Overall, this is more overhead
	but considering the problems faced with the old approach I think
	we just have to suck it up and find another way of reducing the
	overhead.

specjbb multi JVM: Negligible performance difference to the actual benchmark
	but like the single JVM case, the system overhead is noticeably
	higher.  Again, interrupts are a major factor.

autonumabench: This was all over the place and about all that can be
	reasonably concluded is that it's different but not necessarily
	better or worse.

autonumabench
                                          3.19.0-rc2            3.19.0-rc2
                                             vanilla         protnone-v5r1
Time System-NUMA01                  268.99 (  0.00%)     1350.70 (-402.14%)
Time System-NUMA01_THEADLOCAL       110.14 (  0.00%)       50.68 ( 53.99%)
Time System-NUMA02                   20.14 (  0.00%)       31.12 (-54.52%)
Time System-NUMA02_SMT                7.40 (  0.00%)        6.57 ( 11.22%)
Time Elapsed-NUMA01                 687.57 (  0.00%)      528.51 ( 23.13%)
Time Elapsed-NUMA01_THEADLOCAL      540.29 (  0.00%)      554.36 ( -2.60%)
Time Elapsed-NUMA02                  84.98 (  0.00%)       78.87 (  7.19%)
Time Elapsed-NUMA02_SMT              77.32 (  0.00%)       87.07 (-12.61%)

System CPU usage of NUMA01 is worse but it's an adverse workload on this
machine so I'm reluctant to conclude that it's a problem that matters.
Overall time to complete the benchmark is comparable

          3.19.0-rc2  3.19.0-rc2
             vanillaprotnone-v5r1
User        58100.89    48351.17
System        407.74     1439.22
Elapsed      1411.44     1250.55


NUMA alloc hit                 5398081     5536696
NUMA alloc miss                      0           0
NUMA interleave hit                  0           0
NUMA alloc local               5398073     5536668
NUMA base PTE updates        622722221   442576477
NUMA huge PMD updates          1215268      863690
NUMA page range updates     1244939437   884785757
NUMA hint faults               1696858     1221541
NUMA hint local faults         1046842      791219
NUMA hint local percent             61          64
NUMA pages migrated            6044430    59291698

The NUMA pages migrated look terrible but when I looked at a graph of the
activity over time I see that the massive spike in migration activity was
during NUMA01. This correlates with high system CPU usage and could be simply
down to bad luck but any modifications that affect that workload would be
related to scan rates and migrations, not the protection mechanism. For
all other workloads, migration activity was comparable.

Overall, headline performance figures are comparable but the overhead
is higher, mostly in interrupts. To some extent, higher overhead from
this approach was anticipated but not to this degree. It's going to be
necessary to reduce this again with a separate series in the future. It's
still worth going ahead with this series though as it's likely to avoid
constant headaches with Xen and is probably easier to maintain.

 arch/powerpc/include/asm/pgtable.h    |  54 ++----------
 arch/powerpc/include/asm/pte-common.h |   5 --
 arch/powerpc/include/asm/pte-hash64.h |   6 --
 arch/powerpc/kvm/book3s_hv_rm_mmu.c   |   2 +-
 arch/powerpc/mm/copro_fault.c         |   8 +-
 arch/powerpc/mm/fault.c               |  25 ++----
 arch/powerpc/mm/pgtable.c             |  11 ++-
 arch/powerpc/mm/pgtable_64.c          |   3 +-
 arch/x86/include/asm/pgtable.h        |  46 +++++-----
 arch/x86/include/asm/pgtable_64.h     |   5 --
 arch/x86/include/asm/pgtable_types.h  |  41 +--------
 arch/x86/mm/gup.c                     |   4 +-
 include/asm-generic/pgtable.h         | 153 ++--------------------------------
 include/linux/migrate.h               |   4 -
 include/linux/swapops.h               |   2 +-
 include/uapi/linux/mempolicy.h        |   2 +-
 mm/gup.c                              |  10 +--
 mm/huge_memory.c                      |  50 ++++++-----
 mm/memory.c                           |  18 ++--
 mm/mempolicy.c                        |   2 +-
 mm/migrate.c                          |   8 +-
 mm/mprotect.c                         |  48 +++++------
 mm/pgtable-generic.c                  |   2 -
 23 files changed, 135 insertions(+), 374 deletions(-)

-- 
2.1.2

