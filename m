Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbaELQn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:43:57 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.113]:37041 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758873AbaELQnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:43:55 -0400
X-Env-Sender: Benjamin.Romer@unisys.com
X-Msg-Ref: server-5.tower-200.messagelabs.com!1399913022!8210220!47
X-Originating-IP: [192.61.61.105]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: Benjamin Romer <benjamin.romer@unisys.com>
To: <gregkh@linuxfoundation.org>, <sparmaintainer@unisys.com>,
        <linux-kernel@vger.kernel.org>, <jkc@redhat.com>,
        <devel@driverdev.osuosl.org>
CC: Benjamin Romer <benjamin.romer@unisys.com>
Subject: [PATCH 6/7] staging: unisys: move uislib/info proc entry to debugfs
Date: Mon, 12 May 2014 12:38:34 -0400
Message-ID: <1399912715-16142-7-git-send-email-benjamin.romer@unisys.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399912715-16142-1-git-send-email-benjamin.romer@unisys.com>
References: <1399912715-16142-1-git-send-email-benjamin.romer@unisys.com>
X-OriginalArrivalTime: 12 May 2014 16:43:49.0967 (UTC) FILETIME=[59EB9DF0:01CF6E01]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert /proc/uislib/info to an equivalent entry under debugfs.

Signed-off-by: Benjamin Romer <benjamin.romer@unisys.com>
---
 drivers/staging/unisys/uislib/uislib.c | 40 ++++++++++++++--------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/unisys/uislib/uislib.c b/drivers/staging/unisys/uislib/uislib.c
index 3a54450..5980040 100644
--- a/drivers/staging/unisys/uislib/uislib.c
+++ b/drivers/staging/unisys/uislib/uislib.c
@@ -91,11 +91,9 @@ static int Go_Polling_Device_Channels;
 
 static struct proc_dir_entry *uislib_proc_dir;
 static struct proc_dir_entry *uislib_proc_vbus_dir;
-static struct proc_dir_entry *info_proc_entry;
 
 #define DIR_PROC_ENTRY "uislib"
 #define DIR_VBUS_PROC_ENTRY "vbus"
-#define INFO_PROC_ENTRY_FN "info"
 
 #define CALLHOME_PROC_ENTRY_FN "callhome"
 #define CALLHOME_THROTTLED_PROC_ENTRY_FN "callhome_throttled"
@@ -112,6 +110,9 @@ static struct dentry *cycles_before_wait_debugfs_read;
 #define SMART_WAKEUP_DEBUGFS_ENTRY_FN "smart_wakeup"
 static struct dentry *smart_wakeup_debugfs_entry;
 
+#define INFO_DEBUGFS_ENTRY_FN "info"
+static struct dentry *info_debugfs_entry;
+
 static unsigned long long cycles_before_wait, wait_cycles;
 
 /*****************************************************/
@@ -134,10 +135,10 @@ static const struct file_operations proc_info_vbus_fops = {
 	.release = single_release,
 };
 
-static ssize_t info_proc_read(struct file *file, char __user *buf,
+static ssize_t info_debugfs_read(struct file *file, char __user *buf,
 			      size_t len, loff_t *offset);
-static const struct file_operations proc_info_fops = {
-	.read = info_proc_read,
+static const struct file_operations debugfs_info_fops = {
+	.read = info_debugfs_read,
 };
 
 static void
@@ -158,16 +159,6 @@ create_bus_proc_entries(struct bus_info *bus)
 		       bus->name);
 		return;
 	}
-	bus->proc_info = proc_create_data("info", 0, bus->proc_dir,
-					  &proc_info_vbus_fops, bus);
-	if (!bus->proc_info) {
-		LOGERR("failed to create /proc/uislib/vbus/%s/info", bus->name);
-		remove_proc_entry(bus->name, uislib_proc_vbus_dir);
-		bus->proc_dir = NULL;
-		return;
-	}
-	SET_PROC_OWNER(bus->proc_info, THIS_MODULE);
-
 }
 
 static __iomem void *
@@ -1255,7 +1246,7 @@ EXPORT_SYMBOL_GPL(uislib_cache_free);
 					       buff_len, __VA_ARGS__)
 
 static int
-info_proc_read_helper(char **buff, int *buff_len)
+info_debugfs_read_helper(char **buff, int *buff_len)
 {
 	int i, tot = 0;
 	struct bus_info *bus;
@@ -1315,7 +1306,8 @@ err_done:
 }
 
 static ssize_t
-info_proc_read(struct file *file, char __user *buf, size_t len, loff_t *offset)
+info_debugfs_read(struct file *file, char __user *buf,
+		size_t len, loff_t *offset)
 {
 	char *temp;
 	int totalBytes = 0;
@@ -1335,9 +1327,9 @@ info_proc_read(struct file *file, char __user *buf, size_t len, loff_t *offset)
 	temp = ProcReadBuffer;
 
 	if ((*offset == 0) || (!ProcReadBufferValid)) {
-		DBGINF("calling info_proc_read_helper.\n");
+		DBGINF("calling info_debugfs_read_helper.\n");
 		/* if the read fails, then -1 will be returned */
-		totalBytes = info_proc_read_helper(&temp, &remaining_bytes);
+		totalBytes = info_debugfs_read_helper(&temp, &remaining_bytes);
 		ProcReadBufferValid = 1;
 	} else
 		totalBytes = strlen(ProcReadBuffer);
@@ -1676,13 +1668,14 @@ uislib_mod_init(void)
 	/* (e.g., for /proc/uislib/vbus/<x>/info) */
 	uislib_proc_vbus_dir = proc_mkdir(DIR_VBUS_PROC_ENTRY, uislib_proc_dir);
 
-	info_proc_entry = proc_create(INFO_PROC_ENTRY_FN, 0, uislib_proc_dir,
-				      &proc_info_fops);
-	SET_PROC_OWNER(info_proc_entry, THIS_MODULE);
 
 	dir_debugfs = debugfs_create_dir(DIR_DEBUGFS_ENTRY, NULL);
 
 	if (dir_debugfs) {
+		info_debugfs_entry = debugfs_create_file(
+			INFO_DEBUGFS_ENTRY_FN, 0444, dir_debugfs, NULL,
+			&debugfs_info_fops);
+
 		platformnumber_debugfs_read = debugfs_create_u32(
 			PLATFORMNUMBER_DEBUGFS_ENTRY_FN, 0444, dir_debugfs,
 			&PlatformNumber);
@@ -1703,8 +1696,6 @@ uislib_mod_init(void)
 static void __exit
 uislib_mod_exit(void)
 {
-	if (info_proc_entry)
-		remove_proc_entry(INFO_PROC_ENTRY_FN, uislib_proc_dir);
 	if (uislib_proc_vbus_dir)
 		remove_proc_entry(DIR_VBUS_PROC_ENTRY, uislib_proc_dir);
 	if (uislib_proc_dir)
@@ -1715,6 +1706,7 @@ uislib_mod_exit(void)
 		ProcReadBuffer = NULL;
 	}
 
+	debugfs_remove(info_debugfs_entry);
 	debugfs_remove(smart_wakeup_debugfs_entry);
 	debugfs_remove(cycles_before_wait_debugfs_read);
 	debugfs_remove(platformnumber_debugfs_read);
-- 
1.9.1

