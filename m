Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3IIQe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:34:26 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:63529 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab3IIQeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:34:24 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-input@vger.kernel.org
Cc: Tom Gundersen <teg@jklm.no>, Kay Sievers <kay.sievers@vrfy.org>,
        Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH] HID: uhid: allocate static minor
Date: Mon,  9 Sep 2013 18:33:54 +0200
Message-Id: <1378744434-10883-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

udev has this nice feature of creating "dead" /dev/<node> device-nodes if
it finds a devnode:<node> modalias. Once the node is accessed, the kernel
automatically loads the module that provides the node. However, this
requires udev to know the major:minor code to use for the node. This
feature was introduced by:

  commit 578454ff7eab61d13a26b568f99a89a2c9edc881
  Author: Kay Sievers <kay.sievers@vrfy.org>
  Date:   Thu May 20 18:07:20 2010 +0200

      driver core: add devname module aliases to allow module on-demand auto-loading

However, uhid uses dynamic minor numbers so this doesn't actually work. We
need to load uhid to know which minor it's going to use.

Hence, allocate a static minor (just like uinput does) and we're good
to go.

Reported-by: Tom Gundersen <teg@jklm.no>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/hid/uhid.c         | 3 ++-
 include/linux/miscdevice.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index 5bf2fb7..93b00d7 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -615,7 +615,7 @@ static const struct file_operations uhid_fops = {
 
 static struct miscdevice uhid_misc = {
 	.fops		= &uhid_fops,
-	.minor		= MISC_DYNAMIC_MINOR,
+	.minor		= UHID_MINOR,
 	.name		= UHID_NAME,
 };
 
@@ -634,4 +634,5 @@ module_exit(uhid_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("David Herrmann <dh.herrmann@gmail.com>");
 MODULE_DESCRIPTION("User-space I/O driver support for HID subsystem");
+MODULE_ALIAS_MISCDEV(UHID_MINOR);
 MODULE_ALIAS("devname:" UHID_NAME);
diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index 09c2300..cb35835 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -45,6 +45,7 @@
 #define MAPPER_CTRL_MINOR	236
 #define LOOP_CTRL_MINOR		237
 #define VHOST_NET_MINOR		238
+#define UHID_MINOR		239
 #define MISC_DYNAMIC_MINOR	255
 
 struct device;
-- 
1.8.4

