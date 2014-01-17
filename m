Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaAQQiM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:38:12 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:46204 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaAQQiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:38:10 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, hverkuil@xs4all.nl
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [media] hdpvr: Fix memory leak in debug
Date: Sat, 18 Jan 2014 01:38:00 +0900
Message-Id: <1389976680-21269-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.5.2.309.ga25014b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cppcheck reported memory leak in device_authorizatio()
within hdpvr-core.c.
When the debug option is specified and the code jump to
"unlock:" label, print_buf was not freed.
Confirm the module succesfully compiled without error.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/media/usb/hdpvr/hdpvr-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index 2f0c89c..c563896 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -198,7 +198,6 @@ static int device_authorization(struct hdpvr_device *dev)
 	hex_dump_to_buffer(response, 8, 16, 1, print_buf, 5*buf_size+1, 0);
 	v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev, " response: %s\n",
 		 print_buf);
-	kfree(print_buf);
 #endif
 
 	msleep(100);
@@ -214,6 +213,9 @@ static int device_authorization(struct hdpvr_device *dev)
 	retval = ret != 8;
 unlock:
 	mutex_unlock(&dev->usbc_mutex);
+#ifdef HDPVR_DEBUG
+	kfree(print_buf);
+#endif
 	return retval;
 }
 
-- 
1.8.5.2.309.ga25014b

