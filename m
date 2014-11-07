Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaKGGfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 01:35:34 -0500
Received: from gate.crashing.org ([63.228.1.57]:39937 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbaKGGfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 01:35:31 -0500
Message-ID: <1415342117.4925.29.camel@kernel.crashing.org>
Subject: Re: [RFC] Add of_path property for all devices with a node
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: devicetree@vger.kernel.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Date: Fri, 07 Nov 2014 17:35:17 +1100
In-Reply-To: <1415342031.4925.27.camel@kernel.crashing.org>
References: <1415342031.4925.27.camel@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-07 at 17:33 +1100, Benjamin Herrenschmidt wrote:

> So I came up with this patch, 

And here is the actual patch, which might help :-) It's pretty trivial
and small...

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 20da3ad..dd0ee1b 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -26,6 +26,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/netdevice.h>
 #include <linux/sysfs.h>
+#include <linux/of.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -454,6 +455,23 @@ static ssize_t online_store(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RW(online);
 
+#ifdef CONFIG_OF
+
+static ssize_t of_path_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	ssize_t s = 0;
+
+	device_lock(dev);
+	if (dev->of_node)
+		s = sprintf(buf, "%s\n", dev->of_node->full_name);
+	device_unlock(dev);
+	return s;
+}
+static DEVICE_ATTR_RO(of_path);
+
+#endif /* CONFIG_OF */
+
 int device_add_groups(struct device *dev, const struct attribute_group **groups)
 {
 	return sysfs_create_groups(&dev->kobj, groups);
@@ -487,15 +505,27 @@ static int device_add_attrs(struct device *dev)
 	if (error)
 		goto err_remove_type_groups;
 
+#ifdef CONFIG_OF
+	if (dev->of_node) {
+		error = device_create_file(dev, &dev_attr_of_path);
+		if (error)
+			goto err_remove_dev_groups;
+	}
+#endif /* CONFIG_OF */
+
 	if (device_supports_offline(dev) && !dev->offline_disabled) {
 		error = device_create_file(dev, &dev_attr_online);
 		if (error)
-			goto err_remove_dev_groups;
+			goto err_remove_of_path;
 	}
 
 	return 0;
 
+ err_remove_of_path:
+#ifdef CONFIG_OF
+	device_remove_file(dev, &dev_attr_of_path);
  err_remove_dev_groups:
+#endif
 	device_remove_groups(dev, dev->groups);
  err_remove_type_groups:
 	if (type)


