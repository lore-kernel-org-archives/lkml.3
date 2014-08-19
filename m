Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaHSGId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 02:08:33 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:55036 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbaHSGIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 02:08:30 -0400
MIME-Version: 1.0
In-Reply-To: <53CE36C2.50307@gmail.com>
References: <1406020130-20467-1-git-send-email-sbhatta@xilinx.com>
	<31c3ad1a-370a-4d0d-b392-8e7bb292f6aa@BN1AFFO11FD050.protection.gbl>
	<53CE36C2.50307@gmail.com>
Date: Tue, 19 Aug 2014 11:38:28 +0530
Message-ID: <CALHRZurfZ7fcByw12DC07PK6EfGtAzR__yL6Uu09DehP6Mxu5Q@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] usb: gadget: Add xilinx usb2 device support
From: sundeep subbaraya <sundeep.lkml@gmail.com>
To: Varka Bhadram <varkabhadram@gmail.com>
Cc: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michals@xilinx.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        svemula@xilinx.com, anirudh@xilinx.com,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 22, 2014 at 3:32 PM, Varka Bhadram <varkabhadram@gmail.com> wrote:
> On 07/22/2014 02:38 PM, Subbaraya Sundeep Bhatta wrote:
>>
>> +#include <linux/delay.h>
>> +#include <linux/device.h>
>> +#include <linux/dma-mapping.h>
>> +#include "gadget_chips.h"
>> +#include <linux/interrupt.h>
>> +#include <linux/io.h>
>> +#include <linux/module.h>
>> +#include <linux/of_address.h>
>> +#include <linux/of_device.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/of_irq.h>
>> +#include <linux/prefetch.h>
>> +#include <linux/usb/ch9.h>
>> +#include <linux/usb/gadget.h>
>> +
>
>
> Normally we will put the includes in alphabetical because it looks good
> and readable.
>
> But we have to include the local headers separately after all the main
> includes...
> #include <linux/delay.h>
> #include <linux/device.h>
> ....
> #include <linux/usb/gadget.h>
>
> #include "gadget_chips.h"
>
> (...)
>
Ok
>
>>
>> +       switch (udc->setupseqtx) {
>> +       case STATUS_PHASE:
>> +               switch (udc->setup.bRequest) {
>> +               case USB_REQ_SET_ADDRESS:
>> +                       /* Set the address of the device.*/
>> +                       udc->write_fn(udc->base_address,
>> +                                       XUSB_ADDRESS_OFFSET,
>> +                                       udc->setup.wValue);
>
>
> Should match open parenthesis
not necessary, as per coding style spaces should not be used --
Outside of comments, documentation and except in Kconfig, spaces are never
used for indentation.

>
> udc->write_fn(udc->base_address,
>               XUSB_ADDRESS_OFFSET,
>
>               udc->setup.wValue);
>
>
>> +                       break;
>> +               case USB_REQ_SET_FEATURE:
>> +                       if (udc->setup.bRequestType ==
>> +                                       USB_RECIP_DEVICE) {
>> +                               if (udc->setup.wValue ==
>> +                                               USB_DEVICE_TEST_MODE)
>> +                                       udc->write_fn(udc->base_address,
>> +
>> XUSB_TESTMODE_OFFSET,
>> +                                                       test_mode);
>
>
> Dto
not necessary
>
>
>> +                       }
>> +                       break;
>> +               }
>> +               req->usb_req.actual = req->usb_req.length;
>> +               xudc_done(ep0, req, 0);
>> +               break;
>> +       case DATA_PHASE:
>> +               if (!bytes_to_tx) {
>> +                       /*
>> +                        * We're done with data transfer, next
>> +                        * will be zero length OUT with data toggle of
>> +                        * 1. Setup data_toggle.
>> +                        */
>> +                       epcfgreg = udc->read_fn(udc->base_address +
>> +                                       ep0->offset);
>> +                       epcfgreg |= XUSB_EP_CFG_DATA_TOGGLE_MASK;
>> +                       udc->write_fn(udc->base_address, ep0->offset,
>> epcfgreg);
>> +                       udc->setupseqtx = STATUS_PHASE;
>> +               } else {
>> +                       length = count = min_t(u32, bytes_to_tx,
>> +                                               EP0_MAX_PACKET);
>> +                       /* Copy the data to be transmitted into the DPRAM.
>> */
>> +                       ep0rambase = (u8 __force *) (udc->base_address +
>> +                                       (ep0->rambase << 2));
>> +
>> +                       buffer = req->usb_req.buf + req->usb_req.actual;
>> +                       req->usb_req.actual = req->usb_req.actual +
>> length;
>> +                       memcpy((void *)ep0rambase, buffer, length);
>> +               }
>> +               udc->write_fn(udc->base_address, XUSB_EP_BUF0COUNT_OFFSET,
>> +                               count);
>> +               udc->write_fn(udc->base_address, XUSB_BUFFREADY_OFFSET,
>> 1);
>> +               break;
>> +       default:
>> +               break;
>> +       }
>> +}
>> +
>> +/**
>> + * xudc_ctrl_ep_handler - Endpoint 0 interrupt handler.
>> + * @udc: pointer to the udc structure.
>> + * @intrstatus:        It's the mask value for the interrupt sources on
>> endpoint 0.
>> + *
>> + * Processes the commands received during enumeration phase.
>> + */
>> +static void xudc_ctrl_ep_handler(struct xusb_udc *udc, u32 intrstatus)
>> +{
>> +
>> +       if (intrstatus & XUSB_STATUS_SETUP_PACKET_MASK) {
>> +               xudc_handle_setup(udc);
>> +       } else {
>> +               if (intrstatus & XUSB_STATUS_FIFO_BUFF_RDY_MASK)
>> +                       xudc_ep0_out(udc);
>> +               else if (intrstatus & XUSB_STATUS_FIFO_BUFF_FREE_MASK)
>> +                       xudc_ep0_in(udc);
>> +       }
>> +}
>> +
>> +/**
>> + * xudc_nonctrl_ep_handler - Non control endpoint interrupt handler.
>> + * @udc: pointer to the udc structure.
>> + * @epnum: End point number for which the interrupt is to be processed
>> + * @intrstatus:        mask value for interrupt sources of endpoints
>> other
>> + *             than endpoint 0.
>> + *
>> + * Processes the buffer completion interrupts.
>> + */
>> +static void xudc_nonctrl_ep_handler(struct xusb_udc *udc, u8 epnum,
>> +               u32 intrstatus)
>
>
> Should match open parenthesis:
not necessary
>
>
> static void xudc_nonctrl_ep_handler(struct xusb_udc *udc, u8 epnum,
>                                     u32 intrstatus)
>
>> +{
>> +
>> +       struct xusb_req *req;
>> +       struct xusb_ep *ep;
>> +
>> +       ep = &udc->ep[epnum];
>> +       /* Process the End point interrupts.*/
>> +       if (intrstatus & (XUSB_STATUS_EP0_BUFF1_COMP_MASK << epnum))
>> +               ep->buffer0ready = 0;
>> +       if (intrstatus & (XUSB_STATUS_EP0_BUFF2_COMP_MASK << epnum))
>> +               ep->buffer1ready = 0;
>> +
>> +       if (list_empty(&ep->queue))
>> +               return;
>> +
>> +       req = list_first_entry(&ep->queue, struct xusb_req, queue);
>> +
>> +       if (ep->is_in)
>> +               xudc_write_fifo(ep, req);
>> +       else
>> +               xudc_read_fifo(ep, req);
>> +}
>> +
>
>
> (...)
>
>
>> +
>> +       /* buffer for data of get_status request */
>> +       buff = kzalloc(2, GFP_KERNEL);
>
>
> define proper macro for '2'. Also we can use devm_kzalloc().
Ok
>
> Also one more thing: if we use kzalloc for allocating the 2 bytes
> no where i found that releasing the buffer on error path.
>
>
>> +       if (buff == NULL) {
>> +               ret = -ENOMEM;
>> +               goto fail;
>> +       }
>> +       /* Dummy request ready, free this in remove */
>> +       udc->req->usb_req.buf = buff;
>> +
>> +       /* Set device address to 0.*/
>> +       udc->write_fn(udc->base_address, XUSB_ADDRESS_OFFSET, 0);
>> +
>> +       ret = usb_add_gadget_udc(&pdev->dev, &udc->gadget);
>> +       if (ret)
>> +               goto fail;
>
>
> If it fails we have to free the buff. see above..
Yeah will change.
>
>
>> +
>> +       udc->dev = &udc->gadget.dev;
>> +
>> +       /* Enable the interrupts.*/
>> +       ier = XUSB_STATUS_GLOBAL_INTR_MASK | XUSB_STATUS_INTR_EVENT_MASK |
>> +               XUSB_STATUS_FIFO_BUFF_RDY_MASK |
>> +               XUSB_STATUS_FIFO_BUFF_FREE_MASK |
>> +               XUSB_STATUS_SETUP_PACKET_MASK |
>> +               XUSB_STATUS_INTR_BUFF_COMP_ALL_MASK;
>> +
>> +       udc->write_fn(udc->base_address, XUSB_IER_OFFSET, ier);
>> +
>> +       platform_set_drvdata(pdev, udc);
>> +
>> +       dev_dbg(&pdev->dev, "%s at 0x%08X mapped to 0x%08X %s\n",
>> +               driver_name, (u32)res->start,
>> +               (u32 __force)udc->base_address,
>> +               udc->dma_enabled ? "with DMA" : "without DMA");
>> +
>> +       return 0;
>> +fail:
>> +       dev_err(&pdev->dev, "probe failed, %d\n", ret);
>> +       return ret;
>> +}
>> +
>> +/**
>> + * xudc_remove - Releases the resources allocated during the
>> initialization.
>> + * @pdev: pointer to the platform device structure.
>> + *
>> + * Return: 0 always
>> + */
>> +static int xudc_remove(struct platform_device *pdev)
>> +{
>> +       struct xusb_udc *udc = platform_get_drvdata(pdev);
>> +       void *buf = udc->req->usb_req.buf;
>
>
> No need of creating another "void *". We can directly free it. (It is u8 *)
Ofcourse but as per Felipe's comments declared local variables for readability
>
>
>> +
>> +       usb_del_gadget_udc(&udc->gadget);
>> +
>> +       /* free memory allocated for dummy request buffer */
>> +       kfree(buf);
>> +       /* free memory allocated for dummy request */
>> +       kfree(udc->req);
>> +
>> +       return 0;
>> +}
>> +
>> +/* Match table for of_platform binding */
>> +static const struct of_device_id usb_of_match[] = {
>> +       { .compatible = "xlnx,usb2-device-4.00.a", },
>> +       { /* end of list */ },
>> +};
>> +MODULE_DEVICE_TABLE(of, usb_of_match);
>> +
>> +static struct platform_driver xudc_driver = {
>> +       .driver = {
>> +               .name = driver_name,
>> +               .owner = THIS_MODULE,
>
>
> We can drop the owner field update... It updated automatically
> by module_platform_driver().
Ok
>
>
> Please run checkpatch.pl on this patch. You may get more warnings and
> errors.
Yes ran before sending this out. 0 errors and 0 warnings.

Thanks,
Sundeep.B.S.
>
>
> --
> Regards,
> Varka Bhadram.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
