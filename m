Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab3IXVjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 17:39:22 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:34693 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab3IXVjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 17:39:20 -0400
From: Benson Leung <bleung@chromium.org>
To: gregkh@linuxfoundation.org, ming.lei@canonical.com,
        linux-kernel@vger.kernel.org
Cc: bleung@chromium.org, olofj@chromium.org, stable@vger.kernel.org
Subject: [PATCH] driver core : Fix use after free of dev->parent in device_shutdown
Date: Tue, 24 Sep 2013 14:39:08 -0700
Message-Id: <1380058748-9347-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The put_device(dev) at the bottom of the loop of device_shutdown
may result in the dev being cleaned up. In device_create_release,
the dev is kfreed.

However, device_shutdown attempts to use the dev pointer again after
put_device by referring to dev->parent.

Copy the parent pointer instead to avoid this condition.

This bug was found on Chromium OS's chromeos-3.8, which is based on v3.8.11.
See bug report : https://code.google.com/p/chromium/issues/detail?id=297842
This can easily be reproduced when shutting down with
hidraw devices that report battery condition.
Two examples are the HP Bluetooth Mouse X4000b and the Apple Magic Mouse.
For example, with the magic mouse :
The dev in question is "hidraw0"
dev->parent is "magicmouse"

In the course of the shutdown for this device, the input event cleanup calls
a put on hidraw0, decrementing its reference count.
When we finally get to put_device(dev) in device_shutdown, kobject_cleanup
is called and device_create_release does kfree(dev).
dev->parent is no longer valid, and we may crash in
put_device(dev->parent).

This change should be applied on any kernel with this change :
d1c6c030fcec6f860d9bb6c632a3ebe62e28440b

Cc: stable@vger.kernel.org
Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/base/core.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index c7cfadc..34bd546 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2026,6 +2026,8 @@ void device_shutdown(void)
 	 * devices offline, even as the system is shutting down.
 	 */
 	while (!list_empty(&devices_kset->list)) {
+		struct device *parent;
+
 		dev = list_entry(devices_kset->list.prev, struct device,
 				kobj.entry);
 
@@ -2034,7 +2036,8 @@ void device_shutdown(void)
 		 * prevent it from being freed because parent's
 		 * lock is to be held
 		 */
-		get_device(dev->parent);
+		parent = dev->parent;
+		get_device(parent);
 		get_device(dev);
 		/*
 		 * Make sure the device is off the kset list, in the
@@ -2044,8 +2047,8 @@ void device_shutdown(void)
 		spin_unlock(&devices_kset->list_lock);
 
 		/* hold lock to avoid race with probe/release */
-		if (dev->parent)
-			device_lock(dev->parent);
+		if (parent)
+			device_lock(parent);
 		device_lock(dev);
 
 		/* Don't allow any more runtime suspends */
@@ -2063,11 +2066,11 @@ void device_shutdown(void)
 		}
 
 		device_unlock(dev);
-		if (dev->parent)
-			device_unlock(dev->parent);
+		if (parent)
+			device_unlock(parent);
 
 		put_device(dev);
-		put_device(dev->parent);
+		put_device(parent);
 
 		spin_lock(&devices_kset->list_lock);
 	}
-- 
1.8.4

