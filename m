Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbaHFUSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 16:18:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49534 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754316AbaHFUSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 16:18:39 -0400
Date: Wed, 6 Aug 2014 16:18:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sergey Klyaus <Sergey.Klyaus@Tune-IT.Ru>
cc: Oliver Neukum <oneukum@suse.de>, <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] driver core: fix race with userland in device_add()
In-Reply-To: <53E2681D.3020508@Tune-IT.Ru>
Message-ID: <Pine.LNX.4.44L0.1408061610520.1145-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2014, Sergey Klyaus wrote:

> Hello.
> 
> I wrote a patch that fixes the problem that described above, here are a 
> patch for 3.16.0+ kernel (cloned from GitHub today). Maybe that "if 
> (MAJOR(dev->devt)) " part has to go even after BUS_NOTIFY_ADD_DEVICE abd 
> KOBJ_ADD? I put it before it, because there is no rollback code in 
> device_add() for that part.

I think this is fine.  However, I suspect the order of the other calls
there isn't totally right.  For instance, the

	if (parent)
		klist_add_tail(&dev->p->knode_parent,
			       &parent->p->klist_children);

part should probably be the first thing after we know the routine can't 
abort.

I guess the time when bus_probe_device() gets called doesn't matter 
much, because the driver might not even be loaded at this point.  But 
what about all the dev->class stuff at the end of device_add()?  Should 
that happen before any uevents are sent out?

Greg, have you looked at this?

Alan Stern

> Here are a patch:
> 
> bus_add_device() should be called before devtmpfs_create_node(), so when 
> userland application opens device from devtmpfs, it wouldn't get ENODEV 
> from kernel, because device_add() wasn't completed.
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 20da3ad..cc84ba8 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1019,18 +1029,6 @@ int device_add(struct device *dev)
>       if (error)
>           goto attrError;
> 
> -    if (MAJOR(dev->devt)) {
> -        error = device_create_file(dev, &dev_attr_dev);
> -        if (error)
> -            goto ueventattrError;
> -
> -        error = device_create_sys_dev_entry(dev);
> -        if (error)
> -            goto devtattrError;
> -
> -        devtmpfs_create_node(dev);
> -    }
> -
>       error = device_add_class_symlinks(dev);
>       if (error)
>           goto SymlinkError;
> @@ -1044,7 +1042,19 @@ int device_add(struct device *dev)
>       if (error)
>           goto DPMError;
>       device_pm_add(dev);
> -
> +
> +    if (MAJOR(dev->devt)) {
> +        error = device_create_file(dev, &dev_attr_dev);
> +        if (error)
> +            goto DevAttrError;
> +
> +        error = device_create_sys_dev_entry(dev);
> +        if (error)
> +            goto SysEntryError;
> +
> +        devtmpfs_create_node(dev);
> +    }
> +
>       /* Notify clients of device addition.  This call must come
>        * after dpm_sysfs_add() and before kobject_uevent().
>        */
> @@ -1074,6 +1084,12 @@ int device_add(struct device *dev)
>   done:
>       put_device(dev);
>       return error;
> + SysEntryError:
> +    if (MAJOR(dev->devt))
> +        device_remove_file(dev, &dev_attr_dev);
> + DevAttrError:
> +    device_pm_remove(dev);
> +    dpm_sysfs_remove(dev);
>    DPMError:
>       bus_remove_device(dev);
>    BusError:
> @@ -1081,14 +1097,6 @@ done:
>    AttrsError:
>       device_remove_class_symlinks(dev);
>    SymlinkError:
> -    if (MAJOR(dev->devt))
> -        devtmpfs_delete_node(dev);
> -    if (MAJOR(dev->devt))
> -        device_remove_sys_dev_entry(dev);
> - devtattrError:
> -    if (MAJOR(dev->devt))
> -        device_remove_file(dev, &dev_attr_dev);
> - ueventattrError:
>       device_remove_file(dev, &dev_attr_uevent);
>    attrError:
>       kobject_uevent(&dev->kobj, KOBJ_REMOVE);

