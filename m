Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbaILJFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:05:01 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:52225 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbaILJE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:04:58 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] staging: comedi: adl_pci9118: use dma_alloc_coherent()
Date: Fri, 12 Sep 2014 10:04:44 +0100
Message-Id: <1410512684-17403-4-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410512684-17403-1-git-send-email-abbotti@mev.co.uk>
References: <1410512684-17403-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use `dma_alloc_coherent()` to allocate the DMA buffers instead of
using `__get_free_pages()` to allocate and `virt_to_bus()` to get the
hardware address.  The coherent buffers are fairly small - at most 4
pages (although there are two of them).  Use of `virt_to_bus()` is
discouraged.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/Kconfig               |  2 +-
 drivers/staging/comedi/drivers/adl_pci9118.c | 20 ++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index fd5f939..9eaffd4 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -740,7 +740,7 @@ config COMEDI_ADL_PCI9111
 config COMEDI_ADL_PCI9118
 	tristate "ADLink PCI-9118DG, PCI-9118HG, PCI-9118HR support"
 	select COMEDI_FC
-	depends on VIRT_TO_BUS
+	depends on HAS_DMA
 	---help---
 	  Enable support for ADlink PCI-9118DG, PCI-9118HG, PCI-9118HR cards
 
diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 6ab9e0a..e18fd95 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -204,11 +204,10 @@ static const struct pci9118_boardinfo pci9118_boards[] = {
 };
 
 struct pci9118_dmabuf {
-	unsigned long virt;	/* virtual address of buffer */
-	unsigned long hw;	/* hardware (bus) address of buffer */
+	unsigned short *virt;	/* virtual address of buffer */
+	dma_addr_t hw;		/* hardware (bus) address of buffer */
 	unsigned int size;	/* size of dma buffer in bytes */
 	unsigned int use_size;	/* which size we may now use for transfer */
-	int order;		/* log2 number of pages in buffer */
 };
 
 struct pci9118_private {
@@ -475,12 +474,11 @@ static unsigned int defragment_dma_buffer(struct comedi_device *dev,
 
 static int move_block_from_dma(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
-			       unsigned long virt_addr,
+			       unsigned short *dma_buffer,
 			       unsigned int num_samples)
 {
 	struct pci9118_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
-	unsigned short *dma_buffer = (unsigned short *)virt_addr;
 	unsigned int num_bytes;
 
 	num_samples = defragment_dma_buffer(dev, s, dma_buffer, num_samples);
@@ -1485,15 +1483,15 @@ static void pci9118_alloc_dma(struct comedi_device *dev)
 	for (i = 0; i < 2; i++) {
 		dmabuf = &devpriv->dmabuf[i];
 		for (order = 2; order >= 0; order--) {
-			dmabuf->virt = __get_free_pages(GFP_KERNEL, order);
+			dmabuf->virt =
+			    dma_alloc_coherent(dev->hw_dev, PAGE_SIZE << order,
+					       &dmabuf->hw, GFP_KERNEL);
 			if (dmabuf->virt)
 				break;
 		}
 		if (!dmabuf->virt)
 			break;
-		dmabuf->order = order;
 		dmabuf->size = PAGE_SIZE << order;
-		dmabuf->hw = virt_to_bus((void *)dmabuf->virt);
 
 		if (i == 0)
 			devpriv->master = 1;
@@ -1513,8 +1511,10 @@ static void pci9118_free_dma(struct comedi_device *dev)
 
 	for (i = 0; i < 2; i++) {
 		dmabuf = &devpriv->dmabuf[i];
-		if (dmabuf->virt)
-			free_pages(dmabuf->virt, dmabuf->order);
+		if (dmabuf->virt) {
+			dma_free_coherent(dev->hw_dev, dmabuf->size,
+					  dmabuf->virt, dmabuf->hw);
+		}
 	}
 }
 
-- 
2.1.0

