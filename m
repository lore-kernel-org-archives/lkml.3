Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057Ab3CHSri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 13:47:38 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:44764 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759575Ab3CHSrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 13:47:37 -0500
X-IronPort-AV: E=Sophos;i="4.84,809,1355097600"; 
   d="scan'208";a="11507195"
From: David Vrabel <david.vrabel@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH] x86,mm: fix init_mem_mapping() when the first memory chunk is small
Date: Fri, 8 Mar 2013 18:47:14 +0000
Message-ID: <1362768434-30525-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In init_mem_mapping(), if the first chunk of memory that is mapped is
small, there will not be enough mapped pages to allocate page table
pages for the next (larger) chunk.

Estimate how many pages are used for the mappings so far and how many
are needed for a larger chunk, and only increase step_size if there
are enough free pages.

This fixes a boot failure on a system where the first chunk of memory
mapped only had 3 pages in it.

init_memory_mapping: [mem 0x00000000-0x000fffff]
init_memory_mapping: [mem 0x20d000000-0x20d002fff]
init_memory_mapping: [mem 0x20c000000-0x20cffffff]
Kernel panic - not syncing: alloc_low_page: can not alloc memory

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/mm/init.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 4903a03..0cc7afb 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -389,6 +389,12 @@ static unsigned long __init init_range_memory_mapping(
 	return mapped_ram_size;
 }
 
+/* Estimate of the number of pages needed to page 'size' bytes. */
+static unsigned long __init nr_pages_to_map(unsigned long size)
+{
+	return DIV_ROUND_UP(size, PMD_SIZE) + DIV_ROUND_UP(size, PUD_SIZE);
+}
+
 /* (PUD_SHIFT-PMD_SHIFT)/2 */
 #define STEP_SIZE_SHIFT 5
 void __init init_mem_mapping(void)
@@ -397,7 +403,7 @@ void __init init_mem_mapping(void)
 	unsigned long step_size;
 	unsigned long addr;
 	unsigned long mapped_ram_size = 0;
-	unsigned long new_mapped_ram_size;
+	unsigned long mapped_pages;
 
 	probe_page_size_mask();
 
@@ -427,14 +433,17 @@ void __init init_mem_mapping(void)
 				start = ISA_END_ADDRESS;
 		} else
 			start = ISA_END_ADDRESS;
-		new_mapped_ram_size = init_range_memory_mapping(start,
-							last_start);
+		mapped_ram_size += init_range_memory_mapping(start,
+							     last_start);
+		mapped_pages = mapped_ram_size >> PAGE_SHIFT;
 		last_start = start;
 		min_pfn_mapped = last_start >> PAGE_SHIFT;
-		/* only increase step_size after big range get mapped */
-		if (new_mapped_ram_size > mapped_ram_size)
+
+		/* Only increase step_size if there is enough mapped
+		   ram to map the larger block. */
+		if (nr_pages_to_map(step_size << STEP_SIZE_SHIFT)
+		    < mapped_pages - nr_pages_to_map(mapped_ram_size))
 			step_size <<= STEP_SIZE_SHIFT;
-		mapped_ram_size += new_mapped_ram_size;
 	}
 
 	if (real_end < end)
-- 
1.7.2.5

