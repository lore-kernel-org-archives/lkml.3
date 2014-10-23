Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbaJWPTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:19:54 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:52863 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbaJWPTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:19:47 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Thu, 23 Oct 2014 17:16:43 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org,
        arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v8 1/4] mfd: add support for Diolan DLN-2 devices
Message-ID: <20141023151643.GA7270@localhost>
References: <1413384491-23703-1-git-send-email-octavian.purdila@intel.com>
 <1413384491-23703-2-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413384491-23703-2-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 05:48:08PM +0300, Octavian Purdila wrote:

Here's some late feedback due to travels. You managed to get two updates
in there so commenting on the diff from v6.

> +struct dln2_event_cb_entry {
> +	struct list_head list;
> +	u16 id;
> +	struct platform_device *pdev;
> +	dln2_event_cb_t callback;
> +};
> +
> +int dln2_register_event_cb(struct platform_device *pdev, u16 id,
> +			   dln2_event_cb_t rx_cb)
> +{
> +	struct dln2_dev *dln2 = dev_get_drvdata(pdev->dev.parent);
> +	struct dln2_event_cb_entry *i, *new_cb;

Can you use a name which does not have the same suffix as the actual
callback function (i.e. "_cb"). Just call it "entry" or something.

> +	unsigned long flags;
> +	int ret = 0;
> +
> +	new_cb = kmalloc(sizeof(*new_cb), GFP_KERNEL);

Use kzalloc here.

> +	if (!new_cb)
> +		return -ENOMEM;
> +
> +	new_cb->id = id;
> +	new_cb->callback = rx_cb;
> +	new_cb->pdev = pdev;
> +
> +	spin_lock_irqsave(&dln2->event_cb_lock, flags);
> +
> +	list_for_each_entry(i, &dln2->event_cb_list, list) {
> +		if (i->id == id) {
> +			ret = -EBUSY;
> +			break;
> +		}
> +	}
> +
> +	if (!ret)
> +		list_add_rcu(&new_cb->list, &dln2->event_cb_list);
> +
> +	spin_unlock_irqrestore(&dln2->event_cb_lock, flags);
> +
> +	if (ret)
> +		kfree(new_cb);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(dln2_register_event_cb);
> +
> +void dln2_unregister_event_cb(struct platform_device *pdev, u16 id)
> +{
> +	struct dln2_dev *dln2 = dev_get_drvdata(pdev->dev.parent);
> +	struct dln2_event_cb_entry *i;
> +	unsigned long flags;
> +	bool found = false;
> +
> +	spin_lock_irqsave(&dln2->event_cb_lock, flags);
> +
> +	list_for_each_entry(i, &dln2->event_cb_list, list) {
> +		if (i->id == id) {
> +			list_del_rcu(&i->list);
> +			found = true;
> +			break;
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&dln2->event_cb_lock, flags);
> +
> +	if (found) {
> +		synchronize_rcu();
> +		kfree(i);
> +	}
> +}
> +EXPORT_SYMBOL(dln2_unregister_event_cb);
> +

Please add a comment describing the return value (i.e. when the urb had
been saved and shouldn't be resubmitted).

Also could rename this helper so it doesn't appear to be a variant of
dln2_transfer (e.g. something with "complete" in the name).

> +static bool dln2_rx_transfer(struct dln2_dev *dln2, struct urb *urb,
> +			     u16 handle, u16 rx_slot)
> +{
> +	struct dln2_mod_rx_slots *rxs = &dln2->mod_rx_slots[handle];
> +	struct dln2_rx_context *rxc;
> +	bool ret = false;
> +
> +	rxc = &rxs->slots[rx_slot];
> +
> +	/*
> +	 * No need to disable interrupts as this lock is not taken in
> +	 * interrupt context elsewhere in this driver and this
> +	 * function (or its callers) are not exported to other
> +	 * modules.

Why do you break comment lines already at 70 chars?

> +	 */
> +	spin_lock(&rxs->lock);
> +	if (rxc->in_use && !rxc->urb) {
> +		rxc->urb = urb;
> +		complete(&rxc->done);
> +		ret = true;
> +	}
> +	spin_unlock(&rxs->lock);
> +
> +	return ret;
> +}
> +
> +static void dln2_run_event_callbacks(struct dln2_dev *dln2, u16 id, u16 echo,
> +				     void *data, int len)
> +{
> +	struct dln2_event_cb_entry *i;
> +
> +	rcu_read_lock();
> +
> +	list_for_each_entry_rcu(i, &dln2->event_cb_list, list)
> +		if (i->id == id)
> +			i->callback(i->pdev, echo, data, len);
> +
> +	rcu_read_unlock();
> +}
> +
> +static void dln2_rx(struct urb *urb)
> +{
> +	struct dln2_dev *dln2 = urb->context;
> +	struct dln2_header *hdr = urb->transfer_buffer;
> +	struct device *dev = &dln2->interface->dev;
> +	u16 id, echo, handle, size;
> +	u8 *data;
> +	int len;
> +	int err;
> +
> +	switch (urb->status) {
> +	case 0:
> +		/* success */
> +		break;
> +	case -ECONNRESET:
> +	case -ENOENT:
> +	case -ESHUTDOWN:
> +	case -EPIPE:
> +		/* this urb is terminated, clean up */
> +		dev_dbg(dev, "urb shutting down with status %d\n", urb->status);
> +		return;
> +	default:
> +		dev_dbg(dev, "nonzero urb status received %d\n", urb->status);
> +		goto out;
> +	}
> +
> +	if (urb->actual_length < sizeof(struct dln2_header)) {
> +		dev_err(dev, "short response: %d\n", urb->actual_length);
> +		goto out;
> +	}
> +
> +	handle = le16_to_cpu(hdr->handle);
> +	id = le16_to_cpu(hdr->id);
> +	echo = le16_to_cpu(hdr->echo);
> +	size = le16_to_cpu(hdr->size);
> +
> +	if (size != urb->actual_length) {
> +		dev_err(dev, "size mismatch: handle %x cmd %x echo %x size %d actual %d\n",
> +			handle, id, echo, size, urb->actual_length);
> +		goto out;
> +	}
> +
> +	if (handle >= DLN2_HANDLES) {
> +		dev_warn(dev, "RX: invalid handle %d\n", handle);
> +		goto out;
> +	}
> +
> +	data = urb->transfer_buffer + sizeof(struct dln2_header);
> +	len = urb->actual_length - sizeof(struct dln2_header);
> +
> +	if (handle == DLN2_HANDLE_EVENT) {
> +		dln2_run_event_callbacks(dln2, id, echo, data, len);
> +	} else {
> +		/* URB will be re-submitted in free_rx_slot */

Refer to _dln2_transfer (the only place where free_rx_slot is used) as
well.

> +		if (dln2_rx_transfer(dln2, urb, handle, echo))
> +			return;
> +		dev_warn(dev, "bad/late response %d/%d\n", handle, echo);

Move this message back to the helper.

> +	}
> +
> +out:
> +	err = usb_submit_urb(urb, GFP_ATOMIC);
> +	if (err < 0)
> +		dev_err(dev, "failed to resubmit RX URB: %d\n", err);
> +}
> +

[...]

> +static int dln2_setup_rx_urbs(struct dln2_dev *dln2,
> +			      struct usb_host_interface *hostif)
> +{
> +	int i;
> +	const int rx_max_size = DLN2_RX_BUF_SIZE;
> +
> +	for (i = 0; i < DLN2_MAX_URBS; i++) {
> +		int ret;
> +		struct device *dev = &dln2->interface->dev;

Move these out of the loop.

> +
> +		dln2->rx_buf[i] = kmalloc(rx_max_size, GFP_KERNEL);
> +		if (!dln2->rx_buf[i])
> +			return -ENOMEM;
> +
> +		dln2->rx_urb[i] = usb_alloc_urb(0, GFP_KERNEL);
> +		if (!dln2->rx_urb[i])
> +			return -ENOMEM;
> +
> +		usb_fill_bulk_urb(dln2->rx_urb[i], dln2->usb_dev,
> +				  usb_rcvbulkpipe(dln2->usb_dev, dln2->ep_in),
> +				  dln2->rx_buf[i], rx_max_size, dln2_rx, dln2);
> +
> +		ret = usb_submit_urb(dln2->rx_urb[i], GFP_KERNEL);
> +		if (ret < 0) {
> +			dev_err(dev, "failed to submit RX URB: %d\n", ret);
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static struct dln2_platform_data dln2_pdata_gpio = {
> +	.handle = DLN2_HANDLE_GPIO,
> +};
> +
> +/* Only one I2C port seems to be supported on current hardware */
> +static struct dln2_platform_data dln2_pdata_i2c = {
> +	.handle = DLN2_HANDLE_I2C,
> +	.port = 0,
> +};
> +
> +static const struct mfd_cell dln2_devs[] = {
> +	{
> +		.name = "dln2-gpio",
> +		.platform_data = &dln2_pdata_gpio,
> +		.pdata_size = sizeof(struct dln2_platform_data),
> +	},
> +	{
> +		.name = "dln2-i2c",
> +		.platform_data = &dln2_pdata_i2c,
> +		.pdata_size = sizeof(struct dln2_platform_data),
> +	},
> +};
> +
> +static void dln2_disconnect(struct usb_interface *interface)
> +{
> +	struct dln2_dev *dln2 = usb_get_intfdata(interface);
> +	int i, j;
> +
> +	/* don't allow starting new transfers */
> +	spin_lock(&dln2->disconnect_lock);
> +	dln2->disconnect = true;
> +	spin_unlock(&dln2->disconnect_lock);
> +
> +	/* cancel in progress transfers */
> +	for (i = 0; i < DLN2_HANDLES; i++) {
> +		struct dln2_mod_rx_slots *rxs = &dln2->mod_rx_slots[i];
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&rxs->lock, flags);
> +
> +		/* cancel all response waiters */
> +		for (j = 0; j < DLN2_MAX_RX_SLOTS; j++) {
> +			struct dln2_rx_context *rxc = &rxs->slots[j];
> +
> +			if (rxc->in_use)
> +				complete(&rxc->done);
> +		}
> +
> +		spin_unlock_irqrestore(&rxs->lock, flags);
> +	}
> +
> +	/* wait for transfers to end */
> +	wait_event(dln2->disconnect_wq, !dln2->active_transfers);
> +
> +	mfd_remove_devices(&interface->dev);
> +
> +	dln2_free(dln2);
> +}
> +
> +static int dln2_probe(struct usb_interface *interface,
> +		      const struct usb_device_id *usb_id)
> +{
> +	struct usb_host_interface *hostif = interface->cur_altsetting;
> +	struct device *dev = &interface->dev;
> +	struct dln2_dev *dln2;
> +	int ret;
> +	int i, j;
> +
> +	if (hostif->desc.bInterfaceNumber != 0 ||
> +	    hostif->desc.bNumEndpoints < 2)
> +		return -ENODEV;
> +
> +	dln2 = kzalloc(sizeof(*dln2), GFP_KERNEL);
> +	if (!dln2)
> +		return -ENOMEM;
> +
> +	dln2->ep_out = hostif->endpoint[0].desc.bEndpointAddress;
> +	dln2->ep_in = hostif->endpoint[1].desc.bEndpointAddress;
> +	dln2->usb_dev = usb_get_dev(interface_to_usbdev(interface));
> +	dln2->interface = interface;
> +	usb_set_intfdata(interface, dln2);
> +	init_waitqueue_head(&dln2->disconnect_wq);
> +
> +	for (i = 0; i < DLN2_HANDLES; i++) {
> +		init_waitqueue_head(&dln2->mod_rx_slots[i].wq);
> +		spin_lock_init(&dln2->mod_rx_slots[i].lock);
> +		for (j = 0; j < DLN2_MAX_RX_SLOTS; j++)
> +			init_completion(&dln2->mod_rx_slots[i].slots[j].done);
> +	}
> +
> +	spin_lock_init(&dln2->event_cb_lock);
> +	spin_lock_init(&dln2->disconnect_lock);
> +	INIT_LIST_HEAD(&dln2->event_cb_list);
> +
> +	ret = dln2_setup_rx_urbs(dln2, hostif);
> +	if (ret)
> +		goto out_cleanup;
> +
> +	ret = dln2_hw_init(dln2);
> +	if (ret < 0) {
> +		dev_err(dev, "failed to initialize hardware\n");
> +		goto out_cleanup;
> +	}
> +
> +	ret = mfd_add_hotplug_devices(dev, dln2_devs, ARRAY_SIZE(dln2_devs));

So this now depends on 15bb4d6e8534 ("mfd: core: Add helper function to
register hotplug devices") in the MFD tree.

Please mention what tree the patch is against in your cover letter (I
noticed you had rebased when it no longer applied to 3.17).

You should drop the gpiolib patch now that v3.18-rc1 is out as well.

> +	if (ret != 0) {
> +		dev_err(dev, "failed to add mfd devices to core\n");
> +		goto out_cleanup;
> +	}
> +
> +	return 0;
> +
> +out_cleanup:
> +	dln2_free(dln2);
> +
> +	return ret;
> +}
> +
> +static const struct usb_device_id dln2_table[] = {
> +	{ USB_DEVICE(0xa257, 0x2013) },
> +	{ }
> +};
> +
> +MODULE_DEVICE_TABLE(usb, dln2_table);
> +
> +static struct usb_driver dln2_driver = {
> +	.name = "dln2",
> +	.probe = dln2_probe,
> +	.disconnect = dln2_disconnect,
> +	.id_table = dln2_table,
> +};
> +
> +module_usb_driver(dln2_driver);
> +
> +MODULE_AUTHOR("Octavian Purdila <octavian.purdila@intel.com>");
> +MODULE_DESCRIPTION("Core driver for the Diolan DLN2 interface adapter");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/mfd/dln2.h b/include/linux/mfd/dln2.h
> new file mode 100644
> index 0000000..57ddc58
> --- /dev/null
> +++ b/include/linux/mfd/dln2.h
> @@ -0,0 +1,69 @@
> +#ifndef __LINUX_USB_DLN2_H
> +#define __LINUX_USB_DLN2_H
> +
> +#define DLN2_CMD(cmd, id)		((cmd) | ((id) << 8))
> +
> +struct dln2_platform_data {
> +	u16 handle;		/* sub-driver handle (internally used only) */
> +	u8 port;		/* I2C/SPI port */
> +};
> +
> +/**
> + * dln2_event_cb_t - event callback function signature
> + *
> + * @pdev - the sub-device that registered this callback
> + * @echo - the echo header field received in the message
> + * @data - the data payload
> + * @len  - the data payload length
> + *
> + * The callback function is called in interrupt context and the data
> + * payload is only valid during the call. If the user needs later
> + * access of the data, it must copy it.
> + */
> +
> +typedef void (*dln2_event_cb_t)(struct platform_device *pdev, u16 echo,
> +				const void *data, int len);
> +
> +/**
> + * dl2n_register_event_cb - register a callback function for an event
> + *
> + * @pdev - the sub-device that registers the callback
> + * @event - the event for which to register a callback
> + * @event_cb - the callback function
> + *
> + * @return 0 in case of success, negative value in case of error
> + */
> +int dln2_register_event_cb(struct platform_device *pdev, u16 event,
> +			   dln2_event_cb_t event_cb);
> +
> +/**
> + * dln2_unregister_event_cb - unregister the callback function for an event
> + *
> + * @pdev - the sub-device that registered the callback
> + * @event - the event for which to register a callback
> + */
> +void dln2_unregister_event_cb(struct platform_device *pdev, u16 event);
> +
> +/**
> + * dln2_transfer - issue a DLN2 command and wait for a response and
> + * the associated data
> + *
> + * @pdev - the sub-device which is issuing this transfer
> + * @cmd - the command to be sent to the device
> + * @obuf - the buffer to be sent to the device; it can be NULL if the
> + *	user doesn't need to transmit data with this command
> + * @obuf_len - the size of the buffer to be sent to the device
> + * @ibuf - any data associated with the response will be copied here;
> + *	it can be NULL if the user doesn't need the response data
> + * @ibuf_len - must be initialized to the input buffer size; it will
> + *	be modified to indicate the actual data transfered;
> + * @result - pointer to store the result code received from hardware;
> + *	it can be NULL if the user doesn't need the result code
> + *
> + * @return 0 for success, negative value for errors
> + */
> +int dln2_transfer(struct platform_device *pdev, u16 cmd,
> +		  const void *obuf, unsigned obuf_len,
> +		  void *ibuf, unsigned *ibuf_len, u16 *result);

Why add yet another parameter for the result and then never even use it?
Please remove it. You can add a new function for it (and a wrapper)
later if it's ever needed.

You should also consider adding a convenience function for when you
don't care about any returned data (e.g. dln2_transfer_tx) so you don't
have to pass all those NULLs (most calls currently have three NULL
params).

> +
> +#endif

Johan
