Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947431Ab3BHXxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 18:53:45 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:57211 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947361Ab3BHXxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 18:53:44 -0500
Date: Fri, 8 Feb 2013 15:53:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: sameo@linux.intel.com, arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 01/11 V2] mei: bus: Initial MEI bus type
 implementation
Message-ID: <20130208235341.GA24127@kroah.com>
References: <1360326504-17041-1-git-send-email-tomas.winkler@intel.com>
 <1360326504-17041-2-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360326504-17041-2-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 02:28:14PM +0200, Tomas Winkler wrote:
> From: Samuel Ortiz <sameo@linux.intel.com>
> 
> mei bus will present some of the me clients
> as devices for other standard subsystems
> 
> Implement the probe, remove, match and the device addtion routines.
> A mei-bus.txt document describing the rationale and the API usage
> is also added.
> 
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  Documentation/misc-devices/mei/mei-bus.txt |  137 ++++++++++++++++++++++++
>  drivers/misc/mei/Makefile                  |    1 +
>  drivers/misc/mei/bus.c                     |  155 ++++++++++++++++++++++++++++
>  drivers/misc/mei/bus.h                     |   27 +++++
>  drivers/misc/mei/mei_dev.h                 |   24 +++++
>  include/linux/mei_bus.h                    |   91 ++++++++++++++++
>  6 files changed, 435 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/misc-devices/mei/mei-bus.txt
>  create mode 100644 drivers/misc/mei/bus.c
>  create mode 100644 drivers/misc/mei/bus.h
>  create mode 100644 include/linux/mei_bus.h
> 
> diff --git a/Documentation/misc-devices/mei/mei-bus.txt b/Documentation/misc-devices/mei/mei-bus.txt
> new file mode 100644
> index 0000000..dac6239
> --- /dev/null
> +++ b/Documentation/misc-devices/mei/mei-bus.txt
> @@ -0,0 +1,137 @@
> +Intel(R) Management Engine (ME) bus API
> +=======================================
> +
> +
> +Rationale
> +=========
> +While a misc character device is useful for applications to send and receive
> +data to the many IP blocks found in Intel's ME, kernel drivers rely on the
> +device model to be probed.
> +By adding a kernel virtual bus abstraction on top of the MEI driver we can
> +implement drivers for the various MEI features as standalone ones, found in
> +their respective subsystem. Existing drivers can even potentially be re-used
> +by adding an MEI bus layer to the existing code.
> +
> +
> +MEI bus API
> +===========
> +A driver implementation for an MEI IP block is very similar to existing bus
> +based device drivers. The driver registers itself as an MEI bus driver through
> +the mei_bus_driver structure:
> +
> +struct mei_bus_driver {
> +	struct device_driver driver;
> +
> +	struct mei_id id;
> +
> +	int (*probe)(struct mei_bus_client *client);
> +	int (*remove)(struct mei_bus_client *client);
> +};
> +
> +struct mei_id {
> +	char name[MEI_NAME_SIZE];
> +	uuid_le uuid;
> +};
> +
> +The mei_id structure allows the driver to bind itself against an ME UUID and a
> +device name. There typically is one ME UUID per technology and the mei_id name
> +field matches a specific device name within that technology. As an example,
> +the ME supports several NFC devices: All of them have the same ME UUID but the
> +ME bus code will assign each of them a different name.
> +
> +To actually register a driver on the ME bus one must call the mei_add_driver()
> +API. This is typically called at module init time.
> +
> +Once registered on the ME bus, a driver will typically try to do some I/O on
> +this bus and this should be done through the mei_bus_send() and mei_bus_recv()
> +routines. The latter is synchronous (blocks and sleeps until data shows up).
> +In order for drivers to be notified of pending events waiting for them (e.g.
> +an Rx event) they can register an event handler through the
> +mei_bus_register_event_cb() routine. Currently only the MEI_BUS_EVENT_RX event
> +will trigger an event handler call and the driver implementation is supposed
> +to call mei_bus_recv() from the event handler in order to fetch the pending
> +received buffers.
> +
> +
> +Example
> +=======
> +As a theoretical example let's pretend the ME comes with a "contact" NFC IP.
> +The driver init and exit routines for this device would look like:
> +
> +#define CONTACT_DRIVER_NAME "contact"
> +
> +#define NFC_UUID UUID_LE(0x0bb17a78, 0x2a8e, 0x4c50, 0x94, \
> +			       0xd4, 0x50, 0x26, 0x67, 0x23, 0x77, 0x5c)
> +
> +static struct mei_bus_driver contact_driver = {
> +	.driver = {
> +		   .name = CONTAC_DRIVER_NAME,
> +		  },

Can't you put a name field in your mei_bus_driver structure and then
copy it to the version in the driver model?  That's what other bus
drivers do and it makes more sense.

> +	.id = {
> +		.name = CONTACT_DRIVER_NAME,
> +		.uuid = NFC_UUID,
> +	},

Drivers usually only have a pointer to a list of device ids, specific to
their bus type.  Don't force them to be listed in this manner, otherwise
you can not do automatic module loading (through the MODULE_DEVICE()
macro.)


> +
> +	.probe = contact_probe,
> +	.remove = contact_remove,
> +};
> +
> +static int contact_init(void)
> +{
> +	int r;
> +
> +	pr_debug(DRIVER_DESC ": %s\n", __func__);

Don't encourage people to write "noisy" kernel modules please, this
doesn't need to be here.

> +
> +	r = mei_add_driver(&contact_driver);
> +	if (r) {
> +		pr_err(CONTACT_DRIVER_NAME ": driver registration failed\n");
> +		return r;
> +	}
> +
> +	return 0;
> +}
> +
> +static void __exit contact_exit(void)
> +{
> +	mei_del_driver(&contact_driver);
> +}
> +
> +module_init(contact_init);
> +module_exit(contact_exit);
> +
> +And the driver's simplified probe routine would look like that:
> +
> +int contact_probe(struct mei_bus_client *client)

