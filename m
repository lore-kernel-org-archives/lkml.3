Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab3GXWMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:12:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab3GXWGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:06:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 29/36] video: output: convert class code to use dev_groups
Date: Wed, 24 Jul 2013 15:05:32 -0700
Message-Id: <1374703539-9705-30-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct class is going away soon, dev_groups
should be used instead.  This converts the video output class code to
use the correct field.

Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Jean-Christophe and Tomi, feel free to take this through your tree, or
ACK it and I can take it through mine.

 drivers/video/output.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/video/output.c b/drivers/video/output.c
index 6285b971..1446c49f 100644
--- a/drivers/video/output.c
+++ b/drivers/video/output.c
@@ -32,8 +32,8 @@ MODULE_DESCRIPTION("Display Output Switcher Lowlevel Control Abstraction");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Luming Yu <luming.yu@intel.com>");
 
-static ssize_t video_output_show_state(struct device *dev,
-				       struct device_attribute *attr, char *buf)
+static ssize_t state_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
 {
 	ssize_t ret_size = 0;
 	struct output_device *od = to_output_device(dev);
@@ -42,9 +42,8 @@ static ssize_t video_output_show_state(struct device *dev,
 	return ret_size;
 }
 
-static ssize_t video_output_store_state(struct device *dev,
-					struct device_attribute *attr,
-					const char *buf,size_t count)
+static ssize_t state_store(struct device *dev, struct device_attribute *attr,
+			   const char *buf,size_t count)
 {
 	char *endp;
 	struct output_device *od = to_output_device(dev);
@@ -62,6 +61,7 @@ static ssize_t video_output_store_state(struct device *dev,
 	}
 	return count;
 }
+static DEVICE_ATTR_RW(state);
 
 static void video_output_release(struct device *dev)
 {
@@ -69,16 +69,16 @@ static void video_output_release(struct device *dev)
 	kfree(od);
 }
 
-static struct device_attribute video_output_attributes[] = {
-	__ATTR(state, 0644, video_output_show_state, video_output_store_state),
-	__ATTR_NULL,
+static struct attribute *video_output_attrs[] = {
+	&dev_attr_state.attr,
+	NULL,
 };
-
+ATTRIBUTE_GROUPS(video_output);
 
 static struct class video_output_class = {
 	.name = "video_output",
 	.dev_release = video_output_release,
-	.dev_attrs = video_output_attributes,
+	.dev_groups = video_output_groups,
 };
 
 struct output_device *video_output_register(const char *name,
-- 
1.8.3.rc0.20.gb99dd2e

