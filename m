Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbaCZKIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 06:08:00 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:36136 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaCZKHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 06:07:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140220182257.GF23217@saruman.home>
References: <774153d4-d33f-4bb4-813b-582762bc3af9@TX2EHSMHS021.ehs.local>
	<20140220182257.GF23217@saruman.home>
Date: Wed, 26 Mar 2014 15:37:52 +0530
Message-ID: <CALHRZuoF52kHH7aPd5AA3iCG9iZhCFu-2=u3_jEiSFrUOnBAew@mail.gmail.com>
Subject: Re: [PATCH RFC] usb: gadget: Add xilinx axi usb2 device support
From: sundeep subbaraya <sundeep.lkml@gmail.com>
To: balbi@ti.com
Cc: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <michals@xilinx.com>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Thu, Feb 20, 2014 at 11:53 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Wed, Feb 19, 2014 at 03:10:45PM +0530, Subbaraya Sundeep Bhatta wrote:
>> This patch adds xilinx axi usb2 device driver support
>>
>> Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
>> ---
>>  .../devicetree/bindings/usb/xilinx_usb.txt         |   21 +
>>  drivers/usb/gadget/Kconfig                         |   14 +
>>  drivers/usb/gadget/Makefile                        |    1 +
>>  drivers/usb/gadget/xilinx_udc.c                    | 2045 ++++++++++++++++++++
>>  4 files changed, 2081 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/usb/xilinx_usb.txt
>>  create mode 100644 drivers/usb/gadget/xilinx_udc.c
>>
>> diff --git a/Documentation/devicetree/bindings/usb/xilinx_usb.txt b/Documentation/devicetree/bindings/usb/xilinx_usb.txt
>> new file mode 100644
>> index 0000000..acf03ab
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/usb/xilinx_usb.txt
>> @@ -0,0 +1,21 @@
>> +Xilinx AXI USB2 device controller
>> +
>> +Required properties:
>> +- compatible         : Should be "xlnx,axi-usb2-device-4.00.a"
>> +- reg                        : Physical base address and size of the Axi USB2
>> +                       device registers map.
>> +- interrupts         : Property with a value describing the interrupt
>> +                       number.
>> +- interrupt-parent   : Must be core interrupt controller
>> +- xlnx,include-dma   : Must be 1 or 0 based on whether DMA is included
>> +                       in IP or not.
>> +
>> +Example:
>> +             axi-usb2-device@42e00000 {
>> +                        compatible = "xlnx,axi-usb2-device-4.00.a";
>> +                        interrupt-parent = <0x1>;
>> +                        interrupts = <0x0 0x39 0x1>;
>> +                        reg = <0x42e00000 0x10000>;
>> +                        xlnx,include-dma = <0x1>;
>> +                };
>> +
>
> you need to Cc devicetree@vger.kernel.org for this.
>
>> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
>> index 8154165..0b284bf 100644
>> --- a/drivers/usb/gadget/Kconfig
>> +++ b/drivers/usb/gadget/Kconfig
>> @@ -466,6 +466,20 @@ config USB_EG20T
>>         ML7213/ML7831 is companion chip for Intel Atom E6xx series.
>>         ML7213/ML7831 is completely compatible for Intel EG20T PCH.
>>
>> +config USB_GADGET_XILINX
>> +     tristate "Xilinx USB Driver"
>> +     depends on MICROBLAZE || ARCH_ZYNQ
>
> This has the tendency to grow and I really don't like seeing a bunch of
> arch-specific dependencies. At a minimum add COMPILE_TEST so I can build
> test on my setup and make sure it builds fine on other architectures.
>
>> +     help
>> +       USB peripheral controller driver for Xilinx AXI USB2 device.
>> +       Xilinx AXI USB2 device is a soft IP which supports both full
>> +       and high speed USB 2.0 data transfers. It has seven configurable
>> +       endpoints(bulk or interrupt or isochronous), as well as
>> +       endpoint zero(for control transfers).
>> +
>> +       Say "y" to link the driver statically, or "m" to build a
>> +       dynamically linked module called "xilinx_udc" and force all
>> +       gadget drivers to also be dynamically linked.
>> +
>>  #
>>  # LAST -- dummy/emulated controller
>>  #
>> diff --git a/drivers/usb/gadget/Makefile b/drivers/usb/gadget/Makefile
>> index 5f150bc..3a55564 100644
>> --- a/drivers/usb/gadget/Makefile
>> +++ b/drivers/usb/gadget/Makefile
>> @@ -36,6 +36,7 @@ obj-$(CONFIG_USB_FUSB300)   += fusb300_udc.o
>>  obj-$(CONFIG_USB_FOTG210_UDC)        += fotg210-udc.o
>>  obj-$(CONFIG_USB_MV_U3D)     += mv_u3d_core.o
>>  obj-$(CONFIG_USB_GR_UDC)     += gr_udc.o
>> +obj-$(CONFIG_USB_GADGET_XILINX)      += xilinx_udc.o
>
> let's start normalizing the names here (I'll patch the others later) and
> call this udc-xilinx.o
>
>> diff --git a/drivers/usb/gadget/xilinx_udc.c b/drivers/usb/gadget/xilinx_udc.c
>> new file mode 100644
>> index 0000000..3ee8359
>> --- /dev/null
>> +++ b/drivers/usb/gadget/xilinx_udc.c
>> @@ -0,0 +1,2045 @@
>> +/*
>> + * Xilinx USB peripheral controller driver
>> + *
>> + * Copyright (C) 2004 by Thomas Rathbone
>> + * Copyright (C) 2005 by HP Labs
>> + * Copyright (C) 2005 by David Brownell
>
> heh! :-) Brownell was really everywhere, good to still see code from him
> ;-)
>
>> + * Copyright (C) 2010 - 2014 Xilinx, Inc.
>> + *
>> + * Some parts of this driver code is based on the driver for at91-series
>> + * USB peripheral controller (at91_udc.c).
>> + *
>> + * This program is free software; you can redistribute it
>> + * and/or modify it under the terms of the GNU General Public
>> + * License as published by the Free Software Foundation;
>> + * either version 2 of the License, or (at your option) any
>> + * later version.
>
> are you sure you want to allow people ot use GPL v3 on this driver ?
>
>> +#include <linux/interrupt.h>
>> +#include <linux/device.h>
>> +#include <linux/module.h>
>> +#include <linux/prefetch.h>
>> +#include <linux/usb/ch9.h>
>> +#include <linux/usb/gadget.h>
>> +#include <linux/io.h>
>> +#include <linux/seq_file.h>
>> +#include <linux/of_address.h>
>> +#include <linux/of_device.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/of_irq.h>
>> +#include <linux/dma-mapping.h>
>> +#include "gadget_chips.h"
>> +
>> +/* Register offsets for the USB device.*/
>> +#define XUSB_EP0_CONFIG_OFFSET               0x0000  /* EP0 Config Reg Offset */
>> +#define XUSB_SETUP_PKT_ADDR_OFFSET   0x0080  /* Setup Packet Address */
>> +#define XUSB_ADDRESS_OFFSET          0x0100  /* Address Register */
>> +#define XUSB_CONTROL_OFFSET          0x0104  /* Control Register */
>> +#define XUSB_STATUS_OFFSET           0x0108  /* Status Register */
>> +#define XUSB_FRAMENUM_OFFSET         0x010C  /* Frame Number Register */
>> +#define XUSB_IER_OFFSET                      0x0110  /* Interrupt Enable Register */
>> +#define XUSB_BUFFREADY_OFFSET                0x0114  /* Buffer Ready Register */
>> +#define XUSB_TESTMODE_OFFSET         0x0118  /* Test Mode Register */
>> +#define XUSB_DMA_RESET_OFFSET                0x0200  /* DMA Soft Reset Register */
>> +#define XUSB_DMA_CONTROL_OFFSET              0x0204  /* DMA Control Register */
>> +#define XUSB_DMA_DSAR_ADDR_OFFSET    0x0208  /* DMA source Address Reg */
>> +#define XUSB_DMA_DDAR_ADDR_OFFSET    0x020C  /* DMA destination Addr Reg */
>> +#define XUSB_DMA_LENGTH_OFFSET               0x0210  /* DMA Length Register */
>> +#define XUSB_DMA_STATUS_OFFSET               0x0214  /* DMA Status Register */
>> +
>> +/* Endpoint Configuration Space offsets */
>> +#define XUSB_EP_CFGSTATUS_OFFSET     0x00    /* Endpoint Config Status  */
>> +#define XUSB_EP_BUF0COUNT_OFFSET     0x08    /* Buffer 0 Count */
>> +#define XUSB_EP_BUF1COUNT_OFFSET     0x0C    /* Buffer 1 Count */
>> +
>> +#define XUSB_CONTROL_USB_READY_MASK  0x80000000 /* USB ready Mask */
>> +
>> +/* Interrupt register related masks.*/
>> +#define XUSB_STATUS_GLOBAL_INTR_MASK 0x80000000 /* Global Intr Enable */
>> +#define XUSB_STATUS_RESET_MASK               0x00800000 /* USB Reset Mask */
>> +#define XUSB_STATUS_SUSPEND_MASK     0x00400000 /* USB Suspend Mask */
>> +#define XUSB_STATUS_DISCONNECT_MASK  0x00200000 /* USB Disconnect Mask */
>> +#define XUSB_STATUS_FIFO_BUFF_RDY_MASK       0x00100000 /* FIFO Buff Ready Mask */
>> +#define XUSB_STATUS_FIFO_BUFF_FREE_MASK      0x00080000 /* FIFO Buff Free Mask */
>> +#define XUSB_STATUS_SETUP_PACKET_MASK        0x00040000 /* Setup packet received */
>> +#define XUSB_STATUS_EP1_BUFF2_COMP_MASK      0x00000200 /* EP 1 Buff 2 Processed */
>> +#define XUSB_STATUS_EP1_BUFF1_COMP_MASK      0x00000002 /* EP 1 Buff 1 Processed */
>> +#define XUSB_STATUS_EP0_BUFF2_COMP_MASK      0x00000100 /* EP 0 Buff 2 Processed */
>> +#define XUSB_STATUS_EP0_BUFF1_COMP_MASK      0x00000001 /* EP 0 Buff 1 Processed */
>> +#define XUSB_STATUS_HIGH_SPEED_MASK  0x00010000 /* USB Speed Mask */
>> +/* Suspend,Reset and Disconnect Mask */
>> +#define XUSB_STATUS_INTR_EVENT_MASK  0x00E00000
>> +/* Buffers  completion Mask */
>> +#define XUSB_STATUS_INTR_BUFF_COMP_ALL_MASK  0x0000FEFF
>> +/* Mask for buffer 0 and buffer 1 completion for all Endpoints */
>> +#define XUSB_STATUS_INTR_BUFF_COMP_SHIFT_MASK        0x00000101
>> +#define XUSB_STATUS_EP_BUFF2_SHIFT   8          /* EP buffer offset */
>> +
>> +/* Endpoint Configuration Status Register */
>> +#define XUSB_EP_CFG_VALID_MASK               0x80000000 /* Endpoint Valid bit */
>> +#define XUSB_EP_CFG_STALL_MASK               0x40000000 /* Endpoint Stall bit */
>> +#define XUSB_EP_CFG_DATA_TOGGLE_MASK 0x08000000 /* Endpoint Data toggle */
>> +
>> +/* USB device specific global configuration constants.*/
>> +#define XUSB_MAX_ENDPOINTS           8       /* Maximum End Points */
>> +#define XUSB_EP_NUMBER_ZERO          0       /* End point Zero */
>> +
>> +/* Test Modes (Set Feature).*/
>> +#define TEST_J                               1       /* Chirp J Test */
>> +#define TEST_K                               2       /* Chirp K Test */
>> +#define TEST_SE0_NAK                 3       /* Chirp SE0 Test */
>> +#define TEST_PKT                     4       /* Packet Test */
>> +
>> +#define CONFIGURATION_ONE            0x01    /* USB device configuration*/
>> +#define STANDARD_OUT_DEVICE          0x00    /* Out device */
>> +#define STANDARD_OUT_ENDPOINT                0x02    /* Standard Out end point */
>
> DO NOT REDEFINE THESE, use the ones from <linux/usb/ch9.h>
>
>> +
>> +#define XUSB_DMA_READ_FROM_DPRAM     0x80000000/**< DPRAM is the source
>> +                                                     address for DMA transfer
>> +                                                     */
>> +#define XUSB_DMA_DMASR_BUSY          0x80000000 /**< DMA busy*/
>> +#define XUSB_DMA_DMASR_ERROR         0x40000000 /**< DMA Error */
>> +
>> +/*
>> + * When this bit is set, the DMA buffer ready bit is set by hardware upon
>> + * DMA transfer completion.
>> + */
>> +#define XUSB_DMA_BRR_CTRL            0x40000000 /**< DMA bufready ctrl bit */
>> +
>> +/* Phase States */
>> +#define SETUP_PHASE                  0x0000  /* Setup Phase */
>> +#define DATA_PHASE                   0x0001  /* Data Phase */
>> +#define STATUS_PHASE                 0x0002  /* Status Phase */
>> +
>> +#define EP_TRANSMIT          0       /* EP is IN endpoint */
>> +#define EP0_MAX_PACKET               64 /* Endpoint 0 maximum packet length */
>> +
>> +/**
>> + * struct xusb_request - Xilinx USB device request structure
>> + * @usb_req: Linux usb request structure
>> + * @queue: usb device request queue
>> + */
>> +struct xusb_request {
>> +     struct usb_request usb_req;
>> +     struct list_head queue;
>> +};
>> +
>> +/**
>> + * struct xusb_ep - USB end point structure.
>> + * @ep_usb: usb endpoint instance
>> + * @queue: endpoint message queue
>> + * @udc: xilinx usb peripheral driver instance pointer
>> + * @desc: pointer to the usb endpoint descriptor
>> + * @data: pointer to the xusb_request structure
>> + * @rambase: the endpoint buffer address
>> + * @endpointoffset: the endpoint register offset value
>> + * @epnumber: endpoint number
>> + * @maxpacket: maximum packet size the endpoint can store
>> + * @buffer0count: the size of the packet recieved in the first buffer
>> + * @buffer0ready: the busy state of first buffer
>> + * @buffer1count: the size of the packet received in the second buffer
>> + * @buffer1ready: the busy state of second buffer
>> + * @eptype: endpoint transfer type (BULK, INTERRUPT)
>> + * @curbufnum: current buffer of endpoint that will be processed next
>> + * @is_in: endpoint direction (IN or OUT)
>> + * @stopped: endpoint active status
>> + * @is_iso: endpoint type(isochronous or non isochronous)
>> + * @name: name of the endpoint
>> + */
>> +struct xusb_ep {
>> +     struct usb_ep ep_usb;
>> +     struct list_head queue;
>> +     struct xusb_udc *udc;
>> +     const struct usb_endpoint_descriptor *desc;
>> +     struct xusb_request *data;
>> +     u32 rambase;
>> +     u32 endpointoffset;
>> +     u16 epnumber;
>> +     u16 maxpacket;
>> +     u16 buffer0count;
>> +     u16 buffer1count;
>> +     u8 buffer0ready;
>> +     u8 buffer1ready;
>> +     u8 eptype;
>> +     u8 curbufnum;
>> +     u8 is_in;
>> +     u8 stopped;
>> +     u8 is_iso;
>> +     char name[4];
>> +};
>> +
>> +/**
>> + * struct xusb_udc -  USB peripheral driver structure
>> + * @gadget: USB gadget driver instance
>> + * @ep: an array of endpoint structures
>> + * @driver: pointer to the usb gadget driver instance
>> + * @read_fn: function pointer to read device registers
>> + * @write_fn: function pointer to write to device registers
>> + * @base_address: the usb device base address
>> + * @lock: instance of spinlock
>> + * @dma_enabled: flag indicating whether the dma is included in the system
>> + * @status: status flag indicating the device cofiguration
>> + */
>> +struct xusb_udc {
>> +     struct usb_gadget gadget;
>> +     struct xusb_ep ep[8];
>> +     struct usb_gadget_driver *driver;
>> +     unsigned int (*read_fn)(void __iomem *);
>> +     void (*write_fn)(u32, void __iomem *);
>> +     void __iomem *base_address;
>> +     spinlock_t lock;
>> +     bool dma_enabled;
>> +     u8 status;
>> +};
>> +
>> +/**
>> + * struct cmdbuf - Standard USB Command Buffer Structure defined
>> + * @setup: usb_ctrlrequest structure for control requests
>> + * @contreadcount: read data bytes count
>> + * @contwritecount: write data bytes count
>> + * @setupseqtx: tx status
>> + * @setupseqrx: rx status
>> + * @contreadptr: pointer to endpoint0 read data
>> + * @contwriteptr: pointer to endpoint0 write data
>> + * @contreaddatabuffer: read data buffer for endpoint0
>> + */
>> +struct cmdbuf {
>> +     struct usb_ctrlrequest setup;
>> +     u32 contreadcount;
>> +     u32 contwritecount;
>> +     u32 setupseqtx;
>> +     u32 setupseqrx;
>> +     u8 *contreadptr;
>> +     u8 *contwriteptr;
>> +     u8 contreaddatabuffer[64];
>> +};
>> +
>> +static struct cmdbuf ch9_cmdbuf;
>
> NAK, you should support multiple instances of this device in the same
> SoC.
>
>> +/*
>> + * Endpoint buffer start addresses in the core
>> + */
>
> fits in one line.
>
>> +static u32 rambase[8] = { 0x22, 0x1000, 0x1100, 0x1200, 0x1300, 0x1400, 0x1500,
>> +                     0x1600 };
>> +
>> +static const char driver_name[] = "xilinx-udc";
>> +static const char ep0name[] = "ep0";
>> +
>> +/* Control endpoint configuration.*/
>> +static struct usb_endpoint_descriptor config_bulk_out_desc = {
>> +     .bLength = USB_DT_ENDPOINT_SIZE,
>> +     .bDescriptorType = USB_DT_ENDPOINT,
>> +     .bEndpointAddress = USB_DIR_OUT,
>> +     .bmAttributes = USB_ENDPOINT_XFER_BULK,
>> +     .wMaxPacketSize = __constant_cpu_to_le16(0x40),
>> +};
>> +
>> +/**
>> + * to_udc - Return the udc instance pointer
>> + * @g: pointer to the usb gadget driver instance
>> + *
>> + * Return: xusb_udc pointer
>> + */
>> +static inline struct xusb_udc *to_udc(struct usb_gadget *g)
>> +{
>> +
>
> remove this whiteline here. Also, this could very well be a macro
> instead of a function. No strong feelings though.
Ok
>
>> +     return container_of(g, struct xusb_udc, gadget);
>> +}
>> +
>> +/**
>> + * xudc_write32 - little endian write to device registers
>> + * @val: data to be written
>> + * @addr: addr of device register
>> + */
>> +static void xudc_write32(u32 val, void __iomem *addr)
>
> usually, people tend to pass addr, offset and value. Then you do the
> quick little math internally:
>
>         iowrite32(val, addr + offset);
>
> no strong feelings either.
Ok. will change
>
>> +static int xudc_eptxrx(struct xusb_ep *ep, u8 *bufferptr, u32 bufferlen,
>> +                     u8 direction)
>> +{
>> +     u32 *eprambase;
>> +     u32 bytestosend;
>> +     u8 *temprambase;
>> +     unsigned long timeout;
>> +     u32 srcaddr = 0;
>> +     u32 dstaddr = 0;
>> +     int rc = 0;
>> +     struct xusb_udc *udc = ep->udc;
>> +
>> +     bytestosend = bufferlen;
>> +
>> +     /* Put the transmit buffer into the correct ping-pong buffer.*/
>> +     if (!ep->curbufnum && !ep->buffer0ready) {
>> +             /* Get the Buffer address and copy the transmit data.*/
>> +             eprambase = (u32 __force *)(ep->udc->base_address +
>> +                             ep->rambase);
>> +
>> +             if (ep->udc->dma_enabled) {
>> +                     if (direction == EP_TRANSMIT) {
>> +                             srcaddr = dma_map_single(
>> +                                     ep->udc->gadget.dev.parent,
>> +                                     bufferptr, bufferlen, DMA_TO_DEVICE);
>> +                             dstaddr = virt_to_phys(eprambase);
>> +                             udc->write_fn(bufferlen,
>> +                                             ep->udc->base_address +
>> +                                             ep->endpointoffset +
>> +                                             XUSB_EP_BUF0COUNT_OFFSET);
>> +                             udc->write_fn(XUSB_DMA_BRR_CTRL |
>> +                                             (1 << ep->epnumber),
>> +                                             ep->udc->base_address +
>> +                                             XUSB_DMA_CONTROL_OFFSET);
>> +                     } else {
>> +                             srcaddr = virt_to_phys(eprambase);
>> +                             dstaddr = dma_map_single(
>> +                                     ep->udc->gadget.dev.parent,
>> +                                     bufferptr, bufferlen, DMA_FROM_DEVICE);
>> +                             udc->write_fn(XUSB_DMA_BRR_CTRL |
>> +                                     XUSB_DMA_READ_FROM_DPRAM |
>> +                                     (1 << ep->epnumber),
>> +                                     ep->udc->base_address +
>> +                                     XUSB_DMA_CONTROL_OFFSET);
>> +                     }
>> +                     /*
>> +                      * Set the addresses in the DMA source and destination
>> +                      * registers and then set the length into the DMA length
>> +                      * register.
>> +                      */
>> +                     udc->write_fn(srcaddr, ep->udc->base_address +
>> +                             XUSB_DMA_DSAR_ADDR_OFFSET);
>> +                     udc->write_fn(dstaddr, ep->udc->base_address +
>> +                             XUSB_DMA_DDAR_ADDR_OFFSET);
>> +                     udc->write_fn(bufferlen, ep->udc->base_address +
>> +                                     XUSB_DMA_LENGTH_OFFSET);
>> +             } else {
>> +
>> +                     while (bytestosend > 3) {
>> +                             if (direction == EP_TRANSMIT)
>> +                                     *eprambase++ = *(u32 *)bufferptr;
>> +                             else
>> +                                     *(u32 *)bufferptr = *eprambase++;
>> +                             bufferptr += 4;
>> +                             bytestosend -= 4;
>> +                     }
>> +                     temprambase = (u8 *)eprambase;
>> +                     while (bytestosend--) {
>> +                             if (direction == EP_TRANSMIT)
>> +                                     *temprambase++ = *bufferptr++;
>> +                             else
>> +                                     *bufferptr++ = *temprambase++;
>> +                     }
>> +                     /*
>> +                      * Set the Buffer count register with transmit length
>> +                      * and enable the buffer for transmission.
>> +                      */
>> +                     if (direction == EP_TRANSMIT)
>> +                             udc->write_fn(bufferlen,
>> +                                     ep->udc->base_address +
>> +                                     ep->endpointoffset +
>> +                                     XUSB_EP_BUF0COUNT_OFFSET);
>> +                     udc->write_fn(1 << ep->epnumber,
>> +                                     ep->udc->base_address +
>> +                                     XUSB_BUFFREADY_OFFSET);
>> +             }
>> +             ep->buffer0ready = 1;
>> +             ep->curbufnum = 1;
>> +
>> +     } else
>> +             if ((ep->curbufnum == 1) && (!ep->buffer1ready)) {
>> +
>> +                     /* Get the Buffer address and copy the transmit data.*/
>> +                     eprambase = (u32 __force *)(ep->udc->base_address +
>> +                                     ep->rambase + ep->ep_usb.maxpacket);
>> +                     if (ep->udc->dma_enabled) {
>> +                             if (direction == EP_TRANSMIT) {
>> +                                     srcaddr = dma_map_single(
>> +                                             ep->udc->gadget.dev.parent,
>> +                                             bufferptr, bufferlen,
>> +                                             DMA_TO_DEVICE);
>> +                                     dstaddr = virt_to_phys(eprambase);
>> +                                     udc->write_fn(bufferlen,
>> +                                             ep->udc->base_address +
>> +                                             ep->endpointoffset +
>> +                                             XUSB_EP_BUF1COUNT_OFFSET);
>> +                                     udc->write_fn(XUSB_DMA_BRR_CTRL |
>> +                                             (1 << (ep->epnumber +
>> +                                             XUSB_STATUS_EP_BUFF2_SHIFT)),
>> +                                             ep->udc->base_address +
>> +                                             XUSB_DMA_CONTROL_OFFSET);
>> +                             } else {
>> +                                     srcaddr = virt_to_phys(eprambase);
>> +                                     dstaddr = dma_map_single(
>> +                                             ep->udc->gadget.dev.parent,
>> +                                             bufferptr, bufferlen,
>> +                                             DMA_FROM_DEVICE);
>> +                                     udc->write_fn(XUSB_DMA_BRR_CTRL |
>> +                                             XUSB_DMA_READ_FROM_DPRAM |
>> +                                             (1 << (ep->epnumber +
>> +                                             XUSB_STATUS_EP_BUFF2_SHIFT)),
>> +                                             ep->udc->base_address +
>> +                                             XUSB_DMA_CONTROL_OFFSET);
>> +                             }
>> +                             /*
>> +                              * Set the addresses in the DMA source and
>> +                              * destination registers and then set the length
>> +                              * into the DMA length register.
>> +                              */
>> +                             udc->write_fn(srcaddr,
>> +                                             ep->udc->base_address +
>> +                                             XUSB_DMA_DSAR_ADDR_OFFSET);
>> +                             udc->write_fn(dstaddr,
>> +                                             ep->udc->base_address +
>> +                                             XUSB_DMA_DDAR_ADDR_OFFSET);
>> +                             udc->write_fn(bufferlen,
>> +                                             ep->udc->base_address +
>> +                                             XUSB_DMA_LENGTH_OFFSET);
>> +                     } else {
>> +                             while (bytestosend > 3) {
>> +                                     if (direction == EP_TRANSMIT)
>> +                                             *eprambase++ =
>> +                                                     *(u32 *)bufferptr;
>> +                                     else
>> +                                             *(u32 *)bufferptr =
>> +                                                     *eprambase++;
>> +                                     bufferptr += 4;
>> +                                     bytestosend -= 4;
>> +                             }
>> +                             temprambase = (u8 *)eprambase;
>> +                             while (bytestosend--) {
>> +                                     if (direction == EP_TRANSMIT)
>> +                                             *temprambase++ = *bufferptr++;
>> +                                     else
>> +                                             *bufferptr++ = *temprambase++;
>> +                             }
>> +                             /*
>> +                              * Set the Buffer count register with transmit
>> +                              * length and enable the buffer for
>> +                              * transmission.
>> +                              */
>> +                             if (direction == EP_TRANSMIT)
>> +                                     udc->write_fn(bufferlen,
>> +                                             ep->udc->base_address +
>> +                                             ep->endpointoffset +
>> +                                             XUSB_EP_BUF1COUNT_OFFSET);
>> +                             udc->write_fn(1 << (ep->epnumber +
>> +                                             XUSB_STATUS_EP_BUFF2_SHIFT),
>> +                                             ep->udc->base_address +
>> +                                             XUSB_BUFFREADY_OFFSET);
>> +                     }
>> +                     ep->buffer1ready = 1;
>> +                     ep->curbufnum = 0;
>> +             } else {
>> +                     /*
>> +                      * None of the ping-pong buffer is free. Return a
>> +                      * failure.
>> +                      */
>> +                     return 1;
>> +             }
>> +
>> +     if (ep->udc->dma_enabled) {
>> +             /*
>> +              * Wait till DMA transaction is complete and
>> +              * check whether the DMA transaction was
>> +              * successful.
>> +              */
>> +             while ((udc->read_fn(ep->udc->base_address +
>> +                             XUSB_DMA_STATUS_OFFSET) &
>> +                             XUSB_DMA_DMASR_BUSY) == XUSB_DMA_DMASR_BUSY) {
>> +                     timeout = jiffies + 10000;
>> +
>> +                     if (time_after(jiffies, timeout)) {
>> +                             rc = -ETIMEDOUT;
>> +                             goto clean;
>> +                     }
>> +
>> +             }
>> +             if ((udc->read_fn(ep->udc->base_address +
>> +                             XUSB_DMA_STATUS_OFFSET) &
>> +                             XUSB_DMA_DMASR_ERROR) == XUSB_DMA_DMASR_ERROR)
>> +                     dev_dbg(&ep->udc->gadget.dev, "DMA Error\n");
>> +clean:
>> +             if (direction == EP_TRANSMIT) {
>> +                     dma_unmap_single(ep->udc->gadget.dev.parent,
>> +                             srcaddr, bufferlen, DMA_TO_DEVICE);
>> +             } else {
>> +                     dma_unmap_single(ep->udc->gadget.dev.parent,
>> +                             dstaddr, bufferlen, DMA_FROM_DEVICE);
>> +             }
>> +     }
>> +     return rc;
>> +}
>
> what a big function. Looks like you could split it into smaller
> functions to aid redability.
Ok.
>
>> +static int xudc_ep_enable(struct usb_ep *_ep,
>> +                       const struct usb_endpoint_descriptor *desc)
>> +{
>> +     struct xusb_ep *ep = container_of(_ep, struct xusb_ep, ep_usb);
>> +     struct xusb_udc *dev = ep->udc;
>> +     u32 tmp;
>> +     u8 eptype = 0;
>> +     unsigned long flags;
>> +     u32 epcfg;
>> +     struct xusb_udc *udc = ep->udc;
>> +
>> +     /*
>> +      * The check for _ep->name == ep0name is not done as this enable i used
>> +      * for enabling ep0 also. In other gadget drivers, this ep name is not
>> +      * used.
>> +      */
>> +     if (!_ep || !desc || ep->desc ||
>> +         desc->bDescriptorType != USB_DT_ENDPOINT) {
>> +             dev_dbg(&ep->udc->gadget.dev, "first check fails\n");
>
> you need a more descriptive message here.
Ok
>
>> +             return -EINVAL;
>> +     }
>> +
>> +     if (!dev->driver || dev->gadget.speed == USB_SPEED_UNKNOWN) {
>> +             dev_dbg(&ep->udc->gadget.dev, "bogus device state\n");
>> +             return -ESHUTDOWN;
>> +     }
>> +
>> +
>> +     ep->is_in = ((desc->bEndpointAddress & USB_DIR_IN) != 0);
>> +     /*
>> +      * Bit 3...0: endpoint number
>> +      */
>
> fits in one line, no need for multiline comment.
Ok
>
>> +     ep->epnumber = (desc->bEndpointAddress & 0x0f);
>> +     ep->stopped = 0;
>> +     ep->desc = desc;
>> +     ep->ep_usb.desc = desc;
>> +     tmp = desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
>> +     spin_lock_irqsave(&ep->udc->lock, flags);
>> +     ep->ep_usb.maxpacket = le16_to_cpu(desc->wMaxPacketSize);
>> +
>> +     switch (tmp) {
>> +     case USB_ENDPOINT_XFER_CONTROL:
>> +             dev_dbg(&ep->udc->gadget.dev, "only one control endpoint\n");
>> +             /* NON- ISO */
>> +             eptype = 0;
>> +             spin_unlock_irqrestore(&ep->udc->lock, flags);
>> +             return -EINVAL;
>> +     case USB_ENDPOINT_XFER_INT:
>> +             /* NON- ISO */
>> +             eptype = 0;
>> +             if (ep->ep_usb.maxpacket > 64)
>> +                     goto bogus_max;
>> +             break;
>> +     case USB_ENDPOINT_XFER_BULK:
>> +             /* NON- ISO */
>> +             eptype = 0;
>> +             switch (ep->ep_usb.maxpacket) {
>> +             case 8:
>> +             case 16:
>> +             case 32:
>> +             case 64:
>> +             case 512:
>> +             goto ok;
>
> bogus indentation.
>
>> +             }
>> +bogus_max:
>> +             dev_dbg(&ep->udc->gadget.dev, "bogus maxpacket %d\n",
>> +                     ep->ep_usb.maxpacket);
>> +             spin_unlock_irqrestore(&ep->udc->lock, flags);
>> +             return -EINVAL;
>> +     case USB_ENDPOINT_XFER_ISOC:
>> +             /* ISO */
>> +             eptype = 1;
>> +             ep->is_iso = 1;
>> +             break;
>> +     }
>> +
>> +ok:  ep->eptype = eptype;
>
> the label sits in a line by itself:
>
> ok:
>         ep->eptype = eptype;
>
>         ...
>
>> +static int xudc_ep_disable(struct usb_ep *_ep)
>> +{
>> +     struct xusb_ep *ep = container_of(_ep, struct xusb_ep, ep_usb);
>> +     unsigned long flags;
>> +     u32 epcfg;
>> +     struct xusb_udc *udc = ep->udc;
>> +
>> +     if (ep == &ep->udc->ep[XUSB_EP_NUMBER_ZERO]) {
>> +             dev_dbg(&ep->udc->gadget.dev, "Ep0 disable called\n");
>> +             return -EINVAL;
>> +     }
>> +     spin_lock_irqsave(&ep->udc->lock, flags);
>> +
>> +     xudc_nuke(ep, -ESHUTDOWN);
>> +
>> +     /* Restore the endpoint's pristine config */
>> +     ep->desc = NULL;
>> +     ep->ep_usb.desc = NULL;
>> +
>> +     ep->stopped = 1;
>> +
>> +     dev_dbg(&ep->udc->gadget.dev, "USB Ep %d disable\n ", ep->epnumber);
>> +
>> +     /* Disable the endpoint.*/
>> +     epcfg = udc->read_fn(ep->udc->base_address + ep->endpointoffset);
>> +     epcfg &= ~XUSB_EP_CFG_VALID_MASK;
>> +     udc->write_fn(epcfg, ep->udc->base_address + ep->endpointoffset);
>> +     spin_unlock_irqrestore(&ep->udc->lock, flags);
>> +     return 0;
>> +}
>> +
>> +/**
>> + * xudc_ep_alloc_request - Initializes the request queue.
>> + * @_ep: pointer to the usb device endpoint structure.
>> + * @gfp_flags: Flags related to the request call.
>> + *
>> + * Return: pointer to request structure on success and a NULL on failure.
>> + */
>> +static struct usb_request *xudc_ep_alloc_request(struct usb_ep *_ep,
>> +                                              gfp_t gfp_flags)
>> +{
>> +     struct xusb_request *req;
>> +
>> +     req = kmalloc(sizeof(*req), gfp_flags);
>
> use kzalloc...
>
>> +     if (!req)
>> +             return NULL;
>> +
>> +     memset(req, 0, sizeof(*req));
>
> ... and drop this list head.
>
>> +     INIT_LIST_HEAD(&req->queue);
>
> remove this INIT_LIST_HEAD();
>
> also, before returning, I suppose you probably want to link the request
> to the endpoint somehow. Usually people save the endpoint pointer inside
> the private request structure (iow: req->ep = ep;)
>

in ep_queue (say,for IN transaction) the driver copies the gadget
driver buffer to HW endpoint buffer and if whole data
has been transferred successfully then request is not added to
endpoint request list. Hence  INIT_LIST_HEAD(&req->queue)
is required since list_add_tail is not done every time in ep_queue. Is
it ok to let this be here?

>> +     return &req->usb_req;
>> +}
>> +
>> +/**
>> + * xudc_free_request - Releases the request from queue.
>> + * @_ep: pointer to the usb device endpoint structure.
>> + * @_req: pointer to the usb request structure.
>> + */
>> +static void xudc_free_request(struct usb_ep *_ep, struct usb_request *_req)
>> +{
>> +     struct xusb_ep *ep = container_of(_ep, struct xusb_ep, ep_usb);
>> +     struct xusb_request *req;
>> +
>> +     req = container_of(_req, struct xusb_request, usb_req);
>
> define helper macros for these two container_of(). It helps with
> readability.
>
>> +     if (!list_empty(&req->queue))
>> +             dev_warn(&ep->udc->gadget.dev, "Error: No memory to free");
>
> what did you want to do here ? Perhaps:
>
>         if (list_empty(&req->queue)) {
>                 dev_warn(&ep->udc->gadget.dev, "Error: no request to free");
>                 return;
>         }
>
> ???
>
>> +     kfree(req);
>> +}
>> +
>> +/**
>> + * xudc_ep_queue - Adds the request to the queue.
>> + * @_ep: pointer to the usb device endpoint structure.
>> + * @_req: pointer to the usb request structure.
>> + * @gfp_flags: Flags related to the request call.
>> + *
>> + * Return: 0 for success and error value on failure
>> + */
>> +static int xudc_ep_queue(struct usb_ep *_ep, struct usb_request *_req,
>> +                      gfp_t gfp_flags)
>> +{
>> +     struct xusb_request *req;
>> +     struct xusb_ep *ep;
>> +     struct xusb_udc *dev;
>> +     unsigned long flags;
>> +     u32 length, count;
>> +     u8 *corebuf;
>> +     struct xusb_udc *udc;
>> +
>> +     req = container_of(_req, struct xusb_request, usb_req);
>> +     ep = container_of(_ep, struct xusb_ep, ep_usb);
>> +     udc = ep->udc;
>> +
>> +     if (!_req || !_req->complete || !_req->buf ||
>> +                     !list_empty(&req->queue)) {
>> +             dev_dbg(&ep->udc->gadget.dev, "invalid request\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     if (!_ep || (!ep->desc && ep->ep_usb.name != ep0name)) {
>> +             dev_dbg(&ep->udc->gadget.dev, "invalid ep\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     dev = ep->udc;
>> +     if (!dev || !dev->driver || dev->gadget.speed == USB_SPEED_UNKNOWN) {
>> +             dev_dbg(&ep->udc->gadget.dev, "%s, bogus device state %p\n",
>> +                     __func__, dev->driver);
>> +             return -ESHUTDOWN;
>> +     }
>> +
>> +     spin_lock_irqsave(&dev->lock, flags);
>> +
>> +     _req->status = -EINPROGRESS;
>> +     _req->actual = 0;
>> +
>> +     /* Try to kickstart any empty and idle queue */
>> +     if (list_empty(&ep->queue)) {
>> +             if (!ep->epnumber) {
>> +                     ep->data = req;
>> +                     if (ch9_cmdbuf.setup.bRequestType & USB_DIR_IN) {
>> +                             ch9_cmdbuf.contwriteptr = req->usb_req.buf +
>> +                                                     req->usb_req.actual;
>> +                             prefetch(ch9_cmdbuf.contwriteptr);
>> +                             length = req->usb_req.length -
>> +                                     req->usb_req.actual;
>> +                             corebuf = (void __force *) ((ep->rambase << 2) +
>> +                                         ep->udc->base_address);
>> +                             ch9_cmdbuf.contwritecount = length;
>> +                             length = count = min_t(u32, length,
>> +                                                     EP0_MAX_PACKET);
>> +                             while (length--)
>> +                                     *corebuf++ = *ch9_cmdbuf.contwriteptr++;
>> +                             udc->write_fn(count, ep->udc->base_address +
>> +                                        XUSB_EP_BUF0COUNT_OFFSET);
>> +                             udc->write_fn(1, ep->udc->base_address +
>> +                                        XUSB_BUFFREADY_OFFSET);
>> +                             ch9_cmdbuf.contwritecount -= count;
>> +                     } else {
>> +                             if (ch9_cmdbuf.setup.wLength) {
>> +                                     ch9_cmdbuf.contreadptr =
>> +                                             req->usb_req.buf +
>> +                                                     req->usb_req.actual;
>> +                                     udc->write_fn(req->usb_req.length ,
>> +                                             ep->udc->base_address +
>> +                                             XUSB_EP_BUF0COUNT_OFFSET);
>> +                                     udc->write_fn(1, ep->udc->base_address
>> +                                             + XUSB_BUFFREADY_OFFSET);
>> +                             } else {
>> +                                     xudc_wrstatus(udc);
>> +                                     req = NULL;
>> +                             }
>> +                     }
>> +             } else {
>> +
>> +                     if (ep->is_in) {
>> +                             dev_dbg(&ep->udc->gadget.dev,
>> +                                     "xudc_write_fifo called from queue\n");
>> +                             if (xudc_write_fifo(ep, req) == 1)
>> +                                     req = NULL;
>> +                     } else {
>> +                             dev_dbg(&ep->udc->gadget.dev,
>> +                                     "xudc_read_fifo called from queue\n");
>> +                             if (xudc_read_fifo(ep, req) == 1)
>> +                                     req = NULL;
>> +                     }
>> +             }
>> +     }
>> +
>> +     if (req != NULL)
>> +             list_add_tail(&req->queue, &ep->queue);
Here. INIT_LIST_HEAD(&req->queue) is required in alloc_req since
list_add_tail is not executed every time.

Could you please clarify my questions regarding requests queuing.
1. If Device need to send 5120 bytes to host and
ep->desc->wMaxPacketSize is 512 then single request with length 5120
is issued
or 10 requests are issued?
2. Does device need to know OUT transactions before hand so that OUT
requests are queued for endpoint before packets are received
from host?

>> +     spin_unlock_irqrestore(&dev->lock, flags);
>> +     return 0;
>> +}
>> +
>> +/**
>> + * xudc_ep_dequeue - Removes the request from the queue.
>> + * @_ep: pointer to the usb device endpoint structure.
>> + * @_req: pointer to the usb request structure.
>> + *
>> + * Return: 0 for success and error value on failure
>> + */
>> +static int xudc_ep_dequeue(struct usb_ep *_ep, struct usb_request *_req)
>> +{
>> +     struct xusb_ep *ep;
>> +     struct xusb_request *req;
>> +     unsigned long flags;
>> +
>> +     ep = container_of(_ep, struct xusb_ep, ep_usb);
>> +
>> +     if (!_ep || ep->ep_usb.name == ep0name)
>> +             return -EINVAL;
>> +
>> +     spin_lock_irqsave(&ep->udc->lock, flags);
>> +     /* Make sure it's actually queued on this endpoint */
>> +     list_for_each_entry(req, &ep->queue, queue) {
>> +             if (&req->usb_req == _req)
>> +                     break;
>> +     }
>> +     if (&req->usb_req != _req) {
>> +             spin_unlock_irqrestore(&ep->udc->lock, flags);
>> +             return -EINVAL;
>> +     }
>> +
>> +     xudc_done(ep, req, -ECONNRESET);
>> +     spin_unlock_irqrestore(&ep->udc->lock, flags);
>> +
>> +     return 0;
>> +}
>> +
>> +static struct usb_ep_ops xusb_ep_ops = {
>> +     .enable = xudc_ep_enable,
>> +     .disable = xudc_ep_disable,
>> +
>> +     .alloc_request = xudc_ep_alloc_request,
>> +     .free_request = xudc_free_request,
>> +
>> +     .queue = xudc_ep_queue,
>> +     .dequeue = xudc_ep_dequeue,
>> +     .set_halt = xudc_ep_set_halt,
>> +};
>> +
>> +/**
>> + * xudc_get_frame - Reads the current usb frame number.
>> + * @gadget: pointer to the usb gadget structure.
>> + *
>> + * Return: current frame number for success and error value on failure.
>> + */
>> +static int xudc_get_frame(struct usb_gadget *gadget)
>> +{
>> +
>> +     struct xusb_udc *udc = to_udc(gadget);
>> +     unsigned long flags;
>> +     int retval;
>> +
>> +     if (!gadget)
>> +             return -ENODEV;
>> +
>> +     local_irq_save(flags);
>> +     retval = udc->read_fn(udc->base_address + XUSB_FRAMENUM_OFFSET);
>> +     local_irq_restore(flags);
>> +     return retval;
>> +}
>> +
>> +/**
>> + * xudc_reinit - Restores inital software state.
>> + * @udc: pointer to the usb device controller structure.
>> + */
>> +static void xudc_reinit(struct xusb_udc *udc)
>> +{
>> +     u32 ep_number;
>> +     char name[4];
>> +
>> +     INIT_LIST_HEAD(&udc->gadget.ep_list);
>> +     INIT_LIST_HEAD(&udc->gadget.ep0->ep_list);
>> +
>> +     for (ep_number = 0; ep_number < XUSB_MAX_ENDPOINTS; ep_number++) {
>> +             struct xusb_ep *ep = &udc->ep[ep_number];
>> +
>> +             if (ep_number) {
>> +                     list_add_tail(&ep->ep_usb.ep_list,
>> +                                     &udc->gadget.ep_list);
>> +                     ep->ep_usb.maxpacket = (unsigned short)~0;
>> +                     sprintf(name, "ep%d", ep_number);
>> +                     strcpy(ep->name, name);
>> +                     ep->ep_usb.name = ep->name;
>> +             } else {
>> +                     ep->ep_usb.name = ep0name;
>> +                     ep->ep_usb.maxpacket = 0x40;
>> +             }
>> +
>> +             ep->ep_usb.ops = &xusb_ep_ops;
>> +             ep->udc = udc;
>> +             ep->epnumber = ep_number;
>> +             ep->desc = NULL;
>> +             ep->stopped = 0;
>> +             /*
>> +              * The configuration register address offset between
>> +              * each endpoint is 0x10.
>> +              */
>> +             ep->endpointoffset = XUSB_EP0_CONFIG_OFFSET +
>> +                                     (ep_number * 0x10);
>> +             ep->is_in = 0;
>> +             ep->is_iso = 0;
>> +             ep->maxpacket = 0;
>> +             xudc_epconfig(ep, udc);
>> +             udc->status = 0;
>> +
>> +             /* Initialize one queue per endpoint */
>> +             INIT_LIST_HEAD(&ep->queue);
>> +     }
>> +}
>> +
>> +/**
>> + * xudc_stop_activity - Stops any further activity on the device.
>> + * @udc: pointer to the usb device controller structure.
>> + */
>> +static void xudc_stop_activity(struct xusb_udc *udc)
>> +{
>> +     struct usb_gadget_driver *driver = udc->driver;
>> +     int i;
>> +
>> +     if (udc->gadget.speed == USB_SPEED_UNKNOWN)
>> +             driver = NULL;
>> +     udc->gadget.speed = USB_SPEED_HIGH;
>> +
>> +     for (i = 0; i < XUSB_MAX_ENDPOINTS; i++) {
>> +             struct xusb_ep *ep = &udc->ep[i];
>> +
>> +             ep->stopped = 1;
>> +             xudc_nuke(ep, -ESHUTDOWN);
>> +     }
>> +     if (driver) {
>> +             spin_unlock(&udc->lock);
>> +             driver->disconnect(&udc->gadget);
>> +             spin_lock(&udc->lock);
>> +     }
>
> you shouldn't be calling disconnect here, udc-core is doing that for
> you.
>
>> +
>> +     xudc_reinit(udc);
>> +}
>> +
>> +/**
>> + * xudc_start - Starts the device.
>> + * @gadget: pointer to the usb gadget structure
>> + * @driver: pointer to gadget driver structure
>> + *
>> + * Return: zero always
>> + */
>> +static int xudc_start(struct usb_gadget *gadget,
>> +                     struct usb_gadget_driver *driver)
>> +{
>> +     struct xusb_udc *udc = to_udc(gadget);
>> +     const struct usb_endpoint_descriptor *d = &config_bulk_out_desc;
>> +
>> +     driver->driver.bus = NULL;
>> +     /* hook up the driver */
>> +     udc->driver = driver;
>> +     udc->gadget.dev.driver = &driver->driver;
>> +     udc->gadget.speed = driver->max_speed;
>> +
>> +     /* Enable the USB device.*/
>> +     xudc_ep_enable(&udc->ep[XUSB_EP_NUMBER_ZERO].ep_usb, d);
>> +     udc->write_fn(0, (udc->base_address + XUSB_ADDRESS_OFFSET));
>> +     udc->write_fn(XUSB_CONTROL_USB_READY_MASK,
>> +             udc->base_address + XUSB_CONTROL_OFFSET);
>> +
>> +     return 0;
>> +}
>> +
>> +/**
>> + * xudc_stop - stops the device.
>> + * @gadget: pointer to the usb gadget structure
>> + * @driver: pointer to usb gadget driver structure
>> + *
>> + * Return: zero always
>> + */
>> +static int xudc_stop(struct usb_gadget *gadget,
>> +             struct usb_gadget_driver *driver)
>> +{
>> +     struct xusb_udc *udc = to_udc(gadget);
>> +     unsigned long flags;
>> +     u32 crtlreg;
>> +
>> +     /* Disable USB device.*/
>> +     crtlreg = udc->read_fn(udc->base_address + XUSB_CONTROL_OFFSET);
>> +     crtlreg &= ~XUSB_CONTROL_USB_READY_MASK;
>> +     udc->write_fn(crtlreg, udc->base_address + XUSB_CONTROL_OFFSET);
>> +     spin_lock_irqsave(&udc->lock, flags);
>> +     udc->gadget.speed = USB_SPEED_UNKNOWN;
>> +     xudc_stop_activity(udc);
>> +     spin_unlock_irqrestore(&udc->lock, flags);
>> +
>> +     udc->gadget.dev.driver = NULL;
>> +     udc->driver = NULL;
>> +
>> +     return 0;
>> +}
>> +
>> +static const struct usb_gadget_ops xusb_udc_ops = {
>> +     .get_frame = xudc_get_frame,
>> +     .udc_start = xudc_start,
>> +     .udc_stop  = xudc_stop,
>> +};
>> +
>> +/**
>> + * xudc_startup_handler - The usb device controller interrupt handler.
>> + * @callbackref: pointer to the reference value being passed.
>> + * @intrstatus: The mask value containing the interrupt sources.
>> + *
>> + * This handler handles the RESET, SUSPEND and DISCONNECT interrupts.
>> + */
>> +static void xudc_startup_handler(void *callbackref, u32 intrstatus)
>
> why void ? why isn't this returning irqreturn_t ?
>
>> +{
>> +     struct xusb_udc *udc;
>> +     u32 intrreg;
>> +
>> +     udc = (struct xusb_udc *) callbackref;
>
> you don't need the cast here.
>
>> +     if (intrstatus & XUSB_STATUS_RESET_MASK) {
>> +             dev_dbg(&udc->gadget.dev, "Reset\n");
>> +             if (intrstatus & XUSB_STATUS_HIGH_SPEED_MASK)
>> +                     udc->gadget.speed = USB_SPEED_HIGH;
>> +             else
>> +                     udc->gadget.speed = USB_SPEED_FULL;
>> +
>> +             if (udc->status == 1) {
>> +                     udc->status = 0;
>> +                     /* Set device address to 0.*/
>> +                     udc->write_fn(0, udc->base_address +
>> +                                             XUSB_ADDRESS_OFFSET);
>> +             }
>> +             /* Disable the Reset interrupt.*/
>> +             intrreg = udc->read_fn(udc->base_address +
>> +                                     XUSB_IER_OFFSET);
>> +
>> +             intrreg &= ~XUSB_STATUS_RESET_MASK;
>> +             udc->write_fn(intrreg, udc->base_address + XUSB_IER_OFFSET);
>> +             /* Enable thesuspend and disconnect.*/
>> +             intrreg =
>> +                     udc->read_fn(udc->base_address + XUSB_IER_OFFSET);
>> +             intrreg |=
>> +                     (XUSB_STATUS_SUSPEND_MASK |
>> +                      XUSB_STATUS_DISCONNECT_MASK);
>> +             udc->write_fn(intrreg, udc->base_address + XUSB_IER_OFFSET);
>> +     }
>> +
>> +     if (intrstatus & XUSB_STATUS_DISCONNECT_MASK) {
>> +
>> +             /* Disable the Disconnect interrupt.*/
>> +             intrreg =
>> +                     udc->read_fn(udc->base_address + XUSB_IER_OFFSET);
>> +             intrreg &= ~XUSB_STATUS_DISCONNECT_MASK;
>> +             udc->write_fn(intrreg, udc->base_address + XUSB_IER_OFFSET);
>> +             dev_dbg(&udc->gadget.dev, "Disconnect\n");
>> +             if (udc->status == 1) {
>> +                     udc->status = 0;
>> +                     /* Set device address to 0.*/
>> +                     udc->write_fn(0, udc->base_address +
>> +                                     XUSB_ADDRESS_OFFSET);
>> +                     /* Enable the USB device.*/
>> +                     udc->write_fn(XUSB_CONTROL_USB_READY_MASK,
>> +                             udc->base_address + XUSB_CONTROL_OFFSET);
>> +             }
>> +
>> +             /* Enable the suspend and reset interrupts.*/
>> +             intrreg = udc->read_fn(udc->base_address + XUSB_IER_OFFSET) |
>> +                             XUSB_STATUS_SUSPEND_MASK |
>> +                             XUSB_STATUS_RESET_MASK;
>> +             udc->write_fn(intrreg, udc->base_address + XUSB_IER_OFFSET);
>> +             xudc_stop_activity(udc);
>> +     }
>> +
>> +     if (intrstatus & XUSB_STATUS_SUSPEND_MASK) {
>> +             dev_dbg(&udc->gadget.dev, "Suspend\n");
>> +             /* Disable the Suspend interrupt.*/
>> +             intrreg = udc->read_fn(udc->base_address + XUSB_IER_OFFSET) &
>> +                                     ~XUSB_STATUS_SUSPEND_MASK;
>> +             udc->write_fn(intrreg, udc->base_address + XUSB_IER_OFFSET);
>> +             /* Enable the Disconnect and reset interrupts. */
>> +             intrreg = udc->read_fn(udc->base_address + XUSB_IER_OFFSET) |
>> +                             XUSB_STATUS_DISCONNECT_MASK |
>> +                             XUSB_STATUS_RESET_MASK;
>> +             udc->write_fn(intrreg, udc->base_address + XUSB_IER_OFFSET);
>> +     }
>> +}
>> +
>> +/**
>> + * xudc_set_clear_feature - Executes the set feature and clear feature commands.
>> + * @udc: pointer to the usb device controller structure.
>> + * @flag: Value deciding the set or clear action.
>> + *
>> + * Processes the SET_FEATURE and CLEAR_FEATURE commands.
>> + */
>> +static void xudc_set_clear_feature(struct xusb_udc *udc, int flag)
>> +{
>> +     u8 endpoint;
>> +     u8 outinbit;
>> +     u32 epcfgreg;
>> +
>> +     switch (ch9_cmdbuf.setup.bRequestType) {
>> +     case STANDARD_OUT_DEVICE:
>
> use the macros from <linux/usb/ch9.h>
>
>> +             switch (ch9_cmdbuf.setup.wValue) {
>> +             case USB_DEVICE_TEST_MODE:
>> +                     /*
>> +                      * The Test Mode will be executed
>> +                      * after the status phase.
>> +                      */
>> +                     break;
>> +
>> +             default:
>> +                     epcfgreg = udc->read_fn(udc->base_address +
>> +                             udc->ep[XUSB_EP_NUMBER_ZERO].endpointoffset);
>> +                     epcfgreg |= XUSB_EP_CFG_STALL_MASK;
>> +                     udc->write_fn(epcfgreg, udc->base_address +
>> +                             udc->ep[XUSB_EP_NUMBER_ZERO].endpointoffset);
>> +                     break;
>> +             }
>> +             break;
>> +
>> +     case STANDARD_OUT_ENDPOINT:
>
> use the macros from <linux/usb/ch9.h>
>
>> +             if (!ch9_cmdbuf.setup.wValue) {
>> +                     endpoint = ch9_cmdbuf.setup.wIndex & 0xf;
>> +                     outinbit = ch9_cmdbuf.setup.wIndex & 0x80;
>> +                     outinbit = outinbit >> 7;
>> +
>> +                     /* Make sure direction matches.*/
>> +                     if (outinbit != udc->ep[endpoint].is_in) {
>> +                             epcfgreg = udc->read_fn(udc->base_address +
>> +                                             udc->ep[XUSB_EP_NUMBER_ZERO].
>> +                                             endpointoffset);
>> +                             epcfgreg |= XUSB_EP_CFG_STALL_MASK;
>> +
>> +                             udc->write_fn(epcfgreg, udc->base_address +
>> +                                     udc->ep[XUSB_EP_NUMBER_ZERO].
>> +                                     endpointoffset);
>> +                             return;
>> +                     }
>> +
>> +                     if (!endpoint) {
>> +                             /* Clear the stall.*/
>> +                             epcfgreg = udc->read_fn(udc->base_address +
>> +                                             udc->ep[XUSB_EP_NUMBER_ZERO].
>> +                                             endpointoffset);
>> +
>> +                             epcfgreg &= ~XUSB_EP_CFG_STALL_MASK;
>> +
>> +                             udc->write_fn(epcfgreg, udc->base_address +
>> +                                     udc->ep[XUSB_EP_NUMBER_ZERO].
>> +                                     endpointoffset);
>> +                             break;
>> +                     } else {
>> +                             if (flag == 1) {
>> +                                     epcfgreg =
>> +                                             udc->read_fn(udc->base_address +
>> +                                             udc->ep[XUSB_EP_NUMBER_ZERO].
>> +                                             endpointoffset);
>> +                                     epcfgreg |= XUSB_EP_CFG_STALL_MASK;
>> +
>> +                                     udc->write_fn(epcfgreg,
>> +                                             udc->base_address +
>> +                                             udc->ep[XUSB_EP_NUMBER_ZERO].
>> +                                             endpointoffset);
>> +                             } else {
>> +                                     /* Unstall the endpoint.*/
>> +                                     epcfgreg =
>> +                                             udc->read_fn(udc->base_address +
>> +                                             udc->ep[endpoint].
>> +                                             endpointoffset);
>> +                                     epcfgreg &=
>> +                                             ~(XUSB_EP_CFG_STALL_MASK |
>> +                                               XUSB_EP_CFG_DATA_TOGGLE_MASK);
>> +                                     udc->write_fn(epcfgreg,
>> +                                             udc->base_address +
>> +                                             udc->ep[endpoint].
>> +                                             endpointoffset);
>> +                             }
>> +                     }
>> +             }
>> +             break;
>> +
>> +     default:
>> +             epcfgreg = udc->read_fn(udc->base_address +
>> +                             udc->ep[XUSB_EP_NUMBER_ZERO].endpointoffset);
>> +             epcfgreg |= XUSB_EP_CFG_STALL_MASK;
>> +             udc->write_fn(epcfgreg, udc->base_address +
>> +                     udc->ep[XUSB_EP_NUMBER_ZERO].endpointoffset);
>> +             return;
>> +     }
>> +
>> +     /* Cause and valid status phase to be issued.*/
>> +     xudc_wrstatus(udc);
>> +
>> +     return;
>> +}
>> +
>> +/**
>> + * xudc_execute_cmd - Processes the USB specification chapter 9 commands.
>> + * @udc: pointer to the usb device controller structure.
>> + *
>> + * Return: 0 for success and the same reuqest command if it is not handled.
>> + */
>> +static int xudc_execute_cmd(struct xusb_udc *udc)
>> +{
>> +
>> +     if ((ch9_cmdbuf.setup.bRequestType & USB_TYPE_MASK) ==
>> +                     USB_TYPE_STANDARD) {
>> +             /* Process the chapter 9 command.*/
>> +             switch (ch9_cmdbuf.setup.bRequest) {
>> +
>> +             case USB_REQ_CLEAR_FEATURE:
>> +                     xudc_set_clear_feature(udc, 0);
>> +                     break;
>> +
>> +             case USB_REQ_SET_FEATURE:
>> +                     xudc_set_clear_feature(udc, 1);
>> +                     break;
>> +
>> +             case USB_REQ_SET_ADDRESS:
>> +                     xudc_wrstatus(udc);
>> +                     break;
>> +
>> +             case USB_REQ_SET_CONFIGURATION:
>> +                     udc->status = 1;
>> +                     return ch9_cmdbuf.setup.bRequest;
>> +
>> +             default:
>> +                     /*
>> +                      * Return the same request to application for
>> +                      * handling.
>> +                      */
>> +                     return ch9_cmdbuf.setup.bRequest;
>> +             }
>> +
>> +     } else {
>> +             if ((ch9_cmdbuf.setup.bRequestType & USB_TYPE_MASK) ==
>> +                  USB_TYPE_CLASS)
>> +                     return ch9_cmdbuf.setup.bRequest;
>> +     }
>> +     return 0;
>> +}
>> +
>> +/**
>> + * xudc_handle_setup - Processes the setup packet.
>> + * @udc: pointer to the usb device controller structure.
>> + * @ctrl: pointer to the usb control endpoint structure.
>> + *
>> + * Return: 0 for success and request to be handled by application if
>> + *           is not handled by the driver.
>> + */
>> +static int xudc_handle_setup(struct xusb_udc *udc, struct usb_ctrlrequest *ctrl)
>> +{
>> +     u32 *ep0rambase;
>> +
>> +     /* Load up the chapter 9 command buffer.*/
>> +     ep0rambase = (u32 __force *) (udc->base_address +
>> +                               XUSB_SETUP_PKT_ADDR_OFFSET);
>> +     memcpy((void *)&ch9_cmdbuf.setup, (void *)ep0rambase, 8);
>> +
>> +     ctrl->bRequestType = ch9_cmdbuf.setup.bRequestType;
>> +     ctrl->bRequest     = ch9_cmdbuf.setup.bRequest;
>> +     ctrl->wValue       = ch9_cmdbuf.setup.wValue;
>> +     ctrl->wIndex       = ch9_cmdbuf.setup.wIndex;
>> +     ctrl->wLength      = ch9_cmdbuf.setup.wLength;
>> +
>> +     ch9_cmdbuf.setup.wValue = cpu_to_le16(ch9_cmdbuf.setup.wValue);
>> +     ch9_cmdbuf.setup.wIndex = cpu_to_le16(ch9_cmdbuf.setup.wIndex);
>> +     ch9_cmdbuf.setup.wLength = cpu_to_le16(ch9_cmdbuf.setup.wLength);
>> +
>> +     /* Restore ReadPtr to data buffer.*/
>> +     ch9_cmdbuf.contreadptr = &ch9_cmdbuf.contreaddatabuffer[0];
>> +     ch9_cmdbuf.contreadcount = 0;
>> +
>> +     if (ch9_cmdbuf.setup.bRequestType & USB_DIR_IN) {
>> +             /* Execute the get command.*/
>> +             ch9_cmdbuf.setupseqrx = STATUS_PHASE;
>> +             ch9_cmdbuf.setupseqtx = DATA_PHASE;
>> +             return xudc_execute_cmd(udc);
>> +     } else {
>> +             /* Execute the put command.*/
>> +             ch9_cmdbuf.setupseqrx = DATA_PHASE;
>> +             ch9_cmdbuf.setupseqtx = STATUS_PHASE;
>> +             return xudc_execute_cmd(udc);
>> +     }
>> +     /* Control should never come here.*/
>> +     return 0;
>> +}
>> +
>> +/**
>> + * xudc_ep0_out - Processes the endpoint 0 OUT token.
>> + * @udc: pointer to the usb device controller structure.
>> + */
>> +static void xudc_ep0_out(struct xusb_udc *udc)
>> +{
>> +     struct xusb_ep *ep;
>> +     u8 count;
>> +     u8 *ep0rambase;
>> +     u16 index;
>> +
>> +     ep = &udc->ep[0];
>> +     switch (ch9_cmdbuf.setupseqrx) {
>> +     case STATUS_PHASE:
>
> what about the setup phase ?
>
>> +             /*
>> +              * This resets both state machines for the next
>> +              * Setup packet.
>> +              */
>> +             ch9_cmdbuf.setupseqrx = SETUP_PHASE;
>> +             ch9_cmdbuf.setupseqtx = SETUP_PHASE;
>> +             ep->data->usb_req.actual = ep->data->usb_req.length;
>> +             xudc_done(ep, ep->data, 0);
>> +             break;
>> +
>> +     case DATA_PHASE:
>> +             count = udc->read_fn(udc->base_address +
>> +                             XUSB_EP_BUF0COUNT_OFFSET);
>> +             /* Copy the data to be received from the DPRAM. */
>> +             ep0rambase =
>> +                     (u8 __force *) (udc->base_address +
>> +                             (udc->ep[XUSB_EP_NUMBER_ZERO].rambase << 2));
>> +
>> +             for (index = 0; index < count; index++)
>> +                     *ch9_cmdbuf.contreadptr++ = *ep0rambase++;
>> +
>> +             ch9_cmdbuf.contreadcount += count;
>> +             if (ch9_cmdbuf.setup.wLength == ch9_cmdbuf.contreadcount) {
>> +                             xudc_wrstatus(udc);
>> +             } else {
>> +                     /* Set the Tx packet size and the Tx enable bit.*/
>> +                     udc->write_fn(0, udc->base_address +
>> +                             XUSB_EP_BUF0COUNT_OFFSET);
>> +                     udc->write_fn(1, udc->base_address +
>> +                             XUSB_BUFFREADY_OFFSET);
>> +             }
>> +             break;
>> +
>> +     default:
>> +             break;
>> +     }
>> +}
>> +
>> +/**
>> + * xudc_ep0_in - Processes the endpoint 0 IN token.
>> + * @udc: pointer to the usb device controller structure.
>> + */
>> +static void xudc_ep0_in(struct xusb_udc *udc)
>> +{
>> +     struct xusb_ep *ep;
>> +     u32 epcfgreg;
>> +     u16 count;
>> +     u16 length;
>> +     u8 *ep0rambase;
>> +
>> +     ep = &udc->ep[0];
>> +     switch (ch9_cmdbuf.setupseqtx) {
>> +     case STATUS_PHASE:
>> +             if (ch9_cmdbuf.setup.bRequest == USB_REQ_SET_ADDRESS) {
>> +                     /* Set the address of the device.*/
>> +                     udc->write_fn(ch9_cmdbuf.setup.wValue,
>> +                                     (udc->base_address +
>> +                                     XUSB_ADDRESS_OFFSET));
>> +                     break;
>> +             } else {
>> +                     if (ch9_cmdbuf.setup.bRequest == USB_REQ_SET_FEATURE) {
>> +                             if (ch9_cmdbuf.setup.bRequestType ==
>> +                                 STANDARD_OUT_DEVICE) {
>> +                                     if (ch9_cmdbuf.setup.wValue ==
>> +                                         USB_DEVICE_TEST_MODE)
>> +                                             udc->write_fn(TEST_J,
>> +                                                     udc->base_address +
>> +                                                     XUSB_TESTMODE_OFFSET);
>
> use a switch.
>
>> +                             }
>> +                     }
>> +             }
>> +             ep->data->usb_req.actual = ch9_cmdbuf.setup.wLength;
>> +             xudc_done(ep, ep->data, 0);
>> +             break;
>> +
>> +     case DATA_PHASE:
>> +             if (!ch9_cmdbuf.contwritecount) {
>> +                     /*
>> +                      * We're done with data transfer, next
>> +                      * will be zero length OUT with data toggle of
>> +                      * 1. Setup data_toggle.
>> +                      */
>> +                     epcfgreg = udc->read_fn(udc->base_address +
>> +                             udc->ep[XUSB_EP_NUMBER_ZERO].endpointoffset);
>> +                     epcfgreg |= XUSB_EP_CFG_DATA_TOGGLE_MASK;
>> +                     udc->write_fn(epcfgreg, udc->base_address +
>> +                             udc->ep[XUSB_EP_NUMBER_ZERO].endpointoffset);
>> +                     count = 0;
>> +
>> +                     ch9_cmdbuf.setupseqtx = STATUS_PHASE;
>> +
>> +             } else {
>> +                     length = count = min_t(u32, ch9_cmdbuf.contwritecount,
>> +                                             EP0_MAX_PACKET);
>> +                     /* Copy the data to be transmitted into the DPRAM. */
>> +                     ep0rambase = (u8 __force *) (udc->base_address +
>> +                             (udc->ep[XUSB_EP_NUMBER_ZERO].rambase << 2));
>> +                     while (length--)
>> +                             *ep0rambase++ = *ch9_cmdbuf.contwriteptr++;
>> +
>> +                     ch9_cmdbuf.contwritecount -= count;
>> +             }
>> +             udc->write_fn(count, udc->base_address +
>> +                             XUSB_EP_BUF0COUNT_OFFSET);
>> +             udc->write_fn(1, udc->base_address + XUSB_BUFFREADY_OFFSET);
>> +             break;
>> +
>> +     default:
>> +             break;
>> +     }
>> +}
>> +
>> +/**
>> + * xudc_ctrl_ep_handler - Endpoint 0 interrupt handler.
>> + * @callbackref: pointer to the call back reference passed by the
>> + *                   main interrupt handler.
>> + * @intrstatus:      It's the mask value for the interrupt sources on endpoint 0.
>> + *
>> + * Processes the commands received during enumeration phase.
>> + */
>> +static void xudc_ctrl_ep_handler(void *callbackref, u32 intrstatus)
>> +{
>> +     struct xusb_udc *udc;
>> +     struct usb_ctrlrequest ctrl;
>> +     int status;
>> +     int epnum;
>> +     u32 intrreg;
>> +
>> +     udc = (struct xusb_udc *) callbackref;
>> +     /* Process the end point zero buffer interrupt.*/
>> +     if (intrstatus & XUSB_STATUS_EP0_BUFF1_COMP_MASK) {
>> +             if (intrstatus & XUSB_STATUS_SETUP_PACKET_MASK) {
>> +                     /*
>> +                      * Enable the Disconnect, suspend and reset
>> +                      * interrupts.
>> +                      */
>> +                     intrreg = udc->read_fn(udc->base_address +
>> +                                     XUSB_IER_OFFSET);
>> +                     intrreg |= XUSB_STATUS_DISCONNECT_MASK |
>> +                                      XUSB_STATUS_SUSPEND_MASK |
>> +                                      XUSB_STATUS_RESET_MASK;
>> +                     udc->write_fn(intrreg,
>> +                             udc->base_address + XUSB_IER_OFFSET);
>> +                     status = xudc_handle_setup(udc, &ctrl);
>> +                     if (status || ((ch9_cmdbuf.setup.bRequestType &
>> +                                     USB_TYPE_MASK) == USB_TYPE_CLASS)) {
>> +                             /*
>> +                              * Request is to be handled by the gadget
>> +                              * driver.
>> +                              */
>> +                             spin_unlock(&udc->lock);
>> +                             udc->driver->setup(&udc->gadget, &ctrl);
>> +                             spin_lock(&udc->lock);
>> +                     } else {
>> +                             if (ctrl.bRequest == USB_REQ_CLEAR_FEATURE) {
>> +                                     epnum = ctrl.wIndex & 0xf;
>> +                                     udc->ep[epnum].stopped = 0;
>> +                             }
>> +                             if (ctrl.bRequest == USB_REQ_SET_FEATURE) {
>> +                                     epnum = ctrl.wIndex & 0xf;
>> +                                     udc->ep[epnum].stopped = 1;
>> +                             }
>> +                     }
>> +             } else {
>> +                     if (intrstatus & XUSB_STATUS_FIFO_BUFF_RDY_MASK)
>> +                             xudc_ep0_out(udc);
>> +                     else if (intrstatus &
>> +                             XUSB_STATUS_FIFO_BUFF_FREE_MASK)
>> +                             xudc_ep0_in(udc);
>> +             }
>> +     }
>> +}
>> +
>> +/**
>> + * xudc_nonctrl_ep_handler - Non control endpoint interrupt handler.
>> + * @callbackref: pointer to the call back reference passed by the
>> + *                   main interrupt handler.
>> + * @epnum: End point number for which the interrupt is to be processed
>> + * @intrstatus:      It's the mask value for the interrupt sources on endpoint 0.
>> + */
>> +static void xudc_nonctrl_ep_handler(void *callbackref, u8 epnum,
>> +                                     u32 intrstatus)
>> +{
>> +
>> +     struct xusb_request *req;
>> +     struct xusb_udc *udc;
>> +     struct xusb_ep *ep;
>> +
>> +     udc = (struct xusb_udc *) callbackref;
>> +     ep = &udc->ep[epnum];
>> +     /* Process the End point interrupts.*/
>> +     if (intrstatus & (XUSB_STATUS_EP0_BUFF1_COMP_MASK << epnum))
>> +             ep->buffer0ready = 0;
>> +     if (intrstatus & (XUSB_STATUS_EP0_BUFF2_COMP_MASK << epnum))
>> +             ep->buffer1ready = 0;
>> +
>> +     if (list_empty(&ep->queue))
>> +             req = NULL;
>> +     else
>> +             req = list_entry(ep->queue.next, struct xusb_request, queue);
>> +     if (!req)
>> +             return;
>> +     if (ep->is_in)
>> +             xudc_write_fifo(ep, req);
>> +     else
>> +             xudc_read_fifo(ep, req);
>> +}
>> +
>> +/**
>> + * xudc_irq - The main interrupt handler.
>> + * @irq: The interrupt number.
>> + * @_udc: pointer to the usb device controller structure.
>> + *
>> + * Return: IRQ_HANDLED after the interrupt is handled.
>> + */
>> +static irqreturn_t xudc_irq(int irq, void *_udc)
>> +{
>> +     struct xusb_udc *udc = _udc;
>> +     u32 intrstatus;
>> +     u8 index;
>> +     u32 bufintr;
>> +
>> +     spin_lock(&(udc->lock));
>> +
>> +     /* Read the Interrupt Status Register.*/
>> +     intrstatus = udc->read_fn(udc->base_address + XUSB_STATUS_OFFSET);
>> +     /* Call the handler for the event interrupt.*/
>> +     if (intrstatus & XUSB_STATUS_INTR_EVENT_MASK) {
>> +             /*
>> +              * Check if there is any action to be done for :
>> +              * - USB Reset received {XUSB_STATUS_RESET_MASK}
>> +              * - USB Suspend received {XUSB_STATUS_SUSPEND_MASK}
>
> what about resume ? No resume ?
>
>> +              * - USB Disconnect received {XUSB_STATUS_DISCONNECT_MASK}
>> +              */
>> +             xudc_startup_handler(udc, intrstatus);
>> +     }
>> +
>> +     /* Check the buffer completion interrupts */
>> +     if (intrstatus & XUSB_STATUS_INTR_BUFF_COMP_ALL_MASK) {
>> +             if (intrstatus & XUSB_STATUS_EP0_BUFF1_COMP_MASK)
>> +                     xudc_ctrl_ep_handler(udc, intrstatus);
>> +
>> +             for (index = 1; index < 8; index++) {
>> +                     bufintr = ((intrstatus &
>> +                                     (XUSB_STATUS_EP1_BUFF1_COMP_MASK <<
>> +                                                     (index - 1))) ||
>> +                                (intrstatus &
>> +                                     (XUSB_STATUS_EP1_BUFF2_COMP_MASK <<
>> +                                                     (index - 1))));
>> +
>> +                     if (bufintr)
>> +                             xudc_nonctrl_ep_handler(udc, index,
>> +                                             intrstatus);
>> +             }
>> +     }
>> +     spin_unlock(&(udc->lock));
>> +
>> +     return IRQ_HANDLED;
>> +}
>> +
>> +
>> +
>> +/**
>> + * xudc_release - Releases device structure
>> + * @dev: pointer to device structure
>> + */
>> +static void xudc_release(struct device *dev)
>> +{
>> +}
>
> you don't need to define this, udc-core will give you a release method.
>
>> +/**
>> + * xudc_probe - The device probe function for driver initialization.
>> + * @pdev: pointer to the platform device structure.
>> + *
>> + * Return: 0 for success and error value on failure
>> + */
>> +static int xudc_probe(struct platform_device *pdev)
>> +{
>> +     struct device_node *np = pdev->dev.of_node;
>> +     struct resource *res;
>> +     struct xusb_udc *udc;
>> +     int irq;
>> +     int ret;
>> +
>> +     dev_dbg(&pdev->dev, "%s(%p)\n", __func__, pdev);
>> +
>> +     udc = devm_kzalloc(&pdev->dev, sizeof(*udc), GFP_KERNEL);
>> +     if (!udc)
>> +             return -ENOMEM;
>> +
>> +     /* Map the registers */
>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +     udc->base_address = devm_ioremap_nocache(&pdev->dev, res->start,
>> +                                              resource_size(res));
>
> use devm_ioremap_resource() instead.
>
>> +     if (!udc->base_address)
>> +             return -ENOMEM;
>> +
>> +     irq = platform_get_irq(pdev, 0);
>> +     if (irq < 0) {
>> +             dev_err(&pdev->dev, "unable to get irq\n");
>> +             return irq;
>> +     }
>> +     ret = request_irq(irq, xudc_irq, 0, dev_name(&pdev->dev), udc);
>
> devm_request_irq()
>
>> +     if (ret < 0) {
>> +             dev_dbg(&pdev->dev, "unable to request irq %d", irq);
>> +             goto fail0;
>> +     }
>> +
>> +     udc->dma_enabled = of_property_read_bool(np, "xlnx,include-dma");
>> +
>> +     /* Setup gadget structure */
>> +     udc->gadget.ops = &xusb_udc_ops;
>> +     udc->gadget.max_speed = USB_SPEED_HIGH;
>> +     udc->gadget.speed = USB_SPEED_HIGH;
>> +     udc->gadget.ep0 = &udc->ep[XUSB_EP_NUMBER_ZERO].ep_usb;
>> +     udc->gadget.name = driver_name;
>> +
>> +     dev_set_name(&udc->gadget.dev, "xilinx_udc");
>> +     udc->gadget.dev.release = xudc_release;
>> +     udc->gadget.dev.parent = &pdev->dev;
>
> don't touch the gadget device directly, udc-core handles all of that for
> you.
>
>> +
>> +     spin_lock_init(&udc->lock);
>> +
>> +     /* Check for IP endianness */
>> +     udc->write_fn = xudc_write32_be;
>> +     udc->read_fn = xudc_read32_be;
>> +     udc->write_fn(TEST_J, udc->base_address + XUSB_TESTMODE_OFFSET);
>> +     if ((udc->read_fn(udc->base_address + XUSB_TESTMODE_OFFSET))
>> +                     != TEST_J) {
>> +             udc->write_fn = xudc_write32;
>> +             udc->read_fn = xudc_read32;
>> +     }
>> +     udc->write_fn(0, udc->base_address + XUSB_TESTMODE_OFFSET);
>> +
>> +     xudc_reinit(udc);
>> +
>> +     /* Set device address to 0.*/
>> +     udc->write_fn(0, udc->base_address + XUSB_ADDRESS_OFFSET);
>> +
>> +     ret = usb_add_gadget_udc(&pdev->dev, &udc->gadget);
>> +     if (ret)
>> +             goto fail1;
>> +
>> +     /* Enable the interrupts.*/
>> +     udc->write_fn(XUSB_STATUS_GLOBAL_INTR_MASK | XUSB_STATUS_RESET_MASK |
>> +                   XUSB_STATUS_DISCONNECT_MASK | XUSB_STATUS_SUSPEND_MASK |
>> +                   XUSB_STATUS_FIFO_BUFF_RDY_MASK |
>> +                   XUSB_STATUS_FIFO_BUFF_FREE_MASK |
>> +                   XUSB_STATUS_EP0_BUFF1_COMP_MASK,
>> +                   udc->base_address + XUSB_IER_OFFSET);
>> +
>> +     platform_set_drvdata(pdev, udc);
>> +
>> +     dev_info(&pdev->dev, "%s #%d at 0x%08X mapped to 0x%08X\n",
>> +              driver_name, 0, (u32)res->start,
>> +              (u32 __force)udc->base_address);
>
> make this a dev_vdbg().
>
>> +
>> +     return 0;
>> +
>> +fail1:
>> +     free_irq(irq, udc);
>> +fail0:
>> +     dev_dbg(&pdev->dev, "probe failed, %d\n", ret);
>
> this should be dev_err().
>
>> +     return ret;
>> +}
>> +
>> +/**
>> + * xudc_remove - Releases the resources allocated during the initialization.
>> + * @pdev: pointer to the platform device structure.
>> + *
>> + * Return: 0 for success and error value on failure
>> + */
>> +static int xudc_remove(struct platform_device *pdev)
>> +{
>> +     struct xusb_udc *udc = platform_get_drvdata(pdev);
>> +
>> +     dev_dbg(&pdev->dev, "remove\n");
>> +     usb_del_gadget_udc(&udc->gadget);
>> +     if (udc->driver)
>> +             return -EBUSY;
>> +
>> +     device_unregister(&udc->gadget.dev);
>
> remove this line.
>
> Also, you're leaking your IRQ handler, if you switch to
> devm_request_irq() then you don't need to free it, though.
>
> From the looks of it, I doubt this was actually tested, you need a lot
> of work on this driver.
>
> cheers
>
> --
> balbi

Thanks,
Sundeep
