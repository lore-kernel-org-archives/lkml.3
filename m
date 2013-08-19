Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750938Ab3HSPJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 11:09:35 -0400
Received: from netrider.rowland.org ([192.131.102.5]:50179 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750796Ab3HSPJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 11:09:33 -0400
Date: Mon, 19 Aug 2013 11:09:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: USB host support should depend on HAS_DMA
In-Reply-To: <CAMuHMdVXeWaggY5FPKrr2fBBnKLq3Rqw9WF99N+AX5sFwBOnog@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1308191106040.3616-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Aug 2013, Geert Uytterhoeven wrote:

> On Thu, Jul 11, 2013 at 1:12 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wednesday 10 July 2013, Alan Stern wrote:
> >> This isn't right.  There are USB host controllers that use PIO, not
> >> DMA.  The HAS_DMA dependency should go with the controller driver, not
> >> the USB core.
> >>
> >> On the other hand, the USB core does call various routines like
> >> dma_unmap_single.  It ought to be possible to compile these calls even
> >> when DMA isn't enabled.  That is, they should be defined as do-nothing
> >> stubs.
> >
> > The asm-generic/dma-mapping-broken.h file intentionally causes link
> > errors, but that could be changed.
> >
> > The better approach in my mind would be to replace code like
> >
> >
> >         if (hcd->self.uses_dma)
> >
> > with
> >
> >         if (IS_ENABLED(CONFIG_HAS_DMA) && hcd->self.uses_dma) {
> >
> > which will reliably cause that reference to be omitted from object code,
> > but not stop giving link errors for drivers that actually require
> > DMA.
> 
> This can be done for drivers/usb/core/hcd.c.
> 
> But I'm a bit puzzled by drivers/usb/core/buffer.c. E.g.
> 
> void *hcd_buffer_alloc(...)
> {
>         ....
>         /* some USB hosts just use PIO */
>         if (!bus->controller->dma_mask &&
>             !(hcd->driver->flags & HCD_LOCAL_MEM)) {

I don't remember the full story.  You should check with the person who
added the HCD_LOCAL_MEM flag originally.

> So if DMA is not used (!hcd->self.uses_dma, i.e. bus->controller->dma_mask
> is zero), and HCD_LOCAL_MEM is set, we still end up calling dma_pool_alloc()?
> 
> (Naively, I'm not so familiar with the USB code) I'd expect it to use
> kmalloc() instead?

Maybe what happens in this case is that some sort of hook causes the 
allocation to be made from a special memory-mapped region on board the 
controller.

Alan Stern

