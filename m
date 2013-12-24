Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836Ab3LXASK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 19:18:10 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:42139 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932821Ab3LXASI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 19:18:08 -0500
From: Peter Wu <lekensteyn@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: How should dev_[gs]et_drvdata be used?
Date: Tue, 24 Dec 2013 01:18:03 +0100
Message-ID: <1716344.EUMSGCAAKK@al>
User-Agent: KMail/4.12 (Linux/3.13.0-rc4-custom-00257-gae3253e; KDE/4.12.0; x86_64; ; )
In-Reply-To: <1387820241.30327.105.camel@bling.home>
References: <20130123174204.00463f98@endymion.delvare> <2690400.fFjCFlrrIR@al> <1387820241.30327.105.camel@bling.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 December 2013 10:37:21 Alex Williamson wrote:
> On Mon, 2013-12-23 at 16:49 +0100, Peter Wu wrote:
[..]
> > 
> > There is still one thing I do not fully understand, how should
> > dev_set_drvdata and dev_get_drvdata be used? For the devices passed
> > to probe functions, the core takes care of setting to NULL on error.
> > Then device_unregister frees the memory, right?
> > 
> > Now, what if the dev_set_drvdata (or aliases such as pci_set_drvdata,
> > i2c_set_adapinfo, etc.) are manually called outside probe functions?
> > Or inside the probe function, but not for the device that is being
> > probed (such as is the case with the i801 i2c driver)?
> > 
> > The VFIO driver also does something odd, it clears the driver data,
> > but the device holding it is freed using kfree():
> > 
> >     static void vfio_device_release(struct kref *kref) {
> >         struct vfio_device *device = container_of(kref,
> >                                                   struct vfio_device, kref);
> >         struct vfio_group *group = device->group;
> > 
> >         list_del(&device->group_next);
> >         mutex_unlock(&group->device_lock);
> > 
> >         dev_set_drvdata(device->dev, NULL);
> > 
> >         kfree(device);
> > 
> > Is a memory leak also present here since dev_set_drvdata() always tries to
> > allocate memory?
> 
> But it doesn't:
> 
> int dev_set_drvdata(struct device *dev, void *data)
> {
>         int error;
> 
>         if (!dev->p) {
>                 error = device_private_init(dev);
>                 if (error)
>                         return error;
>         }
>         dev->p->driver_data = data;
>         return 0;
> }

It does:

int device_private_init(struct device *dev)
{
        dev->p = kzalloc(sizeof(*dev->p), GFP_KERNEL);
        if (!dev->p)
                return -ENOMEM;
        dev->p->device = dev; 
        klist_init(&dev->p->klist_children, klist_children_get,
                   klist_children_put);
        INIT_LIST_HEAD(&dev->p->deferred_probe);
        return 0;
}

and if it doesn't, then I must be missing something in this non-obvious
code. I scanned the interwebs and Documentation/, but could not really
find a great example on how this is supposed to work. The dev_set_drvdata
function existed since Linus moved to git.

> Also, the code referenced is kfree'ing a struct vfio_device, not the
> struct device.  VFIO uses the drvdata to provide a back pointer to the
> vfio specific structure, which also includes a pointer to the struct
> device.  We obviously want to clear drvdata when the vfio specific
> structure is being released.

Ah, I see. "device->dev" is not freed, but "device". And the data is
cleared for "device->dev". Thanks for correcting.

Clear examples of how to use dev_{s,g}et_drvdata correctly in i2c is
still wanted. I stepped in it yesterday, i2c seems to have its own
way to register new devices. More specifically, how can the memory
associated with dev_set_drvdata be free'd on error paths if the
device is not registered with device_register (as is done in the
probe function of the i801 i2c driver)?

Regards,
Peter

