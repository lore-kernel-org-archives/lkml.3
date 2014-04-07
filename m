Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbaDGJBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 05:01:46 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:58249 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868AbaDGJBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 05:01:39 -0400
MIME-Version: 1.0
In-Reply-To: <533D7CF0.2000702@monstr.eu>
References: <1396510519-8555-1-git-send-email-sbhatta@xilinx.com>
	<113d0620-4003-417d-806b-0b79ae692829@VA3EHSMHS023.ehs.local>
	<20140403145853.GD14162@saruman.home>
	<533D7CF0.2000702@monstr.eu>
Date: Mon, 7 Apr 2014 14:31:37 +0530
Message-ID: <CALHRZuotnhQH03xVThGF0kz_80zGvJG-jbkXbFCczk8gs6ZQXw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] usb: gadget: Add xilinx axi usb2 device support
From: sundeep subbaraya <sundeep.lkml@gmail.com>
To: monstr@monstr.eu
Cc: balbi@ti.com,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Thu, Apr 3, 2014 at 8:53 PM, Michal Simek <monstr@monstr.eu> wrote:
>>> +struct xusb_udc {
>>> +    struct usb_gadget gadget;
>>> +    struct xusb_ep ep[8];
>>> +    struct usb_gadget_driver *driver;
>>> +    struct cmdbuf ch9cmd;
>>> +    u32 usb_state;
>>> +    u32 remote_wkp;
>>> +    unsigned int (*read_fn)(void __iomem *);
>>> +    void (*write_fn)(void __iomem *, u32, u32);
>>
>> why do you need these to be function pointers ? Because of endianness ?
>> generic readl()/writel() already take care of that.
>
> readl from asm-generic/io.h is converting value from little endian IO
> to cpu endianness.
> This IP exists also in big endian version.
> It means we have to support all possible combinations.
> IP little and reading it on little or big endian CPU
> IP big and reading it on little or big endian CPU.
>
> Look below.
>
>>> +    spin_lock_init(&udc->lock);
>>> +
>>> +    /* Check for IP endianness */
>>> +    udc->write_fn = xudc_write32_be;
>>> +    udc->read_fn = xudc_read32_be;
>>> +    udc->write_fn(udc->base_address, XUSB_TESTMODE_OFFSET, TEST_J);
>>> +    if ((udc->read_fn(udc->base_address + XUSB_TESTMODE_OFFSET))
>>> +                    != TEST_J) {
>>> +            udc->write_fn = xudc_write32;
>>> +            udc->read_fn = xudc_read32;
>>> +    }
>>
>> hmm... isn't there a configuration register to check this out ?
>
> Sundeep can tell us if there is any configuration register but
> I don't think so in connection to my experience with Xilinx soft IPs.
>

Yes, there is no configuration register for endianess.

Thanks,
Sundeep.

> Endian detection directly on IP itself came from my discussion
> on drivers/spi/spi-xilinx.c that this is only one way how to do it.
>
> Thanks,
> Michal
>
> --
> Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
> w: www.monstr.eu p: +42-0-721842854
> Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
> Maintainer of Linux kernel - Xilinx Zynq ARM architecture
> Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
>
>
