Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933597AbaEPNm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:42:58 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:62601 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605AbaEPNmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:42:54 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 46/49] media: davinci: vpif_capture: return -ENODATA for *std calls
Date: Fri, 16 May 2014 19:03:52 +0530
Message-Id: <1400247235-31434-49-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch adds supports to return -ENODATA to *std calls
if the selected output does not support it.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_capture.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 0b97023..8d7ada2 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -862,11 +862,22 @@ static int vpif_querystd(struct file *file, void *priv, v4l2_std_id *std_id)
  */
 static int vpif_g_std(struct file *file, void *priv, v4l2_std_id *std)
 {
+	struct vpif_capture_config *config = vpif_dev->platform_data;
 	struct video_device *vdev = video_devdata(file);
 	struct channel_obj *ch = video_get_drvdata(vdev);
+	struct vpif_capture_chan_config *chan_cfg;
+	struct v4l2_input input;
 
 	vpif_dbg(2, debug, "vpif_g_std\n");
 
+	if (config->chan_config[ch->channel_id].inputs == NULL)
+		return -ENODATA;
+
+	chan_cfg = &config->chan_config[ch->channel_id];
+	input = chan_cfg->inputs[ch->input_idx].input;
+	if (input.capabilities != V4L2_IN_CAP_STD)
+		return -ENODATA;
+
 	*std = ch->video.stdid;
 	return 0;
 }
@@ -879,13 +890,24 @@ static int vpif_g_std(struct file *file, void *priv, v4l2_std_id *std)
  */
 static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 {
+	struct vpif_capture_config *config = vpif_dev->platform_data;
 	struct video_device *vdev = video_devdata(file);
 	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	int ret = 0;
+	struct vpif_capture_chan_config *chan_cfg;
+	struct v4l2_input input;
+	int ret;
 
 	vpif_dbg(2, debug, "vpif_s_std\n");
 
+	if (config->chan_config[ch->channel_id].inputs == NULL)
+		return -ENODATA;
+
+	chan_cfg = &config->chan_config[ch->channel_id];
+	input = chan_cfg->inputs[ch->input_idx].input;
+	if (input.capabilities != V4L2_IN_CAP_STD)
+		return -ENODATA;
+
 	if (vb2_is_busy(&common->buffer_queue))
 		return -EBUSY;
 
-- 
1.7.9.5

