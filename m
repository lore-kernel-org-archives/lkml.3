Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024Ab3LBUnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:43:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab3LBTOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Stone <daniels@collabora.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.10 119/173] Input: evdev - fall back to vmalloc for client event buffer
Date: Mon,  2 Dec 2013 11:11:42 -0800
Message-Id: <20131202191157.373989087@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Stone <daniel@fooishbar.org>

commit 92eb77d0ffbaa71b501a0a8dabf09a351bf4267f upstream.

evdev always tries to allocate the event buffer for clients using
kzalloc rather than vmalloc, presumably to avoid mapping overhead where
possible.  However, drivers like bcm5974, which claims support for
reporting 16 fingers simultaneously, can have an extraordinarily large
buffer.  The resultant contiguous order-4 allocation attempt fails due
to fragmentation, and the device is thus unusable until reboot.

Try kzalloc if we can to avoid the mapping overhead, but if that fails,
fall back to vzalloc.

Signed-off-by: Daniel Stone <daniels@collabora.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/evdev.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -18,6 +18,8 @@
 #include <linux/poll.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/input/mt.h>
@@ -289,7 +291,11 @@ static int evdev_release(struct inode *i
 	mutex_unlock(&evdev->mutex);
 
 	evdev_detach_client(evdev, client);
-	kfree(client);
+
+	if (is_vmalloc_addr(client))
+		vfree(client);
+	else
+		kfree(client);
 
 	evdev_close_device(evdev);
 
@@ -309,12 +315,14 @@ static int evdev_open(struct inode *inod
 {
 	struct evdev *evdev = container_of(inode->i_cdev, struct evdev, cdev);
 	unsigned int bufsize = evdev_compute_buffer_size(evdev->handle.dev);
+	unsigned int size = sizeof(struct evdev_client) +
+					bufsize * sizeof(struct input_event);
 	struct evdev_client *client;
 	int error;
 
-	client = kzalloc(sizeof(struct evdev_client) +
-				bufsize * sizeof(struct input_event),
-			 GFP_KERNEL);
+	client = kzalloc(size, GFP_KERNEL | __GFP_NOWARN);
+	if (!client)
+		client = vzalloc(size);
 	if (!client)
 		return -ENOMEM;
 


