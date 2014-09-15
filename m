Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbaIOVPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:15:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772AbaIOT0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:26:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 3.16 020/158] firmware: Do not use WARN_ON(!spin_is_locked())
Date: Mon, 15 Sep 2014 12:24:19 -0700
Message-Id: <20140915192543.490526106@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit aee530cfecf4f3ec83b78406bac618cec35853f8 upstream.

spin_is_locked() always returns false for uniprocessor configurations
in several architectures, so do not use WARN_ON with it.
Use lockdep_assert_held() instead to also reduce overhead in
non-debug kernels.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/vars.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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
@@ -507,7 +507,7 @@ int __efivar_entry_delete(struct efivar_
 	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	WARN_ON(!spin_is_locked(&__efivars->lock));
+	lockdep_assert_held(&__efivars->lock);
 
 	status = ops->set_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid,
@@ -667,7 +667,7 @@ struct efivar_entry *efivar_entry_find(e
 	int strsize1, strsize2;
 	bool found = false;
 
-	WARN_ON(!spin_is_locked(&__efivars->lock));
+	lockdep_assert_held(&__efivars->lock);
 
 	list_for_each_entry_safe(entry, n, head, list) {
 		strsize1 = ucs2_strsize(name, 1024);
@@ -739,7 +739,7 @@ int __efivar_entry_get(struct efivar_ent
 	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	WARN_ON(!spin_is_locked(&__efivars->lock));
+	lockdep_assert_held(&__efivars->lock);
 
 	status = ops->get_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid,


