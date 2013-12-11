Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab3LKIUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 03:20:18 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:54424 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab3LKIUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 03:20:15 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Daniel Mack <zonque@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Sergei Ianovich <ynvich@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 5/9] ARM: dts: provide DMA config to pxamci
References: <1386348542-9584-1-git-send-email-ynvich@gmail.com>
	<1386543229-1542-1-git-send-email-ynvich@gmail.com>
	<1386543229-1542-6-git-send-email-ynvich@gmail.com>
	<201312090233.58592.arnd@arndb.de> <52A587A0.1050503@gmail.com>
X-URL: http://belgarath.falguerolles.org/
Date: Wed, 11 Dec 2013 09:19:33 +0100
In-Reply-To: <52A587A0.1050503@gmail.com> (Daniel Mack's message of "Mon, 09
	Dec 2013 10:04:32 +0100")
Message-ID: <87a9g77qay.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack <zonque@gmail.com> writes:

> In particular, the pxa camera driver is something Robert (cc) wanted to
> have a look at. Robert, any updates on this?
Oh yes, sorry, it's been monthes, I've been very busy.

This is my last status :
 - my current patch is in (1)

 - this patch doesn't work yet

 - if my memory serves me well, I have reached the conclusion that dmaengine
   pxa-mpp driver doesn't allow pxa_camera to work properly in the current
   state.  This is a long time since I checked, so take the following with
   caution until I have checked again.

This assertion is based on this required behaviour :
 - video buffers are queued, let's say 5
   => 5 dma are "prepared"

 - video buffers are submitted
   => 5 dma xfers are submitted

 - the userspace polls for each finished frame (ie. dma xfer termination), and
   on the third one, resubmits the 2 finished frames
     => scatter-gathers should mot be recomputed, just xfer should be
     resubmitted, with cache sync operations and first/last descriptors chaining

 - the pxa_camera driver needs a way to know if a dma channel is still running,
   for missed chaining transfers, because if a channel stopped, the dma xfers
   should not be submitted until IRQ "begin of frame" is encoutered. I didn't
   find a way for that.

Now, I will retry this weekend, but if I remember correctly the issues I had
were :
 - a transfer cannot be resubmitted, it has to be freed and recreated
 - if it is resubmitted, the completion is not signaled by the tasklet

Cheers.

--
Robert

(1)
commit 4741ba6 (pxa_camera_dmaengine, backup/pxa_camera_dmaengine)
Author: Robert Jarzmik <robert.jarzmik@free.fr>
Date:   Sat Aug 24 21:13:38 2013 +0200

    WIP: pxa_camera dmaengine conversion
    
    Only slightly tested, without much success.
    
    Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index d4df305..903ea03 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -9,7 +9,7 @@
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  */
-
+#define DEBUG 1
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/io.h>
@@ -28,6 +28,9 @@
 #include <linux/clk.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
+#include <linux/dma/mmp-pdma.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
@@ -37,7 +40,6 @@
 
 #include <linux/videodev2.h>
 
-#include <mach/dma.h>
 #include <linux/platform_data/camera-pxa.h>
 
 #define PXA_CAM_VERSION "0.0.6"
@@ -174,21 +176,13 @@ enum pxa_camera_active_dma {
 	DMA_V = 0x4,
 };
 
-/* descriptor needed for the PXA DMA engine */
-struct pxa_cam_dma {
-	dma_addr_t		sg_dma;
-	struct pxa_dma_desc	*sg_cpu;
-	size_t			sg_size;
-	int			sglen;
-};
-
 /* buffer for one video frame */
 struct pxa_buffer {
 	/* common v4l buffer stuff -- must be first */
 	struct videobuf_buffer		vb;
 	enum v4l2_mbus_pixelcode	code;
 	/* our descriptor lists for Y, U and V channels */
-	struct pxa_cam_dma		dmas[3];
+	struct dma_async_tx_descriptor	*descs[3];
 	int				inwork;
 	enum pxa_camera_active_dma	active_dma;
 };
@@ -206,7 +200,7 @@ struct pxa_camera_dev {
 	void __iomem		*base;
 
 	int			channels;
-	unsigned int		dma_chans[3];
+	struct dma_chan		*dma_chans[3];
 
 	struct pxacamera_platform_data *pdata;
 	struct resource		*res;
@@ -221,7 +215,6 @@ struct pxa_camera_dev {
 	spinlock_t		lock;
 
 	struct pxa_buffer	*active;
-	struct pxa_dma_desc	*sg_tail[3];
 
 	u32			save_cicr[5];
 };
@@ -273,40 +266,70 @@ static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
 	videobuf_waiton(vq, &buf->vb, 0, 0);
 	videobuf_dma_unmap(vq->dev, dma);
 	videobuf_dma_free(dma);
-
-	for (i = 0; i < ARRAY_SIZE(buf->dmas); i++) {
-		if (buf->dmas[i].sg_cpu)
-			dma_free_coherent(ici->v4l2_dev.dev,
-					  buf->dmas[i].sg_size,
-					  buf->dmas[i].sg_cpu,
-					  buf->dmas[i].sg_dma);
-		buf->dmas[i].sg_cpu = NULL;
-	}
+	/* FIXME: free buf->descs[0..2] */
 
 	buf->vb.state = VIDEOBUF_NEEDS_INIT;
+
+	dev_dbg(icd->parent, "%s end (vb=0x%p) 0x%08lx %d\n", __func__,
+		&buf->vb, buf->vb.baddr, buf->vb.bsize);
 }
 
-static int calculate_dma_sglen(struct scatterlist *sglist, int sglen,
-			       int sg_first_ofs, int size)
+static struct scatterlist *videobuf_sg_splice(struct scatterlist *sglist,
+					      int sglen, int offset, int size,
+					      int *new_sg_len)
 {
-	int i, offset, dma_len, xfer_len;
-	struct scatterlist *sg;
+	struct scatterlist *sg0, *sg;
+	int nfirst, i, dma_len, xfer_len;
 
-	offset = sg_first_ofs;
-	for_each_sg(sglist, sg, sglen, i) {
+	sg0 = kmalloc(sizeof(struct scatterlist) * sglen, GFP_KERNEL);
+	if (!sg0)
+		return NULL;
+	for_each_sg(sglist, sg, sglen, nfirst) {
 		dma_len = sg_dma_len(sg);
-
+		if (offset < dma_len)
+			break;
 		/* PXA27x Developer's Manual 27.4.4.1: round up to 8 bytes */
-		xfer_len = roundup(min(dma_len - offset, size), 8);
-
-		size = max(0, size - xfer_len);
-		offset = 0;
-		if (size == 0)
+		xfer_len = roundup(min(dma_len - offset, offset), 8);
+		offset = max(0, offset - xfer_len);
+	}
+	BUG_ON(sg_is_last(&sglist[nfirst]));
+	for_each_sg(&sglist[nfirst], sg, sglen - nfirst, i) {
+		sg0[i] = sglist[nfirst];
+		sg0[i].offset = offset;
+		sg_dma_len(&sg0[i]) -= offset;
+		if (size <= sg_dma_len(sg))
 			break;
+		offset = 0;
+		size -= roundup(sg_dma_len(sg), 8);
+	}
+	if (size) {
+		sg_dma_len(&sg0[i]) = size;
+		*new_sg_len = i + 1;
+	} else {
+		*new_sg_len = i;
 	}
 
-	BUG_ON(size != 0);
-	return i + 1;
+	return sg0;
+}
+static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
+			       enum pxa_camera_active_dma act_dma);
+
+static void pxa_camera_dma_irq_y(void *data)
+{
+	struct pxa_camera_dev *pcdev = data;
+	pxa_camera_dma_irq(pcdev, DMA_Y);
+}
+
+static void pxa_camera_dma_irq_u(void *data)
+{
+	struct pxa_camera_dev *pcdev = data;
+	pxa_camera_dma_irq(pcdev, DMA_U);
+}
+
+static void pxa_camera_dma_irq_v(void *data)
+{
+	struct pxa_camera_dev *pcdev = data;
+	pxa_camera_dma_irq(pcdev, DMA_V);
 }
 
 /**
@@ -317,91 +340,68 @@ static int calculate_dma_sglen(struct scatterlist *sglist, int sglen,
  * @channel: dma channel (0 => 'Y', 1 => 'U', 2 => 'V')
  * @cibr: camera Receive Buffer Register
  * @size: bytes to transfer
- * @sg_first: first element of sg_list
- * @sg_first_ofs: offset in first element of sg_list
+ * @offset: offset in videobuffer of the first byte to transfer
  *
  * Prepares the pxa dma descriptors to transfer one camera channel.
- * Beware sg_first and sg_first_ofs are both input and output parameters.
  *
- * Returns 0 or -ENOMEM if no coherent memory is available
+ * Returns 0 if success or -ENOMEM if no memory is available
  */
 static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
 				struct pxa_buffer *buf,
 				struct videobuf_dmabuf *dma, int channel,
-				int cibr, int size,
-				struct scatterlist **sg_first, int *sg_first_ofs)
+				int cibr, int size, int offset)
 {
-	struct pxa_cam_dma *pxa_dma = &buf->dmas[channel];
-	struct device *dev = pcdev->soc_host.v4l2_dev.dev;
-	struct scatterlist *sg;
-	int i, offset, sglen;
-	int dma_len = 0, xfer_len = 0;
+	struct dma_chan *dma_chan = pcdev->dma_chans[channel];
+	struct scatterlist *sg = NULL;
+	int ret, sglen;
+	struct dma_slave_config config;
+	struct dma_async_tx_descriptor *tx;
 
-	if (pxa_dma->sg_cpu)
-		dma_free_coherent(dev, pxa_dma->sg_size,
-				  pxa_dma->sg_cpu, pxa_dma->sg_dma);
+	dmaengine_terminate_all(dma_chan);
 
-	sglen = calculate_dma_sglen(*sg_first, dma->sglen,
-				    *sg_first_ofs, size);
-
-	pxa_dma->sg_size = (sglen + 1) * sizeof(struct pxa_dma_desc);
-	pxa_dma->sg_cpu = dma_alloc_coherent(dev, pxa_dma->sg_size,
-					     &pxa_dma->sg_dma, GFP_KERNEL);
-	if (!pxa_dma->sg_cpu)
+	sg = videobuf_sg_splice(dma->sglist, dma->sglen, offset, size, &sglen);
+	if (!sg)
 		return -ENOMEM;
 
-	pxa_dma->sglen = sglen;
-	offset = *sg_first_ofs;
-
-	dev_dbg(dev, "DMA: sg_first=%p, sglen=%d, ofs=%d, dma.desc=%x\n",
-		*sg_first, sglen, *sg_first_ofs, pxa_dma->sg_dma);
-
+	memset(&config, 0, sizeof(config));
+	config.src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE; /* FIXME? */
+	config.src_maxburst = 8;
+	config.src_addr = pcdev->res->start + cibr;
+	config.direction = DMA_DEV_TO_MEM;
 
-	for_each_sg(*sg_first, sg, sglen, i) {
-		dma_len = sg_dma_len(sg);
-
-		/* PXA27x Developer's Manual 27.4.4.1: round up to 8 bytes */
-		xfer_len = roundup(min(dma_len - offset, size), 8);
-
-		size = max(0, size - xfer_len);
-
-		pxa_dma->sg_cpu[i].dsadr = pcdev->res->start + cibr;
-		pxa_dma->sg_cpu[i].dtadr = sg_dma_address(sg) + offset;
-		pxa_dma->sg_cpu[i].dcmd =
-			DCMD_FLOWSRC | DCMD_BURST8 | DCMD_INCTRGADDR | xfer_len;
-#ifdef DEBUG
-		if (!i)
-			pxa_dma->sg_cpu[i].dcmd |= DCMD_STARTIRQEN;
-#endif
-		pxa_dma->sg_cpu[i].ddadr =
-			pxa_dma->sg_dma + (i + 1) * sizeof(struct pxa_dma_desc);
-
-		dev_vdbg(dev, "DMA: desc.%08x->@phys=0x%08x, len=%d\n",
-			 pxa_dma->sg_dma + i * sizeof(struct pxa_dma_desc),
-			 sg_dma_address(sg) + offset, xfer_len);
-		offset = 0;
-
-		if (size == 0)
-			break;
+	ret = dmaengine_slave_config(dma_chan, &config);
+	if (ret < 0) {
+		printk("%s(): dma slave config failed: %d\n", __func__, ret);
+		return ret;
 	}
 
-	pxa_dma->sg_cpu[sglen].ddadr = DDADR_STOP;
-	pxa_dma->sg_cpu[sglen].dcmd  = DCMD_FLOWSRC | DCMD_BURST8 | DCMD_ENDIRQEN;
+	tx = dmaengine_prep_slave_sg(dma_chan, sg, sglen,
+				     config.direction,
+				     DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!tx) {
+		printk("%s(): prep_slave_sg() failed\n", __func__);
+		goto fail;
+	}
 
-	/*
-	 * Handle 1 special case :
-	 *  - in 3 planes (YUV422P format), we might finish with xfer_len equal
-	 *    to dma_len (end on PAGE boundary). In this case, the sg element
-	 *    for next plane should be the next after the last used to store the
-	 *    last scatter gather RAM page
-	 */
-	if (xfer_len >= dma_len) {
-		*sg_first_ofs = xfer_len - dma_len;
-		*sg_first = sg_next(sg);
-	} else {
-		*sg_first_ofs = xfer_len;
-		*sg_first = sg;
+	tx->callback_param = pcdev;
+	switch (channel) {
+	case 0:
+		tx->callback = pxa_camera_dma_irq_y;
+		break;
+	case 1:
+		tx->callback = pxa_camera_dma_irq_u;
+		break;
+	case 2:
+		tx->callback = pxa_camera_dma_irq_v;
+		break;
 	}
+fail:
+	kfree(sg);
+	buf->descs[channel] = tx;
+
+	dev_dbg(pcdev->soc_host.v4l2_dev.dev,
+		"%s (vb=0x%p) dma_tx=%p\n",
+		__func__, &buf->vb, tx);
 
 	return 0;
 }
@@ -470,11 +470,10 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 		goto out;
 	}
 
-	if (vb->state == VIDEOBUF_NEEDS_INIT) {
+	//if (vb->state == VIDEOBUF_NEEDS_INIT) {
+	if (vb->state != VIDEOBUF_PREPARED) {
 		int size = vb->size;
-		int next_ofs = 0;
 		struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
-		struct scatterlist *sg;
 
 		ret = videobuf_iolock(vq, vb, NULL);
 		if (ret)
@@ -487,11 +486,8 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 			size_y = size;
 		}
 
-		sg = dma->sglist;
-
 		/* init DMA for Y channel */
-		ret = pxa_init_dma_channel(pcdev, buf, dma, 0, CIBR0, size_y,
-					   &sg, &next_ofs);
+		ret = pxa_init_dma_channel(pcdev, buf, dma, 0, CIBR0, size_y, 0);
 		if (ret) {
 			dev_err(dev, "DMA initialization for Y/RGB failed\n");
 			goto fail;
@@ -500,7 +496,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 		/* init DMA for U channel */
 		if (size_u)
 			ret = pxa_init_dma_channel(pcdev, buf, dma, 1, CIBR1,
-						   size_u, &sg, &next_ofs);
+						   size_u, size_y);
 		if (ret) {
 			dev_err(dev, "DMA initialization for U failed\n");
 			goto fail_u;
@@ -509,7 +505,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 		/* init DMA for V channel */
 		if (size_v)
 			ret = pxa_init_dma_channel(pcdev, buf, dma, 2, CIBR2,
-						   size_v, &sg, &next_ofs);
+						   size_v, size_y + size_u);
 		if (ret) {
 			dev_err(dev, "DMA initialization for V failed\n");
 			goto fail_v;
@@ -524,11 +520,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 	return 0;
 
 fail_v:
-	dma_free_coherent(dev, buf->dmas[1].sg_size,
-			  buf->dmas[1].sg_cpu, buf->dmas[1].sg_dma);
 fail_u:
-	dma_free_coherent(dev, buf->dmas[0].sg_size,
-			  buf->dmas[0].sg_cpu, buf->dmas[0].sg_dma);
 fail:
 	free_buffer(vq, buf);
 out:
@@ -552,10 +544,8 @@ static void pxa_dma_start_channels(struct pxa_camera_dev *pcdev)
 
 	for (i = 0; i < pcdev->channels; i++) {
 		dev_dbg(pcdev->soc_host.v4l2_dev.dev,
-			"%s (channel=%d) ddadr=%08x\n", __func__,
-			i, active->dmas[i].sg_dma);
-		DDADR(pcdev->dma_chans[i]) = active->dmas[i].sg_dma;
-		DCSR(pcdev->dma_chans[i]) = DCSR_RUN;
+			"%s (channel=%d)\n", __func__, i);
+		dma_async_issue_pending(pcdev->dma_chans[i]);
 	}
 }
 
@@ -566,7 +556,7 @@ static void pxa_dma_stop_channels(struct pxa_camera_dev *pcdev)
 	for (i = 0; i < pcdev->channels; i++) {
 		dev_dbg(pcdev->soc_host.v4l2_dev.dev,
 			"%s (channel=%d)\n", __func__, i);
-		DCSR(pcdev->dma_chans[i]) = 0;
+		dmaengine_terminate_all(pcdev->dma_chans[i]);
 	}
 }
 
