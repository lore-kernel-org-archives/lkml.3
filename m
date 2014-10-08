Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbaJHJ0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:26:42 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:65420 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbaJHJ0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 05:26:39 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 8 Oct 2014 11:23:47 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org,
        arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v6 1/4] mfd: add support for Diolan DLN-2 devices
Message-ID: <20141008092347.GB1990@localhost>
References: <1411661254-5204-1-git-send-email-octavian.purdila@intel.com>
 <1411661254-5204-2-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411661254-5204-2-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 07:07:31PM +0300, Octavian Purdila wrote:

> +static void dln2_rx_transfer(struct dln2_dev *dln2, struct urb *urb,
> +			     u16 handle, u16 rx_slot)
> +{
> +	struct dln2_mod_rx_slots *rxs = &dln2->mod_rx_slots[handle];
> +	struct dln2_rx_context *rxc;
> +	struct device *dev = &dln2->interface->dev;
> +
> +	spin_lock(&rxs->lock);

You must use spin_lock_irqsave here as you call it from the completion
handler.

> +
> +	rxc = &rxs->slots[rx_slot];
> +
> +	if (rxc->in_use && !rxc->urb) {
> +		rxc->urb = urb;
> +		complete(&rxc->done);
> +		/* URB will be resubmitted in free_rx_slot */
> +	} else {
> +		dev_warn(dev, "bad/late response %d/%d\n", handle, rx_slot);
> +		dln2_submit_urb(dln2, urb, GFP_ATOMIC);
> +	}
> +
> +	spin_unlock(&rxs->lock);
> +}

> +static int _dln2_transfer(struct dln2_dev *dln2, u16 handle, u16 cmd,
> +			  const void *obuf, unsigned obuf_len,
> +			  void *ibuf, unsigned *ibuf_len)
> +{
> +	int ret = 0;
> +	u16 result;
> +	int rx_slot;
> +	struct dln2_response *rsp;
> +	struct dln2_rx_context *rxc;
> +	struct device *dev;
> +	const int timeout = DLN2_USB_TIMEOUT * HZ / 1000;
> +	struct dln2_mod_rx_slots *rxs = &dln2->mod_rx_slots[handle];
> +
> +	spin_lock(&dln2->disconnect_lock);

How did you test this version? You never initialise disconnect_lock so
lockdep complains loudly when calling _dln2_transfer during probe.

> +	if (!dln2->disconnect)
> +		dln2->active_transfers++;
> +	else
> +		ret = -ENODEV;
> +	spin_unlock(&dln2->disconnect_lock);
> +
> +	if (ret)
> +		return ret;
> +
> +	rx_slot = alloc_rx_slot(dln2, handle);
> +	if (rx_slot < 0) {
> +		ret = rx_slot;
> +		goto out_decr;
> +	}
> +
> +	dev = &dln2->interface->dev;
> +
> +	ret = dln2_send_wait(dln2, handle, cmd, rx_slot, obuf, obuf_len);
> +	if (ret < 0) {
> +		dev_err(dev, "USB write failed: %d\n", ret);
> +		goto out_free_rx_slot;
> +	}
> +
> +	rxc = &rxs->slots[rx_slot];
> +
> +	ret = wait_for_completion_interruptible_timeout(&rxc->done, timeout);
> +	if (ret <= 0) {
> +		if (!ret)
> +			ret = -ETIMEDOUT;
> +		goto out_free_rx_slot;
> +	}
> +
> +	if (!rxc->urb) {
> +		ret = -ENODEV;
> +		goto out_free_rx_slot;
> +	}
> +
> +	/* if we got here we know that the response header has been checked */
> +	rsp = rxc->urb->transfer_buffer;
> +
> +	if (rsp->hdr.size < sizeof(*rsp)) {
> +		ret = -EPROTO;
> +		goto out_free_rx_slot;
> +	}
> +
> +	result = le16_to_cpu(rsp->result);
> +	if (result) {
> +		dev_dbg(dev, "%d received response with error %d\n",
> +			handle, result);
> +		ret = -EREMOTEIO;
> +		goto out_free_rx_slot;
> +	}
> +
> +	if (!ibuf) {
> +		ret = 0;
> +		goto out_free_rx_slot;
> +	}
> +
> +	if (*ibuf_len > rsp->hdr.size - sizeof(*rsp))
> +		*ibuf_len = rsp->hdr.size - sizeof(*rsp);
> +
> +	memcpy(ibuf, rsp + 1, *ibuf_len);
> +
> +out_free_rx_slot:
> +	free_rx_slot(dln2, handle, rx_slot);
> +out_decr:
> +	spin_lock(&dln2->disconnect_lock);
> +	dln2->active_transfers--;
> +	spin_unlock(&dln2->disconnect_lock);
> +	if (dln2->disconnect)
> +		wake_up(&dln2->disconnect_wq);
> +
> +	return ret;
> +}

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

Just stick to spin_lock in this function.

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
> +	int id;
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
> +	INIT_LIST_HEAD(&dln2->event_cb_list);

The disconnect_lock is never initialised, as mentioned above.

> +
> +	ret = dln2_setup_rx_urbs(dln2, hostif);
> +	if (ret) {
> +		dln2_free(dln2);
> +		return ret;
> +	}
> +
> +	ret = dln2_hw_init(dln2);
> +	if (ret < 0) {
> +		dev_err(dev, "failed to initialize hardware\n");
> +		goto out_cleanup;
> +	}
> +
> +	id = dln2->usb_dev->bus->busnum << 8 | dln2->usb_dev->devnum;
> +	ret = mfd_add_devices(dev, id, dln2_devs, ARRAY_SIZE(dln2_devs),
> +			      NULL, 0, NULL);
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
> +	.name = "usb-dln2",

Just call the usb driver "dln2". 

> +	.probe = dln2_probe,
> +	.disconnect = dln2_disconnect,
> +	.id_table = dln2_table,
> +};

Johan
