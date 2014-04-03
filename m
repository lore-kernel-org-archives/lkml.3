Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbaDCPBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:01:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54469 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbaDCPA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:00:56 -0400
Date: Thu, 3 Apr 2014 09:58:54 -0500
From: Felipe Balbi <balbi@ti.com>
To: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <michals@xilinx.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Subject: Re: [PATCH v2 2/2] usb: gadget: Add xilinx axi usb2 device support
Message-ID: <20140403145853.GD14162@saruman.home>
Reply-To: <balbi@ti.com>
References: <1396510519-8555-1-git-send-email-sbhatta@xilinx.com>
 <113d0620-4003-417d-806b-0b79ae692829@VA3EHSMHS023.ehs.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X3gaHHMYHkYqP6yf"
Content-Disposition: inline
In-Reply-To: <113d0620-4003-417d-806b-0b79ae692829@VA3EHSMHS023.ehs.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--X3gaHHMYHkYqP6yf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 03, 2014 at 01:05:19PM +0530, Subbaraya Sundeep Bhatta wrote:
> This patch adds xilinx axi usb2 device driver support
>=20
> Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
> ---
> Changes for v2:
> 	- Added Resume
> 	- Added Remote wakeup
> 	- Fixed v1 comments
>=20
>  drivers/usb/gadget/Kconfig      |   14 +
>  drivers/usb/gadget/Makefile     |    1 +
>  drivers/usb/gadget/udc-xilinx.c | 2057 +++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 2072 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/usb/gadget/udc-xilinx.c
>=20
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index 8154165..db43a79 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -466,6 +466,20 @@ config USB_EG20T
>  	  ML7213/ML7831 is companion chip for Intel Atom E6xx series.
>  	  ML7213/ML7831 is completely compatible for Intel EG20T PCH.
> =20
> +config USB_GADGET_XILINX
> +	tristate "Xilinx USB Driver"
> +	depends on COMPILE_TEST
> +	help
> +	  USB peripheral controller driver for Xilinx AXI USB2 device.
> +	  Xilinx AXI USB2 device is a soft IP which supports both full
> +	  and high speed USB 2.0 data transfers. It has seven configurable
> +	  endpoints(bulk or interrupt or isochronous), as well as
> +	  endpoint zero(for control transfers).
> +
> +	  Say "y" to link the driver statically, or "m" to build a
> +	  dynamically linked module called "xilinx_udc" and force all
> +	  gadget drivers to also be dynamically linked.
> +
>  #
>  # LAST -- dummy/emulated controller
>  #
> diff --git a/drivers/usb/gadget/Makefile b/drivers/usb/gadget/Makefile
> index 5f150bc..8a3fc0b 100644
> --- a/drivers/usb/gadget/Makefile
> +++ b/drivers/usb/gadget/Makefile
> @@ -36,6 +36,7 @@ obj-$(CONFIG_USB_FUSB300)	+=3D fusb300_udc.o
>  obj-$(CONFIG_USB_FOTG210_UDC)	+=3D fotg210-udc.o
>  obj-$(CONFIG_USB_MV_U3D)	+=3D mv_u3d_core.o
>  obj-$(CONFIG_USB_GR_UDC)	+=3D gr_udc.o
> +obj-$(CONFIG_USB_GADGET_XILINX)	+=3D udc-xilinx.o
> =20
>  # USB Functions
>  usb_f_acm-y			:=3D f_acm.o
> diff --git a/drivers/usb/gadget/udc-xilinx.c b/drivers/usb/gadget/udc-xil=
inx.c
> new file mode 100644
> index 0000000..5709aeb
> --- /dev/null
> +++ b/drivers/usb/gadget/udc-xilinx.c
> @@ -0,0 +1,2057 @@
> +/*
> + * Xilinx USB peripheral controller driver
> + *
> + * Copyright (C) 2004 by Thomas Rathbone
> + * Copyright (C) 2005 by HP Labs
> + * Copyright (C) 2005 by David Brownell
> + * Copyright (C) 2010 - 2014 Xilinx, Inc.
> + *
> + * Some parts of this driver code is based on the driver for at91-series
> + * USB peripheral controller (at91_udc.c).
> + *
> + * This program is free software; you can redistribute it
> + * and/or modify it under the terms of the GNU General Public
> + * License as published by the Free Software Foundation;
> + * either version 2 of the License, or (at your option) any
> + * later version.
> + */
> +#include <linux/interrupt.h>
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/prefetch.h>
> +#include <linux/usb/ch9.h>
> +#include <linux/usb/gadget.h>
> +#include <linux/io.h>
> +#include <linux/seq_file.h>
> +#include <linux/of_address.h>
> +#include <linux/of_device.h>
> +#include <linux/of_platform.h>
> +#include <linux/of_irq.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/delay.h>
> +#include "gadget_chips.h"
> +
> +/* Register offsets for the USB device.*/
> +#define XUSB_EP0_CONFIG_OFFSET		0x0000  /* EP0 Config Reg Offset */
> +#define XUSB_SETUP_PKT_ADDR_OFFSET	0x0080  /* Setup Packet Address */
> +#define XUSB_ADDRESS_OFFSET		0x0100  /* Address Register */
> +#define XUSB_CONTROL_OFFSET		0x0104  /* Control Register */
> +#define XUSB_STATUS_OFFSET		0x0108  /* Status Register */
> +#define XUSB_FRAMENUM_OFFSET		0x010C	/* Frame Number Register */
> +#define XUSB_IER_OFFSET			0x0110	/* Interrupt Enable Register */
> +#define XUSB_BUFFREADY_OFFSET		0x0114	/* Buffer Ready Register */
> +#define XUSB_TESTMODE_OFFSET		0x0118	/* Test Mode Register */
> +#define XUSB_DMA_RESET_OFFSET		0x0200  /* DMA Soft Reset Register */
> +#define XUSB_DMA_CONTROL_OFFSET		0x0204	/* DMA Control Register */
> +#define XUSB_DMA_DSAR_ADDR_OFFSET	0x0208	/* DMA source Address Reg */
> +#define XUSB_DMA_DDAR_ADDR_OFFSET	0x020C	/* DMA destination Addr Reg */
> +#define XUSB_DMA_LENGTH_OFFSET		0x0210	/* DMA Length Register */
> +#define XUSB_DMA_STATUS_OFFSET		0x0214	/* DMA Status Register */
> +
> +/* Endpoint Configuration Space offsets */
> +#define XUSB_EP_CFGSTATUS_OFFSET	0x00	/* Endpoint Config Status  */
> +#define XUSB_EP_BUF0COUNT_OFFSET	0x08	/* Buffer 0 Count */
> +#define XUSB_EP_BUF1COUNT_OFFSET	0x0C	/* Buffer 1 Count */
> +
> +#define XUSB_CONTROL_USB_READY_MASK	0x80000000 /* USB ready Mask */
> +#define XUSB_CONTROL_USB_RMTWAKE_MASK	0x40000000 /* Remote wake up mask =
*/
> +
> +/* Interrupt register related masks.*/
> +#define XUSB_STATUS_GLOBAL_INTR_MASK	0x80000000 /* Global Intr Enable */
> +#define XUSB_STATUS_RESUME_MASK		0x01000000 /* USB Resume Mask */
> +#define XUSB_STATUS_RESET_MASK		0x00800000 /* USB Reset Mask */
> +#define XUSB_STATUS_SUSPEND_MASK	0x00400000 /* USB Suspend Mask */
> +#define XUSB_STATUS_FIFO_BUFF_RDY_MASK	0x00100000 /* FIFO Buff Ready Mas=
k */
> +#define XUSB_STATUS_FIFO_BUFF_FREE_MASK	0x00080000 /* FIFO Buff Free Mas=
k */
> +#define XUSB_STATUS_SETUP_PACKET_MASK	0x00040000 /* Setup packet receive=
d */
> +#define XUSB_STATUS_EP1_BUFF2_COMP_MASK	0x00000200 /* EP 1 Buff 2 Proces=
sed */
> +#define XUSB_STATUS_EP1_BUFF1_COMP_MASK	0x00000002 /* EP 1 Buff 1 Proces=
sed */
> +#define XUSB_STATUS_EP0_BUFF2_COMP_MASK	0x00000100 /* EP 0 Buff 2 Proces=
sed */
> +#define XUSB_STATUS_EP0_BUFF1_COMP_MASK	0x00000001 /* EP 0 Buff 1 Proces=
sed */
> +#define XUSB_STATUS_HIGH_SPEED_MASK	0x00010000 /* USB Speed Mask */
> +/* Suspend,Reset and Disconnect Mask */
> +#define XUSB_STATUS_INTR_EVENT_MASK	0x00C00000
> +/* Buffers  completion Mask */
> +#define XUSB_STATUS_INTR_BUFF_COMP_ALL_MASK	0x0000FEFF
> +/* Mask for buffer 0 and buffer 1 completion for all Endpoints */
> +#define XUSB_STATUS_INTR_BUFF_COMP_SHIFT_MASK	0x00000101
> +#define XUSB_STATUS_EP_BUFF2_SHIFT	8	   /* EP buffer offset */
> +
> +/* Endpoint Configuration Status Register */
> +#define XUSB_EP_CFG_VALID_MASK		0x80000000 /* Endpoint Valid bit */
> +#define XUSB_EP_CFG_STALL_MASK		0x40000000 /* Endpoint Stall bit */
> +#define XUSB_EP_CFG_DATA_TOGGLE_MASK	0x08000000 /* Endpoint Data toggle =
*/
> +
> +/* USB device specific global configuration constants.*/
> +#define XUSB_MAX_ENDPOINTS		8	/* Maximum End Points */
> +#define XUSB_EP_NUMBER_ZERO		0	/* End point Zero */
> +/* DPRAM is the source address for DMA transfer */
> +#define XUSB_DMA_READ_FROM_DPRAM	0x80000000
> +#define XUSB_DMA_DMASR_BUSY		0x80000000 /* DMA busy */
> +#define XUSB_DMA_DMASR_ERROR		0x40000000 /* DMA Error */
> +/*
> + * When this bit is set, the DMA buffer ready bit is set by hardware upon
> + * DMA transfer completion.
> + */
> +#define XUSB_DMA_BRR_CTRL		0x40000000 /* DMA bufready ctrl bit */
> +/* Phase States */
> +#define SETUP_PHASE			0x0000	/* Setup Phase */
> +#define DATA_PHASE			0x0001  /* Data Phase */
> +#define STATUS_PHASE			0x0002  /* Status Phase */
> +
> +#define EP0_MAX_PACKET		64 /* Endpoint 0 maximum packet length */
> +
> +/* container_of helper macros */
> +#define to_udc(g)	 container_of((g), struct xusb_udc, gadget)
> +#define to_xusb_ep(ep)	 container_of((ep), struct xusb_ep, ep_usb)
> +#define to_xusb_req(req) container_of((req), struct xusb_req, usb_req)
> +
> +/*----------------------------------------------------------------------=
---*/
> +
> +#ifdef DEBUG
> +#define DBG(fmt, args...)	pr_debug("[%s]  " fmt "\n", \
> +				__func__, ## args)
> +#else
> +#define DBG(fmt, args...)	do {} while (0)
> +#endif
> +
> +#ifdef VERBOSE
> +#define VDBG		DBG
> +#else
> +#define VDBG(stuff...)	do {} while (0)
> +#endif
> +
> +#define ERR(stuff...)		pr_err("udc: " stuff)
> +#define WARNING(stuff...)		pr_warn("udc: " stuff)
> +#define INFO(stuff...)		pr_info("udc: " stuff)

