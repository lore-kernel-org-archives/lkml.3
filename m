Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab3JJPrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:47:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52794 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab3JJPrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:47:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benson Leung <bleung@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 074/104] driver core : Fix use after free of dev->parent in device_shutdown
Date: Thu, 10 Oct 2013 08:42:02 -0700
Message-Id: <1381419752-29733-75-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benson Leung <bleung@chromium.org>

commit f123db8e9d6c84c863cb3c44d17e61995dc984fb upstream.

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

Signed-off-by: Benson Leung <bleung@chromium.org>
Reviewed-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/base/core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index a235085..0ff9496 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1825,7 +1825,7 @@ EXPORT_SYMBOL_GPL(device_move);
  */
 void device_shutdown(void)
 {
-	struct device *dev;
+	struct device *dev, *parent;
 
 	spin_lock(&devices_kset->list_lock);
 	/*
@@ -1842,7 +1842,7 @@ void device_shutdown(void)
 		 * prevent it from being freed because parent's
 		 * lock is to be held
 		 */
-		get_device(dev->parent);
+		parent = get_device(dev->parent);
 		get_device(dev);
 		/*
 		 * Make sure the device is off the kset list, in the
@@ -1852,8 +1852,8 @@ void device_shutdown(void)
 		spin_unlock(&devices_kset->list_lock);
 
 		/* hold lock to avoid race with probe/release */
-		if (dev->parent)
-			device_lock(dev->parent);
+		if (parent)
+			device_lock(parent);
 		device_lock(dev);
 
 		/* Don't allow any more runtime suspends */
@@ -1871,11 +1871,11 @@ void device_shutdown(void)
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
1.8.1.2

