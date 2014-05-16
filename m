Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026AbaEPNkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:40:31 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:34011 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933002AbaEPNk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:40:26 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 18/49] media: davinci: vpif_display: drop unneeded module params
Date: Fri, 16 May 2014 19:03:23 +0530
Message-Id: <1400247235-31434-20-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this pacth drops unneeded module params and vpif_config_params.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c |   69 +------------------------
 drivers/media/platform/davinci/vpif_display.h |    8 ---
 2 files changed, 1 insertion(+), 76 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 1e0a162..fef03be 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -35,32 +35,10 @@ MODULE_VERSION(VPIF_DISPLAY_VERSION);
 		v4l2_dbg(level, debug, &vpif_obj.v4l2_dev, fmt, ## arg)
 
 static int debug = 1;
-static u32 ch2_numbuffers = 3;
-static u32 ch3_numbuffers = 3;
-static u32 ch2_bufsize = 1920 * 1080 * 2;
-static u32 ch3_bufsize = 720 * 576 * 2;
 
 module_param(debug, int, 0644);
-module_param(ch2_numbuffers, uint, S_IRUGO);
-module_param(ch3_numbuffers, uint, S_IRUGO);
-module_param(ch2_bufsize, uint, S_IRUGO);
-module_param(ch3_bufsize, uint, S_IRUGO);
 
 MODULE_PARM_DESC(debug, "Debug level 0-1");
-MODULE_PARM_DESC(ch2_numbuffers, "Channel2 buffer count (default:3)");
-MODULE_PARM_DESC(ch3_numbuffers, "Channel3 buffer count (default:3)");
-MODULE_PARM_DESC(ch2_bufsize, "Channel2 buffer size (default:1920 x 1080 x 2)");
-MODULE_PARM_DESC(ch3_bufsize, "Channel3 buffer size (default:720 x 576 x 2)");
-
-static struct vpif_config_params config_params = {
-	.min_numbuffers		= 3,
-	.numbuffers[0]		= 3,
-	.numbuffers[1]		= 3,
-	.min_bufsize[0]		= 720 * 480 * 2,
-	.min_bufsize[1]		= 720 * 480 * 2,
-	.channel_bufsize[0]	= 1920 * 1080 * 2,
-	.channel_bufsize[1]	= 720 * 576 * 2,
-};
 
 #define VPIF_DRIVER_NAME	"vpif_display"
 
@@ -571,8 +549,6 @@ static void vpif_config_format(struct channel_obj *ch)
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 
 	common->fmt.fmt.pix.field = V4L2_FIELD_ANY;
-	common->fmt.fmt.pix.sizeimage =
-			config_params.channel_bufsize[ch->channel_id];
 	common->fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV422P;
 	common->fmt.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
 }
@@ -758,13 +734,6 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 	if (vpif_update_resolution(ch))
 		return -EINVAL;
 
-	if ((ch->vpifparams.std_info.width *
-		ch->vpifparams.std_info.height * 2) >
-		config_params.channel_bufsize[ch->channel_id]) {
-		vpif_err("invalid std for this size\n");
-		return -EINVAL;
-	}
-
 	common->fmt.fmt.pix.bytesperline = common->fmt.fmt.pix.width;
 	/* Configure the default format information */
 	vpif_config_format(ch);
@@ -1121,39 +1090,7 @@ static const struct v4l2_file_operations vpif_fops = {
 static int initialize_vpif(void)
 {
 	int free_channel_objects_index;
-	int free_buffer_channel_index;
-	int free_buffer_index;
-	int err = 0, i, j;
-
-	/* Default number of buffers should be 3 */
-	if ((ch2_numbuffers > 0) &&
-	    (ch2_numbuffers < config_params.min_numbuffers))
-		ch2_numbuffers = config_params.min_numbuffers;
-	if ((ch3_numbuffers > 0) &&
-	    (ch3_numbuffers < config_params.min_numbuffers))
-		ch3_numbuffers = config_params.min_numbuffers;
-
-	/* Set buffer size to min buffers size if invalid buffer size is
-	 * given */
-	if (ch2_bufsize < config_params.min_bufsize[VPIF_CHANNEL2_VIDEO])
-		ch2_bufsize =
-		    config_params.min_bufsize[VPIF_CHANNEL2_VIDEO];
-	if (ch3_bufsize < config_params.min_bufsize[VPIF_CHANNEL3_VIDEO])
-		ch3_bufsize =
-		    config_params.min_bufsize[VPIF_CHANNEL3_VIDEO];
-
-	config_params.numbuffers[VPIF_CHANNEL2_VIDEO] = ch2_numbuffers;
-
-	if (ch2_numbuffers) {
-		config_params.channel_bufsize[VPIF_CHANNEL2_VIDEO] =
-							ch2_bufsize;
-	}
-	config_params.numbuffers[VPIF_CHANNEL3_VIDEO] = ch3_numbuffers;
-
-	if (ch3_numbuffers) {
-		config_params.channel_bufsize[VPIF_CHANNEL3_VIDEO] =
-							ch3_bufsize;
-	}
+	int err, i, j;
 
 	/* Allocate memory for six channel objects */
 	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
@@ -1167,10 +1104,6 @@ static int initialize_vpif(void)
 		}
 	}
 
-	free_channel_objects_index = VPIF_DISPLAY_MAX_DEVICES;
-	free_buffer_channel_index = VPIF_DISPLAY_NUM_CHANNELS;
-	free_buffer_index = config_params.numbuffers[i - 1];
-
 	return 0;
 
 vpif_init_free_channel_objects:
diff --git a/drivers/media/platform/davinci/vpif_display.h b/drivers/media/platform/davinci/vpif_display.h
index 029e0c5..089e860 100644
--- a/drivers/media/platform/davinci/vpif_display.h
+++ b/drivers/media/platform/davinci/vpif_display.h
@@ -128,12 +128,4 @@ struct vpif_device {
 	struct vpif_display_config *config;
 };
 
-struct vpif_config_params {
-	u32 min_bufsize[VPIF_DISPLAY_NUM_CHANNELS];
-	u32 channel_bufsize[VPIF_DISPLAY_NUM_CHANNELS];
-	u8 numbuffers[VPIF_DISPLAY_NUM_CHANNELS];
-	u32 video_limit[VPIF_DISPLAY_NUM_CHANNELS];
-	u8 min_numbuffers;
-};
-
 #endif				/* DAVINCIHD_DISPLAY_H */
-- 
1.7.9.5

