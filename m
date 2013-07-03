Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468Ab3GCSwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:52:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3109 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933226Ab3GCSk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:40:58 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=WZBO0vgpxDMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=T98fOZTBIPEA:10 a=r_1tXGB3AAAA:8 a=gPJu0pBYAAAA:8 a=20KFwNOVAAAA:8 a=WPyIoOwQAAAA:8 a=drOt6m5kAAAA:8 a=J1Y8HTJGAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=a6djoXrbhetjRiC9FxAA:9 a=EDSpbFuiShEA:10 a=M6t7uCnp1osA:10 a=jEp0ucaQiEUA:10 a=0kPLrQdw3YYA:10 a=1DbiqZag68YA:10 a=4N9Db7Z2_RYA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=pogkObnYyZcfjUoU:21 a=9ML5fbr0RSFk6GDZ:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184048.863130458@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>,
        Leonid Yegoshin <yegoshin@mips.com>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        Russell King <rmk@arm.linux.org.uk>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [026/141] mm compaction: fix of improper cache flush in migration code
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0026-mm-compaction-fix-of-improper-cache-flush-in-migrati.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>

[ Upstream commit c2cc499c5bcf9040a738f49e8051b42078205748 ]

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 77ed2d7..a303524 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -146,7 +146,7 @@ static int remove_migration_pte(struct page *new, struct vm_area_struct *vma,
 	if (PageHuge(new))
 		pte = pte_mkhuge(pte);
 #endif
-	flush_cache_page(vma, addr, pte_pfn(pte));
+	flush_dcache_page(new);
 	set_pte_at(mm, addr, ptep, pte);
 
 	if (PageHuge(new)) {
-- 
1.7.10.4


