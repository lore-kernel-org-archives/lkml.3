Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab3LBTb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:31:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab3LBTTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:19:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3.12 197/212] media: v4l2-async: Dont use dynamic static allocation
Date: Mon,  2 Dec 2013 11:16:28 -0800
Message-Id: <20131202191310.962280316@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit 24e9a47e14f0a97ee97abc3dd86b2ef254448a17 upstream.

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:
	drivers/media/v4l2-core/v4l2-async.c:238:1: warning: 'v4l2_async_notifier_unregister' uses dynamic stack allocation [enabled by default]
Instead, let's enforce a limit for the buffer.
In this specific case, there's a hard limit imposed by V4L2_MAX_SUBDEVS,
with is currently 128. That means that the buffer size can be up to
128x8 = 1024 bytes (on a 64bits kernel), with is too big for stack.
Worse than that, someone could increase it and cause real troubles.
So, let's use dynamically allocated data, instead.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/v4l2-core/v4l2-async.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -189,30 +189,53 @@ void v4l2_async_notifier_unregister(stru
 	struct v4l2_subdev *sd, *tmp;
 	unsigned int notif_n_subdev = notifier->num_subdevs;
 	unsigned int n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
-	struct device *dev[n_subdev];
+	struct device **dev;
 	int i = 0;
 
 	if (!notifier->v4l2_dev)
 		return;
 
+	dev = kmalloc(n_subdev * sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
+		dev_err(notifier->v4l2_dev->dev,
+			"Failed to allocate device cache!\n");
+	}
+
 	mutex_lock(&list_lock);
 
 	list_del(&notifier->list);
 
 	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
-		dev[i] = get_device(sd->dev);
+		struct device *d;
+
+		d = get_device(sd->dev);
 
 		v4l2_async_cleanup(sd);
 
 		/* If we handled USB devices, we'd have to lock the parent too */
-		device_release_driver(dev[i++]);
+		device_release_driver(d);
 
 		if (notifier->unbind)
 			notifier->unbind(notifier, sd, sd->asd);
+
+		/*
+		 * Store device at the device cache, in order to call
+		 * put_device() on the final step
+		 */
+		if (dev)
+			dev[i++] = d;
+		else
+			put_device(d);
 	}
 
 	mutex_unlock(&list_lock);
 
+	/*
+	 * Call device_attach() to reprobe devices
+	 *
+	 * NOTE: If dev allocation fails, i is 0, and the whole loop won't be
+	 * executed.
+	 */
 	while (i--) {
 		struct device *d = dev[i];
 
@@ -228,6 +251,7 @@ void v4l2_async_notifier_unregister(stru
 		}
 		put_device(d);
 	}
+	kfree(dev);
 
 	notifier->v4l2_dev = NULL;
 


