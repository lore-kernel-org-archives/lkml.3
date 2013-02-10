Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760994Ab3BJD0A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 22:26:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:15354 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760959Ab3BJDZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 22:25:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,636,1355126400"; 
   d="scan'208";a="289150505"
Date: Sun, 10 Feb 2013 04:25:55 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tomas Winkler <tomas.winkler@intel.com>, arnd@arndb.de,
        linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 01/11 V2] mei: bus: Initial MEI bus type
 implementation
Message-ID: <20130210032555.GG20996@sortiz-mobl>
References: <1360326504-17041-1-git-send-email-tomas.winkler@intel.com>
 <1360326504-17041-2-git-send-email-tomas.winkler@intel.com>
 <20130208235341.GA24127@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130208235341.GA24127@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Fri, Feb 08, 2013 at 03:53:41PM -0800, Greg KH wrote:
> > +Example
> > +=======
> > +As a theoretical example let's pretend the ME comes with a "contact" NFC IP.
> > +The driver init and exit routines for this device would look like:
> > +
> > +#define CONTACT_DRIVER_NAME "contact"
> > +
> > +#define NFC_UUID UUID_LE(0x0bb17a78, 0x2a8e, 0x4c50, 0x94, \
> > +			       0xd4, 0x50, 0x26, 0x67, 0x23, 0x77, 0x5c)
> > +
> > +static struct mei_bus_driver contact_driver = {
> > +	.driver = {
> > +		   .name = CONTAC_DRIVER_NAME,
> > +		  },
> 
> Can't you put a name field in your mei_bus_driver structure and then
> copy it to the version in the driver model?  That's what other bus
> drivers do and it makes more sense.
Sure.

 
> > +	.id = {
> > +		.name = CONTACT_DRIVER_NAME,
> > +		.uuid = NFC_UUID,
> > +	},
> 
> Drivers usually only have a pointer to a list of device ids, specific to
> their bus type.  Don't force them to be listed in this manner, otherwise
> you can not do automatic module loading (through the MODULE_DEVICE()
> macro.)
I'll do that, yes.


> 
> > +
> > +	.probe = contact_probe,
> > +	.remove = contact_remove,
> > +};
> > +
> > +static int contact_init(void)
> > +{
> > +	int r;
> > +
> > +	pr_debug(DRIVER_DESC ": %s\n", __func__);
> 
> Don't encourage people to write "noisy" kernel modules please, this
> doesn't need to be here.
Ok, will fix.


> > +
> > +	r = mei_add_driver(&contact_driver);
> > +	if (r) {
> > +		pr_err(CONTACT_DRIVER_NAME ": driver registration failed\n");
> > +		return r;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static void __exit contact_exit(void)
> > +{
> > +	mei_del_driver(&contact_driver);
> > +}
> > +
> > +module_init(contact_init);
> > +module_exit(contact_exit);
> > +
> > +And the driver's simplified probe routine would look like that:
> > +
> > +int contact_probe(struct mei_bus_client *client)
> 
> Please pass back the id that the device is being matched on, to give the
> driver a chance to do something with any specific values it needs to.
> 
> Again, like other busses (PCI and USB).
Makes sense, I'll do that.


> > --- /dev/null
> > +++ b/drivers/misc/mei/bus.c
> > @@ -0,0 +1,155 @@
> > +/*
> > + * Intel Management Engine Interface (Intel MEI) Linux driver
> > + * Copyright (c) 2012, Intel Corporation.
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms and conditions of the GNU General Public License,
> > + * version 2, as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope it will be useful, but WITHOUT
> > + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> > + * more details.
> > + *
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/device.h>
> > +#include <linux/kernel.h>
> > +#include <linux/init.h>
> > +#include <linux/errno.h>
> > +#include <linux/slab.h>
> > +#include <linux/mutex.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/pci.h>
> > +#include <linux/mei_bus.h>
> > +
> > +#include "mei_dev.h"
> > +#include "bus.h"
> 
> Why create bus.h?  Why not just put it all in mei_dev.h?
I was trying not to pollute mei_dev.h too much, but I'll rm bus.h and put the
whole bus API into mei_dev.h.

 
> > +static int mei_device_match(struct device *dev, struct device_driver *drv)
> > +{
> > +	struct mei_bus_client *client = to_mei_client(dev);
> > +	struct mei_bus_driver *driver;
> > +
> > +	if (!client)
> > +		return 0;
> > +
> > +	driver = to_mei_driver(drv);
> > +
> > +	return !uuid_le_cmp(client->uuid, driver->id.uuid) &&
> > +		!strcmp(client->name, driver->id.name);
> > +}
> > +
> > +static int mei_device_probe(struct device *dev)
> > +{
> > +	struct mei_bus_client *client = to_mei_client(dev);
> > +	struct mei_bus_driver *driver;
> > +	int status;
> > +
> > +	if (!client)
> > +		return 0;
> > +
> > +	driver = to_mei_driver(dev->driver);
> > +	if (!driver->probe)
> > +		return -ENODEV;
> > +
> > +	client->driver = driver;
> > +	dev_dbg(dev, "probe\n");
> > +
> > +	status = driver->probe(client);
> > +	if (status)
> > +		client->driver = NULL;
> > +
> > +	return status;
> > +}
> > +
> > +static int mei_device_remove(struct device *dev)
> > +{
> > +	struct mei_bus_client *client = to_mei_client(dev);
> > +	struct mei_bus_driver *driver;
> > +	int status;
> > +
> > +	if (!client || !dev->driver)
> > +		return 0;
> > +
> > +	driver = to_mei_driver(dev->driver);
> > +	if (!driver->remove) {
> > +		dev->driver = NULL;
> > +		client->driver = NULL;
> > +
> > +		return 0;
> > +	}
> > +
> > +	status = driver->remove(client);
> > +	if (!status)
> > +		client->driver = NULL;
> > +
> > +	return status;
> > +}
> > +
> > +static void mei_device_shutdown(struct device *dev)
> > +{
> > +	return;
> > +}
> 
> If you don't do anything here, no need to provide it at all.
I'll remove it.

 
> > +struct bus_type mei_bus_type = {
> > +	.name		= "mei",
> > +	.match		= mei_device_match,
> > +	.probe		= mei_device_probe,
> > +	.remove		= mei_device_remove,
> > +	.shutdown	= mei_device_shutdown,
> > +};
> > +EXPORT_SYMBOL(mei_bus_type);
> 
> Why is this exported?
It shouldn't, I'll fix that.


> And please, EXPORT_SYMBOL_GPL() for new functions that are busses using
> the driver model.
Sure.


> > +static void mei_client_dev_release(struct device *dev)
> > +{
> > +	kfree(to_mei_client(dev));
> > +}
> > +
> > +static struct device_type mei_client_type = {
> > +	.release	= mei_client_dev_release,
> > +};
> 
> Thank you for getting this right, it makes me happy.
> 
> > +struct mei_bus_client *mei_add_device(struct mei_device *mei_dev,
> > +				      uuid_le uuid, char *name)
> > +{
> > +	struct mei_bus_client *client;
> > +	int status;
> > +
> > +	client = kzalloc(sizeof(struct mei_bus_client), GFP_KERNEL);
> > +	if (!client)
> > +		return NULL;
> > +
> > +	client->mei_dev = mei_dev;
> > +	client->uuid = uuid;
> > +	strlcpy(client->name, name, sizeof(client->name));
> > +
> > +	client->dev.parent = &client->mei_dev->pdev->dev;
> > +	client->dev.bus = &mei_bus_type;
> > +	client->dev.type = &mei_client_type;
> > +
> > +	dev_set_name(&client->dev, "%s", client->name);
> > +
> > +	status = device_register(&client->dev);
> > +	if (status)
> > +		goto out_err;
> > +
> > +	dev_dbg(&client->dev, "client %s registered\n", client->name);
> > +
> > +	return client;
> > +
> > +out_err:
> > +	dev_err(client->dev.parent, "Failed to register MEI client\n");
> > +
> > +	kfree(client);
> > +
> > +	return NULL;
> > +}
> > +EXPORT_SYMBOL(mei_add_device);
> 
> EXPORT_SYMBOL_GPL() please.
> 
> > +void mei_remove_device(struct mei_bus_client *client)
> > +{
> > +	device_unregister(&client->dev);
> > +}
> > +EXPORT_SYMBOL(mei_remove_device);
> 
> _GPL() please.
> 
> 
> > --- /dev/null
> > +++ b/drivers/misc/mei/bus.h
> > @@ -0,0 +1,27 @@
> > +/*
> > + *
> > + * Intel Management Engine Interface (Intel MEI) Linux driver
> > + * Copyright (c) 2003-2012, Intel Corporation.
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms and conditions of the GNU General Public License,
> > + * version 2, as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope it will be useful, but WITHOUT
> > + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> > + * more details.
> > + *
> > + */
> > +
> > +#ifndef _MEI_BUS_H_
> > +#define _MEI_BUS_H_
> > +
> > +#define to_mei_driver(d) container_of(d, struct mei_bus_driver, driver)
> > +#define to_mei_client(d) container_of(d, struct mei_bus_client, dev)
> 
> Why are these in this file and not just in bus.c?
Yep, I'll put them there.


> > +
> > +struct mei_bus_client *mei_add_device(struct mei_device *mei_dev,
> > +					uuid_le uuid, char *name);
> > +void mei_remove_device(struct mei_bus_client *client);
> 
> These should go in mei_dev.h
> 
> 
> > +
> > +#endif /* _MEI_BUS_H_ */
> > diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
> > index cb80166..ce19b26 100644
> > --- a/drivers/misc/mei/mei_dev.h
> > +++ b/drivers/misc/mei/mei_dev.h
> > @@ -21,6 +21,7 @@
> >  #include <linux/watchdog.h>
> >  #include <linux/poll.h>
> >  #include <linux/mei.h>
> > +#include <linux/mei_bus.h>
> >  
> >  #include "hw.h"
> >  #include "hw-me-regs.h"
> > @@ -264,6 +265,29 @@ struct mei_hw_ops {
> >  };
> >  
> >  /**
> > + * mei_bus_client
> 
> I don't really understand this structure, please explain it better.
This is a structure that links the MEI bus client pointer passed to the driver
with the actual ME client. It also allows the ME driver to implement
technology specific ME protocol through the send/recv hooks.

 
> > + *
> > + * @uuid: me client uuid
> > + * @name: client symbolic name
> > + * @me_dev: mei device
> > + * @cl: mei client
> > + * @driver: mei bus driver for this client
> > + * @dev: linux driver model device pointer
> > + * @priv_data: client private data
> > + */
> > +struct mei_bus_client {
> > +	uuid_le uuid;
> > +	char name[MEI_NAME_SIZE];
> 
> This isn't needed, use the struct device name instead.
Yes, will fix.

> > +	struct mei_device *mei_dev;
> 
> What is this for?
Not needed, I'll remove it.


> > +	struct mei_cl *cl;
> > +	struct mei_bus_driver *driver;
> 
> Why is this needed?
It shouldn't be there, I'll remove it as well.


> > +	struct device dev;
> > +
> > +	void *priv_data;
> 
> Why is this needed?  What's wrong with the one build into 'struct
> device'?
The latter is used by drivers registered on the MEI bus through the
mei_bus_ge/sett_clientdata routines. The former is for technology specific
parts of the ME driver to retrieve their private data.
For example the NFC specific part of the ME driver will get IO requests from
mei_bus_client pointers. The priv_data field from these pointers will give
this part of the code their private structure back.



> > +struct mei_bus_driver {
> > +	struct device_driver driver;
> 
> Add a:
> 	char *name;
> field here please.
Yes, I'll ad it.


> > +
> > +	struct mei_id id;
> 
> This should be a list of ids, NULL terminated.
Yes, will do as well.

Thanks a lot for the comments, I'll send a v3 soon.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
