Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205AbaFQOgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:36:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:16609 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696AbaFQOgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:36:47 -0400
Message-ID: <53A05277.7060900@oracle.com>
Date: Tue, 17 Jun 2014 22:36:39 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/24] drivers/base: return actual error on sysfs init
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Liu <jeff.liu@oracle.com>

This patch fix all sysfs init functions under drivers core to
return the actual error code than the hardcoded ENOMEM.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 drivers/base/bus.c   | 16 ++++++++--------
 drivers/base/class.c |  4 ++--
 drivers/base/core.c  |  4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 83e910a..b0590a7 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -901,15 +901,15 @@ int bus_register(struct bus_type *bus)
 
 	priv->devices_kset = kset_create_and_add("devices", NULL,
 						 &priv->subsys.kobj);
-	if (!priv->devices_kset) {
-		retval = -ENOMEM;
+	if (IS_ERR(priv->devices_kset)) {
+		retval = PTR_ERR(priv->devices_kset);
 		goto bus_devices_fail;
 	}
 
 	priv->drivers_kset = kset_create_and_add("drivers", NULL,
 						 &priv->subsys.kobj);
-	if (!priv->drivers_kset) {
-		retval = -ENOMEM;
+	if (IS_ERR(priv->drivers_kset)) {
+		retval = PTR_ERR(priv->drivers_kset);
 		goto bus_drivers_fail;
 	}
 
@@ -1261,12 +1261,12 @@ EXPORT_SYMBOL_GPL(subsys_virtual_register);
 int __init buses_init(void)
 {
 	bus_kset = kset_create_and_add("bus", &bus_uevent_ops, NULL);
-	if (!bus_kset)
-		return -ENOMEM;
+	if (IS_ERR(bus_kset))
+		return PTR_ERR(bus_kset);
 
 	system_kset = kset_create_and_add("system", NULL, &devices_kset->kobj);
-	if (!system_kset)
-		return -ENOMEM;
+	if (IS_ERR(system_kset))
+		return PTR_ERR(system_kset);
 
 	return 0;
 }
diff --git a/drivers/base/class.c b/drivers/base/class.c
index f96f704..56e16fa 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -584,8 +584,8 @@ EXPORT_SYMBOL_GPL(class_compat_remove_link);
 int __init classes_init(void)
 {
 	class_kset = kset_create_and_add("class", NULL, NULL);
-	if (!class_kset)
-		return -ENOMEM;
+	if (IS_ERR(class_kset))
+		return PTR_ERR(class_kset);
 	return 0;
 }
 
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 20da3ad..0f729f9 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1364,8 +1364,8 @@ EXPORT_SYMBOL_GPL(device_find_child);
 int __init devices_init(void)
 {
 	devices_kset = kset_create_and_add("devices", &device_uevent_ops, NULL);
-	if (!devices_kset)
-		return -ENOMEM;
+	if (IS_ERR(devices_kset))
+		return PTR_ERR(devices_kset);
 	dev_kobj = kobject_create_and_add("dev", NULL);
 	if (!dev_kobj)
 		goto dev_kobj_err;
-- 
1.8.3.2
