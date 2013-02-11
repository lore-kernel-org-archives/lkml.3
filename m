Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668Ab3BKR7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:59:52 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:57644 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758504Ab3BKR7v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:59:51 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
CC: "Matt Fleming (matt@console-pimps.org)" <matt@console-pimps.org>,
        "mikew@google.com" <mikew@google.com>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: [PATCH v6 -next 1/2] efivars: Disable external interrupt while
 holding efivars->lock
Thread-Topic: [PATCH v6 -next 1/2] efivars: Disable external interrupt while
 holding efivars->lock
Thread-Index: Ac4IgX7td8cz78hTSiiyUhfN3mqmtQ==
Date: Mon, 11 Feb 2013 17:59:34 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A922A6@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-02-11_03:2013-02-11,2013-02-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1302110163
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/firmware/efivars.c |   86 ++++++++++++++++++++++---------------------
 1 files changed, 44 insertions(+), 42 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 2452311..b962553 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -405,10 +405,11 @@ static efi_status_t
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
@@ -537,14 +538,14 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
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
@@ -713,7 +714,7 @@ static ssize_t efivarfs_file_write(struct file *file,
 	 * amounts of memory. Pick a default size of 64K if
 	 * QueryVariableInfo() isn't supported by the firmware.
 	 */
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 
 	if (!efivars->ops->query_variable_info)
 		status = EFI_UNSUPPORTED;
@@ -723,7 +724,7 @@ static ssize_t efivarfs_file_write(struct file *file,
 						   &remaining_size, &max_size);
 	}
 
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 
 	if (status != EFI_SUCCESS) {
 		if (status != EFI_UNSUPPORTED)
@@ -754,7 +755,7 @@ static ssize_t efivarfs_file_write(struct file *file,
 	 * set_variable call, and removal of the variable from the efivars
 	 * list (in the case of an authenticated delete).
 	 */
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 
 	status = efivars->ops->set_variable(var->var.VariableName,
 					    &var->var.VendorGuid,
@@ -762,7 +763,7 @@ static ssize_t efivarfs_file_write(struct file *file,
 					    data);
 
 	if (status != EFI_SUCCESS) {
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		kfree(data);
 
 		return efi_status_to_err(status);
@@ -783,21 +784,21 @@ static ssize_t efivarfs_file_write(struct file *file,
 					    NULL);
 
 	if (status == EFI_BUFFER_TOO_SMALL) {
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		mutex_lock(&inode->i_mutex);
 		i_size_write(inode, newdatasize + sizeof(attributes));
 		mutex_unlock(&inode->i_mutex);
 
 	} else if (status == EFI_NOT_FOUND) {
 		list_del(&var->list);
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		efivar_unregister(var);
 		drop_nlink(inode);
 		d_delete(file->f_dentry);
 		dput(file->f_dentry);
 
 	} else {
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		pr_warn("efivarfs: inconsistent EFI variable implementation? "
 				"status = %lx\n", status);
 	}
@@ -819,11 +820,11 @@ static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
 	void *data;
 	ssize_t size = 0;
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 	status = efivars->ops->get_variable(var->var.VariableName,
 					    &var->var.VendorGuid,
 					    &attributes, &datasize, NULL);
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 
 	if (status != EFI_BUFFER_TOO_SMALL)
 		return efi_status_to_err(status);
@@ -833,12 +834,12 @@ static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
 	if (!data)
 		return -ENOMEM;
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 	status = efivars->ops->get_variable(var->var.VariableName,
 					    &var->var.VendorGuid,
 					    &attributes, &datasize,
 					    (data + sizeof(attributes)));
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 
 	if (status != EFI_SUCCESS) {
 		size = efi_status_to_err(status);
@@ -966,9 +967,9 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 		goto out;
 
 	kobject_uevent(&var->kobj, KOBJ_ADD);
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 	list_add(&var->list, &efivars->list);
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 	d_instantiate(dentry, inode);
 	dget(dentry);
 out:
@@ -985,7 +986,7 @@ static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
 	struct efivars *efivars = var->efivars;
 	efi_status_t status;
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 
 	status = efivars->ops->set_variable(var->var.VariableName,
 					    &var->var.VendorGuid,
@@ -993,14 +994,14 @@ static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
 
 	if (status == EFI_SUCCESS || status == EFI_NOT_FOUND) {
 		list_del(&var->list);
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		efivar_unregister(var);
 		drop_nlink(dentry->d_inode);
 		dput(dentry);
 		return 0;
 	}
 
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 	return -EINVAL;
 };
 
@@ -1066,13 +1067,13 @@ static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 		/* copied by the above to local storage in the dentry. */
 		kfree(name);
 
-		spin_lock(&efivars->lock);
+		spin_lock_irq(&efivars->lock);
 		efivars->ops->get_variable(entry->var.VariableName,
 					   &entry->var.VendorGuid,
 					   &entry->var.Attributes,
 					   &size,
 					   NULL);
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 
 		mutex_lock(&inode->i_mutex);
 		inode->i_private = entry;
@@ -1123,7 +1124,7 @@ static int efi_pstore_open(struct pstore_info *psi)
 {
 	struct efivars *efivars = psi->data;
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 	efivars->walk_entry = list_first_entry(&efivars->list,
 					       struct efivar_entry, list);
 	return 0;
@@ -1133,7 +1134,7 @@ static int efi_pstore_close(struct pstore_info *psi)
 {
 	struct efivars *efivars = psi->data;
 
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 	return 0;
 }
 
@@ -1209,6 +1210,7 @@ static int efi_pstore_write(enum pstore_type_id type,
 	int i, ret = 0;
 	u64 storage_space, remaining_space, max_variable_size;
 	efi_status_t status = EFI_NOT_FOUND;
+	unsigned long flags;
 
 	if (pstore_cannot_block_path(reason)) {
 		/*
@@ -1216,10 +1218,10 @@ static int efi_pstore_write(enum pstore_type_id type,
 		 * this driver returns without entering firmware to avoid
 		 * hanging up.
 		 */
-		if (!spin_trylock(&efivars->lock))
+		if (!spin_trylock_irqsave(&efivars->lock, flags))
 			return -EBUSY;
 	} else
-		spin_lock(&efivars->lock);
+		spin_lock_irqsave(&efivars->lock, flags);
 
 	/*
 	 * Check if there is a space enough to log.
@@ -1231,7 +1233,7 @@ static int efi_pstore_write(enum pstore_type_id type,
 						   &remaining_space,
 						   &max_variable_size);
 	if (status || remaining_space < size + DUMP_NAME_LEN * 2) {
-		spin_unlock(&efivars->lock);
+		spin_unlock_irqrestore(&efivars->lock, flags);
 		*id = part;
 		return -ENOSPC;
 	}
@@ -1245,7 +1247,7 @@ static int efi_pstore_write(enum pstore_type_id type,
 	efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
 				   size, psi->buf);
 
-	spin_unlock(&efivars->lock);
+	spin_unlock_irqrestore(&efivars->lock, flags);
 
 	if (size)
 		ret = efivar_create_sysfs_entry(efivars,
@@ -1272,7 +1274,7 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 	sprintf(name, "dump-type%u-%u-%d-%lu", type, (unsigned int)id, count,
 		time.tv_sec);
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = name[i];
@@ -1316,7 +1318,7 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 	if (found)
 		list_del(&found->list);
 
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 
 	if (found)
 		efivar_unregister(found);
@@ -1386,7 +1388,7 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 		return -EINVAL;
 	}
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 
 	/*
 	 * Does this variable already exist?
@@ -1404,7 +1406,7 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 		}
 	}
 	if (found) {
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		return -EINVAL;
 	}
 
@@ -1418,10 +1420,10 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
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
@@ -1449,7 +1451,7 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 
 	/*
 	 * Does this variable already exist?
@@ -1467,7 +1469,7 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 		}
 	}
 	if (!found) {
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		return -EINVAL;
 	}
 	/* force the Attributes/DataSize to 0 to ensure deletion */
@@ -1483,12 +1485,12 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
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
@@ -1603,9 +1605,9 @@ efivar_create_sysfs_entry(struct efivars *efivars,
 	kfree(short_name);
 	short_name = NULL;
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 	list_add(&new_efivar->list, &efivars->list);
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 
 	return 0;
 }
@@ -1674,9 +1676,9 @@ void unregister_efivars(struct efivars *efivars)
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
-- 1.7.1


