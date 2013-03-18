Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab3CREhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:37:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33651 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752220Ab3CREbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:31:08 -0400
Message-Id: <20130318042148.005388539@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:23 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Josh Boyer <jwboyer@redhat.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>, Mike Waychison <mikew@google.com>,
        Matt Fleming <matt.fleming@intel.com>, Tony Luck <tony.luck@intel.com>
Subject: [ 39/82] efivars: Disable external interrupt while holding  efivars->lock
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Boyer <jwboyer@redhat.com>

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
[bwh: Backported to 3.2:
 - Drop efivarfs changes
 - Adjust context
 - Drop change to efi_pstore_erase(), which is implemented using
   efi_pstore_write() here]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/firmware/efivars.c | 84 ++++++++++++++++++++++++----------------------
 1 file changed, 43 insertions(+), 41 deletions(-)

--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -393,10 +393,11 @@ static efi_status_t
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
@@ -525,14 +526,14 @@ efivar_store_raw(struct efivar_entry *en
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
@@ -643,7 +644,7 @@ static int efi_pstore_open(struct pstore
 {
 	struct efivars *efivars = psi->data;
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 	efivars->walk_entry = list_first_entry(&efivars->list,
 					       struct efivar_entry, list);
 	return 0;
@@ -653,7 +654,7 @@ static int efi_pstore_close(struct pstor
 {
 	struct efivars *efivars = psi->data;
 
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 	return 0;
 }
 
@@ -708,11 +709,12 @@ static int efi_pstore_write(enum pstore_
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
@@ -724,7 +726,7 @@ static int efi_pstore_write(enum pstore_
 						   &remaining_space,
 						   &max_variable_size);
 	if (status || remaining_space < size + DUMP_NAME_LEN * 2) {
-		spin_unlock(&efivars->lock);
+		spin_unlock_irqrestore(&efivars->lock, flags);
 		*id = part;
 		return -ENOSPC;
 	}
@@ -765,7 +767,7 @@ static int efi_pstore_write(enum pstore_
 	efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
 				   size, psi->buf);
 
-	spin_unlock(&efivars->lock);
+	spin_unlock_irqrestore(&efivars->lock, flags);
 
 	if (found)
 		efivar_unregister(found);
@@ -848,7 +850,7 @@ static ssize_t efivar_create(struct file
 		return -EINVAL;
 	}
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 
 	/*
 	 * Does this variable already exist?
@@ -866,7 +868,7 @@ static ssize_t efivar_create(struct file
 		}
 	}
 	if (found) {
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		return -EINVAL;
 	}
 
@@ -880,10 +882,10 @@ static ssize_t efivar_create(struct file
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
@@ -911,7 +913,7 @@ static ssize_t efivar_delete(struct file
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 
 	/*
 	 * Does this variable already exist?
@@ -929,7 +931,7 @@ static ssize_t efivar_delete(struct file
 		}
 	}
 	if (!found) {
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		return -EINVAL;
 	}
 	/* force the Attributes/DataSize to 0 to ensure deletion */
@@ -945,12 +947,12 @@ static ssize_t efivar_delete(struct file
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
@@ -1058,9 +1060,9 @@ efivar_create_sysfs_entry(struct efivars
 	kfree(short_name);
 	short_name = NULL;
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 	list_add(&new_efivar->list, &efivars->list);
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 
 	return 0;
 }
@@ -1129,9 +1131,9 @@ void unregister_efivars(struct efivars *
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


