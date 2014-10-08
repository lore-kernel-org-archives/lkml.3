Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbaJHHyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 03:54:05 -0400
Received: from mail.tune-it.ru ([80.246.244.150]:64222 "EHLO mail.tune-it.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbaJHHyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 03:54:04 -0400
X-Greylist: delayed 1222 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Oct 2014 03:54:03 EDT
From: Sergey Klyaus <Sergey.Klyaus@tune-it.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: fix race with userland in device_add()
Date: Wed, 08 Oct 2014 11:31:54 +0400
Message-ID: <3249227.py6aLU3D94@zenbook.mylocal>
User-Agent: KMail/4.11.2 (Linux/3.11.10-17-desktop; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bus_add_device() should be called before devtmpfs_create_node(), so when 
userland application opens device from devtmpfs, it wouldn't get ENODEV 
from kernel, because device_add() wasn't completed.

Signed-off-by: Sergey Klyaus <Sergey.Klyaus@Tune-IT.Ru>
---
 drivers/base/core.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 20da3ad..88ee96a 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1019,18 +1019,6 @@ int device_add(struct device *dev)
 	if (error)
 		goto attrError;
 
-	if (MAJOR(dev->devt)) {
-		error = device_create_file(dev, &dev_attr_dev);
-		if (error)
-			goto ueventattrError;
-
-		error = device_create_sys_dev_entry(dev);
-		if (error)
-			goto devtattrError;
-
-		devtmpfs_create_node(dev);
-	}
-
 	error = device_add_class_symlinks(dev);
 	if (error)
 		goto SymlinkError;
@@ -1044,7 +1032,19 @@ int device_add(struct device *dev)
 	if (error)
 		goto DPMError;
 	device_pm_add(dev);
-
+	
+	if (MAJOR(dev->devt)) {
+		error = device_create_file(dev, &dev_attr_dev);
+		if (error)
+			goto DevAttrError;
+		
+		error = device_create_sys_dev_entry(dev);
+		if (error)
+			goto SysEntryError;
+		
+		devtmpfs_create_node(dev);
+	}
+	
 	/* Notify clients of device addition.  This call must come
 	 * after dpm_sysfs_add() and before kobject_uevent().
 	 */
@@ -1074,6 +1074,12 @@ int device_add(struct device *dev)
 done:
 	put_device(dev);
 	return error;
+ SysEntryError:
+	if (MAJOR(dev->devt))
+		device_remove_file(dev, &dev_attr_dev);
+ DevAttrError:
+	device_pm_remove(dev);
+	dpm_sysfs_remove(dev);
  DPMError:
 	bus_remove_device(dev);
  BusError:
@@ -1081,14 +1087,6 @@ done:
  AttrsError:
 	device_remove_class_symlinks(dev);
  SymlinkError:
-	if (MAJOR(dev->devt))
-		devtmpfs_delete_node(dev);
-	if (MAJOR(dev->devt))
-		device_remove_sys_dev_entry(dev);
- devtattrError:
-	if (MAJOR(dev->devt))
-		device_remove_file(dev, &dev_attr_dev);
- ueventattrError:
 	device_remove_file(dev, &dev_attr_uevent);
  attrError:
 	kobject_uevent(&dev->kobj, KOBJ_REMOVE);
-- 
1.8.4.5
