Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab3JHCQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 22:16:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab3JHCQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 22:16:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>
Subject: [PATCH 5/8] virtio: convert bus code to use dev_groups
Date: Mon,  7 Oct 2013 18:27:39 -0700
Message-Id: <1381195662-28009-6-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <1381195662-28009-1-git-send-email-gregkh@linuxfoundation.org>
References: <1381195662-28009-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the virtio bus code to use the
correct field.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: <virtualization@lists.linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Rusty and Michael, I can take this through my driver-core tree if you
don't want to take it through yours, just let me know what works best
for you.

 drivers/virtio/virtio.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index ee59b74..fed0ce1 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -13,18 +13,24 @@ static ssize_t device_show(struct device *_d,
 	struct virtio_device *dev = dev_to_virtio(_d);
 	return sprintf(buf, "0x%04x\n", dev->id.device);
 }
+static DEVICE_ATTR_RO(device);
+
 static ssize_t vendor_show(struct device *_d,
 			   struct device_attribute *attr, char *buf)
 {
 	struct virtio_device *dev = dev_to_virtio(_d);
 	return sprintf(buf, "0x%04x\n", dev->id.vendor);
 }
+static DEVICE_ATTR_RO(vendor);
+
 static ssize_t status_show(struct device *_d,
 			   struct device_attribute *attr, char *buf)
 {
 	struct virtio_device *dev = dev_to_virtio(_d);
 	return sprintf(buf, "0x%08x\n", dev->config->get_status(dev));
 }
+static DEVICE_ATTR_RO(status);
+
 static ssize_t modalias_show(struct device *_d,
 			     struct device_attribute *attr, char *buf)
 {
@@ -32,6 +38,8 @@ static ssize_t modalias_show(struct device *_d,
 	return sprintf(buf, "virtio:d%08Xv%08X\n",
 		       dev->id.device, dev->id.vendor);
 }
+static DEVICE_ATTR_RO(modalias);
+
 static ssize_t features_show(struct device *_d,
 			     struct device_attribute *attr, char *buf)
 {
@@ -47,14 +55,17 @@ static ssize_t features_show(struct device *_d,
 	len += sprintf(buf+len, "\n");
 	return len;
 }
-static struct device_attribute virtio_dev_attrs[] = {
-	__ATTR_RO(device),
-	__ATTR_RO(vendor),
-	__ATTR_RO(status),
-	__ATTR_RO(modalias),
-	__ATTR_RO(features),
-	__ATTR_NULL
+static DEVICE_ATTR_RO(features);
+
+static struct attribute *virtio_dev_attrs[] = {
+	&dev_attr_device.attr,
+	&dev_attr_vendor.attr,
+	&dev_attr_status.attr,
+	&dev_attr_modalias.attr,
+	&dev_attr_features.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(virtio_dev);
 
 static inline int virtio_id_match(const struct virtio_device *dev,
 				  const struct virtio_device_id *id)
@@ -165,7 +176,7 @@ static int virtio_dev_remove(struct device *_d)
 static struct bus_type virtio_bus = {
 	.name  = "virtio",
 	.match = virtio_dev_match,
-	.dev_attrs = virtio_dev_attrs,
+	.dev_groups = virtio_dev_groups,
 	.uevent = virtio_uevent,
 	.probe = virtio_dev_probe,
 	.remove = virtio_dev_remove,
-- 
1.8.4.6.g82e253f.dirty

