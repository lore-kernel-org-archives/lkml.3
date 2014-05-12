Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123AbaELQoC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:44:02 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.101]:40858 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758733AbaELQnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:43:55 -0400
X-Env-Sender: Benjamin.Romer@unisys.com
X-Msg-Ref: server-5.tower-200.messagelabs.com!1399913022!8210220!44
X-Originating-IP: [192.61.61.105]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: Benjamin Romer <benjamin.romer@unisys.com>
To: <gregkh@linuxfoundation.org>, <sparmaintainer@unisys.com>,
        <linux-kernel@vger.kernel.org>, <jkc@redhat.com>,
        <devel@driverdev.osuosl.org>
CC: Benjamin Romer <benjamin.romer@unisys.com>
Subject: [PATCH 4/7] staging: unisys: move uislib/smart_wakeup proc entry to debugfs
Date: Mon, 12 May 2014 12:38:32 -0400
Message-ID: <1399912715-16142-5-git-send-email-benjamin.romer@unisys.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399912715-16142-1-git-send-email-benjamin.romer@unisys.com>
References: <1399912715-16142-1-git-send-email-benjamin.romer@unisys.com>
X-OriginalArrivalTime: 12 May 2014 16:43:49.0733 (UTC) FILETIME=[59C7E950:01CF6E01]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert /proc/uislib/smart_wakeup to an equivalent entry in debugfs.

Signed-off-by: Benjamin Romer <benjamin.romer@unisys.com>
---
 drivers/staging/unisys/uislib/uislib.c | 59 ++++++----------------------------
 1 file changed, 9 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/unisys/uislib/uislib.c b/drivers/staging/unisys/uislib/uislib.c
index 0f966b7..a77936a 100644
--- a/drivers/staging/unisys/uislib/uislib.c
+++ b/drivers/staging/unisys/uislib/uislib.c
@@ -92,12 +92,11 @@ static int Go_Polling_Device_Channels;
 static struct proc_dir_entry *uislib_proc_dir;
 static struct proc_dir_entry *uislib_proc_vbus_dir;
 static struct proc_dir_entry *info_proc_entry;
-static struct proc_dir_entry *smart_wakeup_proc_entry;
 
 #define DIR_PROC_ENTRY "uislib"
 #define DIR_VBUS_PROC_ENTRY "vbus"
 #define INFO_PROC_ENTRY_FN "info"
-#define SMART_WAKEUP_PROC_ENTRY_FN "smart_wakeup"
+
 #define CALLHOME_PROC_ENTRY_FN "callhome"
 #define CALLHOME_THROTTLED_PROC_ENTRY_FN "callhome_throttled"
 
@@ -110,6 +109,9 @@ static struct dentry *platformnumber_debugfs_read;
 #define CYCLES_BEFORE_WAIT_DEBUGFS_ENTRY_FN "cycles_before_wait"
 static struct dentry *cycles_before_wait_debugfs_read;
 
+#define SMART_WAKEUP_DEBUGFS_ENTRY_FN "smart_wakeup"
+static struct dentry *smart_wakeup_debugfs_entry;
+
 static unsigned long long cycles_before_wait, wait_cycles;
 
 /*****************************************************/
@@ -143,14 +145,6 @@ static const struct file_operations proc_info_fops = {
 	.read = info_proc_read,
 };
 
-static ssize_t smart_wakeup_proc_write(struct file *file,
-				       const char __user *buffer,
-				       size_t count, loff_t *ppos);
-static const struct file_operations proc_smart_wakeup_fops = {
-	.read = uislib_proc_read_writeonly,
-	.write = smart_wakeup_proc_write,
-};
-
 static void
 init_msg_header(CONTROLVM_MESSAGE *msg, U32 id, uint rsp, uint svr)
 {
@@ -1423,39 +1417,6 @@ uislib_proc_read_writeonly(struct file *file, char __user *buffer,
 	return 0;
 }
 
-static ssize_t
-smart_wakeup_proc_write(struct file *file, const char __user *buffer,
-			size_t count, loff_t *ppos)
-{
-	char buf[16];
-	int new_value;
-
-#define SMART_WAKEUP_USE_ERROR  { \
-	LOGERR("Incorrect smart_wakeup Input 0 disables smart_wakeup, and 1 enables smart_wakeup.\n"); \
-	pr_info("echo 0 > smart_wakeup\n"); \
-	pr_info("echo 1 > smart_wakeup\n"); \
-	return -EFAULT; \
-	}
-
-	if (count >= ARRAY_SIZE(buf))
-		return -EINVAL;
-
-	if (count == 0)
-		SMART_WAKEUP_USE_ERROR;
-
-	if (copy_from_user(buf, buffer, count)) {
-		LOGERR("copy_from_user failed.\n");
-		return -EFAULT;
-	}
-	buf[count - 1] = '\0';	/* Replace the LF at the end of the
-				 * input with a NULL */
-	/* Pull out the smart_wakeup must be decimal integer */
-	if (sscanf(buf, "%d", &new_value) != 1)
-		SMART_WAKEUP_USE_ERROR;
-	en_smart_wakeup = new_value;
-	return count;
-}
-
 static struct device_info *
 find_dev(U32 busNo, U32 devNo)
 {
@@ -1762,12 +1723,11 @@ uislib_mod_init(void)
 		cycles_before_wait_debugfs_read = debugfs_create_u64(
 			CYCLES_BEFORE_WAIT_DEBUGFS_ENTRY_FN, 0666, dir_debugfs,
 			&cycles_before_wait);
-	}
 
-	smart_wakeup_proc_entry =
-	    proc_create(SMART_WAKEUP_PROC_ENTRY_FN, 0, uislib_proc_dir,
-			&proc_smart_wakeup_fops);
-	SET_PROC_OWNER(smart_wakeup_proc_entry, THIS_MODULE);
+		smart_wakeup_debugfs_entry = debugfs_create_bool(
+			SMART_WAKEUP_DEBUGFS_ENTRY_FN, 0666, dir_debugfs,
+			&en_smart_wakeup);
+	}
 
 	POSTCODE_LINUX_3(DRIVER_EXIT_PC, 0, POSTCODE_SEVERITY_INFO);
 	return 0;
@@ -1776,8 +1736,6 @@ uislib_mod_init(void)
 static void __exit
 uislib_mod_exit(void)
 {
-	if (smart_wakeup_proc_entry)
-		remove_proc_entry(SMART_WAKEUP_PROC_ENTRY_FN, uislib_proc_dir);
 	if (info_proc_entry)
 		remove_proc_entry(INFO_PROC_ENTRY_FN, uislib_proc_dir);
 	if (uislib_proc_vbus_dir)
@@ -1790,6 +1748,7 @@ uislib_mod_exit(void)
 		ProcReadBuffer = NULL;
 	}
 
+	debugfs_remove(smart_wakeup_debugfs_entry);
 	debugfs_remove(cycles_before_wait_debugfs_read);
 	debugfs_remove(platformnumber_debugfs_read);
 	debugfs_remove(dir_debugfs);
-- 
1.9.1

