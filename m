Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbaCSUAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:00:22 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:59909 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754882AbaCSUAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:00:20 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 4/5] efivars: Refactor sanity checking code into separate function
Date: Wed, 19 Mar 2014 19:59:59 +0000
Message-Id: <1395259200-27732-5-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395259200-27732-1-git-send-email-matt@console-pimps.org>
References: <1395259200-27732-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Move a large chunk of code that checks the validity of efi_variable into
a new function, because we'll also need to use it for the compat code.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 drivers/firmware/efi/efivars.c | 52 ++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 5ee2cfb96698..a44310c6a8ba 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -189,6 +189,35 @@ efivar_data_read(struct efivar_entry *entry, char *buf)
 	memcpy(buf, var->Data, var->DataSize);
 	return var->DataSize;
 }
+
+static inline int
+sanity_check(struct efi_variable *var, efi_char16_t *name, efi_guid_t vendor,
+	     unsigned long size, u32 attributes, u8 *data)
+{
+	/*
+	 * If only updating the variable data, then the name
+	 * and guid should remain the same
+	 */
+	if (memcmp(name, var->VariableName, sizeof(var->VariableName)) ||
+		efi_guidcmp(vendor, var->VendorGuid)) {
+		printk(KERN_ERR "efivars: Cannot edit the wrong variable!\n");
+		return -EINVAL;
+	}
+
+	if ((size <= 0) || (attributes == 0)){
+		printk(KERN_ERR "efivars: DataSize & Attributes must be valid!\n");
+		return -EINVAL;
+	}
+
+	if ((attributes & ~EFI_VARIABLE_MASK) != 0 ||
+	    efivar_validate(name, data, size) == false) {
+		printk(KERN_ERR "efivars: Malformed variable content\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /*
  * We allow each variable to be edited via rewriting the
  * entire efi variable structure.
@@ -215,26 +244,9 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 	size = new_var->DataSize;
 	data = new_var->Data;
 
-	/*
-	 * If only updating the variable data, then the name
-	 * and guid should remain the same
-	 */
-	if (memcmp(name, var->VariableName, sizeof(var->VariableName)) ||
-		efi_guidcmp(vendor, var->VendorGuid)) {
-		printk(KERN_ERR "efivars: Cannot edit the wrong variable!\n");
-		return -EINVAL;
-	}
-
-	if ((size <= 0) || (attributes == 0)){
-		printk(KERN_ERR "efivars: DataSize & Attributes must be valid!\n");
-		return -EINVAL;
-	}
-
-	if ((attributes & ~EFI_VARIABLE_MASK) != 0 ||
-	    efivar_validate(name, data, size) == false) {
-		printk(KERN_ERR "efivars: Malformed variable content\n");
-		return -EINVAL;
-	}
+	err = sanity_check(var, name, vendor, size, attributes, data);
+	if (err)
+		return err;
 
 	memcpy(&entry->var, new_var, count);
 
-- 
1.8.5.3

