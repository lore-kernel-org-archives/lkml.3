Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab3ETKxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:53:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56178 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab3ETKxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jerry Hoemann <jerry.hoemann@hp.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 056/115] x86/mm: account for PGDIR_SIZE alignment
Date: Mon, 20 May 2013 11:50:56 +0100
Message-Id: <1369047116-9378-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerry Hoemann <jerry.hoemann@hp.com>

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
Signed-off-by: Luis Henriques<luis.henriques@canonical.com>
---
 arch/x86/mm/init.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 4e4dcda..4779d7c 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -45,11 +45,15 @@ static void __init find_early_table_space(struct map_range *mr, int nr_range)
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
 
@@ -74,6 +78,7 @@ static void __init find_early_table_space(struct map_range *mr, int nr_range)
 	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
 	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
 	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
+	tables += (pgd_extra * PAGE_SIZE);
 
 #ifdef CONFIG_X86_32
 	/* for fixmap */
-- 
1.8.1.2

