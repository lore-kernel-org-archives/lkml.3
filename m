Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab3J0EAn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 00:00:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938Ab3J0EAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 00:00:24 -0400
Message-Id: <20131027035923.081819853@dhcp-16-126.nay.redhat.com>
User-Agent: quilt/0.60-1
Date: Sun, 27 Oct 2013 11:47:16 +0800
From: dyoung@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.fedoraproject.org, kexec@lists.infradead.org, bp@alien8.de,
        Dave Young <dyoung@redhat.com>
Subject: [patch 3/6] Cleanup efi_enter_virtual_mode function
References: <20131027034713.481920209@dhcp-16-126.nay.redhat.com>
Content-Disposition: inline; filename=02-efi-enter-virtual-mode-cleanup-1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add two small functions:
efi_merge_regions and efi_map_regions, efi_enter_virtual_mode
calls them instead of embedding two long for loop.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/platform/efi/efi.c |   83 +++++++++++++++++++++++++++-----------------
 1 file changed, 52 insertions(+), 31 deletions(-)

--- efi.orig/arch/x86/platform/efi/efi.c
+++ efi/arch/x86/platform/efi/efi.c
@@ -789,35 +789,13 @@ void __init old_map_region(efi_memory_de
 		pr_err("ioremap of 0x%llX failed!\n",
 		       (unsigned long long)md->phys_addr);
 }
-/*
- * This function will switch the EFI runtime services to virtual mode.
- * Essentially, look through the EFI memmap and map every region that
- * has the runtime attribute bit set in its memory descriptor and update
- * that memory descriptor with the virtual address obtained from ioremap().
- * This enables the runtime services to be called without having to
- * thunk back into physical mode for every invocation.
- */
-void __init efi_enter_virtual_mode(void)
-{
-	efi_memory_desc_t *md, *prev_md = NULL;
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
+/* Merge contiguous regions of the same type and attribute */
+static void efi_merge_regions(void)
+{
+	void *p;
+ 	efi_memory_desc_t *md, *prev_md = NULL;
 
-	/* Merge contiguous regions of the same type and attribute */
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		u64 prev_size;
 		md = p;
@@ -844,6 +822,19 @@ void __init efi_enter_virtual_mode(void)
 		prev_md = md;
 
 	}
+}
+
+/*
+ * Map efi memory ranges for runtime serivce
+ * Return the new memmap with updated virtual addrresses.
+ */
+void efi_map_regions(void **new_memmap, int *count)
+{
+	efi_memory_desc_t *md, *prev_md = NULL;
+	void *p;
+	unsigned long size;
+	efi_status_t status;
+	u64 end, systab;
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
@@ -862,14 +853,44 @@ void __init efi_enter_virtual_mode(void)
 			systab += md->virt_addr - md->phys_addr;
 			efi.systab = (efi_system_table_t *) (unsigned long) systab;
 		}
-		new_memmap = krealloc(new_memmap,
-				      (count + 1) * memmap.desc_size,
+		*new_memmap = krealloc(*new_memmap,
+				      (*count + 1) * memmap.desc_size,
 				      GFP_KERNEL);
-		memcpy(new_memmap + (count * memmap.desc_size), md,
+		memcpy(*new_memmap + (*count * memmap.desc_size), md,
 		       memmap.desc_size);
-		count++;
+		(*count)++;
+	}
+}
+
+/*
+ * This function will switch the EFI runtime services to virtual mode.
+ * Essentially, look through the EFI memmap and map every region that
+ * has the runtime attribute bit set in its memory descriptor and update
+ * that memory descriptor with the virtual address obtained from ioremap().
+ * This enables the runtime services to be called without having to
+ * thunk back into physical mode for every invocation.
+ */
+void __init efi_enter_virtual_mode(void)
+{
+	efi_status_t status;
+	void *p, *new_memmap = NULL;
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
 	}
 
+	efi_merge_regions();
+
+	efi_map_regions(&new_memmap, &count);
+
 #ifdef CONFIG_X86_64
 	efi_scratch.efi_pgt = (pgd_t *)(unsigned long)real_mode_header->trampoline_pgd;
 

