Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab3DOUKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 16:10:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40559 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab3DOUKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 16:10:05 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: matt.fleming@intel.com
Cc: linux-efi@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH V6 3/3] efi: Distinguish between "remaining space" and actually used space
Date: Mon, 15 Apr 2013 13:09:47 -0700
Message-Id: <1366056587-24414-4-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366056587-24414-1-git-send-email-matthew.garrett@nebula.com>
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com>
 <1366056587-24414-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 50.0.250.146
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EFI implementations distinguish between space that is actively used by a
variable and space that merely hasn't been garbage collected yet. Space
that hasn't yet been garbage collected isn't available for use and so isn't
counted in the remaining_space field returned by QueryVariableInfo().

Combined with commit 68d9298 this can cause problems. Some implementations
don't garbage collect until the remaining space is smaller than the maximum
variable size, and as a result check_var_size() will always fail once more
than 50% of the variable store has been used even if most of that space is
marked as available for garbage collection. The user is unable to create
new variables, and deleting variables doesn't increase the remaining space.

The problem that 68d9298 was attempting to avoid was one where certain
platforms fail if the actively used space is greater than 50% of the
available storage space. We should be able to calculate that by simply
summing the size of each available variable and subtracting that from
the total storage space. With luck this will fix the problem described in
https://bugzilla.kernel.org/show_bug.cgi?id=55471 without permitting
damage to occur to the machines 68d9298 was attempting to fix.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 arch/x86/platform/efi/efi.c | 109 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 102 insertions(+), 7 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index e844d82..a3f03cd 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -41,6 +41,7 @@
 #include <linux/io.h>
 #include <linux/reboot.h>
 #include <linux/bcd.h>
+#include <linux/ucs2_string.h>
 
 #include <asm/setup.h>
 #include <asm/efi.h>
@@ -51,6 +52,13 @@
 
 #define EFI_DEBUG	1
 
+/*
+ * There's some additional metadata associated with each
+ * variable. Intel's reference implementation is 60 bytes - bump that
+ * to account for potential alignment constraints
+ */
+#define VAR_METADATA_SIZE 64
+
 struct efi __read_mostly efi = {
 	.mps        = EFI_INVALID_TABLE_ADDR,
 	.acpi       = EFI_INVALID_TABLE_ADDR,
@@ -72,6 +80,9 @@ static efi_system_table_t efi_systab __initdata;
 static u64 efi_var_store_size;
 static u64 efi_var_remaining_size;
 static u64 efi_var_max_var_size;
+static u64 boot_used_size;
+static u64 boot_var_size;
+static u64 active_size;
 
 unsigned long x86_efi_facility;
 
@@ -166,8 +177,53 @@ static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
 					       efi_char16_t *name,
 					       efi_guid_t *vendor)
 {
-	return efi_call_virt3(get_next_variable,
-			      name_size, name, vendor);
+	efi_status_t status;
+	static bool finished = false;
+	static u64 var_size;
+
+	status = efi_call_virt3(get_next_variable,
+				name_size, name, vendor);
+
+	if (status == EFI_NOT_FOUND) {
+		finished = true;
+		if (var_size < boot_used_size) {
+			boot_var_size = boot_used_size - var_size;
+			active_size += boot_var_size;
+		} else {
+			printk(KERN_WARNING FW_BUG  "efi: Inconsistent initial sizes\n");
+		}
+	}
+
+	if (boot_used_size && !finished) {
+		unsigned long size;
+		u32 attr;
+		efi_status_t s;
+		void *tmp;
+
+		s = virt_efi_get_variable(name, vendor, &attr, &size, NULL);
+
+		if (s != EFI_BUFFER_TOO_SMALL || !size)
+			return status;
+
+		tmp = kmalloc(size, GFP_ATOMIC);
+
+		if (!tmp)
+			return status;
+
+		s = virt_efi_get_variable(name, vendor, &attr, &size, tmp);
+
+		if (s == EFI_SUCCESS && (attr & EFI_VARIABLE_NON_VOLATILE)) {
+			var_size += size;
+			var_size += ucs2_strsize(name, 1024);
+			active_size += size;
+			active_size += VAR_METADATA_SIZE;
+			active_size += ucs2_strsize(name, 1024);
+		}
+
+		kfree(tmp);
+	}
+
+	return status;
 }
 
 static efi_status_t virt_efi_set_variable(efi_char16_t *name,
@@ -176,9 +232,34 @@ static efi_status_t virt_efi_set_variable(efi_char16_t *name,
 					  unsigned long data_size,
 					  void *data)
 {
-	return efi_call_virt5(set_variable,
-			      name, vendor, attr,
-			      data_size, data);
+	efi_status_t status;
+	u32 orig_attr = 0;
+	unsigned long orig_size = 0;
+
+	status = virt_efi_get_variable(name, vendor, &orig_attr, &orig_size,
+				       NULL);
+
+	if (status != EFI_BUFFER_TOO_SMALL)
+		orig_size = 0;
+
+	status = efi_call_virt5(set_variable,
+				name, vendor, attr,
+				data_size, data);
+
+	if (status == EFI_SUCCESS) {
+		if (orig_size) {
+			active_size -= orig_size;
+			active_size -= ucs2_strsize(name, 1024);
+			active_size -= VAR_METADATA_SIZE;
+		}
+		if (data_size) {
+			active_size += data_size;
+			active_size += ucs2_strsize(name, 1024);
+			active_size += VAR_METADATA_SIZE;
+		}
+	}
+
+	return status;
 }
 
 static efi_status_t virt_efi_query_variable_info(u32 attr,
@@ -720,6 +801,8 @@ void __init efi_init(void)
 		early_iounmap(data, sizeof(*efi_var_data));
 	}
 
+	boot_used_size = efi_var_store_size - efi_var_remaining_size;
+
 	set_bit(EFI_SYSTEM_TABLES, &x86_efi_facility);
 
 	/*
@@ -1039,8 +1122,20 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 	if (status != EFI_SUCCESS)
 		return status;
 
-	if (!storage_size || size > remaining_size || size > max_size ||
-	    (remaining_size - size) < (storage_size / 2))
+	/*
+	 * Some firmware implementations refuse to boot if there's insufficient
+	 * space in the variable store. We account for that by refusing the
+	 * write if permitting it would reduce the available space to under
+	 * 50%. However, some firmware won't reclaim variable space until
+	 * after the used (not merely the actively used) space drops below
+	 * a threshold. We can approximate that case with the value calculated
+	 * above. If both the firmware and our calculations indicate that the
+	 * available space would drop below 50%, refuse the write.
+	 */
+
+	if (!storage_size || size > remaining_size ||
+	    ((active_size + size + VAR_METADATA_SIZE > storage_size / 2) &&
+	     (remaining_size - size < storage_size / 2)))
 		return EFI_OUT_OF_RESOURCES;
 
 	return EFI_SUCCESS;
-- 
1.8.1.2

