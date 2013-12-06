Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162174Ab3LFNlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:41:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44236 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161599Ab3LFNCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Stone <daniels@collabora.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 144/272] Input: evdev - fall back to vmalloc for client event buffer
Date: Fri,  6 Dec 2013 12:57:13 +0000
Message-Id: <1386334761-25517-145-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/input/evdev.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index d2b34fb..9bb8075 100644
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
@@ -365,7 +367,11 @@ static int evdev_release(struct inode *inode, struct file *file)
 	mutex_unlock(&evdev->mutex);
 
 	evdev_detach_client(evdev, client);
-	kfree(client);
+
+	if (is_vmalloc_addr(client))
+		vfree(client);
+	else
+		kfree(client);
 
 	evdev_close_device(evdev);
 
@@ -385,12 +391,14 @@ static int evdev_open(struct inode *inode, struct file *file)
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
 
-- 
1.8.3.2

