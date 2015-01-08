Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbbAHStN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:49:13 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:51408 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244AbbAHStJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:49:09 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: leif.lindholm@linaro.org, roy.franz@linaro.org, matt.fleming@intel.com,
        will.deacon@arm.com, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        bp@alien8.de, msalter@redhat.com, geoff.levand@linaro.org,
        dyoung@redhat.com, mark.rutland@arm.com, linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 4/8] efi: efistub: allow allocation alignment larger than EFI_PAGE_SIZE
Date: Thu,  8 Jan 2015 18:48:30 +0000
Message-Id: <1420742914-2404-5-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1420742914-2404-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1420742914-2404-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On systems with 64 KB pages, it is preferable for UEFI memory map
entries to be 64 KB aligned multiples of 64 KB, because it relieves
us of having to deal with the residues.
So, if EFI_ALLOC_ALIGN is #define'd by the platform, use it to round
up all memory allocations made.

Acked-by: Matt Fleming <matt.fleming@intel.com>
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index a920fec8fe88..e766df60fbfb 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -32,6 +32,15 @@
 
 static unsigned long __chunk_size = EFI_READ_CHUNK_SIZE;
 
+/*
+ * Allow the platform to override the allocation granularity: this allows
+ * systems that have the capability to run with a larger page size to deal
+ * with the allocations for initrd and fdt more efficiently.
+ */
+#ifndef EFI_ALLOC_ALIGN
+#define EFI_ALLOC_ALIGN		EFI_PAGE_SIZE
+#endif
+
 struct file_info {
 	efi_file_handle_t *handle;
 	u64 size;
@@ -150,10 +159,10 @@ efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 	 * a specific address.  We are doing page-based allocations,
 	 * so we must be aligned to a page.
 	 */
-	if (align < EFI_PAGE_SIZE)
-		align = EFI_PAGE_SIZE;
+	if (align < EFI_ALLOC_ALIGN)
+		align = EFI_ALLOC_ALIGN;
 
-	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+	nr_pages = round_up(size, EFI_ALLOC_ALIGN) / EFI_PAGE_SIZE;
 again:
 	for (i = 0; i < map_size / desc_size; i++) {
 		efi_memory_desc_t *desc;
@@ -235,10 +244,10 @@ efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 	 * a specific address.  We are doing page-based allocations,
 	 * so we must be aligned to a page.
 	 */
-	if (align < EFI_PAGE_SIZE)
-		align = EFI_PAGE_SIZE;
+	if (align < EFI_ALLOC_ALIGN)
+		align = EFI_ALLOC_ALIGN;
 
-	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+	nr_pages = round_up(size, EFI_ALLOC_ALIGN) / EFI_PAGE_SIZE;
 	for (i = 0; i < map_size / desc_size; i++) {
 		efi_memory_desc_t *desc;
 		unsigned long m = (unsigned long)map;
@@ -292,7 +301,7 @@ void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
 	if (!size)
 		return;
 
-	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+	nr_pages = round_up(size, EFI_ALLOC_ALIGN) / EFI_PAGE_SIZE;
 	efi_call_early(free_pages, addr, nr_pages);
 }
 
@@ -561,7 +570,7 @@ efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
 	 * to the preferred address.  If that fails, allocate as low
 	 * as possible while respecting the required alignment.
 	 */
-	nr_pages = round_up(alloc_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+	nr_pages = round_up(alloc_size, EFI_ALLOC_ALIGN) / EFI_PAGE_SIZE;
 	status = efi_call_early(allocate_pages,
 				EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
 				nr_pages, &efi_addr);
-- 
1.8.3.2

