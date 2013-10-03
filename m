Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab3JCEPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:15:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560Ab3JCEPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:15:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benson Leung <bleung@chromium.org>, Ming Lei <ming.lei@canonical.com>
Subject: [ 37/52] driver core : Fix use after free of dev->parent in device_shutdown
Date: Wed,  2 Oct 2013 21:05:55 -0700
Message-Id: <20131003040524.702739188@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040522.190209641@linuxfoundation.org>
References: <20131003040522.190209641@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/base/core.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1839,7 +1839,7 @@ EXPORT_SYMBOL_GPL(device_move);
  */
 void device_shutdown(void)
 {
-	struct device *dev;
+	struct device *dev, *parent;
 
 	spin_lock(&devices_kset->list_lock);
 	/*
@@ -1856,7 +1856,7 @@ void device_shutdown(void)
 		 * prevent it from being freed because parent's
 		 * lock is to be held
 		 */
-		get_device(dev->parent);
+		parent = get_device(dev->parent);
 		get_device(dev);
 		/*
 		 * Make sure the device is off the kset list, in the
@@ -1866,8 +1866,8 @@ void device_shutdown(void)
 		spin_unlock(&devices_kset->list_lock);
 
 		/* hold lock to avoid race with probe/release */
-		if (dev->parent)
-			device_lock(dev->parent);
+		if (parent)
+			device_lock(parent);
 		device_lock(dev);
 
 		/* Don't allow any more runtime suspends */
@@ -1885,11 +1885,11 @@ void device_shutdown(void)
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


