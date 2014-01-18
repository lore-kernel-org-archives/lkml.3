Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbaARLtR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 06:49:17 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49972 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbaARLsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 06:48:33 -0500
From: Borislav Petkov <bp@alien8.de>
To: Linux EFI <linux-efi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 4/5] efi: Make efi virtual runtime map passing more robust
Date: Sat, 18 Jan 2014 12:48:17 +0100
Message-Id: <1390045698-16882-5-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.5.2.192.g7794a68
In-Reply-To: <1390045698-16882-1-git-send-email-bp@alien8.de>
References: <1390045698-16882-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Currently, running SetVirtualAddressMap() and passing the physical
address of the virtual map array was working only by a lucky coincidence
because the memory was present in the EFI page table too. Until Toshi
went and booted this on a big HP box - the krealloc() manner of resizing
the memmap we're doing did allocate from such physical addresses which
were not mapped anymore and boom:

http://lkml.kernel.org/r/1386806463.1791.295.camel@misato.fc.hp.com

One way to take care of that issue is to reimplement the krealloc thing
but with pages. We start with contiguous pages of order 1, i.e. 2 pages,
and when we deplete that memory (shouldn't happen all that often but you
know firmware) we realloc the next power-of-two pages.

Having the pages, it is much more handy and easy to map them into the
EFI page table with the already existing mapping code which we're using
for building the virtual mappings.

Thanks to Toshi Kani and Matt for the great debugging help.

Reported-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/x86/include/asm/efi.h     |  3 +-
 arch/x86/platform/efi/efi.c    | 99 +++++++++++++++++++++++++++++++++---------
 arch/x86/platform/efi/efi_32.c |  6 ++-
 arch/x86/platform/efi/efi_64.c | 32 ++++++++++++--
 4 files changed, 114 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index dfc319e7a7b8..b473f2541e67 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -130,7 +130,8 @@ extern void efi_memory_uc(u64 addr, unsigned long size);
 extern void __init efi_map_region(efi_memory_desc_t *md);
 extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
 extern void efi_sync_low_kernel_mappings(void);
-extern void efi_setup_page_tables(void);
+extern int efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages);
+extern void efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages);
 extern void __init old_map_region(efi_memory_desc_t *md);
 extern void __init efi_dump_pagetable(void);
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 35450ab3a123..b79a85c8a6aa 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -938,14 +938,36 @@ static void __init efi_map_regions_fixed(void)
 
 }
 
+static void *realloc_pages(void *old_memmap, int old_shift)
+{
+	void *ret;
+
+	ret = (void *)__get_free_pages(GFP_KERNEL, old_shift + 1);
+	if (!ret)
+		goto out;
+
+	/*
+	 * A first-time allocation doesn't have anything to copy.
+	 */
+	if (!old_memmap)
+		return ret;
+
+	memcpy(ret, old_memmap, PAGE_SIZE << old_shift);
+
+out:
+	free_pages((unsigned long)old_memmap, old_shift);
+	return ret;
+}
+
 /*
- * Map efi memory ranges for runtime serivce and update new_memmap with virtual
- * addresses.
+ * Map the efi memory ranges of the runtime services and update new_mmap with
+ * virtual addresses.
  */
-static void * __init efi_map_regions(int *count)
+static void * __init efi_map_regions(int *count, int *pg_shift)
 {
+	void *p, *new_memmap = NULL;
+	unsigned long left = 0;
 	efi_memory_desc_t *md;
-	void *p, *tmp, *new_memmap = NULL;
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
@@ -960,20 +982,23 @@ static void * __init efi_map_regions(int *count)
 		efi_map_region(md);
 		get_systab_virt_addr(md);
 
-		tmp = krealloc(new_memmap, (*count + 1) * memmap.desc_size,
-			       GFP_KERNEL);
-		if (!tmp)
-			goto out;
-		new_memmap = tmp;
+		if (left < memmap.desc_size) {
+			new_memmap = realloc_pages(new_memmap, *pg_shift);
+			if (!new_memmap)
+				return NULL;
+
+			left += PAGE_SIZE << *pg_shift;
+			(*pg_shift)++;
+		}
+
 		memcpy(new_memmap + (*count * memmap.desc_size), md,
 		       memmap.desc_size);
+
+		left -= memmap.desc_size;
 		(*count)++;
 	}
 
 	return new_memmap;
