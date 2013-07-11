Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193Ab3GKO2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:28:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43307 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933078Ab3GKO1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:27:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "Lee, Chun-Y" <jlee@suse.com>, Matt Fleming <matt.fleming@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 94/98] Modify UEFI anti-bricking code
Date: Thu, 11 Jul 2013 15:25:04 +0100
Message-Id: <1373552708-15235-95-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Garrett <matthew.garrett@nebula.com>

commit f8b8404337de4e2466e2e1139ea68b1f8295974f upstream.

This patch reworks the UEFI anti-bricking code, including an effective
reversion of cc5a080c and 31ff2f20. It turns out that calling
QueryVariableInfo() from boot services results in some firmware
implementations jumping to physical addresses even after entering virtual
mode, so until we have 1:1 mappings for UEFI runtime space this isn't
going to work so well.

Reverting these gets us back to the situation where we'd refuse to create
variables on some systems because they classify deleted variables as "used"
until the firmware triggers a garbage collection run, which they won't do
until they reach a lower threshold. This results in it being impossible to
install a bootloader, which is unhelpful.

Feedback from Samsung indicates that the firmware doesn't need more than
5KB of storage space for its own purposes, so that seems like a reasonable
threshold. However, there's still no guarantee that a platform will attempt
garbage collection merely because it drops below this threshold. It seems
that this is often only triggered if an attempt to write generates a
genuine EFI_OUT_OF_RESOURCES error. We can force that by attempting to
create a variable larger than the remaining space. This should fail, but if
it somehow succeeds we can then immediately delete it.

I've tested this on the UEFI machines I have available, but I don't have
a Samsung and so can't verify that it avoids the bricking problem.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Lee, Chun-Y <jlee@suse.com> [ dummy variable cleanup ]
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
[ luis: backported to 3.5, based on bwh's backport to 3.2:
  - the reverted changes were never applied here ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/platform/efi/efi.c | 77 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 67 insertions(+), 10 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index da366ae..2c990b5 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -50,6 +50,13 @@
 
 #define EFI_DEBUG	1
 
+#define EFI_MIN_RESERVE 5120
+
+#define EFI_DUMMY_GUID \
+	EFI_GUID(0x4424ac57, 0xbe4b, 0x47dd, 0x9e, 0x97, 0xed, 0x50, 0xf0, 0x9f, 0x92, 0xa9)
+
+static efi_char16_t efi_dummy_name[6] = { 'D', 'U', 'M', 'M', 'Y', 0 };
+
 struct efi __read_mostly efi = {
 	.mps        = EFI_INVALID_TABLE_ADDR,
 	.acpi       = EFI_INVALID_TABLE_ADDR,
@@ -936,6 +943,13 @@ void __init efi_enter_virtual_mode(void)
 		runtime_code_page_mkexec();
 
 	kfree(new_memmap);
+
+	/* clean DUMMY object */
+	efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
+			 EFI_VARIABLE_NON_VOLATILE |
+			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
+			 EFI_VARIABLE_RUNTIME_ACCESS,
+			 0, NULL);
 }
 
 /*
@@ -987,22 +1001,65 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 	efi_status_t status;
 	u64 storage_size, remaining_size, max_size;
 
+	if (!(attributes & EFI_VARIABLE_NON_VOLATILE))
+		return 0;
+
 	status = efi.query_variable_info(attributes, &storage_size,
 					 &remaining_size, &max_size);
 	if (status != EFI_SUCCESS)
 		return status;
 
-	if (!max_size && remaining_size > size)
-		printk_once(KERN_ERR FW_BUG "Broken EFI implementation"
-			    " is returning MaxVariableSize=0\n");
-
-	if (!storage_size || size > remaining_size ||
-	    (max_size && size > max_size))
-		return EFI_OUT_OF_RESOURCES;
+	/*
+	 * Some firmware implementations refuse to boot if there's insufficient
+	 * space in the variable store. We account for that by refusing the
+	 * write if permitting it would reduce the available space to under
+	 * 5KB. This figure was provided by Samsung, so should be safe.
+	 */
+	if ((remaining_size - size < EFI_MIN_RESERVE) &&
+		!efi_no_storage_paranoia) {
+
+		/*
+		 * Triggering garbage collection may require that the firmware
+		 * generate a real EFI_OUT_OF_RESOURCES error. We can force
+		 * that by attempting to use more space than is available.
+		 */
+		unsigned long dummy_size = remaining_size + 1024;
+		void *dummy = kmalloc(dummy_size, GFP_ATOMIC);
+
+		status = efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
+					  EFI_VARIABLE_NON_VOLATILE |
+					  EFI_VARIABLE_BOOTSERVICE_ACCESS |
+					  EFI_VARIABLE_RUNTIME_ACCESS,
+					  dummy_size, dummy);
+
+		if (status == EFI_SUCCESS) {
+			/*
+			 * This should have failed, so if it didn't make sure
+			 * that we delete it...
+			 */
+			efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
+					 EFI_VARIABLE_NON_VOLATILE |
+					 EFI_VARIABLE_BOOTSERVICE_ACCESS |
+					 EFI_VARIABLE_RUNTIME_ACCESS,
+					 0, dummy);
+		}
 
-	if (!efi_no_storage_paranoia &&
-	    (remaining_size - size) < (storage_size / 2))
-		return EFI_OUT_OF_RESOURCES;
+		/*
+		 * The runtime code may now have triggered a garbage collection
+		 * run, so check the variable info again
+		 */
+		status = efi.query_variable_info(attributes, &storage_size,
+						 &remaining_size, &max_size);
+
+		if (status != EFI_SUCCESS)
+			return status;
+
+		/*
+		 * There still isn't enough room, so return an error
+		 */
+		if (remaining_size - size < EFI_MIN_RESERVE)
+			return EFI_OUT_OF_RESOURCES;
+	}
 
 	return EFI_SUCCESS;
 }
-- 
1.8.1.2

