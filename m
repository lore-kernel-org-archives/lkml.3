Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751082AbaAECI0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 21:08:26 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60719 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbaAECIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 21:08:25 -0500
From: Ethan Zhao <ethan.kernel@gmail.com>
To: hans.verkuil@cisco.com, m.chehab@samsung.com, gregkh@linuxfoundation.org,
        mchehab@redhat.com
Cc: linux-kernel@vger.kernel.org, Ethan Zhao <ethan.kernel@gmail.com>
Subject: [PATCH] [media] saa7146: fix a possible NULL pointer reference in saa7146_set_position
Date: Sun,  5 Jan 2014 10:08:00 +0800
Message-Id: <1388887680-942-1-git-send-email-ethan.kernel@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function saa7146_format_by_fourcc() may return NULL, reference of the returned
result would cause NULL pointer issue without checking.

Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
---
 drivers/media/common/saa7146/saa7146_hlp.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_hlp.c b/drivers/media/common/saa7146/saa7146_hlp.c
index be746d1..3e23eab 100644
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
-- 
1.8.3.4 (Apple Git-47)

