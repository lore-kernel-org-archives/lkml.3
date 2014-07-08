Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbaGHTtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:49:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54033 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755645AbaGHTIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mel Gorman" <mgorman@suse.de>,
        "Will Deacon" <will.deacon@arm.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.404298636@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 001/125] mm: highmem: don't treat PKMAP_ADDR(LAST_PKMAP)
 as a highmem address
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 498c2280212327858e521e9d21345d4cc2637f54 upstream.

kmap_to_page returns the corresponding struct page for a virtual address
of an arbitrary mapping.  This works by checking whether the address
falls in the pkmap region and using the pkmap page tables instead of the
linear mapping if appropriate.

Unfortunately, the bounds checking means that PKMAP_ADDR(LAST_PKMAP) is
incorrectly treated as a highmem address and we can end up walking off
the end of pkmap_page_table and subsequently passing junk to pte_page.

This patch fixes the bound check to stay within the pkmap tables.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/highmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index d517cd1..2da13a5 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -98,7 +98,7 @@ struct page *kmap_to_page(void *vaddr)
 {
 	unsigned long addr = (unsigned long)vaddr;
 
-	if (addr >= PKMAP_ADDR(0) && addr <= PKMAP_ADDR(LAST_PKMAP)) {
+	if (addr >= PKMAP_ADDR(0) && addr < PKMAP_ADDR(LAST_PKMAP)) {
 		int i = (addr - PKMAP_ADDR(0)) >> PAGE_SHIFT;
 		return pte_page(pkmap_page_table[i]);
 	}

