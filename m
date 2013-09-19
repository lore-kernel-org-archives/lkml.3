Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab3ISO46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 10:56:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58785 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738Ab3ISOzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 10:55:06 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
        linux-efi@vger.kernel.org
Subject: [PATCH 02/11] efi: Remove EFI_PAGE_SHIFT and EFI_PAGE_SIZE
Date: Thu, 19 Sep 2013 16:54:45 +0200
Message-Id: <1379602494-26684-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379602494-26684-1-git-send-email-bp@alien8.de>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... and use the good old standard defines which we all know. Also,
simplify math to shift by PAGE_SHIFT instead of multiplying by
PAGE_SIZE.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/boot/compressed/eboot.c | 12 ++++++------
 arch/x86/boot/compressed/eboot.h |  1 -
 arch/x86/platform/efi/efi.c      | 22 +++++++++++-----------
 include/linux/efi.h              |  6 ++----
 4 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index b7388a425f09..5c440bf769a8 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -96,7 +96,7 @@ static efi_status_t high_alloc(unsigned long size, unsigned long align,
 	if (status != EFI_SUCCESS)
 		goto fail;
 
-	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+	nr_pages = round_up(size, PAGE_SIZE) / PAGE_SIZE;
 again:
 	for (i = 0; i < map_size / desc_size; i++) {
 		efi_memory_desc_t *desc;
@@ -111,7 +111,7 @@ again:
 			continue;
 
 		start = desc->phys_addr;
-		end = start + desc->num_pages * (1UL << EFI_PAGE_SHIFT);
+		end = start + (desc->num_pages << PAGE_SHIFT);
 
 		if ((start + size) > end || (start + size) > max)
 			continue;
@@ -173,7 +173,7 @@ static efi_status_t low_alloc(unsigned long size, unsigned long align,
 	if (status != EFI_SUCCESS)
 		goto fail;
 
-	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+	nr_pages = round_up(size, PAGE_SIZE) / PAGE_SIZE;
 	for (i = 0; i < map_size / desc_size; i++) {
 		efi_memory_desc_t *desc;
 		unsigned long m = (unsigned long)map;
@@ -188,7 +188,7 @@ static efi_status_t low_alloc(unsigned long size, unsigned long align,
 			continue;
 
 		start = desc->phys_addr;
-		end = start + desc->num_pages * (1UL << EFI_PAGE_SHIFT);
+		end = start + (desc->num_pages << PAGE_SHIFT);
 
 		/*
 		 * Don't allocate at 0x0. It will confuse code that
@@ -224,7 +224,7 @@ static void low_free(unsigned long size, unsigned long addr)
 {
 	unsigned long nr_pages;
 
-	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+	nr_pages = round_up(size, PAGE_SIZE) / PAGE_SIZE;
 	efi_call_phys2(sys_table->boottime->free_pages, addr, nr_pages);
 }
 
@@ -1128,7 +1128,7 @@ static efi_status_t relocate_kernel(struct setup_header *hdr)
 	 * possible.
 	 */
 	start = hdr->pref_address;
-	nr_pages = round_up(hdr->init_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+	nr_pages = round_up(hdr->init_size, PAGE_SIZE) / PAGE_SIZE;
 
 	status = efi_call_phys4(sys_table->boottime->allocate_pages,
 				EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
diff --git a/arch/x86/boot/compressed/eboot.h b/arch/x86/boot/compressed/eboot.h
index e5b0a8f91c5f..786398c1bb9a 100644
--- a/arch/x86/boot/compressed/eboot.h
+++ b/arch/x86/boot/compressed/eboot.h
@@ -11,7 +11,6 @@
 
 #define DESC_TYPE_CODE_DATA	(1 << 0)
 
-#define EFI_PAGE_SIZE		(1UL << EFI_PAGE_SHIFT)
 #define EFI_READ_CHUNK_SIZE	(1024 * 1024)
 
 #define EFI_CONSOLE_OUT_DEVICE_GUID    \
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 7cec1e9e5494..538c1e6b7b2c 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -339,7 +339,7 @@ static void __init do_add_efi_memmap(void)
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		efi_memory_desc_t *md = p;
 		unsigned long long start = md->phys_addr;
-		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
+		unsigned long long size = md->num_pages << PAGE_SHIFT;
 		int e820_type;
 
 		switch (md->type) {
@@ -416,8 +416,8 @@ static void __init print_efi_memmap(void)
 		pr_info("mem%02u: type=%u, attr=0x%llx, "
 			"range=[0x%016llx-0x%016llx) (%lluMB)\n",
 			i, md->type, md->attribute, md->phys_addr,
-			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
-			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
+			md->phys_addr + (md->num_pages << PAGE_SHIFT),
+			(md->num_pages >> (20 - PAGE_SHIFT)));
 	}
 #endif  /*  EFI_DEBUG  */
 }
@@ -429,7 +429,7 @@ void __init efi_reserve_boot_services(void)
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		efi_memory_desc_t *md = p;
 		u64 start = md->phys_addr;
-		u64 size = md->num_pages << EFI_PAGE_SHIFT;
+		u64 size = md->num_pages << PAGE_SHIFT;
 
 		if (md->type != EFI_BOOT_SERVICES_CODE &&
 		    md->type != EFI_BOOT_SERVICES_DATA)
@@ -473,7 +473,7 @@ void __init efi_free_boot_services(void)
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		efi_memory_desc_t *md = p;
 		unsigned long long start = md->phys_addr;
-		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
+		unsigned long long size = md->num_pages << PAGE_SHIFT;
 
 		if (md->type != EFI_BOOT_SERVICES_CODE &&
 		    md->type != EFI_BOOT_SERVICES_DATA)
@@ -825,7 +825,7 @@ void __iomem *efi_lookup_mapped_addr(u64 phys_addr)
 		return NULL;
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		efi_memory_desc_t *md = p;
-		u64 size = md->num_pages << EFI_PAGE_SHIFT;
+		u64 size = md->num_pages << PAGE_SHIFT;
 		u64 end = md->phys_addr + size;
 		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
 		    md->type != EFI_BOOT_SERVICES_CODE &&
@@ -843,7 +843,7 @@ void __iomem *efi_lookup_mapped_addr(u64 phys_addr)
 
 void efi_memory_uc(u64 addr, unsigned long size)
 {
-	unsigned long page_shift = 1UL << EFI_PAGE_SHIFT;
+	unsigned long page_shift = 1UL << PAGE_SHIFT;
 	u64 npages;
 
 	npages = round_up(size, page_shift) / page_shift;
@@ -896,7 +896,7 @@ void __init efi_enter_virtual_mode(void)
 			continue;
 		}
 
-		prev_size = prev_md->num_pages << EFI_PAGE_SHIFT;
+		prev_size = prev_md->num_pages << PAGE_SHIFT;
 
 		if (md->phys_addr == (prev_md->phys_addr + prev_size)) {
 			prev_md->num_pages += md->num_pages;
@@ -914,7 +914,7 @@ void __init efi_enter_virtual_mode(void)
 		    md->type != EFI_BOOT_SERVICES_DATA)
 			continue;
 
-		size = md->num_pages << EFI_PAGE_SHIFT;
+		size = md->num_pages << PAGE_SHIFT;
 		end = md->phys_addr + size;
 
 		start_pfn = PFN_DOWN(md->phys_addr);
@@ -1011,7 +1011,7 @@ u32 efi_mem_type(unsigned long phys_addr)
 		md = p;
 		if ((md->phys_addr <= phys_addr) &&
 		    (phys_addr < (md->phys_addr +
-				  (md->num_pages << EFI_PAGE_SHIFT))))
+				  (md->num_pages << PAGE_SHIFT))))
 			return md->type;
 	}
 	return 0;
@@ -1026,7 +1026,7 @@ u64 efi_mem_attributes(unsigned long phys_addr)
 		md = p;
 		if ((md->phys_addr <= phys_addr) &&
 		    (phys_addr < (md->phys_addr +
-				  (md->num_pages << EFI_PAGE_SHIFT))))
+				  (md->num_pages << PAGE_SHIFT))))
 			return md->attribute;
 	}
 	return 0;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 5f8f176154f7..fa47d80ab4b5 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -95,8 +95,6 @@ typedef	struct {
 #define EFI_MEMORY_RUNTIME	((u64)0x8000000000000000ULL)	/* range requires runtime mapping */
 #define EFI_MEMORY_DESCRIPTOR_VERSION	1
 
-#define EFI_PAGE_SHIFT		12
-
 typedef struct {
 	u32 type;
 	u32 pad;
@@ -611,7 +609,7 @@ static inline int efi_range_is_wc(unsigned long start, unsigned long len)
 {
 	unsigned long i;
 
-	for (i = 0; i < len; i += (1UL << EFI_PAGE_SHIFT)) {
+	for (i = 0; i < len; i += PAGE_SIZE) {
 		unsigned long paddr = __pa(start + i);
 		if (!(efi_mem_attributes(paddr) & EFI_MEMORY_WC))
 			return 0;
@@ -728,7 +726,7 @@ struct efi_generic_dev_path {
 
 static inline void memrange_efi_to_native(u64 *addr, u64 *npages)
 {
-	*npages = PFN_UP(*addr + (*npages<<EFI_PAGE_SHIFT)) - PFN_DOWN(*addr);
+	*npages = PFN_UP(*addr + (*npages << PAGE_SHIFT)) - PFN_DOWN(*addr);
 	*addr &= PAGE_MASK;
 }
 
-- 
1.8.4

