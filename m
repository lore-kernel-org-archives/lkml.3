Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab3HVBJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 21:09:21 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:20978 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab3HVBJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 21:09:19 -0400
Message-ID: <521564B7.10902@laposte.net>
Date: Thu, 22 Aug 2013 03:09:11 +0200
From: Yann Cantin <yann.cantin@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        dmitry.torokhov@gmail.com, jkosina@suse.cz, rob@landley.net,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 2/2] input: misc: New USB eBeam input driver
References: <1376684743-25047-1-git-send-email-yann.cantin@laposte.net>  <1376684743-25047-3-git-send-email-yann.cantin@laposte.net> <1377062750.1797.9.camel@linux-fkkt.site>
In-Reply-To: <1377062750.1797.9.camel@linux-fkkt.site>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

All issues addressed. Just a point :

>> +
>> +	/* input final setup */
>> +	ebeam_setup_input(ebeam, input_dev);
>> +
>> +	err = input_register_device(ebeam->input);
>> +	if (err) {
>> +		dev_dbg(&intf->dev,
>> +			"%s - input_register_device failed, err: %d\n",
>> +			__func__, err);
>> +		goto out_free_urb;
>> +	}
>> +
>> +	/* usb final setup */
>> +	usb_set_intfdata(intf, ebeam);
>> +
>> +	/* sysfs setup */
>> +	err = sysfs_create_group(&intf->dev.kobj, &ebeam_attr_group);
>> +	if (err) {
>> +		dev_dbg(&intf->dev,
>> +			"%s - cannot create sysfs group, err: %d\n",
>> +			__func__, err);
>> +		goto out_unregister_input;
>> +	}
>
> This is not nice. User space may react to a new input device of this
> type by setting up the calibration. But the sysfs files may be created
> after that. You should invert the order.

Switch done. Could you please double check the goto out-* cleanup, i've spotted
a missing usb_set_intfdata(intf, NULL), perhaps there's others missing steps :

static int ebeam_probe(struct usb_interface *intf,
		       const struct usb_device_id *id)
{
	struct ebeam_device *ebeam;
	struct input_dev *input_dev;
	struct usb_endpoint_descriptor *endpoint;
	struct usb_device *udev = interface_to_usbdev(intf);
	int err = -ENOMEM;

	endpoint = ebeam_get_input_endpoint(intf->cur_altsetting);
	if (!endpoint)
		return -ENXIO;

	ebeam = kzalloc(sizeof(struct ebeam_device), GFP_KERNEL);
	input_dev = input_allocate_device();
	if (!ebeam || !input_dev)
		goto out_free;

	ebeam_init_settings(ebeam);

	ebeam->data = usb_alloc_coherent(udev, REPT_SIZE,
					 GFP_KERNEL, &ebeam->data_dma);
	if (!ebeam->data)
		goto out_free;

	ebeam->irq = usb_alloc_urb(0, GFP_KERNEL);
	if (!ebeam->irq) {
		dev_dbg(&intf->dev,
			"%s - usb_alloc_urb failed: ebeam->irq\n", __func__);
		goto out_free_buffers;
	}

	ebeam->interface = intf;
	ebeam->input = input_dev;

	/* setup name */
	snprintf(ebeam->name, sizeof(ebeam->name),
		 "USB eBeam %04x:%04x",
		 le16_to_cpu(udev->descriptor.idVendor),
		 le16_to_cpu(udev->descriptor.idProduct));

	if (udev->manufacturer || udev->product) {
		strlcat(ebeam->name,
			" (",
			sizeof(ebeam->name));

		if (udev->manufacturer)
			strlcat(ebeam->name,
				udev->manufacturer,
				sizeof(ebeam->name));

		if (udev->product) {
			if (udev->manufacturer)
				strlcat(ebeam->name,
					" ",
					sizeof(ebeam->name));
			strlcat(ebeam->name,
				udev->product,
				sizeof(ebeam->name));
		}

		if (strlcat(ebeam->name, ")", sizeof(ebeam->name))
			>= sizeof(ebeam->name)) {
			/* overflowed, closing ) anyway */
			ebeam->name[sizeof(ebeam->name)-2] = ')';
		}
	}

	/* usb tree */
	usb_make_path(udev, ebeam->phys, sizeof(ebeam->phys));
	strlcat(ebeam->phys, "/input0", sizeof(ebeam->phys));

	/* input setup */
	input_dev->name = ebeam->name;
	input_dev->phys = ebeam->phys;
	usb_to_input_id(udev, &input_dev->id);
	input_dev->dev.parent = &intf->dev;

	input_set_drvdata(input_dev, ebeam);

	input_dev->open = ebeam_open;
	input_dev->close = ebeam_close;

	/* usb urb setup */
	if (usb_endpoint_type(endpoint) == USB_ENDPOINT_XFER_INT)
		usb_fill_int_urb(ebeam->irq, udev,
			usb_rcvintpipe(udev, endpoint->bEndpointAddress),
			ebeam->data, REPT_SIZE,
			ebeam_irq, ebeam, endpoint->bInterval);
	else
		usb_fill_bulk_urb(ebeam->irq, udev,
			usb_rcvbulkpipe(udev, endpoint->bEndpointAddress),
			ebeam->data, REPT_SIZE,
			ebeam_irq, ebeam);

	ebeam->irq->dev = udev;
	ebeam->irq->transfer_dma = ebeam->data_dma;
	ebeam->irq->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;

	/* usb final setup */
	usb_set_intfdata(intf, ebeam);

	/* sysfs setup */
	err = sysfs_create_group(&intf->dev.kobj, &ebeam_attr_group);
	if (err) {
		dev_dbg(&intf->dev,
			"%s - cannot create sysfs group, err: %d\n",
			__func__, err);
		goto out_free_usb;
	}

	/* input final setup */
	ebeam_setup_input(ebeam, input_dev);

	err = input_register_device(ebeam->input);
	if (err) {
		dev_dbg(&intf->dev,
			"%s - input_register_device failed, err: %d\n",
			__func__, err);
		goto out_remove_sysfs;
	}

	return 0;

out_remove_sysfs:
	sysfs_remove_group(&intf->dev.kobj, &ebeam_attr_group);
out_free_usb:
	usb_set_intfdata(intf, NULL);
	usb_free_urb(ebeam->irq);
out_free_buffers:
	ebeam_free_buffers(udev, ebeam);
out_free:
	input_free_device(input_dev);
	kfree(ebeam);
	return err;
}


Thanks,

--
Yann Cantin
A4FEB47F
--