@@ -574,18 +564,12 @@ static void pxa_dma_add_tail_buf(struct pxa_camera_dev *pcdev,
 				 struct pxa_buffer *buf)
 {
 	int i;
-	struct pxa_dma_desc *buf_last_desc;
 
 	for (i = 0; i < pcdev->channels; i++) {
-		buf_last_desc = buf->dmas[i].sg_cpu + buf->dmas[i].sglen;
-		buf_last_desc->ddadr = DDADR_STOP;
-
-		if (pcdev->sg_tail[i])
-			/* Link the new buffer to the old tail */
-			pcdev->sg_tail[i]->ddadr = buf->dmas[i].sg_dma;
-
-		/* Update the channel tail */
-		pcdev->sg_tail[i] = buf_last_desc;
+		dmaengine_submit(buf->descs[i]);
+		dev_dbg(pcdev->soc_host.v4l2_dev.dev,
+			"%s (channel=%d) : submit vb=%p cookie=%d\n",
+			__func__, i, buf, buf->descs[i]->cookie);
 	}
 }
 
@@ -676,8 +660,6 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
 			      struct videobuf_buffer *vb,
 			      struct pxa_buffer *buf)
 {
-	int i;
-
 	/* _init is used to debug races, see comment in pxa_camera_reqbufs() */
 	list_del_init(&vb->queue);
 	vb->state = VIDEOBUF_DONE;
@@ -689,8 +671,6 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
 
 	if (list_empty(&pcdev->capture)) {
 		pxa_camera_stop_capture(pcdev);
-		for (i = 0; i < pcdev->channels; i++)
-			pcdev->sg_tail[i] = NULL;
 		return;
 	}
 
@@ -716,48 +696,33 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
  */
 static void pxa_camera_check_link_miss(struct pxa_camera_dev *pcdev)
 {
-	int i, is_dma_stopped = 1;
+	/* FIXME: ask dmaengine if channel is still running */
+	int is_dma_stopped = 1;
 
-	for (i = 0; i < pcdev->channels; i++)
-		if (DDADR(pcdev->dma_chans[i]) != DDADR_STOP)
-			is_dma_stopped = 0;
 	dev_dbg(pcdev->soc_host.v4l2_dev.dev,
-		"%s : top queued buffer=%p, dma_stopped=%d\n",
-		__func__, pcdev->active, is_dma_stopped);
+		"%s : top queued buffer=%p\n", __func__, pcdev->active);
+	if (pcdev->active)
+		pxa_dma_start_channels(pcdev);
 	if (pcdev->active && is_dma_stopped)
 		pxa_camera_start_capture(pcdev);
 }
 
