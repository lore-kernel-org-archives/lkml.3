Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbaILLVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 07:21:38 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:53166 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064AbaILLUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 07:20:25 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] staging: comedi: addi_apci_3120: don't overallocate DMA buffer
Date: Fri, 12 Sep 2014 12:19:55 +0100
Message-Id: <1410520797-17824-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410520797-17824-1-git-send-email-abbotti@mev.co.uk>
References: <1410520797-17824-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last parameter of `__get_free_pages()` is log2 (the 'order') of the
number of pages to be allocated.  This driver seems to think it is the
linear number of pages, so `apci3120_auto_attach()` first tries to allocate
16 pages, but only uses 4 of them, setting the buffer size to PAGE_SIZE
multiplied by the 'order'.  If the allocation fails, it tries
progressively smaller orders, down to 0.  If the allocation at order 0
succeeds, the buffer size is set to 0, which is likely to cause
problems.

Set the buffer size to `PAGE_SIZE` shifted left by the allocation order.
Since the maximum buffer size previously used was 4, start with an
allocation order of 2 instead of 4.  Rename the `ui_DmaBufferPages` member of
`struct addi_private` to `ui_DmaBufferPageOrder` and rename the `pages`
local variable to `order` to make it clearer what it is.

Note: `struct addi_private` is used by some other ADDI-DATA drivers as
well, but this is the only one using the affected members.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/addi-data/addi_common.h |  2 +-
 drivers/staging/comedi/drivers/addi_apci_3120.c        | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.h b/drivers/staging/comedi/drivers/addi-data/addi_common.h
index a7400a2..88295e4 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.h
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.h
@@ -110,7 +110,7 @@ struct addi_private {
 	unsigned int ul_DmaBufferHw[2];	/*  hw address of DMA buff */
 	unsigned int ui_DmaBufferSize[2];	/*  size of dma buffer in bytes */
 	unsigned int ui_DmaBufferUsesize[2];	/*  which size we may now used for transfer */
-	unsigned int ui_DmaBufferPages[2];	/*  number of pages in buffer */
+	unsigned int ui_DmaBufferPageOrder[2];	/*  log2 of pages in buffer */
 	unsigned char b_DigitalOutputRegister;	/*  Digital Output Register */
 	unsigned char b_OutputMemoryStatus;
 	unsigned char b_TimerSelectMode;	/*  Contain data written at iobase + 0C */
diff --git a/drivers/staging/comedi/drivers/addi_apci_3120.c b/drivers/staging/comedi/drivers/addi_apci_3120.c
index 2ac95ba..57c36ed 100644
--- a/drivers/staging/comedi/drivers/addi_apci_3120.c
+++ b/drivers/staging/comedi/drivers/addi_apci_3120.c
@@ -57,7 +57,7 @@ static int apci3120_auto_attach(struct comedi_device *dev,
 	const struct addi_board *this_board = NULL;
 	struct addi_private *devpriv;
 	struct comedi_subdevice *s;
-	int ret, pages, i;
+	int ret, order, i;
 
 	if (context < ARRAY_SIZE(apci3120_boardtypes))
 		this_board = &apci3120_boardtypes[context];
@@ -93,17 +93,17 @@ static int apci3120_auto_attach(struct comedi_device *dev,
 	/* Allocate DMA buffers */
 	devpriv->b_DmaDoubleBuffer = 0;
 	for (i = 0; i < 2; i++) {
-		for (pages = 4; pages >= 0; pages--) {
+		for (order = 2; order >= 0; order--) {
 			devpriv->ul_DmaBufferVirtual[i] =
-				(void *) __get_free_pages(GFP_KERNEL, pages);
+			    (void *)__get_free_pages(GFP_KERNEL, order);
 
 			if (devpriv->ul_DmaBufferVirtual[i])
 				break;
 		}
 		if (!devpriv->ul_DmaBufferVirtual[i])
 			break;
-		devpriv->ui_DmaBufferPages[i] = pages;
-		devpriv->ui_DmaBufferSize[i] = PAGE_SIZE * pages;
+		devpriv->ui_DmaBufferPageOrder[i] = order;
+		devpriv->ui_DmaBufferSize[i] = PAGE_SIZE << order;
 		devpriv->ul_DmaBufferHw[i] =
 		    virt_to_bus(devpriv->ul_DmaBufferVirtual[i]);
 	}
@@ -201,12 +201,12 @@ static void apci3120_detach(struct comedi_device *dev)
 		if (devpriv->ul_DmaBufferVirtual[0]) {
 			free_pages((unsigned long)devpriv->
 				ul_DmaBufferVirtual[0],
-				devpriv->ui_DmaBufferPages[0]);
+				devpriv->ui_DmaBufferPageOrder[0]);
 		}
 		if (devpriv->ul_DmaBufferVirtual[1]) {
 			free_pages((unsigned long)devpriv->
 				ul_DmaBufferVirtual[1],
-				devpriv->ui_DmaBufferPages[1]);
+				devpriv->ui_DmaBufferPageOrder[1]);
 		}
 	}
 }
-- 
2.1.0

