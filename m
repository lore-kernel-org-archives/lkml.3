Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab3GXWGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:06:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab3GXWFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:05:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 11/36] v4l2: convert class code to use dev_groups
Date: Wed, 24 Jul 2013 15:05:14 -0700
Message-Id: <1374703539-9705-12-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct class is going away soon, dev_groups
should be used instead.  This converts the v4l2 class code to use the
correct field.

Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Mauro, feel free to take this through your tree, or ACK it and I can take it
through mine.

 drivers/media/v4l2-core/v4l2-dev.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index c8859d6f..b0f49b01 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -38,24 +38,25 @@
  *	sysfs stuff
  */
 
-static ssize_t show_index(struct device *cd,
-			 struct device_attribute *attr, char *buf)
+static ssize_t index_show(struct device *cd,
+			  struct device_attribute *attr, char *buf)
 {
 	struct video_device *vdev = to_video_device(cd);
 
 	return sprintf(buf, "%i\n", vdev->index);
 }
+static DEVICE_ATTR_RO(index);
 
-static ssize_t show_debug(struct device *cd,
-			 struct device_attribute *attr, char *buf)
+static ssize_t debug_show(struct device *cd,
+			  struct device_attribute *attr, char *buf)
 {
 	struct video_device *vdev = to_video_device(cd);
 
 	return sprintf(buf, "%i\n", vdev->debug);
 }
 
-static ssize_t set_debug(struct device *cd, struct device_attribute *attr,
-		   const char *buf, size_t len)
+static ssize_t debug_store(struct device *cd, struct device_attribute *attr,
+			  const char *buf, size_t len)
 {
 	struct video_device *vdev = to_video_device(cd);
 	int res = 0;
@@ -68,21 +69,24 @@ static ssize_t set_debug(struct device *cd, struct device_attribute *attr,
 	vdev->debug = value;
 	return len;
 }
+static DEVICE_ATTR_RW(debug);
 
-static ssize_t show_name(struct device *cd,
+static ssize_t name_show(struct device *cd,
 			 struct device_attribute *attr, char *buf)
 {
 	struct video_device *vdev = to_video_device(cd);
 
 	return sprintf(buf, "%.*s\n", (int)sizeof(vdev->name), vdev->name);
 }
+static DEVICE_ATTR_RO(name);
 
-static struct device_attribute video_device_attrs[] = {
-	__ATTR(name, S_IRUGO, show_name, NULL),
-	__ATTR(debug, 0644, show_debug, set_debug),
-	__ATTR(index, S_IRUGO, show_index, NULL),
-	__ATTR_NULL
+static struct attribute *video_device_attrs[] = {
+	&dev_attr_name.attr,
+	&dev_attr_debug.attr,
+	&dev_attr_index.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(video_device);
 
 /*
  *	Active devices
@@ -217,7 +221,7 @@ static void v4l2_device_release(struct device *cd)
 
 static struct class video_class = {
 	.name = VIDEO_NAME,
-	.dev_attrs = video_device_attrs,
+	.dev_groups = video_device_groups,
 };
 
 struct video_device *video_devdata(struct file *file)
-- 
1.8.3.rc0.20.gb99dd2e