-static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
+static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
 			       enum pxa_camera_active_dma act_dma)
 {
 	struct device *dev = pcdev->soc_host.v4l2_dev.dev;
 	struct pxa_buffer *buf;
 	unsigned long flags;
-	u32 status, camera_status, overrun;
+	u32 camera_status, overrun;
 	struct videobuf_buffer *vb;
 
 	spin_lock_irqsave(&pcdev->lock, flags);
 
-	status = DCSR(channel);
-	DCSR(channel) = status;
-
 	camera_status = __raw_readl(pcdev->base + CISR);
 	overrun = CISR_IFO_0;
 	if (pcdev->channels == 3)
 		overrun |= CISR_IFO_1 | CISR_IFO_2;
 
-	if (status & DCSR_BUSERR) {
-		dev_err(dev, "DMA Bus Error IRQ!\n");
-		goto out;
-	}
-
-	if (!(status & (DCSR_ENDINTR | DCSR_STARTINTR))) {
-		dev_err(dev, "Unknown DMA IRQ source, status: 0x%08x\n",
-			status);
-		goto out;
-	}
-
 	/*
 	 * pcdev->active should not be NULL in DMA irq handler.
 	 *
@@ -777,52 +742,28 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
 	buf = container_of(vb, struct pxa_buffer, vb);
 	WARN_ON(buf->inwork || list_empty(&vb->queue));
 
-	dev_dbg(dev, "%s channel=%d %s%s(vb=0x%p) dma.desc=%x\n",
-		__func__, channel, status & DCSR_STARTINTR ? "SOF " : "",
-		status & DCSR_ENDINTR ? "EOF " : "", vb, DDADR(channel));
-
-	if (status & DCSR_ENDINTR) {
-		/*
-		 * It's normal if the last frame creates an overrun, as there
-		 * are no more DMA descriptors to fetch from QCI fifos
-		 */
-		if (camera_status & overrun &&
-		    !list_is_last(pcdev->capture.next, &pcdev->capture)) {
-			dev_dbg(dev, "FIFO overrun! CISR: %x\n",
-				camera_status);
-			pxa_camera_stop_capture(pcdev);
-			pxa_camera_start_capture(pcdev);
-			goto out;
-		}
-		buf->active_dma &= ~act_dma;
-		if (!buf->active_dma) {
-			pxa_camera_wakeup(pcdev, vb, buf);
-			pxa_camera_check_link_miss(pcdev);
-		}
+	/*
+	 * It's normal if the last frame creates an overrun, as there
+	 * are no more DMA descriptors to fetch from QCI fifos
+	 */
+	if (camera_status & overrun &&
+	    !list_is_last(pcdev->capture.next, &pcdev->capture)) {
+		dev_dbg(dev, "FIFO overrun! CISR: %x\n",
+			camera_status);
+		pxa_camera_stop_capture(pcdev);
+		pxa_camera_start_capture(pcdev);
+		goto out;
+	}
+	buf->active_dma &= ~act_dma;
+	if (!buf->active_dma) {
+		pxa_camera_wakeup(pcdev, vb, buf);
+		pxa_camera_check_link_miss(pcdev);
 	}
 
 out:
 	spin_unlock_irqrestore(&pcdev->lock, flags);
 }
 
