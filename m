Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab3KZF7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 00:59:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077Ab3KZF7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 00:59:14 -0500
From: Dave Young <dyoung@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com
Subject: [PATCH v4 04/12] efi: cleanup efi_enter_virtual_mode function
Date: Tue, 26 Nov 2013 13:57:49 +0800
Message-Id: <1385445477-9665-5-git-send-email-dyoung@redhat.com>
In-Reply-To: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
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

Signed-off-by: Dave Young <dyoung@redhat.com>
Acked-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/platform/efi/efi.c | 109 +++++++++++++++++++++++++++-----------------
 1 file changed, 66 insertions(+), 43 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 15e3b5e..480529a 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -773,44 +773,12 @@ void __init old_map_region(efi_memory_desc_t *md)
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
 
-	efi.systab = NULL;
-
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
@@ -837,6 +805,18 @@ void __init efi_enter_virtual_mode(void)
 		prev_md = md;
 
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
+	void *p, *new_memmap = NULL;
+	unsigned long size;
+	u64 end, systab;
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
@@ -861,14 +841,60 @@ void __init efi_enter_virtual_mode(void)
 		}
 
 		new_memmap = krealloc(new_memmap,
-				      (count + 1) * memmap.desc_size,
-				      GFP_KERNEL);
+					(*count + 1) * memmap.desc_size,
+					GFP_KERNEL);
 		if (!new_memmap)
-			goto err_out;
+			goto ret;
 
-		memcpy(new_memmap + (count * memmap.desc_size), md,
+		memcpy(new_memmap + (*count * memmap.desc_size), md,
 		       memmap.desc_size);
-		count++;
+		(*count)++;
+	}
+
+ret:
+	return new_memmap;
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
+
+	efi.systab = NULL;
+
+	/*
+	 * We don't do virtual mode, since we don't do runtime services, on
+	 * non-native EFI
+	 */
+	if (!efi_is_native()) {
+		efi_unmap_memmap();
+		return;
+	}
+
+	efi_merge_regions();
+
+	new_memmap = efi_map_regions(&count);
+	if (!new_memmap) {
+		pr_err("Error reallocating memory, EFI runtime non-functional!\n");
+		return;
 	}
 
 	BUG_ON(!efi.systab);
@@ -922,9 +948,6 @@ void __init efi_enter_virtual_mode(void)
 			 0, NULL);
 
 	return;
-
- err_out:
-	pr_err("Error reallocating memory, EFI runtime non-functional!\n");
 }
 
 /*
-- 
1.8.3.1

