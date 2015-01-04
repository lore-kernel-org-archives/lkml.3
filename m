Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbbADRwK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 12:52:10 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:50287 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbbADRwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 12:52:08 -0500
Message-ID: <54A97DC4.1030705@kernel.org>
Date: Sun, 04 Jan 2015 17:52:04 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: George McCollister <george.mccollister@gmail.com>, unlisted-recipients:;
CC: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:IIO SUBSYSTEM AND..." <linux-iio@vger.kernel.org>
Subject: Re: [PATCH 2/2] iio: Add nt133 I/O board support
References: <1417038344-3801-1-git-send-email-george.mccollister@gmail.com> <1417038344-3801-2-git-send-email-george.mccollister@gmail.com>
In-Reply-To: <1417038344-3801-2-git-send-email-george.mccollister@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/11/14 21:45, George McCollister wrote:
> The NovaTech 133 I/O board is an expansion card for the NovaTech
> OrionLXm with 16 digital input channels and 4 digital output channels.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
A few comments inline.

I understand where you are comming from but have concerns about both
the input and output channels.

For the input ones, we probably need to better handle logic level inputs
in general.  That probably means making the demux unit and other bits of
alignment specific code cope with the special case of a single bit.

For the output channels, this single pulse use case is interesting, but
any interface probably needs to be much more general.  Two options here come
to mind.

a) Do it on top of Lars-Peter's output buffer patches.
b) Use the approach used in some of the frequency drivers (probably needs
   rethinking as well) and add a new info_mask element that allows the number
   of repeat cycles to be limited.

Both are not simple I'm afraid.

Temporal varying outputs are something we don't yet have well covered!

