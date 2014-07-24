Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbaGXOgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:36:10 -0400
Received: from 8bytes.org ([81.169.241.247]:57885 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759007AbaGXOgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:36:07 -0400
From: Joerg Roedel <joro@8bytes.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <jweiner@redhat.com>
Cc: Jerome Glisse <jglisse@redhat.com>, jroedel@suse.de, Jay.Cornwall@amd.com,
        Oded.Gabbay@amd.com, John.Bridgman@amd.com,
        Suravee.Suthikulpanit@amd.com, ben.sander@amd.com,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, iommu@lists.linux-foundation.org,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 0/3] mmu_notifier: Allow to manage CPU external TLBs
Date: Thu, 24 Jul 2014 16:35:38 +0200
Message-Id: <1406212541-25975-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a patch-set to extend the mmu_notifiers in the Linux
kernel to allow managing CPU external TLBs. Those TLBs may
be implemented in IOMMUs or any other external device, e.g.
ATS/PRI capable PCI devices.

The problem with managing these TLBs are the semantics of
the invalidate_range_start/end call-backs currently
available. Currently the subsystem using mmu_notifiers has
to guarantee that no new TLB entries are established between
invalidate_range_start/end. Furthermore the
invalidate_range_start() function is called when all pages
are still mapped and invalidate_range_end() when the pages
are unmapped an already freed.

So both call-backs can't be used to safely flush any non-CPU
TLB because _start() is called too early and _end() too
late.

In the AMD IOMMUv2 driver this is currently implemented by
assigning an empty page-table to the external device between
_start() and _end(). But as tests have shown this doesn't
work as external devices don't re-fault infinitly but enter
a failure state after some time.

Next problem with this solution is that it causes an
interrupt storm for IO page faults to be handled when an
empty page-table is assigned.

To solve this situation I wrote a patch-set to introduce a
new notifier call-back: mmu_notifer_invalidate_range(). This
notifier lifts the strict requirements that no new
references are taken in the range between _start() and
_end(). When the subsystem can't guarantee that any new
references are taken is has to provide the
invalidate_range() call-back to clear any new references in
there.

It is called between invalidate_range_start() and _end()
every time the VMM has to wipe out any references to a
couple of pages. This are usually the places where the CPU
TLBs are flushed too and where its important that this
happens before invalidate_range_end() is called.

Any comments and review appreciated!

Thanks,

	Joerg

Joerg Roedel (3):
  mmu_notifier: Add mmu_notifier_invalidate_range()
  mmu_notifier: Call mmu_notifier_invalidate_range() from VMM
  mmu_notifier: Add the call-back for mmu_notifier_invalidate_range()

 include/linux/mmu_notifier.h | 66 ++++++++++++++++++++++++++++++++++++++++----
 kernel/events/uprobes.c      |  2 +-
 mm/fremap.c                  |  2 +-
 mm/huge_memory.c             |  9 +++---
 mm/hugetlb.c                 |  7 ++++-
 mm/ksm.c                     |  4 +--
 mm/memory.c                  |  3 +-
 mm/migrate.c                 |  3 +-
 mm/mmu_notifier.c            | 15 ++++++++++
 mm/rmap.c                    |  2 +-
 10 files changed, 95 insertions(+), 18 deletions(-)

-- 
1.9.1

