Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbaDYQO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:14:58 -0400
Received: from mail.ispras.ru ([83.149.199.45]:46574 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbaDYQOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:14:53 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] [media] ivtv: avoid GFP_KERNEL in atomic context
Date: Fri, 25 Apr 2014 18:14:37 +0200
Message-Id: <1398442477-28876-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ivtv_yuv_init() is used in atomic context,
so memory allocation should be done keeping that in mind.

Call graph for ivtv_yuv_init() is as follows:
- ivtv_yuv_next_free()
  - ivtv_yuv_prep_frame() [ioctl handler]
  - ivtv_yuv_setup_stream_frame()
    - ivtv_irq_dec_data_req() -> ivtv_irq_handler() [ATOMIC CONTEXT]
    - ivtv_yuv_udma_stream_frame() [with mutex held]
    - ivtv_write() [with mutex held]

The patch adds gfp_t argument and implements its usage according to the context.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/pci/ivtv/ivtv-fileops.c |  2 +-
 drivers/media/pci/ivtv/ivtv-irq.c     |  2 +-
 drivers/media/pci/ivtv/ivtv-yuv.c     | 16 ++++++++--------
 drivers/media/pci/ivtv/ivtv-yuv.h     |  2 +-
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-fileops.c b/drivers/media/pci/ivtv/ivtv-fileops.c
index 9caffd8aa995..2e8885c245e7 100644
--- a/drivers/media/pci/ivtv/ivtv-fileops.c
+++ b/drivers/media/pci/ivtv/ivtv-fileops.c
@@ -689,7 +689,7 @@ retry:
 			int got_sig;
 
 			if (mode == OUT_YUV)
-				ivtv_yuv_setup_stream_frame(itv);
+				ivtv_yuv_setup_stream_frame(itv, GFP_KERNEL);
 
 			mutex_unlock(&itv->serialize_lock);
 			prepare_to_wait(&itv->dma_waitq, &wait, TASK_INTERRUPTIBLE);
diff --git a/drivers/media/pci/ivtv/ivtv-irq.c b/drivers/media/pci/ivtv/ivtv-irq.c
index 19a7c9b990a3..7a44f6b7aed4 100644
--- a/drivers/media/pci/ivtv/ivtv-irq.c
+++ b/drivers/media/pci/ivtv/ivtv-irq.c
@@ -822,7 +822,7 @@ static void ivtv_irq_dec_data_req(struct ivtv *itv)
 	}
 	else {
 		if (test_bit(IVTV_F_I_DEC_YUV, &itv->i_flags))
-			ivtv_yuv_setup_stream_frame(itv);
+			ivtv_yuv_setup_stream_frame(itv, GFP_ATOMIC);
 		clear_bit(IVTV_F_S_NEEDS_DATA, &s->s_flags);
 		ivtv_queue_move(s, &s->q_full, NULL, &s->q_predma, itv->dma_data_req_size);
 		ivtv_dma_stream_dec_prepare(s, itv->dma_data_req_offset + IVTV_DECODER_OFFSET, 0);
diff --git a/drivers/media/pci/ivtv/ivtv-yuv.c b/drivers/media/pci/ivtv/ivtv-yuv.c
index 2ad65eb29832..9bf47b89f8a0 100644
--- a/drivers/media/pci/ivtv/ivtv-yuv.c
+++ b/drivers/media/pci/ivtv/ivtv-yuv.c
@@ -854,7 +854,7 @@ void ivtv_yuv_work_handler(struct ivtv *itv)
 	yi->old_frame_info = f;
 }
 
-static void ivtv_yuv_init(struct ivtv *itv)
+static void ivtv_yuv_init(struct ivtv *itv, gfp_t gfp)
 {
 	struct yuv_playback_info *yi = &itv->yuv_info;
 
@@ -936,7 +936,7 @@ static void ivtv_yuv_init(struct ivtv *itv)
 	}
 
 	/* We need a buffer for blanking when Y plane is offset - non-fatal if we can't get one */
