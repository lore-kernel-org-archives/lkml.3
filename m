Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092AbaAHTvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:51:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbaAHTvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:51:13 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        x86@kernel.org, leif.lindholm@linaro.org,
        Roy Franz <roy.franz@linaro.org>, Mark Salter <msalter@redhat.com>
Subject: [PATCH] x86: efi: create memory map iteration helper
Date: Wed,  8 Jan 2014 14:50:53 -0500
Message-Id: <1389210653-15271-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are about a dozen places in the x86 EFI code which loop through
the EFI memory map descriptors. All of these places use essentially
the same for-loop code. This patch adds a for_each_efi_memory_desc()
helper to clean up all of the duplicate code and make it available
for other architectures to use.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/x86/platform/efi/efi.c    | 48 +++++++++++++-----------------------------
 arch/x86/platform/efi/efi_64.c |  5 +----
 drivers/firmware/efi/efi.c     |  5 ++---
 include/linux/efi.h            |  6 ++++++
 4 files changed, 24 insertions(+), 40 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index cceb813..211aa57 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -328,10 +328,9 @@ void efi_get_time(struct timespec *now)
 
 static void __init do_add_efi_memmap(void)
 {
-	void *p;
+	efi_memory_desc_t *md;
 
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		efi_memory_desc_t *md = p;
+	for_each_efi_memory_desc(&memmap, md) {
 		unsigned long long start = md->phys_addr;
 		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
 		int e820_type;
@@ -402,16 +401,12 @@ int __init efi_memblock_x86_reserve_range(void)
 static void __init print_efi_memmap(void)
 {
 	efi_memory_desc_t *md;
-	void *p;
-	int i;
+	int i = 0;
 
-	for (p = memmap.map, i = 0;
-	     p < memmap.map_end;
-	     p += memmap.desc_size, i++) {
-		md = p;
+	for_each_efi_memory_desc(&memmap, md) {
 		pr_info("mem%02u: type=%u, attr=0x%llx, "
 			"range=[0x%016llx-0x%016llx) (%lluMB)\n",
-			i, md->type, md->attribute, md->phys_addr,
+			i++, md->type, md->attribute, md->phys_addr,
 			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
 			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
 	}
@@ -420,10 +415,9 @@ static void __init print_efi_memmap(void)
 
 void __init efi_reserve_boot_services(void)
 {
-	void *p;
+	efi_memory_desc_t *md;
 
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		efi_memory_desc_t *md = p;
+	for_each_efi_memory_desc(&memmap, md) {
 		u64 start = md->phys_addr;
 		u64 size = md->num_pages << EFI_PAGE_SHIFT;
 
@@ -461,13 +455,12 @@ void __init efi_unmap_memmap(void)
 
 void __init efi_free_boot_services(void)
 {
-	void *p;
+	efi_memory_desc_t *md;
 
 	if (!efi_is_native())
 		return;
 
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		efi_memory_desc_t *md = p;
+	for_each_efi_memory_desc(&memmap, md) {
 		unsigned long long start = md->phys_addr;
 		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
 
@@ -718,12 +711,9 @@ void __init efi_set_executable(efi_memory_desc_t *md, bool executable)
 static void __init runtime_code_page_mkexec(void)
 {
 	efi_memory_desc_t *md;
-	void *p;
 
 	/* Make EFI runtime service code area executable */
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
-
+	for_each_efi_memory_desc(&memmap, md) {
 		if (md->type != EFI_RUNTIME_SERVICES_CODE)
 			continue;
 
@@ -755,7 +745,7 @@ void __init efi_enter_virtual_mode(void)
 	efi_status_t status;
 	unsigned long size;
 	u64 end, systab, start_pfn, end_pfn;
-	void *p, *va, *new_memmap = NULL;
+	void *va, *new_memmap = NULL;
 	int count = 0;
 
 	efi.systab = NULL;
@@ -771,9 +761,8 @@ void __init efi_enter_virtual_mode(void)
 	}
 
 	/* Merge contiguous regions of the same type and attribute */
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+	for_each_efi_memory_desc(&memmap, md) {
 		u64 prev_size;
-		md = p;
 
 		if (!prev_md) {
 			prev_md = md;
@@ -797,8 +786,7 @@ void __init efi_enter_virtual_mode(void)
 		prev_md = md;
 	}
 
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
+	for_each_efi_memory_desc(&memmap, md) {
 		if (!(md->attribute & EFI_MEMORY_RUNTIME)) {
 #ifdef CONFIG_X86_64
 			if (md->type != EFI_BOOT_SERVICES_CODE &&
@@ -895,33 +883,27 @@ void __init efi_enter_virtual_mode(void)
 u32 efi_mem_type(unsigned long phys_addr)
 {
 	efi_memory_desc_t *md;
-	void *p;
 
 	if (!efi_enabled(EFI_MEMMAP))
 		return 0;
 
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
+	for_each_efi_memory_desc(&memmap, md)
 		if ((md->phys_addr <= phys_addr) &&
 		    (phys_addr < (md->phys_addr +
 				  (md->num_pages << EFI_PAGE_SHIFT))))
 			return md->type;
-	}
 	return 0;
 }
 
 u64 efi_mem_attributes(unsigned long phys_addr)
 {
 	efi_memory_desc_t *md;
-	void *p;
 
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
+	for_each_efi_memory_desc(&memmap, md)
 		if ((md->phys_addr <= phys_addr) &&
 		    (phys_addr < (md->phys_addr +
 				  (md->num_pages << EFI_PAGE_SHIFT))))
 			return md->attribute;
-	}
 	return 0;
 }
 
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 39a0e7f..90aaefc 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -45,18 +45,15 @@ static unsigned long efi_flags __initdata;
 static void __init early_code_mapping_set_exec(int executable)
 {
 	efi_memory_desc_t *md;
-	void *p;
 
 	if (!(__supported_pte_mask & _PAGE_NX))
 		return;
 
 	/* Make EFI service code area executable */
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
+	for_each_efi_memory_desc(&memmap, md)
 		if (md->type == EFI_RUNTIME_SERVICES_CODE ||
 		    md->type == EFI_BOOT_SERVICES_CODE)
 			efi_set_executable(md, executable);
-	}
 }
 
 void __init efi_call_phys_prelog(void)
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 2e2fbde..70648da 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -158,14 +158,13 @@ subsys_initcall(efisubsys_init);
 void __iomem *efi_lookup_mapped_addr(u64 phys_addr)
 {
 	struct efi_memory_map *map;
-	void *p;
+	efi_memory_desc_t *md;
 	map = efi.memmap;
 	if (!map)
 		return NULL;
 	if (WARN_ON(!map->map))
 		return NULL;
-	for (p = map->map; p < map->map_end; p += map->desc_size) {
-		efi_memory_desc_t *md = p;
+	for_each_efi_memory_desc(map, md) {
 		u64 size = md->num_pages << EFI_PAGE_SHIFT;
 		u64 end = md->phys_addr + size;
 		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 11ce678..9dc5b05 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -618,6 +618,12 @@ extern int efi_set_rtc_mmss(const struct timespec *now);
 extern void efi_reserve_boot_services(void);
 extern struct efi_memory_map memmap;
 
+/* Iterate through an efi_memory_map */
+#define for_each_efi_memory_desc(m, md)					   \
+	for ((md) = (m)->map;						   \
+	     (md) <= (efi_memory_desc_t *)((m)->map_end - (m)->desc_size); \
+	     (md) = (void *)(md) + (m)->desc_size)
+
 /**
  * efi_range_is_wc - check the WC bit on an address range
  * @start: starting kvirt address
-- 
1.8.3.1

