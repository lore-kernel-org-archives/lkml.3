Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbaJLUlX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:41:23 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:34962 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbaJLUlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:41:13 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 15/15] media: davinci: vpbe: return -ENODATA for *dv_timings/*_std calls
Date: Sun, 12 Oct 2014 21:40:45 +0100
Message-Id: <1413146445-7304-16-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch adds support for returning -ENODATA if the current
output doesn't support it.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpbe.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index 33b9660..49d2de0 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -341,7 +341,7 @@ static int vpbe_s_dv_timings(struct vpbe_device *vpbe_dev,
 
 	if (!(cfg->outputs[out_index].output.capabilities &
 	    V4L2_OUT_CAP_DV_TIMINGS))
-		return -EINVAL;
+		return -ENODATA;
 
 	for (i = 0; i < output->num_modes; i++) {
 		if (output->modes[i].timings_type == VPBE_ENC_DV_TIMINGS &&
@@ -384,6 +384,13 @@ static int vpbe_s_dv_timings(struct vpbe_device *vpbe_dev,
 static int vpbe_g_dv_timings(struct vpbe_device *vpbe_dev,
 		     struct v4l2_dv_timings *dv_timings)
 {
+	struct vpbe_config *cfg = vpbe_dev->cfg;
+	int out_index = vpbe_dev->current_out_index;
+
+	if (!(cfg->outputs[out_index].output.capabilities &
+		V4L2_OUT_CAP_DV_TIMINGS))
+		return -ENODATA;
+
 	if (vpbe_dev->current_timings.timings_type &
 	  VPBE_ENC_DV_TIMINGS) {
 		*dv_timings = vpbe_dev->current_timings.dv_timings;
@@ -409,7 +416,7 @@ static int vpbe_enum_dv_timings(struct vpbe_device *vpbe_dev,
 	int i;
 
 	if (!(output->output.capabilities & V4L2_OUT_CAP_DV_TIMINGS))
-		return -EINVAL;
+		return -ENODATA;
 
 	for (i = 0; i < output->num_modes; i++) {
 		if (output->modes[i].timings_type == VPBE_ENC_DV_TIMINGS) {
@@ -440,7 +447,7 @@ static int vpbe_s_std(struct vpbe_device *vpbe_dev, v4l2_std_id std_id)
 
 	if (!(cfg->outputs[out_index].output.capabilities &
 		V4L2_OUT_CAP_STD))
-		return -EINVAL;
+		return -ENODATA;
 
 	ret = vpbe_get_std_info(vpbe_dev, std_id);
 	if (ret)
@@ -473,6 +480,11 @@ static int vpbe_s_std(struct vpbe_device *vpbe_dev, v4l2_std_id std_id)
 static int vpbe_g_std(struct vpbe_device *vpbe_dev, v4l2_std_id *std_id)
 {
 	struct vpbe_enc_mode_info *cur_timings = &vpbe_dev->current_timings;
+	struct vpbe_config *cfg = vpbe_dev->cfg;
+	int out_index = vpbe_dev->current_out_index;
+
+	if (!(cfg->outputs[out_index].output.capabilities & V4L2_OUT_CAP_STD))
+		return -ENODATA;
 
 	if (cur_timings->timings_type & VPBE_ENC_STD) {
 		*std_id = cur_timings->std_id;
-- 
1.9.1

