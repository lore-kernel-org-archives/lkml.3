Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbaLTKsv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 05:48:51 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:50565 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbaLTKss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 05:48:48 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Scott Jiang <scott.jiang.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 11/15] media: blackfin: bfin_capture: return -ENODATA for *dv_timings calls
Date: Sat, 20 Dec 2014 16:17:38 +0530
Message-Id: <1419072462-3168-12-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
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
index 9f48795..f663687 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -487,6 +487,11 @@ static int bcap_enum_dv_timings(struct file *file, void *priv,
 				struct v4l2_enum_dv_timings *timings)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct v4l2_input input;
+
+	input = bcap_dev->cfg->inputs[bcap_dev->cur_input];
+	if (!(input.capabilities & V4L2_IN_CAP_DV_TIMINGS))
+		return -ENODATA;
 
 	timings->pad = 0;
 
@@ -498,6 +503,11 @@ static int bcap_query_dv_timings(struct file *file, void *priv,
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
@@ -507,6 +517,11 @@ static int bcap_g_dv_timings(struct file *file, void *priv,
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
@@ -516,7 +531,13 @@ static int bcap_s_dv_timings(struct file *file, void *priv,
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
1.9.1

