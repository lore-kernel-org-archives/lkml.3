Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbaGVNoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:44:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbaGVNof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:44:35 -0400
From: "Jerome Marchand" <jmarchan@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-doc@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux390@de.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH RESEND 0/5] mm, shmem: Enhance per-process accounting of shared memory
Date: Tue, 22 Jul 2014 15:43:47 +0200
Message-Id: <1406036632-26552-1-git-send-email-jmarchan@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several shortcomings with the accounting of shared memory
(sysV shm, shared anonymous mapping, mapping to a tmpfs file). The
values in /proc/<pid>/status and statm don't allow to distinguish
between shmem memory and a shared mapping to a regular file, even
though theirs implication on memory usage are quite different: at
reclaim, file mapping can be dropped or write back on disk while shmem
needs a place in swap. As for shmem pages that are swapped-out or in
swap cache, they aren't accounted at all.

This series addresses these issues by adding new fields to status and
smaps file in /proc/<pid>/. The accounting of resident shared memory is
made in the same way as it's currently done for resident memory and
general swap (a counter in mm_rss_stat), but this approach proved
impractical for paged-out shared memory (it would requires a rmap walk
each time a page is paged-in).

/proc/<pid>/smaps also lacks proper accounting of shared memory since
shmem subsystem hides all implementation detail to generic mm code.
This series adds the shmem_locate() function that returns the location
of a particular page (resident, in swap or swap cache). Called from
smaps code, it allows to show more detailled accounting of shmem
mappings in smaps.

Patch 1 adds a counter to keep track of resident shmem memory.
Patch 2 adds a function to allow generic code to know the physical
location of a shmem page.
Patch 3 adds simple helper function.
Patch 4 accounts swapped-out shmem in /proc/<pid>/status.
Patch 5 adds shmem specific fields to /proc/<pid>/smaps.

Thanks,
Jerome

Jerome Marchand (5):
  mm, shmem: Add shmem resident memory accounting
  mm, shmem: Add shmem_locate function
  mm, shmem: Add shmem_vma() helper
  mm, shmem: Add shmem swap memory accounting
  mm, shmem: Show location of non-resident shmem pages in smaps

 Documentation/filesystems/proc.txt |  15 ++++
 arch/s390/mm/pgtable.c             |   2 +-
 fs/proc/task_mmu.c                 | 139 +++++++++++++++++++++++++++++++++++--
 include/linux/mm.h                 |  20 ++++++
 include/linux/mm_types.h           |   7 +-
 kernel/events/uprobes.c            |   2 +-
 mm/filemap_xip.c                   |   2 +-
 mm/memory.c                        |  37 ++++++++--
 mm/rmap.c                          |   8 +--
 mm/shmem.c                         |  37 ++++++++++
 10 files changed, 249 insertions(+), 20 deletions(-)

-- 
1.9.3

