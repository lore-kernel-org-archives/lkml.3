Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbaKRL0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:26:54 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:55368 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbaKRLYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:24:08 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 06/12] media: marvell-ccic: use vb2_ops_wait_prepare/finish helper
Date: Tue, 18 Nov 2014 11:23:35 +0000
Message-Id: <1416309821-5426-7-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416309821-5426-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1416309821-5426-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 29 +++++--------------------
 1 file changed, 5 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index f0eeb6c..eeb87d1 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1100,26 +1100,6 @@ static void mcam_vb_buf_queue(struct vb2_buffer *vb)
 		mcam_read_setup(cam);
 }
 
-
-/*
- * vb2 uses these to release the mutex when waiting in dqbuf.  I'm
- * not actually sure we need to do this (I'm not sure that vb2_dqbuf() needs
- * to be called with the mutex held), but better safe than sorry.
- */
-static void mcam_vb_wait_prepare(struct vb2_queue *vq)
-{
-	struct mcam_camera *cam = vb2_get_drv_priv(vq);
-
-	mutex_unlock(&cam->s_mutex);
-}
-
-static void mcam_vb_wait_finish(struct vb2_queue *vq)
-{
-	struct mcam_camera *cam = vb2_get_drv_priv(vq);
-
-	mutex_lock(&cam->s_mutex);
-}
-
 /*
  * These need to be called with the mutex held from vb2
  */
@@ -1189,8 +1169,8 @@ static const struct vb2_ops mcam_vb2_ops = {
 	.buf_queue		= mcam_vb_buf_queue,
 	.start_streaming	= mcam_vb_start_streaming,
 	.stop_streaming		= mcam_vb_stop_streaming,
-	.wait_prepare		= mcam_vb_wait_prepare,
-	.wait_finish		= mcam_vb_wait_finish,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
 };
 
 
@@ -1266,8 +1246,8 @@ static const struct vb2_ops mcam_vb2_sg_ops = {
 	.buf_cleanup		= mcam_vb_sg_buf_cleanup,
 	.start_streaming	= mcam_vb_start_streaming,
 	.stop_streaming		= mcam_vb_stop_streaming,
-	.wait_prepare		= mcam_vb_wait_prepare,
-	.wait_finish		= mcam_vb_wait_finish,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
 };
 
 #endif /* MCAM_MODE_DMA_SG */
@@ -1279,6 +1259,7 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 	memset(vq, 0, sizeof(*vq));
 	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	vq->drv_priv = cam;
+	vq->lock = &cam->s_mutex;
 	INIT_LIST_HEAD(&cam->buffers);
 	switch (cam->buffer_mode) {
 	case B_DMA_contig:
-- 
1.9.1

