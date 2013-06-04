Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522Ab3FDRDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:03:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48548 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758385Ab3FDRCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:02:55 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>,
        Leonid Yegoshin <yegoshin@mips.com>, Michal Hocko <mhocko@suse.cz>,
        Ralf Baechle <ralf@linux-mips.org>,
        Russell King <rmk@arm.linux.org.uk>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 50/75] mm compaction: fix of improper cache flush in migration code
Date: Tue,  4 Jun 2013 09:55:34 -0700
Message-Id: <1370364959-9475-51-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>

commit c2cc499c5bcf9040a738f49e8051b42078205748 upstream.

Page 'new' during MIGRATION can't be flushed with flush_cache_page().
Using flush_cache_page(vma, addr, pfn) is justified only if the page is
already placed in process page table, and that is done right after
flush_cache_page().  But without it the arch function has no knowledge
of process PTE and does nothing.

Besides that, flush_cache_page() flushes an application cache page, but
the kernel has a different page virtual address and dirtied it.

Replace it with flush_dcache_page(new) which is the proper usage.

The old page is flushed in try_to_unmap_one() before migration.

This bug takes place in Sead3 board with M14Kc MIPS CPU without cache
aliasing (but Harvard arch - separate I and D cache) in tight memory
environment (128MB) each 1-3days on SOAK test.  It fails in cc1 during
kernel build (SIGILL, SIGBUS, SIGSEG) if CONFIG_COMPACTION is switched
ON.

Signed-off-by: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
Cc: Leonid Yegoshin <yegoshin@mips.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 2fd8b4a..4c6250a 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -165,7 +165,7 @@ static int remove_migration_pte(struct page *new, struct vm_area_struct *vma,
 		pte = arch_make_huge_pte(pte, vma, new, 0);
 	}
 #endif
-	flush_cache_page(vma, addr, pte_pfn(pte));
+	flush_dcache_page(new);
 	set_pte_at(mm, addr, ptep, pte);
 
 	if (PageHuge(new)) {
-- 
1.8.1.2

