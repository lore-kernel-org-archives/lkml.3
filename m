Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab3JQOay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:30:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422Ab3JQOax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:30:53 -0400
References: <52584373.3010202@hds.com> <878uxssarf.fsf@redhat.com> <A5ED84D3BB3A384992CBB9C77DEDA4D443F0BEB4@USINDEM103.corp.hds.com>
User-agent: mu4e 0.9.9.5; emacs 24.3.1
From: Madper Xie <cxie@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Madper Xie <cxie@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi\@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "matt.fleming\@intel.com" <matt.fleming@intel.com>,
        "tony.luck\@intel.com" <tony.luck@intel.com>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>,
        "dle-develop\@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH v3] efivars,efi-pstore: Hold off deletion of sysfs entry until, the scan is completed
In-reply-to: <A5ED84D3BB3A384992CBB9C77DEDA4D443F0BEB4@USINDEM103.corp.hds.com>
Date: Thu, 17 Oct 2013 22:30:26 +0800
Message-ID: <87fvs0as1p.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, It seems my mu4e(a email client for emacs)'s auto-indent breaks the
patch... I apologize for this... 

seiji.aguchi@hds.com writes:

> Hi Madper,
>
> I tested this patch on 3.12-rc4.
> Could you please send me the log when you failed to apply?
>
> Seiji
>
>> -----Original Message-----
>> From: Madper Xie [mailto:cxie@redhat.com]
>> Sent: Thursday, October 17, 2013 1:54 AM
>> To: Seiji Aguchi
>> Cc: linux-kernel@vger.kernel.org; linux-efi@vger.kernel.org; matt.fleming@intel.com; tony.luck@intel.com; Tomoki Sekiyama; dle-
>> develop@lists.sourceforge.net
>> Subject: Re: [PATCH v3] efivars,efi-pstore: Hold off deletion of sysfs entry until, the scan is completed
>> 
>> Howdy Seiji,
>>   I failed appily this patch to both 3.12-rc2 and 3.12-rc4. Could you
>>   please let me know which is the right tree for this patch?
>> 
>>   Thanks,
>>   Madper.
>> seiji.aguchi@hds.com writes:
>> 
>> > Change from v2:
>> > - Move dynamic memory allocation to efi_pstore_read() before holding
>> >   efivars->lock to protect entry->var.Data.
>> > - Access to entry->scanning while holding efivars->lock.
>> > - Move a comment about a returned value from efi_pstore_read_func() to
>> >   efi_pstore_read() because "size < 0" case may happen in efi_pstore_read().
>> >
>> > Currently, when mounting pstore file system, a read callback of efi_pstore
>> > driver runs mutiple times as below.
>> >
>> > - In the first read callback, scan efivar_sysfs_list from head and pass
>> >   a kmsg buffer of a entry to an upper pstore layer.
>> > - In the second read callback, rescan efivar_sysfs_list from the entry and pass
>> >   another kmsg buffer to it.
>> > - Repeat the scan and pass until the end of efivar_sysfs_list.
>> >
>> > In this process, an entry is read across the multiple read function calls.
>> > To avoid race between the read and erasion, the whole process above is
>> > protected by a spinlock, holding in open() and releasing in close().
>> >
>> > At the same time, kmemdup() is called to pass the buffer to pstore filesystem
>> > during it.
>> > And then, it causes a following lockdep warning.
>> >
>> > To make the dynamic memory allocation runnable without taking spinlock,
>> > holding off a deletion of sysfs entry if it happens while scanning it
>> > via efi_pstore, and deleting it after the scan is completed.
>> >
>> > To implement it, this patch introduces two flags, scanning and deleting,
>> > to efivar_entry.
>> >
>> > [    1.143710] ------------[ cut here ]------------
>> > [    1.144058] WARNING: CPU: 1 PID: 1 at kernel/lockdep.c:2740
>> > lockdep_trace_alloc+0x104/0x110()
>> > [    1.144058] DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))
>> > [    1.144058] Modules linked in:
>> >
>> > [    1.144058] CPU: 1 PID: 1 Comm: systemd Not tainted 3.11.0-rc5 #2
>> > [    1.144058]  0000000000000009 ffff8800797e9ae0 ffffffff816614a5
>> > ffff8800797e9b28
>> > [    1.144058]  ffff8800797e9b18 ffffffff8105510d 0000000000000080
>> > 0000000000000046
>> > [    1.144058]  00000000000000d0 00000000000003af ffffffff81ccd0c0
>> > ffff8800797e9b78
>> > [    1.144058] Call Trace:
>> > [    1.144058]  [<ffffffff816614a5>] dump_stack+0x54/0x74
>> > [    1.144058]  [<ffffffff8105510d>] warn_slowpath_common+0x7d/0xa0
>> > [    1.144058]  [<ffffffff8105517c>] warn_slowpath_fmt+0x4c/0x50
>> > [    1.144058]  [<ffffffff8131290f>] ? vsscanf+0x57f/0x7b0
>> > [    1.144058]  [<ffffffff810bbd74>] lockdep_trace_alloc+0x104/0x110
>> > [    1.144058]  [<ffffffff81192da0>] __kmalloc_track_caller+0x50/0x280
>> > [    1.144058]  [<ffffffff815147bb>] ?
>> > efi_pstore_read_func.part.1+0x12b/0x170
>> > [    1.144058]  [<ffffffff8115b260>] kmemdup+0x20/0x50
>> > [    1.144058]  [<ffffffff815147bb>] efi_pstore_read_func.part.1+0x12b/0x170
>> > [    1.144058]  [<ffffffff81514800>] ?
>> > efi_pstore_read_func.part.1+0x170/0x170
>> > [    1.144058]  [<ffffffff815148b4>] efi_pstore_read_func+0xb4/0xe0
>> > [    1.144058]  [<ffffffff81512b7b>] __efivar_entry_iter+0xfb/0x120
>> > [    1.144058]  [<ffffffff8151428f>] efi_pstore_read+0x3f/0x50
>> > [    1.144058]  [<ffffffff8128d7ba>] pstore_get_records+0x9a/0x150
>> > [    1.158207]  [<ffffffff812af25c>] ? selinux_d_instantiate+0x1c/0x20
>> > [    1.158207]  [<ffffffff8128ce30>] ? parse_options+0x80/0x80
>> > [    1.158207]  [<ffffffff8128ced5>] pstore_fill_super+0xa5/0xc0
>> > [    1.158207]  [<ffffffff811ae7d2>] mount_single+0xa2/0xd0
>> > [    1.158207]  [<ffffffff8128ccf8>] pstore_mount+0x18/0x20
>> > [    1.158207]  [<ffffffff811ae8b9>] mount_fs+0x39/0x1b0
>> > [    1.158207]  [<ffffffff81160550>] ? __alloc_percpu+0x10/0x20
>> > [    1.158207]  [<ffffffff811c9493>] vfs_kern_mount+0x63/0xf0
>> > [    1.158207]  [<ffffffff811cbb0e>] do_mount+0x23e/0xa20
>> > [    1.158207]  [<ffffffff8115b51b>] ? strndup_user+0x4b/0xf0
>> > [    1.158207]  [<ffffffff811cc373>] SyS_mount+0x83/0xc0
>> > [    1.158207]  [<ffffffff81673cc2>] system_call_fastpath+0x16/0x1b
>> > [    1.158207] ---[ end trace 61981bc62de9f6f4 ]---
>> >
>> > Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
>> > ---
>> >  drivers/firmware/efi/efi-pstore.c | 143 +++++++++++++++++++++++++++++++++++---
>> >  drivers/firmware/efi/efivars.c    |  12 ++--
>> >  drivers/firmware/efi/vars.c       |  12 +++-
>> >  include/linux/efi.h               |   2 +
>> >  4 files changed, 153 insertions(+), 16 deletions(-)
>> >
>> > diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
>> > index 5002d50..ebd5dbc 100644
>> > --- a/drivers/firmware/efi/efi-pstore.c
>> > +++ b/drivers/firmware/efi/efi-pstore.c
>> > @@ -18,14 +18,12 @@ module_param_named(pstore_disable, efivars_pstore_disable, bool, 0644);
>> >
>> >  static int efi_pstore_open(struct pstore_info *psi)
>> >  {
>> > -	efivar_entry_iter_begin();
>> >  	psi->data = NULL;
>> >  	return 0;
>> >  }
>> >
>> >  static int efi_pstore_close(struct pstore_info *psi)
>> >  {
>> > -	efivar_entry_iter_end();
>> >  	psi->data = NULL;
>> >  	return 0;
>> >  }
>> > @@ -91,19 +89,125 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
>> >  	__efivar_entry_get(entry, &entry->var.Attributes,
>> >  			   &entry->var.DataSize, entry->var.Data);
>> >  	size = entry->var.DataSize;
>> > +	memcpy(*cb_data->buf, entry->var.Data, (size_t)min_t(unsigned long,
>> > +							     1024, size));
>> >
>> > -	*cb_data->buf = kmemdup(entry->var.Data, size, GFP_KERNEL);
>> > -	if (*cb_data->buf == NULL)
>> > -		return -ENOMEM;
>> >  	return size;
>> >  }
>> >
>> > +/**
>> > + * efi_pstore_scan_sysfs_enter
>> > + * @entry: scanning entry
>> > + * @next: next entry
>> > + * @head: list head
>> > + */
>> > +static void efi_pstore_scan_sysfs_enter(struct efivar_entry *pos,
>> > +					struct efivar_entry *next,
>> > +					struct list_head *head)
>> > +{
>> > +	pos->scanning = true;
>> > +	if (&next->list != head)
>> > +		next->scanning = true;
>> > +}
>> > +
>> > +/**
>> > + * __efi_pstore_scan_sysfs_exit
>> > + * @entry: deleting entry
>> > + * @turn_off_scanning: Check if a scanning flag should be turned off
>> > + */
>> > +static inline void __efi_pstore_scan_sysfs_exit(struct efivar_entry *entry,
>> > +						bool turn_off_scanning)
>> > +{
>> > +	if (entry->deleting) {
>> > +		list_del(&entry->list);
>> > +		efivar_entry_iter_end();
>> > +		efivar_unregister(entry);
>> > +		efivar_entry_iter_begin();
>> > +	} else if (turn_off_scanning)
>> > +		entry->scanning = false;
>> > +}
>> > +
>> > +/**
>> > + * efi_pstore_scan_sysfs_exit
>> > + * @pos: scanning entry
>> > + * @next: next entry
>> > + * @head: list head
>> > + * @stop: a flag checking if scanning will stop
>> > + */
>> > +static void efi_pstore_scan_sysfs_exit(struct efivar_entry *pos,
>> > +				       struct efivar_entry *next,
>> > +				       struct list_head *head, bool stop)
>> > +{
>> > +	__efi_pstore_scan_sysfs_exit(pos, true);
>> > +	if (stop)
>> > +		__efi_pstore_scan_sysfs_exit(next, &next->list != head);
>> > +}
>> > +
>> > +/**
>> > + * efi_pstore_sysfs_entry_iter
>> > + *
>> > + * @data: function-specific data to pass to callback
>> > + * @pos: entry to begin iterating from
>> > + *
>> > + * You MUST call efivar_enter_iter_begin() before this function, and
>> > + * efivar_entry_iter_end() afterwards.
>> > + *
>> > + * It is possible to begin iteration from an arbitrary entry within
>> > + * the list by passing @pos. @pos is updated on return to point to
>> > + * the next entry of the last one passed to efi_pstore_read_func().
>> > + * To begin iterating from the beginning of the list @pos must be %NULL.
>> > + */
>> > +static int efi_pstore_sysfs_entry_iter(void *data, struct efivar_entry **pos)
>> > +{
>> > +	struct efivar_entry *entry, *n;
>> > +	struct list_head *head = &efivar_sysfs_list;
>> > +	int size = 0;
>> > +
>> > +	if (!*pos) {
>> > +		list_for_each_entry_safe(entry, n, head, list) {
>> > +			efi_pstore_scan_sysfs_enter(entry, n, head);
>> > +
>> > +			size = efi_pstore_read_func(entry, data);
>> > +			efi_pstore_scan_sysfs_exit(entry, n, head, size < 0);
>> > +			if (size)
>> > +				break;
>> > +		}
>> > +		*pos = n;
>> > +		return size;
>> > +	}
>> > +
>> > +	list_for_each_entry_safe_from((*pos), n, head, list) {
>> > +		efi_pstore_scan_sysfs_enter((*pos), n, head);
>> > +
>> > +		size = efi_pstore_read_func((*pos), data);
>> > +		efi_pstore_scan_sysfs_exit((*pos), n, head, size < 0);
>> > +		if (size)
>> > +			break;
>> > +	}
>> > +	*pos = n;
>> > +	return size;
>> > +}
>> > +
>> > +/**
>> > + * efi_pstore_read
>> > + *
>> > + * This function returns a size of NVRAM entry logged via efi_pstore_write().
>> > + * The meaning and behavior of efi_pstore/pstore are as below.
>> > + *
>> > + * size > 0: Got data of an entry logged via efi_pstore_write() successfully,
>> > + *           and pstore filesystem will continue reading subsequent entries.
>> > + * size == 0: Entry was not logged via efi_pstore_write(),
>> > + *            and efi_pstore driver will continue reading subsequent entries.
>> > + * size < 0: Failed to get data of entry logging via efi_pstore_write(),
>> > + *           and pstore will stop reading entry.
>> > + */
>> >  static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
>> >  			       int *count, struct timespec *timespec,
>> >  			       char **buf, bool *compressed,
>> >  			       struct pstore_info *psi)
>> >  {
>> >  	struct pstore_read_data data;
>> > +	ssize_t size;
>> >
>> >  	data.id = id;
>> >  	data.type = type;
>> > @@ -112,8 +216,17 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
>> >  	data.compressed = compressed;
>> >  	data.buf = buf;
>> >
>> > -	return __efivar_entry_iter(efi_pstore_read_func, &efivar_sysfs_list, &data,
>> > -				   (struct efivar_entry **)&psi->data);
>> > +	*data.buf = kzalloc(1024, GFP_KERNEL);
>> > +	if (!*data.buf)
>> > +		return -ENOMEM;
>> > +
>> > +	efivar_entry_iter_begin();
>> > +	size = efi_pstore_sysfs_entry_iter(&data,
>> > +					   (struct efivar_entry **)&psi->data);
>> > +	efivar_entry_iter_end();
>> > +	if (size <= 0)
>> > +		kfree(*data.buf);
>> > +	return size;
>> >  }
>> >
>> >  static int efi_pstore_write(enum pstore_type_id type,
>> > @@ -184,9 +297,17 @@ static int efi_pstore_erase_func(struct efivar_entry *entry, void *data)
>> >  			return 0;
>> >  	}
>> >
>> > +	if (entry->scanning) {
>> > +		/*
>> > +		 * Skip deletion because this entry will be deleted
>> > +		 * after scanning is completed.
>> > +		 */
>> > +		entry->deleting = true;
>> > +	} else
>> > +		list_del(&entry->list);
>> > +
>> >  	/* found */
>> >  	__efivar_entry_delete(entry);
>> > -	list_del(&entry->list);
>> >
>> >  	return 1;
>> >  }
>> > @@ -214,10 +335,12 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
>> >
>> >  	efivar_entry_iter_begin();
>> >  	found = __efivar_entry_iter(efi_pstore_erase_func, &efivar_sysfs_list, &edata, &entry);
>> > -	efivar_entry_iter_end();
>> >
>> > -	if (found)
>> > +	if (found && !entry->scanning) {
>> > +		efivar_entry_iter_end();
>> >  		efivar_unregister(entry);
>> > +	} else
>> > +		efivar_entry_iter_end();
>> >
>> >  	return 0;
>> >  }
>> > diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
>> > index 8a7432a..8c5a61a 100644
>> > --- a/drivers/firmware/efi/efivars.c
>> > +++ b/drivers/firmware/efi/efivars.c
>> > @@ -383,12 +383,16 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
>> >  	else if (__efivar_entry_delete(entry))
>> >  		err = -EIO;
>> >
>> > -	efivar_entry_iter_end();
>> > -
>> > -	if (err)
>> > +	if (err) {
>> > +		efivar_entry_iter_end();
>> >  		return err;
>> > +	}
>> >
>> > -	efivar_unregister(entry);
>> > +	if (!entry->scanning) {
>> > +		efivar_entry_iter_end();
>> > +		efivar_unregister(entry);
>> > +	} else
>> > +		efivar_entry_iter_end();
>> >
>> >  	/* It's dead Jim.... */
>> >  	return count;
>> > diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
>> > index 391c67b..b22659c 100644
>> > --- a/drivers/firmware/efi/vars.c
>> > +++ b/drivers/firmware/efi/vars.c
>> > @@ -683,8 +683,16 @@ struct efivar_entry *efivar_entry_find(efi_char16_t *name, efi_guid_t guid,
>> >  	if (!found)
>> >  		return NULL;
>> >
>> > -	if (remove)
>> > -		list_del(&entry->list);
>> > +	if (remove) {
>> > +		if (entry->scanning) {
>> > +			/*
>> > +			 * The entry will be deleted
>> > +			 * after scanning is completed.
>> > +			 */
>> > +			entry->deleting = true;
>> > +		} else
>> > +			list_del(&entry->list);
>> > +	}
>> >
>> >  	return entry;
>> >  }
>> > diff --git a/include/linux/efi.h b/include/linux/efi.h
>> > index 5f8f176..04088fb 100644
>> > --- a/include/linux/efi.h
>> > +++ b/include/linux/efi.h
>> > @@ -782,6 +782,8 @@ struct efivar_entry {
>> >  	struct efi_variable var;
>> >  	struct list_head list;
>> >  	struct kobject kobj;
>> > +	bool scanning;
>> > +	bool deleting;
>> >  };
>> >
>> >  extern struct list_head efivar_sysfs_list;
>> 
>> 
>> --
>> Best,
>> Madper Xie.


-- 
Best,
Madper Xie.
