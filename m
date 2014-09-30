Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbaI3VuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:50:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32821 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbaI3ViZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:38:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guenter Roeck <linux@roeck-us.net>, Matt Fleming <matt.fleming@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 033/103] firmware: Do not use WARN_ON(!spin_is_locked())
Date: Tue, 30 Sep 2014 14:30:38 -0700
Message-Id: <1412112708-27356-34-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit aee530cfecf4f3ec83b78406bac618cec35853f8 upstream.

spin_is_locked() always returns false for uniprocessor configurations
in several architectures, so do not use WARN_ON with it.
Use lockdep_assert_held() instead to also reduce overhead in
non-debug kernels.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/firmware/efi/vars.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index b22659c..e612552 100644
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

