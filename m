Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab3IVWpf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 18:45:35 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:45733 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab3IVWpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 18:45:32 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com
Cc: leif.lindholm@linaro.org, grant.likely@linaro.org, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 07/18] Move relocate_kernel() to shared file.
Date: Sun, 22 Sep 2013 15:45:31 -0700
Message-Id: <1379889942-3135-8-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
References: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The relocate_kernel() function will be generalized and used
by all architectures, as they all have similar requirements.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 arch/x86/boot/compressed/eboot.c       |   34 -------------------------------
 drivers/firmware/efi/efi-stub-helper.c |   35 ++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 34 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 2a4430a..5bbba86 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -677,40 +677,6 @@ free_mem_map:
 	return status;
 }
 
-static efi_status_t relocate_kernel(struct setup_header *hdr)
-{
-	unsigned long start, nr_pages;
-	efi_status_t status;
-
-	/*
-	 * The EFI firmware loader could have placed the kernel image
-	 * anywhere in memory, but the kernel has various restrictions
-	 * on the max physical address it can run at. Attempt to move
-	 * the kernel to boot_params.pref_address, or as low as
-	 * possible.
-	 */
-	start = hdr->pref_address;
-	nr_pages = round_up(hdr->init_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
-
-	status = efi_call_phys4(sys_table->boottime->allocate_pages,
-				EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
-				nr_pages, &start);
-	if (status != EFI_SUCCESS) {
-		status = efi_low_alloc(sys_table, hdr->init_size,
-				   hdr->kernel_alignment, &start);
-		if (status != EFI_SUCCESS)
-			efi_printk(sys_table, "Failed to alloc mem for kernel\n");
-	}
-
-	if (status == EFI_SUCCESS)
-		memcpy((void *)start, (void *)(unsigned long)hdr->code32_start,
-		       hdr->init_size);
-
-	hdr->pref_address = hdr->code32_start;
-	hdr->code32_start = (__u32)start;
-
-	return status;
-}
 
 /*
  * On success we return a pointer to a boot_params structure, and NULL
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 9e451c6..1d5f219 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -483,3 +483,38 @@ fail:
 
 	return status;
 }
+
+static efi_status_t relocate_kernel(struct setup_header *hdr)
+{
+	unsigned long start, nr_pages;
+	efi_status_t status;
+
+	/*
+	 * The EFI firmware loader could have placed the kernel image
+	 * anywhere in memory, but the kernel has various restrictions
+	 * on the max physical address it can run at. Attempt to move
+	 * the kernel to boot_params.pref_address, or as low as
+	 * possible.
+	 */
+	start = hdr->pref_address;
+	nr_pages = round_up(hdr->init_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+
+	status = efi_call_phys4(sys_table->boottime->allocate_pages,
+				EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
+				nr_pages, &start);
+	if (status != EFI_SUCCESS) {
+		status = efi_low_alloc(sys_table, hdr->init_size,
+				   hdr->kernel_alignment, &start);
+		if (status != EFI_SUCCESS)
+			efi_printk(sys_table, "Failed to alloc mem for kernel\n");
+	}
+
+	if (status == EFI_SUCCESS)
+		memcpy((void *)start, (void *)(unsigned long)hdr->code32_start,
+		       hdr->init_size);
+
+	hdr->pref_address = hdr->code32_start;
+	hdr->code32_start = (__u32)start;
+
+	return status;
+}
-- 
1.7.10.4

