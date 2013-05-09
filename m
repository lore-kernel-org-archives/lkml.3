Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab3EIWiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:38:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46458 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab3EIWhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:37:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jerry Hoemann <jerry.hoemann@hp.com>
Subject: [ 12/12] x86/mm: account for PGDIR_SIZE alignment
Date: Thu,  9 May 2013 15:37:25 -0700
Message-Id: <20130509223612.711787446@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509223611.432377360@linuxfoundation.org>
References: <20130509223611.432377360@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerry Hoemann <jerry.hoemann@hp.com>

Patch for -stable.  Function find_early_table_space removed upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/mm/init.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -44,11 +44,15 @@ static void __init find_early_table_spac
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
 
@@ -73,6 +77,7 @@ static void __init find_early_table_spac
 	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
 	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
 	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
+	tables += (pgd_extra * PAGE_SIZE);
 
 #ifdef CONFIG_X86_32
 	/* for fixmap */


