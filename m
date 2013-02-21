Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab3BUTms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:42:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110Ab3BUTmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:42:45 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 0/9] extend hugepage migration
Date: Thu, 21 Feb 2013 14:41:39 -0500
Message-Id: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

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

Could you review and give me some comments/feedbacks?

Thanks,
Naoya Horiguchi
---
Easy patch access:
  git@github.com:Naoya-Horiguchi/linux.git
  branch:extend_hugepage_migration

Test code:
  git@github.com:Naoya-Horiguchi/test_hugepage_migration_extension.git

Naoya Horiguchi (9):
      migrate: add migrate_entry_wait_huge()
      migrate: make core migration code aware of hugepage
      soft-offline: use migrate_pages() instead of migrate_huge_page()
      migrate: clean up migrate_huge_page()
      migrate: enable migrate_pages() to migrate hugepage
      migrate: enable move_pages() to migrate hugepage
      mbind: enable mbind() to migrate hugepage
      memory-hotplug: enable memory hotplug to handle hugepage
      remove /proc/sys/vm/hugepages_treat_as_movable

 Documentation/sysctl/vm.txt |  16 ------
 include/linux/hugetlb.h     |  25 ++++++++--
 include/linux/mempolicy.h   |   2 +-
 include/linux/migrate.h     |  12 ++---
 include/linux/swapops.h     |   4 ++
 kernel/sysctl.c             |   7 ---
 mm/hugetlb.c                |  98 ++++++++++++++++++++++++++++--------
 mm/memory-failure.c         |  20 ++++++--
 mm/memory.c                 |   6 ++-
 mm/memory_hotplug.c         |  51 +++++++++++++++----
 mm/mempolicy.c              |  61 +++++++++++++++--------
 mm/migrate.c                | 119 ++++++++++++++++++++++++++++++--------------
 mm/page_alloc.c             |  12 +++++
 mm/page_isolation.c         |   5 ++
 14 files changed, 311 insertions(+), 127 deletions(-)
