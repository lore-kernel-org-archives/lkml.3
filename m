Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbaGQFB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 01:01:58 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:35579 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbaGQFB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 01:01:57 -0400
X-Original-SENDERIP: 10.177.222.156
X-Original-MAILFROM: minchan@kernel.org
Date: Thu, 17 Jul 2014 14:02:30 +0900
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v12 0/8] MADV_FREE support
Message-ID: <20140717050230.GB12333@bbox>
References: <1404886949-17695-1-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1404886949-17695-1-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill, Do you have any comment?

On Wed, Jul 09, 2014 at 03:22:21PM +0900, Minchan Kim wrote:
> This patch enable MADV_FREE hint for madvise syscall, which have
> been supported by other OSes. [PATCH 1] includes the details.
> 
> [1] support MADVISE_FREE for !THP page so if VM encounter
> THP page in syscall context, it splits THP page.
> [2-7] is to preparing to call madvise syscall without THP plitting
> [8] enable THP page support for MADV_FREE.
> 
> 
> * From v11
>  * Fix arm build - Steve
>  * Separate patch for arm and arm64 - Steve
>  * Remove unnecessary check - Kirill
>  * Skip non-vm_normal page - Kirill
>  * Add Acked-by - Zhang
>  * Sparc64 build fix
>  * Pagetable walker THP handling fix
> 
> * From v10
>  * Add Acked-by from arch stuff(x86, s390)
>  * Pagewalker based pagetable working - Kirill
>  * Fix try_to_unmap_one broken with hwpoison - Kirill
>  * Use VM_BUG_ON_PAGE in madvise_free_pmd - Kirill
>  * Fix pgtable-3level.h for arm - Steve
> 
> * From v9
>  * Add Acked-by - Rik
>  * Add THP page support - Kirill
> 
> * From v8
>  * Rebased-on v3.16-rc2-mmotm-2014-06-25-16-44
> 
> * From v7
>  * Rebased-on next-20140613
> 
> * From v6
>  * Remove page from swapcache in syscal time
>  * Move utility functions from memory.c to madvise.c - Johannes
>  * Rename untilify functtions - Johannes
>  * Remove unnecessary checks from vmscan.c - Johannes
>  * Rebased-on v3.15-rc5-mmotm-2014-05-16-16-56
>  * Drop Reviewe-by because there was some changes since then.
> 
> * From v5
>  * Fix PPC problem which don't flush TLB - Rik
>  * Remove unnecessary lazyfree_range stub function - Rik
>  * Rebased on v3.15-rc5
> 
> * From v4
>  * Add Reviewed-by: Zhang Yanfei
>  * Rebase on v3.15-rc1-mmotm-2014-04-15-16-14
> 
> * From v3
>  * Add "how to work part" in description - Zhang
>  * Add page_discardable utility function - Zhang
>  * Clean up
> 
> * From v2
>  * Remove forceful dirty marking of swap-readed page - Johannes
>  * Remove deactivation logic of lazyfreed page
>  * Rebased on 3.14
>  * Remove RFC tag
> 
> * From v1
>  * Use custom page table walker for madvise_free - Johannes
>  * Remove PG_lazypage flag - Johannes
>  * Do madvise_dontneed instead of madvise_freein swapless system
> 
> Minchan Kim (8):
>   [1] mm: support madvise(MADV_FREE)
>   [2] x86: add pmd_[dirty|mkclean] for THP
>   [3] sparc: add pmd_[dirty|mkclean] for THP
>   [4] powerpc: add pmd_[dirty|mkclean] for THP
>   [5] s390: add pmd_[dirty|mkclean] for THP
>   [6] arm: add pmd_[dirty|mkclean] for THP
>   [7] arm64: add pmd_[dirty|mkclean] for THP
>   [8] mm: Don't split THP page when syscall is called
> 
>  arch/arm/include/asm/pgtable-3level.h    |   3 +
>  arch/arm64/include/asm/pgtable.h         |   2 +
>  arch/powerpc/include/asm/pgtable-ppc64.h |   2 +
>  arch/s390/include/asm/pgtable.h          |  12 +++
>  arch/sparc/include/asm/pgtable_64.h      |  16 ++++
>  arch/x86/include/asm/pgtable.h           |  10 ++
>  include/linux/huge_mm.h                  |   4 +
>  include/linux/rmap.h                     |   9 +-
>  include/linux/vm_event_item.h            |   1 +
>  include/uapi/asm-generic/mman-common.h   |   1 +
>  mm/huge_memory.c                         |  35 +++++++
>  mm/madvise.c                             | 155 +++++++++++++++++++++++++++++++
>  mm/rmap.c                                |  46 ++++++++-
>  mm/vmscan.c                              |  64 +++++++++----
>  mm/vmstat.c                              |   1 +
>  15 files changed, 341 insertions(+), 20 deletions(-)
> 
> -- 
> 2.0.0
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
