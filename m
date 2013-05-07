Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab3EGFHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 01:07:47 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:53857 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757967Ab3EGFHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 01:07:45 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2] media: davinci: vpbe: fix layer availability for NV12 format
Date: Tue,  7 May 2013 10:37:25 +0530
Message-Id: <1367903245-4494-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

For NV12 format, even if display data is single image,
both VIDWIN0 and VIDWIN1 parameters must be used. The start
address of Y data plane and C data plane is configured in
VIDEOWIN0ADH/L and VIDEOWIN1ADH/L respectively.
cuurently only one layer was requested, which is suffice
for yuv422, but for yuv420(NV12) two layers are required and
fix the same by requesting for other layer if pix fmt is NV12
during set_fmt.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 Changes for v2:
 1: Dropped cpu_is_*() check in driver as, any way driver would fail to set
    NV12 if the device doesnt support it.

 drivers/media/platform/davinci/vpbe_display.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 0341dcc..4ceee3a 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -922,6 +922,21 @@ static int vpbe_display_s_fmt(struct file *file, void *priv,
 	other video window */
 
 	layer->pix_fmt = *pixfmt;
+	if (pixfmt->pixelformat == V4L2_PIX_FMT_NV12) {
+		struct vpbe_layer *otherlayer;
+
+		otherlayer = _vpbe_display_get_other_win_layer(disp_dev, layer);
+		/* if other layer is available, only
+		 * claim it, do not configure it
+		 */
+		ret = osd_device->ops.request_layer(osd_device,
+						    otherlayer->layer_info.id);
+		if (ret < 0) {
+			v4l2_err(&vpbe_dev->v4l2_dev,
+				 "Display Manager failed to allocate layer\n");
+			return -EBUSY;
+		}
+	}
 
 	/* Get osd layer config */
 	osd_device->ops.get_layer_config(osd_device,
-- 
1.7.4.1

