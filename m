Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbaEDPms (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:42:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbaEDPmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.10 69/86] media: omap3isp: preview: Fix the crop margins
Date: Sun,  4 May 2014 11:41:44 -0400
Message-Id: <20140504154149.838174917@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
References: <20140504154140.444932005@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/omap3isp/isppreview.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -1079,6 +1079,7 @@ static void preview_config_input_format(
  */
 static void preview_config_input_size(struct isp_prev_device *prev, u32 active)
 {
+	const struct v4l2_mbus_framefmt *format = &prev->formats[PREV_PAD_SINK];
 	struct isp_device *isp = to_isp_device(prev);
 	unsigned int sph = prev->crop.left;
 	unsigned int eph = prev->crop.left + prev->crop.width - 1;
@@ -1086,6 +1087,14 @@ static void preview_config_input_size(st
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
 


