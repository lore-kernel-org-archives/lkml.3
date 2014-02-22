Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbaBVAul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 19:50:41 -0500
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:53082 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754517AbaBVAuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 19:50:39 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [RFC] [PATCH 1/6] media: em28xx - add suspend/resume to em28xx_ops
Date: Fri, 21 Feb 2014 17:50:13 -0700
Message-Id: <b948a58520578080c7252e8cd9780356589d2581.1393027856.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1393027856.git.shuah.kh@samsung.com>
References: <cover.1393027856.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1393027856.git.shuah.kh@samsung.com>
References: <cover.1393027856.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

em28xx usb driver will have to suspend and resume its extensions. Adding
suspend and resume to em28xx_ops gives extensions the ability to install
suspend and resume that can be invoked from em28xx_usb driver suspend()
and resume() interfaces.

Approach:
Add power management support to em28xx usb driver. This driver works in
conjunction with extensions for each of the functions on the USB device
for video/audio/dvb/remote functionality that is present on media USB
devices it supports. During suspend and resume each of these extensions
will have to do their part in suspending the components they control.

Adding suspend and resume hooks to the existing struct em28xx_ops will
enable the extensions the ability to implement suspend and resume hooks
to be called from em28xx driver. The overall approach is as follows:

-- add suspend and resume hooks to em28xx_ops
-- add suspend and resume routines to em28xx-core to invoke suspend
   and resume hooks for all registered extensions.
-- change em28xx dvb, audio, input, and video extensions to implement
   em28xx_ops: suspend and resume hooks. These hooks do what is necessary
   to suspend and resume the devices they control.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-core.c | 28 ++++++++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx.h      |  4 ++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 898fb9b..6de41c6 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -1106,3 +1106,31 @@ void em28xx_close_extension(struct em28xx *dev)
 	list_del(&dev->devlist);
 	mutex_unlock(&em28xx_devlist_mutex);
 }
+
+int em28xx_suspend_extension(struct em28xx *dev)
+{
+	const struct em28xx_ops *ops = NULL;
+
+	em28xx_info("Suspending extensions");
+	mutex_lock(&em28xx_devlist_mutex);
+	list_for_each_entry(ops, &em28xx_extension_devlist, next) {
+		if (ops->suspend)
+			ops->suspend(dev);
+	}
+	mutex_unlock(&em28xx_devlist_mutex);
+	return 0;
+}
+
+int em28xx_resume_extension(struct em28xx *dev)
+{
+	const struct em28xx_ops *ops = NULL;
+
+	em28xx_info("Resuming extensions");
+	mutex_lock(&em28xx_devlist_mutex);
+	list_for_each_entry(ops, &em28xx_extension_devlist, next) {
+		if (ops->resume)
+			ops->resume(dev);
+	}
+	mutex_unlock(&em28xx_devlist_mutex);
+	return 0;
+}
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 32d8a4b..9b02f15 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -713,6 +713,8 @@ struct em28xx_ops {
 	int id;
 	int (*init)(struct em28xx *);
 	int (*fini)(struct em28xx *);
+	int (*suspend)(struct em28xx *);
+	int (*resume)(struct em28xx *);
 };
 
 /* Provided by em28xx-i2c.c */
@@ -758,6 +760,8 @@ int em28xx_register_extension(struct em28xx_ops *dev);
 void em28xx_unregister_extension(struct em28xx_ops *dev);
 void em28xx_init_extension(struct em28xx *dev);
 void em28xx_close_extension(struct em28xx *dev);
+int em28xx_suspend_extension(struct em28xx *dev);
+int em28xx_resume_extension(struct em28xx *dev);
 
 /* Provided by em28xx-cards.c */
 extern struct em28xx_board em28xx_boards[];
-- 
1.8.3.2

