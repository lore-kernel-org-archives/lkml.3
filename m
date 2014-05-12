Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094AbaELQof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:44:35 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.105]:37162 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759067AbaELQn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:43:57 -0400
X-Env-Sender: Benjamin.Romer@unisys.com
X-Msg-Ref: server-5.tower-200.messagelabs.com!1399913022!8210220!52
X-Originating-IP: [192.61.61.105]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: Benjamin Romer <benjamin.romer@unisys.com>
To: <gregkh@linuxfoundation.org>, <sparmaintainer@unisys.com>,
        <linux-kernel@vger.kernel.org>, <jkc@redhat.com>,
        <devel@driverdev.osuosl.org>
CC: Benjamin Romer <benjamin.romer@unisys.com>
Subject: [PATCH 7/7] staging: unisys: remove remaining proc directory entries
Date: Mon, 12 May 2014 12:38:35 -0400
Message-ID: <1399912715-16142-8-git-send-email-benjamin.romer@unisys.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399912715-16142-1-git-send-email-benjamin.romer@unisys.com>
References: <1399912715-16142-1-git-send-email-benjamin.romer@unisys.com>
X-OriginalArrivalTime: 12 May 2014 16:43:50.0061 (UTC) FILETIME=[59F9F5D0:01CF6E01]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally, remove /proc/uislib and all remaining, redundant entries created
under /proc/uislib/vbus.

Signed-off-by: Benjamin Romer <benjamin.romer@unisys.com>
---
 drivers/staging/unisys/uislib/uislib.c | 92 ----------------------------------
 1 file changed, 92 deletions(-)

diff --git a/drivers/staging/unisys/uislib/uislib.c b/drivers/staging/unisys/uislib/uislib.c
index 5980040..dcac042 100644
--- a/drivers/staging/unisys/uislib/uislib.c
+++ b/drivers/staging/unisys/uislib/uislib.c
@@ -89,12 +89,6 @@ static DEFINE_SEMAPHORE(Lock_Polling_Device_Channels);	/* unlocked */
 static DECLARE_WAIT_QUEUE_HEAD(Wakeup_Polling_Device_Channels);
 static int Go_Polling_Device_Channels;
 
-static struct proc_dir_entry *uislib_proc_dir;
-static struct proc_dir_entry *uislib_proc_vbus_dir;
-
-#define DIR_PROC_ENTRY "uislib"
-#define DIR_VBUS_PROC_ENTRY "vbus"
-
 #define CALLHOME_PROC_ENTRY_FN "callhome"
 #define CALLHOME_THROTTLED_PROC_ENTRY_FN "callhome_throttled"
 
@@ -119,22 +113,6 @@ static unsigned long long cycles_before_wait, wait_cycles;
 /* local functions                                   */
 /*****************************************************/
 
-static int proc_info_vbus_show(struct seq_file *m, void *v);
-static int
-proc_info_vbus_open(struct inode *inode, struct file *filp)
-{
-	/* proc_info_vbus_show will grab this from seq_file.private: */
-	struct bus_info *bus = PDE_DATA(inode);
-	return single_open(filp, proc_info_vbus_show, bus);
-}
-
-static const struct file_operations proc_info_vbus_fops = {
-	.open = proc_info_vbus_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
 static ssize_t info_debugfs_read(struct file *file, char __user *buf,
 			      size_t len, loff_t *offset);
 static const struct file_operations debugfs_info_fops = {
@@ -150,17 +128,6 @@ init_msg_header(CONTROLVM_MESSAGE *msg, U32 id, uint rsp, uint svr)
 	msg->hdr.Flags.server = svr;
 }
 
-static void
-create_bus_proc_entries(struct bus_info *bus)
-{
-	bus->proc_dir = proc_mkdir(bus->name, uislib_proc_vbus_dir);
-	if (!bus->proc_dir) {
-		LOGERR("failed to create /proc/uislib/vbus/%s directory",
-		       bus->name);
-		return;
-	}
-}
-
 static __iomem void *
 init_vbus_channel(U64 channelAddr, U32 channelBytes, int isServer)
 {
@@ -296,7 +263,6 @@ create_bus(CONTROLVM_MESSAGE *msg, char *buf)
 			    CONTROLVM_RESP_ERROR_VIRTPCI_DRIVER_CALLBACK_ERROR;
 		}
 	}
