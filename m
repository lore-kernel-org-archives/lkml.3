Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbaILJF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:05:29 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:52217 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084AbaILJFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:05:00 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] staging: comedi: adl_pci9118: don't overallocate DMA buffer
Date: Fri, 12 Sep 2014 10:04:43 +0100
Message-Id: <1410512684-17403-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410512684-17403-1-git-send-email-abbotti@mev.co.uk>
References: <1410512684-17403-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last parameter of `__get_free_pages()` is log2 (the 'order') of the
number of pages to be allocated.  This driver seems to think it is the
linear number of pages, so `pci9118_alloc_dma()` first tries to allocate
16 pages, but only uses 4 of them, setting the buffer size to PAGE_SIZE
multiplied by the 'order'.  If the allocation fails, it tries
progressively smaller orders, down to 0.  If the allocation at order 0
succeeds, the buffer size is set to 0, which is likely to cause
problems.

Set the buffer size to `PAGE_SIZE` shifted left by the allocation order.
Since the maximum buffer size previously used was 4, start with an
allocation order of 2 instead of 4.  Rename the `pages` member of
`struct pci9118_dmabuf` (and the local variable in
`pci9118_alloc_dma()`) to `order` to make it clearer what it is.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/adl_pci9118.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 1169104..6ab9e0a 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -208,7 +208,7 @@ struct pci9118_dmabuf {
 	unsigned long hw;	/* hardware (bus) address of buffer */
 	unsigned int size;	/* size of dma buffer in bytes */
 	unsigned int use_size;	/* which size we may now use for transfer */
-	int pages;		/* number of pages in buffer */
+	int order;		/* log2 number of pages in buffer */
 };
 
 struct pci9118_private {
@@ -1479,20 +1479,20 @@ static void pci9118_alloc_dma(struct comedi_device *dev)
 {
 	struct pci9118_private *devpriv = dev->private;
 	struct pci9118_dmabuf *dmabuf;
-	int pages;
+	int order;
 	int i;
 
 	for (i = 0; i < 2; i++) {
 		dmabuf = &devpriv->dmabuf[i];
-		for (pages = 4; pages >= 0; pages--) {
-			dmabuf->virt = __get_free_pages(GFP_KERNEL, pages);
+		for (order = 2; order >= 0; order--) {
+			dmabuf->virt = __get_free_pages(GFP_KERNEL, order);
 			if (dmabuf->virt)
 				break;
 		}
 		if (!dmabuf->virt)
 			break;
-		dmabuf->pages = pages;
-		dmabuf->size = PAGE_SIZE * pages;
+		dmabuf->order = order;
+		dmabuf->size = PAGE_SIZE << order;
 		dmabuf->hw = virt_to_bus((void *)dmabuf->virt);
 
 		if (i == 0)
@@ -1514,7 +1514,7 @@ static void pci9118_free_dma(struct comedi_device *dev)
 	for (i = 0; i < 2; i++) {
 		dmabuf = &devpriv->dmabuf[i];
 		if (dmabuf->virt)
-			free_pages(dmabuf->virt, dmabuf->pages);
+			free_pages(dmabuf->virt, dmabuf->order);
 	}
 }
 
-- 
2.1.0

