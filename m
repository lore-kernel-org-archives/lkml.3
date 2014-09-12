Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbaILLVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 07:21:05 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:53172 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648AbaILLUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 07:20:25 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] staging: comedi: addi_apci_3120: use dma_alloc_coherent()
Date: Fri, 12 Sep 2014 12:19:56 +0100
Message-Id: <1410520797-17824-4-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410520797-17824-1-git-send-email-abbotti@mev.co.uk>
References: <1410520797-17824-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use `dma_alloc_coherent()` to allocate the DMA buffers instead of
using `__get_free_pages()` to allocate and `virt_to_bus()` to get the
hardware address.  The coherent buffers are fairly small - at most 4
pages (although there are two of them).  Use of `virt_to_bus()` is
discouraged.

Note: `struct addi_private` is used by some other ADDI-DATA drivers as
well, but this is the only one using the affected members.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/Kconfig                     |  2 +-
 .../staging/comedi/drivers/addi-data/addi_common.h |  3 +--
 drivers/staging/comedi/drivers/addi_apci_3120.c    | 26 +++++++++++-----------
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index fd5f939..f21bf6c 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -677,7 +677,7 @@ config COMEDI_ADDI_APCI_2200
 
 config COMEDI_ADDI_APCI_3120
 	tristate "ADDI-DATA APCI_3120/3001 support"
-	depends on VIRT_TO_BUS
+	depends on HAS_DMA
 	select COMEDI_FC
 	---help---
 	  Enable support for ADDI-DATA APCI_3120/3001 cards
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.h b/drivers/staging/comedi/drivers/addi-data/addi_common.h
index 88295e4..e2a3ffe 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.h
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.h
@@ -107,10 +107,9 @@ struct addi_private {
 	unsigned char b_DmaDoubleBuffer;	/*  we can use double buffering */
 	unsigned int ui_DmaActualBuffer;	/*  which buffer is used now */
 	unsigned short *ul_DmaBufferVirtual[2];	/*  pointers to DMA buffer */
-	unsigned int ul_DmaBufferHw[2];	/*  hw address of DMA buff */
+	dma_addr_t ul_DmaBufferHw[2];		/*  hw address of DMA buff */
 	unsigned int ui_DmaBufferSize[2];	/*  size of dma buffer in bytes */
 	unsigned int ui_DmaBufferUsesize[2];	/*  which size we may now used for transfer */
-	unsigned int ui_DmaBufferPageOrder[2];	/*  log2 of pages in buffer */
 	unsigned char b_DigitalOutputRegister;	/*  Digital Output Register */
 	unsigned char b_OutputMemoryStatus;
 	unsigned char b_TimerSelectMode;	/*  Contain data written at iobase + 0C */
diff --git a/drivers/staging/comedi/drivers/addi_apci_3120.c b/drivers/staging/comedi/drivers/addi_apci_3120.c
index 57c36ed..1025541 100644
--- a/drivers/staging/comedi/drivers/addi_apci_3120.c
+++ b/drivers/staging/comedi/drivers/addi_apci_3120.c
@@ -95,17 +95,16 @@ static int apci3120_auto_attach(struct comedi_device *dev,
 	for (i = 0; i < 2; i++) {
 		for (order = 2; order >= 0; order--) {
 			devpriv->ul_DmaBufferVirtual[i] =
-			    (void *)__get_free_pages(GFP_KERNEL, order);
+			    dma_alloc_coherent(dev->hw_dev, PAGE_SIZE << order,
+					       &devpriv->ul_DmaBufferHw[i],
+					       GFP_KERNEL);
 
 			if (devpriv->ul_DmaBufferVirtual[i])
 				break;
 		}
 		if (!devpriv->ul_DmaBufferVirtual[i])
 			break;
-		devpriv->ui_DmaBufferPageOrder[i] = order;
 		devpriv->ui_DmaBufferSize[i] = PAGE_SIZE << order;
-		devpriv->ul_DmaBufferHw[i] =
-		    virt_to_bus(devpriv->ul_DmaBufferVirtual[i]);
 	}
 	if (!devpriv->ul_DmaBufferVirtual[0])
 		devpriv->us_UseDma = 0;
@@ -198,15 +197,16 @@ static void apci3120_detach(struct comedi_device *dev)
 		apci3120_reset(dev);
 	comedi_pci_detach(dev);
 	if (devpriv) {
-		if (devpriv->ul_DmaBufferVirtual[0]) {
-			free_pages((unsigned long)devpriv->
-				ul_DmaBufferVirtual[0],
-				devpriv->ui_DmaBufferPageOrder[0]);
-		}
-		if (devpriv->ul_DmaBufferVirtual[1]) {
-			free_pages((unsigned long)devpriv->
-				ul_DmaBufferVirtual[1],
-				devpriv->ui_DmaBufferPageOrder[1]);
+		unsigned int i;
+
+		for (i = 0; i < 2; i++) {
+			if (devpriv->ul_DmaBufferVirtual[i]) {
+				dma_free_coherent(dev->hw_dev,
+						  devpriv->ui_DmaBufferSize[i],
+						  devpriv->
+						  ul_DmaBufferVirtual[i],
+						  devpriv->ul_DmaBufferHw[i]);
+			}
 		}
 	}
 }
-- 
2.1.0

