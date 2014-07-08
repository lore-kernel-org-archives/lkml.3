Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaGHGDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 02:03:46 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:36529 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbaGHGDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 02:03:45 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH v11 0/7] MADV_FREE support
Date: Tue,  8 Jul 2014 15:03:37 +0900
Message-Id: <1404799424-1120-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enable MADV_FREE hint for madvise syscall, which have
been supported by other OSes. [PATCH 1] includes the details.

[1] support MADVISE_FREE for !THP page so if VM encounter
THP page in syscall context, it splits THP page.
[2-6] is to preparing to call madvise syscall without THP plitting
[7] enable THP page support for MADV_FREE.

* From v10
 * Add Acked-by from arch stuff(x86, s390)
 * Pagewalker based pagetable working - Kirill
 * Fix try_to_unmap_one broken with hwpoison - Kirill
 * Use VM_BUG_ON_PAGE in madvise_free_pmd - Kirill
 * Fix pgtable-3level.h for arm - Steve

* From v9
 * Add Acked-by - Rik
 * Add THP page support - Kirill
 * Rebased-on v3.16-rc3-mmotm-2014-07-02-15-07

* From v8
 * Rebased-on v3.16-rc2-mmotm-2014-06-25-16-44

* From v7
 * Rebased-on next-20140613
 
* From v6
 * Remove page from swapcache in syscal time
 * Move utility functions from memory.c to madvise.c - Johannes
 * Rename untilify functtions - Johannes
 * Remove unnecessary checks from vmscan.c - Johannes
 * Rebased-on v3.15-rc5-mmotm-2014-05-16-16-56
 * Drop Reviewe-by because there was some changes since then.

* From v5
 * Fix PPC problem which don't flush TLB - Rik
 * Remove unnecessary lazyfree_range stub function - Rik
 * Rebased on v3.15-rc5

* From v4
 * Add Reviewed-by: Zhang Yanfei
 * Rebase on v3.15-rc1-mmotm-2014-04-15-16-14

* From v3
 * Add "how to work part" in description - Zhang
 * Add page_discardable utility function - Zhang
 * Clean up

* From v2
 * Remove forceful dirty marking of swap-readed page - Johannes
 * Remove deactivation logic of lazyfreed page
 * Rebased on 3.14
 * Remove RFC tag

* From v1
 * Use custom page table walker for madvise_free - Johannes
 * Remove PG_lazypage flag - Johannes
 * Do madvise_dontneed instead of madvise_freein swapless system

Minchan Kim (7):
  [1] mm: support madvise(MADV_FREE)
  [2] x86: add pmd_[dirty|mkclean] for THP
  [3] sparc: add pmd_[dirty|mkclean] for THP
  [4] powerpc: add pmd_[dirty|mkclean] for THP
  [5] s390: add pmd_[dirty|mkclean] for THP
  [6] ARM: add pmd_[dirty|mkclean] for THP
  [7] mm: Don't split THP page when syscall is called

 arch/arm/include/asm/pgtable-3level.h    |   3 +
 arch/arm64/include/asm/pgtable.h         |   2 +
 arch/powerpc/include/asm/pgtable-ppc64.h |   2 +
 arch/s390/include/asm/pgtable.h          |  12 +++
 arch/sparc/include/asm/pgtable_64.h      |  16 ++++
 arch/x86/include/asm/pgtable.h           |  10 ++
 include/linux/rmap.h                     |   9 +-
 include/linux/vm_event_item.h            |   1 +
 include/uapi/asm-generic/mman-common.h   |   1 +
 mm/madvise.c                             | 153 +++++++++++++++++++++++++++++++
 mm/rmap.c                                |  41 ++++++++-
 mm/vmscan.c                              |  64 +++++++++----
 mm/vmstat.c                              |   1 +
 13 files changed, 295 insertions(+), 20 deletions(-)

-- 
2.0.0