Jonathan
> ---
>  drivers/iio/Kconfig           |   1 +
>  drivers/iio/Makefile          |   1 +
>  drivers/iio/waveform/Kconfig  |  14 ++
>  drivers/iio/waveform/Makefile |   5 +
>  drivers/iio/waveform/nt133.c  | 572 ++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 593 insertions(+)
>  create mode 100644 drivers/iio/waveform/Kconfig
>  create mode 100644 drivers/iio/waveform/Makefile
>  create mode 100644 drivers/iio/waveform/nt133.c
> 
> diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
> index 345395e..c0af707 100644
> --- a/drivers/iio/Kconfig
> +++ b/drivers/iio/Kconfig
> @@ -77,5 +77,6 @@ endif #IIO_TRIGGER
>  source "drivers/iio/pressure/Kconfig"
>  source "drivers/iio/proximity/Kconfig"
>  source "drivers/iio/temperature/Kconfig"
> +source "drivers/iio/waveform/Kconfig"
>  
>  endif # IIO
> diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
> index 698afc2..599e34e 100644
> --- a/drivers/iio/Makefile
> +++ b/drivers/iio/Makefile
> @@ -27,3 +27,4 @@ obj-y += pressure/
>  obj-y += proximity/
>  obj-y += temperature/
>  obj-y += trigger/
> +obj-y += waveform/
> diff --git a/drivers/iio/waveform/Kconfig b/drivers/iio/waveform/Kconfig
> new file mode 100644
> index 0000000..c97558d
> --- /dev/null
> +++ b/drivers/iio/waveform/Kconfig
> @@ -0,0 +1,14 @@
> +#
> +# Waveform drivers
> +#
> +menu "Waveform output"
> +
> +config NT133
> +	tristate "NovaTech 133 I/O board"
> +	select IIO_BUFFER
> +	select IIO_TRIGGERED_BUFFER
> +	depends on USB
> +	help
> +	  Say yes here to build support for NovaTech 133 I/O board.
> +
> +endmenu
> diff --git a/drivers/iio/waveform/Makefile b/drivers/iio/waveform/Makefile
> new file mode 100644
> index 0000000..d59887c
> --- /dev/null
> +++ b/drivers/iio/waveform/Makefile
> @@ -0,0 +1,5 @@
> +#
> +# Makefile for industrial I/O waveform drivers
> +#
> +
> +obj-$(CONFIG_NT133) += nt133.o
> diff --git a/drivers/iio/waveform/nt133.c b/drivers/iio/waveform/nt133.c
> new file mode 100644
> index 0000000..8fdf172
> --- /dev/null
> +++ b/drivers/iio/waveform/nt133.c
> @@ -0,0 +1,572 @@
> +/*
> + * NovaTech 133 I/O board driver
> + *
> + * Copyright 2014 NovaTech LLC.
> + *
> + * George McCollister <george.mccollister@gmail.com>
> + *
> + * Portions derivied from USB Skeleton driver - 2.2
> + *
> + * Licensed under the GPL-2.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/uaccess.h>
> +#include <linux/usb.h>
> +#include <linux/mutex.h>
> +#include <linux/iio/iio.h>
> +#include <linux/iio/sysfs.h>
> +#include <linux/iio/trigger.h>
> +#include <linux/iio/trigger_consumer.h>
> +#include <linux/iio/buffer.h>
> +#include <linux/iio/triggered_buffer.h>
> +
> +#define NT133_DRV_NAME		"nt133"
> +#define NT133_VENDOR_ID		0x2aeb
> +#define NT133_PRODUCT_ID	133
> +
> +#define NT133_USB_REQ_INPUT_STATUS	0x10
> +#define NT133_USB_REQ_OUTPUT_STATUS	0x11
> +#define NT133_USB_REQ_OUTPUT_CTRL	0x12
> +#define NT133_USB_REQ_OUTPUT_ENABLE	0x13
> +
> +/* table of devices that work with this driver */
> +static const struct usb_device_id nt133_table[] = {
> +	{ USB_DEVICE(NT133_VENDOR_ID, NT133_PRODUCT_ID) },
> +	{ }					/* Terminating entry */
> +};
> +MODULE_DEVICE_TABLE(usb, nt133_table);
> +
> +struct nt133_state {
> +	/* the usb device for this device */
> +	struct usb_device	*udev;
> +	/* the interface for this device */
> +	struct usb_interface	*interface;
> +	/* in case we need to retract our submissions */
> +	struct usb_anchor	submitted;
> +	/* the urb to read data with */
> +	struct urb		*int_in_urb;
> +	/* the buffer to receive data */
> +	__be16			int_in_data;
> +	/* the address of the int in endpoint */
> +	__u8			int_in_endpointAddr;
> +	/* synchronize I/O with disconnect */
> +	struct mutex		io_mutex;
> +	/* Interrupt end point poll interval */
> +	u8			bInterval;
> +	struct iio_trigger	*trig;
> +	u16			*buffer;
> +};
> +
> +#define NT133_IN_CHAN(idx) {					\
> +	.type = IIO_VOLTAGE,					\
> +	.indexed = 1,						\
> +	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),		\
> +	.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE),	\
> +	.channel = idx,						\
> +	.scan_index = idx,					\
> +	.scan_type = {						\
> +		.sign		= 'u',				\
> +		.realbits	= 1,				\
> +		.storagebits	= 16,				\
So we are using a voltage input for a logic signal.  I can sort of
see the argument (can easily provide info on the levels of that
signal) but I think we would be better off providing nice handling
of binary signals. Perhaps even add support to the core for single
bit buffer elements. That way, if we get a whole set of them, the
buffered storage will be as compact as possible.
Fiddly for the demux code I suppose, but not too bad.


> +	},							\
> +}
> +
> +#define NT133_OUT_CHAN(chan, chan2) {				\
> +	.type = IIO_WAVEFORM,					\
> +	.indexed = 1,						\
> +	.scan_index = -1,					\
> +	.output = 1,						\
> +	.modified = 1,						\
> +	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),		\
> +	.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE),	\
> +	.channel = chan,					\
> +	.channel2 = chan2,					\
> +	.scan_type = {						\
> +		.sign		= 'u',				\
> +		.realbits	= 29,				\
> +		.storagebits	= 32,				\
> +	},							\
> +}
I think this is way too restrictive.  If we are going to define a waveform
type, it would need to handle arbitary waveforms and come out of a buffer.

A fun exercise to think about, but firstly needs the buffered output patches
from Lars-Peter Clausen, then needs those to handle timing (don't think
they do currently).  So you'd have an element which says, at this time
set voltages to this.  That way your control here would be

time a - set high, time b - set low  -- or something like that.

What you have here is basically a controlled pulse output. Interesting
usecase, but if we define a new interface it will need to cope with
a lot more than that.

I'm dubious about introducing a 'single pulse' channel type.

We could perhaps introduce a pwm and have a 'cycles till disable'
type element?  That could always be set to 1 on this device.



