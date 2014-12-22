Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbaLVQAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:00:20 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49661 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150AbaLVQAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:00:18 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Sureau?= 
	<frederic.sureau@vodalys.com>,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC PATCH] [media] coda: Use S_PARM to set nominal framerate for h.264 encoder
Date: Mon, 22 Dec 2014 17:00:00 +0100
Message-Id: <1419264000-11761-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.1.3
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The encoder needs to know the nominal framerate for the constant bitrate
control mechanism to work. Currently the only way to set the framerate is
by using VIDIOC_S_PARM on the output queue.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 39330a7..63eb510 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -803,6 +803,32 @@ static int coda_decoder_cmd(struct file *file, void *fh,
 	return 0;
 }
 
+static int coda_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
+{
+	struct coda_ctx *ctx = fh_to_ctx(fh);
+
+	a->parm.output.timeperframe.denominator = 1;
+	a->parm.output.timeperframe.numerator = ctx->params.framerate;
+
+	return 0;
+}
+
+static int coda_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
+{
+	struct coda_ctx *ctx = fh_to_ctx(fh);
+
+	if (a->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
+	    a->parm.output.timeperframe.numerator != 0) {
+		ctx->params.framerate = a->parm.output.timeperframe.denominator
+				      / a->parm.output.timeperframe.numerator;
+	}
+
+	a->parm.output.timeperframe.denominator = 1;
+	a->parm.output.timeperframe.numerator = ctx->params.framerate;
+
+	return 0;
+}
+
 static int coda_subscribe_event(struct v4l2_fh *fh,
 				const struct v4l2_event_subscription *sub)
 {
@@ -843,6 +869,9 @@ static const struct v4l2_ioctl_ops coda_ioctl_ops = {
 	.vidioc_try_decoder_cmd	= coda_try_decoder_cmd,
 	.vidioc_decoder_cmd	= coda_decoder_cmd,
 
+	.vidioc_g_parm		= coda_g_parm,
+	.vidioc_s_parm		= coda_s_parm,
+
 	.vidioc_subscribe_event = coda_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
-- 
2.1.4

