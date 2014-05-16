Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569AbaEPNmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:42:52 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:50098 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605AbaEPNmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:42:49 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 45/49] media: davinci: vpif_capture: return -ENODATA for *dv_timings calls
Date: Fri, 16 May 2014 19:03:51 +0530
Message-Id: <1400247235-31434-48-git-send-email-prabhakar.csengg@gmail.com>
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
 drivers/media/platform/davinci/vpif_capture.c |   50 +++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index f4cf24c..0b97023 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1109,13 +1109,25 @@ static int
 vpif_enum_dv_timings(struct file *file, void *priv,
 		     struct v4l2_enum_dv_timings *timings)
 {
+	struct vpif_capture_config *config = vpif_dev->platform_data;
 	struct video_device *vdev = video_devdata(file);
 	struct channel_obj *ch = video_get_drvdata(vdev);
+	struct vpif_capture_chan_config *chan_cfg;
+	struct v4l2_input input;
 	int ret;
 
+	if (config->chan_config[ch->channel_id].inputs == NULL)
+		return -ENODATA;
+
+	chan_cfg = &config->chan_config[ch->channel_id];
+	input = chan_cfg->inputs[ch->input_idx].input;
+	if (input.capabilities != V4L2_IN_CAP_DV_TIMINGS)
+		return -ENODATA;
+
 	ret = v4l2_subdev_call(ch->sd, video, enum_dv_timings, timings);
 	if (ret == -ENOIOCTLCMD || ret == -ENODEV)
 		return -EINVAL;
+
 	return ret;
 }
 
@@ -1129,13 +1141,25 @@ static int
 vpif_query_dv_timings(struct file *file, void *priv,
 		      struct v4l2_dv_timings *timings)
 {
+	struct vpif_capture_config *config = vpif_dev->platform_data;
 	struct video_device *vdev = video_devdata(file);
 	struct channel_obj *ch = video_get_drvdata(vdev);
+	struct vpif_capture_chan_config *chan_cfg;
+	struct v4l2_input input;
 	int ret;
 
+	if (config->chan_config[ch->channel_id].inputs == NULL)
+		return -ENODATA;
+
+	chan_cfg = &config->chan_config[ch->channel_id];
+	input = chan_cfg->inputs[ch->input_idx].input;
+	if (input.capabilities != V4L2_IN_CAP_DV_TIMINGS)
+		return -ENODATA;
+
 	ret = v4l2_subdev_call(ch->sd, video, query_dv_timings, timings);
 	if (ret == -ENOIOCTLCMD || ret == -ENODEV)
 		return -ENODATA;
+
 	return ret;
 }
 
@@ -1148,19 +1172,34 @@ vpif_query_dv_timings(struct file *file, void *priv,
 static int vpif_s_dv_timings(struct file *file, void *priv,
 		struct v4l2_dv_timings *timings)
 {
+	struct vpif_capture_config *config = vpif_dev->platform_data;
 	struct video_device *vdev = video_devdata(file);
 	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct vpif_params *vpifparams = &ch->vpifparams;
 	struct vpif_channel_config_params *std_info = &vpifparams->std_info;
+	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct video_obj *vid_ch = &ch->video;
 	struct v4l2_bt_timings *bt = &vid_ch->dv_timings.bt;
+	struct vpif_capture_chan_config *chan_cfg;
+	struct v4l2_input input;
 	int ret;
 
+	if (config->chan_config[ch->channel_id].inputs == NULL)
+		return -ENODATA;
+
+	chan_cfg = &config->chan_config[ch->channel_id];
+	input = chan_cfg->inputs[ch->input_idx].input;
+	if (input.capabilities != V4L2_IN_CAP_DV_TIMINGS)
+		return -ENODATA;
+
 	if (timings->type != V4L2_DV_BT_656_1120) {
 		vpif_dbg(2, debug, "Timing type not defined\n");
 		return -EINVAL;
 	}
 
+	if (vb2_is_busy(&common->buffer_queue))
+		return -EBUSY;
+
 	/* Configure subdevice timings, if any */
 	ret = v4l2_subdev_call(ch->sd, video, s_dv_timings, timings);
 	if (ret == -ENOIOCTLCMD || ret == -ENODEV)
@@ -1236,9 +1275,20 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 static int vpif_g_dv_timings(struct file *file, void *priv,
 		struct v4l2_dv_timings *timings)
 {
+	struct vpif_capture_config *config = vpif_dev->platform_data;
 	struct video_device *vdev = video_devdata(file);
 	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct video_obj *vid_ch = &ch->video;
+	struct vpif_capture_chan_config *chan_cfg;
+	struct v4l2_input input;
+
+	if (config->chan_config[ch->channel_id].inputs == NULL)
+		return -ENODATA;
+
+	chan_cfg = &config->chan_config[ch->channel_id];
+	input = chan_cfg->inputs[ch->input_idx].input;
+	if (input.capabilities != V4L2_IN_CAP_DV_TIMINGS)
+		return -ENODATA;
 
 	*timings = vid_ch->dv_timings;
 
-- 
1.7.9.5

