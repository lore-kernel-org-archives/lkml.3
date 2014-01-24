Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaAXTLB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 14:11:01 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35002 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbaAXTK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 14:10:57 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave.hansen@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/3] memblock, nobootmem: Add memblock_virt_alloc_low()
Date: Fri, 24 Jan 2014 11:11:10 -0800
Message-Id: <1390590670-25901-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1390590670-25901-1-git-send-email-yinghai@kernel.org>
References: <1390590670-25901-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new memblock_virt APIs are used to replaced old bootmem API.

We need to allocate page below 4G for swiotlb.

That should fix regression on Andrew's system that is using swiotlb.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

---
 arch/arm/kernel/setup.c |    2 +-
 include/linux/bootmem.h |   37 +++++++++++++++++++++++++++++++++++++
 lib/swiotlb.c           |    4 ++--
 3 files changed, 40 insertions(+), 3 deletions(-)

Index: linux-2.6/include/linux/bootmem.h
===================================================================
--- linux-2.6.orig/include/linux/bootmem.h
+++ linux-2.6/include/linux/bootmem.h
@@ -175,6 +175,27 @@ static inline void * __init memblock_vir
 						    NUMA_NO_NODE);
 }
 
+#ifndef ARCH_LOW_ADDRESS_LIMIT
+#define ARCH_LOW_ADDRESS_LIMIT  0xffffffffUL
+#endif
+
+static inline void * __init memblock_virt_alloc_low(
+					phys_addr_t size, phys_addr_t align)
+{
+	return memblock_virt_alloc_try_nid(size, align,
+						   BOOTMEM_LOW_LIMIT,
+						   ARCH_LOW_ADDRESS_LIMIT,
+						   NUMA_NO_NODE);
+}
+static inline void * __init memblock_virt_alloc_low_nopanic(
+					phys_addr_t size, phys_addr_t align)
+{
+	return memblock_virt_alloc_try_nid_nopanic(size, align,
+						   BOOTMEM_LOW_LIMIT,
+						   ARCH_LOW_ADDRESS_LIMIT,
+						   NUMA_NO_NODE);
+}
+
 static inline void * __init memblock_virt_alloc_from_nopanic(
 		phys_addr_t size, phys_addr_t align, phys_addr_t min_addr)
 {
@@ -238,6 +259,22 @@ static inline void * __init memblock_vir
 	return __alloc_bootmem_nopanic(size, align, BOOTMEM_LOW_LIMIT);
 }
 
+static inline void * __init memblock_virt_alloc_low(
+					phys_addr_t size, phys_addr_t align)
+{
+	if (!align)
+		align = SMP_CACHE_BYTES;
+	return __alloc_bootmem_low(size, align, BOOTMEM_LOW_LIMIT);
+}
+
+static inline void * __init memblock_virt_alloc_low_nopanic(
+					phys_addr_t size, phys_addr_t align)
+{
+	if (!align)
+		align = SMP_CACHE_BYTES;
+	return __alloc_bootmem_low_nopanic(size, align, BOOTMEM_LOW_LIMIT);
+}
+
 static inline void * __init memblock_virt_alloc_from_nopanic(
 		phys_addr_t size, phys_addr_t align, phys_addr_t min_addr)
 {
Index: linux-2.6/lib/swiotlb.c
===================================================================
--- linux-2.6.orig/lib/swiotlb.c
+++ linux-2.6/lib/swiotlb.c
@@ -172,7 +172,7 @@ int __init swiotlb_init_with_tbl(char *t
 	/*
 	 * Get the overflow emergency buffer
 	 */
-	v_overflow_buffer = memblock_virt_alloc_nopanic(
+	v_overflow_buffer = memblock_virt_alloc_low_nopanic(
 						PAGE_ALIGN(io_tlb_overflow),
 						PAGE_SIZE);
 	if (!v_overflow_buffer)
@@ -220,7 +220,7 @@ swiotlb_init(int verbose)
 	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
 
 	/* Get IO TLB memory from the low pages */
-	vstart = memblock_virt_alloc_nopanic(PAGE_ALIGN(bytes), PAGE_SIZE);
+	vstart = memblock_virt_alloc_low_nopanic(PAGE_ALIGN(bytes), PAGE_SIZE);
 	if (vstart && !swiotlb_init_with_tbl(vstart, io_tlb_nslabs, verbose))
 		return;
 
Index: linux-2.6/arch/arm/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/setup.c
+++ linux-2.6/arch/arm/kernel/setup.c
@@ -717,7 +717,7 @@ static void __init request_standard_reso
 	kernel_data.end     = virt_to_phys(_end - 1);
 
 	for_each_memblock(memory, region) {
-		res = memblock_virt_alloc(sizeof(*res), 0);
+		res = memblock_virt_alloc_low(sizeof(*res), 0);
 		res->name  = "System RAM";
 		res->start = __pfn_to_phys(memblock_region_memory_base_pfn(region));
 		res->end = __pfn_to_phys(memblock_region_memory_end_pfn(region)) - 1;
