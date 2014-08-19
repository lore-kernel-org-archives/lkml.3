Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaHSJ4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 05:56:40 -0400
Received: from svenfoo.org ([82.94.215.22]:52521 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaHSJ4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 05:56:38 -0400
Message-ID: <53F31F52.8060904@zonque.org>
Date: Tue, 19 Aug 2014 11:56:34 +0200
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        balbi@ti.com, devicetree@vger.kernel.org
CC: gregkh@linuxfoundation.org, michals@xilinx.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, svemula@xilinx.com, anirudh@xilinx.com,
        sbhatta@xilinx.com
Subject: Re: [PATCH v4 2/2] usb: gadget: Add xilinx usb2 device support
References: <1406020130-20467-1-git-send-email-sbhatta@xilinx.com> <31c3ad1a-370a-4d0d-b392-8e7bb292f6aa@BN1AFFO11FD050.protection.gbl>
In-Reply-To: <31c3ad1a-370a-4d0d-b392-8e7bb292f6aa@BN1AFFO11FD050.protection.gbl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/22/2014 11:08 AM, Subbaraya Sundeep Bhatta wrote:
> This patch adds xilinx usb2 device driver support

Add some more information here, please. Copying the text from the
Kconfig option is already a good start.

>  drivers/usb/gadget/Kconfig      |   14 +
>  drivers/usb/gadget/Makefile     |    1 +
>  drivers/usb/gadget/udc-xilinx.c | 2261 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 2276 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/usb/gadget/udc-xilinx.c

As your driver has a DT binding, you have to describe it in
Documentation/devicetree/bindings.

> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -459,6 +459,20 @@ config USB_EG20T
>  	  ML7213/ML7831 is companion chip for Intel Atom E6xx series.
>  	  ML7213/ML7831 is completely compatible for Intel EG20T PCH.
>
> +config USB_GADGET_XILINX
> +	tristate "Xilinx USB Driver"
> +	depends on COMPILE_TEST

Why would you depend on that?

Also, your code uses device tree functions unconditionally, which is
fine, but it must hence depend on 'OF'.

> +struct xusb_ep {
> +	struct usb_ep ep_usb;
> +	struct list_head queue;
> +	struct xusb_udc *udc;
> +	const struct usb_endpoint_descriptor *desc;
> +	u32 rambase;
> +	u32 offset;
> +	char name[4];
> +	u16 epnumber;
> +	u16 maxpacket;
> +	u16 buffer0count;
> +	u16 buffer1count;
> +	u8 buffer0ready;
> +	u8 buffer1ready;
> +	u8 eptype;
> +	u8 curbufnum;
> +	u8 is_in;
> +	u8 is_iso;

Some of those could probably become booleans.

> +struct xusb_udc {
> +	struct usb_gadget gadget;
> +	struct xusb_ep ep[8];
> +	struct usb_gadget_driver *driver;
> +	struct usb_ctrlrequest setup;
> +	struct xusb_req *req;
> +	struct device *dev;
> +	u32 usb_state;
> +	u32 remote_wkp;
> +	u32 setupseqtx;
> +	u32 setupseqrx;
> +	void __iomem *base_address;
> +	spinlock_t lock;
> +	bool dma_enabled;
> +
> +	unsigned int (*read_fn)(void __iomem *);
> +	void (*write_fn)(void __iomem *, u32, u32);
> +};
> +
> +/* Endpoint buffer start addresses in the core */
> +static u32 rambase[8] = { 0x22, 0x1000, 0x1100, 0x1200, 0x1300, 0x1400, 0x1500,
> +			0x1600 };

As stated by Peter, indenting such lines to match the position of the
line before makes such code much prettier and more readable. It's also
done in the majority of drivers.

This counts for many locations in your code.

> +/* Control endpoint configuration.*/
> +static const struct usb_endpoint_descriptor config_bulk_out_desc = {
> +	.bLength		= USB_DT_ENDPOINT_SIZE,
> +	.bDescriptorType	= USB_DT_ENDPOINT,
> +	.bEndpointAddress	= USB_DIR_OUT,
> +	.bmAttributes		= USB_ENDPOINT_XFER_BULK,
> +	.wMaxPacketSize		= cpu_to_le16(64),

Why not use EP0_MAX_PACKET here?

> +static void xudc_wrstatus(struct xusb_udc *udc)
> +{
> +	struct xusb_ep *ep0 = &udc->ep[XUSB_EP_NUMBER_ZERO];
> +	u32 epcfgreg;
> +
> +	epcfgreg = udc->read_fn(udc->base_address + ep0->offset)|
> +			XUSB_EP_CFG_DATA_TOGGLE_MASK;
> +	udc->write_fn(udc->base_address, ep0->offset, epcfgreg);
> +	udc->write_fn(udc->base_address, ep0->offset + XUSB_EP_BUF0COUNT_OFFSET,
> +			0);

Just a nit, but renaming 'base_address' to something like 'base' or
'addr' would help you get around or maximum line constraint here and in
some other places.

> +static int xudc_dma_send(struct xusb_ep *ep, struct xusb_req *req,
> +		u8 *buffer, u32 length)
> +{
> +	u32 *eprambase;
> +	dma_addr_t src;
> +	dma_addr_t dst;
> +	int ret;
> +	struct xusb_udc *udc = ep->udc;
> +
> +	src = req->usb_req.dma + req->usb_req.actual;
> +	if (req->usb_req.length)
> +		dma_sync_single_for_device(udc->dev, src,
> +						length, DMA_TO_DEVICE);
> +	if (!ep->curbufnum && !ep->buffer0ready) {
> +		/* Get the Buffer address and copy the transmit data.*/
> +		eprambase = (u32 __force *)(udc->base_address +
> +				ep->rambase);
> +		dst = virt_to_phys(eprambase);
> +		udc->write_fn(udc->base_address, ep->offset +
> +				XUSB_EP_BUF0COUNT_OFFSET, length);
> +		udc->write_fn(udc->base_address, XUSB_DMA_CONTROL_OFFSET,
> +				XUSB_DMA_BRR_CTRL | (1 << ep->epnumber));
> +		ep->buffer0ready = 1;
> +		ep->curbufnum = 1;
> +	} else if (ep->curbufnum && !ep->buffer1ready) {
> +		/* Get the Buffer address and copy the transmit data.*/
> +		eprambase = (u32 __force *)(udc->base_address +
> +				ep->rambase + ep->ep_usb.maxpacket);
> +		dst = virt_to_phys(eprambase);
> +		udc->write_fn(udc->base_address, ep->offset +
> +				XUSB_EP_BUF1COUNT_OFFSET, length);
> +		udc->write_fn(udc->base_address, XUSB_DMA_CONTROL_OFFSET,
> +				XUSB_DMA_BRR_CTRL | (1 << (ep->epnumber +
> +				XUSB_STATUS_EP_BUFF2_SHIFT)));
> +		ep->buffer1ready = 1;
> +		ep->curbufnum = 0;
> +	} else {
> +		/* None of ping pong buffers are ready currently .*/
> +		return -EAGAIN;
> +	}
> +
> +	ret = xudc_start_dma(ep, src, dst, length);
> +	return ret;

return xudc_start_dma(ep, src, dst, length);

... so you don't need 'ret' at all.

> +static int xudc_dma_receive(struct xusb_ep *ep, struct xusb_req *req,
> +		u8 *buffer, u32 length)
> +{
> +	u32 *eprambase;
> +	dma_addr_t src;
> +	dma_addr_t dst;
> +	int ret = 0;
> +	struct xusb_udc *udc = ep->udc;
> +
> +	dst = req->usb_req.dma + req->usb_req.actual;
> +
> +	if (!ep->curbufnum && !ep->buffer0ready) {
> +		/* Get the Buffer address and copy the transmit data */
> +		eprambase = (u32 __force *)(udc->base_address +
> +				ep->rambase);
> +		src = virt_to_phys(eprambase);
> +		udc->write_fn(udc->base_address, XUSB_DMA_CONTROL_OFFSET,
> +				XUSB_DMA_BRR_CTRL | XUSB_DMA_READ_FROM_DPRAM |
> +				(1 << ep->epnumber));
> +		ep->buffer0ready = 1;
> +		ep->curbufnum = 1;
> +	} else if (ep->curbufnum && !ep->buffer1ready) {
> +		/* Get the Buffer address and copy the transmit data */
> +		eprambase = (u32 __force *)(udc->base_address +
> +				ep->rambase + ep->ep_usb.maxpacket);
> +		src = virt_to_phys(eprambase);
> +		udc->write_fn(udc->base_address, XUSB_DMA_CONTROL_OFFSET,
> +				XUSB_DMA_BRR_CTRL | XUSB_DMA_READ_FROM_DPRAM |
> +				(1 << (ep->epnumber +
> +				XUSB_STATUS_EP_BUFF2_SHIFT)));
> +		ep->buffer1ready = 1;
> +		ep->curbufnum = 0;
> +	} else {
> +		/* None of the ping-pong buffers are ready currently */
> +		return -EAGAIN;
> +	}
> +
> +	ret = xudc_start_dma(ep, src, dst, length);
> +	return ret;

Dito.

> +static int xudc_eptxrx(struct xusb_ep *ep, struct xusb_req *req,
> +		u8 *bufferptr, u32 bufferlen)
> +{
> +	u32 *eprambase;
> +	u32 bytestosend;
> +	u8 *temprambase;
> +	int rc = 0;
> +	struct xusb_udc *udc = ep->udc;
> +
> +	bytestosend = bufferlen;
> +	if (udc->dma_enabled) {
> +		if (ep->is_in)
> +			rc = xudc_dma_send(ep, req, bufferptr, bufferlen);
> +		else
> +			rc = xudc_dma_receive(ep, req, bufferptr, bufferlen);
> +		return rc;
> +	}
> +	/* Put the transmit buffer into the correct ping-pong buffer.*/
> +	if (!ep->curbufnum && !ep->buffer0ready) {
> +		/* Get the Buffer address and copy the transmit data.*/
> +		eprambase = (u32 __force *)(udc->base_address + ep->rambase);
> +		while (bytestosend > 3) {
> +			if (ep->is_in)
> +				*eprambase++ = *(u32 *)bufferptr;
> +			else
> +				*(u32 *)bufferptr = *eprambase++;
> +			bufferptr += 4;
> +			bytestosend -= 4;
> +		}
> +		temprambase = (u8 *)eprambase;
> +		while (bytestosend--) {
> +			if (ep->is_in)
> +				*temprambase++ = *bufferptr++;
> +			else
> +				*bufferptr++ = *temprambase++;
> +		}

Why not use memcpy()?

> +		/*
> +		 * Set the Buffer count register with transmit length
> +		 * and enable the buffer for transmission.
> +		 */
> +		if (ep->is_in)
> +			udc->write_fn(udc->base_address, ep->offset +
> +					XUSB_EP_BUF0COUNT_OFFSET, bufferlen);
> +		udc->write_fn(udc->base_address, XUSB_BUFFREADY_OFFSET,
> +				1 << ep->epnumber);
> +		ep->buffer0ready = 1;
> +		ep->curbufnum = 1;
> +	} else if ((ep->curbufnum == 1) && (!ep->buffer1ready)) {
> +		/* Get the Buffer address and copy the transmit data.*/
> +		eprambase = (u32 __force *)(udc->base_address + ep->rambase +
> +				ep->ep_usb.maxpacket);
> +		while (bytestosend > 3) {
> +			if (ep->is_in)
> +				*eprambase++ = *(u32 *)bufferptr;
> +			else
> +				*(u32 *)bufferptr = *eprambase++;
> +			bufferptr += 4;
> +			bytestosend -= 4;
> +		}
> +		temprambase = (u8 *)eprambase;
> +		while (bytestosend--) {
> +			if (ep->is_in)
> +				*temprambase++ = *bufferptr++;
> +			else
> +				*bufferptr++ = *temprambase++;
> +		}

memcpy()?

> +/**
> + * xudc_read_fifo - Reads the data from the given endpoint buffer.
> + * @ep: pointer to the usb device endpoint structure.
> + * @req: pointer to the usb request structure.
> + *
> + * Return: 0 if request is completed and -EAGAIN if not completed.
> + *
> + * Pulls OUT packet data from the endpoint buffer.
> + */
> +static int xudc_read_fifo(struct xusb_ep *ep, struct xusb_req *req)
> +{
> +	u8 *buf;
> +	u32 is_short, count, bufferspace;
> +	u8 bufoffset;
> +	u8 two_pkts = 0;
> +	int ret;
> +	int retval = -EAGAIN;
> +	struct xusb_udc *udc = ep->udc;
> +
> +	if ((ep->buffer0ready == 1) && (ep->buffer1ready == 1)) {

if (ep->buffer0ready && ep->buffer1ready)

is shorter and easier to read.

> +static int xudc_ep_set_halt(struct usb_ep *_ep, int value)
> +{
> +	struct xusb_ep *ep = to_xusb_ep(_ep);
> +	struct xusb_udc *udc;
> +	unsigned long flags;
> +	u32 epcfgreg;
> +
> +	if (!_ep || (!ep->desc && ep->epnumber)) {
> +		pr_debug("%s: bad ep or descriptor\n", __func__);

dev_dbg()

> +static int __xudc_ep_enable(struct xusb_ep *ep,
> +		const struct usb_endpoint_descriptor *desc)
> +{
> +	struct xusb_udc *udc = ep->udc;
> +	u32 tmp;
> +	u8 eptype = 0;
> +	u32 epcfg;
> +	u32 ier;
> +
> +	ep->is_in = ((desc->bEndpointAddress & USB_DIR_IN) != 0);
> +	/* Bit 3...0:endpoint number */
> +	ep->epnumber = (desc->bEndpointAddress & 0x0f);
> +	ep->desc = desc;
> +	ep->ep_usb.desc = desc;
> +	tmp = desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
> +	ep->ep_usb.maxpacket = le16_to_cpu(desc->wMaxPacketSize);
> +
> +	switch (tmp) {
> +	case USB_ENDPOINT_XFER_CONTROL:
> +		dev_dbg(udc->dev, "only one control endpoint\n");
> +		/* NON- ISO */
> +		eptype = 0;
> +		return -EINVAL;
> +	case USB_ENDPOINT_XFER_INT:
> +		/* NON- ISO */
> +		eptype = 0;
> +		if (ep->ep_usb.maxpacket > 64)
> +			goto bogus_max;
> +		break;
> +	case USB_ENDPOINT_XFER_BULK:
> +		/* NON- ISO */
> +		eptype = 0;
> +		switch (ep->ep_usb.maxpacket) {
> +		case 8:
> +		case 16:
> +		case 32:
> +		case 64:
> +		case 512:
> +			goto ok;
> +		}

Nit: With is_power_of_2() and some min/max checks, you wouldn't need a
switch here, and hence the jump label could go away.

> +bogus_max:
> +		dev_dbg(udc->dev, "bogus maxpacket %d\n",
> +			ep->ep_usb.maxpacket);
> +		return -EINVAL;
> +	case USB_ENDPOINT_XFER_ISOC:
> +		/* ISO */
> +		eptype = 1;
> +		ep->is_iso = 1;
> +		break;
> +	}
> +ok:

...

> +static int xudc_ep_enable(struct usb_ep *_ep,
> +		const struct usb_endpoint_descriptor *desc)
> +{
> +	struct xusb_ep *ep;
> +	struct xusb_udc *udc;
> +	unsigned long flags;
> +	int ret;
> +
> +	if (!_ep || !desc || desc->bDescriptorType != USB_DT_ENDPOINT) {
> +		pr_debug("%s: bad ep or descriptor\n", __func__);

dev_dbg()

> +static int xudc_ep_disable(struct usb_ep *_ep)
> +{
> +	struct xusb_ep *ep;
> +	unsigned long flags;
> +	u32 epcfg;
> +	struct xusb_udc *udc;
> +
> +	if (!_ep) {
> +		pr_debug("%s: invalid ep\n", __func__);

dev_dbg()

> +static int __xudc_ep0_queue(struct xusb_ep *ep0, struct xusb_req *req)
> +{
> +	struct xusb_udc *udc = ep0->udc;
> +	u32 length;
> +	u8 *corebuf;
> +
> +	if (!udc->driver || udc->gadget.speed == USB_SPEED_UNKNOWN) {
> +		dev_dbg(udc->dev, "%s, bogus device state\n",
> +			__func__);
> +		return -EINVAL;
> +	}
> +	if (!list_empty(&ep0->queue)) {
> +		dev_dbg(udc->dev, "%s:ep0 busy\n", __func__);
> +		return -EBUSY;
> +	}
> +
> +	req->usb_req.status = -EINPROGRESS;
> +	req->usb_req.actual = 0;
> +
> +	list_add_tail(&req->queue, &ep0->queue);
> +
> +	if (udc->setup.bRequestType & USB_DIR_IN) {
> +		prefetch(req->usb_req.buf);
> +		length = req->usb_req.length;
> +		corebuf = (void __force *) ((ep0->rambase << 2) +
> +				udc->base_address);
> +		length = req->usb_req.actual = min_t(u32, length,
> +						EP0_MAX_PACKET);
> +		memcpy((void *)corebuf, req->usb_req.buf, length);

No need for the cast.

> +		udc->write_fn(udc->base_address, XUSB_EP_BUF0COUNT_OFFSET,
> +				length);
> +		udc->write_fn(udc->base_address, XUSB_BUFFREADY_OFFSET, 1);
> +	} else {
> +		if (udc->setup.wLength) {
> +			/* Enable EP0 buffer to receive data */
> +			udc->write_fn(udc->base_address,
> +					XUSB_EP_BUF0COUNT_OFFSET, 0);
> +			udc->write_fn(udc->base_address,
> +					XUSB_BUFFREADY_OFFSET, 1);
> +		} else {
> +			xudc_wrstatus(udc);
> +		}
> +	}
> +
> +	return 0;
> +}
> +

...

> +/**
> + * xudc_handle_setup - Processes the setup packet.
> + * @udc: pointer to the usb device controller structure.
> + *
> + * Process setup packet and delegate to gadget layer.
> + */
> +static void xudc_handle_setup(struct xusb_udc *udc)
> +{
> +	struct xusb_ep *ep0 = &udc->ep[0];
> +	struct usb_ctrlrequest setup;
> +	u32 *ep0rambase;
> +
> +	/* Load up the chapter 9 command buffer.*/
> +	ep0rambase = (u32 __force *) (udc->base_address +
> +				  XUSB_SETUP_PKT_ADDR_OFFSET);
> +	memcpy((void *)&setup, (void *)ep0rambase, 8);

Dito.

> +static void xudc_ep0_in(struct xusb_udc *udc)
> +{
> +	struct xusb_ep *ep0 = &udc->ep[0];
> +	struct xusb_req *req;
> +	unsigned int bytes_to_tx;
> +	void *buffer;
> +	u32 epcfgreg;
> +	u16 count = 0;
> +	u16 length;
> +	u8 *ep0rambase;
> +	u8 test_mode = udc->setup.wIndex >> 8;
> +
> +	req = list_first_entry(&ep0->queue, struct xusb_req, queue);
> +	bytes_to_tx = req->usb_req.length - req->usb_req.actual;
> +
> +	switch (udc->setupseqtx) {
> +	case STATUS_PHASE:
> +		switch (udc->setup.bRequest) {
> +		case USB_REQ_SET_ADDRESS:
> +			/* Set the address of the device.*/
> +			udc->write_fn(udc->base_address,
> +					XUSB_ADDRESS_OFFSET,
> +					udc->setup.wValue);
> +			break;
> +		case USB_REQ_SET_FEATURE:
> +			if (udc->setup.bRequestType ==
> +					USB_RECIP_DEVICE) {
> +				if (udc->setup.wValue ==
> +						USB_DEVICE_TEST_MODE)
> +					udc->write_fn(udc->base_address,
> +							XUSB_TESTMODE_OFFSET,
> +							test_mode);
> +			}
> +			break;
> +		}
> +		req->usb_req.actual = req->usb_req.length;
> +		xudc_done(ep0, req, 0);
> +		break;
> +	case DATA_PHASE:
> +		if (!bytes_to_tx) {
> +			/*
> +			 * We're done with data transfer, next
> +			 * will be zero length OUT with data toggle of
> +			 * 1. Setup data_toggle.
> +			 */
> +			epcfgreg = udc->read_fn(udc->base_address +
> +					ep0->offset);
> +			epcfgreg |= XUSB_EP_CFG_DATA_TOGGLE_MASK;
> +			udc->write_fn(udc->base_address, ep0->offset, epcfgreg);
> +			udc->setupseqtx = STATUS_PHASE;
> +		} else {
> +			length = count = min_t(u32, bytes_to_tx,
> +						EP0_MAX_PACKET);
> +			/* Copy the data to be transmitted into the DPRAM. */
> +			ep0rambase = (u8 __force *) (udc->base_address +
> +					(ep0->rambase << 2));
> +
> +			buffer = req->usb_req.buf + req->usb_req.actual;
> +			req->usb_req.actual = req->usb_req.actual + length;
> +			memcpy((void *)ep0rambase, buffer, length);

Dito.

+/**
+ * xudc_eps_init - initialize endpoints.
+ * @udc: pointer to the usb device controller structure.
+ */
+static void xudc_eps_init(struct xusb_udc *udc)
+{
+	u32 ep_number;
+	char name[4];
+
+	INIT_LIST_HEAD(&udc->gadget.ep_list);
+
+	for (ep_number = 0; ep_number < XUSB_MAX_ENDPOINTS; ep_number++) {
+		struct xusb_ep *ep = &udc->ep[ep_number];
+
+		if (ep_number) {
+			list_add_tail(&ep->ep_usb.ep_list,
+					&udc->gadget.ep_list);
+			usb_ep_set_maxpacket_limit(&ep->ep_usb,
+					(unsigned short) ~0);
+			sprintf(name, "ep%d", ep_number);
+			strcpy(ep->name, name);
+			ep->ep_usb.name = ep->name;

Why not use ep->name directly? Also, I'd prefer snprintf() here, even if
you're sure this can't overflow :)

> +static int xudc_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct resource *res;
> +	struct xusb_udc *udc;
> +	struct xusb_ep *ep0;
> +	int irq;
> +	int ret;
> +	u32 ier;
> +	u8 *buff;
> +
> +	udc = devm_kzalloc(&pdev->dev, sizeof(*udc), GFP_KERNEL);
> +	if (!udc)
> +		return -ENOMEM;
> +
> +	/* Map the registers */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	udc->base_address = devm_ioremap_resource(&pdev->dev, res);
> +	if (!udc->base_address)
> +		return -ENOMEM;
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(&pdev->dev, "unable to get irq\n");
> +		return irq;
> +	}
> +	ret = devm_request_irq(&pdev->dev, irq, xudc_irq, 0,
> +				dev_name(&pdev->dev), udc);
> +	if (ret < 0) {
> +		dev_dbg(&pdev->dev, "unable to request irq %d", irq);
> +		goto fail;
> +	}
> +
> +	udc->dma_enabled = of_property_read_bool(np, "xlnx,has-builtin-dma");
> +
> +	/* Setup gadget structure */
> +	udc->gadget.ops = &xusb_udc_ops;
> +	udc->gadget.max_speed = USB_SPEED_HIGH;
> +	udc->gadget.speed = USB_SPEED_UNKNOWN;
> +	udc->gadget.ep0 = &udc->ep[XUSB_EP_NUMBER_ZERO].ep_usb;
> +	udc->gadget.name = driver_name;
> +
> +	spin_lock_init(&udc->lock);
> +
> +	/* Check for IP endianness */
> +	udc->write_fn = xudc_write32_be;
> +	udc->read_fn = xudc_read32_be;
> +	udc->write_fn(udc->base_address, XUSB_TESTMODE_OFFSET, TEST_J);
> +	if ((udc->read_fn(udc->base_address + XUSB_TESTMODE_OFFSET))
> +			!= TEST_J) {
> +		udc->write_fn = xudc_write32;
> +		udc->read_fn = xudc_read32;
> +	}
> +	udc->write_fn(udc->base_address, XUSB_TESTMODE_OFFSET, 0);
> +
> +	xudc_eps_init(udc);
> +
> +	ep0 = &udc->ep[0];
> +	/* Create a dummy request for GET_STATUS, SET_ADDRESS */
> +	udc->req = container_of(xudc_ep_alloc_request(&ep0->ep_usb, GFP_KERNEL),
> +				struct xusb_req, usb_req);
> +	if (!udc->req) {
> +		ret = -ENOMEM;
> +		goto fail;
> +	}
> +
> +	/* buffer for data of get_status request */
> +	buff = kzalloc(2, GFP_KERNEL);
> +	if (buff == NULL) {
> +		ret = -ENOMEM;
> +		goto fail;
> +	}
> +	/* Dummy request ready, free this in remove */
> +	udc->req->usb_req.buf = buff;

devm_kzalloc() solves this for you.

> +static int xudc_remove(struct platform_device *pdev)
> +{
> +	struct xusb_udc *udc = platform_get_drvdata(pdev);
> +	void *buf = udc->req->usb_req.buf;
> +
> +	usb_del_gadget_udc(&udc->gadget);
> +
> +	/* free memory allocated for dummy request buffer */
> +	kfree(buf);
> +	/* free memory allocated for dummy request */
> +	kfree(udc->req);

These comments don't really help anyone - it's pretty obvious what
happens here :) But those will vanish with devm_kzalloc() anyway.



Thanks,
Daniel