NACK, this is always to cleanup later. Please stick to
dev_{info,err,warn,dbg,vdbg}()

> +struct xusb_udc {
> +	struct usb_gadget gadget;
> +	struct xusb_ep ep[8];
> +	struct usb_gadget_driver *driver;
> +	struct cmdbuf ch9cmd;
> +	u32 usb_state;
> +	u32 remote_wkp;
> +	unsigned int (*read_fn)(void __iomem *);
> +	void (*write_fn)(void __iomem *, u32, u32);

why do you need these to be function pointers ? Because of endianness ?
generic readl()/writel() already take care of that.

> +	void __iomem *base_address;
> +	spinlock_t lock;
> +	bool dma_enabled;
> +};
> +
> +/* Endpoint buffer start addresses in the core */
> +static u32 rambase[8] =3D { 0x22, 0x1000, 0x1100, 0x1200, 0x1300, 0x1400=
, 0x1500,
> +			0x1600 };
> +
> +static const char driver_name[] =3D "xilinx-udc";
> +static const char ep0name[] =3D "ep0";
> +
> +/* Control endpoint configuration.*/
> +static struct usb_endpoint_descriptor config_bulk_out_desc =3D {

should be const, you never modify this.

> +	.bLength =3D USB_DT_ENDPOINT_SIZE,
> +	.bDescriptorType =3D USB_DT_ENDPOINT,
> +	.bEndpointAddress =3D USB_DIR_OUT,
> +	.bmAttributes =3D USB_ENDPOINT_XFER_BULK,
> +	.wMaxPacketSize =3D __constant_cpu_to_le16(0x40),

let's use the decimal here just for clarity.

> +/**
> + * xudc_wrstatus - Sets up the usb device status stages.
> + * @udc: pointer to the usb device controller structure.
> + */
> +static void xudc_wrstatus(struct xusb_udc *udc)
> +{
> +	u32 epcfgreg;
> +
> +	epcfgreg =3D udc->read_fn(udc->base_address +
> +				udc->ep[XUSB_EP_NUMBER_ZERO].offset)|
> +				XUSB_EP_CFG_DATA_TOGGLE_MASK;

are you really trying to mask here ? If you're trying to mask you should
be using a bitwise and.

> +	udc->write_fn(udc->base_address, udc->ep[XUSB_EP_NUMBER_ZERO].offset,
> +			epcfgreg);
> +	udc->write_fn(udc->base_address, udc->ep[XUSB_EP_NUMBER_ZERO].offset +
> +			  XUSB_EP_BUF0COUNT_OFFSET, 0);
> +	udc->write_fn(udc->base_address, XUSB_BUFFREADY_OFFSET, 1);

you can improve redability on this by defining some local variables:

struct xusb_udc_ep *ep0 =3D &udc->ep[XUSB_EP_NUMBER_ZERO];
u32 reg;

reg =3D xudc_readl(udc->base_address, ep0->offset);
reg |=3D XUSB_EP_CFG_DATA_TOGGLE_MASK;
xudc_writel(udc->base_address, ep0->offset + XUSB_EP_BUF0COUNT_OFFSET, 0);
xudc_writel(udc->base_address, XUSB_BUFFREADY_OFFSET, 1);

and so on, likewise for all other functions.

> +static int start_dma(struct xusb_ep *ep, u32 src, u32 dst, u32 length)

please prepend this with xudc_, it makes tracing a lot easier.

> +{
> +	struct xusb_udc *udc;
> +	int rc =3D 0;
> +	unsigned long timeout;
> +
> +	udc =3D ep->udc;
> +	/*
> +	 * Set the addresses in the DMA source and
> +	 * destination registers and then set the length
> +	 * into the DMA length register.
> +	 */
> +	udc->write_fn(udc->base_address, XUSB_DMA_DSAR_ADDR_OFFSET, src);
> +	udc->write_fn(udc->base_address, XUSB_DMA_DDAR_ADDR_OFFSET, dst);
> +	udc->write_fn(udc->base_address, XUSB_DMA_LENGTH_OFFSET, length);
> +
> +	/*
> +	 * Wait till DMA transaction is complete and
> +	 * check whether the DMA transaction was
> +	 * successful.
> +	*/
> +	while ((udc->read_fn(ep->udc->base_address + XUSB_DMA_STATUS_OFFSET) &
> +			XUSB_DMA_DMASR_BUSY) =3D=3D XUSB_DMA_DMASR_BUSY) {
> +		timeout =3D jiffies + 10000;
> +
> +		if (time_after(jiffies, timeout)) {
> +			rc =3D -ETIMEDOUT;
> +			goto clean;
> +		}
> +	}

don't you get an IRQ for DMA completion ? If you do, you could be using
wait_for_completion()

> +	if ((udc->read_fn(udc->base_address + XUSB_DMA_STATUS_OFFSET) &
> +				XUSB_DMA_DMASR_ERROR) =3D=3D XUSB_DMA_DMASR_ERROR){
> +		DBG("DMA Error\n");
> +		rc =3D -EINVAL;
> +	}
> +clean:
> +	if (ep->is_in) {
> +		dma_unmap_single(udc->gadget.dev.parent, src,
> +					length, DMA_TO_DEVICE);
> +	} else {
> +		dma_unmap_single(udc->gadget.dev.parent, dst,
> +					length, DMA_FROM_DEVICE);

NACK, use generic usb_gadget_map_reqeust() and
usb_gadget_unmap_request().

> +static int dma_send(struct xusb_ep *ep, u8 *buffer, u32 length)

prepend with xudc_

> +{
> +	u32 *eprambase;
> +	dma_addr_t src;
> +	u32 dst;
> +	int ret;
> +	struct xusb_udc *udc;
> +
> +	udc =3D ep->udc;
> +	src =3D dma_map_single(udc->gadget.dev.parent, buffer, length,
> +				DMA_TO_DEVICE);
> +	if (dma_mapping_error(udc->gadget.dev.parent, src)) {
> +		DBG("failed to map DMA\n");
> +		return -EFAULT;
> +	}

use generic mapping functions.

> +static int dma_receive(struct xusb_ep *ep, u8 *buffer, u32 length)

prepend with xudc_

> +{
> +	u32 *eprambase;
> +	u32 src;
> +	dma_addr_t dst;
> +	int ret;
> +	struct xusb_udc *udc;
> +
> +	udc =3D ep->udc;
> +	dst =3D dma_map_single(udc->gadget.dev.parent, buffer, length,
> +				DMA_FROM_DEVICE);
> +	if (dma_mapping_error(udc->gadget.dev.parent, dst)) {
> +		DBG("failed to map DMA\n");
> +		return -EFAULT;
> +	}

use generic mapping functions

> +
> +	if (!ep->curbufnum && !ep->buffer0ready) {
> +		/* Get the Buffer address and copy the transmit data */
> +		eprambase =3D (u32 __force *)(ep->udc->base_address +
> +				ep->rambase);
> +		src =3D virt_to_phys(eprambase);
> +		udc->write_fn(udc->base_address, XUSB_DMA_CONTROL_OFFSET,
> +				XUSB_DMA_BRR_CTRL | XUSB_DMA_READ_FROM_DPRAM |
> +				(1 << ep->epnumber));
> +		ep->buffer0ready =3D 1;
> +		ep->curbufnum =3D 1;
> +	} else if (ep->curbufnum && !ep->buffer1ready) {
> +		/* Get the Buffer address and copy the transmit data */
> +		eprambase =3D (u32 __force *)(ep->udc->base_address +
> +				ep->rambase + ep->ep_usb.maxpacket);
> +		src =3D virt_to_phys(eprambase);
> +		udc->write_fn(udc->base_address, XUSB_DMA_CONTROL_OFFSET,
> +				XUSB_DMA_BRR_CTRL | XUSB_DMA_READ_FROM_DPRAM |
> +				(1 << (ep->epnumber +
> +				XUSB_STATUS_EP_BUFF2_SHIFT)));
> +		ep->buffer1ready =3D 1;
> +		ep->curbufnum =3D 0;
> +	} else {
> +		/* None of the ping-pong buffers are ready currently */
> +		return 1;

you *must* return a proper error code here. -EAGAIN sounds like the one
you want.

> +static int xudc_eptxrx(struct xusb_ep *ep, u8 *bufferptr, u32 bufferlen)
> +{
> +	u32 *eprambase;
> +	u32 bytestosend;
> +	u8 *temprambase;
> +	int rc =3D 0;
> +	struct xusb_udc *udc =3D ep->udc;
> +
> +	bytestosend =3D bufferlen;
> +	if (udc->dma_enabled) {
> +		if (ep->is_in)
> +			rc =3D dma_send(ep, bufferptr, bufferlen);
> +		else
> +			rc =3D dma_receive(ep, bufferptr, bufferlen);
> +		return rc;
> +	}
> +	/* Put the transmit buffer into the correct ping-pong buffer.*/
> +	if (!ep->curbufnum && !ep->buffer0ready) {
> +		/* Get the Buffer address and copy the transmit data.*/
> +		eprambase =3D (u32 __force *)(udc->base_address + ep->rambase);
> +		while (bytestosend > 3) {
> +			if (ep->is_in)
> +				*eprambase++ =3D *(u32 *)bufferptr;
> +			else
> +				*(u32 *)bufferptr =3D *eprambase++;
> +			bufferptr +=3D 4;
> +			bytestosend -=3D 4;
> +		}
> +		temprambase =3D (u8 *)eprambase;
> +		while (bytestosend--) {
> +			if (ep->is_in)
> +				*temprambase++ =3D *bufferptr++;
> +			else
> +				*bufferptr++ =3D *temprambase++;
> +		}
> +		/*
> +		 * Set the Buffer count register with transmit length
> +		 * and enable the buffer for transmission.
> +		 */
> +		if (ep->is_in)
> +			udc->write_fn(udc->base_address, ep->offset +
> +					XUSB_EP_BUF0COUNT_OFFSET, bufferlen);
> +		udc->write_fn(udc->base_address, XUSB_BUFFREADY_OFFSET,
> +				1 << ep->epnumber);
> +		ep->buffer0ready =3D 1;
> +		ep->curbufnum =3D 1;
> +	} else if ((ep->curbufnum =3D=3D 1) && (!ep->buffer1ready)) {
> +		/* Get the Buffer address and copy the transmit data.*/
> +		eprambase =3D (u32 __force *)(udc->base_address + ep->rambase +
> +				ep->ep_usb.maxpacket);
> +		while (bytestosend > 3) {
> +			if (ep->is_in)
> +				*eprambase++ =3D *(u32 *)bufferptr;
> +			else
> +				*(u32 *)bufferptr =3D *eprambase++;
> +			bufferptr +=3D 4;
> +			bytestosend -=3D 4;
> +		}
> +		temprambase =3D (u8 *)eprambase;
> +		while (bytestosend--) {
> +			if (ep->is_in)
> +				*temprambase++ =3D *bufferptr++;
> +			else
> +				*bufferptr++ =3D *temprambase++;
> +		}
> +		/*
> +		 * Set the Buffer count register with transmit
> +		 * length and enable the buffer for
> +		 * transmission.
> +		 */
> +		if (ep->is_in)
> +			udc->write_fn(udc->base_address, ep->offset +
> +					XUSB_EP_BUF1COUNT_OFFSET, bufferlen);
> +		udc->write_fn(udc->base_address, XUSB_BUFFREADY_OFFSET,
> +				1 << (ep->epnumber +
> +				XUSB_STATUS_EP_BUFF2_SHIFT));
> +		ep->buffer1ready =3D 1;
> +		ep->curbufnum =3D 0;
> +	} else {
> +		/* None of the ping-pong buffers are ready currently */
> +		return 1;
> +	}
> +	return rc;
> +}
> +
> +/**
> + * xudc_done - Exeutes the endpoint data transfer completion tasks.
> + * @ep: pointer to the usb device endpoint structure.
> + * @req: pointer to the usb request structure.
> + * @status: Status of the data transfer.
> + *
> + * Deletes the message from the queue and updates data transfer completi=
on
> + * status.
> + */
> +static void xudc_done(struct xusb_ep *ep, struct xusb_req *req, int stat=
us)
> +{
> +	u8 stopped =3D ep->stopped;
> +
> +	list_del_init(&req->queue);
> +
> +	if (req->usb_req.status =3D=3D -EINPROGRESS)
> +		req->usb_req.status =3D status;
> +	else
> +		status =3D req->usb_req.status;
> +
> +	if (status && status !=3D -ESHUTDOWN)
> +		DBG("%s done %p, status %d\n", ep->ep_usb.name, req, status);

dev_dbg()

> +	ep->stopped =3D 1;
> +
> +	spin_unlock(&ep->udc->lock);
> +	if (req->usb_req.complete)
> +		req->usb_req.complete(&ep->ep_usb, &req->usb_req);
> +	spin_lock(&ep->udc->lock);
> +
> +	ep->stopped =3D stopped;
> +}
> +
> +/**
> + * xudc_read_fifo - Reads the data from the given endpoint buffer.
> + * @ep: pointer to the usb device endpoint structure.
> + * @req: pointer to the usb request structure.
> + *
> + * Return: 1 if request completed/dequeued or 0 if req is not
> + *		completed

should return 0 on success and negative errno in case it doesn't
complete. You must review your error handling!!

> +static int xudc_read_fifo(struct xusb_ep *ep, struct xusb_req *req)
> +{
> +	u8 *buf;
> +	u32 is_short, count, bufferspace;

avoid multiple declarations in one line.

> +	u8 bufoffset;
> +	u8 two_pkts =3D 0;
> +	struct xusb_udc *udc =3D ep->udc;
> +
> +	if ((ep->buffer0ready =3D=3D 1) && (ep->buffer1ready =3D=3D 1)) {
> +		DBG("Packet NOT ready!\n");
> +		return 0;
> +	}
> +top:
> +	if (ep->curbufnum)
> +		bufoffset =3D XUSB_EP_BUF1COUNT_OFFSET;
> +	else
> +		bufoffset =3D XUSB_EP_BUF0COUNT_OFFSET;
> +	count =3D udc->read_fn(ep->udc->base_address + ep->offset + bufoffset);
> +	if (!ep->buffer0ready && !ep->buffer1ready)
> +		two_pkts =3D 1;
> +
> +	DBG("curbufnum is %d  and buf0rdy is %d, buf1rdy is %d\n",
> +		ep->curbufnum, ep->buffer0ready, ep->buffer1ready);
> +
> +	buf =3D req->usb_req.buf + req->usb_req.actual;
> +	prefetchw(buf);
> +	bufferspace =3D req->usb_req.length - req->usb_req.actual;
> +	req->usb_req.actual +=3D min(count, bufferspace);
> +	is_short =3D count < ep->ep_usb.maxpacket;
> +
> +	if (unlikely(!bufferspace)) {
> +		/*
> +		 * This happens when the driver's buffer
> +		 * is smaller than what the host sent.
> +		 * discard the extra data.
> +		 */
> +		if (req->usb_req.status !=3D -EOVERFLOW)
> +			DBG("%s overflow %d\n", ep->ep_usb.name, count);
> +			req->usb_req.status =3D -EOVERFLOW;
> +	} else {
> +		switch (xudc_eptxrx(ep, buf, count)) {
> +		case 0:
> +			VDBG("read %s, %d bytes%s req %p %d/%d\n",
> +				ep->ep_usb.name, count, is_short ? "/S" : "",
> +				req, req->usb_req.actual, req->usb_req.length);
> +			bufferspace -=3D count;
> +			/* Completion */
> +			if ((req->usb_req.actual =3D=3D
> +				req->usb_req.length) || is_short) {
> +				xudc_done(ep, req, 0);
> +				return 1;
> +			}
> +			if (two_pkts) {
> +				two_pkts =3D 0;
> +				goto top;
> +			}
> +			break;
> +		case 1:
> +			VDBG("Rx buffers busy\n");
> +			req->usb_req.actual -=3D min(count, bufferspace);
> +			break;
> +		case -EINVAL:
> +		case -EFAULT:
> +		case -ETIMEDOUT:
> +			/* DMA error, dequeue the request */
> +			xudc_done(ep, req, -ECONNRESET);
> +			return 1;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * xudc_write_fifo - Writes data into the given endpoint buffer.
> + * @ep: pointer to the usb device endpoint structure.
> + * @req: pointer to the usb request structure.
> + *
> + * Return: 1 if request completed/dequeued or 0 if req is not
> + *		completed
> + *
> + * Loads endpoint buffer for an IN packet.
> + */
> +static int xudc_write_fifo(struct xusb_ep *ep, struct xusb_req *req)
> +{
> +	u8 *buf;
> +	u32 max;
> +	u32 length;
> +	int is_last, is_short =3D 0;
> +
> +	max =3D le16_to_cpu(ep->desc->wMaxPacketSize);
> +	buf =3D req->usb_req.buf + req->usb_req.actual;
> +	prefetch(buf);
> +	length =3D req->usb_req.length - req->usb_req.actual;
> +	length =3D min(length, max);
> +
> +	switch (xudc_eptxrx(ep, buf, length)) {
> +	case 0:
> +		req->usb_req.actual +=3D length;
> +		if (unlikely(length !=3D max)) {
> +			is_last =3D is_short =3D 1;
> +		} else {
> +			if (likely(req->usb_req.length !=3D
> +				   req->usb_req.actual) || req->usb_req.zero)
> +				is_last =3D 0;
> +			else
> +				is_last =3D 1;
> +		}
> +		VDBG("wrote %s %d bytes%s%s %d left %p\n", ep->ep_usb.name,
> +			length, is_last ? "/L" : "", is_short ? "/S" : "",
> +			req->usb_req.length - req->usb_req.actual, req);
> +		if (is_last) {
> +			xudc_done(ep, req, 0);
> +			return 1;
> +		}
> +		break;
> +	case 1:
> +		VDBG("Tx buffers busy\n");
> +		break;
> +	case -EINVAL:
> +	case -EFAULT:
> +	case -ETIMEDOUT:
> +		/* DMA error, dequeue the request */
> +		xudc_done(ep, req, -ECONNRESET);
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * xudc_nuke - Cleans up the data transfer message list.
> + * @ep: pointer to the usb device endpoint structure.
> + * @status: Status of the data transfer.
> + */
> +static void xudc_nuke(struct xusb_ep *ep, int status)
> +{
> +	struct xusb_req *req;
> +
> +	while (!list_empty(&ep->queue)) {
> +		req =3D list_entry(ep->queue.next, struct xusb_req, queue);
> +		xudc_done(ep, req, status);
> +	}
> +}
> +
> +/***************************** Endpoint related functions***************=
******/
> +/**
> + * xudc_ep_set_halt - Stalls/unstalls the given endpoint.
> + * @_ep: pointer to the usb device endpoint structure.
> + * @value: value to indicate stall/unstall.
> + *
> + * Return: 0 for success and error value on failure
> + */
> +static int xudc_ep_set_halt(struct usb_ep *_ep, int value)
> +{
> +	struct xusb_ep *ep =3D to_xusb_ep(_ep);
> +	unsigned long flags;
> +	u32 epcfgreg;
> +	struct xusb_udc *udc =3D ep->udc;
> +
> +	if (!_ep || (!ep->desc && ep->epnumber))
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(&udc->lock, flags);
> +
> +	if (ep->is_in && (!list_empty(&ep->queue)) && value) {
> +		spin_unlock_irqrestore(&udc->lock, flags);
> +		return -EAGAIN;
> +	}
> +	if ((ep->buffer0ready =3D=3D 1) || (ep->buffer1ready =3D=3D 1)) {
> +		spin_unlock_irqrestore(&udc->lock, flags);
> +		return -EAGAIN;
> +	}
> +	if (value) {
> +		/* Stall the device.*/
> +		epcfgreg =3D udc->read_fn(udc->base_address +
> +				   ep->offset);
> +		epcfgreg |=3D XUSB_EP_CFG_STALL_MASK;
> +
> +		udc->write_fn(udc->base_address, ep->offset, epcfgreg);
> +		ep->stopped =3D 1;
> +	} else {
> +		ep->stopped =3D 0;
> +		/* Unstall the device.*/
> +		epcfgreg =3D udc->read_fn(udc->base_address +
> +					    ep->offset);
> +		epcfgreg &=3D ~XUSB_EP_CFG_STALL_MASK;
> +		udc->write_fn(udc->base_address, ep->offset, epcfgreg);
> +		if (ep->epnumber) {
> +			/* Reset the toggle bit.*/
> +			epcfgreg =3D udc->read_fn(ep->udc->base_address +
> +						    ep->offset);
> +			epcfgreg &=3D ~XUSB_EP_CFG_DATA_TOGGLE_MASK;
> +			udc->write_fn(udc->base_address, ep->offset, epcfgreg);
> +		}
> +	}
> +	spin_unlock_irqrestore(&udc->lock, flags);
> +	return 0;
> +}
> +
> +/**
> + * xudc_ep_enable - Enables the given endpoint.
> + * @_ep: pointer to the usb device endpoint structure.
> + * @desc: pointer to usb endpoint descriptor.
> + *
> + * Return: 0 for success and error value on failure
> + */
> +static int xudc_ep_enable(struct usb_ep *_ep,
> +			  const struct usb_endpoint_descriptor *desc)
> +{
> +	struct xusb_ep *ep =3D to_xusb_ep(_ep);
> +	u32 tmp;
> +	u8 eptype =3D 0;
> +	unsigned long flags;
> +	u32 epcfg;
> +	struct xusb_udc *udc =3D ep->udc;
> +
> +	/*
> +	 * The check for _ep->name =3D=3D ep0name is not done as this enable is=
 used
> +	 * for enabling ep0 also. In other gadget drivers, this ep name is not
> +	 * used.
> +	 */
> +	if (!_ep || !desc || ep->desc ||
> +			desc->bDescriptorType !=3D USB_DT_ENDPOINT) {
> +		DBG("bad ep or descriptor\n");
> +		return -EINVAL;
> +	}
> +	if (!udc->driver || udc->gadget.speed =3D=3D USB_SPEED_UNKNOWN) {
> +		DBG("bogus device state\n");
> +		return -ESHUTDOWN;
> +	}
> +
> +	ep->is_in =3D ((desc->bEndpointAddress & USB_DIR_IN) !=3D 0);
> +	/* Bit 3...0:endpoint number */
> +	ep->epnumber =3D (desc->bEndpointAddress & 0x0f);
> +	ep->stopped =3D 0;
> +	ep->desc =3D desc;
> +	ep->ep_usb.desc =3D desc;
> +	tmp =3D desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
> +
> +	spin_lock_irqsave(&udc->lock, flags);
> +
> +	ep->ep_usb.maxpacket =3D le16_to_cpu(desc->wMaxPacketSize);
> +	switch (tmp) {
> +	case USB_ENDPOINT_XFER_CONTROL:
> +		DBG("only one control endpoint\n");
> +		/* NON- ISO */
> +		eptype =3D 0;
> +		spin_unlock_irqrestore(&ep->udc->lock, flags);
> +		return -EINVAL;
> +	case USB_ENDPOINT_XFER_INT:
> +		/* NON- ISO */
> +		eptype =3D 0;
> +		if (ep->ep_usb.maxpacket > 64)
> +			goto bogus_max;
> +		break;
> +	case USB_ENDPOINT_XFER_BULK:
> +		/* NON- ISO */
> +		eptype =3D 0;
> +		switch (ep->ep_usb.maxpacket) {
> +		case 8:
> +		case 16:
> +		case 32:
> +		case 64:
> +		case 512:
> +			goto ok;
> +		}
> +bogus_max:
> +		DBG("bogus maxpacket %d\n", ep->ep_usb.maxpacket);
> +		spin_unlock_irqrestore(&ep->udc->lock, flags);
> +		return -EINVAL;
> +	case USB_ENDPOINT_XFER_ISOC:
> +		/* ISO */
> +		eptype =3D 1;
> +		ep->is_iso =3D 1;
> +		break;
> +	}
> +ok:
> +	ep->eptype =3D eptype;
> +	ep->buffer0ready =3D 0;
> +	ep->buffer1ready =3D 0;
> +	ep->curbufnum =3D 0;
> +	ep->rambase =3D rambase[ep->epnumber];
> +	xudc_epconfig(ep, udc);
> +
> +	DBG("Enable Endpoint %d max pkt is %d\n",
> +			ep->epnumber, ep->ep_usb.maxpacket);
> +
> +	/* Enable the End point.*/
> +	epcfg =3D udc->read_fn(udc->base_address + ep->offset);
> +	epcfg |=3D XUSB_EP_CFG_VALID_MASK;
> +	udc->write_fn(udc->base_address, ep->offset, epcfg);
> +	if (ep->epnumber)
> +		ep->rambase <<=3D 2;
> +
> +	if (ep->epnumber)
> +		udc->write_fn(udc->base_address, XUSB_IER_OFFSET,
> +				(udc->read_fn(ep->udc->base_address +
> +				XUSB_IER_OFFSET) |
> +				(XUSB_STATUS_INTR_BUFF_COMP_SHIFT_MASK <<
> +				ep->epnumber)));
> +	if (ep->epnumber && !ep->is_in) {
> +		/* Set the buffer ready bits.*/
> +		udc->write_fn(udc->base_address, XUSB_BUFFREADY_OFFSET,
> +				1 << ep->epnumber);
> +		ep->buffer0ready =3D 1;
> +		udc->write_fn(udc->base_address, XUSB_BUFFREADY_OFFSET,
> +				(1 << (ep->epnumber +
> +				XUSB_STATUS_EP_BUFF2_SHIFT)));
> +		ep->buffer1ready =3D 1;
> +	}
> +
> +	spin_unlock_irqrestore(&udc->lock, flags);
> +
> +	return 0;
> +}
> +
> +/**
> + * xudc_ep_disable - Disables the given endpoint.
> + * @_ep: pointer to the usb device endpoint structure.
> + *
> + * Return: 0 for success and error value on failure
> + */
> +static int xudc_ep_disable(struct usb_ep *_ep)
> +{
> +	struct xusb_ep *ep =3D to_xusb_ep(_ep);
> +	unsigned long flags;
> +	u32 epcfg;
> +	struct xusb_udc *udc =3D ep->udc;
> +
> +	udc =3D ep->udc;
> +	if (ep =3D=3D &udc->ep[XUSB_EP_NUMBER_ZERO]) {
> +		DBG("Ep0 disable called\n");
> +		return -EINVAL;
> +	}
> +
> +	spin_lock_irqsave(&udc->lock, flags);
> +	xudc_nuke(ep, -ESHUTDOWN);
> +
> +	/* Restore the endpoint's pristine config */
> +	ep->desc =3D NULL;
> +	ep->ep_usb.desc =3D NULL;
> +	ep->stopped =3D 1;
> +
> +	DBG("USB Ep %d disable\n ", ep->epnumber);
> +	/* Disable the endpoint.*/
> +	epcfg =3D udc->read_fn(udc->base_address + ep->offset);
> +	epcfg &=3D ~XUSB_EP_CFG_VALID_MASK;
> +	udc->write_fn(udc->base_address, ep->offset, epcfg);
> +
> +	spin_unlock_irqrestore(&udc->lock, flags);
> +	return 0;
> +}
> +
> +/**
> + * xudc_ep_alloc_request - Initializes the request queue.
> + * @_ep: pointer to the usb device endpoint structure.
> + * @gfp_flags: Flags related to the request call.
> + *
> + * Return: pointer to request structure on success and a NULL on failure.
> + */
> +static struct usb_request *xudc_ep_alloc_request(struct usb_ep *_ep,
> +						 gfp_t gfp_flags)
> +{
> +	struct xusb_req *req;
> +
> +	req =3D kzalloc(sizeof(*req), gfp_flags);
> +	if (!req)
> +		return NULL;
> +	req->ep =3D to_xusb_ep(_ep);
> +	INIT_LIST_HEAD(&req->queue);
> +	return &req->usb_req;
> +}
> +
> +/**
> + * xudc_free_request - Releases the request from queue.
> + * @_ep: pointer to the usb device endpoint structure.
> + * @_req: pointer to the usb request structure.
> + */
> +static void xudc_free_request(struct usb_ep *_ep, struct usb_request *_r=
eq)
> +{
> +	struct xusb_req *req =3D to_xusb_req(_req);
> +
> +	kfree(req);
> +}
> +
> +/**
> + * xudc_ep_queue - Adds the request to the queue.
> + * @_ep: pointer to the usb device endpoint structure.
> + * @_req: pointer to the usb request structure.
> + * @gfp_flags: Flags related to the request call.
> + *
> + * Return: 0 for success and error value on failure
> + */
> +static int xudc_ep_queue(struct usb_ep *_ep, struct usb_request *_req,
> +			 gfp_t gfp_flags)
> +{
> +	struct xusb_req *req;
> +	struct xusb_ep *ep;
> +	unsigned long flags;
> +	u32 length, count;
> +	u8 *corebuf;
> +	struct xusb_udc *udc;
> +
> +	req =3D to_xusb_req(_req);
> +	ep =3D to_xusb_ep(_ep);
> +
> +	if (!_req || !_req->complete || !_req->buf
> +			|| !list_empty(&req->queue)) {
> +		DBG("invalid request\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!_ep || (!ep->desc && ep->ep_usb.name !=3D ep0name)) {
> +		DBG("invalid ep\n");
> +		return -EINVAL;
> +	}
> +
> +	udc =3D ep->udc;
> +	if (!udc || !udc->driver || udc->gadget.speed =3D=3D USB_SPEED_UNKNOWN)=
 {
> +		DBG("bogus device state\n");
> +		return -EINVAL;
> +	}
> +	spin_lock_irqsave(&udc->lock, flags);
> +
> +	_req->status =3D -EINPROGRESS;
> +	_req->actual =3D 0;
> +	/* Try to kickstart any empty and idle queue */
> +	if (list_empty(&ep->queue)) {
> +		if (!ep->epnumber) {
> +			ep->data =3D req;
> +			if (udc->ch9cmd.setup.bRequestType & USB_DIR_IN) {
> +				udc->ch9cmd.wrtptr =3D req->usb_req.buf +
> +							req->usb_req.actual;
> +				prefetch(udc->ch9cmd.wrtptr);
> +				length =3D req->usb_req.length -
> +						req->usb_req.actual;
> +				corebuf =3D (void __force *) ((ep->rambase << 2) +
> +					    ep->udc->base_address);
> +				udc->ch9cmd.writecount =3D length;
> +				length =3D count =3D min_t(u32, length,
> +							EP0_MAX_PACKET);
> +				while (length--)
> +					*corebuf++ =3D *udc->ch9cmd.wrtptr++;
> +				udc->write_fn(udc->base_address,
> +						XUSB_EP_BUF0COUNT_OFFSET,
> +						count);
> +				udc->write_fn(udc->base_address,
> +						XUSB_BUFFREADY_OFFSET, 1);
> +				udc->ch9cmd.writecount -=3D count;
> +			} else {
> +				if (udc->ch9cmd.setup.wLength) {
> +					udc->ch9cmd.readptr =3D
> +						req->usb_req.buf +
> +							req->usb_req.actual;
> +					udc->write_fn(udc->base_address,
> +						  XUSB_EP_BUF0COUNT_OFFSET,
> +						  req->usb_req.length);
> +					udc->write_fn(udc->base_address,
> +						  XUSB_BUFFREADY_OFFSET, 1);
> +				} else {
> +					xudc_wrstatus(udc);
> +					req =3D NULL;
> +				}
> +			}
> +		} else {
> +			if (ep->is_in) {
> +				VDBG("xudc_write_fifo called from queue\n");
> +				if (xudc_write_fifo(ep, req) =3D=3D 1)
> +					req =3D NULL;
> +			} else {
> +				VDBG("xudc_read_fifo called from queue\n");
> +				if (xudc_read_fifo(ep, req) =3D=3D 1)
> +					req =3D NULL;
> +			}
> +		}
> +	}

looks like you need some refactoring here to avoid deep indentations.

> +	if (req !=3D NULL)
> +		list_add_tail(&req->queue, &ep->queue);
> +
> +	spin_unlock_irqrestore(&udc->lock, flags);
> +	return 0;
> +}
> +
> +/**
> + * xudc_ep_dequeue - Removes the request from the queue.
> + * @_ep: pointer to the usb device endpoint structure.
> + * @_req: pointer to the usb request structure.
> + *
> + * Return: 0 for success and error value on failure
> + */
> +static int xudc_ep_dequeue(struct usb_ep *_ep, struct usb_request *_req)
> +{
> +	struct xusb_ep *ep;
> +	struct xusb_req *req;
> +	unsigned long flags;
> +
> +	ep =3D to_xusb_ep(_ep);
> +
> +	if (!_ep || ep->ep_usb.name =3D=3D ep0name)
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(&ep->udc->lock, flags);
> +	/* Make sure it's actually queued on this endpoint */
> +	list_for_each_entry(req, &ep->queue, queue) {
> +		if (&req->usb_req =3D=3D _req)
> +			break;
> +	}
> +	if (&req->usb_req !=3D _req) {
> +		spin_unlock_irqrestore(&ep->udc->lock, flags);
> +		return -EINVAL;
> +	}
> +
> +	xudc_done(ep, req, -ECONNRESET);
> +	spin_unlock_irqrestore(&ep->udc->lock, flags);
> +
> +	return 0;
> +}
> +
> +static struct usb_ep_ops xusb_ep_ops =3D {
> +	.enable =3D xudc_ep_enable,
> +	.disable =3D xudc_ep_disable,
> +
> +	.alloc_request =3D xudc_ep_alloc_request,
> +	.free_request =3D xudc_free_request,
> +
> +	.queue =3D xudc_ep_queue,
> +	.dequeue =3D xudc_ep_dequeue,
> +	.set_halt =3D xudc_ep_set_halt,
> +};
> +
> +/**
> + * xudc_get_frame - Reads the current usb frame number.
> + * @gadget: pointer to the usb gadget structure.
> + *
> + * Return: current frame number for success and error value on failure.
> + */
> +static int xudc_get_frame(struct usb_gadget *gadget)
> +{
> +
> +	struct xusb_udc *udc =3D to_udc(gadget);
> +	unsigned long flags;
> +	int retval;
> +
> +	if (!gadget)
> +		return -ENODEV;

oh boy... so you first deref gadget, then you check for it ?

> +	local_irq_save(flags);
> +	retval =3D udc->read_fn(udc->base_address + XUSB_FRAMENUM_OFFSET);
> +	local_irq_restore(flags);

yeah I'm not a big fan of anybody messing with local_irq_*.

> +	return retval;
> +}
> +
> +/**
> + * xudc_wakeup - Send remote wakeup signal to host
> + * @gadget: pointer to the usb gadget structure.
> + *
> + * Return: 0 on success and error on failure
> + */
> +
> +static int xudc_wakeup(struct usb_gadget *gadget)
> +{
> +	struct xusb_udc *udc =3D to_udc(gadget);
> +	u32             crtlreg;
> +	int             status =3D -EINVAL;
> +	unsigned long   flags;
> +
> +	spin_lock_irqsave(&udc->lock, flags);
> +
> +	/* Remote wake up not enabled by host */
> +	if (!udc->remote_wkp)
> +		goto done;
> +
> +	crtlreg =3D udc->read_fn(udc->base_address + XUSB_CONTROL_OFFSET);
> +	/* set remote wake up bit */
> +	udc->write_fn(udc->base_address, XUSB_CONTROL_OFFSET, crtlreg |
> +			XUSB_CONTROL_USB_RMTWAKE_MASK);
> +	/* wait for a while and reset remote wake up bit */
> +	mdelay(2);

why 2 ms ? why not 5 ? why not 1 ? shouldn't you be polling a bit in a
register or something ?

> +	udc->write_fn(udc->base_address, XUSB_CONTROL_OFFSET, crtlreg &
> +			~XUSB_CONTROL_USB_RMTWAKE_MASK);
> +	status =3D 0;
> +done:
> +	spin_unlock_irqrestore(&udc->lock, flags);
> +	return status;
> +}
> +
> +/**
> + * xudc_reinit - Restores inital software state.
> + * @udc: pointer to the usb device controller structure.
> + */
> +static void xudc_reinit(struct xusb_udc *udc)
> +{
> +	u32 ep_number;
> +	char name[4];
> +
> +	INIT_LIST_HEAD(&udc->gadget.ep_list);
> +
> +	for (ep_number =3D 0; ep_number < XUSB_MAX_ENDPOINTS; ep_number++) {
> +		struct xusb_ep *ep =3D &udc->ep[ep_number];
> +
> +		if (ep_number) {
> +			list_add_tail(&ep->ep_usb.ep_list,
> +					&udc->gadget.ep_list);
> +			ep->ep_usb.maxpacket =3D (unsigned short)~0;
> +			sprintf(name, "ep%d", ep_number);
> +			strcpy(ep->name, name);
> +			ep->ep_usb.name =3D ep->name;
> +		} else {
> +			ep->ep_usb.name =3D ep0name;
> +			ep->ep_usb.maxpacket =3D 0x40;
> +		}
> +
> +		ep->ep_usb.ops =3D &xusb_ep_ops;
> +		ep->udc =3D udc;
> +		ep->epnumber =3D ep_number;
> +		ep->desc =3D NULL;
> +		ep->stopped =3D 0;
> +		/*
> +		 * The configuration register address offset between
> +		 * each endpoint is 0x10.
> +		 */
> +		ep->offset =3D XUSB_EP0_CONFIG_OFFSET +
> +					(ep_number * 0x10);
> +		ep->is_in =3D 0;
> +		ep->is_iso =3D 0;
> +		ep->maxpacket =3D 0;
> +		xudc_epconfig(ep, udc);
> +
> +		/* Initialize one queue per endpoint */
> +		INIT_LIST_HEAD(&ep->queue);
> +	}
> +}
> +
> +/**
> + * xudc_stop_activity - Stops any further activity on the device.
> + * @udc: pointer to the usb device controller structure.
> + */
> +static void xudc_stop_activity(struct xusb_udc *udc)
> +{
> +	int i;
> +	struct xusb_ep *ep;
> +
> +	for (i =3D 0; i < XUSB_MAX_ENDPOINTS; i++) {
> +		ep =3D &udc->ep[i];
> +		xudc_nuke(ep, -ESHUTDOWN);
> +	}
> +}
> +
> +/**
> + * xudc_start - Starts the device.
> + * @gadget: pointer to the usb gadget structure
> + * @driver: pointer to gadget driver structure
> + *
> + * Return: zero always
> + */
> +static int xudc_start(struct usb_gadget *gadget,
> +			struct usb_gadget_driver *driver)
> +{
> +	struct xusb_udc *udc =3D to_udc(gadget);
> +	const struct usb_endpoint_descriptor *d =3D &config_bulk_out_desc;
> +	u32 crtlreg;
> +
> +	driver->driver.bus =3D NULL;
> +	/* hook up the driver */
> +	udc->driver =3D driver;
> +	udc->gadget.dev.driver =3D &driver->driver;
> +	udc->gadget.speed =3D driver->max_speed;
> +
> +	/* Enable the control endpoint. */
> +	xudc_ep_enable(&udc->ep[XUSB_EP_NUMBER_ZERO].ep_usb, d);
> +	/* Set Address to zero */
> +	udc->write_fn(udc->base_address, XUSB_ADDRESS_OFFSET, 0);
> +	/* Start device */
> +	crtlreg =3D udc->read_fn(udc->base_address + XUSB_CONTROL_OFFSET);
> +	crtlreg |=3D XUSB_CONTROL_USB_READY_MASK;
> +	udc->write_fn(udc->base_address, XUSB_CONTROL_OFFSET, crtlreg);
> +
> +	return 0;
> +}
> +
> +/**
> + * xudc_stop - stops the device.
> + * @gadget: pointer to the usb gadget structure
> + * @driver: pointer to usb gadget driver structure
> + *
> + * Return: zero always
> + */
> +static int xudc_stop(struct usb_gadget *gadget,
> +		struct usb_gadget_driver *driver)
> +{
> +	struct xusb_udc *udc =3D to_udc(gadget);
> +	unsigned long flags;
> +	u32 crtlreg;
> +
> +	/* Disable USB device.*/
> +	crtlreg =3D udc->read_fn(udc->base_address + XUSB_CONTROL_OFFSET);
> +	crtlreg &=3D ~XUSB_CONTROL_USB_READY_MASK;
> +	udc->write_fn(udc->base_address, XUSB_CONTROL_OFFSET, crtlreg);
> +	spin_lock_irqsave(&udc->lock, flags);
> +	udc->gadget.speed =3D USB_SPEED_UNKNOWN;
> +	xudc_stop_activity(udc);
> +	spin_unlock_irqrestore(&udc->lock, flags);
> +
> +	udc->gadget.dev.driver =3D NULL;
> +	udc->driver =3D NULL;
> +
> +	return 0;
> +}
> +
> +static const struct usb_gadget_ops xusb_udc_ops =3D {
> +	.get_frame =3D xudc_get_frame,
> +	.wakeup =3D xudc_wakeup,
> +	.udc_start =3D xudc_start,
> +	.udc_stop  =3D xudc_stop,

no pullup ??? What gives ? This HW doesn't support it ? really ?

> +static void xudc_startup_handler(struct xusb_udc *udc, u32 intrstatus)
> +{
> +	u32 intrreg;
> +
> +	if (intrstatus & XUSB_STATUS_RESET_MASK) {
> +
> +		DBG("Reset\n");
> +
> +		if (intrstatus & XUSB_STATUS_HIGH_SPEED_MASK)
> +			udc->gadget.speed =3D USB_SPEED_HIGH;
> +		else
> +			udc->gadget.speed =3D USB_SPEED_FULL;
> +
> +		/* Set device address and remote wakeup to 0 */
> +		udc->write_fn(udc->base_address, XUSB_ADDRESS_OFFSET, 0);
> +		udc->remote_wkp =3D 0;
> +
> +		/* Enable the suspend and resume */
> +		intrreg =3D udc->read_fn(udc->base_address + XUSB_IER_OFFSET);
> +		intrreg |=3D XUSB_STATUS_SUSPEND_MASK | XUSB_STATUS_RESUME_MASK;
> +		udc->write_fn(udc->base_address, XUSB_IER_OFFSET, intrreg);
> +
> +		xudc_stop_activity(udc);

you need to conditionally call gadget_driver->disconnect(), you also
need to make sure test modes are cleared, clear all stalls, etc.

> +	}
> +	if (intrstatus & XUSB_STATUS_SUSPEND_MASK) {
> +
> +		DBG("Suspend\n");
> +
> +		/* Enable the reset and resume */
> +		intrreg =3D udc->read_fn(udc->base_address + XUSB_IER_OFFSET);
> +		intrreg |=3D XUSB_STATUS_RESET_MASK | XUSB_STATUS_RESUME_MASK;
> +		udc->write_fn(udc->base_address, XUSB_IER_OFFSET, intrreg);
> +		udc->usb_state =3D USB_STATE_SUSPENDED;
> +
> +		if (udc->driver->suspend)
> +			udc->driver->suspend(&udc->gadget);
> +	}

when are you going to call driver->resume() ??

> +static void xudc_getstatus(struct xusb_udc *udc)
> +{
> +	u16 status =3D 0;
> +	u32 epcfgreg;
> +	struct xusb_ep *ep0;
> +	int epnum;
> +	struct xusb_ep *ep;
> +	u32 halt;
> +	u32 *corebuf;
> +
> +	ep0 =3D &udc->ep[XUSB_EP_NUMBER_ZERO];
> +	switch (udc->ch9cmd.setup.bRequestType & USB_RECIP_MASK) {
> +	case USB_RECIP_DEVICE:
> +		/* Get device status */
> +		status =3D 1 << USB_DEVICE_SELF_POWERED;
> +		if (udc->remote_wkp)
> +			status |=3D (1 << USB_DEVICE_REMOTE_WAKEUP);
> +		break;
> +	case USB_RECIP_INTERFACE:
> +		break;
> +	case USB_RECIP_ENDPOINT:
> +		epnum =3D udc->ch9cmd.setup.wIndex & USB_ENDPOINT_NUMBER_MASK;
> +		ep =3D &udc->ep[epnum];
> +		epcfgreg =3D udc->read_fn(udc->base_address +
> +				udc->ep[epnum].offset);
> +		halt =3D epcfgreg & XUSB_EP_CFG_STALL_MASK;
> +		if (udc->ch9cmd.setup.wIndex & USB_DIR_IN) {
> +			if (!ep->is_in)
> +				goto stall;
> +		} else {
> +			if (ep->is_in)
> +				goto stall;
> +		}
> +		if (halt)
> +			status =3D 1 << USB_ENDPOINT_HALT;
> +		break;
> +	default:
> +		goto stall;
> +	}
> +
> +	udc->ch9cmd.writecount =3D 0;
> +	corebuf =3D (void __force *) ((ep0->rambase << 2) + udc->base_address);
> +	status =3D cpu_to_le16(status);
> +	memcpy((void *)corebuf, (void *)&status, 2);
> +	udc->write_fn(udc->base_address, XUSB_EP_BUF0COUNT_OFFSET, 2);
> +	udc->write_fn(udc->base_address, XUSB_BUFFREADY_OFFSET, 1);
> +	return;
> +stall:
> +	dev_err(&udc->gadget.dev, "Can't respond to getstatus request\n");
> +	xudc_ep0_stall(udc);
> +	return;
> +}
> +
> +/**
> + * xudc_set_clear_feature - Executes the set feature and clear feature c=
ommands.
> + * @udc: pointer to the usb device controller structure.
> + *
> + * Processes the SET_FEATURE and CLEAR_FEATURE commands.
> + */
> +static void xudc_set_clear_feature(struct xusb_udc *udc)
> +{
> +	u8 endpoint;
> +	u8 outinbit;
> +	u32 epcfgreg;
> +	int flag =3D (udc->ch9cmd.setup.bRequest =3D=3D USB_REQ_SET_FEATURE ? 1=
 : 0);
> +	switch (udc->ch9cmd.setup.bRequestType) {
> +	case USB_RECIP_DEVICE:
> +		switch (udc->ch9cmd.setup.wValue) {
> +		case USB_DEVICE_TEST_MODE:
> +			/*
> +			 * The Test Mode will be executed
> +			 * after the status phase.
> +			 */
> +			break;
> +		case USB_DEVICE_REMOTE_WAKEUP:
> +			if (flag)
> +				udc->remote_wkp =3D 1;
> +			else
> +				udc->remote_wkp =3D 0;
> +			break;
> +		default:
> +			xudc_ep0_stall(udc);
> +			break;
> +		}
> +		break;
> +	case USB_RECIP_ENDPOINT:
> +		if (!udc->ch9cmd.setup.wValue) {
> +			endpoint =3D udc->ch9cmd.setup.wIndex &
> +					USB_ENDPOINT_NUMBER_MASK;
> +			outinbit =3D udc->ch9cmd.setup.wIndex &
> +					USB_ENDPOINT_DIR_MASK;
> +			outinbit =3D outinbit >> 7;
> +
> +			/* Make sure direction matches.*/
> +			if (outinbit !=3D udc->ep[endpoint].is_in) {
> +				xudc_ep0_stall(udc);
> +				return;
> +			}
> +			epcfgreg =3D udc->read_fn(udc->base_address +
> +						udc->ep[endpoint].
> +						offset);
> +			if (!endpoint) {
> +				/* Clear the stall.*/
> +				epcfgreg &=3D ~XUSB_EP_CFG_STALL_MASK;
> +				udc->write_fn(udc->base_address,
> +						udc->ep[endpoint].offset,
> +						epcfgreg);
> +			} else {
> +				if (flag) {
> +					epcfgreg |=3D XUSB_EP_CFG_STALL_MASK;
> +					udc->write_fn(udc->base_address,
> +							udc->ep[endpoint].
> +							offset, epcfgreg);
> +				} else {
> +					/* Unstall the endpoint.*/
> +					epcfgreg &=3D ~(XUSB_EP_CFG_STALL_MASK |
> +						  XUSB_EP_CFG_DATA_TOGGLE_MASK);
> +					udc->write_fn(udc->base_address,
> +							udc->ep[endpoint].
> +							offset, epcfgreg);
> +				}
> +			}
> +		}
> +		break;
> +	default:
> +		xudc_ep0_stall(udc);
> +		return;
> +	}
> +	/* Cause and valid status phase to be issued.*/
> +	xudc_wrstatus(udc);
> +	return;
> +}
> +
> +/**
> + * xudc_reset_ep0 - reset ep0 request
> + * @ep0: pointer to the endpoint structure.
> + *
> + * Resets endpoint 0 request.
> + */
> +static void xudc_reset_ep0(struct xusb_ep *ep0)
> +{
> +	ep0->no_queue =3D 0;
> +	xudc_nuke(ep0, -ECONNRESET);
> +}
> +
> +/**
> + * xudc_handle_setup - Processes the setup packet.
> + * @udc: pointer to the usb device controller structure.
> + * @setup: pointer to the usb control request structure.
> + *
> + * Process setup packet and delegate to gadget layer.
> + */
> +static void xudc_handle_setup(struct xusb_udc *udc,
> +				struct usb_ctrlrequest *setup)
> +{
> +	u32 *ep0rambase;
> +	struct xusb_ep *ep0 =3D &udc->ep[XUSB_EP_NUMBER_ZERO];
> +
> +	/* Load up the chapter 9 command buffer.*/
> +	ep0rambase =3D (u32 __force *) (udc->base_address +
> +				  XUSB_SETUP_PKT_ADDR_OFFSET);
> +	memcpy((void *)&udc->ch9cmd.setup, (void *)ep0rambase, 8);
> +
> +	setup->bRequestType =3D udc->ch9cmd.setup.bRequestType;
> +	setup->bRequest     =3D udc->ch9cmd.setup.bRequest;
> +	setup->wValue       =3D udc->ch9cmd.setup.wValue;
> +	setup->wIndex       =3D udc->ch9cmd.setup.wIndex;
> +	setup->wLength      =3D udc->ch9cmd.setup.wLength;
> +
> +	udc->ch9cmd.setup.wValue =3D cpu_to_le16(udc->ch9cmd.setup.wValue);
> +	udc->ch9cmd.setup.wIndex =3D cpu_to_le16(udc->ch9cmd.setup.wIndex);
> +	udc->ch9cmd.setup.wLength =3D cpu_to_le16(udc->ch9cmd.setup.wLength);
> +
> +	/* Restore ReadPtr to data buffer.*/
> +	udc->ch9cmd.readptr =3D &udc->ch9cmd.readbuff[0];
> +	udc->ch9cmd.readcount =3D 0;
> +
> +	if (udc->ch9cmd.setup.bRequestType & USB_DIR_IN) {
> +		/* Execute the get command.*/
> +		udc->ch9cmd.setupseqrx =3D STATUS_PHASE;
> +		udc->ch9cmd.setupseqtx =3D DATA_PHASE;
> +	} else {
> +		/* Execute the put command.*/
> +		udc->ch9cmd.setupseqrx =3D DATA_PHASE;
> +		udc->ch9cmd.setupseqtx =3D STATUS_PHASE;
> +	}
> +
> +	xudc_reset_ep0(ep0);
> +
> +	switch (udc->ch9cmd.setup.bRequest) {
> +	case USB_REQ_GET_STATUS:
> +		/* Data+Status phase form udc */
> +		if ((udc->ch9cmd.setup.bRequestType &
> +				(USB_DIR_IN | USB_TYPE_MASK)) !=3D
> +				(USB_DIR_IN | USB_TYPE_STANDARD))
> +			break;
> +		ep0->no_queue =3D 1;
> +		xudc_getstatus(udc);
> +		return;
> +	case USB_REQ_SET_ADDRESS:
> +		/* Status phase from udc */
> +		if (udc->ch9cmd.setup.bRequestType !=3D (USB_DIR_OUT |
> +				USB_TYPE_STANDARD | USB_RECIP_DEVICE))
> +			break;
> +		ep0->no_queue =3D 1;
> +		xudc_wrstatus(udc);
> +		return;
> +	case USB_REQ_CLEAR_FEATURE:
> +	case USB_REQ_SET_FEATURE:
> +		/* Requests with no data phase, status phase from udc */
> +		if ((udc->ch9cmd.setup.bRequestType & USB_TYPE_MASK)
> +				!=3D USB_TYPE_STANDARD)
> +			break;
> +		ep0->no_queue =3D 1;
> +		xudc_set_clear_feature(udc);
> +		return;
> +	default:
> +		break;
> +	}
> +
> +	spin_unlock(&udc->lock);
> +	if (udc->driver->setup(&udc->gadget, setup) < 0)
> +		xudc_ep0_stall(udc);
> +	spin_lock(&udc->lock);
> +}
> +
> +/**
> + * xudc_ep0_out - Processes the endpoint 0 OUT token.
> + * @udc: pointer to the usb device controller structure.
> + */
> +static void xudc_ep0_out(struct xusb_udc *udc)
> +{
> +	struct xusb_ep *ep;
> +	u8 count;
> +	u8 *ep0rambase;
> +	u16 index;
> +
> +	ep =3D &udc->ep[0];
> +	switch (udc->ch9cmd.setupseqrx) {
> +	case STATUS_PHASE:
> +		/*
> +		 * This resets both state machines for the next
> +		 * Setup packet.
> +		 */
> +		udc->ch9cmd.setupseqrx =3D SETUP_PHASE;
> +		udc->ch9cmd.setupseqtx =3D SETUP_PHASE;
> +		if (!ep->no_queue) {
> +			ep->data->usb_req.actual =3D ep->data->usb_req.length;
> +			xudc_done(ep, ep->data, 0);
> +		}
> +		ep->no_queue =3D 0;
> +		break;
> +	case DATA_PHASE:
> +		count =3D udc->read_fn(udc->base_address +
> +				XUSB_EP_BUF0COUNT_OFFSET);
> +		/* Copy the data to be received from the DPRAM. */
> +		ep0rambase =3D
> +			(u8 __force *) (udc->base_address +
> +				(udc->ep[XUSB_EP_NUMBER_ZERO].rambase << 2));
> +
> +		for (index =3D 0; index < count; index++)
> +			*udc->ch9cmd.readptr++ =3D *ep0rambase++;
> +
> +		udc->ch9cmd.readcount +=3D count;
> +		if (udc->ch9cmd.setup.wLength =3D=3D udc->ch9cmd.readcount) {
> +			xudc_wrstatus(udc);
> +		} else {
> +			/* Set the Tx packet size and the Tx enable bit.*/
> +			udc->write_fn(udc->base_address,
> +					XUSB_EP_BUF0COUNT_OFFSET, 0);
> +			udc->write_fn(udc->base_address,
> +					XUSB_BUFFREADY_OFFSET, 1);
> +		}
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
> +/**
> + * xudc_ep0_in - Processes the endpoint 0 IN token.
> + * @udc: pointer to the usb device controller structure.
> + */
> +static void xudc_ep0_in(struct xusb_udc *udc)
> +{
> +	struct xusb_ep *ep;
> +	u32 epcfgreg;
> +	u16 count;
> +	u16 length;
> +	u8 *ep0rambase;
> +
> +	ep =3D &udc->ep[0];
> +	switch (udc->ch9cmd.setupseqtx) {
> +	case STATUS_PHASE:
> +		switch (udc->ch9cmd.setup.bRequest) {
> +		case USB_REQ_SET_ADDRESS:
> +			/* Set the address of the device.*/
> +			udc->write_fn(udc->base_address,
> +					XUSB_ADDRESS_OFFSET,
> +					udc->ch9cmd.setup.wValue);
> +			break;
> +		case USB_REQ_SET_FEATURE:
> +			if (udc->ch9cmd.setup.bRequestType =3D=3D
> +					USB_RECIP_DEVICE) {
> +				if (udc->ch9cmd.setup.wValue =3D=3D
> +						USB_DEVICE_TEST_MODE)
> +					udc->write_fn(udc->base_address,
> +							XUSB_TESTMODE_OFFSET,
> +							TEST_J);
> +			}
> +			break;
> +		}
> +		if (!ep->no_queue) {
> +			ep->data->usb_req.actual =3D udc->ch9cmd.setup.wLength;
> +			xudc_done(ep, ep->data, 0);
> +		}
> +		ep->no_queue =3D 0;
> +		break;
> +	case DATA_PHASE:
> +		if (!udc->ch9cmd.writecount) {
> +			/*
> +			 * We're done with data transfer, next
> +			 * will be zero length OUT with data toggle of
> +			 * 1. Setup data_toggle.
> +			 */
> +			epcfgreg =3D udc->read_fn(udc->base_address +
> +				udc->ep[XUSB_EP_NUMBER_ZERO].offset);
> +			epcfgreg |=3D XUSB_EP_CFG_DATA_TOGGLE_MASK;
> +			udc->write_fn(udc->base_address,
> +				udc->ep[XUSB_EP_NUMBER_ZERO].offset, epcfgreg);
> +			count =3D 0;
> +			udc->ch9cmd.setupseqtx =3D STATUS_PHASE;
> +		} else {
> +			length =3D count =3D min_t(u32, udc->ch9cmd.writecount,
> +						EP0_MAX_PACKET);
> +			/* Copy the data to be transmitted into the DPRAM. */
> +			ep0rambase =3D (u8 __force *) (udc->base_address +
> +				(udc->ep[XUSB_EP_NUMBER_ZERO].rambase << 2));
> +			while (length--)
> +				*ep0rambase++ =3D *udc->ch9cmd.wrtptr++;
> +
> +			udc->ch9cmd.writecount -=3D count;
> +		}
> +		udc->write_fn(udc->base_address, XUSB_EP_BUF0COUNT_OFFSET,
> +				count);
> +		udc->write_fn(udc->base_address, XUSB_BUFFREADY_OFFSET, 1);
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
> +/**
> + * xudc_ctrl_ep_handler - Endpoint 0 interrupt handler.
> + * @udc: pointer to the udc structure.
> + * @intrstatus:	It's the mask value for the interrupt sources on endpoin=
t 0.
> + *
> + * Processes the commands received during enumeration phase.
> + */
> +static void xudc_ctrl_ep_handler(struct xusb_udc *udc, u32 intrstatus)
> +{
> +	struct usb_ctrlrequest ctrl;
> +
> +	if (intrstatus & XUSB_STATUS_SETUP_PACKET_MASK) {
> +		xudc_handle_setup(udc, &ctrl);
> +	} else {
> +		if (intrstatus & XUSB_STATUS_FIFO_BUFF_RDY_MASK)
> +			xudc_ep0_out(udc);
> +		else if (intrstatus & XUSB_STATUS_FIFO_BUFF_FREE_MASK)
> +			xudc_ep0_in(udc);
> +	}
> +}
> +
> +/**
> + * xudc_nonctrl_ep_handler - Non control endpoint interrupt handler.
> + * @udc: pointer to the udc structure.
> + * @epnum: End point number for which the interrupt is to be processed
> + * @intrstatus:	mask value for interrupt sources of endpoints other
> + *		than endpoint 0.
> + *
> + * Processes the buffer completion interrupts.
> + */
> +static void xudc_nonctrl_ep_handler(struct xusb_udc *udc, u8 epnum,
> +					u32 intrstatus)
> +{
> +
> +	struct xusb_req *req;
> +	struct xusb_ep *ep;
> +
> +	ep =3D &udc->ep[epnum];
> +	/* Process the End point interrupts.*/
> +	if (intrstatus & (XUSB_STATUS_EP0_BUFF1_COMP_MASK << epnum))
> +		ep->buffer0ready =3D 0;
> +	if (intrstatus & (XUSB_STATUS_EP0_BUFF2_COMP_MASK << epnum))
> +		ep->buffer1ready =3D 0;
> +
> +	if (list_empty(&ep->queue))
> +		req =3D NULL;
> +	else
> +		req =3D list_entry(ep->queue.next, struct xusb_req, queue);
> +	if (!req)
> +		return;
> +
> +	if (ep->is_in)
> +		xudc_write_fifo(ep, req);
> +	else
> +		xudc_read_fifo(ep, req);
> +}
> +
> +/**
> + * xudc_irq - The main interrupt handler.
> + * @irq: The interrupt number.
> + * @_udc: pointer to the usb device controller structure.
> + *
> + * Return: IRQ_HANDLED after the interrupt is handled.
> + */
> +static irqreturn_t xudc_irq(int irq, void *_udc)
> +{
> +	struct xusb_udc *udc =3D _udc;
> +	u32 intrstatus;
> +	u32 intrreg;
> +	u8 index;
> +	u32 bufintr;
> +
> +	spin_lock(&(udc->lock));
> +
> +	intrreg =3D udc->read_fn(udc->base_address + XUSB_IER_OFFSET);
> +	intrreg &=3D ~XUSB_STATUS_INTR_EVENT_MASK;
> +	udc->write_fn(udc->base_address, XUSB_IER_OFFSET, intrreg);
> +
> +	/* Read the Interrupt Status Register.*/
> +	intrstatus =3D udc->read_fn(udc->base_address + XUSB_STATUS_OFFSET);
> +
> +	if (udc->usb_state =3D=3D USB_STATE_SUSPENDED) {
> +
> +		DBG("Resume\n");
> +
> +		if (intrstatus & XUSB_STATUS_RESUME_MASK) {
> +			/* Enable the reset and suspend */
> +			intrreg =3D udc->read_fn(udc->base_address +
> +						XUSB_IER_OFFSET);
> +			intrreg |=3D XUSB_STATUS_RESET_MASK |
> +					XUSB_STATUS_SUSPEND_MASK;
> +			udc->write_fn(udc->base_address, XUSB_IER_OFFSET,
> +					intrreg);
> +		}
> +		udc->usb_state =3D 0;
> +
> +		if (udc->driver->resume)
> +			udc->driver->resume(&udc->gadget);
> +	}
> +
> +	/* Call the handler for the event interrupt.*/
> +	if (intrstatus & XUSB_STATUS_INTR_EVENT_MASK) {
> +		/*
> +		 * Check if there is any action to be done for :
> +		 * - USB Reset received {XUSB_STATUS_RESET_MASK}
> +		 * - USB Suspend received {XUSB_STATUS_SUSPEND_MASK}
> +		 */
> +		xudc_startup_handler(udc, intrstatus);
> +	}
> +
> +	/* Check the buffer completion interrupts */
> +	if (intrstatus & XUSB_STATUS_INTR_BUFF_COMP_ALL_MASK) {
> +		/* Enable Reset and Suspend */
> +		intrreg =3D udc->read_fn(udc->base_address + XUSB_IER_OFFSET);
> +		intrreg |=3D XUSB_STATUS_SUSPEND_MASK | XUSB_STATUS_RESET_MASK;
> +		udc->write_fn(udc->base_address, XUSB_IER_OFFSET, intrreg);
> +
> +		if (intrstatus & XUSB_STATUS_EP0_BUFF1_COMP_MASK)
> +			xudc_ctrl_ep_handler(udc, intrstatus);
> +
> +		for (index =3D 1; index < 8; index++) {
> +			bufintr =3D ((intrstatus &
> +					(XUSB_STATUS_EP1_BUFF1_COMP_MASK <<
> +							(index - 1))) ||
> +				   (intrstatus &
> +					(XUSB_STATUS_EP1_BUFF2_COMP_MASK <<
> +							(index - 1))));
> +			if (bufintr)
> +				xudc_nonctrl_ep_handler(udc, index,
> +						intrstatus);
> +		}
> +	}
> +	spin_unlock(&(udc->lock));
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/**
> + * xudc_probe - The device probe function for driver initialization.
> + * @pdev: pointer to the platform device structure.
> + *
> + * Return: 0 for success and error value on failure
> + */
> +static int xudc_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np =3D pdev->dev.of_node;
> +	struct resource *res;
> +	struct xusb_udc *udc;
> +	int irq;
> +	int ret;
> +
> +	udc =3D devm_kzalloc(&pdev->dev, sizeof(*udc), GFP_KERNEL);
> +	if (!udc)
> +		return -ENOMEM;
> +
> +	/* Map the registers */
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	udc->base_address =3D devm_ioremap_resource(&pdev->dev, res);
> +	if (!udc->base_address)
> +		return -ENOMEM;
> +
> +	irq =3D platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(&pdev->dev, "unable to get irq\n");
> +		return irq;
> +	}
> +	ret =3D devm_request_irq(&pdev->dev, irq, xudc_irq, 0,
> +				dev_name(&pdev->dev), udc);
> +	if (ret < 0) {
> +		dev_dbg(&pdev->dev, "unable to request irq %d", irq);
> +		goto fail;
> +	}
> +
> +	udc->dma_enabled =3D of_property_read_bool(np, "xlnx,has-builtin-dma");
> +
> +	/* Setup gadget structure */
> +	udc->gadget.ops =3D &xusb_udc_ops;
> +	udc->gadget.max_speed =3D USB_SPEED_HIGH;
> +	udc->gadget.speed =3D USB_SPEED_UNKNOWN;
> +	udc->gadget.ep0 =3D &udc->ep[XUSB_EP_NUMBER_ZERO].ep_usb;
> +	udc->gadget.name =3D driver_name;
> +
> +	dev_set_name(&udc->gadget.dev, "xilinx_udc");

this line isn't necessary.

> +	spin_lock_init(&udc->lock);
> +
> +	/* Check for IP endianness */
> +	udc->write_fn =3D xudc_write32_be;
> +	udc->read_fn =3D xudc_read32_be;
> +	udc->write_fn(udc->base_address, XUSB_TESTMODE_OFFSET, TEST_J);
> +	if ((udc->read_fn(udc->base_address + XUSB_TESTMODE_OFFSET))
> +			!=3D TEST_J) {
> +		udc->write_fn =3D xudc_write32;
> +		udc->read_fn =3D xudc_read32;
> +	}

hmm... isn't there a configuration register to check this out ?

> +	udc->write_fn(udc->base_address, XUSB_TESTMODE_OFFSET, 0);
> +
> +	xudc_reinit(udc);
> +
> +	/* Set device address to 0.*/
> +	udc->write_fn(udc->base_address, XUSB_ADDRESS_OFFSET, 0);
> +
> +	ret =3D usb_add_gadget_udc(&pdev->dev, &udc->gadget);
> +	if (ret)
> +		goto fail;
> +
> +	/* Enable the interrupts.*/
> +	udc->write_fn(udc->base_address, XUSB_IER_OFFSET,
> +			XUSB_STATUS_GLOBAL_INTR_MASK | XUSB_STATUS_RESET_MASK |
> +			XUSB_STATUS_SUSPEND_MASK |
> +			XUSB_STATUS_RESUME_MASK |

you're enabling resume IRQ but never handling it.

> +			XUSB_STATUS_FIFO_BUFF_RDY_MASK |
> +			XUSB_STATUS_FIFO_BUFF_FREE_MASK |
> +			XUSB_STATUS_EP0_BUFF1_COMP_MASK);
> +
> +	platform_set_drvdata(pdev, udc);
> +
> +	VDBG("%s #%d at 0x%08X mapped to 0x%08X\n", driver_name, 0,
> +		(u32)res->start, (u32 __force)udc->base_address);
> +
> +	return 0;
> +
> +fail:
> +	dev_err(&pdev->dev, "probe failed, %d\n", ret);
> +	return ret;
> +}
> +
> +/**
> + * xudc_remove - Releases the resources allocated during the initializat=
ion.
> + * @pdev: pointer to the platform device structure.
> + *
> + * Return: 0 always
> + */
> +static int xudc_remove(struct platform_device *pdev)
> +{
> +	struct xusb_udc *udc =3D platform_get_drvdata(pdev);
> +
> +	dev_dbg(&pdev->dev, "remove\n");

this is *really* unnecessary.


--=20
balbi

--X3gaHHMYHkYqP6yf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTPXctAAoJEIaOsuA1yqREZKwQAKkvZgvLxfwzEKnkHjHAshBR
PuTXQ0ZncOjhLGjKsLlNX94UkdkIYIdYUTB27XswhZa0Pd8hp7B2biLxjAU/+VqV
Vtub9Aa7sxlzn4xvRqnPi6hATwjGgWrl6llFedG0aan9xEorqq9g+KuG3xEqveSA
ftilO4UmzMOfP8dIg400MZRXxKyzPzBQZK4VquKBQ56AElDxtn9UroYGOlATIDmA
RLUjlAb4i94XGkma8rBfTLI5gzAKdqZQIVGdpGLfxI/KgcNli/P/Xqj6cR+nIqxF
rNWX3isZkUgNga8g3kN9V2IRin7RK4SiBbl/bN9JOkokko/DxOp/l6/O2CJ5ZLEO
/nN/fCyDZ+G6Po410h54hwVhr2msHipp20iUy+FlH5nV6dz2SRxq1U7CB0/3oQyo
L/ZMvd+VDHduuK7VPZArGSC27BMImDhrVOVcysEMSMIAPrZLsDgWXpf4ai+bUATJ
xWqLcIcXbmlCp8g1yoBhTL9koFdyWpNkEea92NzkdWZylKzCL2DobPBRT1cGqccy
1rnyaEA3ad2x076bGbEvMnooSGB7U5DzQgZ6xxZIBzRSxQKthP+9u8RHw+MCBxTG
DJ3xcMBfjjZ0ABbclOEUcKHO5l8aVllEfT68ZacTH5vargOwJDyQ22PY89/wtuKQ
zgPapT/RQVy5JbNZA717
=B2sq
-----END PGP SIGNATURE-----

--X3gaHHMYHkYqP6yf--
