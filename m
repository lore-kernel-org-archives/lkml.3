Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab3HRVMu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 17:12:50 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:45102 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab3HRVMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 17:12:48 -0400
MIME-Version: 1.0
In-Reply-To: <201307110112.57398.arnd@arndb.de>
References: <Pine.LNX.4.44L0.1307101724430.1215-100000@iolanthe.rowland.org>
	<201307110112.57398.arnd@arndb.de>
Date: Sun, 18 Aug 2013 23:12:47 +0200
X-Google-Sender-Auth: nrKJmI68Akptwuxkq8gCcZZYuaY
Message-ID: <CAMuHMdVXeWaggY5FPKrr2fBBnKLq3Rqw9WF99N+AX5sFwBOnog@mail.gmail.com>
Subject: Re: [PATCH] usb: USB host support should depend on HAS_DMA
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 1:12 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 10 July 2013, Alan Stern wrote:
>> This isn't right.  There are USB host controllers that use PIO, not
>> DMA.  The HAS_DMA dependency should go with the controller driver, not
>> the USB core.
>>
>> On the other hand, the USB core does call various routines like
>> dma_unmap_single.  It ought to be possible to compile these calls even
>> when DMA isn't enabled.  That is, they should be defined as do-nothing
>> stubs.
>
> The asm-generic/dma-mapping-broken.h file intentionally causes link
> errors, but that could be changed.
>
> The better approach in my mind would be to replace code like
>
>
>         if (hcd->self.uses_dma)
>
> with
>
>         if (IS_ENABLED(CONFIG_HAS_DMA) && hcd->self.uses_dma) {
>
> which will reliably cause that reference to be omitted from object code,
> but not stop giving link errors for drivers that actually require
> DMA.

This can be done for drivers/usb/core/hcd.c.

But I'm a bit puzzled by drivers/usb/core/buffer.c. E.g.

void *hcd_buffer_alloc(...)
{
        ....
        /* some USB hosts just use PIO */
        if (!bus->controller->dma_mask &&
            !(hcd->driver->flags & HCD_LOCAL_MEM)) {
                *dma = ~(dma_addr_t) 0;
                return kmalloc(size, mem_flags);
        }

        for (i = 0; i < HCD_BUFFER_POOLS; i++) {
                if (size <= pool_max[i])
                        return dma_pool_alloc(hcd->pool[i], mem_flags, dma);
        }
        return dma_alloc_coherent(hcd->self.controller, size, dma, mem_flags);
}

which is called from usb_hcd_map_urb_for_dma():

                if (hcd->self.uses_dma) {
                        ....
                } else if (hcd->driver->flags & HCD_LOCAL_MEM) {
                        ret = hcd_alloc_coherent(
                                        urb->dev->bus, mem_flags,
                                        &urb->setup_dma,
                                        (void **)&urb->setup_packet,
                                        sizeof(struct usb_ctrlrequest),
                                        DMA_TO_DEVICE);
                        ...
                }

So if DMA is not used (!hcd->self.uses_dma, i.e. bus->controller->dma_mask
is zero), and HCD_LOCAL_MEM is set, we still end up calling dma_pool_alloc()?

(Naively, I'm not so familiar with the USB code) I'd expect it to use
kmalloc() instead?

So I would change it to

        if (!IS_ENABLED(CONFIG_HAS_DMA) ||
            (!bus->controller->dma_mask &&
             !(hcd->driver->flags & HCD_LOCAL_MEM))) {
                *dma = ~(dma_addr_t) 0;
                return kmalloc(size, mem_flags);
        }

Thanks for your clarification!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
