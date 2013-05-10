Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab3EJOT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:19:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56902 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754117Ab3EJOTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:19:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, jerry.hoemann@hp.com,
        "Jerry Hoemann" <jerry.hoemann@hp.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.47019609@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [118/118] x86/mm: account for PGDIR_SIZE alignment
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: jerry.hoemann@hp.com

Patch for 3.0-stable.  Function find_early_table_space removed upstream.

Fixes panic in alloc_low_page due to pgt_buf overflow during
init_memory_mapping.

find_early_table_space sizes pgt_buf based upon the size of the
memory being mapped, but it does not take into account the alignment
of the memory.  When the region being mapped spans a 512GB (PGDIR_SIZE)
alignment, a panic from alloc_low_pages occurs.

kernel_physical_mapping_init takes into account PGDIR_SIZE alignment.
This causes an extra call to alloc_low_page to be made.  This extra call
isn't accounted for by find_early_table_space and causes a kernel panic.

Change is to take into account PGDIR_SIZE alignment in find_early_table_space.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/mm/init.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index c22c423..96c4577 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -44,11 +44,15 @@ static void __init find_early_table_space(struct map_range *mr, int nr_range)
 	int i;
 	unsigned long puds = 0, pmds = 0, ptes = 0, tables;
 	unsigned long start = 0, good_end;
+	unsigned long pgd_extra = 0;
 	phys_addr_t base;
 
 	for (i = 0; i < nr_range; i++) {
 		unsigned long range, extra;
 
+		if ((mr[i].end >> PGDIR_SHIFT) - (mr[i].start >> PGDIR_SHIFT))
+			pgd_extra++;
+
 		range = mr[i].end - mr[i].start;
 		puds += (range + PUD_SIZE - 1) >> PUD_SHIFT;
 
@@ -73,6 +77,7 @@ static void __init find_early_table_space(struct map_range *mr, int nr_range)
 	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
 	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
 	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
+	tables += (pgd_extra * PAGE_SIZE);
 
 #ifdef CONFIG_X86_32
 	/* for fixmap */