-static void pxa_camera_dma_irq_y(int channel, void *data)
-{
-	struct pxa_camera_dev *pcdev = data;
-	pxa_camera_dma_irq(channel, pcdev, DMA_Y);
-}
-
-static void pxa_camera_dma_irq_u(int channel, void *data)
-{
-	struct pxa_camera_dev *pcdev = data;
-	pxa_camera_dma_irq(channel, pcdev, DMA_U);
-}
-
-static void pxa_camera_dma_irq_v(int channel, void *data)
-{
-	struct pxa_camera_dev *pcdev = data;
-	pxa_camera_dma_irq(channel, pcdev, DMA_V);
-}
-
 static struct videobuf_queue_ops pxa_videobuf_ops = {
 	.buf_setup      = pxa_videobuf_setup,
 	.buf_prepare    = pxa_videobuf_prepare,
@@ -992,10 +933,7 @@ static void pxa_camera_clock_stop(struct soc_camera_host *ici)
 	__raw_writel(0x3ff, pcdev->base + CICR0);
 
 	/* Stop DMA engine */
-	DCSR(pcdev->dma_chans[0]) = 0;
-	DCSR(pcdev->dma_chans[1]) = 0;
-	DCSR(pcdev->dma_chans[2]) = 0;
-
+	pxa_dma_stop_channels(pcdev);
 	pxa_camera_deactivate(pcdev);
 }
 
