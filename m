Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaENVf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:35:27 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:42351 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbaENVfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:35:23 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [RFC PATCH 09/11] misc: Make loop-control available to all user namespaces
Date: Wed, 14 May 2014 16:34:57 -0500
Message-Id: <1400103299-144589-10-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a ns_global field to struct miscdevice to allow indicating
that the created struct device should be global to all user
namespaces, and set this flag for loop-control.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/block/loop.c       |  1 +
 drivers/char/misc.c        | 11 +++++++++--
 include/linux/miscdevice.h |  1 +
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index f70a230a2945..f0e41a372c24 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1813,6 +1813,7 @@ static struct miscdevice loop_misc = {
 	.minor		= LOOP_CTRL_MINOR,
 	.name		= "loop-control",
 	.fops		= &loop_ctl_fops,
+	.ns_global	= true,
 };
 
 MODULE_ALIAS_MISCDEV(LOOP_CTRL_MINOR);
diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index ffa97d261cf3..5940ebd98023 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -205,8 +205,15 @@ int misc_register(struct miscdevice * misc)
 
 	dev = MKDEV(MISC_MAJOR, misc->minor);
 
-	misc->this_device = device_create(misc_class, misc->parent, dev,
-					  misc, "%s", misc->name);
+	if (misc->ns_global)
+		misc->this_device = device_create_global(misc_class,
+							 misc->parent, dev,
+							 misc, "%s",
+							 misc->name);
+	else
+		misc->this_device = device_create(misc_class, misc->parent, dev,
+						  misc, "%s", misc->name);
+
 	if (IS_ERR(misc->this_device)) {
 		int i = DYNAMIC_MINORS - misc->minor - 1;
 		if (i < DYNAMIC_MINORS && i >= 0)
diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index 51e26f3cd3b3..a85782339fe2 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -62,6 +62,7 @@ struct miscdevice  {
 	struct device *this_device;
 	const char *nodename;
 	umode_t mode;
+	bool ns_global;
 };
 
 extern int misc_register(struct miscdevice * misc);
-- 
1.9.1

