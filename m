Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630AbaJNPBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 11:01:24 -0400
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:49262 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932497AbaJNO71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:59:27 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: m.chehab@samsung.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, crope@iki.fi, olebowle@gmx.com,
        dheitmueller@kernellabs.com, hverkuil@xs4all.nl, ramakrmu@cisco.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        perex@perex.cz, tiwai@suse.de, prabhakar.csengg@gmail.com,
        tim.gardner@canonical.com, linux@eikelenboom.it
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/6] media: v4l2-core changes to use media token api
Date: Tue, 14 Oct 2014 08:58:38 -0600
Message-Id: <18acf9bc97414fc67a60b799cd711c58c068bfaf.1413246372.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1413246370.git.shuahkh@osg.samsung.com>
References: <cover.1413246370.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1413246370.git.shuahkh@osg.samsung.com>
References: <cover.1413246370.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes to v4l2-core to hold tuner and audio tokens in v4l2
ioctl that change the tuner modes, and release the token from
fh exit. The changes are limited to vb2 calls that disrupt
digital stream. vb1 changes are made in the driver. The
following ioctls are changed:

S_INPUT, S_FMT, S_TUNER, S_FREQUENCY, S_STD, S_HW_FREQ_SEEK,
VIDIOC_ENUMINPUT, and VIDIOC_QUERYSTD:

- hold tuner and audio tokens before calling appropriate
  ops->vidioc_s_*
- return tuner and audio tokens locked.

v4l2_fh_exit:

- releases tuner and audio tokens.

Note that media_get_tuner_tkn() will do a get on audio token
and return with both tuner and audio tokens locked. When tuner
token released using media_put_tuner_tkn() , audio token is
released.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/v4l2-core/v4l2-fh.c    |    7 ++++
 drivers/media/v4l2-core/v4l2-ioctl.c |   61 ++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-fh.c b/drivers/media/v4l2-core/v4l2-fh.c
index c97067a..717e03d 100644
--- a/drivers/media/v4l2-core/v4l2-fh.c
+++ b/drivers/media/v4l2-core/v4l2-fh.c
@@ -25,7 +25,10 @@
 #include <linux/bitops.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <linux/device.h>
+#include <linux/media_tknres.h>
 #include <media/v4l2-dev.h>
+#include <media/v4l2-device.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-ioctl.h>
@@ -92,6 +95,10 @@ void v4l2_fh_exit(struct v4l2_fh *fh)
 {
 	if (fh->vdev == NULL)
 		return;
+
+	if (fh->vdev->dev_parent)
+		media_put_tuner_tkn(fh->vdev->dev_parent);
+
 	v4l2_event_unsubscribe_all(fh);
 	fh->vdev = NULL;
 }
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 9ccb19a..686f428 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -17,6 +17,7 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/version.h>
+#include <linux/media_tknres.h>
 
 #include <linux/videodev2.h>
 
@@ -1003,6 +1004,15 @@ static void v4l_sanitize_format(struct v4l2_format *fmt)
 	       sizeof(fmt->fmt.pix) - offset);
 }
 
+static int v4l_get_tuner_tkn(struct video_device *vfd)
+{
+	int rc = 0;
+
+	if (vfd->dev_parent)
+		rc = media_get_tuner_tkn(vfd->dev_parent);
+	return rc;
+}
+
 static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
@@ -1022,6 +1032,14 @@ static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
 static int v4l_s_input(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
+	struct video_device *vfd = video_devdata(file);
+	int ret = 0;
+
+	ret = v4l_get_tuner_tkn(vfd);
+	if (ret) {
+		pr_info("%s: Tuner is busy\n", __func__);
+		return ret;
+	}
 	return ops->vidioc_s_input(file, fh, *(unsigned int *)arg);
 }
 
