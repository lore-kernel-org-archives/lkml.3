Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbaKRLYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:24:20 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:38688 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbaKRLYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:24:13 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 10/12] media: vivid: use vb2_ops_wait_prepare/finish helper
Date: Tue, 18 Nov 2014 11:23:39 +0000
Message-Id: <1416309821-5426-11-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416309821-5426-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1416309821-5426-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.c    | 19 +++++--------------
 drivers/media/platform/vivid/vivid-core.h    |  3 ---
 drivers/media/platform/vivid/vivid-sdr-cap.c |  4 ++--
 drivers/media/platform/vivid/vivid-vbi-cap.c |  4 ++--
 drivers/media/platform/vivid/vivid-vbi-out.c |  4 ++--
 drivers/media/platform/vivid/vivid-vid-cap.c |  4 ++--
 drivers/media/platform/vivid/vivid-vid-out.c |  4 ++--
 7 files changed, 15 insertions(+), 27 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 686c3c2..987a46c 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -195,20 +195,6 @@ static const u8 vivid_hdmi_edid[256] = {
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xd7
 };
 
-void vivid_lock(struct vb2_queue *vq)
-{
-	struct vivid_dev *dev = vb2_get_drv_priv(vq);
-
-	mutex_lock(&dev->mutex);
-}
-
-void vivid_unlock(struct vb2_queue *vq)
-{
-	struct vivid_dev *dev = vb2_get_drv_priv(vq);
-
-	mutex_unlock(&dev->mutex);
-}
-
 static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
@@ -1018,6 +1004,7 @@ static int __init vivid_create_instance(int inst)
 		q->mem_ops = &vb2_vmalloc_memops;
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
+		q->lock = &dev->mutex;
 
 		ret = vb2_queue_init(q);
 		if (ret)
@@ -1036,6 +1023,7 @@ static int __init vivid_create_instance(int inst)
 		q->mem_ops = &vb2_vmalloc_memops;
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
+		q->lock = &dev->mutex;
 
 		ret = vb2_queue_init(q);
 		if (ret)
@@ -1054,6 +1042,7 @@ static int __init vivid_create_instance(int inst)
 		q->mem_ops = &vb2_vmalloc_memops;
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
+		q->lock = &dev->mutex;
 
 		ret = vb2_queue_init(q);
 		if (ret)
@@ -1072,6 +1061,7 @@ static int __init vivid_create_instance(int inst)
 		q->mem_ops = &vb2_vmalloc_memops;
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
+		q->lock = &dev->mutex;
 
 		ret = vb2_queue_init(q);
 		if (ret)
@@ -1089,6 +1079,7 @@ static int __init vivid_create_instance(int inst)
 		q->mem_ops = &vb2_vmalloc_memops;
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 8;
+		q->lock = &dev->mutex;
 
 		ret = vb2_queue_init(q);
 		if (ret)
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 811c286..6f4445a 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -514,7 +514,4 @@ static inline bool vivid_is_hdmi_out(const struct vivid_dev *dev)
 	return dev->output_type[dev->output] == HDMI;
 }
 
-void vivid_lock(struct vb2_queue *vq);
-void vivid_unlock(struct vb2_queue *vq);
-
 #endif
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index 8c5d661..4af55f1 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -297,8 +297,8 @@ const struct vb2_ops vivid_sdr_cap_qops = {
 	.buf_queue		= sdr_cap_buf_queue,
 	.start_streaming	= sdr_cap_start_streaming,
 	.stop_streaming		= sdr_cap_stop_streaming,
-	.wait_prepare		= vivid_unlock,
-	.wait_finish		= vivid_lock,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
 };
 
 int vivid_sdr_enum_freq_bands(struct file *file, void *fh, struct v4l2_frequency_band *band)
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index 2166d0b..ef81b01 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -236,8 +236,8 @@ const struct vb2_ops vivid_vbi_cap_qops = {
 	.buf_queue		= vbi_cap_buf_queue,
 	.start_streaming	= vbi_cap_start_streaming,
 	.stop_streaming		= vbi_cap_stop_streaming,
-	.wait_prepare		= vivid_unlock,
-	.wait_finish		= vivid_lock,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
 };
 
 int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
index 9d00a07..4e4c70e 100644
--- a/drivers/media/platform/vivid/vivid-vbi-out.c
+++ b/drivers/media/platform/vivid/vivid-vbi-out.c
@@ -131,8 +131,8 @@ const struct vb2_ops vivid_vbi_out_qops = {
 	.buf_queue		= vbi_out_buf_queue,
 	.start_streaming	= vbi_out_start_streaming,
 	.stop_streaming		= vbi_out_stop_streaming,
-	.wait_prepare		= vivid_unlock,
-	.wait_finish		= vivid_lock,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
 };
 
 int vidioc_g_fmt_vbi_out(struct file *file, void *priv,
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 331c544..1309d31 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -288,8 +288,8 @@ const struct vb2_ops vivid_vid_cap_qops = {
 	.buf_queue		= vid_cap_buf_queue,
 	.start_streaming	= vid_cap_start_streaming,
 	.stop_streaming		= vid_cap_stop_streaming,
-	.wait_prepare		= vivid_unlock,
-	.wait_finish		= vivid_lock,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
 };
 
 /*
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 69c2dbd..078bc35 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -209,8 +209,8 @@ const struct vb2_ops vivid_vid_out_qops = {
 	.buf_queue		= vid_out_buf_queue,
 	.start_streaming	= vid_out_start_streaming,
 	.stop_streaming		= vid_out_stop_streaming,
-	.wait_prepare		= vivid_unlock,
-	.wait_finish		= vivid_lock,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
 };
 
 /*
-- 
1.9.1

