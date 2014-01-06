Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbaAFMln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:41:43 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:38972 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaAFMlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:41:42 -0500
From: Ethan Zhao <ethan.kernel@gmail.com>
To: hans.verkuil@cisco.com, m.chehab@samsung.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Ethan Zhao <ethan.kernel@gmail.com>
Subject: [PATCH] [media] saa7146: check return value of saa7146_format_by_fourcc() to avoid NULL pointer
Date: Mon,  6 Jan 2014 20:41:26 +0800
Message-Id: <1389012086-454-1-git-send-email-ethan.kernel@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function saa7146_format_by_fourcc() may return NULL, reference of the returned
result would cause NULL pointer issue without checking.

Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
---
 drivers/media/common/saa7146/saa7146_hlp.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_hlp.c b/drivers/media/common/saa7146/saa7146_hlp.c
index be746d1..1c9518b 100644
--- a/drivers/media/common/saa7146/saa7146_hlp.c
+++ b/drivers/media/common/saa7146/saa7146_hlp.c
@@ -575,6 +575,7 @@ static void saa7146_set_position(struct saa7146_dev *dev, int w_x, int w_y, int
 	 */
 	u32 base = (u32)(unsigned long)vv->ov_fb.base;
 
+	int which = 1;
 	struct	saa7146_video_dma vdma1;
 
 	/* calculate memory offsets for picture, look if we shall top-down-flip */
@@ -608,10 +609,14 @@ static void saa7146_set_position(struct saa7146_dev *dev, int w_x, int w_y, int
 		vdma1.pitch *= -1;
 	}
 
-	vdma1.base_page = sfmt->swap;
+	if (sfmt)
+		vdma1.base_page = sfmt->swap;
+	else
+		which = 0;
+
 	vdma1.num_line_byte = (vv->standard->v_field<<16)+vv->standard->h_pixels;
 
-	saa7146_write_out_dma(dev, 1, &vdma1);
+	saa7146_write_out_dma(dev, which, &vdma1);
 }
 
 static void saa7146_set_output_format(struct saa7146_dev *dev, unsigned long palette)
@@ -713,7 +718,12 @@ static int calculate_video_dma_grab_packed(struct saa7146_dev* dev, struct saa71
 	int bytesperline = buf->fmt->bytesperline;
 	enum v4l2_field field = buf->fmt->field;
 
-	int depth = sfmt->depth;
+	int depth;
+
+	if (sfmt)
+		depth = sfmt->depth;
+	else
+		return -EINVAL;
 
 	DEB_CAP("[size=%dx%d,fields=%s]\n",
 		width, height, v4l2_field_names[field]);
@@ -837,6 +847,9 @@ static int calculate_video_dma_grab_planar(struct saa7146_dev* dev, struct saa71
 	int height = buf->fmt->height;
 	enum v4l2_field field = buf->fmt->field;
 
+	if (!sfmt)
+		return -EINVAL;
+
 	BUG_ON(0 == buf->pt[0].dma);
 	BUG_ON(0 == buf->pt[1].dma);
 	BUG_ON(0 == buf->pt[2].dma);
@@ -1004,6 +1017,9 @@ void saa7146_set_capture(struct saa7146_dev *dev, struct saa7146_buf *buf, struc
 
 	DEB_CAP("buf:%p, next:%p\n", buf, next);
 
+	if (!sfmt)
+		return;
+
 	vdma1_prot_addr = saa7146_read(dev, PROT_ADDR1);
 	if( 0 == vdma1_prot_addr ) {
 		/* clear out beginning of streaming bit (rps register 0)*/
-- 
1.8.3.4 (Apple Git-47)

