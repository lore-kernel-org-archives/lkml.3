Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab3JGGzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 02:55:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab3JGGzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 02:55:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        <xen-devel@lists.xenproject.org>
Subject: [PATCH 10/11] xenbus: convert bus code to use dev_groups
Date: Sun,  6 Oct 2013 23:55:49 -0700
Message-Id: <1381128950-28125-11-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <1381128950-28125-1-git-send-email-gregkh@linuxfoundation.org>
References: <1381128950-28125-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the xenbus code to use the
correct field.

Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: <xen-devel@lists.xenproject.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Konrad, I can take this through my driver-core tree if you like, just
let me know what would be the easiest for you.

 drivers/xen/xenbus/xenbus_probe.c          | 24 ++++++++++++++++++------
 drivers/xen/xenbus/xenbus_probe.h          |  2 +-
 drivers/xen/xenbus/xenbus_probe_backend.c  |  2 +-
 drivers/xen/xenbus/xenbus_probe_frontend.c |  2 +-
 4 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 38e92b7..3c0a74b 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -384,12 +384,14 @@ static ssize_t nodename_show(struct device *dev,
 {
 	return sprintf(buf, "%s\n", to_xenbus_device(dev)->nodename);
 }
+static DEVICE_ATTR_RO(nodename);
 
 static ssize_t devtype_show(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
 	return sprintf(buf, "%s\n", to_xenbus_device(dev)->devicetype);
 }
+static DEVICE_ATTR_RO(devtype);
 
 static ssize_t modalias_show(struct device *dev,
 			     struct device_attribute *attr, char *buf)
@@ -397,14 +399,24 @@ static ssize_t modalias_show(struct device *dev,
 	return sprintf(buf, "%s:%s\n", dev->bus->name,
 		       to_xenbus_device(dev)->devicetype);
 }
+static DEVICE_ATTR_RO(modalias);
 
-struct device_attribute xenbus_dev_attrs[] = {
-	__ATTR_RO(nodename),
-	__ATTR_RO(devtype),
-	__ATTR_RO(modalias),
-	__ATTR_NULL
+static struct attribute *xenbus_dev_attrs[] = {
+	&dev_attr_nodename.attr,
+	&dev_attr_devtype.attr,
+	&dev_attr_modalias.attr,
+	NULL,
 };
-EXPORT_SYMBOL_GPL(xenbus_dev_attrs);
+
+static const struct attribute_group xenbus_dev_group = {
+	.attrs = xenbus_dev_attrs,
+};
+
+const struct attribute_group *xenbus_dev_groups[] = {
+	&xenbus_dev_group,
+	NULL,
+};
+EXPORT_SYMBOL_GPL(xenbus_dev_groups);
 
 int xenbus_probe_node(struct xen_bus_type *bus,
 		      const char *type,
diff --git a/drivers/xen/xenbus/xenbus_probe.h b/drivers/xen/xenbus/xenbus_probe.h
index 146f857..1085ec2 100644
--- a/drivers/xen/xenbus/xenbus_probe.h
+++ b/drivers/xen/xenbus/xenbus_probe.h
@@ -54,7 +54,7 @@ enum xenstore_init {
 	XS_LOCAL,
 };
 
-extern struct device_attribute xenbus_dev_attrs[];
+extern const struct attribute_group *xenbus_dev_groups[];
 
 extern int xenbus_match(struct device *_dev, struct device_driver *_drv);
 extern int xenbus_dev_probe(struct device *_dev);
diff --git a/drivers/xen/xenbus/xenbus_probe_backend.c b/drivers/xen/xenbus/xenbus_probe_backend.c
index 998bbba..5125dce 100644
--- a/drivers/xen/xenbus/xenbus_probe_backend.c
+++ b/drivers/xen/xenbus/xenbus_probe_backend.c
@@ -200,7 +200,7 @@ static struct xen_bus_type xenbus_backend = {
 		.probe		= xenbus_dev_probe,
 		.remove		= xenbus_dev_remove,
 		.shutdown	= xenbus_dev_shutdown,
-		.dev_attrs	= xenbus_dev_attrs,
+		.dev_groups	= xenbus_dev_groups,
 	},
 };
 
diff --git a/drivers/xen/xenbus/xenbus_probe_frontend.c b/drivers/xen/xenbus/xenbus_probe_frontend.c
index 34b20bf..129bf84 100644
--- a/drivers/xen/xenbus/xenbus_probe_frontend.c
+++ b/drivers/xen/xenbus/xenbus_probe_frontend.c
@@ -154,7 +154,7 @@ static struct xen_bus_type xenbus_frontend = {
 		.probe		= xenbus_frontend_dev_probe,
 		.remove		= xenbus_dev_remove,
 		.shutdown	= xenbus_dev_shutdown,
-		.dev_attrs	= xenbus_dev_attrs,
+		.dev_groups	= xenbus_dev_groups,
 
 		.pm		= &xenbus_pm_ops,
 	},
-- 
1.8.4.6.g82e253f.dirty

