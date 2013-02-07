Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab3BGAAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 19:00:55 -0500
Received: from mail.ispras.ru ([83.149.199.43]:39858 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757988Ab3BGAAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 19:00:51 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH 1/2] pcmcia: synclink_cs: fix error handling in mgslpc_probe()
Date: Thu,  7 Feb 2013 01:00:34 +0100
Message-Id: <1360195235-28949-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mgslpc_probe() ignores errors in mgslpc_add_device() and
does not release all resource if mgslpc_config() failed.

The patch adds returned code to mgslpc_add_device()
and fixes the both issues.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/char/pcmcia/synclink_cs.c |   51 +++++++++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 10 deletions(-)

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index b66eaa0..56e4e94 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -397,7 +397,7 @@ static int adapter_test(MGSLPC_INFO *info);
 
 static int claim_resources(MGSLPC_INFO *info);
 static void release_resources(MGSLPC_INFO *info);
-static void mgslpc_add_device(MGSLPC_INFO *info);
+static int mgslpc_add_device(MGSLPC_INFO *info);
 static void mgslpc_remove_device(MGSLPC_INFO *info);
 
 static bool rx_get_frame(MGSLPC_INFO *info, struct tty_struct *tty);
@@ -549,14 +549,21 @@ static int mgslpc_probe(struct pcmcia_device *link)
     /* Initialize the struct pcmcia_device structure */
 
     ret = mgslpc_config(link);
-    if (ret) {
-	    tty_port_destroy(&info->port);
-	    return ret;
-    }
+    if (ret != 0)
+	    goto failed;
 
-    mgslpc_add_device(info);
+    ret = mgslpc_add_device(info);
+    if (ret != 0)
+	    goto failed_release;
 
     return 0;
+
+failed_release:
+    mgslpc_release((u_long)link);
+failed:
+    tty_port_destroy(&info->port);
+    kfree(info);
+    return ret;
 }
 
 /* Card has been inserted.
@@ -2706,8 +2713,12 @@ static void release_resources(MGSLPC_INFO *info)
  *
  * Arguments:		info	pointer to device instance data
  */
-static void mgslpc_add_device(MGSLPC_INFO *info)
+static int mgslpc_add_device(MGSLPC_INFO *info)
 {
+	MGSLPC_INFO *current_dev = NULL;
+	struct device *tty_dev;
+	int ret;
+
 	info->next_device = NULL;
 	info->line = mgslpc_device_count;
 	sprintf(info->device_name,"ttySLP%d",info->line);
@@ -2722,7 +2733,7 @@ static void mgslpc_add_device(MGSLPC_INFO *info)
 	if (!mgslpc_device_list)
 		mgslpc_device_list = info;
 	else {
-		MGSLPC_INFO *current_dev = mgslpc_device_list;
+		current_dev = mgslpc_device_list;
 		while( current_dev->next_device )
 			current_dev = current_dev->next_device;
 		current_dev->next_device = info;
@@ -2737,10 +2748,30 @@ static void mgslpc_add_device(MGSLPC_INFO *info)
 		info->device_name, info->io_base, info->irq_level);
 
 #if SYNCLINK_GENERIC_HDLC
-	hdlcdev_init(info);
+	ret = hdlcdev_init(info);
+	if (ret != 0)
+		goto failed;
 #endif
-	tty_port_register_device(&info->port, serial_driver, info->line,
+
+	tty_dev = tty_port_register_device(&info->port, serial_driver, info->line,
 			&info->p_dev->dev);
+	if (IS_ERR(tty_dev)) {
+		ret = PTR_ERR(tty_dev);
+#if SYNCLINK_GENERIC_HDLC
+		hdlcdev_exit(info);
+#endif
+		goto failed;
+	}
+
+	return 0;
+
+failed:
+	if (current_dev)
+		current_dev->next_device = NULL;
+	else
+		mgslpc_device_list = NULL;
+	mgslpc_device_count--;
+	return ret;
 }
 
 static void mgslpc_remove_device(MGSLPC_INFO *remove_info)
-- 
1.7.9.5

