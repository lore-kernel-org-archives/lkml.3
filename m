Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbaIVPI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:08:58 -0400
Received: from resqmta-po-12v.sys.comcast.net ([96.114.154.171]:39856 "EHLO
	resqmta-po-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754036AbaIVPHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:07:10 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: m.chehab@samsung.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, crope@iki.fi, olebowle@gmx.com,
        dheitmueller@kernellabs.co, hverkuil@xs4all.nl, ramakrmu@cisco.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 2/5] media: v4l2-core changes to use media tuner token api
Date: Mon, 22 Sep 2014 09:00:46 -0600
Message-Id: <b83cf780636a80aec53e3b7e8f101645049e94f3.1411397045.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1411397045.git.shuahkh@osg.samsung.com>
References: <cover.1411397045.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1411397045.git.shuahkh@osg.samsung.com>
References: <cover.1411397045.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes to v4l2-core to hold tuner token in v4l2 ioctl that change
the tuner modes, and reset the token from fh exit. The changes are
limited to vb2 calls that disrupt digital stream. vb1 changes are
made in the driver. The following ioctls are changed:

S_INPUT, S_OUTPUT, S_FMT, S_TUNER, S_MODULATOR, S_FREQUENCY,
S_STD, S_HW_FREQ_SEEK:

- hold tuner in shared analog mode before calling appropriate
  ops->vidioc_s_*
- return leaving tuner in shared mode.
- Note that S_MODULATOR is now implemented in the core
  previously FCN.

QUERYSTD:
- hold tuner in shared analog mode before calling
  ops->vidioc_querystd
- return after calling put tuner - this simply decrements the
  owners. Leaves tuner in shared analog mode if owners > 0

v4l2_fh_exit:
- resets the media tuner token. A simple put token could leave
  the token in shared mode. The nature of analog token holds
  is unbalanced requiring a reset to clear it.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/v4l2-core/v4l2-fh.c    |   16 ++++++
 drivers/media/v4l2-core/v4l2-ioctl.c |   96 +++++++++++++++++++++++++++++++++-
 2 files changed, 110 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fh.c b/drivers/media/v4l2-core/v4l2-fh.c
index c97067a..81ce3f9 100644
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
@@ -92,6 +95,19 @@ void v4l2_fh_exit(struct v4l2_fh *fh)
 {
 	if (fh->vdev == NULL)
 		return;
+
+	if (fh->vdev->dev_parent) {
+		enum media_tkn_mode mode;
+
+		mode = (fh->vdev->vfl_type == V4L2_TUNER_RADIO) ?
+			MEDIA_MODE_RADIO : MEDIA_MODE_ANALOG;
+		/* reset the token - the nature of token get in
+		   analog mode is shared and unbalanced. There is
+		   no clear start and stop, so shared token might
+		   never get cleared */
+		media_reset_shared_tuner_tkn(fh->vdev->dev_parent, mode);
+	}
+
 	v4l2_event_unsubscribe_all(fh);
 	fh->vdev = NULL;
 }
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index d15e167..9e1f042 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -17,6 +17,7 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/version.h>
+#include <linux/media_tknres.h>
 
 #include <linux/videodev2.h>
 
@@ -1003,6 +1004,37 @@ static void v4l_sanitize_format(struct v4l2_format *fmt)
 	       sizeof(fmt->fmt.pix) - offset);
 }
 
+static int v4l_get_tuner_tkn(struct video_device *vfd,
+				enum v4l2_tuner_type type)
+{
+	int ret = 0;
+
+	if (vfd->dev_parent) {
+		enum media_tkn_mode mode;
+
+		mode = (type == V4L2_TUNER_RADIO) ?
+			MEDIA_MODE_RADIO : MEDIA_MODE_ANALOG;
+		ret = media_get_shared_tuner_tkn(vfd->dev_parent, mode);
+		if (ret)
+			dev_info(vfd->dev_parent,
+				"%s: Tuner is busy\n", __func__);
+	}
+	dev_dbg(vfd->dev_parent, "%s: No token?? %d\n", __func__, ret);
+	return ret;
+}
+
+static void v4l_put_tuner_tkn(struct video_device *vfd,
+				enum v4l2_tuner_type type)
+{
+	if (vfd->dev_parent) {
+		enum media_tkn_mode mode;
+
+		mode = (type == V4L2_TUNER_RADIO) ?
+			MEDIA_MODE_RADIO : MEDIA_MODE_ANALOG;
+		media_put_tuner_tkn(vfd->dev_parent, mode);
+	}
+}
+
 static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
@@ -1022,12 +1054,24 @@ static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
 static int v4l_s_input(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
+	struct video_device *vfd = video_devdata(file);
+	int ret = 0;
+
+	ret = v4l_get_tuner_tkn(vfd, V4L2_TUNER_ANALOG_TV);
+	if (ret)
+		return ret;
 	return ops->vidioc_s_input(file, fh, *(unsigned int *)arg);
 }
 
 static int v4l_s_output(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
+	struct video_device *vfd = video_devdata(file);
+	int ret = 0;
+
+	ret = v4l_get_tuner_tkn(vfd, V4L2_TUNER_ANALOG_TV);
+	if (ret)
+		return ret;
 	return ops->vidioc_s_output(file, fh, *(unsigned int *)arg);
 }
 
@@ -1236,6 +1280,10 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 	int ret;
 
