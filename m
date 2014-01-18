Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbaARLtP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 06:49:15 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49963 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbaARLsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 06:48:32 -0500
From: Borislav Petkov <bp@alien8.de>
To: Linux EFI <linux-efi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 5/5] efi: Split efi_enter_virtual_mode
Date: Sat, 18 Jan 2014 12:48:18 +0100
Message-Id: <1390045698-16882-6-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.5.2.192.g7794a68
In-Reply-To: <1390045698-16882-1-git-send-email-bp@alien8.de>
References: <1390045698-16882-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... into a kexec flavor for better code readability and simplicity. The
original one was getting ugly with ifdeffery.

Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/x86/platform/efi/efi.c | 148 +++++++++++++++++++++++++++++---------------
 include/linux/efi.h         |   1 +
 2 files changed, 99 insertions(+), 50 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index b79a85c8a6aa..bcc3e5117fd7 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -891,8 +891,9 @@ static void __init get_systab_virt_addr(efi_memory_desc_t *md)
 	}
 }
 
-static int __init save_runtime_map(void)
+static void __init save_runtime_map(void)
 {
+#ifdef CONFIG_KEXEC
 	efi_memory_desc_t *md;
 	void *tmp, *p, *q = NULL;
 	int count = 0;
@@ -914,28 +915,12 @@ static int __init save_runtime_map(void)
 	}
 
 	efi_runtime_map_setup(q, count, memmap.desc_size);
+	return;
 
-	return 0;
 out:
 	kfree(q);
-	return -ENOMEM;
-}
-
-/*
- * Map efi regions which were passed via setup_data. The virt_addr is a fixed
- * addr which was used in first kernel of a kexec boot.
- */
-static void __init efi_map_regions_fixed(void)
-{
-	void *p;
-	efi_memory_desc_t *md;
-
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
-		efi_map_region_fixed(md); /* FIXME: add error handling */
-		get_systab_virt_addr(md);
-	}
-
+	pr_err("Error saving runtime map, efi runtime on kexec non-functional!!\n");
+#endif
 }
 
 static void *realloc_pages(void *old_memmap, int old_shift)
@@ -1001,6 +986,72 @@ static void * __init efi_map_regions(int *count, int *pg_shift)
 	return new_memmap;
 }
 
+void __init kexec_enter_virtual_mode(void)
+{
+#ifdef CONFIG_KEXEC
+	efi_memory_desc_t *md;
+	void *p;
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
+	/*
+	* Map efi regions which were passed via setup_data. The virt_addr is a
+	* fixed addr which was used in first kernel of a kexec boot.
+	*/
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		efi_map_region_fixed(md); /* FIXME: add error handling */
+		get_systab_virt_addr(md);
+	}
+
+	save_runtime_map();
+
+	BUG_ON(!efi.systab);
+
+	efi_sync_low_kernel_mappings();
+
+	/*
+	 * Now that EFI is in virtual mode, update the function
+	 * pointers in the runtime service table to the new virtual addresses.
+	 *
+	 * Call EFI services through wrapper functions.
+	 */
+	efi.runtime_version = efi_systab.hdr.revision;
+	efi.get_time = virt_efi_get_time;
+	efi.set_time = virt_efi_set_time;
+	efi.get_wakeup_time = virt_efi_get_wakeup_time;
+	efi.set_wakeup_time = virt_efi_set_wakeup_time;
+	efi.get_variable = virt_efi_get_variable;
+	efi.get_next_variable = virt_efi_get_next_variable;
+	efi.set_variable = virt_efi_set_variable;
+	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
+	efi.reset_system = virt_efi_reset_system;
+	efi.set_virtual_address_map = NULL;
+	efi.query_variable_info = virt_efi_query_variable_info;
+	efi.update_capsule = virt_efi_update_capsule;
+	efi.query_capsule_caps = virt_efi_query_capsule_caps;
+
+	if (efi_enabled(EFI_OLD_MEMMAP) && (__supported_pte_mask & _PAGE_NX))
+		runtime_code_page_mkexec();
+
+	/* clean DUMMY object */
+	efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
+			 EFI_VARIABLE_NON_VOLATILE |
+			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
+			 EFI_VARIABLE_RUNTIME_ACCESS,
+			 0, NULL);
+#endif
+}
+
 /*
  * This function will switch the EFI runtime services to virtual mode.
  * Essentially, we look through the EFI memmap and map every region that
@@ -1020,11 +1071,12 @@ static void * __init efi_map_regions(int *count, int *pg_shift)
  *
  * Specially for kexec boot, efi runtime maps in previous kernel should
  * be passed in via setup_data. In that case runtime ranges will be mapped
- * to the same virtual addresses as the first kernel.
+ * to the same virtual addresses as the first kernel, see
+ * kexec_enter_virtual_mode().
  */
