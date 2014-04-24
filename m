Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbaDXLyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:54:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46308 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbaDXIwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:52:21 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Florian Vaussard <florian.vaussard@epfl.ch>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 019/182] [media] omap3isp: preview: Fix the crop margins
Date: Thu, 24 Apr 2014 09:49:04 +0100
Message-Id: <1398329507-5911-20-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Vaussard <florian.vaussard@epfl.ch>

commit 8b57b9669aa884ac75b8d09c251d6b1755533c15 upstream.

Commit 3fdfedaaa "[media] omap3isp: preview: Lower the crop margins"
accidentally changed the previewer's cropping, causing the previewer
to miss four pixels on each line, thus corrupting the final image.
Restored the removed setting.

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/platform/omap3isp/isppreview.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index cd8831a..e2e4610 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -1079,6 +1079,7 @@ static void preview_config_input_format(struct isp_prev_device *prev,
  */
 static void preview_config_input_size(struct isp_prev_device *prev, u32 active)
 {
+	const struct v4l2_mbus_framefmt *format = &prev->formats[PREV_PAD_SINK];
 	struct isp_device *isp = to_isp_device(prev);
 	unsigned int sph = prev->crop.left;
 	unsigned int eph = prev->crop.left + prev->crop.width - 1;
@@ -1086,6 +1087,14 @@ static void preview_config_input_size(struct isp_prev_device *prev, u32 active)
 	unsigned int elv = prev->crop.top + prev->crop.height - 1;
 	u32 features;
 
+	if (format->code != V4L2_MBUS_FMT_Y8_1X8 &&
+	    format->code != V4L2_MBUS_FMT_Y10_1X10) {
+		sph -= 2;
+		eph += 2;
+		slv -= 2;
+		elv += 2;
+	}
+
 	features = (prev->params.params[0].features & active)
 		 | (prev->params.params[1].features & ~active);
 
-- 
1.9.1

