Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbaLGPmj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 10:42:39 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:44167 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaLGPlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 10:41:50 -0500
From: robert.ward114@googlemail.com
To: arnd@arndb.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: Rob Ward <robert.ward114@googlemail.com>
Subject: [PATCH 1/3] drivers: char: mem: Make /dev/mem an optional device
Date: Sun,  7 Dec 2014 15:40:33 +0000
Message-Id: <1417966835-14012-2-git-send-email-robert.ward114@googlemail.com>
X-Mailer: git-send-email 2.2.0
In-Reply-To: <1417966835-14012-1-git-send-email-robert.ward114@googlemail.com>
References: <1417966835-14012-1-git-send-email-robert.ward114@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Ward <robert.ward114@googlemail.com>

Adds Kconfig option CONFIG_DEVMEM that allows the
/dev/mem device to be disabled.

Option defaults to /dev/mem enabled.

Signed-off-by: Rob Ward <robert.ward114@googlemail.com>
---
 drivers/char/Kconfig | 9 +++++++++
 drivers/char/mem.c   | 4 +++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index efefd12..a4af822 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -6,6 +6,15 @@ menu "Character devices"
 
 source "drivers/tty/Kconfig"
 
+config DEVMEM
+	bool "/dev/mem virtual device support"
+	default y
+	help
+	  Say Y here if you want to support the /dev/mem device.
+	  The /dev/mem device is used to access areas of physical
+	  memory.
+	  When in doubt, say "Y".
+
 config DEVKMEM
 	bool "/dev/kmem virtual device support"
 	default y
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 524b707..b2ca476 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -712,7 +712,7 @@ static int open_port(struct inode *inode, struct file *filp)
 #define open_mem	open_port
 #define open_kmem	open_mem
 
-static const struct file_operations mem_fops = {
+static const struct file_operations __maybe_unused mem_fops = {
 	.llseek		= memory_lseek,
 	.read		= read_mem,
 	.write		= write_mem,
@@ -782,7 +782,9 @@ static const struct memdev {
 	const struct file_operations *fops;
 	struct backing_dev_info *dev_info;
 } devlist[] = {
+#ifdef CONFIG_DEVMEM
 	 [1] = { "mem", 0, &mem_fops, &directly_mappable_cdev_bdi },
+#endif
 #ifdef CONFIG_DEVKMEM
 	 [2] = { "kmem", 0, &kmem_fops, &directly_mappable_cdev_bdi },
 #endif
-- 
2.0.2