> +
> +static const struct iio_chan_spec nt133_channels[] = {
> +	NT133_IN_CHAN(0),
> +	NT133_IN_CHAN(1),
> +	NT133_IN_CHAN(2),
> +	NT133_IN_CHAN(3),
> +	NT133_IN_CHAN(4),
> +	NT133_IN_CHAN(5),
> +	NT133_IN_CHAN(6),
> +	NT133_IN_CHAN(7),
> +	NT133_IN_CHAN(8),
> +	NT133_IN_CHAN(9),
> +	NT133_IN_CHAN(10),
> +	NT133_IN_CHAN(11),
> +	NT133_IN_CHAN(12),
> +	NT133_IN_CHAN(13),
> +	NT133_IN_CHAN(14),
> +	NT133_IN_CHAN(15),
> +	IIO_CHAN_SOFT_TIMESTAMP(16),
> +	NT133_OUT_CHAN(0, IIO_MOD_HIGHTIME),
> +	NT133_OUT_CHAN(0, IIO_MOD_LOWTIME),
> +	NT133_OUT_CHAN(1, IIO_MOD_HIGHTIME),
> +	NT133_OUT_CHAN(1, IIO_MOD_LOWTIME),
> +	NT133_OUT_CHAN(2, IIO_MOD_HIGHTIME),
> +	NT133_OUT_CHAN(2, IIO_MOD_LOWTIME),
> +	NT133_OUT_CHAN(3, IIO_MOD_HIGHTIME),
> +	NT133_OUT_CHAN(3, IIO_MOD_LOWTIME),
> +};
> +
> +
> +static void nt133_read_int_callback(struct urb *urb);
> +
> +static int nt133_do_read_io(struct nt133_state *st)
> +{
> +	int rv;
> +
> +	mutex_lock(&st->io_mutex);
> +	if (!st->interface) {
> +		mutex_unlock(&st->io_mutex);
> +		rv = -ENODEV;
> +		goto error;
> +	}
> +
> +	usb_fill_int_urb(st->int_in_urb,
> +			 st->udev,
> +			 usb_rcvintpipe(st->udev, st->int_in_endpointAddr),
> +			 &st->int_in_data,
> +			 sizeof(st->int_in_data),
> +			 nt133_read_int_callback,
> +			 st,
> +			 st->bInterval);
> +	usb_anchor_urb(st->int_in_urb, &st->submitted);
> +
> +	rv = usb_submit_urb(st->int_in_urb, GFP_KERNEL);
> +	mutex_unlock(&st->io_mutex);
> +	if (rv < 0) {
> +		usb_unanchor_urb(st->int_in_urb);
> +		dev_err(&st->interface->dev,
> +			"%s - failed submitting read urb, error %d\n",
> +			__func__, rv);
> +	}
> +error:
> +	return rv;
> +}
> +
> +static void nt133_read_int_callback(struct urb *urb)
> +{
> +	struct nt133_state *st;
> +
> +	st = urb->context;
> +
> +	dev_dbg(&st->interface->dev,
> +		"%s - urb status = %d, actual length = %d\n",
> +		__func__, urb->status, urb->actual_length);
> +
> +	if (urb->status) {
> +		if (!(urb->status == -ENOENT ||
> +		    urb->status == -ECONNRESET ||
> +		    urb->status == -ESHUTDOWN))
> +			dev_err(&st->interface->dev,
> +				"%s - nonzero write int status received: %d\n",
> +				__func__, urb->status);
> +		nt133_do_read_io(st);
> +	} else if (urb->actual_length == sizeof(st->int_in_data)) {
> +		iio_trigger_poll(st->trig);
> +	} else {
> +		dev_err(&st->interface->dev,
> +			"%s - unexpected size of %d\n",
> +			__func__, urb->actual_length);
> +		nt133_do_read_io(st);
> +	}
> +}
> +
> +static int nt133_read_raw(struct iio_dev *indio_dev,
> +			  struct iio_chan_spec const *chan,
> +			  int *val,
> +			  int *val2,
> +			  long m)
> +{
> +	struct nt133_state *st = iio_priv(indio_dev);
> +	int rv = -EINVAL;
> +	u16 inbits;
> +
> +	switch (m) {
> +	case IIO_CHAN_INFO_RAW:
> +		rv = usb_control_msg(st->udev,
> +				     usb_rcvctrlpipe(st->udev, 0),
> +				     NT133_USB_REQ_INPUT_STATUS,
> +				     USB_DIR_IN | USB_TYPE_VENDOR,
> +				     0,
> +				     0x0,
> +				     &inbits,
> +				     sizeof(inbits),
> +				     USB_CTRL_SET_TIMEOUT);
> +		if (rv < 0) {
> +			dev_err(&st->interface->dev,
> +				"%s - failed to get input status, error %d\n",
> +				__func__, rv);
> +		} else {
> +			*val = (int) (be16_to_cpu(inbits) >> chan->channel)
> +				      & 0x1;
> +			rv = IIO_VAL_INT;
> +		}
> +		break;
> +	case IIO_CHAN_INFO_SCALE:
> +		if (chan->type == IIO_VOLTAGE) {
> +			/* A raw value of 0 indicates 0VDC */
> +			/* A raw value of 1 indicates 90VDC */
> +			*val = 90000000UL;
> +			rv = IIO_VAL_INT;
> +		} else if (chan->type == IIO_WAVEFORM) {
> +			/* Scale raw time (milliseconds) to seconds */
> +			*val = 0;
> +			*val2 = 1000;
> +			rv = IIO_VAL_INT_PLUS_MICRO;
> +		}
> +		break;
> +	}
> +
> +	return rv;
> +}
> +
> +static int nt133_write_raw(struct iio_dev *indio_dev,
> +			   struct iio_chan_spec const *chan,
> +			   int val,
> +			   int val2,
> +			   long m)
> +{
> +	struct nt133_state *st = iio_priv(indio_dev);
> +	const int max_val = (1 << chan->scan_type.realbits);
> +	int rv;
> +	u16 direction;
> +	__be32 duration;
> +
> +	if (chan->channel2 == IIO_MOD_HIGHTIME)
> +		direction = 0x1;
> +	else if (chan->channel2 == IIO_MOD_LOWTIME)
> +		direction = 0x0;
> +	else
> +		return -EINVAL;
> +
> +	if (val >= max_val || val < 0)
> +		return -EINVAL;
> +
> +	/* Check if output is already in progress */
> +	rv = usb_control_msg(st->udev,
> +			     usb_rcvctrlpipe(st->udev, 0),
> +			     NT133_USB_REQ_OUTPUT_STATUS,
> +			     USB_DIR_IN | USB_TYPE_VENDOR,
> +			     0x0,
> +			     (u16)chan->channel,
> +			     &duration,
> +			     sizeof(duration),
> +			     USB_CTRL_SET_TIMEOUT);
> +	if (rv < 0) {
> +		dev_err(&st->interface->dev,
> +			"%s - failed to get output status, error %d\n",
> +			__func__, rv);
> +		return rv;
> +	}
> +
> +	if (be32_to_cpu(duration))
> +		return -EBUSY;
> +
> +	duration = cpu_to_be32((u32)val);
> +
> +	rv = usb_control_msg(st->udev,
> +			     usb_sndctrlpipe(st->udev, 0),
> +			     NT133_USB_REQ_OUTPUT_CTRL,
> +			     USB_DIR_OUT | USB_TYPE_VENDOR,
> +			     direction,
> +			     (u16)chan->channel,
> +			     &duration,
> +			     sizeof(duration),
> +			     USB_CTRL_SET_TIMEOUT);
> +	if (rv < 0)
> +		dev_err(&st->interface->dev,
> +			"%s - failed to control output, error %d\n",
> +			__func__, rv);
> +	return rv;
> +}
> +
> +static int nt133_enable_outputs(struct nt133_state *st)
> +{
> +	int rv;
> +
> +	rv = usb_control_msg(st->udev,
> +			     usb_sndctrlpipe(st->udev, 0),
> +			     NT133_USB_REQ_OUTPUT_ENABLE,
> +			     USB_DIR_OUT | USB_TYPE_VENDOR,
> +			     0x1, /*0=disabled, 1=enabled*/
> +			     0x0,
> +			     NULL,
> +			     0,
> +			     USB_CTRL_SET_TIMEOUT);
> +	if (rv < 0)
> +		dev_err(&st->interface->dev,
> +			"%s - failed to enable outputs, error %d\n",
> +			__func__, rv);
> +	return rv;
> +}
> +
> +static irqreturn_t nt133_trigger_handler(int irq, void *private)
> +{
> +	struct iio_poll_func *pf = private;
> +	struct iio_dev *indio_dev = pf->indio_dev;
> +	struct nt133_state *st = iio_priv(indio_dev);
> +	int i;
> +	int j = 0;
> +
> +	dev_dbg(&st->interface->dev,
> +		"%s - active_scan_mask=%d, masklength=%d\n",
> +		__func__, (int)indio_dev->active_scan_mask[0],
> +		indio_dev->masklength);
> +
> +	for_each_set_bit(i, indio_dev->active_scan_mask,
> +		indio_dev->masklength) {
> +		st->buffer[j++] = (u16)
> +				  (be16_to_cpu(st->int_in_data) >> i) & 0x1;
The core will do demux for you.  Just set available_scan_masks appropriately
and let it get on with it.
> +	}
> +
> +	iio_push_to_buffers_with_timestamp(indio_dev, st->buffer,
> +					   pf->timestamp);
> +	iio_trigger_notify_done(indio_dev->trig);
> +
> +	nt133_do_read_io(st);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int nt133_update_scan_mode(struct iio_dev *indio_dev,
> +				  const unsigned long *scan_mask)
> +{
> +	struct nt133_state *st = iio_priv(indio_dev);
> +
> +	dev_dbg(&st->interface->dev,
> +		"%s - scan_bytes=%d\n",
> +		__func__, indio_dev->scan_bytes);
> +
> +	kfree(st->buffer);
> +	st->buffer = kmalloc(indio_dev->scan_bytes, GFP_KERNEL);
> +	if (st->buffer == NULL)
> +		return -ENOMEM;
> +	return 0;
> +}
> +
> +static const struct iio_trigger_ops nt133_trigger_ops = {
> +	.owner = THIS_MODULE,
> +};
> +
> +static const struct iio_info nt133_info = {
> +	.driver_module = THIS_MODULE,
> +	.read_raw = nt133_read_raw,
> +	.write_raw = nt133_write_raw,
> +	.update_scan_mode = nt133_update_scan_mode,
> +};
> +
> +static int nt133_probe(struct usb_interface *interface,
> +		       const struct usb_device_id *id)
> +{
> +	struct iio_dev *indio_dev;
> +	struct iio_trigger *trig;
> +	struct nt133_state *st;
> +	struct usb_host_interface *iface_desc;
> +	struct usb_endpoint_descriptor *endpoint;
> +	int i;
> +	int retval = -ENOMEM;
> +
> +	/* allocate memory for our device state and initialize it */
> +	indio_dev = devm_iio_device_alloc(&interface->dev, sizeof(*st));
> +	if (!indio_dev) {
> +		dev_err(&interface->dev, "Out of memory\n");
> +		goto error_ret;
> +	}
> +
> +	st = iio_priv(indio_dev);
> +
> +	mutex_init(&st->io_mutex);
> +	init_usb_anchor(&st->submitted);
> +
> +	st->udev = usb_get_dev(interface_to_usbdev(interface));
> +	st->interface = interface;
> +
> +	/* set up the endpoint information */
> +	/* use only the first int-in endpoint */
> +	iface_desc = interface->cur_altsetting;
> +	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
> +		endpoint = &iface_desc->endpoint[i].desc;
> +
> +		if (!st->int_in_endpointAddr &&
> +		    usb_endpoint_is_int_in(endpoint)) {
> +			/* we found a int in endpoint */
> +			st->int_in_endpointAddr = endpoint->bEndpointAddress;
> +			st->int_in_urb = usb_alloc_urb(0, GFP_KERNEL);
> +			if (!st->int_in_urb) {
> +				dev_err(&interface->dev,
> +					"Couldn't allocate int_in_urb.\n");
> +				goto error_put_dev;
> +			}
> +			st->bInterval = endpoint->bInterval;
> +			break;
> +		}
> +	}
> +
> +	if (!(st->int_in_endpointAddr)) {
> +		dev_err(&interface->dev,
> +			"Couldn't find int-in endpoint.\n");
> +		goto error_put_dev;
> +	}
> +
> +	indio_dev->dev.parent = &interface->dev;
> +	indio_dev->name = NT133_DRV_NAME;
> +	indio_dev->channels = nt133_channels;
> +	indio_dev->num_channels = ARRAY_SIZE(nt133_channels);
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +	indio_dev->info = &nt133_info;
> +
> +	/* save our data pointer in this interface device */
> +	usb_set_intfdata(interface, indio_dev);
> +
> +	trig = devm_iio_trigger_alloc(&interface->dev, "%s-dev%d",
> +				      indio_dev->name, indio_dev->id);
> +	if (!trig)
> +		goto error_free_urb;
> +
> +	st->trig = trig;
> +	trig->dev.parent = indio_dev->dev.parent;
> +	iio_trigger_set_drvdata(trig, indio_dev);
> +	trig->ops = &nt133_trigger_ops;
> +
> +	retval = iio_trigger_register(trig);
> +	if (retval) {
> +		dev_err(&interface->dev, "Failed to register trigger.\n");
> +		goto error_free_urb;
> +	}
> +
> +	retval = iio_triggered_buffer_setup(indio_dev, &iio_pollfunc_store_time,
> +		&nt133_trigger_handler, NULL);
> +	if (retval) {
> +		dev_err(&interface->dev, "Failed to setup triggered buffer.\n");
> +		goto error_unregister_trigger;
> +	}
> +
> +	retval = iio_device_register(indio_dev);
> +	if (retval) {
> +		dev_err(&interface->dev, "Failed to regsiter device.\n");
> +		goto error_triggered_buffer_cleanup;
> +	}
> +
> +	retval = nt133_enable_outputs(st);
> +	if (retval)
> +		goto error_device_unregister;
> +
> +	retval = nt133_do_read_io(st);
> +	if (retval)
> +		goto error_device_unregister;
> +
> +	return 0;
> +
> +error_device_unregister:
> +	iio_device_unregister(indio_dev);
> +error_triggered_buffer_cleanup:
> +	iio_triggered_buffer_cleanup(indio_dev);
> +error_unregister_trigger:
> +	iio_trigger_unregister(st->trig);
> +error_free_urb:
> +	usb_free_urb(st->int_in_urb);
> +error_put_dev:
> +	usb_put_dev(st->udev);
> +error_ret:
> +	usb_set_intfdata(interface, NULL);
> +	return retval;
> +}
> +
> +static void nt133_disconnect(struct usb_interface *interface)
> +{
> +	struct iio_dev *indio_dev = usb_get_intfdata(interface);
> +	struct nt133_state *st = iio_priv(indio_dev);
> +
> +	usb_set_intfdata(interface, NULL);
> +
> +	/* prevent more I/O from starting */
> +	mutex_lock(&st->io_mutex);
> +	st->interface = NULL;
> +	mutex_unlock(&st->io_mutex);
> +
> +	usb_kill_anchored_urbs(&st->submitted);
> +
> +	iio_device_unregister(indio_dev);
> +
> +	iio_triggered_buffer_cleanup(indio_dev);
> +
> +	iio_trigger_unregister(st->trig);
> +
> +	usb_free_urb(st->int_in_urb);
> +	usb_put_dev(st->udev);
> +
> +	dev_info(&interface->dev, "nt133 now disconnected");
> +}
> +
> +static void nt133_draw_down(struct nt133_state *st)
> +{
> +	int time;
> +
> +	time = usb_wait_anchor_empty_timeout(&st->submitted, 1000);
> +	if (!time)
> +		usb_kill_anchored_urbs(&st->submitted);
> +	usb_kill_urb(st->int_in_urb);
> +}
> +
> +static int nt133_suspend(struct usb_interface *intf, pm_message_t message)
> +{
> +	struct nt133_state *st = usb_get_intfdata(intf);
> +
> +	if (!st)
> +		return 0;
> +	nt133_draw_down(st);
> +	return 0;
> +}
> +
> +static int nt133_resume(struct usb_interface *intf)
> +{
> +	return 0;
> +}
> +
> +static int nt133_pre_reset(struct usb_interface *intf)
> +{
> +	struct nt133_state *st = usb_get_intfdata(intf);
> +
> +	mutex_lock(&st->io_mutex);
> +	nt133_draw_down(st);
> +
> +	return 0;
> +}
> +
> +static int nt133_post_reset(struct usb_interface *intf)
> +{
> +	struct nt133_state *st = usb_get_intfdata(intf);
> +
> +	/* we are sure no URBs are active - no locking needed */
> +	mutex_unlock(&st->io_mutex);
> +
> +	return 0;
> +}
> +
> +static struct usb_driver nt133_driver = {
> +	.name =		NT133_DRV_NAME,
> +	.probe =	nt133_probe,
> +	.disconnect =	nt133_disconnect,
> +	.suspend =	nt133_suspend,
> +	.resume =	nt133_resume,
> +	.pre_reset =	nt133_pre_reset,
> +	.post_reset =	nt133_post_reset,
> +	.id_table =	nt133_table,
> +};
> +
> +module_usb_driver(nt133_driver);
> +
> +MODULE_LICENSE("GPL");
> 