-	create_bus_proc_entries(bus);
 
 	/* add bus at the head of our list */
 	write_lock(&BusListLock);
@@ -373,14 +339,6 @@ destroy_bus(CONTROLVM_MESSAGE *msg, char *buf)
 		read_unlock(&BusListLock);
 		return CONTROLVM_RESP_ERROR_ALREADY_DONE;
 	}
-	if (bus->proc_info) {
-		remove_proc_entry("info", bus->proc_dir);
-		bus->proc_info = NULL;
-	}
-	if (bus->proc_dir) {
-		remove_proc_entry(bus->name, uislib_proc_vbus_dir);
-		bus->proc_dir = NULL;
-	}
 	if (bus->pBusChannel) {
 		uislib_iounmap(bus->pBusChannel);
 		bus->pBusChannel = NULL;
@@ -1338,44 +1296,6 @@ info_debugfs_read(struct file *file, char __user *buf,
 				       ProcReadBuffer, totalBytes);
 }
 
-/* proc/uislib/vbus/<x>/info */
-static int
-proc_info_vbus_show(struct seq_file *m, void *v)
-{
-	struct bus_info *bus = m->private;
-	int i, devInfoCount, x;
-	char buf[999];
-
-	if (bus == NULL)
-		return 0;
-	seq_printf(m, "Client device / client driver info for %s partition (vbus #%d):\n",
-		   bus->partitionName, bus->busNo);
-	if ((bus->busChannelBytes == 0) || (bus->pBusChannel == NULL))
-		return 0;
-	devInfoCount =
-	    (bus->busChannelBytes -
-	     sizeof(ULTRA_VBUS_CHANNEL_PROTOCOL)) /
-	    sizeof(ULTRA_VBUS_DEVICEINFO);
-	x = VBUSCHANNEL_devInfoToStringBuffer(&bus->pBusChannel->ChpInfo, buf,
-					      sizeof(buf) - 1, -1);
-	buf[x] = '\0';
-	seq_printf(m, "%s", buf);
-	x = VBUSCHANNEL_devInfoToStringBuffer(&bus->pBusChannel->BusInfo,
-					      buf, sizeof(buf) - 1, -1);
-	buf[x] = '\0';
-	seq_printf(m, "%s", buf);
-	for (i = 0; i < devInfoCount; i++) {
-		x = VBUSCHANNEL_devInfoToStringBuffer(&bus->pBusChannel->
-						      DevInfo[i], buf,
-						      sizeof(buf) - 1, i);
-		if (x > 0) {
-			buf[x] = '\0';
-			seq_printf(m, "%s", buf);
-		}
-	}
-	return 0;
-}
-
 static struct device_info *
 find_dev(U32 busNo, U32 devNo)
 {
@@ -1663,14 +1583,7 @@ uislib_mod_init(void)
 	 * then map this physical address to a virtual address. */
 	POSTCODE_LINUX_2(DRIVER_ENTRY_PC, POSTCODE_SEVERITY_INFO);
 
-	/* create the proc entries for the channels */
-	uislib_proc_dir = proc_mkdir(DIR_PROC_ENTRY, NULL);
-	/* (e.g., for /proc/uislib/vbus/<x>/info) */
-	uislib_proc_vbus_dir = proc_mkdir(DIR_VBUS_PROC_ENTRY, uislib_proc_dir);
-
-
 	dir_debugfs = debugfs_create_dir(DIR_DEBUGFS_ENTRY, NULL);
-
 	if (dir_debugfs) {
 		info_debugfs_entry = debugfs_create_file(
 			INFO_DEBUGFS_ENTRY_FN, 0444, dir_debugfs, NULL,
@@ -1696,11 +1609,6 @@ uislib_mod_init(void)
 static void __exit
 uislib_mod_exit(void)
 {
-	if (uislib_proc_vbus_dir)
-		remove_proc_entry(DIR_VBUS_PROC_ENTRY, uislib_proc_dir);
-	if (uislib_proc_dir)
-		remove_proc_entry(DIR_PROC_ENTRY, NULL);
-
 	if (ProcReadBuffer) {
 		vfree(ProcReadBuffer);
 		ProcReadBuffer = NULL;
-- 
1.9.1

