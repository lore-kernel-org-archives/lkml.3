Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbaILLUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 07:20:25 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:53156 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbaILLUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 07:20:24 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] staging: comedi: addi_apci_3120: don't allocate 2nd DMA buffer on failure
Date: Fri, 12 Sep 2014 12:19:54 +0100
Message-Id: <1410520797-17824-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410520797-17824-1-git-send-email-abbotti@mev.co.uk>
References: <1410520797-17824-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`apci3120_auto_attach()` tries to allocate two DMA buffers but may
allocate a single buffer or none at all.  If it fails to allocate the
first buffer, it still tries to allocate the second buffer, even though
it won't be used.  Change it to not bother trying to allocate the second
buffer if the first one fails.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/addi_apci_3120.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_3120.c b/drivers/staging/comedi/drivers/addi_apci_3120.c
index 84501a3..2ac95ba 100644
--- a/drivers/staging/comedi/drivers/addi_apci_3120.c
+++ b/drivers/staging/comedi/drivers/addi_apci_3120.c
@@ -100,13 +100,12 @@ static int apci3120_auto_attach(struct comedi_device *dev,
 			if (devpriv->ul_DmaBufferVirtual[i])
 				break;
 		}
-		if (devpriv->ul_DmaBufferVirtual[i]) {
-			devpriv->ui_DmaBufferPages[i] = pages;
-			devpriv->ui_DmaBufferSize[i] = PAGE_SIZE * pages;
-			devpriv->ul_DmaBufferHw[i] =
-				virt_to_bus((void *)devpriv->
-				ul_DmaBufferVirtual[i]);
-		}
+		if (!devpriv->ul_DmaBufferVirtual[i])
+			break;
+		devpriv->ui_DmaBufferPages[i] = pages;
+		devpriv->ui_DmaBufferSize[i] = PAGE_SIZE * pages;
+		devpriv->ul_DmaBufferHw[i] =
+		    virt_to_bus(devpriv->ul_DmaBufferVirtual[i]);
 	}
 	if (!devpriv->ul_DmaBufferVirtual[0])
 		devpriv->us_UseDma = 0;
-- 
2.1.0

