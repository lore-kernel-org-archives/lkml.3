Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaHMSVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 14:21:42 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:35798 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaHMSVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 14:21:40 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH v2] firmware: Do not use WARN_ON(!spin_is_locked())
Date: Wed, 13 Aug 2014 11:21:34 -0700
Message-Id: <1407954094-26126-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spin_is_locked() always returns false for uniprocessor configurations
in several architectures, so do not use WARN_ON with it.
Use lockdep_assert_held() instead to also reduce overhead in
non-debug kernels.

Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: Use lockdep_assert_held instead of WARN_ON_SMP.

 drivers/firmware/efi/vars.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index f0a4364..5abe943 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -481,7 +481,7 @@ EXPORT_SYMBOL_GPL(efivar_entry_remove);
  */
 static void efivar_entry_list_del_unlock(struct efivar_entry *entry)
 {
-	WARN_ON(!spin_is_locked(&__efivars->lock));
+	lockdep_assert_held(&__efivars->lock);
 
 	list_del(&entry->list);
 	spin_unlock_irq(&__efivars->lock);
@@ -507,7 +507,7 @@ int __efivar_entry_delete(struct efivar_entry *entry)
 	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	WARN_ON(!spin_is_locked(&__efivars->lock));
+	lockdep_assert_held(&__efivars->lock);
 
 	status = ops->set_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid,
@@ -667,7 +667,7 @@ struct efivar_entry *efivar_entry_find(efi_char16_t *name, efi_guid_t guid,
 	int strsize1, strsize2;
 	bool found = false;
 
-	WARN_ON(!spin_is_locked(&__efivars->lock));
+	lockdep_assert_held(&__efivars->lock);
 
 	list_for_each_entry_safe(entry, n, head, list) {
 		strsize1 = ucs2_strsize(name, 1024);
@@ -739,7 +739,7 @@ int __efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
 	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	WARN_ON(!spin_is_locked(&__efivars->lock));
+	lockdep_assert_held(&__efivars->lock);
 
 	status = ops->get_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid,
-- 
1.9.1

