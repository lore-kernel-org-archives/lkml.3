Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab3HUHI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 03:08:58 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:42458 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab3HUHI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 03:08:56 -0400
Message-ID: <1377062750.1797.9.camel@linux-fkkt.site>
Subject: Re: [PATCH 2/2] input: misc: New USB eBeam input driver
From: Oliver Neukum <oliver@neukum.org>
To: Yann Cantin <yann.cantin@laposte.net>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        dmitry.torokhov@gmail.com, jkosina@suse.cz, rob@landley.net,
        gregkh@linuxfoundation.org
In-Reply-To: <1376684743-25047-3-git-send-email-yann.cantin@laposte.net>
References: <1376684743-25047-1-git-send-email-yann.cantin@laposte.net>
	 <1376684743-25047-3-git-send-email-yann.cantin@laposte.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Aug 2013 07:25:50 +0200
Mime-Version: 1.0
X-Mailer: Evolution 3.9.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-16 at 22:25 +0200, Yann Cantin wrote:

> +/* IRQ */
> +static int ebeam_read_data(struct ebeam_device *ebeam, unsigned char *pkt)
> +{
> +
> +/*
> + * Packet description : 8 bytes
> + *
> + *  nop packet : FF FF FF FF FF FF FF FF
> + *
> + *  pkt[0] : Sensors
> + *	bit 1 : ultrasound signal (guessed)
> + *	bit 2 : IR signal (tested with a remote...) ;
> + *	readings OK : 0x03 (anything else is a show-stopper)
> + *
> + *  pkt[1] : raw_x low
> + *  pkt[2] : raw_x high
> + *
> + *  pkt[3] : raw_y low
> + *  pkt[4] : raw_y high
> + *
> + *  pkt[5] : fiability ?
> + *	often 0xC0
> + *	> 0x80 : OK
> + *
> + *  pkt[6] :
> + *	buttons state (low 4 bits)
> + *		0x1 = no buttons
> + *		bit 0 : tip (WARNING inversed : 0=pressed)
> + *		bit 1 : ? (always 0 during tests)
> + *		bit 2 : little (1=pressed)
> + *		bit 3 : big (1=pressed)
> + *
> + *	pointer ID : (high 4 bits)
> + *		Tested  : 0x6=wand ;
> + *		Guessed : 0x1=red ; 0x2=blue ; 0x3=green ; 0x4=black ;
> + *			  0x5=eraser
> + *		bit 4 : pointer ID
> + *		bit 5 : pointer ID
> + *		bit 6 : pointer ID
> + *		bit 7 : pointer ID
> + *
> + *
> + *  pkt[7] : fiability ?
> + *	often 0xFF
> + *
> + */
> +
> +	/* Filtering bad/nop packet */
> +	if (pkt[0] != 0x03)
> +		return 0;
> +
> +	ebeam->raw_x = (pkt[2] << 8) | pkt[1];
> +	ebeam->raw_y = (pkt[4] << 8) | pkt[3];

We have macros. In this case get_unaligned_le16.

> +	ebeam->btn_map = (!(pkt[6] & 0x1))	|
> +			 ((pkt[6] & 0x4) >> 1)	|
> +			 ((pkt[6] & 0x8) >> 1);
> +
> +	return 1;
> +}


> +static void ebeam_close(struct input_dev *input)
> +{
> +	struct ebeam_device *ebeam = input_get_drvdata(input);
> +	int r;
> +
> +	usb_kill_urb(ebeam->irq);
> +
> +	r = usb_autopm_get_interface(ebeam->interface);

Nope. That's an uncool race. If the interface is suspended when
you call this, you will resume it and restart the URB. Therefore
you ought to kill the URB after resuming.

> +	ebeam->interface->needs_remote_wakeup = 0;
> +
> +	if (!r)
> +		usb_autopm_put_interface(ebeam->interface);
> +}
> +
> +static int ebeam_suspend(struct usb_interface *intf, pm_message_t message)
> +{
> +	struct ebeam_device *ebeam = usb_get_intfdata(intf);
> +
> +	usb_kill_urb(ebeam->irq);
> +
> +	return 0;
> +}
> +
> +static int ebeam_resume(struct usb_interface *intf)
> +{
> +	struct ebeam_device *ebeam = usb_get_intfdata(intf);
> +	struct input_dev *input = ebeam->input;
> +	int result = 0;
> +
> +	mutex_lock(&input->mutex);
> +	if (input->users)
> +		result = usb_submit_urb(ebeam->irq, GFP_NOIO);
> +	mutex_unlock(&input->mutex);
> +
> +	return result;
> +}
> +
> +static int ebeam_reset_resume(struct usb_interface *intf)
> +{
> +	return ebeam_resume(intf);
> +}

No need to define a function. You can use the function as
value for resume and reset_resume.

