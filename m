Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaENVfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:35:23 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:59857 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbaENVfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:35:19 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [RFC PATCH 06/11] drivers/char/mem.c: Make null/zero/full/random/urandom available to user namespaces
Date: Wed, 14 May 2014 16:34:54 -0500
Message-Id: <1400103299-144589-7-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/char/mem.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 917403fe10da..edd71ebf5025 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -811,21 +811,22 @@ static const struct memdev {
 	umode_t mode;
 	const struct file_operations *fops;
 	struct backing_dev_info *dev_info;
+	bool global;
 } devlist[] = {
-	 [1] = { "mem", 0, &mem_fops, &directly_mappable_cdev_bdi },
+	 [1] = { "mem", 0, &mem_fops, &directly_mappable_cdev_bdi, false },
 #ifdef CONFIG_DEVKMEM
-	 [2] = { "kmem", 0, &kmem_fops, &directly_mappable_cdev_bdi },
+	 [2] = { "kmem", 0, &kmem_fops, &directly_mappable_cdev_bdi, false },
 #endif
-	 [3] = { "null", 0666, &null_fops, NULL },
+	 [3] = { "null", 0666, &null_fops, NULL, true },
 #ifdef CONFIG_DEVPORT
-	 [4] = { "port", 0, &port_fops, NULL },
+	 [4] = { "port", 0, &port_fops, NULL, false },
 #endif
-	 [5] = { "zero", 0666, &zero_fops, &zero_bdi },
-	 [7] = { "full", 0666, &full_fops, NULL },
-	 [8] = { "random", 0666, &random_fops, NULL },
-	 [9] = { "urandom", 0666, &urandom_fops, NULL },
+	 [5] = { "zero", 0666, &zero_fops, &zero_bdi, true },
+	 [7] = { "full", 0666, &full_fops, NULL, true },
+	 [8] = { "random", 0666, &random_fops, NULL, true },
+	 [9] = { "urandom", 0666, &urandom_fops, NULL, true },
 #ifdef CONFIG_PRINTK
-	[11] = { "kmsg", 0644, &kmsg_fops, NULL },
+	[11] = { "kmsg", 0644, &kmsg_fops, NULL, false },
 #endif
 };
 
@@ -897,8 +898,13 @@ static int __init chr_dev_init(void)
 		if ((minor == DEVPORT_MINOR) && !arch_has_dev_port())
 			continue;
 
-		device_create(mem_class, NULL, MKDEV(MEM_MAJOR, minor),
-			      NULL, devlist[minor].name);
+		if (devlist[minor].global)
+			device_create_global(mem_class, NULL,
+					     MKDEV(MEM_MAJOR, minor), NULL,
+					     devlist[minor].name);
+		else
+			device_create(mem_class, NULL, MKDEV(MEM_MAJOR, minor),
+				      NULL, devlist[minor].name);
 	}
 
 	return tty_init();
-- 
1.9.1

