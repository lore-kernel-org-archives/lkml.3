Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974AbaIZKbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:31:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32952 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671AbaIZJqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:02 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Matt Fleming <matt.fleming@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 041/142] firmware: Do not use WARN_ON(!spin_is_locked())
Date: Fri, 26 Sep 2014 11:44:12 +0200
Message-Id: <2617e71a8abc3fe12f44ed36e1cad3820a75d37c.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit aee530cfecf4f3ec83b78406bac618cec35853f8 upstream.

spin_is_locked() always returns false for uniprocessor configurations
in several architectures, so do not use WARN_ON with it.
Use lockdep_assert_held() instead to also reduce overhead in
non-debug kernels.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/firmware/efi/vars.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index b22659cccca4..e6125522860a 100644
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
2.1.0

