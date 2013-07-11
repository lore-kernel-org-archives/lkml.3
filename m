Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162Ab3GKObY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:31:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43262 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933086Ab3GKO1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:27:08 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Seiji Aguchi <seiji.aguchi@hds.com>, Tony Luck <tony.luck@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 88/98] efivars: Disable external interrupt while holding efivars->lock
Date: Thu, 11 Jul 2013 15:24:58 +0100
Message-Id: <1373552708-15235-89-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seiji Aguchi <seiji.aguchi@hds.com>

commit 81fa4e581d9283f7992a0d8c534bb141eb840a14 upstream.

[Problem]
There is a scenario which efi_pstore fails to log messages in a panic case.

 - CPUA holds an efi_var->lock in either efivarfs parts
   or efi_pstore with interrupt enabled.
 - CPUB panics and sends IPI to CPUA in smp_send_stop().
 - CPUA stops with holding the lock.
 - CPUB kicks efi_pstore_write() via kmsg_dump(KSMG_DUMP_PANIC)
   but it returns without logging messages.

[Patch Description]
This patch disables an external interruption while holding efivars->lock
as follows.

In efi_pstore_write() and get_var_data(), spin_lock/spin_unlock is
replaced by spin_lock_irqsave/spin_unlock_irqrestore because they may
be called in an interrupt context.

In other functions, they are replaced by spin_lock_irq/spin_unlock_irq.
because they are all called from a process context.

By applying this patch, we can avoid the problem above with
a following senario.

 - CPUA holds an efi_var->lock with interrupt disabled.
 - CPUB panics and sends IPI to CPUA in smp_send_stop().
 - CPUA receives the IPI after releasing the lock because it is
   disabling interrupt while holding the lock.
 - CPUB waits for one sec until CPUA releases the lock.
 - CPUB kicks efi_pstore_write() via kmsg_dump(KSMG_DUMP_PANIC)
   And it can hold the lock successfully.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
Acked-by: Mike Waychison <mikew@google.com>
Acked-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
[ luis: backport to 3.4, based on bwh's backport to 3.2:
  - Drop efivarfs changes
  - Adjust context
  - Drop change to efi_pstore_erase(), which is implemented using
    efi_pstore_write() here ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/firmware/efivars.c | 44 +++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 3c8fd0f..13f631c 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -398,10 +398,11 @@ static efi_status_t
 get_var_data(struct efivars *efivars, struct efi_variable *var)
 {
 	efi_status_t status;
+	unsigned long flags;
 
-	spin_lock(&efivars->lock);
+	spin_lock_irqsave(&efivars->lock, flags);
 	status = get_var_data_locked(efivars, var);
-	spin_unlock(&efivars->lock);
+	spin_unlock_irqrestore(&efivars->lock, flags);
 
 	if (status != EFI_SUCCESS) {
 		printk(KERN_WARNING "efivars: get_variable() failed 0x%lx!\n",
@@ -530,14 +531,14 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 		return -EINVAL;
 	}
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 	status = efivars->ops->set_variable(new_var->VariableName,
 					    &new_var->VendorGuid,
 					    new_var->Attributes,
 					    new_var->DataSize,
 					    new_var->Data);
 
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 
 	if (status != EFI_SUCCESS) {
 		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
@@ -646,7 +647,7 @@ static int efi_pstore_open(struct pstore_info *psi)
 {
 	struct efivars *efivars = psi->data;
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 	efivars->walk_entry = list_first_entry(&efivars->list,
 					       struct efivar_entry, list);
 	return 0;
@@ -656,7 +657,7 @@ static int efi_pstore_close(struct pstore_info *psi)
 {
 	struct efivars *efivars = psi->data;
 
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 	return 0;
 }
 
@@ -712,11 +713,12 @@ static int efi_pstore_write(enum pstore_type_id type,
 	int i, ret = 0;
 	u64 storage_space, remaining_space, max_variable_size;
 	efi_status_t status = EFI_NOT_FOUND;
+	unsigned long flags;
 
 	sprintf(stub_name, "dump-type%u-%u-", type, part);
 	sprintf(name, "%s%lu", stub_name, get_seconds());
 
-	spin_lock(&efivars->lock);
+	spin_lock_irqsave(&efivars->lock, flags);
 
 	/*
 	 * Check if there is a space enough to log.
@@ -728,7 +730,7 @@ static int efi_pstore_write(enum pstore_type_id type,
 						   &remaining_space,
 						   &max_variable_size);
 	if (status || remaining_space < size + DUMP_NAME_LEN * 2) {
-		spin_unlock(&efivars->lock);
+		spin_unlock_irqrestore(&efivars->lock, flags);
 		*id = part;
 		return -ENOSPC;
 	}
@@ -769,7 +771,7 @@ static int efi_pstore_write(enum pstore_type_id type,
 	efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
 				   size, psi->buf);
 
-	spin_unlock(&efivars->lock);
+	spin_unlock_irqrestore(&efivars->lock, flags);
 
 	if (found)
 		efivar_unregister(found);
@@ -840,7 +842,7 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 		return -EINVAL;
 	}
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 
 	/*
 	 * Does this variable already exist?
@@ -858,7 +860,7 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 		}
 	}
 	if (found) {
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		return -EINVAL;
 	}
 
@@ -872,10 +874,10 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 	if (status != EFI_SUCCESS) {
 		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
 			status);
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		return -EIO;
 	}
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 
 	/* Create the entry in sysfs.  Locking is not required here */
 	status = efivar_create_sysfs_entry(efivars,
@@ -903,7 +905,7 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 
 	/*
 	 * Does this variable already exist?
@@ -921,7 +923,7 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 		}
 	}
 	if (!found) {
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		return -EINVAL;
 	}
 	/* force the Attributes/DataSize to 0 to ensure deletion */
@@ -937,12 +939,12 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 	if (status != EFI_SUCCESS) {
 		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
 			status);
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		return -EIO;
 	}
 	list_del(&search_efivar->list);
 	/* We need to release this lock before unregistering. */
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 	efivar_unregister(search_efivar);
 
 	/* It's dead Jim.... */
@@ -1050,9 +1052,9 @@ efivar_create_sysfs_entry(struct efivars *efivars,
 	kfree(short_name);
 	short_name = NULL;
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 	list_add(&new_efivar->list, &efivars->list);
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 
 	return 0;
 }
@@ -1121,9 +1123,9 @@ void unregister_efivars(struct efivars *efivars)
 	struct efivar_entry *entry, *n;
 
 	list_for_each_entry_safe(entry, n, &efivars->list, list) {
-		spin_lock(&efivars->lock);
+		spin_lock_irq(&efivars->lock);
 		list_del(&entry->list);
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		efivar_unregister(entry);
 	}
 	if (efivars->new_var)
-- 
1.8.1.2

