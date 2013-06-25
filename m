Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab3FYPSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:18:12 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:57651 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3FYPSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:18:10 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 2/2] media: davinci: vpif: display: add V4L2-async support
Date: Tue, 25 Jun 2013 20:47:35 +0530
Message-Id: <1372173455-509-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372173455-509-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1372173455-509-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Add support for asynchronous subdevice probing, using the v4l2-async API.
The legacy synchronous mode is still supported too, which allows to
gradually update drivers and platforms.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/platform/davinci/vpif_display.c |  210 +++++++++++++++----------
 drivers/media/platform/davinci/vpif_display.h |    3 +-
 include/media/davinci/vpif_types.h            |    2 +
 3 files changed, 132 insertions(+), 83 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index e6e5736..c2ff067 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1618,6 +1618,102 @@ vpif_init_free_channel_objects:
 	return err;
 }
 
+static int vpif_async_bound(struct v4l2_async_notifier *notifier,
+			    struct v4l2_subdev *subdev,
+			    struct v4l2_async_subdev *asd)
+{
+	int i;
+
+	for (i = 0; i < vpif_obj.config->subdev_count; i++)
+		if (!strcmp(vpif_obj.config->subdevinfo[i].name,
+			    subdev->name)) {
+			vpif_obj.sd[i] = subdev;
+			vpif_obj.sd[i]->grp_id = 1 << i;
+			return 0;
+		}
+
+	return -EINVAL;
+}
+
+static int vpif_probe_complete(void)
+{
+	struct common_obj *common;
+	struct channel_obj *ch;
+	int j, err, k;
+
+	for (j = 0; j < VPIF_DISPLAY_MAX_DEVICES; j++) {
+		ch = vpif_obj.dev[j];
+		/* Initialize field of the channel objects */
+		atomic_set(&ch->usrs, 0);
+		for (k = 0; k < VPIF_NUMOBJECTS; k++) {
+			ch->common[k].numbuffers = 0;
+			common = &ch->common[k];
+			common->io_usrs = 0;
+			common->started = 0;
+			spin_lock_init(&common->irqlock);
+			mutex_init(&common->lock);
+			common->numbuffers = 0;
+			common->set_addr = NULL;
+			common->ytop_off = 0;
+			common->ybtm_off = 0;
+			common->ctop_off = 0;
+			common->cbtm_off = 0;
+			common->cur_frm = NULL;
+			common->next_frm = NULL;
+			memset(&common->fmt, 0, sizeof(common->fmt));
+			common->numbuffers = config_params.numbuffers[k];
+		}
+		ch->initialized = 0;
+		if (vpif_obj.config->subdev_count)
+			ch->sd = vpif_obj.sd[0];
+		ch->channel_id = j;
+		if (j < 2)
+			ch->common[VPIF_VIDEO_INDEX].numbuffers =
+			    config_params.numbuffers[ch->channel_id];
+		else
+			ch->common[VPIF_VIDEO_INDEX].numbuffers = 0;
+
+		memset(&ch->vpifparams, 0, sizeof(ch->vpifparams));
+
+		/* Initialize prio member of channel object */
+		v4l2_prio_init(&ch->prio);
+		ch->common[VPIF_VIDEO_INDEX].fmt.type =
+						V4L2_BUF_TYPE_VIDEO_OUTPUT;
+		ch->video_dev->lock = &common->lock;
+		video_set_drvdata(ch->video_dev, ch);
+
+		/* select output 0 */
+		err = vpif_set_output(vpif_obj.config, ch, 0);
+		if (err)
+			goto probe_out;
+
+		/* register video device */
+		vpif_dbg(1, debug, "channel=%x,channel->video_dev=%x\n",
+			 (int)ch, (int)&ch->video_dev);
+
+		err = video_register_device(ch->video_dev,
+					  VFL_TYPE_GRABBER, (j ? 3 : 2));
+		if (err < 0)
+			goto probe_out;
+	}
+
+	return 0;
+
+probe_out:
+	for (k = 0; k < j; k++) {
+		ch = vpif_obj.dev[k];
+		video_unregister_device(ch->video_dev);
+		video_device_release(ch->video_dev);
+		ch->video_dev = NULL;
+	}
+	return err;
+}
+
+static int vpif_async_complete(struct v4l2_async_notifier *notifier)
+{
+	return vpif_probe_complete();
+}
+
 /*
  * vpif_probe: This function creates device entries by register itself to the
  * V4L2 driver and initializes fields of each channel objects
@@ -1625,11 +1721,9 @@ vpif_init_free_channel_objects:
 static __init int vpif_probe(struct platform_device *pdev)
 {
 	struct vpif_subdev_info *subdevdata;
-	struct vpif_display_config *config;
-	int i, j = 0, k, err = 0;
+	int i, j = 0, err = 0;
 	int res_idx = 0;
 	struct i2c_adapter *i2c_adap;
-	struct common_obj *common;
 	struct channel_obj *ch;
 	struct video_device *vfd;
 	struct resource *res;
@@ -1708,11 +1802,9 @@ static __init int vpif_probe(struct platform_device *pdev)
 									size/2;
 		}
 	}
-
-	i2c_adap = i2c_get_adapter(1);
-	config = pdev->dev.platform_data;
-	subdev_count = config->subdev_count;
-	subdevdata = config->subdevinfo;
+	vpif_obj.config = pdev->dev.platform_data;
+	subdev_count = vpif_obj.config->subdev_count;
+	subdevdata = vpif_obj.config->subdevinfo;
 	vpif_obj.sd = kzalloc(sizeof(struct v4l2_subdev *) * subdev_count,
 								GFP_KERNEL);
 	if (vpif_obj.sd == NULL) {
@@ -1721,86 +1813,40 @@ static __init int vpif_probe(struct platform_device *pdev)
 		goto vpif_sd_error;
 	}
 
-	for (i = 0; i < subdev_count; i++) {
-		vpif_obj.sd[i] = v4l2_i2c_new_subdev_board(&vpif_obj.v4l2_dev,
-						i2c_adap,
-						&subdevdata[i].board_info,
-						NULL);
-		if (!vpif_obj.sd[i]) {
-			vpif_err("Error registering v4l2 subdevice\n");
-			err = -ENODEV;
-			goto probe_subdev_out;
-		}
-
-		if (vpif_obj.sd[i])
-			vpif_obj.sd[i]->grp_id = 1 << i;
-	}
-
-	for (j = 0; j < VPIF_DISPLAY_MAX_DEVICES; j++) {
-		ch = vpif_obj.dev[j];
-		/* Initialize field of the channel objects */
-		atomic_set(&ch->usrs, 0);
-		for (k = 0; k < VPIF_NUMOBJECTS; k++) {
-			ch->common[k].numbuffers = 0;
-			common = &ch->common[k];
-			common->io_usrs = 0;
-			common->started = 0;
-			spin_lock_init(&common->irqlock);
-			mutex_init(&common->lock);
-			common->numbuffers = 0;
-			common->set_addr = NULL;
-			common->ytop_off = common->ybtm_off = 0;
-			common->ctop_off = common->cbtm_off = 0;
-			common->cur_frm = common->next_frm = NULL;
-			memset(&common->fmt, 0, sizeof(common->fmt));
-			common->numbuffers = config_params.numbuffers[k];
+	if (!vpif_obj.config->asd_sizes) {
+		i2c_adap = i2c_get_adapter(1);
+		for (i = 0; i < subdev_count; i++) {
+			vpif_obj.sd[i] =
+				v4l2_i2c_new_subdev_board(&vpif_obj.v4l2_dev,
+							  i2c_adap,
+							  &subdevdata[i].
+							  board_info,
+							  NULL);
+			if (!vpif_obj.sd[i]) {
+				vpif_err("Error registering v4l2 subdevice\n");
+				goto probe_subdev_out;
+			}
 
+			if (vpif_obj.sd[i])
+				vpif_obj.sd[i]->grp_id = 1 << i;
+		}
+		vpif_probe_complete();
+	} else {
+		vpif_obj.notifier.subdev = vpif_obj.config->asd;
+		vpif_obj.notifier.num_subdevs = vpif_obj.config->asd_sizes[0];
+		vpif_obj.notifier.bound = vpif_async_bound;
+		vpif_obj.notifier.complete = vpif_async_complete;
+		err = v4l2_async_notifier_register(&vpif_obj.v4l2_dev,
+						   &vpif_obj.notifier);
+		if (err) {
+			vpif_err("Error registering async notifier\n");
+			err = -EINVAL;
+			goto probe_subdev_out;
 		}
-		ch->initialized = 0;
-		if (subdev_count)
-			ch->sd = vpif_obj.sd[0];
-		ch->channel_id = j;
-		if (j < 2)
-			ch->common[VPIF_VIDEO_INDEX].numbuffers =
-			    config_params.numbuffers[ch->channel_id];
-		else
-			ch->common[VPIF_VIDEO_INDEX].numbuffers = 0;
-
-		memset(&ch->vpifparams, 0, sizeof(ch->vpifparams));
-
-		/* Initialize prio member of channel object */
-		v4l2_prio_init(&ch->prio);
-		ch->common[VPIF_VIDEO_INDEX].fmt.type =
-						V4L2_BUF_TYPE_VIDEO_OUTPUT;
-		ch->video_dev->lock = &common->lock;
-		video_set_drvdata(ch->video_dev, ch);
-
-		/* select output 0 */
-		err = vpif_set_output(config, ch, 0);
-		if (err)
-			goto probe_out;
-
-		/* register video device */
-		vpif_dbg(1, debug, "channel=%x,channel->video_dev=%x\n",
-				(int)ch, (int)&ch->video_dev);
-
-		err = video_register_device(ch->video_dev,
-					  VFL_TYPE_GRABBER, (j ? 3 : 2));
-		if (err < 0)
-			goto probe_out;
 	}
 
-	v4l2_info(&vpif_obj.v4l2_dev,
-			" VPIF display driver initialized\n");
 	return 0;
 
-probe_out:
-	for (k = 0; k < j; k++) {
-		ch = vpif_obj.dev[k];
-		video_unregister_device(ch->video_dev);
-		video_device_release(ch->video_dev);
-		ch->video_dev = NULL;
-	}
 probe_subdev_out:
 	kfree(vpif_obj.sd);
 vpif_sd_error:
diff --git a/drivers/media/platform/davinci/vpif_display.h b/drivers/media/platform/davinci/vpif_display.h
index 5d87fc8..4d0485b 100644
--- a/drivers/media/platform/davinci/vpif_display.h
+++ b/drivers/media/platform/davinci/vpif_display.h
@@ -148,7 +148,8 @@ struct vpif_device {
 	struct v4l2_device v4l2_dev;
 	struct channel_obj *dev[VPIF_DISPLAY_NUM_CHANNELS];
 	struct v4l2_subdev **sd;
-
+	struct v4l2_async_notifier notifier;
+	struct vpif_display_config *config;
 };
 
 struct vpif_config_params {
diff --git a/include/media/davinci/vpif_types.h b/include/media/davinci/vpif_types.h
index e08bcde..3cb1704 100644
--- a/include/media/davinci/vpif_types.h
+++ b/include/media/davinci/vpif_types.h
@@ -59,6 +59,8 @@ struct vpif_display_config {
 	int subdev_count;
 	struct vpif_display_chan_config chan_config[VPIF_DISPLAY_MAX_CHANNELS];
 	const char *card_name;
+	struct v4l2_async_subdev **asd;	/* Flat array, arranged in groups */
+	int *asd_sizes;		/* 0-terminated array of asd group sizes */
 };
 
 struct vpif_input {
-- 
1.7.9.5

