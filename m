Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197AbaELQpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:45:31 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.201]:41558 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753827AbaELQnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:43:53 -0400
X-Env-Sender: Benjamin.Romer@unisys.com
X-Msg-Ref: server-2.tower-45.messagelabs.com!1399913015!30856954!60
X-Originating-IP: [192.61.61.105]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: Benjamin Romer <benjamin.romer@unisys.com>
To: <gregkh@linuxfoundation.org>, <sparmaintainer@unisys.com>,
        <linux-kernel@vger.kernel.org>, <jkc@redhat.com>,
        <devel@driverdev.osuosl.org>
CC: Benjamin Romer <benjamin.romer@unisys.com>
Subject: [PATCH 1/7] staging: unisys: remove testing proc interfaces from uislib
Date: Mon, 12 May 2014 12:38:29 -0400
Message-ID: <1399912715-16142-2-git-send-email-benjamin.romer@unisys.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399912715-16142-1-git-send-email-benjamin.romer@unisys.com>
References: <1399912715-16142-1-git-send-email-benjamin.romer@unisys.com>
X-OriginalArrivalTime: 12 May 2014 16:43:49.0600 (UTC) FILETIME=[59B39E00:01CF6E01]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several proc interfaces in the uislib module were intended for debug and
testing during initial driver development. They are no longer needed, so
we should remove them from the module.

Signed-off-by: Benjamin Romer <benjamin.romer@unisys.com>
---
 drivers/staging/unisys/uislib/uislib.c | 534 +--------------------------------
 1 file changed, 1 insertion(+), 533 deletions(-)

diff --git a/drivers/staging/unisys/uislib/uislib.c b/drivers/staging/unisys/uislib/uislib.c
index 885857e..fdc23676 100644
--- a/drivers/staging/unisys/uislib/uislib.c
+++ b/drivers/staging/unisys/uislib/uislib.c
@@ -45,7 +45,6 @@
 
 #define SET_PROC_OWNER(x, y)
 
-#define UISLIB_TEST_PROC
 #define POLLJIFFIES_NORMAL 1
 /* Choose whether or not you want to wakeup the request-polling thread
  * after an IO termination:
@@ -91,44 +90,20 @@ static int Go_Polling_Device_Channels;
 
 static struct proc_dir_entry *uislib_proc_dir;
 static struct proc_dir_entry *uislib_proc_vbus_dir;
-static struct proc_dir_entry *vnic_proc_entry;	/* Used to be "datachan" */
-static struct proc_dir_entry *ctrlchan_proc_entry;
-static struct proc_dir_entry *pmem_proc_entry;
 static struct proc_dir_entry *info_proc_entry;
-static struct proc_dir_entry *switch_proc_entry;
-static struct proc_dir_entry *extport_proc_entry;
 static struct proc_dir_entry *platformnumber_proc_entry;
-static struct proc_dir_entry *bus_proc_entry;
-static struct proc_dir_entry *dev_proc_entry;
-static struct proc_dir_entry *chipset_proc_entry;
 static struct proc_dir_entry *cycles_before_wait_proc_entry;
-static struct proc_dir_entry *reset_counts_proc_entry;
 static struct proc_dir_entry *smart_wakeup_proc_entry;
-static struct proc_dir_entry *disable_proc_entry;
 
 #define DIR_PROC_ENTRY "uislib"
 #define DIR_VBUS_PROC_ENTRY "vbus"
-#define VNIC_PROC_ENTRY_FN "vnic"	/* Used to be "datachan" */
-#define CTRLCHAN_PROC_ENTRY_FN "ctrlchan"
-#define PMEM_PROC_ENTRY_FN "phys_to_virt"
 #define INFO_PROC_ENTRY_FN "info"
-#define SWITCH_PROC_ENTRY_FN "switch"
-#define SWITCH_COUNT_PROC_ENTRY_FN "switch_count"
-#define EXTPORT_PROC_ENTRY_FN "extport"
 #define PLATFORMNUMBER_PROC_ENTRY_FN "platform"
-#define BUS_PROC_ENTRY_FN "bus"
-#define DEV_PROC_ENTRY_FN "device"
-#define CHIPSET_PROC_ENTRY_FN "chipset"
 #define CYCLES_BEFORE_WAIT_PROC_ENTRY_FN "cycles_before_wait"
