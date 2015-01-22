Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbbAVWVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:21:33 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:39358 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbbAVWU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:20:58 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Scott Jiang <scott.jiang.linux@gmail.com>,
        adi-buildroot-devel@lists.sourceforge.net
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 11/15] media: blackfin: bfin_capture: return -ENODATA for *dv_timings calls
Date: Thu, 22 Jan 2015 22:18:44 +0000
Message-Id: <1421965128-10470-12-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch adds support to return -ENODATA for *dv_timings calls
if the current output does not support it.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 6b38e63..31b5697 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -488,6 +488,11 @@ static int bcap_enum_dv_timings(struct file *file, void *priv,
 				struct v4l2_enum_dv_timings *timings)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct v4l2_input input;
+
+	input = bcap_dev->cfg->inputs[bcap_dev->cur_input];
+	if (!(input.capabilities & V4L2_IN_CAP_DV_TIMINGS))
+		return -ENODATA;
 
 	timings->pad = 0;
 
@@ -499,6 +504,11 @@ static int bcap_query_dv_timings(struct file *file, void *priv,
 				struct v4l2_dv_timings *timings)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct v4l2_input input;
+
+	input = bcap_dev->cfg->inputs[bcap_dev->cur_input];
+	if (!(input.capabilities & V4L2_IN_CAP_DV_TIMINGS))
+		return -ENODATA;
 
 	return v4l2_subdev_call(bcap_dev->sd, video,
 				query_dv_timings, timings);
@@ -508,6 +518,11 @@ static int bcap_g_dv_timings(struct file *file, void *priv,
 				struct v4l2_dv_timings *timings)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct v4l2_input input;
+
+	input = bcap_dev->cfg->inputs[bcap_dev->cur_input];
+	if (!(input.capabilities & V4L2_IN_CAP_DV_TIMINGS))
+		return -ENODATA;
 
 	*timings = bcap_dev->dv_timings;
 	return 0;
@@ -517,7 +532,13 @@ static int bcap_s_dv_timings(struct file *file, void *priv,
 				struct v4l2_dv_timings *timings)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct v4l2_input input;
 	int ret;
+
+	input = bcap_dev->cfg->inputs[bcap_dev->cur_input];
+	if (!(input.capabilities & V4L2_IN_CAP_DV_TIMINGS))
+		return -ENODATA;
+
 	if (vb2_is_busy(&bcap_dev->buffer_queue))
 		return -EBUSY;
 
-- 
2.1.0