+	ret = v4l_get_tuner_tkn(vfd, V4L2_TUNER_ANALOG_TV);
+	if (ret)
+		return ret;
+
 	v4l_sanitize_format(p);
 
 	switch (p->type) {
@@ -1415,9 +1463,13 @@ static int v4l_s_tuner(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_tuner *p = arg;
+	int ret;
 
 	p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
 			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+	ret = v4l_get_tuner_tkn(vfd, p->type);
+	if (ret)
+		return ret;
 	return ops->vidioc_s_tuner(file, fh, p);
 }
 
@@ -1433,6 +1485,26 @@ static int v4l_g_modulator(const struct v4l2_ioctl_ops *ops,
 	return err;
 }
 
+static int v4l_s_modulator(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd = video_devdata(file);
+	struct v4l2_fh *vfh =
+		test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
+
+	if (vfh != NULL) {
+		int ret;
+		enum v4l2_tuner_type type;
+
+		type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+				V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+		ret = v4l_get_tuner_tkn(vfd, type);
+		if (ret)
+			return ret;
+	}
+	return ops->vidioc_s_modulator(file, fh, arg);
+}
+
 static int v4l_g_frequency(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
@@ -1453,6 +1525,7 @@ static int v4l_s_frequency(const struct v4l2_ioctl_ops *ops,
 	struct video_device *vfd = video_devdata(file);
 	const struct v4l2_frequency *p = arg;
 	enum v4l2_tuner_type type;
+	int ret;
 
 	if (vfd->vfl_type == VFL_TYPE_SDR) {
 		if (p->type != V4L2_TUNER_ADC && p->type != V4L2_TUNER_RF)
@@ -1462,6 +1535,9 @@ static int v4l_s_frequency(const struct v4l2_ioctl_ops *ops,
 				V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		if (type != p->type)
 			return -EINVAL;
+		ret = v4l_get_tuner_tkn(vfd, type);
+		if (ret)
+			return ret;
 	}
 	return ops->vidioc_s_frequency(file, fh, p);
 }
@@ -1508,11 +1584,16 @@ static int v4l_s_std(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	v4l2_std_id id = *(v4l2_std_id *)arg, norm;
+	int ret = 0;
 
 	norm = id & vfd->tvnorms;
 	if (vfd->tvnorms && !norm)	/* Check if std is supported */
 		return -EINVAL;
 
+	ret = v4l_get_tuner_tkn(vfd, V4L2_TUNER_ANALOG_TV);
+	if (ret)
+		return ret;
+
 	/* Calls the specific handler */
 	return ops->vidioc_s_std(file, fh, norm);
 }
@@ -1522,7 +1603,11 @@ static int v4l_querystd(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	v4l2_std_id *p = arg;
+	int ret = 0;
 
+	ret = v4l_get_tuner_tkn(vfd, V4L2_TUNER_ANALOG_TV);
+	if (ret)
+		return ret;
 	/*
 	 * If no signal is detected, then the driver should return
 	 * V4L2_STD_UNKNOWN. Otherwise it should return tvnorms with
@@ -1532,7 +1617,9 @@ static int v4l_querystd(const struct v4l2_ioctl_ops *ops,
 	 * their efforts to improve the standards detection.
 	 */
 	*p = vfd->tvnorms;
-	return ops->vidioc_querystd(file, fh, arg);
+	ret = ops->vidioc_querystd(file, fh, arg);
+	v4l_put_tuner_tkn(vfd, V4L2_TUNER_ANALOG_TV);
+	return ret;
 }
 
 static int v4l_s_hw_freq_seek(const struct v4l2_ioctl_ops *ops,
@@ -1541,6 +1628,7 @@ static int v4l_s_hw_freq_seek(const struct v4l2_ioctl_ops *ops,
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_hw_freq_seek *p = arg;
 	enum v4l2_tuner_type type;
+	int ret;
 
 	/* s_hw_freq_seek is not supported for SDR for now */
 	if (vfd->vfl_type == VFL_TYPE_SDR)
@@ -1550,6 +1638,9 @@ static int v4l_s_hw_freq_seek(const struct v4l2_ioctl_ops *ops,
 		V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	if (p->type != type)
 		return -EINVAL;
+	ret = v4l_get_tuner_tkn(vfd, type);
+	if (ret)
+		return ret;
 	return ops->vidioc_s_hw_freq_seek(file, fh, p);
 }
 
@@ -2217,7 +2308,8 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_STD(VIDIOC_G_AUDOUT, vidioc_g_audout, v4l_print_audioout, 0),
 	IOCTL_INFO_STD(VIDIOC_S_AUDOUT, vidioc_s_audout, v4l_print_audioout, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_G_MODULATOR, v4l_g_modulator, v4l_print_modulator, INFO_FL_CLEAR(v4l2_modulator, index)),
-	IOCTL_INFO_STD(VIDIOC_S_MODULATOR, vidioc_s_modulator, v4l_print_modulator, INFO_FL_PRIO),
+	IOCTL_INFO_FNC(VIDIOC_S_FREQUENCY, v4l_s_modulator,
+			v4l_print_frequency, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_G_FREQUENCY, v4l_g_frequency, v4l_print_frequency, INFO_FL_CLEAR(v4l2_frequency, tuner)),
 	IOCTL_INFO_FNC(VIDIOC_S_FREQUENCY, v4l_s_frequency, v4l_print_frequency, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_CROPCAP, v4l_cropcap, v4l_print_cropcap, INFO_FL_CLEAR(v4l2_cropcap, type)),
-- 
1.7.10.4

