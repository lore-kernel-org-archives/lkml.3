Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbaKZWoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:44:55 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35541 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbaKZWnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:43:21 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 06/11] media: marvell-ccic: use vb2_ops_wait_prepare/finish helper
Date: Wed, 26 Nov 2014 22:42:29 +0000
Message-Id: <1417041754-8714-7-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417041754-8714-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1417041754-8714-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch drops driver specific wait_prepare() and
wait_finish() callbacks from vb2_ops and instead uses
the the helpers vb2_ops_wait_prepare/finish() provided
by the vb2 core, the lock member of the queue needs
to be initalized to a mutex so that vb2 helpers
vb2_ops_wait_prepare/finish() can make use of it.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 29 +++++--------------------
 1 file changed, 5 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index ce00cba..4ec29c0 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1102,26 +1102,6 @@ static void mcam_vb_buf_queue(struct vb2_buffer *vb)
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
@@ -1191,8 +1171,8 @@ static const struct vb2_ops mcam_vb2_ops = {
 	.buf_queue		= mcam_vb_buf_queue,
 	.start_streaming	= mcam_vb_start_streaming,
 	.stop_streaming		= mcam_vb_stop_streaming,
-	.wait_prepare		= mcam_vb_wait_prepare,
-	.wait_finish		= mcam_vb_wait_finish,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
 };
 
 
@@ -1252,8 +1232,8 @@ static const struct vb2_ops mcam_vb2_sg_ops = {
 	.buf_cleanup		= mcam_vb_sg_buf_cleanup,
 	.start_streaming	= mcam_vb_start_streaming,
 	.stop_streaming		= mcam_vb_stop_streaming,
-	.wait_prepare		= mcam_vb_wait_prepare,
-	.wait_finish		= mcam_vb_wait_finish,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
 };
 
 #endif /* MCAM_MODE_DMA_SG */
@@ -1265,6 +1245,7 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 	memset(vq, 0, sizeof(*vq));
 	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	vq->drv_priv = cam;
+	vq->lock = &cam->s_mutex;
 	INIT_LIST_HEAD(&cam->buffers);
 	switch (cam->buffer_mode) {
 	case B_DMA_contig:
-- 
1.9.1

