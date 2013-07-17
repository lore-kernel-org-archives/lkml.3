Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934163Ab3GQWxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:53:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56372 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757852Ab3GQWw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:52:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "Lee, Chun-Y" <jlee@suse.com>, Matt Fleming <matt.fleming@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 140/145] Modify UEFI anti-bricking code
Date: Wed, 17 Jul 2013 15:47:52 -0700
Message-Id: <1374101277-7915-141-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/platform/efi/efi.c | 71 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 68 insertions(+), 3 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 55452cd..87e91ba 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -51,6 +51,13 @@
 
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
@@ -972,6 +979,13 @@ void __init efi_enter_virtual_mode(void)
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
@@ -1023,14 +1037,65 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 	efi_status_t status;
 	u64 storage_size, remaining_size, max_size;
 
+	if (!(attributes & EFI_VARIABLE_NON_VOLATILE))
+		return 0;
+
 	status = efi.query_variable_info(attributes, &storage_size,
 					 &remaining_size, &max_size);
 	if (status != EFI_SUCCESS)
 		return status;
 
-	if (!storage_size || size > remaining_size || size > max_size ||
-	    (remaining_size - size) < (storage_size / 2))
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
+
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

