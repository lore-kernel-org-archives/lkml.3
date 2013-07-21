Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab3GUPe2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 11:34:28 -0400
Received: from mail-gg0-f173.google.com ([209.85.161.173]:52160 "EHLO
	mail-gg0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581Ab3GUPe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 11:34:27 -0400
From: David Graham White <dgwhite11@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, David Graham White <dgwhite11@gmail.com>
Subject: [PATCH] drivers: base: core: Removed superfluous calls to put_device in device_destroy and to kobject deletion functions in device_del.
Date: Sun, 21 Jul 2013 11:34:59 -0400
Message-Id: <1374420899-2525-1-git-send-email-dgwhite11@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When device_destroy is called and the device's embedded kobject may be removed,
this would occur with the call to put_device in device_unregister. Further,
put_device should take care of cleaning up the kobject without the need to
call kobject_del indepenedently in device_del.

Signed-off-by: David Graham White <dgwhite11@gmail.com>
---
 drivers/base/core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 8856d74..d6494ee 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1292,9 +1292,7 @@ void device_del(struct device *dev)
 	 */
 	if (platform_notify_remove)
 		platform_notify_remove(dev);
-	kobject_uevent(&dev->kobj, KOBJ_REMOVE);
 	cleanup_device_parent(dev);
-	kobject_del(&dev->kobj);
 	put_device(parent);
 }
 
@@ -1849,10 +1847,8 @@ void device_destroy(struct class *class, dev_t devt)
 	struct device *dev;
 
 	dev = class_find_device(class, NULL, &devt, __match_devt);
-	if (dev) {
-		put_device(dev);
+	if (dev)
 		device_unregister(dev);
-	}
 }
 EXPORT_SYMBOL_GPL(device_destroy);
 
-- 
1.8.3.2