@@ -1608,10 +1546,6 @@ static int pxa_camera_resume(struct device *dev)
 	struct pxa_camera_dev *pcdev = ici->priv;
 	int i = 0, ret = 0;
 
-	DRCMR(68) = pcdev->dma_chans[0] | DRCMR_MAPVLD;
-	DRCMR(69) = pcdev->dma_chans[1] | DRCMR_MAPVLD;
-	DRCMR(70) = pcdev->dma_chans[2] | DRCMR_MAPVLD;
-
 	__raw_writel(pcdev->save_cicr[i++] & ~CICR0_ENB, pcdev->base + CICR0);
 	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR1);
 	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR2);
@@ -1655,6 +1589,8 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	struct pxa_camera_dev *pcdev;
 	struct resource *res;
 	void __iomem *base;
+	dma_cap_mask_t mask;
+	unsigned int drcmr;
 	int irq;
 	int err = 0;
 
@@ -1717,36 +1653,35 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	pcdev->base = base;
 
 	/* request dma */
-	err = pxa_request_dma("CI_Y", DMA_PRIO_HIGH,
-			      pxa_camera_dma_irq_y, pcdev);
-	if (err < 0) {
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+
+	drcmr = 68;
+	pcdev->dma_chans[0] =
+		dma_request_slave_channel_compat(mask, mmp_pdma_filter_fn,
+						 &drcmr, &pdev->dev, "CI_Y");
+	if (!pcdev->dma_chans[0]) {
 		dev_err(&pdev->dev, "Can't request DMA for Y\n");
-		return err;
+		return -ENODEV;
 	}
-	pcdev->dma_chans[0] = err;
-	dev_dbg(&pdev->dev, "got DMA channel %d\n", pcdev->dma_chans[0]);
 
-	err = pxa_request_dma("CI_U", DMA_PRIO_HIGH,
-			      pxa_camera_dma_irq_u, pcdev);
-	if (err < 0) {
-		dev_err(&pdev->dev, "Can't request DMA for U\n");
+	drcmr = 69;
+	pcdev->dma_chans[1] =
+		dma_request_slave_channel_compat(mask, mmp_pdma_filter_fn,
+						 &drcmr, &pdev->dev, "CI_U");
+	if (!pcdev->dma_chans[1]) {
+		dev_err(&pdev->dev, "Can't request DMA for Y\n");
 		goto exit_free_dma_y;
 	}
-	pcdev->dma_chans[1] = err;
-	dev_dbg(&pdev->dev, "got DMA channel (U) %d\n", pcdev->dma_chans[1]);
 
-	err = pxa_request_dma("CI_V", DMA_PRIO_HIGH,
-			      pxa_camera_dma_irq_v, pcdev);
-	if (err < 0) {
+	drcmr = 70;
+	pcdev->dma_chans[2] =
+		dma_request_slave_channel_compat(mask, mmp_pdma_filter_fn,
+						 &drcmr, &pdev->dev, "CI_V");
+	if (!pcdev->dma_chans[2]) {
 		dev_err(&pdev->dev, "Can't request DMA for V\n");
 		goto exit_free_dma_u;
 	}
-	pcdev->dma_chans[2] = err;
-	dev_dbg(&pdev->dev, "got DMA channel (V) %d\n", pcdev->dma_chans[2]);
-
-	DRCMR(68) = pcdev->dma_chans[0] | DRCMR_MAPVLD;
-	DRCMR(69) = pcdev->dma_chans[1] | DRCMR_MAPVLD;
-	DRCMR(70) = pcdev->dma_chans[2] | DRCMR_MAPVLD;
 
 	/* request irq */
 	err = devm_request_irq(&pdev->dev, pcdev->irq, pxa_camera_irq, 0,
@@ -1769,11 +1704,11 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	return 0;
 
 exit_free_dma:
-	pxa_free_dma(pcdev->dma_chans[2]);
+	dma_release_channel(pcdev->dma_chans[2]);
 exit_free_dma_u:
-	pxa_free_dma(pcdev->dma_chans[1]);
+	dma_release_channel(pcdev->dma_chans[1]);
 exit_free_dma_y:
-	pxa_free_dma(pcdev->dma_chans[0]);
+	dma_release_channel(pcdev->dma_chans[0]);
 	return err;
 }
 
@@ -1783,9 +1718,9 @@ static int pxa_camera_remove(struct platform_device *pdev)
 	struct pxa_camera_dev *pcdev = container_of(soc_host,
 					struct pxa_camera_dev, soc_host);
 
-	pxa_free_dma(pcdev->dma_chans[0]);
-	pxa_free_dma(pcdev->dma_chans[1]);
-	pxa_free_dma(pcdev->dma_chans[2]);
+	dma_release_channel(pcdev->dma_chans[0]);
+	dma_release_channel(pcdev->dma_chans[1]);
+	dma_release_channel(pcdev->dma_chans[2]);
 
 	soc_camera_host_unregister(soc_host);
 
----------

