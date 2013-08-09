Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab3HIFW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 01:22:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060Ab3HIFW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 01:22:26 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH v5 0/9] extend hugepage migration
Date: Fri,  9 Aug 2013 01:21:33 -0400
Message-Id: <1376025702-14818-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the 5th version of hugepage migration patchset.
Changes in this version are as follows:
 - removed putback_active_hugepages() as a cleanup (1/9)
 - added code to check movability of a given hugepage (8/9)
 - set GFP MOVABLE flag depending on the movability of hugepage (9/9).

I feel that 8/9 and 9/9 contain some new things, so need reviews on them.

TODOs: (likely to be done after this work)
 - split page table lock for pmd/pud based hugepage (maybe applicable to thp)
 - improve alloc_migrate_target (especially in node choice)
 - using page walker in check_range

Thanks,
Naoya Horiguchi
---
GitHub:
  git://github.com/Naoya-Horiguchi/linux.git extend_hugepage_migration.v5

Test code:
  git://github.com/Naoya-Horiguchi/test_hugepage_migration_extension.git

Naoya Horiguchi (9):
      migrate: make core migration code aware of hugepage
      soft-offline: use migrate_pages() instead of migrate_huge_page()
      migrate: add hugepage migration code to migrate_pages()
      migrate: add hugepage migration code to move_pages()
      mbind: add hugepage migration code to mbind()
      migrate: remove VM_HUGETLB from vma flag check in vma_migratable()
      memory-hotplug: enable memory hotplug to handle hugepage
      migrate: check movability of hugepage in unmap_and_move_huge_page()
      prepare to remove /proc/sys/vm/hugepages_treat_as_movable

 Documentation/sysctl/vm.txt   |  13 +---
 arch/arm/mm/hugetlbpage.c     |   5 ++
 arch/arm64/mm/hugetlbpage.c   |   5 ++
 arch/ia64/mm/hugetlbpage.c    |   5 ++
 arch/metag/mm/hugetlbpage.c   |   5 ++
 arch/mips/mm/hugetlbpage.c    |   5 ++
 arch/powerpc/mm/hugetlbpage.c |  10 ++++
 arch/s390/mm/hugetlbpage.c    |   5 ++
 arch/sh/mm/hugetlbpage.c      |   5 ++
 arch/sparc/mm/hugetlbpage.c   |   5 ++
 arch/tile/mm/hugetlbpage.c    |   5 ++
 arch/x86/mm/hugetlbpage.c     |   8 +++
 include/linux/hugetlb.h       |  25 ++++++++
 include/linux/mempolicy.h     |   2 +-
 include/linux/migrate.h       |   5 --
 mm/hugetlb.c                  | 134 +++++++++++++++++++++++++++++++++++++-----
 mm/memory-failure.c           |  15 ++++-
 mm/memory.c                   |  17 +++++-
 mm/memory_hotplug.c           |  42 ++++++++++---
 mm/mempolicy.c                |  46 +++++++++++++--
 mm/migrate.c                  |  61 ++++++++++---------
 mm/page_alloc.c               |  12 ++++
 mm/page_isolation.c           |  14 +++++
 23 files changed, 371 insertions(+), 78 deletions(-)
