Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab3EVUsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 16:48:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41703 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757133Ab3EVUsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 16:48:19 -0400
Date: Wed, 22 May 2013 13:48:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joern Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] mpt2sas/mpt3sas: prevent double free on error path
Message-Id: <20130522134817.7870812723bb720633c2b0b2@linux-foundation.org>
In-Reply-To: <1368132193-25817-3-git-send-email-joern@logfs.org>
References: <1368132193-25817-1-git-send-email-joern@logfs.org>
	<1368132193-25817-3-git-send-email-joern@logfs.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 May 2013 16:42:58 -0400 Joern Engel <joern@logfs.org> wrote:

> I noticed this one when list_del was called with poisoned list
> pointers, but the real problem is a double-free (and a use-after-free
> just before that).
> 
> Both _scsih_probe_boot_devices() and _scsih_sas_device_add() put the
> sas_device onto a list, thereby giving up control.  Next they call
> mpt2sas_transport_port_add() and will list_del and free the object on
> errors.  If some other function already did the list_del and free, it
> will happen again.
> 
> This patch adds reference counting to prevent the double free.  One
> reference count goes to the caller of mpt2sas_transport_port_add(), the
> second to the list.  Whoever removes the object from the list gets to
> drop one reference count.  _scsih_probe_boot_devices() and
> _scsih_sas_device_add() get a second reference count to ensure the
> object is not freed while they are still accessing it.
> 
> To prevent the double list_del(), I changed the code to list_del_init()
> and added a list_empty() check before that.  Since the
> list_empty/list_del_init is always called under a lock, this should be
> safe.
> 
> I hate the complexity this patch adds, but see no alternative to it.

It's regrettable that this bugfix is joined at the hip with a new
kernel feature.

> index 543d8d6..ceb7d41 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.h
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
> @@ -367,6 +367,7 @@ struct _sas_device {
>  	u16	slot;
>  	u8	phy;
>  	u8	responding;
> +	struct kref kref;
>  };
>  
>  /**
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index c6bdc92..217660c 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -570,6 +570,19 @@ _scsih_sas_device_find_by_handle(struct MPT2SAS_ADAPTER *ioc, u16 handle)
>  	return NULL;
>  }
>  
> +static void free_sas_device(struct kref *kref)
> +{
> +	struct _sas_device *sas_device = container_of(kref, struct _sas_device,
> +			kref);

yuk.  Easily fixed:

	struct _sas_device *sas_device;

	sas_device = container_of(kref, struct _sas_device, kref);


> +	kfree(sas_device);
> +}
> +
> +static void put_sas_device(struct _sas_device *sas_device)
> +{
> +	kref_put(&sas_device->kref, free_sas_device);
> +}
> +
>  /**
>   * _scsih_sas_device_remove - remove sas_device from list.
>   * @ioc: per adapter object
> @@ -583,14 +596,19 @@ _scsih_sas_device_remove(struct MPT2SAS_ADAPTER *ioc,
>      struct _sas_device *sas_device)
>  {
>  	unsigned long flags;
> +	int was_on_list = 0;
>  
>  	if (!sas_device)
>  		return;
>  
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -	list_del(&sas_device->list);
> -	kfree(sas_device);
> +	if (!list_empty(&sas_device->list)) {
> +		list_del_init(&sas_device->list);
> +		was_on_list = 1;
> +	}
>  	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> +	if (was_on_list)
> +		put_sas_device(sas_device);
>  }

This looks a bit awkward.

- list_del() on an empty list_head is acceptable, although
  inefficient when used in a high-frequency codepath (whcih this
  isn't).  So the code could be made simpler-looking.

- afaict put_sas_device() can be called from under that lock, so why
  bother with the was_on_list deferral thing?

- it's strange that this function can ever be called when the device
  is not on the list.  Perhaps somethnig else is screwy?


> @@ -612,6 +630,8 @@ _scsih_sas_device_add(struct MPT2SAS_ADAPTER *ioc,
>  	    "(0x%04x), sas_addr(0x%016llx)\n", ioc->name, __func__,
>  	    sas_device->handle, (unsigned long long)sas_device->sas_address));
>  
> +	/* Get an extra refcount... */

>From the annals of unuseful comments ;)

> +	kref_get(&sas_device->kref);
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
>  	list_add_tail(&sas_device->list, &ioc->sas_device_list);
>  	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> @@ -630,6 +650,12 @@ _scsih_sas_device_add(struct MPT2SAS_ADAPTER *ioc,
>  			sas_device->sas_address_parent);
>  		_scsih_sas_device_remove(ioc, sas_device);
>  	}
> +	/*
> +	 * ...and drop it again.  If an error already happend, this is the

"happened"

> +	 * final put and we free the object now.  Otherwise whoever removes
> +	 * the object from the list will do the final put and free.
> +	 */
> +	put_sas_device(sas_device);
>  }

