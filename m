Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaENT1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:27:48 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:61704 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbaENT1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:27:45 -0400
MIME-Version: 1.0
In-Reply-To: <1400090352.30384.19.camel@joe-AO725>
References: <1400089197-18427-1-git-send-email-ricardo.ribalda@gmail.com> <1400090352.30384.19.camel@joe-AO725>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 14 May 2014 21:27:24 +0200
Message-ID: <CAPybu_0mfVf3bLE31ZKZZRvpC9Q-7ao46TvbPh0koUmJHXPnoA@mail.gmail.com>
Subject: Re: [PATCH 2/2 v2] usb: gadget: net2280: Add support for PLX USB338X
To: Joe Perches <joe@perches.com>
Cc: balbi@ti.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joe

 Thanks for your comments. I have already prepared a v3 with your
comments. I wait some hours for more comments and then I resubmit the
patch to avoid spamming the list.

Thanks for your time!

On Wed, May 14, 2014 at 7:59 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2014-05-14 at 19:39 +0200, Ricardo Ribalda Delgado wrote:
>> This patch adds support for the PLX USB3380 and USB3382.
>>
>> This driver is based on the driver from the manufacturer.
>>
>> Since USB338X is register compatible with NET2280, I thought that it
>> would be better to include this hardware into net2280 driver.
>>
>> Manufacturer's driver only supported the USB33X, did not follow the
>> Kernel Style and contain some trivial errors. This patch has tried to
>> address this issues.
>>
>> This patch has only been tested on USB338x hardware, but the merge has
>> been done trying to not affect the behaviour of NET2280.
>
> trivial notes:
>
>> diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
> []
>> @@ -148,6 +155,10 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
>>       struct net2280_ep       *ep;
>>       u32                     max, tmp;
>>       unsigned long           flags;
>> +     static const u32 ep_bit[9] = { 0, 17, 2, 19, 4, 1, 18, 3, 20 };
> []
>> @@ -361,6 +407,56 @@ static void ep_reset (struct net2280_regs __iomem *regs, struct net2280_ep *ep)
> []
>> +static void ep_reset_338x(struct net2280_regs __iomem *regs,
>> +                                     struct net2280_ep *ep)
>> +{
>> +     u32 tmp, dmastat;
>> +     static const u32 ep_bit[9] = { 0, 17, 2, 19, 4, 1, 18, 3, 20 };
>
> To avoid duplication, perhaps ep_bit should be
> declared static const to the module instead of
> declared in multiple functions.
>
>> @@ -874,8 +991,23 @@ net2280_queue (struct usb_ep *_ep, struct usb_request *_req, gfp_t gfp_flags)
>>
>>       /* kickstart this i/o queue? */
>>       if (list_empty (&ep->queue) && !ep->stopped) {
>> +             /* DMA request while EP halted */
>> +             if (ep->dma
>> +                 && (readl(&ep->regs->ep_rsp) & (1 << CLEAR_ENDPOINT_HALT))
>> +                     && (dev->pdev->vendor == 0x10b5)) {
>
> Generally logical continuations are at the end-of-line like
>                 if (ep->dma &&
>                     (readl(&ep->regs->ep_rsp) & (1 << CLEAR_ENDPOINT_HALT)) &&
>                     (dev->pdev->vendor == 0x10b5)) {
>
> []
>
>> @@ -1820,7 +2149,122 @@ static void usb_reinit (struct net2280 *dev)
> []
>> +             if (dev->enhanced_mode) {
>> +                     ep->cfg = &dev->epregs[ne[i]];
>> +                     ep->regs =
>> +                         (struct net2280_ep_regs __iomem
>> +                          *)(((unsigned char *)&dev->epregs[ne[i]]) +
>> +                             ep_reg_addr[i]);
>
> I find this pretty difficult to read.
> Temporaries might help.
>
> Or maybe cast ep->cfg like
>                         ep->regs = (struct net2280_ep_regs __iomem *)
>                                    ((unsigned char *)ep->cfg + ep_reg_addr[i]);
> []
>
>> +     /* AA_AB Errata. Issue 4. Workaround for SuperSpeed USB
>> +        Hot Reset Exit Handshake may Fail in Specific Case using
>> +        Default Register Settings. Workaround for Enumeration test.
>> +      */
>
> linux-kernel multi-line comment style is generally:
>
>         /*
>          * comments...
>          */
>
>
>



-- 
Ricardo Ribalda