Please pass back the id that the device is being matched on, to give the
driver a chance to do something with any specific values it needs to.

Again, like other busses (PCI and USB).

> --- /dev/null
> +++ b/drivers/misc/mei/bus.c
> @@ -0,0 +1,155 @@
> +/*
> + * Intel Management Engine Interface (Intel MEI) Linux driver
> + * Copyright (c) 2012, Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/errno.h>
> +#include <linux/slab.h>
> +#include <linux/mutex.h>
> +#include <linux/interrupt.h>
> +#include <linux/pci.h>
> +#include <linux/mei_bus.h>
> +
> +#include "mei_dev.h"
> +#include "bus.h"

Why create bus.h?  Why not just put it all in mei_dev.h?

> +static int mei_device_match(struct device *dev, struct device_driver *drv)
> +{
> +	struct mei_bus_client *client = to_mei_client(dev);
> +	struct mei_bus_driver *driver;
> +
> +	if (!client)
> +		return 0;
> +
> +	driver = to_mei_driver(drv);
> +
> +	return !uuid_le_cmp(client->uuid, driver->id.uuid) &&
> +		!strcmp(client->name, driver->id.name);
> +}
> +
> +static int mei_device_probe(struct device *dev)
> +{
> +	struct mei_bus_client *client = to_mei_client(dev);
> +	struct mei_bus_driver *driver;
> +	int status;
> +
> +	if (!client)
> +		return 0;
> +
> +	driver = to_mei_driver(dev->driver);
> +	if (!driver->probe)
> +		return -ENODEV;
> +
> +	client->driver = driver;
> +	dev_dbg(dev, "probe\n");
> +
> +	status = driver->probe(client);
> +	if (status)
> +		client->driver = NULL;
> +
> +	return status;
> +}
> +
> +static int mei_device_remove(struct device *dev)
> +{
> +	struct mei_bus_client *client = to_mei_client(dev);
> +	struct mei_bus_driver *driver;
> +	int status;
> +
> +	if (!client || !dev->driver)
> +		return 0;
> +
> +	driver = to_mei_driver(dev->driver);
> +	if (!driver->remove) {
> +		dev->driver = NULL;
> +		client->driver = NULL;
> +
> +		return 0;
> +	}
> +
> +	status = driver->remove(client);
> +	if (!status)
> +		client->driver = NULL;
> +
> +	return status;
> +}
> +
> +static void mei_device_shutdown(struct device *dev)
> +{
> +	return;
> +}

If you don't do anything here, no need to provide it at all.

> +struct bus_type mei_bus_type = {
> +	.name		= "mei",
> +	.match		= mei_device_match,
> +	.probe		= mei_device_probe,
> +	.remove		= mei_device_remove,
> +	.shutdown	= mei_device_shutdown,
> +};
> +EXPORT_SYMBOL(mei_bus_type);

Why is this exported?

And please, EXPORT_SYMBOL_GPL() for new functions that are busses using
the driver model.

> +static void mei_client_dev_release(struct device *dev)
> +{
> +	kfree(to_mei_client(dev));
> +}
> +
> +static struct device_type mei_client_type = {
> +	.release	= mei_client_dev_release,
> +};

Thank you for getting this right, it makes me happy.

> +struct mei_bus_client *mei_add_device(struct mei_device *mei_dev,
> +				      uuid_le uuid, char *name)
> +{
> +	struct mei_bus_client *client;
> +	int status;
> +
> +	client = kzalloc(sizeof(struct mei_bus_client), GFP_KERNEL);
> +	if (!client)
> +		return NULL;
> +
> +	client->mei_dev = mei_dev;
> +	client->uuid = uuid;
> +	strlcpy(client->name, name, sizeof(client->name));
> +
> +	client->dev.parent = &client->mei_dev->pdev->dev;
> +	client->dev.bus = &mei_bus_type;
> +	client->dev.type = &mei_client_type;
> +
> +	dev_set_name(&client->dev, "%s", client->name);
> +
> +	status = device_register(&client->dev);
> +	if (status)
> +		goto out_err;
> +
> +	dev_dbg(&client->dev, "client %s registered\n", client->name);
> +
> +	return client;
> +
> +out_err:
> +	dev_err(client->dev.parent, "Failed to register MEI client\n");
> +
> +	kfree(client);
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL(mei_add_device);

EXPORT_SYMBOL_GPL() please.

> +void mei_remove_device(struct mei_bus_client *client)
> +{
> +	device_unregister(&client->dev);
> +}
> +EXPORT_SYMBOL(mei_remove_device);

_GPL() please.


> --- /dev/null
> +++ b/drivers/misc/mei/bus.h
> @@ -0,0 +1,27 @@
> +/*
> + *
> + * Intel Management Engine Interface (Intel MEI) Linux driver
> + * Copyright (c) 2003-2012, Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + */
> +
> +#ifndef _MEI_BUS_H_
> +#define _MEI_BUS_H_
> +
> +#define to_mei_driver(d) container_of(d, struct mei_bus_driver, driver)
> +#define to_mei_client(d) container_of(d, struct mei_bus_client, dev)

