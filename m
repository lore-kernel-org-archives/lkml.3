Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab3GLPGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 11:06:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:32993 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932845Ab3GLPGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 11:06:22 -0400
Date: Fri, 12 Jul 2013 11:06:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>, Geert Uytterhoeven <geert@linux-m68k.org>
cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] USB: GADGET: don't fail when DMA isn't present
In-Reply-To: <CAMuHMdXGfMb3FZoNPVeWy2c15wxGwfb2w+qcRYtD7m4qADh3Wg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1307121104050.1469-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_HAS_DMA isn't enabled, the UDC core gets build errors:

drivers/built-in.o: In function `dma_set_coherent_mask':
include/linux/dma-mapping.h:93: undefined reference to `dma_supported'
include/linux/dma-mapping.h:93: undefined reference to `dma_supported'
drivers/built-in.o: In function `usb_gadget_unmap_request':
drivers/usb/gadget/udc-core.c:91: undefined reference to `dma_unmap_sg'
drivers/usb/gadget/udc-core.c:96: undefined reference to `dma_unmap_single'
drivers/built-in.o: In function `usb_gadget_map_request':
drivers/usb/gadget/udc-core.c:62: undefined reference to `dma_map_sg'
drivers/usb/gadget/udc-core.c:71: undefined reference to `dma_map_single'
drivers/usb/gadget/udc-core.c:74: undefined reference to `dma_mapping_error'

Prevent this by protecting the DMA API routines with preprocessor tests.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>

---


[as1693]

 drivers/usb/gadget/udc-core.c |    6 ++++++
 1 file changed, 6 insertions(+)

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

