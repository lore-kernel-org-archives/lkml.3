Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbaELQpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:45:49 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.202]:46594 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752665AbaELQnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:43:53 -0400
X-Env-Sender: Benjamin.Romer@unisys.com
X-Msg-Ref: server-2.tower-45.messagelabs.com!1399913015!30856954!58
X-Originating-IP: [192.61.61.105]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: Benjamin Romer <benjamin.romer@unisys.com>
To: <gregkh@linuxfoundation.org>, <sparmaintainer@unisys.com>,
        <linux-kernel@vger.kernel.org>, <jkc@redhat.com>,
        <devel@driverdev.osuosl.org>
CC: Benjamin Romer <benjamin.romer@unisys.com>
Subject: [PATCH 2/7] staging: unisys: move uislib/platform proc entry to debugfs
Date: Mon, 12 May 2014 12:38:30 -0400
Message-ID: <1399912715-16142-3-git-send-email-benjamin.romer@unisys.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399912715-16142-1-git-send-email-benjamin.romer@unisys.com>
References: <1399912715-16142-1-git-send-email-benjamin.romer@unisys.com>
X-OriginalArrivalTime: 12 May 2014 16:43:49.0514 (UTC) FILETIME=[59A67EA0:01CF6E01]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert /proc/uislib/platform to an equivalent entry in debugfs.

Signed-off-by: Benjamin Romer <benjamin.romer@unisys.com>
---
 drivers/staging/unisys/uislib/uislib.c | 62 ++++++++++------------------------
 1 file changed, 17 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/unisys/uislib/uislib.c b/drivers/staging/unisys/uislib/uislib.c
index fdc23676..b71f387 100644
--- a/drivers/staging/unisys/uislib/uislib.c
+++ b/drivers/staging/unisys/uislib/uislib.c
@@ -23,6 +23,7 @@
 #include <config/modversions.h>
 #endif
 #include <linux/module.h>
+#include <linux/debugfs.h>
 
 #include "commontypes.h"
 
@@ -91,19 +92,23 @@ static int Go_Polling_Device_Channels;
 static struct proc_dir_entry *uislib_proc_dir;
 static struct proc_dir_entry *uislib_proc_vbus_dir;
 static struct proc_dir_entry *info_proc_entry;
-static struct proc_dir_entry *platformnumber_proc_entry;
 static struct proc_dir_entry *cycles_before_wait_proc_entry;
 static struct proc_dir_entry *smart_wakeup_proc_entry;
 
 #define DIR_PROC_ENTRY "uislib"
 #define DIR_VBUS_PROC_ENTRY "vbus"
 #define INFO_PROC_ENTRY_FN "info"
-#define PLATFORMNUMBER_PROC_ENTRY_FN "platform"
 #define CYCLES_BEFORE_WAIT_PROC_ENTRY_FN "cycles_before_wait"
 #define SMART_WAKEUP_PROC_ENTRY_FN "smart_wakeup"
 #define CALLHOME_PROC_ENTRY_FN "callhome"
 #define CALLHOME_THROTTLED_PROC_ENTRY_FN "callhome_throttled"
 
+#define DIR_DEBUGFS_ENTRY "uislib"
+static struct dentry *dir_debugfs;
+
+#define PLATFORMNUMBER_DEBUGFS_ENTRY_FN "platform"
+static struct dentry *platformnumber_debugfs_read;
+
 static unsigned long long cycles_before_wait, wait_cycles;
 
 /*****************************************************/
@@ -137,12 +142,6 @@ static const struct file_operations proc_info_fops = {
 	.read = info_proc_read,
 };
 
-static ssize_t platformnumber_proc_read(struct file *file, char __user *buf,
-					size_t len, loff_t *offset);
-static const struct file_operations proc_platformnumber_fops = {
-	.read = platformnumber_proc_read,
-};
-
 static ssize_t cycles_before_wait_proc_write(struct file *file,
 					     const char __user *buffer,
 					     size_t count, loff_t *ppos);
@@ -1386,36 +1385,6 @@ info_proc_read(struct file *file, char __user *buf, size_t len, loff_t *offset)
 				       ProcReadBuffer, totalBytes);
 }
 
-static ssize_t
-platformnumber_proc_read(struct file *file, char __user *buf,
-			 size_t len, loff_t *offset)
-{
-	int length = 0;
-	char *vbuf;
-	loff_t pos = *offset;
-
-	if (pos < 0)
-		return -EINVAL;
-
-	if (pos > 0 || !len)
-		return 0;
-
-	vbuf = kzalloc(len, GFP_KERNEL);
-	if (!vbuf)
-		return -ENOMEM;
-
-	length = sprintf(vbuf, "%d\n", PlatformNumber);
-
-	if (copy_to_user(buf, vbuf, length)) {
-		kfree(vbuf);
-		return -EFAULT;
-	}
-
-	kfree(vbuf);
-	*offset += length;
-	return length;
-}
-
 /* proc/uislib/vbus/<x>/info */
 static int
 proc_info_vbus_show(struct seq_file *m, void *v)
@@ -1821,10 +1790,13 @@ uislib_mod_init(void)
 				      &proc_info_fops);
 	SET_PROC_OWNER(info_proc_entry, THIS_MODULE);
 
-	platformnumber_proc_entry =
-	    proc_create(PLATFORMNUMBER_PROC_ENTRY_FN, 0, uislib_proc_dir,
-			&proc_platformnumber_fops);
-	SET_PROC_OWNER(platformnumberinfo_proc_entry, THIS_MODULE);
+	dir_debugfs = debugfs_create_dir(DIR_DEBUGFS_ENTRY, NULL);
+
+	if (dir_debugfs) {
+		platformnumber_debugfs_read = debugfs_create_u32(
+			PLATFORMNUMBER_DEBUGFS_ENTRY_FN, 0444, dir_debugfs,
+			&PlatformNumber);
+	}
 
 	cycles_before_wait_proc_entry =
 	    proc_create(CYCLES_BEFORE_WAIT_PROC_ENTRY_FN, 0, uislib_proc_dir,
@@ -1850,9 +1822,6 @@ uislib_mod_exit(void)
 		remove_proc_entry(SMART_WAKEUP_PROC_ENTRY_FN, uislib_proc_dir);
 	if (info_proc_entry)
 		remove_proc_entry(INFO_PROC_ENTRY_FN, uislib_proc_dir);
-	if (platformnumber_proc_entry)
-		remove_proc_entry(PLATFORMNUMBER_PROC_ENTRY_FN,
-				  uislib_proc_dir);
 	if (uislib_proc_vbus_dir)
 		remove_proc_entry(DIR_VBUS_PROC_ENTRY, uislib_proc_dir);
 	if (uislib_proc_dir)
@@ -1863,6 +1832,9 @@ uislib_mod_exit(void)
 		ProcReadBuffer = NULL;
 	}
 
+	debugfs_remove(platformnumber_debugfs_read);
+	debugfs_remove(dir_debugfs);
+
 	DBGINF("goodbye.\n");
 	return;
 }
-- 
1.9.1

