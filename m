Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933394Ab3E1D43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:56:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52672 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758939Ab3E1DyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Leonid Yegoshin" <Leonid.Yegoshin@imgtec.com>,
        "Russell King" <rmk@arm.linux.org.uk>,
        "David Miller" <davem@davemloft.net>, "Rik van Riel" <riel@redhat.com>,
        "Ralf Baechle" <ralf@linux-mips.org>,
        "Leonid Yegoshin" <yegoshin@mips.com>, "Mel Gorman" <mgorman@suse.de>,
        "Michal Hocko" <mhocko@suse.cz>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.539037276@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [63/94] mm compaction: fix of improper cache flush in migration code
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -147,7 +147,7 @@ static int remove_migration_pte(struct p
 	if (PageHuge(new))
 		pte = pte_mkhuge(pte);
 #endif
-	flush_cache_page(vma, addr, pte_pfn(pte));
+	flush_dcache_page(new);
 	set_pte_at(mm, addr, ptep, pte);
 
 	if (PageHuge(new)) {

