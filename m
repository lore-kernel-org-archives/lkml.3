Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197AbaEPNlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:41:25 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:62784 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933179AbaEPNlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:41:22 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 28/49] media: davinci: vpif_capture: use vb2_ops_wait_prepare/finish helper functions
Date: Fri, 16 May 2014 19:03:33 +0530
Message-Id: <1400247235-31434-30-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch makes use of vb2_ops_wait_prepare/finish helper functions.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_capture.c |   21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 484d858..8572efe 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -224,24 +224,6 @@ static void vpif_buf_cleanup(struct vb2_buffer *vb)
 
 }
 
-static void vpif_wait_prepare(struct vb2_queue *vq)
-{
-	struct channel_obj *ch = vb2_get_drv_priv(vq);
-	struct common_obj *common;
-
-	common = &ch->common[VPIF_VIDEO_INDEX];
-	mutex_unlock(&common->lock);
-}
-
-static void vpif_wait_finish(struct vb2_queue *vq)
-{
-	struct channel_obj *ch = vb2_get_drv_priv(vq);
-	struct common_obj *common;
-
-	common = &ch->common[VPIF_VIDEO_INDEX];
-	mutex_lock(&common->lock);
-}
-
 static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct vpif_capture_config *vpif_config_data =
@@ -374,8 +356,6 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 
 static struct vb2_ops video_qops = {
 	.queue_setup		= vpif_buffer_queue_setup,
-	.wait_prepare		= vpif_wait_prepare,
-	.wait_finish		= vpif_wait_finish,
 	.buf_prepare		= vpif_buffer_prepare,
 	.start_streaming	= vpif_start_streaming,
 	.stop_streaming		= vpif_stop_streaming,
@@ -1977,6 +1957,7 @@ static int vpif_probe_complete(void)
 		q->buf_struct_size = sizeof(struct vpif_cap_buffer);
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 1;
+		q->lock = &common->lock;
 
 		err = vb2_queue_init(q);
 		if (err) {
-- 
1.7.9.5

