Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbaILLUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 07:20:40 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:53178 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322AbaILLU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 07:20:26 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] staging: comedi: addi_apci_3120: simplify setting of devpriv->us_UseDma
Date: Fri, 12 Sep 2014 12:19:57 +0100
Message-Id: <1410520797-17824-5-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410520797-17824-1-git-send-email-abbotti@mev.co.uk>
References: <1410520797-17824-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`apci3120_auto_attach()` first sets `devpriv->us_UseDma` to 1, then sets
it back to 0 if it fails to allocate the DMA buffer.  Since `*devpriv`
is initially zeroed out by `comedi_alloc_devpriv()`, change it to only
set `devpriv->us_UseDma` to 1 if the allocation succeeds.  Also, don't
bother explicitly initializing `devpriv->b_DmaDoubleBuffer` to 0 as it
is already zeroed out.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/addi_apci_3120.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_3120.c b/drivers/staging/comedi/drivers/addi_apci_3120.c
index 1025541..ba71e24 100644
--- a/drivers/staging/comedi/drivers/addi_apci_3120.c
+++ b/drivers/staging/comedi/drivers/addi_apci_3120.c
@@ -88,10 +88,7 @@ static int apci3120_auto_attach(struct comedi_device *dev,
 			dev->irq = pcidev->irq;
 	}
 
-	devpriv->us_UseDma = 1;
-
 	/* Allocate DMA buffers */
-	devpriv->b_DmaDoubleBuffer = 0;
 	for (i = 0; i < 2; i++) {
 		for (order = 2; order >= 0; order--) {
 			devpriv->ul_DmaBufferVirtual[i] =
@@ -106,8 +103,8 @@ static int apci3120_auto_attach(struct comedi_device *dev,
 			break;
 		devpriv->ui_DmaBufferSize[i] = PAGE_SIZE << order;
 	}
-	if (!devpriv->ul_DmaBufferVirtual[0])
-		devpriv->us_UseDma = 0;
+	if (devpriv->ul_DmaBufferVirtual[0])
+		devpriv->us_UseDma = 1;
 
 	if (devpriv->ul_DmaBufferVirtual[1])
 		devpriv->b_DmaDoubleBuffer = 1;
-- 
2.1.0