-#define RESET_COUNTS_PROC_ENTRY_FN "reset_counts"
 #define SMART_WAKEUP_PROC_ENTRY_FN "smart_wakeup"
 #define CALLHOME_PROC_ENTRY_FN "callhome"
 #define CALLHOME_THROTTLED_PROC_ENTRY_FN "callhome_throttled"
-#define DISABLE_PROC_ENTRY_FN "switch_state"
-#ifdef UISLIB_TEST_PROC
-static struct proc_dir_entry *test_proc_entry;
-#define TEST_PROC_ENTRY_FN "test"
-#endif
+
 static unsigned long long cycles_before_wait, wait_cycles;
 
 /*****************************************************/
@@ -155,21 +130,6 @@ static ssize_t uislib_proc_read_writeonly(struct file *file,
 					  char __user *buffer,
 					  size_t count, loff_t *ppos);
 
-static ssize_t vnic_proc_write(struct file *file, const char __user *buffer,
-			       size_t count, loff_t *ppos);
-
-static const struct file_operations proc_vnic_fops = {
-	.read = uislib_proc_read_writeonly,
-	.write = vnic_proc_write,
-};
-
-static ssize_t chipset_proc_write(struct file *file, const char __user *buffer,
-				  size_t count, loff_t *ppos);
-
-static const struct file_operations proc_chipset_fops = {
-	.read = uislib_proc_read_writeonly,
-	.write = chipset_proc_write,
-};
 
 static ssize_t info_proc_read(struct file *file, char __user *buf,
 			      size_t len, loff_t *offset);
@@ -191,14 +151,6 @@ static const struct file_operations proc_cycles_before_wait_fops = {
 	.write = cycles_before_wait_proc_write,
 };
 
-static ssize_t reset_counts_proc_write(struct file *file,
-				       const char __user *buffer,
-				       size_t count, loff_t *ppos);
-static const struct file_operations proc_reset_counts_fops = {
-	.read = uislib_proc_read_writeonly,
-	.write = reset_counts_proc_write,
-};
-
 static ssize_t smart_wakeup_proc_write(struct file *file,
 				       const char __user *buffer,
 				       size_t count, loff_t *ppos);
@@ -207,30 +159,6 @@ static const struct file_operations proc_smart_wakeup_fops = {
 	.write = smart_wakeup_proc_write,
 };
 
