Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbaAHUdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:33:44 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:30729 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820AbaAHUdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:33:42 -0500
Date: Wed, 8 Jan 2014 21:33:30 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Wu <lekensteyn@gmail.com>
Subject: Re: Freeing of dev->p
Message-ID: <20140108213330.2efbc84c@endymion.delvare>
In-Reply-To: <20140108165628.GA15820@kroah.com>
References: <20140108164058.059cf461@endymion.delvare>
	<20140108165628.GA15820@kroah.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jan 2014 08:56:28 -0800, Greg Kroah-Hartman wrote:
> On Wed, Jan 08, 2014 at 04:40:58PM +0100, Jean Delvare wrote:
> > Hi Greg, hi all,
> > 
> > A memory leak has been reported to me:
> > http://marc.info/?l=linux-i2c&m=138779165123331&w=2
> > 
> > The leak is in i801_probe, caused by an early call to
> > i2c_set_adapdata() which in turn calls dev_set_drvdata() which
> > allocates some memory in device_private_init(). That memory is only
> > freed by the driver core when the i2c_adapter class device is removed.
> > But if the parent (PCI) device probing itself fails for whatever
> > reason, the class device never gets to be created, so it's never
> > removed, thus the memory is never freed.
> > 
> > It is not possible to move the call to i2c_set_adapdata() until after
> > the class device is created, because the data pointed is needed very
> > early after (almost during) i2c adapter creation. So I could make the
> > leak less likely to happen but I can't fix it completely.
> 
> I don't understand, what exactly is leaking?  You have control over your
> own structures, so can't you clean things up on the error path if you
> know something went wrong?

I do, but I can only care for memory I allocated myself, not the memory
allocated by the driver core.

> > I am wondering how this can be solved, and this brought three questions:
> > 
> > 1* What is the rationale for allocating dev->p dynamically? It is
> > allocated as soon as the device is created (in device_add), so as far
> > as I can see every device will need the allocation. Including struct
> > device_private in struct device would not cost more memory, plus it
> > would reduce memory fragmentation. So is this a lifetime issue? Or
> > something else I can't think of?
> 
> I did it to keep things that non-driver-core code should not be
> touching.  Previously, lots of people messed around with the device
> private fields that could confuse the driver core.  Ideally, I'd like to
> be able to move the kobject itself into this structure, to allow devices
> to handle static initialization better, but that never happened, unlike
> other driver core structures.
> 
> > 2* What is the rationale for making void *driver_data part of struct
> > device_private and not struct device itself?
> 
> To "hide" information / details that non-driver core code should not
> care about or touch.

This is a respectable goal, but I'm unsure it's worth the price...

> > 3* If the current implementation is considered correct, does it mean
> > that dev_set_drvdata() should never be used for class devices?
> 
> No, it should be fine, I don't understand the issue with your usage that
> is causing the problem, care to explain it better, or point me at some
> code?

Sorry I wasn't clear. Let me guide you step by step with the real-world
example that caused me to look into this. It all starts in
drivers/i2c/busses/i2c-i801.c, function i801_probe(). This is a driver
for a PCI device implementing an SMBus controller (aka i2c_adapter.)

static int i801_probe(struct pci_dev *dev, const struct pci_device_id *id)
{
	int err;
	struct i801_priv *priv;

	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
	if (!priv)
		return -ENOMEM;

	i2c_set_adapdata(&priv->adapter, priv);

So we allocate private data for the i2c_adapter we're about to create.
i2c_set_adapdata() is a wrapper around dev_set_drvdata() for class
devices of type i2c_adapter. If everything goes well, we would end up
doing:

	err = i2c_add_adapter(&priv->adapter);

and everything would be fine. However, there are a number of things
that can go wrong in between, for example if an ACPI resource conflict
is detected:

	err = acpi_check_resource_conflict(&dev->resource[SMBBAR]);
	if (err) {
		err = -ENODEV;
		goto exit;
	}

	(...)
exit:
	kfree(priv);
	return err;
}

As you can see, we properly free the memory we allocated ourselves for
the i2c_adapter's data on the error path. You'd think we're alright
then, but we're not. The problem is that i2c_set_adapdata() indirectly
allocated some memory:

static inline void i2c_set_adapdata(struct i2c_adapter *dev, void *data)
{
	dev_set_drvdata(&dev->dev, data);
}

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

int device_private_init(struct device *dev)
{
	dev->p = kzalloc(sizeof(*dev->p), GFP_KERNEL);
	(...)
}

In the success case, it's fine because the memory gets freed at device
release time in:

static void device_release(struct kobject *kobj)
{
	struct device *dev = kobj_to_dev(kobj);
	struct device_private *p = dev->p;

	(...)
	kfree(p);
}

However in the error case, device_release() will never get called, so
dev->p is leaked. This is what I am worried about.

I hope I was clear enough this time :) If not I'll try harder.

I consider allocating memory in dev_set_drvdata() very misleading, I
don't think we should keep doing that.

Thanks,
-- 
Jean Delvare
