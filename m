Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab3JGLm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:42:26 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:52779 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754109Ab3JGLmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:42:22 -0400
Date: Mon, 7 Oct 2013 12:42:18 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        tony.luck@intel.com, matt.fleming@intel.com,
        dle-develop@lists.sourceforge.net, tomoki.sekiyama@hds.com
Subject: Re: [RFC][PATCH v2] efivars,efi-pstore: Hold off deletion of sysfs
 entry until the scan is completed
Message-ID: <20131007114218.GA14773@console-pimps.org>
References: <5245E958.5040602@hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5245E958.5040602@hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Sep, at 04:23:52PM, Seiji Aguchi wrote:
> Change form v1
>  - Rebase to 3.12-rc2
> 
> Currently, when mounting pstore file system, a read callback of efi_pstore
> driver runs mutiple times as below.
> 
> - In the first read callback, scan efivar_sysfs_list from head and pass
>   a kmsg buffer of a entry to an upper pstore layer.
> - In the second read callback, rescan efivar_sysfs_list from the entry and pass
>   another kmsg buffer to it.
> - Repeat the scan and pass until the end of efivar_sysfs_list.
> 
> In this process, an entry is read across the multiple read function calls.
> To avoid race between the read and erasion, the whole process above is
> protected by a spinlock, holding in open() and releasing in close().
> 
> At the same time, kmemdup() is called to pass the buffer to pstore filesystem
> during it.
> And then, it causes a following lockdep warning.
> 
> To make the read callback runnable without taking spinlok,
> holding off a deletion of sysfs entry if it happens while scanning it
> via efi_pstore, and deleting it after the scan is completed.
> 
> To implement it, this patch introduces two flags, scanning and deleting,
> to efivar_entry.
> Also, __efivar_entry_get() is removed because it was used in efi_pstore only.

[...]

> @@ -88,8 +103,9 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
>  		return 0;
>  
>  	entry->var.DataSize = 1024;
> -	__efivar_entry_get(entry, &entry->var.Attributes,
> -			   &entry->var.DataSize, entry->var.Data);
> +	efivar_entry_get(entry, &entry->var.Attributes,
> +			 &entry->var.DataSize, entry->var.Data);
> +
>  	size = entry->var.DataSize;
>  
>  	*cb_data->buf = kmemdup(entry->var.Data, size, GFP_KERNEL);

This isn't safe to do without holding the __efivars->lock, because
there's the potential for someone else to update entry->var.Data and
entry->var.DataSize while you're in the middle of copying the data in
kmemdup(). This could leak to an information leak, though I think you're
safe from an out-of-bounds access because DataSize is never > 1024.

> +/**
> + * __efi_pstore_scan_sysfs_exit
> + * @entry: deleting entry
> + * @turn_off_scanning: Check if a scanning flag should be turned off
> + */
> +static inline void __efi_pstore_scan_sysfs_exit(struct efivar_entry *entry,
> +						bool turn_off_scanning)
> +{
> +	if (entry->deleting) {
> +		list_del(&entry->list);
> +		efivar_entry_iter_end();
> +		efivar_unregister(entry);
> +		efivar_entry_iter_begin();
> +	} else if (turn_off_scanning)
> +		entry->scanning = false;
> +}

[...]

> @@ -184,9 +305,17 @@ static int efi_pstore_erase_func(struct efivar_entry *entry, void *data)
>  			return 0;
>  	}
>  
> +	if (entry->scanning) {
> +		/*
> +		 * Skip deletion because this entry will be deleted
> +		 * after scanning is completed.
> +		 */
> +		entry->deleting = true;
> +	} else
> +		list_del(&entry->list);
> +
>  	/* found */
>  	__efivar_entry_delete(entry);
> -	list_del(&entry->list);
>  
>  	return 1;
>  }
> @@ -216,7 +345,7 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
>  	found = __efivar_entry_iter(efi_pstore_erase_func, &efivar_sysfs_list, &edata, &entry);
>  	efivar_entry_iter_end();
>  
> -	if (found)
> +	if (found && !entry->scanning)
>  		efivar_unregister(entry);
>  
>  	return 0;
> diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
> index 8a7432a..831bc5c 100644
> --- a/drivers/firmware/efi/efivars.c
> +++ b/drivers/firmware/efi/efivars.c
> @@ -388,7 +388,8 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
>  	if (err)
>  		return err;
>  
> -	efivar_unregister(entry);
> +	if (!entry->scanning)
> +		efivar_unregister(entry);
>  
>  	/* It's dead Jim.... */
>  	return count;
> diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
> index 391c67b..573ed92 100644
> --- a/drivers/firmware/efi/vars.c
> +++ b/drivers/firmware/efi/vars.c
> @@ -683,8 +683,16 @@ struct efivar_entry *efivar_entry_find(efi_char16_t *name, efi_guid_t guid,
>  	if (!found)
>  		return NULL;
>  
> -	if (remove)
> -		list_del(&entry->list);
> +	if (remove) {
> +		if (entry->scanning) {
> +			/*
> +			 * The entry will be deleted
> +			 * after scanning is completed.
> +			 */
> +			entry->deleting = true;
> +		} else
> +			list_del(&entry->list);
> +	}
>  
>  	return entry;
>  }

This doesn't look correct to me. You can't access 'entry' outside of the
*_iter_begin() and *_iter_end() blocks. You can't do,

	efivar_entry_iter_end():

	if (!entry->scanning)
		efivar_unregister(entry);

because 'entry' may have already been freed by another CPU.

-- 
Matt Fleming, Intel Open Source Technology Center