-static ssize_t test_proc_write(struct file *file,
-			       const char __user *buffer,
-			       size_t count, loff_t *ppos);
-static const struct file_operations proc_test_fops = {
-	.read = uislib_proc_read_writeonly,
-	.write = test_proc_write,
-};
-
-static ssize_t bus_proc_write(struct file *file,
-			      const char __user *buffer,
-			      size_t count, loff_t *ppos);
-static const struct file_operations proc_bus_fops = {
-	.read = uislib_proc_read_writeonly,
-	.write = bus_proc_write,
-};
-
-static ssize_t dev_proc_write(struct file *file,
-			      const char __user *buffer,
-			      size_t count, loff_t *ppos);
-static const struct file_operations proc_dev_fops = {
-	.read = uislib_proc_read_writeonly,
-	.write = dev_proc_write,
-};
-
 static void
 init_msg_header(CONTROLVM_MESSAGE *msg, U32 id, uint rsp, uint svr)
 {
@@ -1363,130 +1291,6 @@ EXPORT_SYMBOL_GPL(uislib_cache_free);
 /* proc filesystem callback functions                */
 /*****************************************************/
 
-static ssize_t
-vnic_proc_write(struct file *file, const char __user *buffer,
-		size_t count, loff_t *ppos)
-{
-	int action = 0xffff, busNo = 0, i, result = 0;
-	char buf[4];
-	char direction;
-/* GUID guid; */
-	if (count >= ARRAY_SIZE(buf))
-		return -EINVAL;
-
-	if (copy_from_user(buf, buffer, count)) {
-		LOGERR("echo > /proc/uislib/vnic copy_from_user ****FAILED.\n");
-		return -EFAULT;
-	}
-
-	i = sscanf(buf, "%d%c", &action, &direction);
-	if (i != 2) {
-		LOGERR("unable to parse vnic proc parameters.\n");
-		return -EFAULT;
-	}
-
-	if ((direction != '-') && (direction != '+')) {
-		LOGERR("unable to determine whether to add or delete vnic\n");
-		return -EFAULT;
-	}
-
-	/* if (i < 1), i.e., if we didn't even read the action field,
-	* then action will default to 0xffff and the code below will
-	* fall through the switch and print usage.
-	*/
-	switch (action) {
-	case 0:
-		/* call client method... */
-		busNo = 0;	/* All client drivers use bus value of 0... */
-		if (direction == '+')
-			result = uislib_client_add_vnic(busNo);
-		else
-			result = uislib_client_delete_vnic(busNo);
-		if (!result) {
-			LOGERR("echo 0%c > /proc/uislib/vnic failed (client end)",
-			     direction);
-			return -EFAULT;
-		}
-		return count;
-
-	default:
-		break;
-	}
-
-	LOGERR("USAGE: echo <action><direction (up/down)> > /proc/uislib/vnic");
-	LOGERR(" ");
-	LOGERR("Client Syntax");
-	LOGERR("-------------");
-	LOGERR("0+    ==> add vnic");
-	LOGERR("0-    ==> delete vnic");
-	LOGERR(" ");
-	return count;
-}				/* end vnic_proc_write */
-
-static ssize_t
-chipset_proc_write(struct file *file, const char __user *buffer,
-		   size_t count, loff_t *ppos)
-{
-	int i, action = 0xffff;
-	char buf[4];
-	CONTROLVM_MESSAGE msg;
-
-	if (count >= ARRAY_SIZE(buf))
-		return -EINVAL;
-
-	memset(&msg, 0, sizeof(CONTROLVM_MESSAGE));
-
-	if (copy_from_user(buf, buffer, count)) {
-		LOGERR("copy_from_user ****FAILED.\n");
-		return -EFAULT;
-	}
-
-	if (chipset_inited) {
-		LOGINF("Chipset already initialized\n");
-		return -EFAULT;
-	}
-	i = sscanf(buf, "%x", &action);
-
-	/* if (i < 1), i.e., if we didn't even read the action field,
-	* then action will default to 0xffff and the code below will
-	* fall through the switch and print usage.
-	*/
-	switch (action) {
-	case 1:
-		/* GUEST */
-		/* step: initialize the chipset */
-		init_msg_header(&msg, CONTROLVM_CHIPSET_INIT, 0, 0);
-		msg.hdr.Flags.testMessage = 0;
-		msg.cmd.initChipset.busCount = 23;
-		msg.cmd.initChipset.switchCount = 23;
-
-		if (init_chipset(&msg, NULL) != CONTROLVM_RESP_SUCCESS) {
-			LOGERR("init_chipset failed.\n");
-			return 0;
-		}
-		return 1;
-	case 2:
-		/* BOTH */
-		init_msg_header(&msg, CONTROLVM_CHIPSET_INIT, 0, 0);
-		msg.hdr.Flags.testMessage = 1;
-		msg.cmd.initChipset.busCount = 23;
-		msg.cmd.initChipset.switchCount = 23;
-
-		if (init_chipset(&msg, NULL) != CONTROLVM_RESP_SUCCESS) {
-			LOGERR("init_chipset failed.\n");
-			return 0;
-		}
-		return 1;
-
-	default:
-		break;
-	}
-
-	LOGERR("usage: 1 ==> init_chipset client\n");
-	LOGERR("usage: 2 ==> init_chipset test\n");
-	return -EFAULT;
-}
-
 #define PLINE(...) uisutil_add_proc_line_ex(&tot, buff, \
 					       buff_len, __VA_ARGS__)
 
@@ -1612,8 +1416,6 @@ platformnumber_proc_read(struct file *file, char __user *buf,
 	return length;
 }
 
-#ifdef UISLIB_TEST_PROC
-
 /* proc/uislib/vbus/<x>/info */
 static int
 proc_info_vbus_show(struct seq_file *m, void *v)
@@ -1653,82 +1455,6 @@ proc_info_vbus_show(struct seq_file *m, void *v)
 }
 
 static ssize_t
