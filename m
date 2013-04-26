Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab3DZPnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:43:52 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:51340 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402Ab3DZPns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:43:48 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "Seiji Aguchi" <seiji.aguchi@hds.com>,
        "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "jk@ozlabs.org" <jk@ozlabs.org>, "teg@jklm.no" <teg@jklm.no>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mikew@google.com" <mikew@google.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: RE: [tip:x86/efi2] efivars: efivar_entry API
Thread-Topic: [tip:x86/efi2] efivars: efivar_entry API
Thread-Index: AQHOPHFEzrlus8pItEq77hQ4E6Icb5jorw2Q
Date: Fri, 26 Apr 2013 15:43:07 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41AFD20E4@USINDEM103.corp.hds.com>
References: <tip-e14ab23dde12b80db4c94b684a2e485b72b16af3@git.kernel.org>
In-Reply-To: <tip-e14ab23dde12b80db4c94b684a2e485b72b16af3@git.kernel.org>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-04-26_05:2013-04-26,2013-04-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=7 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1304260125
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3QFi4Pd004499

> +static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
>  {
>  	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
> -	struct efivars *efivars = __efivars;
> +	struct pstore_read_data *cb_data = data;
>  	char name[DUMP_NAME_LEN];
>  	int i;
>  	int cnt;
> -	unsigned int part, size;
> -	unsigned long time;
> -
> -	while (&efivars->walk_entry->list != &efivars->list) {
> -		if (!efi_guidcmp(efivars->walk_entry->var.VendorGuid,
> -				 vendor)) {
> -			for (i = 0; i < DUMP_NAME_LEN; i++) {
> -				name[i] = efivars->walk_entry->var.VariableName[i];
> -			}
> -			if (sscanf(name, "dump-type%u-%u-%d-%lu",
> -				   type, &part, &cnt, &time) == 4) {
> -				*id = part;
> -				*count = cnt;
> -				timespec->tv_sec = time;
> -				timespec->tv_nsec = 0;
> -			} else if (sscanf(name, "dump-type%u-%u-%lu",
> -				   type, &part, &time) == 3) {
> -				/*
> -				 * Check if an old format,
> -				 * which doesn't support holding
> -				 * multiple logs, remains.
> -				 */
> -				*id = part;
> -				*count = 0;
> -				timespec->tv_sec = time;
> -				timespec->tv_nsec = 0;
> -			} else {
> -				efivars->walk_entry = list_entry(
> -						efivars->walk_entry->list.next,
> -						struct efivar_entry, list);
> -				continue;
> -			}
> +	unsigned int part;
> +	unsigned long time, size;
> 
> -			get_var_data_locked(efivars, &efivars->walk_entry->var);
> -			size = efivars->walk_entry->var.DataSize;
> -			*buf = kmalloc(size, GFP_KERNEL);
> -			if (*buf == NULL)
> -				return -ENOMEM;
> -			memcpy(*buf, efivars->walk_entry->var.Data,
> -			       size);
> -			efivars->walk_entry = list_entry(
> -					efivars->walk_entry->list.next,
> -					struct efivar_entry, list);
> -			return size;
> -		}
> -		efivars->walk_entry = list_entry(efivars->walk_entry->list.next,
> -						 struct efivar_entry, list);
> -	}
> -	return 0;
> +	if (efi_guidcmp(entry->var.VendorGuid, vendor))
> +		return 0;
> +
> +	for (i = 0; i < DUMP_NAME_LEN; i++)
> +		name[i] = entry->var.VariableName[i];
> +
> +	if (sscanf(name, "dump-type%u-%u-%d-%lu",
> +		   cb_data->type, &part, &cnt, &time) == 4) {
> +		*cb_data->id = part;
> +		*cb_data->count = cnt;
> +		cb_data->timespec->tv_sec = time;
> +		cb_data->timespec->tv_nsec = 0;
> +	} else if (sscanf(name, "dump-type%u-%u-%lu",
> +			  cb_data->type, &part, &time) == 3) {
> +		/*
> +		 * Check if an old format,
> +		 * which doesn't support holding
> +		 * multiple logs, remains.
> +		 */
> +		*cb_data->id = part;
> +		*cb_data->count = 0;
> +		cb_data->timespec->tv_sec = time;
> +		cb_data->timespec->tv_nsec = 0;
> +	} else
> +		return 0;
> +
> +	__efivar_entry_size(entry, &size);

I tested pstore_read() as well.
And /dev/pstore/dmesg-efi-X was empty....

This must be __efivar_entry_get() instead of __efivar_entry_size().
(We may have to introduce _efivar_entry_get_locked() to avoid deadlock.)

I think it is a final bug report related to this new API patch.

Seiji

> +	*cb_data->buf = kmalloc(size, GFP_KERNEL);
> +	if (*cb_data->buf == NULL)
> +		return -ENOMEM;
> +	memcpy(*cb_data->buf, entry->var.Data, size);
> +	return size;
> +}
> +
> +static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
> +			       int *count, struct timespec *timespec,
> +			       char **buf, struct pstore_info *psi)
> +{
> +	struct pstore_read_data data;
> +
> +	data.id = id;
> +	data.type = type;
> +	data.count = count;
> +	data.timespec = timespec;
> +	data.buf = buf;
> +
> +	return __efivar_entry_iter(efi_pstore_read_func, &efivar_sysfs_list, &data,
> +				   (struct efivar_entry **)&psi->data);
>  }
> 
>  static int efi_pstore_write(enum pstore_type_id type,
> @@ -1382,36 +1222,7 @@ static int efi_pstore_write(enum pstore_type_id type,
>  	char name[DUMP_NAME_LEN];
>  	efi_char16_t efi_name[DUMP_NAME_LEN];
>  	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
> -	struct efivars *efivars = __efivars;
>  	int i, ret = 0;
> -	efi_status_t status = EFI_NOT_FOUND;
> -	unsigned long flags;
> -
> -	if (pstore_cannot_block_path(reason)) {
> -		/*
> -		 * If the lock is taken by another cpu in non-blocking path,
> -		 * this driver returns without entering firmware to avoid
> -		 * hanging up.
> -		 */
> -		if (!spin_trylock_irqsave(&efivars->lock, flags))
> -			return -EBUSY;
> -	} else
> -		spin_lock_irqsave(&efivars->lock, flags);
> -
> -	/*
> -	 * Check if there is a space enough to log.
> -	 * size: a size of logging data
> -	 * DUMP_NAME_LEN * 2: a maximum size of variable name
> -	 */
> -
> -	status = check_var_size_locked(efivars, PSTORE_EFI_ATTRIBUTES,
> -					 size + DUMP_NAME_LEN * 2);
> -
> -	if (status) {
> -		spin_unlock_irqrestore(&efivars->lock, flags);
> -		*id = part;
> -		return -ENOSPC;
> -	}
> 
>  	sprintf(name, "dump-type%u-%u-%d-%lu", type, part, count,
>  		get_seconds());
> @@ -1419,10 +1230,9 @@ static int efi_pstore_write(enum pstore_type_id type,
>  	for (i = 0; i < DUMP_NAME_LEN; i++)
>  		efi_name[i] = name[i];
> 
> -	efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
> -				   size, psi->buf);
> -
> -	spin_unlock_irqrestore(&efivars->lock, flags);
> +	ret = efivar_entry_set_safe(efi_name, vendor, PSTORE_EFI_ATTRIBUTES,
> +				    !pstore_cannot_block_path(reason),
> +				    size, psi->buf);
> 
>  	if (reason == KMSG_DUMP_OOPS && efivar_wq_enabled)
>  		schedule_work(&efivar_work);
> @@ -1431,69 +1241,79 @@ static int efi_pstore_write(enum pstore_type_id type,
>  	return ret;
>  };
> 
> -static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
> -			    struct timespec time, struct pstore_info *psi)
> +struct pstore_erase_data {
> +	u64 id;
> +	enum pstore_type_id type;
> +	int count;
> +	struct timespec time;
> +	efi_char16_t *name;
> +};
> +
> +/*
> + * Clean up an entry with the same name
> + */
> +static int efi_pstore_erase_func(struct efivar_entry *entry, void *data)
>  {
> -	char name[DUMP_NAME_LEN];
> -	efi_char16_t efi_name[DUMP_NAME_LEN];
> -	char name_old[DUMP_NAME_LEN];
> -	efi_char16_t efi_name_old[DUMP_NAME_LEN];
> +	struct pstore_erase_data *ed = data;
>  	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
> -	struct efivars *efivars = __efivars;
> -	struct efivar_entry *entry, *found = NULL;
> +	efi_char16_t efi_name_old[DUMP_NAME_LEN];
> +	efi_char16_t *efi_name = ed->name;
> +	unsigned long utf16_len = utf16_strlen(ed->name);
> +	char name_old[DUMP_NAME_LEN];
>  	int i;
> 
> -	sprintf(name, "dump-type%u-%u-%d-%lu", type, (unsigned int)id, count,
> -		time.tv_sec);
> +	if (efi_guidcmp(entry->var.VendorGuid, vendor))
> +		return 0;
> 
> -	spin_lock_irq(&efivars->lock);
> +	if (utf16_strncmp(entry->var.VariableName,
> +			  efi_name, (size_t)utf16_len)) {
> +		/*
> +		 * Check if an old format, which doesn't support
> +		 * holding multiple logs, remains.
> +		 */
> +		sprintf(name_old, "dump-type%u-%u-%lu", ed->type,
> +			(unsigned int)ed->id, ed->time.tv_sec);
> 
> -	for (i = 0; i < DUMP_NAME_LEN; i++)
> -		efi_name[i] = name[i];
> +		for (i = 0; i < DUMP_NAME_LEN; i++)
> +			efi_name_old[i] = name_old[i];
> 
> -	/*
> -	 * Clean up an entry with the same name
> -	 */
> +		if (utf16_strncmp(entry->var.VariableName, efi_name_old,
> +				  utf16_strlen(efi_name_old)))
> +			return 0;
> +	}
> 
> -	list_for_each_entry(entry, &efivars->list, list) {
> -		get_var_data_locked(efivars, &entry->var);
> -
> -		if (efi_guidcmp(entry->var.VendorGuid, vendor))
> -			continue;
> -		if (utf16_strncmp(entry->var.VariableName, efi_name,
> -				  utf16_strlen(efi_name))) {
> -			/*
> -			 * Check if an old format,
> -			 * which doesn't support holding
> -			 * multiple logs, remains.
> -			 */
> -			sprintf(name_old, "dump-type%u-%u-%lu", type,
> -				(unsigned int)id, time.tv_sec);
> +	/* found */
> +	__efivar_entry_delete(entry);
> +	return 1;
> +}
> 
> -			for (i = 0; i < DUMP_NAME_LEN; i++)
> -				efi_name_old[i] = name_old[i];
> +static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
> +			    struct timespec time, struct pstore_info *psi)
> +{
> +	struct pstore_erase_data edata;
> +	struct efivar_entry *entry;
> +	char name[DUMP_NAME_LEN];
> +	efi_char16_t efi_name[DUMP_NAME_LEN];
> +	int found, i;
> 
> -			if (utf16_strncmp(entry->var.VariableName, efi_name_old,
> -					  utf16_strlen(efi_name_old)))
> -				continue;
> -		}
> +	sprintf(name, "dump-type%u-%u-%d-%lu", type, (unsigned int)id, count,
> +		time.tv_sec);
> 
> -		/* found */
> -		found = entry;
> -		efivars->ops->set_variable(entry->var.VariableName,
> -					   &entry->var.VendorGuid,
> -					   PSTORE_EFI_ATTRIBUTES,
> -					   0, NULL);
> -		break;
> -	}
> +	for (i = 0; i < DUMP_NAME_LEN; i++)
> +		efi_name[i] = name[i];
> 
> -	if (found)
> -		list_del(&found->list);
> +	edata.id = id;
> +	edata.type = type;
> +	edata.count = count;
> +	edata.time = time;
> +	edata.name = efi_name;
> 
> -	spin_unlock_irq(&efivars->lock);
> +	efivar_entry_iter_begin();
> +	found = __efivar_entry_iter(efi_pstore_erase_func, &efivar_sysfs_list, &edata, &entry);
> +	efivar_entry_iter_end();
> 
>  	if (found)
> -		efivar_unregister(found);
> +		efivar_unregister(entry);
> 
>  	return 0;
>  }
> @@ -1508,19 +1328,17 @@ static struct pstore_info efi_pstore_info = {
>  	.erase		= efi_pstore_erase,
>  };
> 
> -static void efivar_pstore_register(struct efivars *efivars)
> +static void efivar_pstore_register(void)
>  {
> -	efivars->efi_pstore_info = efi_pstore_info;
> -	efivars->efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
> -	if (efivars->efi_pstore_info.buf) {
> -		efivars->efi_pstore_info.bufsize = 1024;
> -		efivars->efi_pstore_info.data = efivars;
> -		spin_lock_init(&efivars->efi_pstore_info.buf_lock);
> -		pstore_register(&efivars->efi_pstore_info);
> +	efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
> +	if (efi_pstore_info.buf) {
> +		efi_pstore_info.bufsize = 1024;
> +		spin_lock_init(&efi_pstore_info.buf_lock);
> +		pstore_register(&efi_pstore_info);
>  	}
>  }
>  #else
> -static void efivar_pstore_register(struct efivars *efivars)
> +static void efivar_pstore_register(void)
>  {
>  	return;
>  }
> @@ -1531,76 +1349,41 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
>  			     char *buf, loff_t pos, size_t count)
>  {
>  	struct efi_variable *new_var = (struct efi_variable *)buf;
> -	struct efivars *efivars = __efivars;
> -	struct efivar_entry *search_efivar, *n;
> -	unsigned long strsize1, strsize2;
> -	efi_status_t status = EFI_NOT_FOUND;
> -	int found = 0;
> +	struct efivar_entry *new_entry;
> +	int err;
> 
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EACCES;
> 
>  	if ((new_var->Attributes & ~EFI_VARIABLE_MASK) != 0 ||
> -	    validate_var(new_var, new_var->Data, new_var->DataSize) == false) {
> +	    efivar_validate(new_var, new_var->Data, new_var->DataSize) == false) {
>  		printk(KERN_ERR "efivars: Malformed variable content\n");
>  		return -EINVAL;
>  	}
> 
> -	spin_lock_irq(&efivars->lock);
> -
> -	/*
> -	 * Does this variable already exist?
> -	 */
> -	list_for_each_entry_safe(search_efivar, n, &efivars->list, list) {
> -		strsize1 = utf16_strsize(search_efivar->var.VariableName, 1024);
> -		strsize2 = utf16_strsize(new_var->VariableName, 1024);
> -		if (strsize1 == strsize2 &&
> -			!memcmp(&(search_efivar->var.VariableName),
> -				new_var->VariableName, strsize1) &&
> -			!efi_guidcmp(search_efivar->var.VendorGuid,
> -				new_var->VendorGuid)) {
> -			found = 1;
> -			break;
> -		}
> -	}
> -	if (found) {
> -		spin_unlock_irq(&efivars->lock);
> -		return -EINVAL;
> -	}
> +	new_entry = kzalloc(sizeof(*new_entry), GFP_KERNEL);
> +	if (!new_entry)
> +		return -ENOMEM;
> 
> -	status = check_var_size_locked(efivars, new_var->Attributes,
> -	       new_var->DataSize + utf16_strsize(new_var->VariableName, 1024));
> +	memcpy(&new_entry->var, new_var, sizeof(*new_var));
> 
> -	if (status && status != EFI_UNSUPPORTED) {
> -		spin_unlock_irq(&efivars->lock);
> -		return efi_status_to_err(status);
> +	err = efivar_entry_set(new_entry, new_var->Attributes, new_var->DataSize,
> +			       new_var->Data, &efivar_sysfs_list);
> +	if (err) {
> +		if (err == -EEXIST)
> +			err = -EINVAL;
> +		goto out;
>  	}
> 
> -	/* now *really* create the variable via EFI */
> -	status = efivars->ops->set_variable(new_var->VariableName,
> -					    &new_var->VendorGuid,
> -					    new_var->Attributes,
> -					    new_var->DataSize,
> -					    new_var->Data);
> -
> -	if (status != EFI_SUCCESS) {
> -		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
> -			status);
> -		spin_unlock_irq(&efivars->lock);
> -		return -EIO;
> -	}
> -	spin_unlock_irq(&efivars->lock);
> -
> -	/* Create the entry in sysfs.  Locking is not required here */
> -	status = efivar_create_sysfs_entry(efivars,
> -					   utf16_strsize(new_var->VariableName,
> -							 1024),
> -					   new_var->VariableName,
> -					   &new_var->VendorGuid);
> -	if (status) {
> -		printk(KERN_WARNING "efivars: variable created, but sysfs entry wasn't.\n");
> +	if (efivar_create_sysfs_entry(new_entry)) {
> +		printk(KERN_WARNING "efivars: failed to create sysfs entry.\n");
> +		kfree(new_entry);
>  	}
>  	return count;
> +
> +out:
> +	kfree(new_entry);
> +	return err;
>  }
> 
>  static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
> @@ -1608,70 +1391,40 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
>  			     char *buf, loff_t pos, size_t count)
>  {
>  	struct efi_variable *del_var = (struct efi_variable *)buf;
> -	struct efivars *efivars = __efivars;
> -	struct efivar_entry *search_efivar, *n;
> -	unsigned long strsize1, strsize2;
> -	efi_status_t status = EFI_NOT_FOUND;
> -	int found = 0;
> +	struct efivar_entry *entry;
> +	int err = 0;
> 
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EACCES;
> 
> -	spin_lock_irq(&efivars->lock);
> +	efivar_entry_iter_begin();
> +	entry = efivar_entry_find(del_var->VariableName, del_var->VendorGuid,
> +				  &efivar_sysfs_list, true);
> +	if (!entry)
> +		err = -EINVAL;
> +	else if (__efivar_entry_delete(entry))
> +		err = -EIO;
> 
> -	/*
> -	 * Does this variable already exist?
> -	 */
> -	list_for_each_entry_safe(search_efivar, n, &efivars->list, list) {
> -		strsize1 = utf16_strsize(search_efivar->var.VariableName, 1024);
> -		strsize2 = utf16_strsize(del_var->VariableName, 1024);
> -		if (strsize1 == strsize2 &&
> -			!memcmp(&(search_efivar->var.VariableName),
> -				del_var->VariableName, strsize1) &&
> -			!efi_guidcmp(search_efivar->var.VendorGuid,
> -				del_var->VendorGuid)) {
> -			found = 1;
> -			break;
> -		}
> -	}
> -	if (!found) {
> -		spin_unlock_irq(&efivars->lock);
> -		return -EINVAL;
> -	}
> -	/* force the Attributes/DataSize to 0 to ensure deletion */
> -	del_var->Attributes = 0;
> -	del_var->DataSize = 0;
> +	efivar_entry_iter_end();
> 
> -	status = efivars->ops->set_variable(del_var->VariableName,
> -					    &del_var->VendorGuid,
> -					    del_var->Attributes,
> -					    del_var->DataSize,
> -					    del_var->Data);
> +	if (err)
> +		return err;
> 
> -	if (status != EFI_SUCCESS) {
> -		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
> -			status);
> -		spin_unlock_irq(&efivars->lock);
> -		return -EIO;
> -	}
> -	list_del(&search_efivar->list);
> -	/* We need to release this lock before unregistering. */
> -	spin_unlock_irq(&efivars->lock);
> -	efivar_unregister(search_efivar);
> +	efivar_unregister(entry);
> 
>  	/* It's dead Jim.... */
>  	return count;
>  }
> 
> -static bool variable_is_present(efi_char16_t *variable_name, efi_guid_t *vendor)
> +static bool variable_is_present(efi_char16_t *variable_name, efi_guid_t *vendor,
> +				struct list_head *head)
>  {
>  	struct efivar_entry *entry, *n;
> -	struct efivars *efivars = __efivars;
>  	unsigned long strsize1, strsize2;
>  	bool found = false;
> 
>  	strsize1 = utf16_strsize(variable_name, 1024);
> -	list_for_each_entry_safe(entry, n, &efivars->list, list) {
> +	list_for_each_entry_safe(entry, n, head, list) {
>  		strsize2 = utf16_strsize(entry->var.VariableName, 1024);
>  		if (strsize1 == strsize2 &&
>  			!memcmp(variable_name, &(entry->var.VariableName),
> @@ -1685,6 +1438,20 @@ static bool variable_is_present(efi_char16_t *variable_name, efi_guid_t *vendor)
>  	return found;
>  }
> 
> +static int efivar_update_sysfs_entry(efi_char16_t *name, efi_guid_t vendor,
> +				     unsigned long name_size, void *data)
> +{
> +	struct efivar_entry *entry = data;
> +
> +	if (efivar_entry_find(name, vendor, &efivar_sysfs_list, false))
> +		return 0;
> +
> +	memcpy(entry->var.VariableName, name, name_size);
> +	memcpy(&(entry->var.VendorGuid), &vendor, sizeof(efi_guid_t));
> +
> +	return 1;
> +}
> +
>  /*
>   * Returns the size of variable_name, in bytes, including the
>   * terminating NULL character, or variable_name_size if no NULL
> @@ -1712,52 +1479,26 @@ static unsigned long var_name_strnsize(efi_char16_t *variable_name,
> 
>  static void efivar_update_sysfs_entries(struct work_struct *work)
>  {
> -	struct efivars *efivars = __efivars;
> -	efi_guid_t vendor;
> -	efi_char16_t *variable_name;
> -	unsigned long variable_name_size = 1024;
> -	efi_status_t status = EFI_NOT_FOUND;
> -	bool found;
> +	struct efivar_entry *entry;
> +	int err;
> +
> +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> +	if (!entry)
> +		return;
> 
>  	/* Add new sysfs entries */
>  	while (1) {
> -		variable_name = kzalloc(variable_name_size, GFP_KERNEL);
> -		if (!variable_name) {
> -			pr_err("efivars: Memory allocation failed.\n");
> -			return;
> -		}
> +		memset(entry, 0, sizeof(*entry));
> 
> -		spin_lock_irq(&efivars->lock);
> -		found = false;
> -		while (1) {
> -			variable_name_size = 1024;
> -			status = efivars->ops->get_next_variable(
> -							&variable_name_size,
> -							variable_name,
> -							&vendor);
> -			if (status != EFI_SUCCESS) {
> -				break;
> -			} else {
> -				if (!variable_is_present(variable_name,
> -				    &vendor)) {
> -					found = true;
> -					break;
> -				}
> -			}
> -		}
> -		spin_unlock_irq(&efivars->lock);
> -
> -		if (!found) {
> -			kfree(variable_name);
> +		err = efivar_init(efivar_update_sysfs_entry, entry,
> +				  true, false, &efivar_sysfs_list);
> +		if (!err)
>  			break;
> -		} else {
> -			variable_name_size = var_name_strnsize(variable_name,
> -							       variable_name_size);
> -			efivar_create_sysfs_entry(efivars,
> -						  variable_name_size,
> -						  variable_name, &vendor);
> -		}
> +
> +		efivar_create_sysfs_entry(entry);
>  	}
> +
> +	kfree(entry);
>  }
> 
>  /*
> @@ -1804,45 +1545,37 @@ static struct attribute_group efi_subsys_attr_group = {
> 
>  static struct kobject *efi_kobj;
> 
> -/*
> - * efivar_create_sysfs_entry()
> - * Requires:
> - *    variable_name_size = number of bytes required to hold
> - *                         variable_name (not counting the NULL
> - *                         character at the end.
> - *    efivars->lock is not held on entry or exit.
> +/**
> + * efivar_create_sysfs_entry - create a new entry in sysfs
> + * @new_var: efivar entry to create
> + *
>   * Returns 1 on failure, 0 on success
>   */
>  static int
> -efivar_create_sysfs_entry(struct efivars *efivars,
> -			  unsigned long variable_name_size,
> -			  efi_char16_t *variable_name,
> -			  efi_guid_t *vendor_guid)
> +efivar_create_sysfs_entry(struct efivar_entry *new_var)
>  {
>  	int i, short_name_size;
>  	char *short_name;
> -	struct efivar_entry *new_efivar;
> +	unsigned long variable_name_size;
> +	efi_char16_t *variable_name;
> +
> +	variable_name = new_var->var.VariableName;
> +	variable_name_size = utf16_strlen(variable_name) * sizeof(efi_char16_t);
> 
>  	/*
>  	 * Length of the variable bytes in ASCII, plus the '-' separator,
>  	 * plus the GUID, plus trailing NUL
>  	 */
>  	short_name_size = variable_name_size / sizeof(efi_char16_t)
> -				+ 1 + GUID_LEN + 1;
> +				+ 1 + EFI_VARIABLE_GUID_LEN + 1;
> 
>  	short_name = kzalloc(short_name_size, GFP_KERNEL);
> -	new_efivar = kzalloc(sizeof(struct efivar_entry), GFP_KERNEL);
> 
> -	if (!short_name || !new_efivar)  {
> +	if (!short_name) {
>  		kfree(short_name);
> -		kfree(new_efivar);
>  		return 1;
>  	}
> 
> -	memcpy(new_efivar->var.VariableName, variable_name,
> -		variable_name_size);
> -	memcpy(&(new_efivar->var.VendorGuid), vendor_guid, sizeof(efi_guid_t));
> -
>  	/* Convert Unicode to normal chars (assume top bits are 0),
>  	   ala UTF-8 */
>  	for (i=0; i < (int)(variable_name_size / sizeof(efi_char16_t)); i++) {
> @@ -1852,30 +1585,25 @@ efivar_create_sysfs_entry(struct efivars *efivars,
>  	   private variables from another's.         */
> 
>  	*(short_name + strlen(short_name)) = '-';
> -	efi_guid_unparse(vendor_guid, short_name + strlen(short_name));
> +	efi_guid_unparse(&new_var->var.VendorGuid,
> +			 short_name + strlen(short_name));
> 
> -	new_efivar->kobj.kset = efivars->kset;
> -	i = kobject_init_and_add(&new_efivar->kobj, &efivar_ktype, NULL,
> -				 "%s", short_name);
> -	if (i) {
> -		kfree(short_name);
> -		kfree(new_efivar);
> -		return 1;
> -	}
> +	new_var->kobj.kset = efivars_kset;
> 
> -	kobject_uevent(&new_efivar->kobj, KOBJ_ADD);
> +	i = kobject_init_and_add(&new_var->kobj, &efivar_ktype,
> +				   NULL, "%s", short_name);
>  	kfree(short_name);
> -	short_name = NULL;
> +	if (i)
> +		return 1;
> 
> -	spin_lock_irq(&efivars->lock);
> -	list_add(&new_efivar->list, &efivars->list);
> -	spin_unlock_irq(&efivars->lock);
> +	kobject_uevent(&new_var->kobj, KOBJ_ADD);
> +	efivar_entry_add(new_var, &efivar_sysfs_list);
> 
>  	return 0;
>  }
> 
>  static int
> -create_efivars_bin_attributes(struct efivars *efivars)
> +create_efivars_bin_attributes(void)
>  {
>  	struct bin_attribute *attr;
>  	int error;
> @@ -1888,8 +1616,7 @@ create_efivars_bin_attributes(struct efivars *efivars)
>  	attr->attr.name = "new_var";
>  	attr->attr.mode = 0200;
>  	attr->write = efivar_create;
> -	attr->private = efivars;
> -	efivars->new_var = attr;
> +	efivars_new_var = attr;
> 
>  	/* del_var */
>  	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
> @@ -1900,61 +1627,59 @@ create_efivars_bin_attributes(struct efivars *efivars)
>  	attr->attr.name = "del_var";
>  	attr->attr.mode = 0200;
>  	attr->write = efivar_delete;
> -	attr->private = efivars;
> -	efivars->del_var = attr;
> +	efivars_del_var = attr;
> 
> -	sysfs_bin_attr_init(efivars->new_var);
> -	sysfs_bin_attr_init(efivars->del_var);
> +	sysfs_bin_attr_init(efivars_new_var);
> +	sysfs_bin_attr_init(efivars_del_var);
> 
>  	/* Register */
> -	error = sysfs_create_bin_file(&efivars->kset->kobj,
> -				      efivars->new_var);
> +	error = sysfs_create_bin_file(&efivars_kset->kobj, efivars_new_var);
>  	if (error) {
>  		printk(KERN_ERR "efivars: unable to create new_var sysfs file"
>  			" due to error %d\n", error);
>  		goto out_free;
>  	}
> -	error = sysfs_create_bin_file(&efivars->kset->kobj,
> -				      efivars->del_var);
> +
> +	error = sysfs_create_bin_file(&efivars_kset->kobj, efivars_del_var);
>  	if (error) {
>  		printk(KERN_ERR "efivars: unable to create del_var sysfs file"
>  			" due to error %d\n", error);
> -		sysfs_remove_bin_file(&efivars->kset->kobj,
> -				      efivars->new_var);
> +		sysfs_remove_bin_file(&efivars_kset->kobj, efivars_new_var);
>  		goto out_free;
>  	}
> 
>  	return 0;
>  out_free:
> -	kfree(efivars->del_var);
> -	efivars->del_var = NULL;
> -	kfree(efivars->new_var);
> -	efivars->new_var = NULL;
> +	kfree(efivars_del_var);
> +	efivars_del_var = NULL;
> +	kfree(efivars_new_var);
> +	efivars_new_var = NULL;
>  	return error;
>  }
> 
> -void unregister_efivars(struct efivars *efivars)
> +static int efivars_sysfs_callback(efi_char16_t *name, efi_guid_t vendor,
> +				  unsigned long name_size, void *data)
>  {
> -	struct efivar_entry *entry, *n;
> +	struct efivar_entry *entry;
> 
> -	__efivars = NULL;
> +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> +	if (!entry)
> +		return -ENOMEM;
> 
> -	list_for_each_entry_safe(entry, n, &efivars->list, list) {
> -		spin_lock_irq(&efivars->lock);
> -		list_del(&entry->list);
> -		spin_unlock_irq(&efivars->lock);
> -		efivar_unregister(entry);
> -	}
> -	if (efivars->new_var)
> -		sysfs_remove_bin_file(&efivars->kset->kobj, efivars->new_var);
> -	if (efivars->del_var)
> -		sysfs_remove_bin_file(&efivars->kset->kobj, efivars->del_var);
> -	kfree(efivars->new_var);
> -	kfree(efivars->del_var);
> -	kobject_put(efivars->kobject);
> -	kset_unregister(efivars->kset);
> +	memcpy(entry->var.VariableName, name, name_size);
> +	memcpy(&(entry->var.VendorGuid), &vendor, sizeof(efi_guid_t));
> +
> +	efivar_create_sysfs_entry(entry);
> +
> +	return 0;
> +}
> +
> +static int efivar_sysfs_destroy(struct efivar_entry *entry, void *data)
> +{
> +	efivar_entry_remove(entry);
> +	efivar_unregister(entry);
> +	return 0;
>  }
> -EXPORT_SYMBOL_GPL(unregister_efivars);
> 
>  /*
>   * Print a warning when duplicate EFI variables are encountered and
> @@ -1985,43 +1710,91 @@ static void dup_variable_bug(efi_char16_t *s16, efi_guid_t *vendor_guid,
>  	kfree(s8);
>  }
> 
> -int register_efivars(struct efivars *efivars,
> -		     const struct efivar_operations *ops,
> -		     struct kobject *parent_kobj)
> +static struct kobject *efivars_kobj;
> +
> +void efivars_sysfs_exit(void)
>  {
> -	efi_status_t status = EFI_NOT_FOUND;
> -	efi_guid_t vendor_guid;
> -	efi_char16_t *variable_name;
> -	unsigned long variable_name_size = 1024;
> -	int error = 0;
> +	/* Remove all entries and destroy */
> +	__efivar_entry_iter(efivar_sysfs_destroy, &efivar_sysfs_list, NULL, NULL);
> +
> +	if (efivars_new_var)
> +		sysfs_remove_bin_file(&efivars_kset->kobj, efivars_new_var);
> +	if (efivars_del_var)
> +		sysfs_remove_bin_file(&efivars_kset->kobj, efivars_del_var);
> +	kfree(efivars_new_var);
> +	kfree(efivars_del_var);
> +	kobject_put(efivars_kobj);
> +	kset_unregister(efivars_kset);
> +}
> 
> -	__efivars = efivars;
> +int efivars_sysfs_init(void)
> +{
> +	struct kobject *parent_kobj = efivars_kobject();
> +	int error = 0;
> 
> -	variable_name = kzalloc(variable_name_size, GFP_KERNEL);
> -	if (!variable_name) {
> -		printk(KERN_ERR "efivars: Memory allocation failed.\n");
> -		return -ENOMEM;
> -	}
> +	/* No efivars has been registered yet */
> +	if (!parent_kobj)
> +		return 0;
> 
> -	spin_lock_init(&efivars->lock);
> -	INIT_LIST_HEAD(&efivars->list);
> -	efivars->ops = ops;
> +	printk(KERN_INFO "EFI Variables Facility v%s %s\n", EFIVARS_VERSION,
> +	       EFIVARS_DATE);
> 
> -	efivars->kset = kset_create_and_add("vars", NULL, parent_kobj);
> -	if (!efivars->kset) {
> +	efivars_kset = kset_create_and_add("vars", NULL, parent_kobj);
> +	if (!efivars_kset) {
>  		printk(KERN_ERR "efivars: Subsystem registration failed.\n");
> -		error = -ENOMEM;
> -		goto out;
> +		return -ENOMEM;
>  	}
> 
> -	efivars->kobject = kobject_create_and_add("efivars", parent_kobj);
> -	if (!efivars->kobject) {
> +	efivars_kobj = kobject_create_and_add("efivars", parent_kobj);
> +	if (!efivars_kobj) {
>  		pr_err("efivars: Subsystem registration failed.\n");
> -		error = -ENOMEM;
> -		kset_unregister(efivars->kset);
> -		goto out;
> +		kset_unregister(efivars_kset);
> +		return -ENOMEM;
> +	}
> +
> +	efivar_init(efivars_sysfs_callback, NULL, false,
> +		    true, &efivar_sysfs_list);
> +
> +	error = create_efivars_bin_attributes();
> +	if (error)
> +		efivars_sysfs_exit();
> +
> +	return error;
> +}
> +EXPORT_SYMBOL_GPL(efivars_sysfs_init);
> +
> +/**
> + * efivar_init - build the initial list of EFI variables
> + * @func: callback function to invoke for every variable
> + * @data: function-specific data to pass to @func
> + * @atomic: do we need to execute the @func-loop atomically?
> + * @duplicates: error if we encounter duplicates on @head?
> + * @head: initialised head of variable list
> + *
> + * Get every EFI variable from the firmware and invoke @func. @func
> + * should call efivar_entry_add() to build the list of variables.
> + *
> + * Returns 0 on success, or a kernel error code on failure.
> + */
> +int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
> +		void *data, bool atomic, bool duplicates,
> +		struct list_head *head)
> +{
> +	const struct efivar_operations *ops = __efivars->ops;
> +	unsigned long variable_name_size = 1024;
> +	efi_char16_t *variable_name;
> +	efi_status_t status;
> +	efi_guid_t vendor_guid;
> +	int err = 0;
> +
> +	variable_name = kzalloc(variable_name_size, GFP_KERNEL);
> +	if (!variable_name) {
> +		printk(KERN_ERR "efivars: Memory allocation failed.\n");
> +		return -ENOMEM;
>  	}
> 
> +	spin_lock_irq(&__efivars->lock);
> +
>  	/*
>  	 * Per EFI spec, the maximum storage allocated for both
>  	 * the variable name and variable data is 1024 bytes.
> @@ -2035,6 +1808,9 @@ int register_efivars(struct efivars *efivars,
>  						&vendor_guid);
>  		switch (status) {
>  		case EFI_SUCCESS:
> +			if (!atomic)
> +				spin_unlock_irq(&__efivars->lock);
> +
>  			variable_name_size = var_name_strnsize(variable_name,
>  							       variable_name_size);
> 
> @@ -2046,17 +1822,24 @@ int register_efivars(struct efivars *efivars,
>  			 * we'll ever see a different variable name,
>  			 * and may end up looping here forever.
>  			 */
> -			if (variable_is_present(variable_name, &vendor_guid)) {
> +			if (duplicates &&
> +			    variable_is_present(variable_name, &vendor_guid, head)) {
>  				dup_variable_bug(variable_name, &vendor_guid,
>  						 variable_name_size);
> +				if (!atomic)
> +					spin_lock_irq(&__efivars->lock);
> +
>  				status = EFI_NOT_FOUND;
>  				break;
>  			}
> 
> -			efivar_create_sysfs_entry(efivars,
> -						  variable_name_size,
> -						  variable_name,
> -						  &vendor_guid);
> +			err = func(variable_name, vendor_guid, variable_name_size, data);
> +			if (err)
> +				status = EFI_NOT_FOUND;
> +
> +			if (!atomic)
> +				spin_lock_irq(&__efivars->lock);
> +
>  			break;
>  		case EFI_NOT_FOUND:
>  			break;
> @@ -2066,40 +1849,637 @@ int register_efivars(struct efivars *efivars,
>  			status = EFI_NOT_FOUND;
>  			break;
>  		}
> +
>  	} while (status != EFI_NOT_FOUND);
> 
> -	error = create_efivars_bin_attributes(efivars);
> -	if (error)
> -		unregister_efivars(efivars);
> +	spin_unlock_irq(&__efivars->lock);
> +
> +	kfree(variable_name);
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(efivar_init);
> +
> +/**
> + * efivar_entry_add - add entry to variable list
> + * @entry: entry to add to list
> + * @head: list head
> + */
> +void efivar_entry_add(struct efivar_entry *entry, struct list_head *head)
> +{
> +	spin_lock_irq(&__efivars->lock);
> +	list_add(&entry->list, head);
> +	spin_unlock_irq(&__efivars->lock);
> +}
> +EXPORT_SYMBOL_GPL(efivar_entry_add);
> +
> +/**
> + * efivar_entry_remove - remove entry from variable list
> + * @entry: entry to remove from list
> + */
> +void efivar_entry_remove(struct efivar_entry *entry)
> +{
> +	spin_lock_irq(&__efivars->lock);
> +	list_del(&entry->list);
> +	spin_unlock_irq(&__efivars->lock);
> +}
> +EXPORT_SYMBOL_GPL(efivar_entry_remove);
> +
> +/*
> + * efivar_entry_list_del_unlock - remove entry from variable list
> + * @entry: entry to remove
> + *
> + * Remove @entry from the variable list and release the list lock.
> + *
> + * NOTE: slightly weird locking semantics here - we expect to be
> + * called with the efivars lock already held, and we release it before
> + * returning. This is because this function is usually called after
> + * set_variable() while the lock is still held.
> + */
> +static void efivar_entry_list_del_unlock(struct efivar_entry *entry)
> +{
> +	WARN_ON(!spin_is_locked(&__efivars->lock));
> +
> +	list_del(&entry->list);
> +	spin_unlock_irq(&__efivars->lock);
> +}
> +
> +/**
> + * __efivar_entry_delete - delete an EFI variable
> + * @entry: entry containing EFI variable to delete
> + *
> + * Delete the variable from the firmware and remove @entry from the
> + * variable list. It is the caller's responsibility to free @entry
> + * once we return.
> + *
> + * This function differs from efivar_entry_delete() because it is
> + * safe to be called from within a efivar_entry_iter_begin() and
> + * efivar_entry_iter_end() region, unlike efivar_entry_delete().
> + *
> + * Returns 0 on success, or a converted EFI status code if
> + * set_variable() fails. If set_variable() fails the entry remains
> + * on the list.
> + */
> +int __efivar_entry_delete(struct efivar_entry *entry)
> +{
> +	const struct efivar_operations *ops = __efivars->ops;
> +	efi_status_t status;
> +
> +	WARN_ON(!spin_is_locked(&__efivars->lock));
> +
> +	status = ops->set_variable(entry->var.VariableName,
> +				   &entry->var.VendorGuid,
> +				   0, 0, NULL);
> +	if (status)
> +		return efi_status_to_err(status);
> +
> +	list_del(&entry->list);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(__efivar_entry_delete);
> +
> +/**
> + * efivar_entry_delete - delete variable and remove entry from list
> + * @entry: entry containing variable to delete
> + *
> + * Delete the variable from the firmware and remove @entry from the
> + * variable list. It is the caller's responsibility to free @entry
> + * once we return.
> + *
> + * Returns 0 on success, or a converted EFI status code if
> + * set_variable() fails.
> + */
> +int efivar_entry_delete(struct efivar_entry *entry)
> +{
> +	const struct efivar_operations *ops = __efivars->ops;
> +	efi_status_t status;
> +
> +	spin_lock_irq(&__efivars->lock);
> +	status = ops->set_variable(entry->var.VariableName,
> +				   &entry->var.VendorGuid,
> +				   0, 0, NULL);
> +	if (!(status == EFI_SUCCESS || status == EFI_NOT_FOUND)) {
> +		spin_unlock_irq(&__efivars->lock);
> +		return efi_status_to_err(status);
> +	}
> +
> +	efivar_entry_list_del_unlock(entry);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(efivar_entry_delete);
> +
> +/**
> + * efivar_entry_set - call set_variable()
> + * @entry: entry containing the EFI variable to write
> + * @attributes: variable attributes
> + * @size: size of @data buffer
> + * @data: buffer containing variable data
> + * @head: head of variable list
> + *
> + * Calls set_variable() for an EFI variable. If creating a new EFI
> + * variable, this function is usually followed by efivar_entry_add().
> + *
> + * Before writing the variable, the remaining EFI variable storage
> + * space is checked to ensure there is enough room available.
> + *
> + * If @head is not NULL a lookup is performed to determine whether
> + * the entry is already on the list.
> + *
> + * Returns 0 on success, -EEXIST if a lookup is performed and the entry
> + * already exists on the list, or a converted EFI status code if
> + * set_variable() fails.
> + */
> +int efivar_entry_set(struct efivar_entry *entry, u32 attributes,
> +		     unsigned long size, void *data, struct list_head *head)
> +{
> +	const struct efivar_operations *ops = __efivars->ops;
> +	efi_status_t status;
> +	efi_char16_t *name = entry->var.VariableName;
> +	efi_guid_t vendor = entry->var.VendorGuid;
> +
> +	spin_lock_irq(&__efivars->lock);
> +
> +	if (head && efivar_entry_find(name, vendor, head, false)) {
> +		spin_unlock_irq(&__efivars->lock);
> +		return -EEXIST;
> +	}
> +
> +	status = check_var_size(attributes, size + utf16_strsize(name, 1024));
> +	if (status == EFI_SUCCESS || status == EFI_UNSUPPORTED)
> +		status = ops->set_variable(name, &vendor,
> +					   attributes, size, data);
> +
> +	spin_unlock_irq(&__efivars->lock);
> +
> +	return efi_status_to_err(status);
> +}
> +EXPORT_SYMBOL_GPL(efivar_entry_set);
> +
> +/**
> + * efivar_entry_set_safe - call set_variable() if enough space in firmware
> + * @name: buffer containing the variable name
> + * @vendor: variable vendor guid
> + * @attributes: variable attributes
> + * @block: can we block in this context?
> + * @size: size of @data buffer
> + * @data: buffer containing variable data
> + *
> + * Ensures there is enough free storage in the firmware for this variable, and
> + * if so, calls set_variable(). If creating a new EFI variable, this function
> + * is usually followed by efivar_entry_add().
> + *
> + * Returns 0 on success, -ENOSPC if the firmware does not have enough
> + * space for set_variable() to succeed, or a converted EFI status code
> + * if set_variable() fails.
> + */
> +int efivar_entry_set_safe(efi_char16_t *name, efi_guid_t vendor, u32 attributes,
> +			  bool block, unsigned long size, void *data)
> +{
> +	const struct efivar_operations *ops = __efivars->ops;
> +	unsigned long flags;
> +	efi_status_t status;
> +
> +	if (!ops->query_variable_info)
> +		return -ENOSYS;
> +
> +	if (!block && !spin_trylock_irqsave(&__efivars->lock, flags))
> +		return -EBUSY;
> +	else
> +		spin_lock_irqsave(&__efivars->lock, flags);
> +
> +	status = check_var_size(attributes, size + utf16_strsize(name, 1024));
> +	if (status != EFI_SUCCESS) {
> +		spin_unlock_irqrestore(&__efivars->lock, flags);
> +		return -ENOSPC;
> +	}
> +
> +	status = ops->set_variable(name, &vendor, attributes, size, data);
> +
> +	spin_unlock_irqrestore(&__efivars->lock, flags);
> +
> +	return efi_status_to_err(status);
> +}
> +EXPORT_SYMBOL_GPL(efivar_entry_set_safe);
> +
> +/**
> + * efivar_entry_find - search for an entry
> + * @name: the EFI variable name
> + * @guid: the EFI variable vendor's guid
> + * @head: head of the variable list
> + * @remove: should we remove the entry from the list?
> + *
> + * Search for an entry on the variable list that has the EFI variable
> + * name @name and vendor guid @guid. If an entry is found on the list
> + * and @remove is true, the entry is removed from the list.
> + *
> + * The caller MUST call efivar_entry_iter_begin() and
> + * efivar_entry_iter_end() before and after the invocation of this
> + * function, respectively.
> + *
> + * Returns the entry if found on the list, %NULL otherwise.
> + */
> +struct efivar_entry *efivar_entry_find(efi_char16_t *name, efi_guid_t guid,
> +				       struct list_head *head, bool remove)
> +{
> +	struct efivar_entry *entry, *n;
> +	int strsize1, strsize2;
> +	bool found = false;
> +
> +	WARN_ON(!spin_is_locked(&__efivars->lock));
> +
> +	list_for_each_entry_safe(entry, n, head, list) {
> +		strsize1 = utf16_strsize(name, 1024);
> +		strsize2 = utf16_strsize(entry->var.VariableName, 1024);
> +		if (strsize1 == strsize2 &&
> +		    !memcmp(name, &(entry->var.VariableName), strsize1) &&
> +		    !efi_guidcmp(guid, entry->var.VendorGuid)) {
> +			found = true;
> +			break;
> +		}
> +	}
> +
> +	if (!found)
> +		return NULL;
> +
> +	if (remove)
> +		list_del(&entry->list);
> +
> +	return entry;
> +}
> +EXPORT_SYMBOL_GPL(efivar_entry_find);
> +
> +/**
> + * __efivar_entry_size - obtain the size of a variable
> + * @entry: entry for this variable
> + * @size: location to store the variable's size
> + *
> + * The caller MUST call efivar_entry_iter_begin() and
> + * efivar_entry_iter_end() before and after the invocation of this
> + * function, respectively.
> + */
> +int __efivar_entry_size(struct efivar_entry *entry, unsigned long *size)
> +{
> +	const struct efivar_operations *ops = __efivars->ops;
> +	efi_status_t status;
> +
> +	WARN_ON(!spin_is_locked(&__efivars->lock));
> +
> +	*size = 0;
> +	status = ops->get_variable(entry->var.VariableName,
> +				   &entry->var.VendorGuid, NULL, size, NULL);
> +	if (status != EFI_BUFFER_TOO_SMALL)
> +		return efi_status_to_err(status);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(__efivar_entry_size);
> +
> +/**
> + * efivar_entry_size - obtain the size of a variable
> + * @entry: entry for this variable
> + * @size: location to store the variable's size
> + */
> +int efivar_entry_size(struct efivar_entry *entry, unsigned long *size)
> +{
> +	const struct efivar_operations *ops = __efivars->ops;
> +	efi_status_t status;
> +
> +	*size = 0;
> +
> +	spin_lock_irq(&__efivars->lock);
> +	status = ops->get_variable(entry->var.VariableName,
> +				   &entry->var.VendorGuid, NULL, size, NULL);
> +	spin_unlock_irq(&__efivars->lock);
> +
> +	if (status != EFI_BUFFER_TOO_SMALL)
> +		return efi_status_to_err(status);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(efivar_entry_size);
> +
> +/**
> + * efivar_entry_get - call get_variable()
> + * @entry: read data for this variable
> + * @attributes: variable attributes
> + * @size: size of @data buffer
> + * @data: buffer to store variable data
> + */
> +int efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
> +		     unsigned long *size, void *data)
> +{
> +	const struct efivar_operations *ops = __efivars->ops;
> +	efi_status_t status;
> +
> +	spin_lock_irq(&__efivars->lock);
> +	status = ops->get_variable(entry->var.VariableName,
> +				   &entry->var.VendorGuid,
> +				   attributes, size, data);
> +	spin_unlock_irq(&__efivars->lock);
> +
> +	return efi_status_to_err(status);
> +}
> +EXPORT_SYMBOL_GPL(efivar_entry_get);
> +
> +/**
> + * efivar_entry_set_get_size - call set_variable() and get new size (atomic)
> + * @entry: entry containing variable to set and get
> + * @attributes: attributes of variable to be written
> + * @size: size of data buffer
> + * @data: buffer containing data to write
> + * @set: did the set_variable() call succeed?
> + *
> + * This is a pretty special (complex) function. See efivarfs_file_write().
> + *
> + * Atomically call set_variable() for @entry and if the call is
> + * successful, return the new size of the variable from get_variable()
> + * in @size. The success of set_variable() is indicated by @set.
> + *
> + * Returns 0 on success, -EINVAL if the variable data is invalid,
> + * -ENOSPC if the firmware does not have enough available space, or a
> + * converted EFI status code if either of set_variable() or
> + * get_variable() fail.
> + *
> + * If the EFI variable does not exist when calling set_variable()
> + * (EFI_NOT_FOUND), @entry is removed from the variable list.
> + */
> +int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
> +			      unsigned long *size, void *data, bool *set)
> +{
> +	const struct efivar_operations *ops = __efivars->ops;
> +	efi_char16_t *name = entry->var.VariableName;
> +	efi_guid_t *vendor = &entry->var.VendorGuid;
> +	efi_status_t status;
> +	int err;
> +
> +	*set = false;
> +
> +	if (efivar_validate(&entry->var, data, *size) == false)
> +		return -EINVAL;
> +
> +	/*
> +	 * The lock here protects the get_variable call, the conditional
> +	 * set_variable call, and removal of the variable from the efivars
> +	 * list (in the case of an authenticated delete).
> +	 */
> +	spin_lock_irq(&__efivars->lock);
> +
> +	/*
> +	 * Ensure that the available space hasn't shrunk below the safe level
> +	 */
> +	status = check_var_size(attributes, *size + utf16_strsize(name, 1024));
> +	if (status != EFI_SUCCESS) {
> +		if (status != EFI_UNSUPPORTED) {
> +			err = efi_status_to_err(status);
> +			goto out;
> +		}
> +
> +		if (*size > 65536) {
> +			err = -ENOSPC;
> +			goto out;
> +		}
> +	}
> +
> +	status = ops->set_variable(name, vendor, attributes, *size, data);
> +	if (status != EFI_SUCCESS) {
> +		err = efi_status_to_err(status);
> +		goto out;
> +	}
> +
> +	*set = true;
> +
> +	/*
> +	 * Writing to the variable may have caused a change in size (which
> +	 * could either be an append or an overwrite), or the variable to be
> +	 * deleted. Perform a GetVariable() so we can tell what actually
> +	 * happened.
> +	 */
> +	*size = 0;
> +	status = ops->get_variable(entry->var.VariableName,
> +				   &entry->var.VendorGuid,
> +				   NULL, size, NULL);
> +
> +	if (status == EFI_NOT_FOUND)
> +		efivar_entry_list_del_unlock(entry);
> +	else
> +		spin_unlock_irq(&__efivars->lock);
> +
> +	if (status && status != EFI_BUFFER_TOO_SMALL)
> +		return efi_status_to_err(status);
> +
> +	return 0;
> +
> +out:
> +	spin_unlock_irq(&__efivars->lock);
> +	return err;
> +
> +}
> +EXPORT_SYMBOL_GPL(efivar_entry_set_get_size);
> +
> +/**
> + * efivar_entry_iter_begin - begin iterating the variable list
> + *
> + * Lock the variable list to prevent entry insertion and removal until
> + * efivar_entry_iter_end() is called. This function is usually used in
> + * conjunction with __efivar_entry_iter() or efivar_entry_iter().
> + */
> +void efivar_entry_iter_begin(void)
> +{
> +	spin_lock_irq(&__efivars->lock);
> +}
> +EXPORT_SYMBOL_GPL(efivar_entry_iter_begin);
> +
> +/**
> + * efivar_entry_iter_end - finish iterating the variable list
> + *
> + * Unlock the variable list and allow modifications to the list again.
> + */
> +void efivar_entry_iter_end(void)
> +{
> +	spin_unlock_irq(&__efivars->lock);
> +}
> +EXPORT_SYMBOL_GPL(efivar_entry_iter_end);
> +
> +/**
> + * __efivar_entry_iter - iterate over variable list
> + * @func: callback function
> + * @head: head of the variable list
> + * @data: function-specific data to pass to callback
> + * @prev: entry to begin iterating from
> + *
> + * Iterate over the list of EFI variables and call @func with every
> + * entry on the list. It is safe for @func to remove entries in the
> + * list via efivar_entry_delete().
> + *
> + * You MUST call efivar_enter_iter_begin() before this function, and
> + * efivar_entry_iter_end() afterwards.
> + *
> + * It is possible to begin iteration from an arbitrary entry within
> + * the list by passing @prev. @prev is updated on return to point to
> + * the last entry passed to @func. To begin iterating from the
> + * beginning of the list @prev must be %NULL.
> + *
> + * The restrictions for @func are the same as documented for
> + * efivar_entry_iter().
> + */
> +int __efivar_entry_iter(int (*func)(struct efivar_entry *, void *),
> +			struct list_head *head, void *data,
> +			struct efivar_entry **prev)
> +{
> +	struct efivar_entry *entry, *n;
> +	int err = 0;
> +
> +	if (!prev || !*prev) {
> +		list_for_each_entry_safe(entry, n, head, list) {
> +			err = func(entry, data);
> +			if (err)
> +				break;
> +		}
> +
> +		if (prev)
> +			*prev = entry;
> +
> +		return err;
> +	}
> +
> +
> +	list_for_each_entry_safe_continue((*prev), n, head, list) {
> +		err = func(*prev, data);
> +		if (err)
> +			break;
> +	}
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(__efivar_entry_iter);
> +
> +/**
> + * efivar_entry_iter - iterate over variable list
> + * @func: callback function
> + * @head: head of variable list
> + * @data: function-specific data to pass to callback
> + *
> + * Iterate over the list of EFI variables and call @func with every
> + * entry on the list. It is safe for @func to remove entries in the
> + * list via efivar_entry_delete() while iterating.
> + *
> + * Some notes for the callback function:
> + *  - a non-zero return value indicates an error and terminates the loop
> + *  - @func is called from atomic context
> + */
> +int efivar_entry_iter(int (*func)(struct efivar_entry *, void *),
> +		      struct list_head *head, void *data)
> +{
> +	int err = 0;
> +
> +	efivar_entry_iter_begin();
> +	err = __efivar_entry_iter(func, head, data, NULL);
> +	efivar_entry_iter_end();
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(efivar_entry_iter);
> +
> +/**
> + * efivars_kobject - get the kobject for the registered efivars
> + *
> + * If efivars_register() has not been called we return NULL,
> + * otherwise return the kobject used at registration time.
> + */
> +struct kobject *efivars_kobject(void)
> +{
> +	if (!__efivars)
> +		return NULL;
> +
> +	return __efivars->kobject;
> +}
> +EXPORT_SYMBOL_GPL(efivars_kobject);
> +
> +/**
> + * efivars_register - register an efivars
> + * @efivars: efivars to register
> + * @ops: efivars operations
> + * @kobject: @efivars-specific kobject
> + *
> + * Only a single efivars can be registered at any time.
> + */
> +int efivars_register(struct efivars *efivars,
> +		     const struct efivar_operations *ops,
> +		     struct kobject *kobject)
> +{
> +	spin_lock_init(&efivars->lock);
> +	efivars->ops = ops;
> +	efivars->kobject = kobject;
> +
> +	__efivars = efivars;
> 
>  	if (!efivars_pstore_disable)
> -		efivar_pstore_register(efivars);
> +		efivar_pstore_register();
> 
>  	register_filesystem(&efivarfs_type);
> 
> -out:
> -	kfree(variable_name);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(efivars_register);
> 
> -	return error;
> +/**
> + * efivars_unregister - unregister an efivars
> + * @efivars: efivars to unregister
> + *
> + * The caller must have already removed every entry from the list,
> + * failure to do so is an error.
> + */
> +int efivars_unregister(struct efivars *efivars)
> +{
> +	int rv;
> +
> +	if (!__efivars) {
> +		printk(KERN_ERR "efivars not registered\n");
> +		rv = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (__efivars != efivars) {
> +		rv = -EINVAL;
> +		goto out;
> +	}
> +
> +	__efivars = NULL;
> +
> +	rv = 0;
> +out:
> +	return rv;
>  }
> -EXPORT_SYMBOL_GPL(register_efivars);
> +EXPORT_SYMBOL_GPL(efivars_unregister);
> 
>  static struct efivars generic_efivars;
>  static struct efivar_operations generic_ops;
> 
>  static int generic_ops_register(void)
>  {
> +	int error;
> +
>  	generic_ops.get_variable = efi.get_variable;
>  	generic_ops.set_variable = efi.set_variable;
>  	generic_ops.get_next_variable = efi.get_next_variable;
>  	generic_ops.query_variable_info = efi.query_variable_info;
> 
> -	return register_efivars(&generic_efivars, &generic_ops, efi_kobj);
> +	error = efivars_register(&generic_efivars, &generic_ops, efi_kobj);
> +	if (error)
> +		return error;
> +
> +	error = efivars_sysfs_init();
> +	if (error)
> +		efivars_unregister(&generic_efivars);
> +
> +	return error;
>  }
> 
>  static void generic_ops_unregister(void)
>  {
> -	unregister_efivars(&generic_efivars);
> +	efivars_sysfs_exit();
> +	efivars_unregister(&generic_efivars);
>  }
> 
>  /*
> @@ -2113,15 +2493,12 @@ static void generic_ops_unregister(void)
>  static int __init
>  efivars_init(void)
>  {
> -	int error = 0;
> -
> -	printk(KERN_INFO "EFI Variables Facility v%s %s\n", EFIVARS_VERSION,
> -	       EFIVARS_DATE);
> +	int error;
> 
>  	if (!efi_enabled(EFI_RUNTIME_SERVICES))
>  		return 0;
> 
> -	/* For now we'll register the efi directory at /sys/firmware/efi */
> +	/* Register the efi directory at /sys/firmware/efi */
>  	efi_kobj = kobject_create_and_add("efi", firmware_kobj);
>  	if (!efi_kobj) {
>  		printk(KERN_ERR "efivars: Firmware registration failed.\n");
> diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
> index c409a75..757b2d9 100644
> --- a/drivers/firmware/google/gsmi.c
> +++ b/drivers/firmware/google/gsmi.c
> @@ -882,12 +882,19 @@ static __init int gsmi_init(void)
>  		goto out_remove_bin_file;
>  	}
> 
> -	ret = register_efivars(&efivars, &efivar_ops, gsmi_kobj);
> +	ret = efivars_register(&efivars, &efivar_ops, gsmi_kobj);
>  	if (ret) {
>  		printk(KERN_INFO "gsmi: Failed to register efivars\n");
>  		goto out_remove_sysfs_files;
>  	}
> 
> +	ret = efivars_sysfs_init();
> +	if (ret) {
> +		printk(KERN_INFO "gsmi: Failed to create efivars files\n");
> +		efivars_unregister(&efivars);
> +		goto out_remove_sysfs_files;
> +	}
> +
>  	register_reboot_notifier(&gsmi_reboot_notifier);
>  	register_die_notifier(&gsmi_die_notifier);
>  	atomic_notifier_chain_register(&panic_notifier_list,
> @@ -919,7 +926,7 @@ static void __exit gsmi_exit(void)
>  	unregister_die_notifier(&gsmi_die_notifier);
>  	atomic_notifier_chain_unregister(&panic_notifier_list,
>  					 &gsmi_panic_notifier);
> -	unregister_efivars(&efivars);
> +	efivars_unregister(&efivars);
> 
>  	sysfs_remove_files(gsmi_kobj, gsmi_attrs);
>  	sysfs_remove_bin_file(gsmi_kobj, &eventlog_bin_attr);
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index d1d782a..cd561b3 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -663,6 +663,12 @@ static inline int efi_enabled(int facility)
>  				EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS | \
>  				EFI_VARIABLE_APPEND_WRITE)
>  /*
> + * Length of a GUID string (strlen("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"))
> + * not including trailing NUL
> + */
> +#define EFI_VARIABLE_GUID_LEN 36
> +
> +/*
>   * The type of search to perform when calling boottime->locate_handle
>   */
>  #define EFI_LOCATE_ALL_HANDLES			0
> @@ -762,19 +768,75 @@ struct efivars {
>  	 * which is protected by the BKL, so that path is safe.
>  	 */
>  	spinlock_t lock;
> -	struct list_head list;
>  	struct kset *kset;
>  	struct kobject *kobject;
> -	struct bin_attribute *new_var, *del_var;
>  	const struct efivar_operations *ops;
> -	struct efivar_entry *walk_entry;
> -	struct pstore_info efi_pstore_info;
>  };
> 
> -int register_efivars(struct efivars *efivars,
> +/*
> + * The maximum size of VariableName + Data = 1024
> + * Therefore, it's reasonable to save that much
> + * space in each part of the structure,
> + * and we use a page for reading/writing.
> + */
> +
> +struct efi_variable {
> +	efi_char16_t  VariableName[1024/sizeof(efi_char16_t)];
> +	efi_guid_t    VendorGuid;
> +	unsigned long DataSize;
> +	__u8          Data[1024];
> +	efi_status_t  Status;
> +	__u32         Attributes;
> +} __attribute__((packed));
> +
> +struct efivar_entry {
> +	struct efi_variable var;
> +	struct list_head list;
> +	struct kobject kobj;
> +};
> +
> +int efivars_register(struct efivars *efivars,
>  		     const struct efivar_operations *ops,
> -		     struct kobject *parent_kobj);
> -void unregister_efivars(struct efivars *efivars);
> +		     struct kobject *kobject);
> +int efivars_unregister(struct efivars *efivars);
> +struct kobject *efivars_kobject(void);
> +
> +int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
> +		void *data, bool atomic, bool duplicates,
> +		struct list_head *head);
> +
> +void efivar_entry_add(struct efivar_entry *entry, struct list_head *head);
> +void efivar_entry_remove(struct efivar_entry *entry);
> +
> +int __efivar_entry_delete(struct efivar_entry *entry);
> +int efivar_entry_delete(struct efivar_entry *entry);
> +
> +int __efivar_entry_size(struct efivar_entry *entry, unsigned long *size);
> +int efivar_entry_size(struct efivar_entry *entry, unsigned long *size);
> +int efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
> +		     unsigned long *size, void *data);
> +int efivar_entry_set(struct efivar_entry *entry, u32 attributes,
> +		     unsigned long size, void *data, struct list_head *head);
> +int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
> +			      unsigned long *size, void *data, bool *set);
> +int efivar_entry_set_safe(efi_char16_t *name, efi_guid_t vendor, u32 attributes,
> +			  bool block, unsigned long size, void *data);
> +
> +void efivar_entry_iter_begin(void);
> +void efivar_entry_iter_end(void);
> +
> +int __efivar_entry_iter(int (*func)(struct efivar_entry *, void *),
> +			struct list_head *head, void *data,
> +			struct efivar_entry **prev);
> +int efivar_entry_iter(int (*func)(struct efivar_entry *, void *),
> +		      struct list_head *head, void *data);
> +
> +struct efivar_entry *efivar_entry_find(efi_char16_t *name, efi_guid_t guid,
> +				       struct list_head *head, bool remove);
> +
> +bool efivar_validate(struct efi_variable *var, u8 *data, unsigned long len);
> +
> +int efivars_sysfs_init(void);
> 
>  #endif /* CONFIG_EFI_VARS */
> 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
