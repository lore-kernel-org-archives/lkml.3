Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab3LTKFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:05:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072Ab3LTKFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:05:11 -0500
From: Dave Young <dyoung@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com, akpm@linux-foundation.org,
        mingo@kernel.org, msalter@redhat.com, leif.lindholm@linaro.org
Subject: [PATCH v7 06/12] efi: cleanup efi_enter_virtual_mode function
Date: Fri, 20 Dec 2013 18:02:16 +0800
Message-Id: <1387533742-18018-7-git-send-email-dyoung@redhat.com>
In-Reply-To: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
References: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add two small functions:
efi_merge_regions and efi_map_regions, efi_enter_virtual_mode
calls them instead of embedding two long for loop.

v1->v2:
refresh; coding style fixes.

v2->v3:
Toshi Kani:
remove unused variable
Matt: check return value of krealloc.
v3->v4:
Boris: Stretch comment to 80 cols
fix krealloc bug.
v4->v5:
Add a new share function get_systab_virt_addr() since later
efi_map_regions_fixed will call it.

Signed-off-by: Dave Young <dyoung@redhat.com>
Acked-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/platform/efi/efi.c | 132 ++++++++++++++++++++++++++------------------
 1 file changed, 79 insertions(+), 53 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index f022294..fd49100 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -766,44 +766,12 @@ void __init old_map_region(efi_memory_desc_t *md)
 		       (unsigned long long)md->phys_addr);
 }
 
-/*
- * This function will switch the EFI runtime services to virtual mode.
- * Essentially, we look through the EFI memmap and map every region that
- * has the runtime attribute bit set in its memory descriptor into the
- * ->trampoline_pgd page table using a top-down VA allocation scheme.
- *
- * The old method which used to update that memory descriptor with the
- * virtual address obtained from ioremap() is still supported when the
- * kernel is booted with efi=old_map on its command line. Same old
- * method enabled the runtime services to be called without having to
- * thunk back into physical mode for every invocation.
- *
- * The new method does a pagetable switch in a preemption-safe manner
- * so that we're in a different address space when calling a runtime
- * function. For function arguments passing we do copy the PGDs of the
- * kernel page table into ->trampoline_pgd prior to each call.
- */
-void __init efi_enter_virtual_mode(void)
+/* Merge contiguous regions of the same type and attribute */
+static void __init efi_merge_regions(void)
 {
+	void *p;
 	efi_memory_desc_t *md, *prev_md = NULL;
-	void *p, *new_memmap = NULL;
-	unsigned long size;
-	efi_status_t status;
-	u64 end, systab;
-	int count = 0;
-
-	efi.systab = NULL;
 
-	/*
-	 * We don't do virtual mode, since we don't do runtime services, on
-	 * non-native EFI
-	 */
-	if (!efi_is_native()) {
-		efi_unmap_memmap();
-		return;
-	}
-
-	/* Merge contiguous regions of the same type and attribute */
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		u64 prev_size;
 		md = p;
@@ -828,8 +796,31 @@ void __init efi_enter_virtual_mode(void)
 			continue;
 		}
 		prev_md = md;
+	}
+}
+
+static void __init get_systab_virt_addr(efi_memory_desc_t *md)
+{
+	unsigned long size;
+	u64 end, systab;
 
+	size = md->num_pages << EFI_PAGE_SHIFT;
+	end = md->phys_addr + size;
+	systab = (u64)(unsigned long)efi_phys.systab;
+	if (md->phys_addr <= systab && systab < end) {
+		systab += md->virt_addr - md->phys_addr;
+		efi.systab = (efi_system_table_t *)(unsigned long)systab;
 	}
+}
+
+/*
+ * Map efi memory ranges for runtime serivce and update new_memmap with virtual
+ * addresses.
+ */
+static void * __init efi_map_regions(int *count)
+{
+	efi_memory_desc_t *md;
+	void *p, *tmp, *new_memmap = NULL;
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
@@ -842,26 +833,64 @@ void __init efi_enter_virtual_mode(void)
 		}
 
 		efi_map_region(md);
+		get_systab_virt_addr(md);
+
+		tmp = krealloc(new_memmap, (*count + 1) * memmap.desc_size,
+			       GFP_KERNEL);
+		if (!tmp)
+			goto out_krealloc;
+		new_memmap = tmp;
+		memcpy(new_memmap + (*count * memmap.desc_size), md,
+		       memmap.desc_size);
+		(*count)++;
+	}
 
-		size = md->num_pages << EFI_PAGE_SHIFT;
-		end = md->phys_addr + size;
+	return new_memmap;
+out_krealloc:
+	kfree(new_memmap);
+	return NULL;
+}
+
+/*
+ * This function will switch the EFI runtime services to virtual mode.
+ * Essentially, we look through the EFI memmap and map every region that
+ * has the runtime attribute bit set in its memory descriptor into the
+ * ->trampoline_pgd page table using a top-down VA allocation scheme.
+ *
+ * The old method which used to update that memory descriptor with the
+ * virtual address obtained from ioremap() is still supported when the
+ * kernel is booted with efi=old_map on its command line. Same old
+ * method enabled the runtime services to be called without having to
+ * thunk back into physical mode for every invocation.
+ *
+ * The new method does a pagetable switch in a preemption-safe manner
+ * so that we're in a different address space when calling a runtime
+ * function. For function arguments passing we do copy the PGDs of the
+ * kernel page table into ->trampoline_pgd prior to each call.
+ */
+void __init efi_enter_virtual_mode(void)
+{
+	efi_status_t status;
+	void *new_memmap = NULL;
+	int count = 0;
 
-		systab = (u64) (unsigned long) efi_phys.systab;
-		if (md->phys_addr <= systab && systab < end) {
-			systab += md->virt_addr - md->phys_addr;
+	efi.systab = NULL;
 
-			efi.systab = (efi_system_table_t *) (unsigned long) systab;
-		}
+	/*
+	 * We don't do virtual mode, since we don't do runtime services, on
+	 * non-native EFI
+	 */
+	if (!efi_is_native()) {
+		efi_unmap_memmap();
+		return;
+	}
 
-		new_memmap = krealloc(new_memmap,
-				      (count + 1) * memmap.desc_size,
-				      GFP_KERNEL);
-		if (!new_memmap)
-			goto err_out;
+	efi_merge_regions();
 
-		memcpy(new_memmap + (count * memmap.desc_size), md,
-		       memmap.desc_size);
-		count++;
+	new_memmap = efi_map_regions(&count);
+	if (!new_memmap) {
+		pr_err("Error reallocating memory, EFI runtime non-functional!\n");
+		return;
 	}
 
 	BUG_ON(!efi.systab);
@@ -915,9 +944,6 @@ void __init efi_enter_virtual_mode(void)
 			 0, NULL);
 
 	return;
-
- err_out:
-	pr_err("Error reallocating memory, EFI runtime non-functional!\n");
 }
 
 /*
-- 
1.8.3.1

