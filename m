Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaK0Lhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:37:36 -0500
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:56924 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752633AbaK0Lhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:37:34 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] staging: comedi: adl_pci9118: simplify interrupt_pci9118_ai_dma() a bit
Date: Thu, 27 Nov 2014 11:37:17 +0000
Message-Id: <1417088239-20460-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417088239-20460-1-git-send-email-abbotti@mev.co.uk>
References: <1417088239-20460-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate the `next_dma_buf` variable in `interrupt_pci9118_ai_dma()`.
It holds the next value of `devpriv->dma_actbuf` when double buffering
is used, but we can just set that to the next value directly at the
point where the buffers are switched as the old value is not used
anywhere else.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/adl_pci9118.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 5e0ff9d..aecfae8 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -608,16 +608,15 @@ static void interrupt_pci9118_ai_dma(struct comedi_device *dev,
 	struct comedi_cmd *cmd = &s->async->cmd;
 	struct pci9118_dmabuf *dmabuf = &devpriv->dmabuf[devpriv->dma_actbuf];
 	unsigned int nsamples = comedi_bytes_to_samples(s, dmabuf->use_size);
-	unsigned int next_dma_buf;
 
-	if (devpriv->dma_doublebuf) {	/*
-					 * switch DMA buffers if is used
-					 * double buffering
-					 */
-		next_dma_buf = 1 - devpriv->dma_actbuf;
-		pci9118_amcc_setup_dma(dev, next_dma_buf);
-		if (devpriv->ai_do == 4)
-			interrupt_pci9118_ai_mode4_switch(dev, next_dma_buf);
+	/* switch DMA buffers and restart DMA if double buffering */
+	if (devpriv->dma_doublebuf) {
+		devpriv->dma_actbuf = 1 - devpriv->dma_actbuf;
+		pci9118_amcc_setup_dma(dev, devpriv->dma_actbuf);
+		if (devpriv->ai_do == 4) {
+			interrupt_pci9118_ai_mode4_switch(dev,
+							  devpriv->dma_actbuf);
+		}
 	}
 
 	if (nsamples) {
@@ -631,11 +630,8 @@ static void interrupt_pci9118_ai_dma(struct comedi_device *dev,
 			s->async->events |= COMEDI_CB_EOA;
 	}
 
-	if (devpriv->dma_doublebuf) {
-		/* switch dma buffers */
-		devpriv->dma_actbuf = 1 - devpriv->dma_actbuf;
-	} else {
-		/* restart DMA if is not used double buffering */
+	/* restart DMA if not double buffering */
+	if (!devpriv->dma_doublebuf) {
 		pci9118_amcc_setup_dma(dev, 0);
 		if (devpriv->ai_do == 4)
 			interrupt_pci9118_ai_mode4_switch(dev, 0);
-- 
2.1.3

