Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab3GKPvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 11:51:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34218 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932137Ab3GKPvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 11:51:10 -0400
Date: Thu, 11 Jul 2013 11:51:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] [RFC] usb: gadget: USB_GADGET should depend on
 HAS_DMA
In-Reply-To: <1373550845-14457-6-git-send-email-geert@linux-m68k.org>
Message-ID: <Pine.LNX.4.44L0.1307111145160.1276-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jul 2013, Geert Uytterhoeven wrote:

> If NO_DMA=y:
> 
> drivers/built-in.o: In function `dma_set_coherent_mask':
> include/linux/dma-mapping.h:93: undefined reference to `dma_supported'
> include/linux/dma-mapping.h:93: undefined reference to `dma_supported'
> drivers/built-in.o: In function `usb_gadget_unmap_request':
> drivers/usb/gadget/udc-core.c:91: undefined reference to `dma_unmap_sg'
> drivers/usb/gadget/udc-core.c:96: undefined reference to `dma_unmap_single'
> drivers/built-in.o: In function `usb_gadget_map_request':
> drivers/usb/gadget/udc-core.c:62: undefined reference to `dma_map_sg'
> drivers/usb/gadget/udc-core.c:71: undefined reference to `dma_map_single'
> drivers/usb/gadget/udc-core.c:74: undefined reference to `dma_mapping_error'
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> This one is very debatable: probably the parts using the DMA API should
> be factored out, instead of disabling the whole USB gadget subsystem.

Indeed.  How does this look instead?

Alan Stern



Index: usb-3.10/drivers/usb/gadget/udc-core.c
===================================================================
--- usb-3.10.orig/drivers/usb/gadget/udc-core.c
+++ usb-3.10/drivers/usb/gadget/udc-core.c
@@ -50,6 +50,8 @@ static DEFINE_MUTEX(udc_lock);
 
 /* ------------------------------------------------------------------------- */
 
+#ifdef	CONFIG_HAS_DMA
+
 int usb_gadget_map_request(struct usb_gadget *gadget,
 		struct usb_request *req, int is_in)
 {
@@ -99,6 +101,8 @@ void usb_gadget_unmap_request(struct usb
 }
 EXPORT_SYMBOL_GPL(usb_gadget_unmap_request);
 
+#endif	/* CONFIG_HAS_DMA */
+
 /* ------------------------------------------------------------------------- */
 
 void usb_gadget_set_state(struct usb_gadget *gadget,
@@ -194,9 +198,11 @@ int usb_add_gadget_udc_release(struct de
 	dev_set_name(&gadget->dev, "gadget");
 	gadget->dev.parent = parent;
 
+#ifdef	CONFIG_HAS_DMA
 	dma_set_coherent_mask(&gadget->dev, parent->coherent_dma_mask);
 	gadget->dev.dma_parms = parent->dma_parms;
 	gadget->dev.dma_mask = parent->dma_mask;
+#endif
 
 	if (release)
 		gadget->dev.release = release;