-void __init efi_enter_virtual_mode(void)
+static void __init __efi_enter_virtual_mode(void)
 {
-	int err, count = 0, pg_shift = 0;
+	int count = 0, pg_shift = 0;
 	void *new_memmap = NULL;
 	efi_status_t status;
 
@@ -1039,43 +1091,33 @@ void __init efi_enter_virtual_mode(void)
 		return;
 	}
 
-	if (efi_setup) {
-		efi_map_regions_fixed();
-	} else {
-		efi_merge_regions();
-		new_memmap = efi_map_regions(&count, &pg_shift);
-		if (!new_memmap) {
-			pr_err("Error reallocating memory, EFI runtime non-functional!\n");
-			return;
-		}
-
-		err = save_runtime_map();
-		if (err)
-			pr_err("Error saving runtime map, efi runtime on kexec non-functional!!\n");
+	efi_merge_regions();
+	new_memmap = efi_map_regions(&count, &pg_shift);
+	if (!new_memmap) {
+		pr_err("Error reallocating memory, EFI runtime non-functional!\n");
+		return;
 	}
 
+	save_runtime_map();
+
 	BUG_ON(!efi.systab);
 
-	if (!efi_setup) {
-		if (efi_setup_page_tables(__pa(new_memmap), 1 << pg_shift))
-			return;
-	}
+	if (efi_setup_page_tables(__pa(new_memmap), 1 << pg_shift))
+		return;
 
 	efi_sync_low_kernel_mappings();
 	efi_dump_pagetable();
 
-	if (!efi_setup) {
-		status = phys_efi_set_virtual_address_map(
+	status = phys_efi_set_virtual_address_map(
 			memmap.desc_size * count,
 			memmap.desc_size,
 			memmap.desc_version,
 			(efi_memory_desc_t *)__pa(new_memmap));
 
-		if (status != EFI_SUCCESS) {
-			pr_alert("Unable to switch EFI into virtual mode (status=%lx)!\n",
-				 status);
-			panic("EFI call to SetVirtualAddressMap() failed!");
-		}
+	if (status != EFI_SUCCESS) {
+		pr_alert("Unable to switch EFI into virtual mode (status=%lx)!\n",
+			 status);
+		panic("EFI call to SetVirtualAddressMap() failed!");
 	}
 
 	/*
@@ -1102,7 +1144,6 @@ void __init efi_enter_virtual_mode(void)
 	if (efi_enabled(EFI_OLD_MEMMAP) && (__supported_pte_mask & _PAGE_NX))
 		runtime_code_page_mkexec();
 
-
 	/*
 	 * We mapped the descriptor array into the EFI pagetable above but we're
 	 * not unmapping it here. Here's why:
@@ -1129,8 +1170,7 @@ void __init efi_enter_virtual_mode(void)
 	 *
 	 * efi_cleanup_page_tables(__pa(new_memmap), 1 << pg_shift);
 	 */
-	if (!efi_setup)
-		free_pages((unsigned long)new_memmap, pg_shift);
+	free_pages((unsigned long)new_memmap, pg_shift);
 
 	/* clean DUMMY object */
 	efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
@@ -1140,6 +1180,14 @@ void __init efi_enter_virtual_mode(void)
 			 0, NULL);
 }
 
+void __init efi_enter_virtual_mode(void)
+{
+	if (efi_setup)
+		kexec_enter_virtual_mode();
+	else
+		__efi_enter_virtual_mode();
+}
+
 /*
  * Convenience functions to obtain memory types and attributes
  */
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 0a819e7a60c9..44ea66ce41e0 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -594,6 +594,7 @@ extern void efi_map_pal_code (void);
 extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
 extern void efi_gettimeofday (struct timespec *ts);
 extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
+extern void kexec_enter_virtual_mode(void);
 #ifdef CONFIG_X86
 extern void efi_late_init(void);
 extern void efi_free_boot_services(void);
-- 
1.8.5.2.192.g7794a68

