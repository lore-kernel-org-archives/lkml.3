Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbaILJFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:05:00 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:52214 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbaILJE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:04:58 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] staging: comedi: adl_pci9118: don't allocate 2nd DMA buffer on failure
Date: Fri, 12 Sep 2014 10:04:42 +0100
Message-Id: <1410512684-17403-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410512684-17403-1-git-send-email-abbotti@mev.co.uk>
References: <1410512684-17403-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`pci9118_alloc_dma()` tries to allocate two DMA buffers but may allocate
a single buffer or none at all.  If it fails to allocate the first
buffer, it still tries to allocate the second buffer, even though it
won't be used.  Change it to not bother trying to allocate the second
buffer if the first one fails.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/adl_pci9118.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 8d3f813..1169104 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -1489,16 +1489,16 @@ static void pci9118_alloc_dma(struct comedi_device *dev)
 			if (dmabuf->virt)
 				break;
 		}
-		if (dmabuf->virt) {
-			dmabuf->pages = pages;
-			dmabuf->size = PAGE_SIZE * pages;
-			dmabuf->hw = virt_to_bus((void *)dmabuf->virt);
-
-			if (i == 0)
-				devpriv->master = 1;
-			if (i == 1)
-				devpriv->dma_doublebuf = 1;
-		}
+		if (!dmabuf->virt)
+			break;
+		dmabuf->pages = pages;
+		dmabuf->size = PAGE_SIZE * pages;
+		dmabuf->hw = virt_to_bus((void *)dmabuf->virt);
+
+		if (i == 0)
+			devpriv->master = 1;
+		if (i == 1)
+			devpriv->dma_doublebuf = 1;
 	}
 }
 
-- 
2.1.0

