Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936911Ab3DJP0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 11:26:53 -0400
Received: from usindpps04.hds.com ([207.126.252.17]:48867 "EHLO
	usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935568Ab3DJP0v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 11:26:51 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Matt Fleming <matt@console-pimps.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Matt Fleming" <matt.fleming@intel.com>, Tom Gundersen <teg@jklm.no>,
        "Matthew Garrett" <mjg59@srcf.ucam.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        "Tony Luck" <tony.luck@intel.com>, Mike Waychison <mikew@google.com>
Subject: RE: [PATCH 3/6] efivars: efivar_entry API
Thread-Topic: [PATCH 3/6] efivars: efivar_entry API
Thread-Index: AQHOMS6o8lzjEPh7XkCNMGWjGQfSNZjPmmpw
Date: Wed, 10 Apr 2013 15:25:54 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF8CFEE@USINDEM103.corp.hds.com>
References: <1365077935-6859-1-git-send-email-matt@console-pimps.org>
 <1365077935-6859-4-git-send-email-matt@console-pimps.org>
In-Reply-To: <1365077935-6859-4-git-send-email-matt@console-pimps.org>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-04-10_07:2013-04-10,2013-04-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=2 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1304100130
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
> -			       int *count, struct timespec *timespec,
> -			       char **buf, struct pstore_info *psi)
> +struct pstore_read_data {
> +	u64 *id;
> +	enum pstore_type_id *type;
> +	int *count;
> +	struct timespec *timespec;
> +	char **buf;
> +};
> +
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
> +	efivar_entry_size(entry, &size);

Deadlocking will happen in this efivar_entry_size() because __efivars->lock is already hold 
in efivar_entry_iter_begin().


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
> @@ -1382,36 +1221,7 @@ static int efi_pstore_write(enum pstore_type_id type,
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
> @@ -1419,81 +1229,90 @@ static int efi_pstore_write(enum pstore_type_id type,
>  	for (i = 0; i < DUMP_NAME_LEN; i++)
>  		efi_name[i] = name[i];
> 
> -	efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
> -				   size, psi->buf);
> +	ret = efivar_entry_set_safe(efi_name, vendor, PSTORE_EFI_ATTRIBUTES,
> +				    !pstore_cannot_block_path(reason),
> +				    size, psi->buf);
> 
> -	spin_unlock_irqrestore(&efivars->lock, flags);
> -
> -	if (reason == KMSG_DUMP_OOPS && efivar_wq_enabled)
> +	if (size && !ret && reason == KMSG_DUMP_OOPS && efivar_wq_enabled)

Why do you add (size && !ret) checking?
If the purpose of this patch is just adding new API, we don't need to modify the logic.


>  		schedule_work(&efivar_work);
> 
>  	*id = part;
>  	return ret;
>  };

