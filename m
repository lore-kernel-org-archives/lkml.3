Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaLTKuP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 05:50:15 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:42247 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbaLTKso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 05:48:44 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Scott Jiang <scott.jiang.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 10/15] media: blackfin: bfin_capture: return -ENODATA for *std calls
Date: Sat, 20 Dec 2014 16:17:37 +0530
Message-Id: <1419072462-3168-11-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch adds supports to return -ENODATA to *_std calls
if the selected output does not support it.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 58414dd..9f48795 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -440,6 +440,11 @@ static irqreturn_t bcap_isr(int irq, void *dev_id)
 static int bcap_querystd(struct file *file, void *priv, v4l2_std_id *std)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct v4l2_input input;
+
+	input = bcap_dev->cfg->inputs[bcap_dev->cur_input];
+	if (!(input.capabilities & V4L2_IN_CAP_STD))
+		return -ENODATA;
 
 	return v4l2_subdev_call(bcap_dev->sd, video, querystd, std);
 }
@@ -447,6 +452,11 @@ static int bcap_querystd(struct file *file, void *priv, v4l2_std_id *std)
 static int bcap_g_std(struct file *file, void *priv, v4l2_std_id *std)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct v4l2_input input;
+
+	input = bcap_dev->cfg->inputs[bcap_dev->cur_input];
+	if (!(input.capabilities & V4L2_IN_CAP_STD))
+		return -ENODATA;
 
 	*std = bcap_dev->std;
 	return 0;
@@ -455,8 +465,13 @@ static int bcap_g_std(struct file *file, void *priv, v4l2_std_id *std)
 static int bcap_s_std(struct file *file, void *priv, v4l2_std_id std)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct v4l2_input input;
 	int ret;
 
+	input = bcap_dev->cfg->inputs[bcap_dev->cur_input];
+	if (!(input.capabilities & V4L2_IN_CAP_STD))
+		return -ENODATA;
+
 	if (vb2_is_busy(&bcap_dev->buffer_queue))
 		return -EBUSY;
 
-- 
1.9.1

