Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069AbaEPNkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:40:47 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:47304 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933029AbaEPNkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:40:43 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 22/49] media: davinci: vpif_display: return -ENODATA for *dv_timings calls
Date: Fri, 16 May 2014 19:03:27 +0530
Message-Id: <1400247235-31434-24-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch adds suppport to return -ENODATA for *dv_timings calls
if the current output does not support it.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c |   40 +++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 81d955a..f51b5be 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -898,10 +898,21 @@ static int
 vpif_enum_dv_timings(struct file *file, void *priv,
 		     struct v4l2_enum_dv_timings *timings)
 {
+	struct vpif_display_config *config = vpif_dev->platform_data;
 	struct video_device *vdev = video_devdata(file);
 	struct channel_obj *ch = video_get_drvdata(vdev);
+	struct vpif_display_chan_config *chan_cfg;
+	struct v4l2_output output;
 	int ret;
 
+	if (config->chan_config[ch->channel_id].outputs == NULL)
+		return -ENODATA;
+
+	chan_cfg = &config->chan_config[ch->channel_id];
+	output = chan_cfg->outputs[ch->output_idx].output;
+	if (output.capabilities != V4L2_OUT_CAP_DV_TIMINGS)
+		return -ENODATA;
+
 	ret = v4l2_subdev_call(ch->sd, video, enum_dv_timings, timings);
 	if (ret == -ENOIOCTLCMD || ret == -ENODEV)
 		return -EINVAL;
@@ -917,14 +928,29 @@ vpif_enum_dv_timings(struct file *file, void *priv,
 static int vpif_s_dv_timings(struct file *file, void *priv,
 		struct v4l2_dv_timings *timings)
 {
+	struct vpif_display_config *config = vpif_dev->platform_data;
 	struct video_device *vdev = video_devdata(file);
 	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct vpif_params *vpifparams = &ch->vpifparams;
+	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct vpif_channel_config_params *std_info = &vpifparams->std_info;
 	struct video_obj *vid_ch = &ch->video;
 	struct v4l2_bt_timings *bt = &vid_ch->dv_timings.bt;
+	struct vpif_display_chan_config *chan_cfg;
+	struct v4l2_output output;
 	int ret;
 
+	if (config->chan_config[ch->channel_id].outputs == NULL)
+		return -ENODATA;
+
+	chan_cfg = &config->chan_config[ch->channel_id];
+	output = chan_cfg->outputs[ch->output_idx].output;
+	if (output.capabilities != V4L2_OUT_CAP_DV_TIMINGS)
+		return -ENODATA;
+
+	if (vb2_is_busy(&common->buffer_queue))
+		return -EBUSY;
+
 	if (timings->type != V4L2_DV_BT_656_1120) {
 		vpif_dbg(2, debug, "Timing type not defined\n");
 		return -EINVAL;
@@ -1006,13 +1032,27 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 static int vpif_g_dv_timings(struct file *file, void *priv,
 		struct v4l2_dv_timings *timings)
 {
+	struct vpif_display_config *config = vpif_dev->platform_data;
 	struct video_device *vdev = video_devdata(file);
 	struct channel_obj *ch = video_get_drvdata(vdev);
+	struct vpif_display_chan_config *chan_cfg;
 	struct video_obj *vid_ch = &ch->video;
+	struct v4l2_output output;
+
+	if (config->chan_config[ch->channel_id].outputs == NULL)
+		goto error;
+
+	chan_cfg = &config->chan_config[ch->channel_id];
+	output = chan_cfg->outputs[ch->output_idx].output;
+
+	if (output.capabilities != V4L2_OUT_CAP_DV_TIMINGS)
+		goto error;
 
 	*timings = vid_ch->dv_timings;
 
 	return 0;
+error:
+	return -ENODATA;
 }
 
 /*
-- 
1.7.9.5