-out:
-	kfree(new_memmap);
-	return NULL;
 }
 
 /*
@@ -999,9 +1024,9 @@ out:
  */
 void __init efi_enter_virtual_mode(void)
 {
-	efi_status_t status;
+	int err, count = 0, pg_shift = 0;
 	void *new_memmap = NULL;
-	int err, count = 0;
+	efi_status_t status;
 
 	efi.systab = NULL;
 
@@ -1018,20 +1043,24 @@ void __init efi_enter_virtual_mode(void)
 		efi_map_regions_fixed();
 	} else {
 		efi_merge_regions();
-		new_memmap = efi_map_regions(&count);
+		new_memmap = efi_map_regions(&count, &pg_shift);
 		if (!new_memmap) {
 			pr_err("Error reallocating memory, EFI runtime non-functional!\n");
 			return;
 		}
-	}
 
-	err = save_runtime_map();
-	if (err)
-		pr_err("Error saving runtime map, efi runtime on kexec non-functional!!\n");
+		err = save_runtime_map();
+		if (err)
+			pr_err("Error saving runtime map, efi runtime on kexec non-functional!!\n");
+	}
 
 	BUG_ON(!efi.systab);
 
-	efi_setup_page_tables();
+	if (!efi_setup) {
+		if (efi_setup_page_tables(__pa(new_memmap), 1 << pg_shift))
+			return;
+	}
+
 	efi_sync_low_kernel_mappings();
 	efi_dump_pagetable();
 
@@ -1073,7 +1102,35 @@ void __init efi_enter_virtual_mode(void)
 	if (efi_enabled(EFI_OLD_MEMMAP) && (__supported_pte_mask & _PAGE_NX))
 		runtime_code_page_mkexec();
 
-	kfree(new_memmap);
+
+	/*
+	 * We mapped the descriptor array into the EFI pagetable above but we're
+	 * not unmapping it here. Here's why:
+	 *
+	 * We're copying select PGDs from the kernel page table to the EFI page
+	 * table and when we do so and make changes to those PGDs like unmapping
+	 * stuff from them, those changes appear in the kernel page table and we
+	 * go boom.
+	 *
+	 * From setup_real_mode():
+	 *
+	 * ...
+	 * trampoline_pgd[0] = init_level4_pgt[pgd_index(__PAGE_OFFSET)].pgd;
+	 *
+	 * In this particular case, our allocation is in PGD 0 of the EFI page
+	 * table but we've copied that PGD from PGD[272] of the EFI page table:
+	 *
+	 *	pgd_index(__PAGE_OFFSET = 0xffff880000000000) = 272
+	 *
+	 * where the direct memory mapping in kernel space is.
+	 *
+	 * new_memmap's VA comes from that direct mapping and thus clearing it,
+	 * it would get cleared in the kernel page table too.
+	 *
+	 * efi_cleanup_page_tables(__pa(new_memmap), 1 << pg_shift);
+	 */
+	if (!efi_setup)
+		free_pages((unsigned long)new_memmap, pg_shift);
 
 	/* clean DUMMY object */
 	efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index b9b827cbfecc..7ad87ee09525 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -40,8 +40,12 @@
 static unsigned long efi_rt_eflags;
 
 void efi_sync_low_kernel_mappings(void) {}
-void efi_setup_page_tables(void) {}
 void __init efi_dump_pagetable(void) {}
+int efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
+{
+	return 0;
+}
+void efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages) {}
 
 void __init efi_map_region(efi_memory_desc_t *md)
 {
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 76fce828c31d..0998f3a536ff 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -137,12 +137,38 @@ void efi_sync_low_kernel_mappings(void)
 		sizeof(pgd_t) * num_pgds);
 }
 
-void efi_setup_page_tables(void)
+int efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 {
+	pgd_t *pgd;
+
+	if (efi_enabled(EFI_OLD_MEMMAP))
+		return 0;
+
 	efi_scratch.efi_pgt = (pgd_t *)(unsigned long)real_mode_header->trampoline_pgd;
+	pgd = __va(efi_scratch.efi_pgt);
 
-	if (!efi_enabled(EFI_OLD_MEMMAP))
-		efi_scratch.use_pgd = true;
+	/*
+	 * It can happen that the physical address of new_memmap lands in memory
+	 * which is not mapped in the EFI page table. Therefore we need to go
+	 * and ident-map those pages containing the map before calling
+	 * phys_efi_set_virtual_address_map().
+	 */
+	if (kernel_map_pages_in_pgd(pgd, pa_memmap, pa_memmap, num_pages, _PAGE_NX)) {
+		pr_err("Error ident-mapping new memmap (0x%lx)!\n", pa_memmap);
+		return 1;
+	}
+
+	efi_scratch.use_pgd = true;
+
+
+	return 0;
+}
+
+void efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages)
+{
+	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
+
+	kernel_unmap_pages_in_pgd(pgd, pa_memmap, num_pages);
 }
 
 static void __init __map_region(efi_memory_desc_t *md, u64 va)
-- 
1.8.5.2.192.g7794a68