Why are these in this file and not just in bus.c?

> +
> +struct mei_bus_client *mei_add_device(struct mei_device *mei_dev,
> +					uuid_le uuid, char *name);
> +void mei_remove_device(struct mei_bus_client *client);

These should go in mei_dev.h


> +
> +#endif /* _MEI_BUS_H_ */
> diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
> index cb80166..ce19b26 100644
> --- a/drivers/misc/mei/mei_dev.h
> +++ b/drivers/misc/mei/mei_dev.h
> @@ -21,6 +21,7 @@
>  #include <linux/watchdog.h>
>  #include <linux/poll.h>
>  #include <linux/mei.h>
> +#include <linux/mei_bus.h>
>  
>  #include "hw.h"
>  #include "hw-me-regs.h"
> @@ -264,6 +265,29 @@ struct mei_hw_ops {
>  };
>  
>  /**
> + * mei_bus_client

I don't really understand this structure, please explain it better.

> + *
> + * @uuid: me client uuid
> + * @name: client symbolic name
> + * @me_dev: mei device
> + * @cl: mei client
> + * @driver: mei bus driver for this client
> + * @dev: linux driver model device pointer
> + * @priv_data: client private data
> + */
> +struct mei_bus_client {
> +	uuid_le uuid;
> +	char name[MEI_NAME_SIZE];

This isn't needed, use the struct device name instead.

> +	struct mei_device *mei_dev;

What is this for?

> +	struct mei_cl *cl;
> +	struct mei_bus_driver *driver;

Why is this needed?

> +	struct device dev;
> +
> +	void *priv_data;

Why is this needed?  What's wrong with the one build into 'struct
device'?

> +struct mei_bus_driver {
> +	struct device_driver driver;

Add a:
	char *name;
field here please.

> +
> +	struct mei_id id;

This should be a list of ids, NULL terminated.

thanks,

greg k-h