@@ -1063,7 +1081,13 @@ static int v4l_enuminput(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_input *p = arg;
+	int ret;
 
+	ret = v4l_get_tuner_tkn(vfd);
+	if (ret) {
+		pr_info("%s: Tuner is busy\n", __func__);
+		return ret;
+	}
 	/*
 	 * We set the flags for CAP_DV_TIMINGS &
 	 * CAP_STD here based on ioctl handler provided by the
@@ -1236,6 +1260,12 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 	int ret;
 
+	ret = v4l_get_tuner_tkn(vfd);
+	if (ret) {
+		pr_info("%s: Tuner is busy\n", __func__);
+		return ret;
+	}
+
 	v4l_sanitize_format(p);
 
 	switch (p->type) {
@@ -1415,9 +1445,15 @@ static int v4l_s_tuner(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_tuner *p = arg;
+	int ret;
 
 	p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
 			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+	ret = v4l_get_tuner_tkn(vfd);
+	if (ret) {
+		pr_info("%s: Tuner is busy\n", __func__);
+		return ret;
+	}
 	return ops->vidioc_s_tuner(file, fh, p);
 }
 
@@ -1453,6 +1489,7 @@ static int v4l_s_frequency(const struct v4l2_ioctl_ops *ops,
 	struct video_device *vfd = video_devdata(file);
 	const struct v4l2_frequency *p = arg;
 	enum v4l2_tuner_type type;
+	int ret;
 
 	if (vfd->vfl_type == VFL_TYPE_SDR) {
 		if (p->type != V4L2_TUNER_ADC && p->type != V4L2_TUNER_RF)
@@ -1462,6 +1499,11 @@ static int v4l_s_frequency(const struct v4l2_ioctl_ops *ops,
 				V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		if (type != p->type)
 			return -EINVAL;
+		ret = v4l_get_tuner_tkn(vfd);
+		if (ret) {
+			pr_info("%s: Tuner is busy\n", __func__);
+			return ret;
+		}
 	}
 	return ops->vidioc_s_frequency(file, fh, p);
 }
@@ -1508,11 +1550,18 @@ static int v4l_s_std(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	v4l2_std_id id = *(v4l2_std_id *)arg, norm;
+	int ret = 0;
 
 	norm = id & vfd->tvnorms;
 	if (vfd->tvnorms && !norm)	/* Check if std is supported */
 		return -EINVAL;
 
+	ret = v4l_get_tuner_tkn(vfd);
+	if (ret) {
+		pr_info("%s: Tuner is busy\n", __func__);
+		return ret;
+	}
+
 	/* Calls the specific handler */
 	return ops->vidioc_s_std(file, fh, norm);
 }
@@ -1522,7 +1571,13 @@ static int v4l_querystd(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	v4l2_std_id *p = arg;
+	int ret = 0;
 
+	ret = v4l_get_tuner_tkn(vfd);
+	if (ret) {
+		pr_info("%s: Tuner is busy\n", __func__);
+		return ret;
+	}
 	/*
 	 * If no signal is detected, then the driver should return
 	 * V4L2_STD_UNKNOWN. Otherwise it should return tvnorms with
@@ -1541,6 +1596,7 @@ static int v4l_s_hw_freq_seek(const struct v4l2_ioctl_ops *ops,
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_hw_freq_seek *p = arg;
 	enum v4l2_tuner_type type;
+	int ret;
 
 	/* s_hw_freq_seek is not supported for SDR for now */
 	if (vfd->vfl_type == VFL_TYPE_SDR)
@@ -1550,6 +1606,11 @@ static int v4l_s_hw_freq_seek(const struct v4l2_ioctl_ops *ops,
 		V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	if (p->type != type)
 		return -EINVAL;
+	ret = v4l_get_tuner_tkn(vfd);
+	if (ret) {
+		pr_info("%s: Tuner is busy\n", __func__);
+		return ret;
+	}
 	return ops->vidioc_s_hw_freq_seek(file, fh, p);
 }
 
-- 
1.7.10.4

