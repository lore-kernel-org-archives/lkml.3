Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422942Ab3CVUZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 16:25:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422696Ab3CVUZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 16:25:17 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/10] extend hugepage migration
Date: Fri, 22 Mar 2013 16:23:45 -0400
Message-Id: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the 2nd version of hugepage migration patchset.
I rebased it onto v3.9-rc3 and merged all feedbacks from Hillf,
Michal and Kosaki-san unless I missed something. Thank you guys.

I hope that we move onto 2nd iteration of the review process,
please let me know if you have something to discuss.

Thanks,
Naoya Horiguchi

--- General Description (exactly same with previous post) ---

Hugepage migration is now available only for soft offlining (moving
data on the half corrupted page to another page to save the data).
But it's also useful some other users of page migration, so this
patchset tries to extend some of such users to support hugepage.

The targets of this patchset are NUMA related system calls (i.e.
migrate_pages(2), move_pages(2), and mbind(2)), and memory hotplug.
This patchset does not extend page migration in memory compaction,
because I think that users of memory compaction mainly expect to
construct thp by arranging raw pages but hugepage migration doesn't
help it.
CMA, another user of page migration, can have benefit from hugepage
migration, but is not enabled to support it now. This is because
I've never used CMA and need to learn more to extend and/or test
hugepage migration in CMA. I'll add this in later version if it
becomes ready, or will post as a separate patchset.

Hugepage migration of 1GB hugepage is not enabled for now, because
I'm not sure whether users of 1GB hugepage really want it.
We need to spare free hugepage in order to do migration, but I don't
think that users want to 1GB memory to idle for that purpose
(currently we can't expand/shrink 1GB hugepage pool after boot).

---
Easy patch access:
  git://github.com/Naoya-Horiguchi/linux.git extend_hugepage_migration_v2

Test code:
  git://github.com/Naoya-Horiguchi/test_hugepage_migration_extension.git

Naoya Horiguchi (10):
      migrate: add migrate_entry_wait_huge()
      migrate: make core migration code aware of hugepage
      soft-offline: use migrate_pages() instead of migrate_huge_page()
      migrate: clean up migrate_huge_page()
      migrate: add hugepage migration code to migrate_pages()
      migrate: add hugepage migration code to move_pages()
      mbind: add hugepage migration code to mbind()
      migrate: remove VM_HUGETLB from vma flag check in vma_migratable()
      memory-hotplug: enable memory hotplug to handle hugepage
      prepare to remove /proc/sys/vm/hugepages_treat_as_movable

 Documentation/sysctl/vm.txt |  13 +-----
 include/linux/hugetlb.h     |  15 ++++++
 include/linux/mempolicy.h   |   2 +-
 include/linux/migrate.h     |  11 +++--
 include/linux/swapops.h     |   4 ++
 mm/hugetlb.c                | 110 ++++++++++++++++++++++++++++++++++++++------
 mm/memory-failure.c         |  15 ++++--
 mm/memory.c                 |   6 ++-
 mm/memory_hotplug.c         |  42 +++++++++++++----
 mm/mempolicy.c              |  56 ++++++++++++++--------
 mm/migrate.c                | 100 ++++++++++++++++++++++++++--------------
 mm/page_alloc.c             |  12 +++++
 mm/page_isolation.c         |   5 ++
 13 files changed, 293 insertions(+), 98 deletions(-)