-bus_proc_write(struct file *file, const char __user *buffer,
-	       size_t count, loff_t *ppos)
-{
-	int server_flag = 0;
-	int i, action = 0xffff, result;
-	char buf[16];
-	CONTROLVM_MESSAGE msg;
-	U32 busNo, deviceCount;
-
-	if (count >= ARRAY_SIZE(buf))
-		return -EINVAL;
-
-	memset(&msg, 0, sizeof(CONTROLVM_MESSAGE));
-
-	if (copy_from_user(buf, buffer, count)) {
-		LOGERR("echo > /proc/uislib/bus: copy_from_user ****FAILED.");
-		return -EFAULT;
-	}
-
-	i = sscanf(buf, "%x-%d-%d", &action, &busNo, &deviceCount);
-
-	/* if (i < 1), i.e., if we didn't even read the action field,
-	* then action will default to 0xffff and the code below will
-	* fall through the switch and print usage.
-	*/
-	switch (action) {
-	case 0:
-		/* destroy a bus */
-		if (i != 2)
-			break;
-		init_msg_header(&msg, CONTROLVM_BUS_DESTROY, 0, server_flag);
-		msg.cmd.destroyBus.busNo = busNo;
-
-		result = destroy_bus(&msg, NULL);
-
-		if (result != CONTROLVM_RESP_SUCCESS) {
-			LOGERR("echo 0-%d > /proc/uislib/bus {CONTROLVM_BUS_DESTROY Failed} Result(%d)",
-			     busNo, result);
-			return -EFAULT;
-		}
-		return count;
-	case 1:
-		/* create a bus */
-		if (i != 3)
-			break;
-		init_msg_header(&msg, CONTROLVM_BUS_CREATE, 0, server_flag);
-		msg.cmd.createBus.busNo = busNo;
-		msg.cmd.createBus.deviceCount = deviceCount;
-
-		result = create_bus(&msg, NULL);
-
-		if (result != CONTROLVM_RESP_SUCCESS) {
-			LOGERR("echo 1-%d-%d > /proc/uislib/bus {CONTROLVM_BUS_CREATE Failed} Result(%d)",
-			     busNo, deviceCount, result);
-			return -EFAULT;
-		}
-
-		return count;
-	default:
-		break;
-	}
-
-	LOGERR("USAGE: echo <action>-<busNo>... > /proc/uislib/bus");
-	LOGERR(" ");
-	LOGERR("Destruct Syntax     ControlVM Message Id");
-	LOGERR("---------------     ---------------------");
-	LOGERR("0-<busNo>       ==> CONTROLVM_BUS_DESTROY");
-	LOGERR(" ");
-	LOGERR("Construct Syntax            ControlVM Message Id");
-	LOGERR("-----------------------     -------------------- ");
-	LOGERR("1-<busNo>-<deviceCount> ==> CONTROLVM_BUS_CREATE");
-
-	return -EFAULT;
-}
-
-static ssize_t
 uislib_proc_read_writeonly(struct file *file, char __user *buffer,
 	       size_t count, loff_t *ppos)
 {
@@ -1736,105 +1462,6 @@ uislib_proc_read_writeonly(struct file *file, char __user *buffer,
 }
 
 static ssize_t
-dev_proc_write(struct file *file, const char __user *buffer,
-	       size_t count, loff_t *ppos)
-{
-	int server_flag = 0;
-	CONTROLVM_MESSAGE msg;
-	U32 busNo, devNo;
-	char buf[32];
-	unsigned int chanptr;
-	int type, i, action = 0xffff, result;
-
-	if (count >= ARRAY_SIZE(buf))
-		return -EINVAL;
-
-	if (copy_from_user(buf, buffer, count)) {
-		LOGERR("echo > /proc/uislib/device: copy_from_user ****FAILED.");
-		return -EFAULT;
-	}
-
-	i = sscanf(buf, "%x-%d-%d-%x-%d",
-		   &action, &busNo, &devNo, &chanptr, &type);
-
-	switch (action) {
-	case 0:
-		if (i != 3)
-			break;
-
-		/* destroy a device */
-		init_msg_header(&msg, CONTROLVM_DEVICE_DESTROY, 0, server_flag);
-		msg.cmd.destroyDevice.busNo = busNo;
-		msg.cmd.destroyDevice.devNo = devNo;
-
-		result = destroy_device(&msg, NULL);
-
-		if (result != CONTROLVM_RESP_SUCCESS) {
-			LOGERR("echo 0-%d-%d > /proc/uislib/device {CONTROLVM_DEVICE_DESTROY Failed} Result(%d)",
-			     busNo, devNo, result);
-			return -EFAULT;
-		}
-
-		return count;
-
-	case 1:
-		if (i != 5)
-			break;
-
-		/* create a device */
-		init_msg_header(&msg, CONTROLVM_DEVICE_CREATE, 0, server_flag);
-		msg.cmd.createDevice.busNo = busNo;
-		msg.cmd.createDevice.devNo = devNo;
-		msg.cmd.createDevice.channelAddr = __pa(chanptr);
-		msg.cmd.createDevice.channelBytes = MIN_IO_CHANNEL_SIZE;
-
-		if (type == 0)
-			msg.cmd.createDevice.dataTypeGuid =
-			    UltraVhbaChannelProtocolGuid;
-		else if (type == 1)
-			msg.cmd.createDevice.dataTypeGuid =
-			    UltraVnicChannelProtocolGuid;
-		else {
-			LOGERR("echo 1-%d-%d-%x-<type> > /proc/uislib/devce failed: invalid device type %d.",
-			     busNo, devNo, chanptr, type);
-			return -EFAULT;
-		}
-
-		result = create_device(&msg, NULL);
-
-		if (result != CONTROLVM_RESP_SUCCESS) {
-			if (type == 0)
-				LOGERR("echo 1-%d-%d-%x-0 > /proc/uislib/device {CONTROLVM_DEVICE_CREATE[vHBA] Failed} Result(%d)",
-				     busNo, devNo, chanptr, result);
-			else
-				LOGERR("echo 1-%d-%d-%x-1 > /proc/uislib/device {CONTROLVM_DEVICE_CREATE[vNIC] Failed} Result(%d)",
-				     busNo, devNo, chanptr, result);
-			return -EFAULT;
-		}
-
-	default:
-		break;
-	}
-
-	LOGERR("USAGE: echo <action>-<busNo>-<devNo>... > /proc/uislib/device");
-	LOGERR(" ");
-	LOGERR("Destruct Syntax       ControlVM Message Id");
-	LOGERR("-----------------     ------------------------");
-	LOGERR("0-<busNo>-<devNo> ==> CONTROLVM_DEVICE_DESTROY");
-	LOGERR(" ");
-	LOGERR("Construct Syntax                       ControlVM Message Id");
-	LOGERR
-	    ("----------------------------------     ----------------------- ");
-	LOGERR
-	    ("1-<busNo>-<devNo>-<chanptr>-<type> ==> CONTROLVM_DEVICE_CREATE");
-	LOGERR("      <type = 0>: vHBA");
-	LOGERR("      <type = 1>: vNIC");
-	LOGERR(" ");
-
-	return -EFAULT;
-}
-
-static ssize_t
 cycles_before_wait_proc_write(struct file *file, const char __user *buffer,
 			      size_t count, loff_t *ppos)
 {
@@ -1866,56 +1493,6 @@ cycles_before_wait_proc_write(struct file *file, const char __user *buffer,
 }
 
 static ssize_t
-reset_counts_proc_write(struct file *file, const char __user *buffer,
-			size_t count, loff_t *ppos)
-{
-	char buf[16];
-	unsigned long long new_value;
-	struct bus_info *bus;
-	int i;
-
-#define RESET_COUNTS_USE_ERROR  { \
-	LOGERR("Incorrect reset_counts Input.\n"); \
-	pr_info("Please pass the new value for the counters:\n"); \
-	pr_info("e.g. echo 0 > reset_counts\n"); \
-	return -EFAULT; \
-	}
-
-	if (count >= ARRAY_SIZE(buf))
-		return -EINVAL;
-
-	if (count == 0)
-		RESET_COUNTS_USE_ERROR;
-
-	if (copy_from_user(buf, buffer, count)) {
-		LOGERR("copy_from_user failed.\n");
-		return -EFAULT;
-	}
-	buf[count - 1] = '\0';	/* Replace the LF at the end of the
-				 * input with a NULL */
-	/* Pull out the reset_counts must be decimal integer */
-	if (sscanf(buf, "%llu", &new_value) != 1)
-		RESET_COUNTS_USE_ERROR;
-	read_lock(&BusListLock);
-	for (bus = BusListHead; bus; bus = bus->next) {
-
-		for (i = 0; i < bus->deviceCount; i++) {
-			if (bus->device[i]) {
-				bus->device[i]->first_busy_cnt = new_value;
-				bus->device[i]->moved_to_tail_cnt = new_value;
-				bus->device[i]->last_on_list_cnt = new_value;
-			}
-		}
-	}
-	read_unlock(&BusListLock);
-	tot_moved_to_tail_cnt = new_value;
-	tot_wait_cnt = new_value;
-	tot_wakeup_cnt = new_value;
-	tot_schedule_cnt = new_value;
-	return count;
-}
-
-static ssize_t
 smart_wakeup_proc_write(struct file *file, const char __user *buffer,
 			size_t count, loff_t *ppos)
 {
@@ -1948,66 +1525,6 @@ smart_wakeup_proc_write(struct file *file, const char __user *buffer,
 	return count;
 }
 
-static ssize_t
-test_proc_write(struct file *file, const char __user *buffer,
-		size_t count, loff_t *ppos)
-{
-	int i, action = 0xffff;
-	char buf[16];
-	CONTROLVM_MESSAGE msg;
-	S64 vrtc_offset;
-
-	if (count >= ARRAY_SIZE(buf))
-		return -EINVAL;
-
-	memset(&msg, 0, sizeof(CONTROLVM_MESSAGE));
-
-	if (copy_from_user(buf, buffer, count)) {
-		LOGERR("copy_from_user ****FAILED.\n");
-		return -EFAULT;
-	}
-
-	i = sscanf(buf, "%x", &action);
-
-	/* if (i < 1), i.e., if we didn't even read the action field,
-	* then action will default to 0xffff and the code below will
-	* fall through the switch and print usage. */
-	switch (action) {
-	case 6:
-		msg.hdr.Id = CONTROLVM_CHIPSET_STOP;
-		msg.hdr.Flags.responseExpected = 1;
-		stop_chipset(&msg, NULL);
-		break;
-	case 7:
-		vrtc_offset = 0;
-		LOGERR("about to issue QUERY vrtc_offset=%LX", vrtc_offset);
-		vrtc_offset = Issue_VMCALL_QUERY_GUEST_VIRTUAL_TIME_OFFSET();
-		LOGERR("result is vrtc_offset=%LX", vrtc_offset);
-		break;
-	case 8:
-		vrtc_offset = 60;
-		LOGERR("about to increase physical time by 0x%LX seconds",
-		       vrtc_offset);
-		vrtc_offset = Issue_VMCALL_UPDATE_PHYSICAL_TIME(vrtc_offset);
-		break;
-	case 9:
-		vrtc_offset = -60;
-		LOGERR("about to decrease physical time by 0x%LX seconds",
-		       vrtc_offset);
-		vrtc_offset = Issue_VMCALL_UPDATE_PHYSICAL_TIME(vrtc_offset);
-		break;
-	default:
-		LOGERR("usage: 6 for CHIPSET_STOP\n");
-		LOGERR("       7 for VMCALL_QUERY_GUEST_VIRTUAL_TIME_OFFSET()\n");
-		LOGERR("       8 for VMCALL_UPDATE_PHYSICAL_TIME(60)\n");
-		LOGERR("       9 for VMCALL_UPDATE_PHYSICAL_TIME(-60)\n");
-		return -EFAULT;
-		break;
-	}
-	return count;
-}
-
-#endif				/* UISLIB_TEST_PROC */
 static struct device_info *
 find_dev(U32 busNo, U32 devNo)
 {
@@ -2300,17 +1817,6 @@ uislib_mod_init(void)
 	/* (e.g., for /proc/uislib/vbus/<x>/info) */
 	uislib_proc_vbus_dir = proc_mkdir(DIR_VBUS_PROC_ENTRY, uislib_proc_dir);
 
-	vnic_proc_entry = proc_create(VNIC_PROC_ENTRY_FN, 0, uislib_proc_dir,
-				      &proc_vnic_fops);
-	SET_PROC_OWNER(vnic_proc_entry, THIS_MODULE);
-
-	/* for testing purposes only, create the proc entries for
-	 * enqueuing Control Channel messages */
-	chipset_proc_entry =
-	    proc_create(CHIPSET_PROC_ENTRY_FN, 0, uislib_proc_dir,
-			&proc_chipset_fops);
-	SET_PROC_OWNER(chipset_proc_entry, THIS_MODULE);
-
 	info_proc_entry = proc_create(INFO_PROC_ENTRY_FN, 0, uislib_proc_dir,
 				      &proc_info_fops);
 	SET_PROC_OWNER(info_proc_entry, THIS_MODULE);
@@ -2325,29 +1831,11 @@ uislib_mod_init(void)
 			&proc_cycles_before_wait_fops);
 	SET_PROC_OWNER(cycles_before_wait_proc_entry, THIS_MODULE);
 
-	reset_counts_proc_entry =
-	    proc_create(RESET_COUNTS_PROC_ENTRY_FN, 0, uislib_proc_dir,
-			&proc_reset_counts_fops);
-	SET_PROC_OWNER(reset_counts_proc_entry, THIS_MODULE);
-
 	smart_wakeup_proc_entry =
 	    proc_create(SMART_WAKEUP_PROC_ENTRY_FN, 0, uislib_proc_dir,
 			&proc_smart_wakeup_fops);
 	SET_PROC_OWNER(smart_wakeup_proc_entry, THIS_MODULE);
 
-#ifdef UISLIB_TEST_PROC
-	test_proc_entry = proc_create(TEST_PROC_ENTRY_FN, 0, uislib_proc_dir,
-				      &proc_test_fops);
-	SET_PROC_OWNER(test_proc_entry, THIS_MODULE);
-
-	bus_proc_entry = proc_create(BUS_PROC_ENTRY_FN, 0, uislib_proc_dir,
-				     &proc_bus_fops);
-	SET_PROC_OWNER(bus_proc_entry, THIS_MODULE);
-
-	dev_proc_entry = proc_create(DEV_PROC_ENTRY_FN, 0, uislib_proc_dir,
-				     &proc_dev_fops);
-	SET_PROC_OWNER(dev_proc_entry, THIS_MODULE);
-#endif				/* UISLIB_TEST_PROC */
 	POSTCODE_LINUX_3(DRIVER_EXIT_PC, 0, POSTCODE_SEVERITY_INFO);
 	return 0;
 }
@@ -2355,36 +1843,16 @@ uislib_mod_init(void)
 static void __exit
 uislib_mod_exit(void)
 {
-	if (disable_proc_entry)
-		remove_proc_entry(DISABLE_PROC_ENTRY_FN, uislib_proc_dir);
 	if (cycles_before_wait_proc_entry)
 		remove_proc_entry(CYCLES_BEFORE_WAIT_PROC_ENTRY_FN,
 				  uislib_proc_dir);
-	if (reset_counts_proc_entry)
-		remove_proc_entry(RESET_COUNTS_PROC_ENTRY_FN, uislib_proc_dir);
 	if (smart_wakeup_proc_entry)
 		remove_proc_entry(SMART_WAKEUP_PROC_ENTRY_FN, uislib_proc_dir);
-	if (ctrlchan_proc_entry)
-		remove_proc_entry(CTRLCHAN_PROC_ENTRY_FN, uislib_proc_dir);
-	if (pmem_proc_entry)
-		remove_proc_entry(PMEM_PROC_ENTRY_FN, uislib_proc_dir);
 	if (info_proc_entry)
 		remove_proc_entry(INFO_PROC_ENTRY_FN, uislib_proc_dir);
-	if (switch_proc_entry)
-		remove_proc_entry(SWITCH_PROC_ENTRY_FN, uislib_proc_dir);
-	if (extport_proc_entry)
-		remove_proc_entry(EXTPORT_PROC_ENTRY_FN, uislib_proc_dir);
 	if (platformnumber_proc_entry)
 		remove_proc_entry(PLATFORMNUMBER_PROC_ENTRY_FN,
 				  uislib_proc_dir);
-	if (bus_proc_entry)
-		remove_proc_entry(BUS_PROC_ENTRY_FN, uislib_proc_dir);
-	if (dev_proc_entry)
-		remove_proc_entry(DEV_PROC_ENTRY_FN, uislib_proc_dir);
-	if (vnic_proc_entry)
-		remove_proc_entry(VNIC_PROC_ENTRY_FN, uislib_proc_dir);
-	if (chipset_proc_entry)
-		remove_proc_entry(CHIPSET_PROC_ENTRY_FN, uislib_proc_dir);
 	if (uislib_proc_vbus_dir)
 		remove_proc_entry(DIR_VBUS_PROC_ENTRY, uislib_proc_dir);
 	if (uislib_proc_dir)
-- 
1.9.1

