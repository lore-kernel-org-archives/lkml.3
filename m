Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761691AbbA1Gof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 01:44:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760715AbbA1Gob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 01:44:31 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH 2/5] xen: use correct types for addresses in arch/x86/xen/setup.c
Date: Wed, 28 Jan 2015 07:44:22 +0100
Message-Id: <1422427465-25239-3-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1422427465-25239-1-git-send-email-jgross@suse.com>
References: <1422427465-25239-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In many places in arch/x86/xen/setup.c wrong types are used for
physical addresses (u64 or unsigned long long). Use phys_addr_t
instead.

Use macros already defined instead of open coding them.

Correct some other type mismatches.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/setup.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index d2520c3..4dcc608 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -64,7 +64,7 @@ static unsigned long xen_remap_mfn __initdata = INVALID_P2M_ENTRY;
  */
 #define EXTRA_MEM_RATIO		(10)
 
-static void __init xen_add_extra_mem(u64 start, u64 size)
+static void __init xen_add_extra_mem(phys_addr_t start, phys_addr_t size)
 {
 	int i;
 
@@ -87,10 +87,10 @@ static void __init xen_add_extra_mem(u64 start, u64 size)
 	memblock_reserve(start, size);
 }
 
-static void __init xen_del_extra_mem(u64 start, u64 size)
+static void __init xen_del_extra_mem(phys_addr_t start, phys_addr_t size)
 {
 	int i;
-	u64 start_r, size_r;
+	phys_addr_t start_r, size_r;
 
 	for (i = 0; i < XEN_EXTRA_MEM_MAX_REGIONS; i++) {
 		start_r = xen_extra_mem[i].start;
@@ -257,7 +257,7 @@ static void __init xen_set_identity_and_release_chunk(unsigned long start_pfn,
 static void __init xen_update_mem_tables(unsigned long pfn, unsigned long mfn)
 {
 	struct mmu_update update = {
-		.ptr = ((unsigned long long)mfn << PAGE_SHIFT) | MMU_MACHPHYS_UPDATE,
+		.ptr = ((uint64_t)mfn << PAGE_SHIFT) | MMU_MACHPHYS_UPDATE,
 		.val = pfn
 	};
 
@@ -535,14 +535,15 @@ static unsigned long __init xen_get_max_pages(void)
 	return min(max_pages, MAX_DOMAIN_PAGES);
 }
 
-static void xen_align_and_add_e820_region(u64 start, u64 size, int type)
+static void xen_align_and_add_e820_region(phys_addr_t start, phys_addr_t size,
+					  int type)
 {
-	u64 end = start + size;
+	phys_addr_t end = start + size;
 
 	/* Align RAM regions to page boundaries. */
 	if (type == E820_RAM) {
 		start = PAGE_ALIGN(start);
-		end &= ~((u64)PAGE_SIZE - 1);
+		end &= ~((phys_addr_t)PAGE_SIZE - 1);
 	}
 
 	e820_add_region(start, end - start, type);
@@ -567,7 +568,7 @@ char * __init xen_memory_setup(void)
 	static struct e820entry map[E820MAX] __initdata;
 
 	unsigned long max_pfn = xen_start_info->nr_pages;
-	unsigned long long mem_end;
+	phys_addr_t mem_end;
 	int rc;
 	struct xen_memory_map memmap;
 	unsigned long max_pages;
@@ -642,16 +643,16 @@ char * __init xen_memory_setup(void)
 			  extra_pages);
 	i = 0;
 	while (i < memmap.nr_entries) {
-		u64 addr = map[i].addr;
-		u64 size = map[i].size;
+		phys_addr_t addr = map[i].addr;
+		phys_addr_t size = map[i].size;
 		u32 type = map[i].type;
 
 		if (type == E820_RAM) {
 			if (addr < mem_end) {
 				size = min(size, mem_end - addr);
 			} else if (extra_pages) {
-				size = min(size, (u64)extra_pages * PAGE_SIZE);
-				extra_pages -= size / PAGE_SIZE;
+				size = min(size, PFN_PHYS(extra_pages));
+				extra_pages -= PFN_DOWN(size);
 				xen_add_extra_mem(addr, size);
 				xen_max_p2m_pfn = PFN_DOWN(addr + size);
 			} else
-- 
2.1.2

