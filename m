Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab3AXUYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:24:19 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:50775 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314Ab3AXUW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:22:29 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 28/35] memblock: Add memblock_mem_size()
Date: Thu, 24 Jan 2013 12:20:09 -0800
Message-Id: <1359058816-7615-29-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use it to get mem size under the limit_pfn.
to replace local version in x86 reserved_initrd.

-v2: remove not needed cast that is pointed out by HPA.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/setup.c  |   16 +---------------
 include/linux/memblock.h |    1 +
 mm/memblock.c            |   17 +++++++++++++++++
 3 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 398ec0c..1f1c68f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -363,20 +363,6 @@ static void __init relocate_initrd(void)
 		ramdisk_here, ramdisk_here + ramdisk_size - 1);
 }
 
-static u64 __init get_mem_size(unsigned long limit_pfn)
-{
-	int i;
-	u64 mapped_pages = 0;
-	unsigned long start_pfn, end_pfn;
-
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
-		start_pfn = min_t(unsigned long, start_pfn, limit_pfn);
-		end_pfn = min_t(unsigned long, end_pfn, limit_pfn);
-		mapped_pages += end_pfn - start_pfn;
-	}
-
-	return mapped_pages << PAGE_SHIFT;
-}
 static void __init early_reserve_initrd(void)
 {
 	/* Assume only end is not page aligned */
@@ -404,7 +390,7 @@ static void __init reserve_initrd(void)
 
 	initrd_start = 0;
 
-	mapped_size = get_mem_size(max_pfn_mapped);
+	mapped_size = memblock_mem_size(max_pfn_mapped);
 	if (ramdisk_size >= (mapped_size>>1))
 		panic("initrd too large to handle, "
 		       "disabling initrd (%lld needed, %lld available)\n",
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index d452ee1..f388203 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -155,6 +155,7 @@ phys_addr_t memblock_alloc_base(phys_addr_t size, phys_addr_t align,
 phys_addr_t __memblock_alloc_base(phys_addr_t size, phys_addr_t align,
 				  phys_addr_t max_addr);
 phys_addr_t memblock_phys_mem_size(void);
+phys_addr_t memblock_mem_size(unsigned long limit_pfn);
 phys_addr_t memblock_start_of_DRAM(void);
 phys_addr_t memblock_end_of_DRAM(void);
 void memblock_enforce_memory_limit(phys_addr_t memory_limit);
diff --git a/mm/memblock.c b/mm/memblock.c
index 88adc8a..b8d9147 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -828,6 +828,23 @@ phys_addr_t __init memblock_phys_mem_size(void)
 	return memblock.memory.total_size;
 }
 
+phys_addr_t __init memblock_mem_size(unsigned long limit_pfn)
+{
+	unsigned long pages = 0;
+	struct memblock_region *r;
+	unsigned long start_pfn, end_pfn;
+
+	for_each_memblock(memory, r) {
+		start_pfn = memblock_region_memory_base_pfn(r);
+		end_pfn = memblock_region_memory_end_pfn(r);
+		start_pfn = min_t(unsigned long, start_pfn, limit_pfn);
+		end_pfn = min_t(unsigned long, end_pfn, limit_pfn);
+		pages += end_pfn - start_pfn;
+	}
+
+	return (phys_addr_t)pages << PAGE_SHIFT;
+}
+
 /* lowest address */
 phys_addr_t __init_memblock memblock_start_of_DRAM(void)
 {
-- 
1.7.10.4

