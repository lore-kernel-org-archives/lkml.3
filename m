Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111AbaIRLeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 07:34:18 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:49016 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906AbaIRLeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 07:34:15 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Thu, 18 Sep 2014 13:31:50 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org,
        arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v4 1/3] mfd: add support for Diolan DLN-2 devices
Message-ID: <20140918113150.GB2337@localhost>
References: <1410290686-6680-1-git-send-email-octavian.purdila@intel.com>
 <1410290686-6680-2-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410290686-6680-2-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 10:24:44PM +0300, Octavian Purdila wrote:

> +static int alloc_rx_slot(struct dln2_mod_rx_slots *rxs)
> +{
> +	int ret;
> +	int slot;
> +
> +	/* No need to timeout here, the wait is bounded by the timeout
> +	 * in _dln2_transfer
> +	 */
> +	ret = wait_event_interruptible(rxs->wq, find_free_slot(rxs, &slot));
> +	if (ret < 0)
> +		return ret;
> +
> +	return slot;
> +}
> +
> +static void free_rx_slot(struct dln2_dev *dln2, struct dln2_mod_rx_slots *rxs,
> +			 int slot)
> +{
> +	struct urb *urb = NULL;
> +	unsigned long flags;
> +	struct dln2_rx_context *rxc;
> +	struct device *dev = &dln2->interface->dev;
> +	int ret;
> +
> +	spin_lock_irqsave(&rxs->lock, flags);
> +
> +	clear_bit(slot, &rxs->bmap);
> +
> +	rxc = &rxs->slots[slot];
> +	rxc->connected = false;
> +	urb = rxc->urb;
> +	rxc->urb = NULL;
> +	reinit_completion(&rxc->done);
> +
> +	spin_unlock_irqrestore(&rxs->lock, flags);
> +
> +	if (urb)  {
> +		ret = usb_submit_urb(urb, GFP_KERNEL);
> +		if (ret < 0)
> +			dev_err(dev, "failed to re-submit RX URB: %d\n", ret);
> +	}
> +
> +	wake_up_interruptible(&rxs->wq);
> +}

> +static void dln2_rx_transfer(struct dln2_dev *dln2, struct urb *urb,
> +			     u16 handle, u16 rx_slot)
> +{
> +	struct dln2_mod_rx_slots *rxs = &dln2->mod_rx_slots[handle];
> +	struct dln2_rx_context *rxc;
> +	struct device *dev = &dln2->interface->dev;
> +	int err;
> +
> +	spin_lock(&rxs->lock);
> +	rxc = &rxs->slots[rx_slot];
> +	if (rxc->connected) {
> +		rxc->urb = urb;
> +		complete(&rxc->done);
> +	} else {
> +		dev_warn(dev, "dropping response %d/%d", handle, rx_slot);
> +		err = usb_submit_urb(urb, GFP_ATOMIC);
> +		if (err < 0)
> +			dev_err(dev, "failed to re-submit RX URB: %d\n", err);
> +	}
> +	spin_unlock(&rxs->lock);
> +}

> +static void dln2_rx(struct urb *urb)
> +{
> +	int err;
> +	struct dln2_dev *dln2 = urb->context;
> +	struct dln2_header *hdr = urb->transfer_buffer;
> +	struct device *dev = &dln2->interface->dev;
> +	u16 id, echo, handle, size;
> +	u8 *data;
> +	int len;
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
> +	if (handle >= DLN2_MAX_MODULES) {
> +		dev_warn(dev, "RX: invalid handle %d\n", handle);
> +		goto out;
> +	}
> +
> +	data = urb->transfer_buffer + sizeof(struct dln2_header);
> +	len = urb->actual_length - sizeof(struct dln2_header);
> +
> +	if (handle == DLN2_HANDLE_EVENT) {
> +		dln2_run_rx_callbacks(dln2, id, echo, data, len);
> +		err = usb_submit_urb(urb, GFP_ATOMIC);
> +		if (err < 0)
> +			goto out_submit_failed;
> +	} else {
> +		dln2_rx_transfer(dln2, urb, handle, echo);
> +	}
> +
> +	return;
> +
> +out:
> +	err = usb_submit_urb(urb, GFP_ATOMIC);
> +out_submit_failed:
> +	if (err < 0)
> +		dev_err(dev, "failed to re-submit RX URB: %d\n", err);
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
> +	struct device *dev = &dln2->interface->dev;
> +	const int timeout = DLN2_USB_TIMEOUT * HZ / 1000;
> +	struct dln2_mod_rx_slots *rxs = &dln2->mod_rx_slots[handle];
> +
> +	rx_slot = alloc_rx_slot(rxs);
> +	if (rx_slot < 0)
> +		return rx_slot;
> +
> +	ret = dln2_send_wait(dln2, handle, cmd, rx_slot, obuf, obuf_len);
> +	if (ret < 0) {
> +		free_rx_slot(dln2, rxs, rx_slot);
> +		dev_err(dev, "USB write failed: %d", ret);
> +		return ret;
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
> +	/* if we got here we know that the response header has been checked */
> +	rsp = rxc->urb->transfer_buffer;
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
> +	free_rx_slot(dln2, rxs, rx_slot);
> +
> +	return ret;
> +}
> +
> +int dln2_transfer(struct platform_device *pdev, u16 cmd,
> +		  const void *obuf, unsigned obuf_len,
> +		  void *ibuf, unsigned *ibuf_len)
> +{
> +	struct dln2_platform_data *dln2_pdata;
> +	struct dln2_dev *dln2;
> +	u16 h;
> +
> +	/* USB device has been disconnected, bail out */
> +	if (!pdev)
> +		return -ENODEV;

This isn't sufficient to prevent I/O after disconnect, or worse.

You set pdev to NULL in the platform device's remove callbacks, but you
have no synchronisation.

To take one example: in _dln2_transfer above you wait for completion,
but you never wake the process up in case the urb is killed due to a
disconnect. Hence you get a timeout much later, call free_rx_slot which
tries to send of another urb using potentially already freed data.

> +
> +	dln2 = dev_get_drvdata(pdev->dev.parent);
> +	dln2_pdata = dev_get_platdata(&pdev->dev);
> +	h = dln2_pdata->handle;
> +
> +	return _dln2_transfer(dln2, h, cmd, obuf, obuf_len, ibuf, ibuf_len);
> +}
> +EXPORT_SYMBOL(dln2_transfer);

> +static void dln2_free_rx_urbs(struct dln2_dev *dln2)
> +{
> +	int i;
> +
> +	for (i = 0; i < DLN2_MAX_URBS; i++) {
> +		usb_kill_urb(dln2->rx_urb[i]);
> +		usb_free_urb(dln2->rx_urb[i]);
> +		kfree(dln2->rx_buf[i]);
> +	}
> +}
> +
> +static void dln2_free(struct dln2_dev *dln2)
> +{
> +	dln2_free_rx_urbs(dln2);
> +	usb_put_dev(dln2->usb_dev);
> +	kfree(dln2);
> +}

> +static void dln2_disconnect(struct usb_interface *interface)
> +{
> +	struct dln2_dev *dln2 = usb_get_intfdata(interface);
> +
> +	mfd_remove_devices(&interface->dev);

You need to make sure all I/O has stopped here.

> +	dln2_free(dln2);
> +}

Johan
