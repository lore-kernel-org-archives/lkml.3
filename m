Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab3LWRhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 12:37:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757409Ab3LWRhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 12:37:35 -0500
Message-ID: <1387820241.30327.105.camel@bling.home>
Subject: Re: How should dev_[gs]et_drvdata be used? (was: Re: [PATCH] i2c:
 i801: fix memleak on probe error)
From: Alex Williamson <alex.williamson@redhat.com>
To: Peter Wu <lekensteyn@gmail.com>
Cc: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 23 Dec 2013 10:37:21 -0700
In-Reply-To: <2690400.fFjCFlrrIR@al>
References: <20130123174204.00463f98@endymion.delvare>
	 <4657870.yOE66qJqIC@al> <52B815A0.1060609@fold.natur.cuni.cz>
	 <2690400.fFjCFlrrIR@al>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-23 at 16:49 +0100, Peter Wu wrote:
> On Monday 23 December 2013 11:51:12 Martin Mokrejs wrote:
> > Thanks for the note, was just compiling a new 3.10.24 kernel to test it.
> > ;-)
> > 
> > So far just booted an old 3.9 kernel and after plugging in an external
> > USB3 drive I got the message, just to be sure I am still able to reproduce
> > the error and that I have the right .config in the running kernel.
> > 
> > Will wait for another fix instead.
> > Martin
> 
> There is still one thing I do not fully understand, how should
> dev_set_drvdata and dev_get_drvdata be used? For the devices passed
> to probe functions, the core takes care of setting to NULL on error.
> Then device_unregister frees the memory, right?
> 
> Now, what if the dev_set_drvdata (or aliases such as pci_set_drvdata,
> i2c_set_adapinfo, etc.) are manually called outside probe functions?
> Or inside the probe function, but not for the device that is being
> probed (such as is the case with the i801 i2c driver)?
> 
> The VFIO driver also does something odd, it clears the driver data,
> but the device holding it is freed using kfree():
> 
>     static void vfio_device_release(struct kref *kref) {
>         struct vfio_device *device = container_of(kref,
>                                                   struct vfio_device, kref);
>         struct vfio_group *group = device->group;
> 
>         list_del(&device->group_next);
>         mutex_unlock(&group->device_lock);
> 
>         dev_set_drvdata(device->dev, NULL);
> 
>         kfree(device);
> 
> Is a memory leak also present here since dev_set_drvdata() always tries to
> allocate memory?

But it doesn't:

int dev_set_drvdata(struct device *dev, void *data)
{
        int error;

        if (!dev->p) {
                error = device_private_init(dev);
                if (error)
                        return error;
        }
        dev->p->driver_data = data;
        return 0;
}

Also, the code referenced is kfree'ing a struct vfio_device, not the
struct device.  VFIO uses the drvdata to provide a back pointer to the
vfio specific structure, which also includes a pointer to the struct
device.  We obviously want to clear drvdata when the vfio specific
structure is being released.  Thanks,

Alex

