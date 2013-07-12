Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab3GLHVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 03:21:18 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:48803 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757181Ab3GLHVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 03:21:16 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1307111145160.1276-100000@iolanthe.rowland.org>
References: <1373550845-14457-6-git-send-email-geert@linux-m68k.org>
	<Pine.LNX.4.44L0.1307111145160.1276-100000@iolanthe.rowland.org>
Date: Fri, 12 Jul 2013 09:21:15 +0200
X-Google-Sender-Auth: D1IsqQ-RjCtBWsO8b_9dfVroHKQ
Message-ID: <CAMuHMdXGfMb3FZoNPVeWy2c15wxGwfb2w+qcRYtD7m4qADh3Wg@mail.gmail.com>
Subject: Re: [PATCH 6/6] [RFC] usb: gadget: USB_GADGET should depend on HAS_DMA
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>, USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Thu, Jul 11, 2013 at 5:51 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 11 Jul 2013, Geert Uytterhoeven wrote:
>
>> If NO_DMA=y:
>>
>> drivers/built-in.o: In function `dma_set_coherent_mask':
>> include/linux/dma-mapping.h:93: undefined reference to `dma_supported'
>> include/linux/dma-mapping.h:93: undefined reference to `dma_supported'
>> drivers/built-in.o: In function `usb_gadget_unmap_request':
>> drivers/usb/gadget/udc-core.c:91: undefined reference to `dma_unmap_sg'
>> drivers/usb/gadget/udc-core.c:96: undefined reference to `dma_unmap_single'
>> drivers/built-in.o: In function `usb_gadget_map_request':
>> drivers/usb/gadget/udc-core.c:62: undefined reference to `dma_map_sg'
>> drivers/usb/gadget/udc-core.c:71: undefined reference to `dma_map_single'
>> drivers/usb/gadget/udc-core.c:74: undefined reference to `dma_mapping_error'
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>> This one is very debatable: probably the parts using the DMA API should
>> be factored out, instead of disabling the whole USB gadget subsystem.
>
> Indeed.  How does this look instead?
>
> Alan Stern
>
>
>
> Index: usb-3.10/drivers/usb/gadget/udc-core.c
> ===================================================================
> --- usb-3.10.orig/drivers/usb/gadget/udc-core.c
> +++ usb-3.10/drivers/usb/gadget/udc-core.c
> @@ -50,6 +50,8 @@ static DEFINE_MUTEX(udc_lock);
>
>  /* ------------------------------------------------------------------------- */
>
> +#ifdef CONFIG_HAS_DMA
> +
>  int usb_gadget_map_request(struct usb_gadget *gadget,
>                 struct usb_request *req, int is_in)
>  {
> @@ -99,6 +101,8 @@ void usb_gadget_unmap_request(struct usb
>  }
>  EXPORT_SYMBOL_GPL(usb_gadget_unmap_request);
>
> +#endif /* CONFIG_HAS_DMA */
> +
>  /* ------------------------------------------------------------------------- */
>
>  void usb_gadget_set_state(struct usb_gadget *gadget,
> @@ -194,9 +198,11 @@ int usb_add_gadget_udc_release(struct de
>         dev_set_name(&gadget->dev, "gadget");
>         gadget->dev.parent = parent;
>
> +#ifdef CONFIG_HAS_DMA
>         dma_set_coherent_mask(&gadget->dev, parent->coherent_dma_mask);
>         gadget->dev.dma_parms = parent->dma_parms;
>         gadget->dev.dma_mask = parent->dma_mask;
> +#endif
>
>         if (release)
>                 gadget->dev.release = release;

Thanks, that works!

(after adding a few more dependencies on HAS_DMA for drivers that call
into usb_gadget_{,un}map_request() and/or dma_set_coherent_mask(),
for which I'll send separate patches).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
