Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbbAVWZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:25:07 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:41974 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbbAVWU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:20:57 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Scott Jiang <scott.jiang.linux@gmail.com>,
        adi-buildroot-devel@lists.sourceforge.net
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 10/15] media: blackfin: bfin_capture: return -ENODATA for *std calls
Date: Thu, 22 Jan 2015 22:18:43 +0000
Message-Id: <1421965128-10470-11-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
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
index 57f3b8c..6b38e63 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -441,6 +441,11 @@ static irqreturn_t bcap_isr(int irq, void *dev_id)
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
@@ -448,6 +453,11 @@ static int bcap_querystd(struct file *file, void *priv, v4l2_std_id *std)
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
@@ -456,8 +466,13 @@ static int bcap_g_std(struct file *file, void *priv, v4l2_std_id *std)
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
2.1.0

