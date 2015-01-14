Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbbANSL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:11:28 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33458 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbbANSL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:11:27 -0500
From: ashishsangwan2@gmail.com
X-Google-Original-From: a.sangwan@samsung.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ashish Sangwan <a.sangwan@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH] driver core: access dev->driver under dev->mutex in dev_uevent
Date: Wed, 14 Jan 2015 23:40:54 +0530
Message-Id: <1421259054-2574-1-git-send-email-a.sangwan@samsung.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ashish Sangwan <a.sangwan@samsung.com>

We have hit a race condition while parallely accessing device's uevent
and rmmoding device's driver. In dev_uevent() first dev->driver is checked if
present which becomes true but before calling add_uevent_var 
dev->driver is set to NULL and driver is freed in __device_release_driver().
This results in either NULL pointer derefrence or invalid virtual address
access. Fix this race by accessing dev->driver under dev->mutex.

Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 drivers/base/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 97e2baf..f8e854a 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -326,8 +326,15 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
 	if (dev->type && dev->type->name)
 		add_uevent_var(env, "DEVTYPE=%s", dev->type->name);
 
+	/*
+	 * dev->driver is set NULL under dev->mutex so it should be checked
+	 * after acquiring dev->mutex. This prevents a race between 
+	 * __device_release_driver and dev_uevent.
+	 */
+	device_lock(dev);
 	if (dev->driver)
 		add_uevent_var(env, "DRIVER=%s", dev->driver->name);
+	device_unlock(dev);
 
 	/* Add common DT information about the device */
 	of_device_uevent(dev, env);
-- 
1.7.11.4