-	yi->blanking_ptr = kzalloc(720 * 16, GFP_KERNEL|__GFP_NOWARN);
+	yi->blanking_ptr = kzalloc(720 * 16, gfp|__GFP_NOWARN);
 	if (yi->blanking_ptr) {
 		yi->blanking_dmaptr = pci_map_single(itv->pdev, yi->blanking_ptr, 720*16, PCI_DMA_TODEVICE);
 	} else {
@@ -952,13 +952,13 @@ static void ivtv_yuv_init(struct ivtv *itv)
 }
 
 /* Get next available yuv buffer on PVR350 */
-static void ivtv_yuv_next_free(struct ivtv *itv)
+static void ivtv_yuv_next_free(struct ivtv *itv, gfp_t gfp)
 {
 	int draw, display;
 	struct yuv_playback_info *yi = &itv->yuv_info;
 
 	if (atomic_read(&yi->next_dma_frame) == -1)
-		ivtv_yuv_init(itv);
+		ivtv_yuv_init(itv, gfp);
 
 	draw = atomic_read(&yi->next_fill_frame);
 	display = atomic_read(&yi->next_dma_frame);
@@ -1119,12 +1119,12 @@ static int ivtv_yuv_udma_frame(struct ivtv *itv, struct ivtv_dma_frame *args)
 }
 
 /* Setup frame according to V4L2 parameters */
-void ivtv_yuv_setup_stream_frame(struct ivtv *itv)
+void ivtv_yuv_setup_stream_frame(struct ivtv *itv, gfp_t gfp)
 {
 	struct yuv_playback_info *yi = &itv->yuv_info;
 	struct ivtv_dma_frame dma_args;
 
-	ivtv_yuv_next_free(itv);
+	ivtv_yuv_next_free(itv, gfp);
 
 	/* Copy V4L2 parameters to an ivtv_dma_frame struct... */
 	dma_args.y_source = NULL;
@@ -1151,7 +1151,7 @@ int ivtv_yuv_udma_stream_frame(struct ivtv *itv, void __user *src)
 	struct ivtv_dma_frame dma_args;
 	int res;
 
-	ivtv_yuv_setup_stream_frame(itv);
+	ivtv_yuv_setup_stream_frame(itv, GFP_KERNEL);
 
 	/* We only need to supply source addresses for this */
 	dma_args.y_source = src;
@@ -1171,7 +1171,7 @@ int ivtv_yuv_prep_frame(struct ivtv *itv, struct ivtv_dma_frame *args)
 	int res;
 
 /*	IVTV_DEBUG_INFO("yuv_prep_frame\n"); */
-	ivtv_yuv_next_free(itv);
+	ivtv_yuv_next_free(itv, GFP_KERNEL);
 	ivtv_yuv_setup_frame(itv, args);
 	/* Wait for frame DMA. Note that serialize_lock is locked,
 	   so to allow other processes to access the driver while
diff --git a/drivers/media/pci/ivtv/ivtv-yuv.h b/drivers/media/pci/ivtv/ivtv-yuv.h
index ca5173fbf006..06753cfe64f3 100644
--- a/drivers/media/pci/ivtv/ivtv-yuv.h
+++ b/drivers/media/pci/ivtv/ivtv-yuv.h
@@ -34,7 +34,7 @@
 extern const u32 yuv_offset[IVTV_YUV_BUFFERS];
 
 int ivtv_yuv_filter_check(struct ivtv *itv);
-void ivtv_yuv_setup_stream_frame(struct ivtv *itv);
+void ivtv_yuv_setup_stream_frame(struct ivtv *itv, gfp_t gfp);
 int ivtv_yuv_udma_stream_frame(struct ivtv *itv, void __user *src);
 void ivtv_yuv_frame_complete(struct ivtv *itv);
 int ivtv_yuv_prep_frame(struct ivtv *itv, struct ivtv_dma_frame *args);
-- 
1.8.3.2

