Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaESKEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:04:45 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:35780 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaESKEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:04:43 -0400
MIME-Version: 1.0
In-Reply-To: <1400179227.5058.14.camel@joe-AO725>
References: <1400156926-11100-1-git-send-email-ricardo.ribalda@gmail.com>
 <1400156926-11100-2-git-send-email-ricardo.ribalda@gmail.com> <1400179227.5058.14.camel@joe-AO725>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 19 May 2014 12:04:22 +0200
Message-ID: <CAPybu_19wJqyZOqVwX45Ks_YZbYZRbRdfMVrUpifHgPb-7WchA@mail.gmail.com>
Subject: Re: [PATCH 2/2 v4] usb: gadget: net2280: Add support for PLX USB338X
To: Joe Perches <joe@perches.com>
Cc: balbi@ti.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Amit Uttamchandani <auttamchandani@logicube.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joe

Thanks again for your comments. Since some the of the issues that you
point are also in the other parts of the file I will fix them in a
follow up patch for the whole driver.



On Thu, May 15, 2014 at 8:40 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2014-05-15 at 14:28 +0200, Ricardo Ribalda Delgado wrote:
>> This patch adds support for the PLX USB3380 and USB3382.
>
> A few more trivial notes, all can be addressed
> as follow-on patches or perhaps even ignored
> altogether.
>
>> diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
>
> []
>
>> @@ -90,11 +97,12 @@ static const char *const ep_name [] = {
>>   */
>>  static bool use_dma = 1;
>>  static bool use_dma_chaining = 0;
>> +static bool use_msi = 1;
>
> Nicer to use true/false instead of 1/0
>

Will fix for the whole file in a new patch

> []
>
>> @@ -161,11 +172,20 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
>>       if ((desc->bEndpointAddress & 0x0f) == EP_DONTUSE)
>>               return -EDOM;
>>
>> +     if (dev->pdev->vendor == 0x10b5) {
>
> There are several tests of vendor that
> could use #define constants instead of
> magic numbers

Will fix for the whole file in a new patch


>
> Also, perhaps these parts will be used
> by other vendors and might have to be
> expanded.
>
>>       /* sanity check ep-e/ep-f since their fifos are small */
>>       max = usb_endpoint_maxp (desc) & 0x1fff;
>> -     if (ep->num > 4 && max > 64)
>> +     if (ep->num > 4 && max > 64 && (dev->pdev->vendor == 0x17cc))
>>               return -ERANGE;
>
> Maybe too specific to one vendor ID?

I am using the vendor id to check for net2280 or usb3380. The net2280
needs that test.

>
>> +
>
> Superfluous blank line

Thanks for catching it :).

>
>> @@ -176,7 +196,8 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
>>       ep->out_overflow = 0;
>>
>>       /* set speed-dependent max packet; may kick in high bandwidth */
>> -     set_idx_reg (dev->regs, REG_EP_MAXPKT (dev, ep->num), max);
>> +     set_idx_reg(dev->regs, (dev->enhanced_mode) ? ep_enhanced[ep->num]
>> +                                     : REG_EP_MAXPKT(dev, ep->num), max);
>
> Maybe a static inline/macro helper function for this?
ok

>
>         dev->enhanced_mode ? ep_enhanced[ep->num] : REG_EP_MAXPKT(dev, ep->num)
>
>> @@ -226,11 +267,13 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
> []
>>       /* enable irqs */
>>       if (!ep->dma) {                         /* pio, per-packet */
>> -             tmp = (1 << ep->num) | readl (&dev->regs->pciirqenb0);
>> +             tmp = (dev->pdev->vendor == 0x17cc)?(1 << ep->num)
>> +                                                : (1 << ep_bit[ep->num]);
>
> And another static inline/macro helper for this?

ok

>
>> @@ -251,8 +294,10 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
>>                       tmp = (1 << SHORT_PACKET_TRANSFERRED_INTERRUPT_ENABLE);
>>                       writel (tmp, &ep->regs->ep_irqenb);
>>
>> -                     tmp = (1 << ep->num) | readl (&dev->regs->pciirqenb0);
>> -                     writel (tmp, &dev->regs->pciirqenb0);
>> +                     tmp = (dev->pdev->vendor == 0x17cc)?(1 << ep->num)
>> +                                             : (1 << ep_bit[ep->num]);
>
> This one is used twice and should use at
> least the same formatting.
>
> []
>
>> @@ -361,6 +407,55 @@ static void ep_reset (struct net2280_regs __iomem *regs, struct net2280_ep *ep)
> []
>> +     writel((1 << SHORT_PACKET_OUT_DONE_INTERRUPT) |
>> +            (1 << SHORT_PACKET_TRANSFERRED_INTERRUPT) |
>> +            (1 << FIFO_OVERFLOW) |
>> +            (1 << DATA_PACKET_RECEIVED_INTERRUPT) |
>> +            (1 << DATA_PACKET_TRANSMITTED_INTERRUPT) |
>> +            (1 << DATA_OUT_PING_TOKEN_INTERRUPT) |
>> +            (1 << DATA_IN_TOKEN_INTERRUPT), &ep->regs->ep_stat);
>> +}
>
> Perhaps these should use the BIT macro

Will fix it on a follow up patch.

>
>         writel((BIT(SHORT_PACKET_OUT_DONE_INTERRUPT) |
>                 BIT(SHORT_PACKET_TRANSFERRED_INTERRUPT) |
>                 BIT(FIFO_OVERFLOW) |
> etc...
>>
> @@ -374,13 +469,17 @@ static int net2280_disable (struct usb_ep *_ep)
>>
>>       spin_lock_irqsave (&ep->dev->lock, flags);
>>       nuke (ep);
>> -     ep_reset (ep->dev->regs, ep);
>> +
>> +     if (ep->dev->pdev->vendor == 0x10b5)
>
> Another vendor ID that could be a #define
>
>> @@ -874,8 +990,23 @@ net2280_queue (struct usb_ep *_ep, struct usb_request *_req, gfp_t gfp_flags)
>>
>>       /* kickstart this i/o queue? */
>>       if (list_empty (&ep->queue) && !ep->stopped) {
>> +             /* DMA request while EP halted */
>> +             if (ep->dma &&
>> +                 (readl(&ep->regs->ep_rsp) & (1 << CLEAR_ENDPOINT_HALT)) &&
>> +                     (dev->pdev->vendor == 0x10b5)) {
>
> here too
>
>> +static void defect7374_workaround(struct net2280 *dev, struct usb_ctrlrequest r)
> []
>> +     if (ack_wait_timeout >= DEFECT_7374_NUMBEROF_MAX_WAIT_LOOPS) {
>> +             ERROR(dev, "FAIL: Defect 7374 workaround waited but failed");
>> +             ERROR(dev, "to detect SS host's data phase ACK.");
>> +             ERROR(dev, "PL_EP_STATUS_1(23:16):.Expected from 0x11 to 0x16");
>> +             ERROR(dev, "got 0x%2.2x.\n", state >> STATE);
>
> I'd use just 2 output lines/ERROR calls here.
>
>> +     } else {
>> +             WARNING(dev, "INFO: Defect 7374 workaround waited about\n");
>> +             WARNING(dev, "%duSec for Control Read Data Phase ACK\n",
>> +                     DEFECT_7374_PROCESSOR_WAIT_TIME * ack_wait_timeout);
>
> and just 1 here

I did split the lines in 4 and 2 because otherwise checkpatch complains:

WARNING: quoted string split across lines
#86: FILE: drivers/usb/gadget/net2280.c:2780:
+ ERROR(dev, "PL_EP_STATUS_1(23:16):.Expected from 0x11 to 0x16"
+ "got 0x%2.2x.\n", state >> STATE);

But if you prefer it that way I have no problem with that.


>
>


Thanks for your comments!


-- 
Ricardo Ribalda
