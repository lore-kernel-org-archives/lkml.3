Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab3FEU7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:59:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36280 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757721Ab3FEUxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:53:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>,
        Leonid Yegoshin <yegoshin@mips.com>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        Russell King <rmk@arm.linux.org.uk>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 16/33] mm compaction: fix of improper cache flush in migration code
Date: Wed,  5 Jun 2013 13:52:54 -0700
Message-Id: <20130605204706.075067611@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605204702.359510786@linuxfoundation.org>
References: <20130605204702.359510786@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


