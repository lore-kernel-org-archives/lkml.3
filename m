Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbaK0Lhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:37:38 -0500
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:42516 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754391AbaK0Lhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:37:36 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] staging: comedi: adl_pci9118: try and avoid unnecessary DMA restart
Date: Thu, 27 Nov 2014 11:37:18 +0000
Message-Id: <1417088239-20460-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417088239-20460-1-git-send-email-abbotti@mev.co.uk>
References: <1417088239-20460-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`interrupt_pci9118_ai_dma()` is called on interrupt to transfer data
from DMA buffers into the comedi async data buffer.  Currently it always
restarts DMA.  If double buffering, it restarts DMA on the next DMA
buffer before processing the current DMA buffer, otherwise it restarts
DMA on the same DMA buffer after it has been processed.

For single buffering we can avoid restarting the DMA transfer by
checking the async event flags after the current buffer has been
processed, which is easy.

For double buffering, we need to know how many valid samples there are
in the current buffer before it has been processed and determine whether
there is enough to complete the acquisition.  Call new function
`valid_samples_in_act_dma_buf()` to determine the number of valid
samples in the current DMA buffer, and compare that with the result of
`comedi_nsamples_left()` to determine if DMA needs to be restarted.
(`comedi_nsamples_left()` needs an upper bound to clamp to, so use the
number of valid samples in the DMA buffer plus one for our test.)

It is still possible for DMA to be restarted unnecessarily in the double
buffer case if a `COMEDI_CB_OVERFLOW` event occurs while copying to the
comedi async buffer, but it doesn't really matter.  The ongoing DMA
operation will get disabled when the subdevice's `cancel()` handler is
called when the events are handled later in the interrupt service
routine (as it does currently).

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/adl_pci9118.c | 78 +++++++++++++++++++++++++---
 1 file changed, 71 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index aecfae8..c0ea733 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -446,6 +446,62 @@ static void interrupt_pci9118_ai_mode4_switch(struct comedi_device *dev,
 	outl(devpriv->ai_cfg, dev->iobase + PCI9118_AI_CFG_REG);
 }
 
+static unsigned int valid_samples_in_act_dma_buf(struct comedi_device *dev,
+						 struct comedi_subdevice *s,
+						 unsigned int n_raw_samples)
+{
+	struct pci9118_private *devpriv = dev->private;
+	struct comedi_cmd *cmd = &s->async->cmd;
+	unsigned int start_pos = devpriv->ai_add_front;
+	unsigned int stop_pos = start_pos + cmd->chanlist_len;
+	unsigned int span_len = stop_pos + devpriv->ai_add_back;
+	unsigned int dma_pos = devpriv->ai_act_dmapos;
+	unsigned int whole_spans, n_samples, x;
+
+	if (span_len == cmd->chanlist_len)
+		return n_raw_samples;	/* use all samples */
+
+	/*
+	 * Not all samples are to be used.  Buffer contents consist of a
+	 * possibly non-whole number of spans and a region of each span
+	 * is to be used.
+	 *
+	 * Account for samples in whole number of spans.
+	 */
+	whole_spans = n_raw_samples / span_len;
+	n_samples = whole_spans * cmd->chanlist_len;
+	n_raw_samples -= whole_spans * span_len;
+
+	/*
+	 * Deal with remaining samples which could overlap up to two spans.
+	 */
+	while (n_raw_samples) {
+		if (dma_pos < start_pos) {
+			/* Skip samples before start position. */
+			x = start_pos - dma_pos;
+			if (x > n_raw_samples)
+				x = n_raw_samples;
+			dma_pos += x;
+			n_raw_samples -= x;
+			if (!n_raw_samples)
+				break;
+		}
+		if (dma_pos < stop_pos) {
+			/* Include samples before stop position. */
+			x = stop_pos - dma_pos;
+			if (x > n_raw_samples)
+				x = n_raw_samples;
+			n_samples += x;
+			dma_pos += x;
+			n_raw_samples -= x;
+		}
+		/* Advance to next span. */
+		start_pos += span_len;
+		stop_pos += span_len;
+	}
+	return n_samples;
+}
+
 static unsigned int defragment_dma_buffer(struct comedi_device *dev,
 					  struct comedi_subdevice *s,
 					  unsigned short *dma_buffer,
@@ -607,10 +663,16 @@ static void interrupt_pci9118_ai_dma(struct comedi_device *dev,
 	struct pci9118_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 	struct pci9118_dmabuf *dmabuf = &devpriv->dmabuf[devpriv->dma_actbuf];
-	unsigned int nsamples = comedi_bytes_to_samples(s, dmabuf->use_size);
+	unsigned int n_all = comedi_bytes_to_samples(s, dmabuf->use_size);
+	unsigned int n_valid;
+	bool more_dma;
+
+	/* determine whether more DMA buffers to do after this one */
+	n_valid = valid_samples_in_act_dma_buf(dev, s, n_all);
+	more_dma = n_valid < comedi_nsamples_left(s, n_valid + 1);
 
 	/* switch DMA buffers and restart DMA if double buffering */
-	if (devpriv->dma_doublebuf) {
+	if (more_dma && devpriv->dma_doublebuf) {
 		devpriv->dma_actbuf = 1 - devpriv->dma_actbuf;
 		pci9118_amcc_setup_dma(dev, devpriv->dma_actbuf);
 		if (devpriv->ai_do == 4) {
@@ -619,10 +681,9 @@ static void interrupt_pci9118_ai_dma(struct comedi_device *dev,
 		}
 	}
 
-	if (nsamples) {
-		nsamples = defragment_dma_buffer(dev, s, dmabuf->virt,
-						 nsamples);
-		comedi_buf_write_samples(s, dmabuf->virt, nsamples);
+	if (n_all) {
+		n_valid = defragment_dma_buffer(dev, s, dmabuf->virt, n_all);
+		comedi_buf_write_samples(s, dmabuf->virt, n_valid);
 	}
 
 	if (!devpriv->ai_neverending) {
@@ -630,8 +691,11 @@ static void interrupt_pci9118_ai_dma(struct comedi_device *dev,
 			s->async->events |= COMEDI_CB_EOA;
 	}
 
+	if (s->async->events & COMEDI_CB_CANCEL_MASK)
+		more_dma = false;
+
 	/* restart DMA if not double buffering */
-	if (!devpriv->dma_doublebuf) {
+	if (more_dma && !devpriv->dma_doublebuf) {
 		pci9118_amcc_setup_dma(dev, 0);
 		if (devpriv->ai_do == 4)
 			interrupt_pci9118_ai_mode4_switch(dev, 0);
-- 
2.1.3

