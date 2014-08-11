Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaHKDyU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 23:54:20 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:63774 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbaHKDyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 23:54:18 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Matt Fleming <matt.fleming@intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] firmware: Do not use WARN_ON(!spin_is_locked())
Date: Sun, 10 Aug 2014 20:54:13 -0700
Message-Id: <1407729253-31341-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spin_is_locked() always returns false for uniprocessor configurations,
so do not use WARN_ON with it. WARN_ON_SMP() exists for that very
purpose and must be used instead.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/firmware/efi/vars.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index f0a4364..6f3623c 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -481,7 +481,7 @@ EXPORT_SYMBOL_GPL(efivar_entry_remove);
  */
 static void efivar_entry_list_del_unlock(struct efivar_entry *entry)
 {
-	WARN_ON(!spin_is_locked(&__efivars->lock));
+	WARN_ON_SMP(!spin_is_locked(&__efivars->lock));
 
 	list_del(&entry->list);
 	spin_unlock_irq(&__efivars->lock);
@@ -507,7 +507,7 @@ int __efivar_entry_delete(struct efivar_entry *entry)
 	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	WARN_ON(!spin_is_locked(&__efivars->lock));
+	WARN_ON_SMP(!spin_is_locked(&__efivars->lock));
 
 	status = ops->set_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid,
@@ -667,7 +667,7 @@ struct efivar_entry *efivar_entry_find(efi_char16_t *name, efi_guid_t guid,
 	int strsize1, strsize2;
 	bool found = false;
 
-	WARN_ON(!spin_is_locked(&__efivars->lock));
+	WARN_ON_SMP(!spin_is_locked(&__efivars->lock));
 
 	list_for_each_entry_safe(entry, n, head, list) {
 		strsize1 = ucs2_strsize(name, 1024);
@@ -739,7 +739,7 @@ int __efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
 	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	WARN_ON(!spin_is_locked(&__efivars->lock));
+	WARN_ON_SMP(!spin_is_locked(&__efivars->lock));
 
 	status = ops->get_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid,
-- 
1.9.1