> +
> +static int ebeam_probe(struct usb_interface *intf,
> +		       const struct usb_device_id *id)
> +{
> +	struct ebeam_device *ebeam;
> +	struct input_dev *input_dev;
> +	struct usb_endpoint_descriptor *endpoint;
> +	struct usb_device *udev = interface_to_usbdev(intf);
> +	int err = -ENOMEM;
> +
> +	endpoint = ebeam_get_input_endpoint(intf->cur_altsetting);
> +	if (!endpoint)
> +		return -ENXIO;
> +
> +	ebeam = kzalloc(sizeof(struct ebeam_device), GFP_KERNEL);
> +	input_dev = input_allocate_device();
> +	if (!ebeam || !input_dev)
> +		goto out_free;
> +
> +	ebeam_init_settings(ebeam);
> +
> +	ebeam->data = usb_alloc_coherent(udev, REPT_SIZE,
> +					 GFP_KERNEL, &ebeam->data_dma);
> +	if (!ebeam->data)
> +		goto out_free;
> +
> +	ebeam->irq = usb_alloc_urb(0, GFP_KERNEL);
> +	if (!ebeam->irq) {
> +		dev_dbg(&intf->dev,
> +			"%s - usb_alloc_urb failed: ebeam->irq\n", __func__);
> +		goto out_free_buffers;
> +	}
> +
> +	ebeam->interface = intf;
> +	ebeam->input = input_dev;
> +
> +	/* setup name */
> +	snprintf(ebeam->name, sizeof(ebeam->name),
> +		 "USB eBeam %04x:%04x",
> +		 le16_to_cpu(udev->descriptor.idVendor),
> +		 le16_to_cpu(udev->descriptor.idProduct));
> +
> +	if (udev->manufacturer || udev->product) {
> +		strlcat(ebeam->name,
> +			" (",
> +			sizeof(ebeam->name));
> +
> +		if (udev->manufacturer)
> +			strlcat(ebeam->name,
> +				udev->manufacturer,
> +				sizeof(ebeam->name));
> +
> +		if (udev->product) {
> +			if (udev->manufacturer)
> +				strlcat(ebeam->name,
> +					" ",
> +					sizeof(ebeam->name));
> +			strlcat(ebeam->name,
> +				udev->product,
> +				sizeof(ebeam->name));
> +		}
> +
> +		if (strlcat(ebeam->name, ")", sizeof(ebeam->name))
> +			>= sizeof(ebeam->name)) {
> +			/* overflowed, closing ) anyway */
> +			ebeam->name[sizeof(ebeam->name)-2] = ')';
> +		}
> +	}
> +
> +	/* usb tree */
> +	usb_make_path(udev, ebeam->phys, sizeof(ebeam->phys));
> +	strlcat(ebeam->phys, "/input0", sizeof(ebeam->phys));
> +
> +	/* input setup */
> +	input_dev->name = ebeam->name;
> +	input_dev->phys = ebeam->phys;
> +	usb_to_input_id(udev, &input_dev->id);
> +	input_dev->dev.parent = &intf->dev;
> +
> +	input_set_drvdata(input_dev, ebeam);
> +
> +	input_dev->open = ebeam_open;
> +	input_dev->close = ebeam_close;
> +
> +	/* usb urb setup */
> +	if (usb_endpoint_type(endpoint) == USB_ENDPOINT_XFER_INT)
> +		usb_fill_int_urb(ebeam->irq, udev,
> +			usb_rcvintpipe(udev, endpoint->bEndpointAddress),
> +			ebeam->data, REPT_SIZE,
> +			ebeam_irq, ebeam, endpoint->bInterval);
> +	else
> +		usb_fill_bulk_urb(ebeam->irq, udev,
> +			usb_rcvbulkpipe(udev, endpoint->bEndpointAddress),
> +			ebeam->data, REPT_SIZE,
> +			ebeam_irq, ebeam);
> +
> +	ebeam->irq->dev = udev;
> +	ebeam->irq->transfer_dma = ebeam->data_dma;
> +	ebeam->irq->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> +
> +	/* input final setup */
> +	ebeam_setup_input(ebeam, input_dev);
> +
> +	err = input_register_device(ebeam->input);
> +	if (err) {
> +		dev_dbg(&intf->dev,
> +			"%s - input_register_device failed, err: %d\n",
> +			__func__, err);
> +		goto out_free_urb;
> +	}
> +
> +	/* usb final setup */
> +	usb_set_intfdata(intf, ebeam);
> +
> +	/* sysfs setup */
> +	err = sysfs_create_group(&intf->dev.kobj, &ebeam_attr_group);
> +	if (err) {
> +		dev_dbg(&intf->dev,
> +			"%s - cannot create sysfs group, err: %d\n",
> +			__func__, err);
> +		goto out_unregister_input;
> +	}

This is not nice. User space may react to a new input device of this
type by setting up the calibration. But the sysfs files may be created
after that. You should invert the order.

	HTH
		Oliver


