Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaK0Lhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:37:40 -0500
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:35419 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752633AbaK0Lhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:37:37 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] staging: comedi: adl_pci9118: eliminate DMA buffer defragmentation step
Date: Thu, 27 Nov 2014 11:37:19 +0000
Message-Id: <1417088239-20460-4-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417088239-20460-1-git-send-email-abbotti@mev.co.uk>
References: <1417088239-20460-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DMA operations used by the driver may have been set up to acquire
data from unwanted channels in addition to the wanted channels.
Currently, `interrupt_pci9118_ai_dma()` calls `defragment_dma_buffer()`
to move all the wanted data to the start of the DMA buffer and then
calls `comedi_buf_write_samples()` to copy it all to the comedi async
buffer.  Those two functions used to be called from
`move_block_from_dma()` which was absorbed into
`interrupt_pci9118_ai_dma()`.

Reinstate `move_block_from_dma()` but rewrite it to copy data directly
from the wanted fragments of the DMA buffer to the comedi async buffer
without defragmenting the buffer first.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/adl_pci9118.c | 67 +++++++++++++++++++---------
 1 file changed, 46 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index c0ea733..2660358 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -502,29 +502,56 @@ static unsigned int valid_samples_in_act_dma_buf(struct comedi_device *dev,
 	return n_samples;
 }
 
-static unsigned int defragment_dma_buffer(struct comedi_device *dev,
-					  struct comedi_subdevice *s,
-					  unsigned short *dma_buffer,
-					  unsigned int num_samples)
+static void move_block_from_dma(struct comedi_device *dev,
+				struct comedi_subdevice *s,
+				unsigned short *dma_buffer,
+				unsigned int n_raw_samples)
 {
 	struct pci9118_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
-	unsigned int i = 0, j = 0;
-	unsigned int start_pos = devpriv->ai_add_front,
-	    stop_pos = devpriv->ai_add_front + cmd->chanlist_len;
-	unsigned int raw_scanlen = devpriv->ai_add_front + cmd->chanlist_len +
-	    devpriv->ai_add_back;
+	unsigned int start_pos = devpriv->ai_add_front;
+	unsigned int stop_pos = start_pos + cmd->chanlist_len;
+	unsigned int span_len = stop_pos + devpriv->ai_add_back;
+	unsigned int dma_pos = devpriv->ai_act_dmapos;
+	unsigned int x;
 
-	for (i = 0; i < num_samples; i++) {
-		if (devpriv->ai_act_dmapos >= start_pos &&
-		    devpriv->ai_act_dmapos < stop_pos) {
-			dma_buffer[j++] = dma_buffer[i];
+	if (span_len == cmd->chanlist_len) {
+		/* All samples are to be copied. */
+		comedi_buf_write_samples(s, dma_buffer, n_raw_samples);
+		dma_pos += n_raw_samples;
+	} else {
+		/*
+		 * Not all samples are to be copied.  Buffer contents consist
+		 * of a possibly non-whole number of spans and a region of
+		 * each span is to be copied.
+		 */
+		while (n_raw_samples) {
+			if (dma_pos < start_pos) {
+				/* Skip samples before start position. */
+				x = start_pos - dma_pos;
+				if (x > n_raw_samples)
+					x = n_raw_samples;
+				dma_pos += x;
+				n_raw_samples -= x;
+				if (!n_raw_samples)
+					break;
+			}
+			if (dma_pos < stop_pos) {
+				/* Copy samples before stop position. */
+				x = stop_pos - dma_pos;
+				if (x > n_raw_samples)
+					x = n_raw_samples;
+				comedi_buf_write_samples(s, dma_buffer, x);
+				dma_pos += x;
+				n_raw_samples -= x;
+			}
+			/* Advance to next span. */
+			start_pos += span_len;
+			stop_pos += span_len;
 		}
-		devpriv->ai_act_dmapos++;
-		devpriv->ai_act_dmapos %= raw_scanlen;
 	}
-
-	return j;
+	/* Update position in span for next time. */
+	devpriv->ai_act_dmapos = dma_pos % span_len;
 }
 
 static void pci9118_exttrg_enable(struct comedi_device *dev, bool enable)
@@ -681,10 +708,8 @@ static void interrupt_pci9118_ai_dma(struct comedi_device *dev,
 		}
 	}
 
-	if (n_all) {
-		n_valid = defragment_dma_buffer(dev, s, dmabuf->virt, n_all);
-		comedi_buf_write_samples(s, dmabuf->virt, n_valid);
-	}
+	if (n_all)
+		move_block_from_dma(dev, s, dmabuf->virt, n_all);
 
 	if (!devpriv->ai_neverending) {
 		if (s->async->scans_done >= cmd->stop_arg)
-- 
2.1.3