But if this kref_get/put_sas_device pair were not here, this function's
_scsih_sas_device_remove() could free the device for us, if that
was_on_list oddity wasn't there.

Perhaps it would help to write down the refcounting rules.  "one for
the object, one for the presence of a list"?

>  /**
> @@ -5270,6 +5296,7 @@ _scsih_add_device(struct MPT2SAS_ADAPTER *ioc, u16 handle, u8 phy_num, u8 is_pd)
>  		return -1;
>  	}
>  
> +	kref_init(&sas_device->kref);
>  	sas_device->handle = handle;
>  	if (_scsih_get_sas_address(ioc, le16_to_cpu
>  		(sas_device_pg0.ParentDevHandle),
> @@ -5341,7 +5368,7 @@ _scsih_remove_device(struct MPT2SAS_ADAPTER *ioc,
>  	    "handle(0x%04x), sas_addr(0x%016llx)\n", ioc->name, __func__,
>  	    sas_device->handle, (unsigned long long)
>  	    sas_device->sas_address));
> -	kfree(sas_device);
> +	put_sas_device(sas_device);
>  }
>  /**
>   * _scsih_device_remove_by_handle - removing device object by handle
> @@ -5355,16 +5382,21 @@ _scsih_device_remove_by_handle(struct MPT2SAS_ADAPTER *ioc, u16 handle)
>  {
>  	struct _sas_device *sas_device;
>  	unsigned long flags;
> +	int was_on_list = 0;
>  
>  	if (ioc->shost_recovery)
>  		return;
>  
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
>  	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
> -	if (sas_device)
> -		list_del(&sas_device->list);
> +	if (sas_device) {
> +		if (!list_empty(&sas_device->list)) {
> +			list_del_init(&sas_device->list);
> +			was_on_list = 1;
> +		}
> +	}
>  	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -	if (sas_device)
> +	if (was_on_list)
>  		_scsih_remove_device(ioc, sas_device);
>  }

hm, duplication.  Should this call _scsih_sas_device_remove()?


> @@ -5381,6 +5413,7 @@ mpt2sas_device_remove_by_sas_address(struct MPT2SAS_ADAPTER *ioc,
>  {
>  	struct _sas_device *sas_device;
>  	unsigned long flags;
> +	int was_on_list = 0;
>  
>  	if (ioc->shost_recovery)
>  		return;
> @@ -5388,10 +5421,14 @@ mpt2sas_device_remove_by_sas_address(struct MPT2SAS_ADAPTER *ioc,
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
>  	sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
>  	    sas_address);
> -	if (sas_device)
> -		list_del(&sas_device->list);
> +	if (sas_device) {
> +		if (!list_empty(&sas_device->list)) {
> +			list_del_init(&sas_device->list);
> +			was_on_list = 1;
> +		}
> +	}
>  	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> -	if (sas_device)
> +	if (was_on_list)
>  		_scsih_remove_device(ioc, sas_device);
>  }

eek, there it is again!

> ...
>
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -569,6 +569,19 @@ _scsih_sas_device_find_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
>  	return NULL;
>  }
>  
> +static void free_sas_device(struct kref *kref)
> +{
> +	struct _sas_device *sas_device = container_of(kref, struct _sas_device,
> +			kref);

A ditto here.

> +	kfree(sas_device);
> +}
> +
> +static void put_sas_device(struct _sas_device *sas_device)
> +{
> +	kref_put(&sas_device->kref, free_sas_device);
> +}
> +
>  /**
>   * _scsih_sas_device_remove - remove sas_device from list.
>   * @ioc: per adapter object
> @@ -582,14 +595,19 @@ _scsih_sas_device_remove(struct MPT3SAS_ADAPTER *ioc,
>  	struct _sas_device *sas_device)
>  {
>  	unsigned long flags;
> +	int was_on_list = 0;
>  
>  	if (!sas_device)
>  		return;
>  
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -	list_del(&sas_device->list);
> -	kfree(sas_device);
> +	if (!list_empty(&sas_device->list)) {
> +		list_del_init(&sas_device->list);
> +		was_on_list = 1;
> +	}
>  	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> +	if (was_on_list)
> +		put_sas_device(sas_device);
>  }

etcetera.


I dunno, it all seems quite duplicative and awkward.  Is there
something exceptional about the problem space here, or is it that the
code is just screwed up and this fix doesn't really unscrew it?

