Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbaANSvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:51:39 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:56415
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbaANSve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:51:34 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
Date: Tue, 14 Jan 2014 11:35:16 -0800
Message-Id: <1389728116-21337-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the file copy service for Linux guests on Hyper-V. This permits the
host to copy a file (over VMBUS) into the guest. This facility is part of
"guest integration services" supported on the Windows platform.
Here is a link that provides additional details on this functionality:

http://technet.microsoft.com/en-us/library/dn464282.aspx

In V1 version of the patch I have addressed comments from
Olaf Hering <olaf@aepfle.de> and Dan Carpenter <dan.carpenter@oracle.com>

In this version of the patch I have made globals static.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/Makefile        |    2 +-
 drivers/hv/hv_fcopy.c      |  422 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/hv/hv_util.c       |   10 +
 include/linux/hyperv.h     |   60 +++++++
 tools/hv/hv_fcopy_daemon.c |  174 ++++++++++++++++++
 5 files changed, 667 insertions(+), 1 deletions(-)
 create mode 100644 drivers/hv/hv_fcopy.c
 create mode 100644 tools/hv/hv_fcopy_daemon.c

diff --git a/drivers/hv/Makefile b/drivers/hv/Makefile
index 0a74b56..5e4dfa4 100644
--- a/drivers/hv/Makefile
+++ b/drivers/hv/Makefile
@@ -5,4 +5,4 @@ obj-$(CONFIG_HYPERV_BALLOON)	+= hv_balloon.o
 hv_vmbus-y := vmbus_drv.o \
 		 hv.o connection.o channel.o \
 		 channel_mgmt.o ring_buffer.o
-hv_utils-y := hv_util.o hv_kvp.o hv_snapshot.o
+hv_utils-y := hv_util.o hv_kvp.o hv_snapshot.o hv_fcopy.o
diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
new file mode 100644
index 0000000..f108a6e
--- /dev/null
+++ b/drivers/hv/hv_fcopy.c
@@ -0,0 +1,422 @@
+/*
+ * An implementation of file copy service.
+ *
+ * Copyright (C) 2014, Microsoft, Inc.
+ *
+ * Author : K. Y. Srinivasan <ksrinivasan@novell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/semaphore.h>
+#include <linux/fs.h>
+#include <linux/nls.h>
+#include <linux/workqueue.h>
+#include <linux/cdev.h>
+#include <linux/hyperv.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+
+#define WIN8_SRV_MAJOR		1
+#define WIN8_SRV_MINOR		1
+#define WIN8_SRV_VERSION	(WIN8_SRV_MAJOR << 16 | WIN8_SRV_MINOR)
+
+/*
+ * Global state maintained for transaction that is being processed.
+ * For a class of integration services, including the "file copy service",
+ * the specified protocol is a "request/response" protocol which means that
+ * there can only be single outstanding transaction from the host at any
+ * given point in time. We use this to simplify memory management in this
+ * driver - we cache and process only one message at a time.
+ *
+ * While the request/response protocol is guaranteed by the host, we further
+ * ensure this by serializing packet processing in this driver - we do not
+ * read additional packets from the VMBUs until the current packet is fully
+ * handled.
+ *
+ * The transaction "active" state is set when we receive a request from the
+ * host and we cleanup this state when the transaction is completed - when we
+ * respond to the host with our response. When the transaction active state is
+ * set, we defer handling incoming packets.
+ */
+
+static struct {
+	bool active; /* transaction status - active or not */
+	int recv_len; /* number of bytes received. */
+	struct hv_fcopy_hdr  *fcopy_msg; /* current message */
+	struct hv_start_fcopy  message; /*  sent to daemon */
+	struct vmbus_channel *recv_channel; /* chn we got the request */
+	u64 recv_req_id; /* request ID. */
+	void *fcopy_context; /* for the channel callback */
+	struct semaphore read_sema;
+} fcopy_transaction;
+
+static dev_t fcopy_dev;
+static bool daemon_died;
+static bool opened; /* currently device opened */
+static struct task_struct *dtp; /* daemon task ptr */
+
+/*
+ * Before we can accept copy messages from the host, we need
+ * to handshake with the user level daemon. This state tracks
+ * if we are in the handshake phase.
+ */
+static bool in_hand_shake = true;
+static void fcopy_send_data(void);
+static void fcopy_respond_to_host(int error);
+static void fcopy_work_func(struct work_struct *dummy);
+static DECLARE_DELAYED_WORK(fcopy_work, fcopy_work_func);
+static u8 *recv_buffer;
+
+static void fcopy_work_func(struct work_struct *dummy)
+{
+	/*
+	 * If the timer fires, the user-mode component has not responded;
+	 * process the pending transaction.
+	 */
+	fcopy_respond_to_host(HV_E_FAIL);
+}
+
+static void fcopy_handle_handshake(void)
+{
+	pr_info("FCP: user-mode registering done.\n");
+	fcopy_transaction.active = false;
+	if (fcopy_transaction.fcopy_context)
+		hv_fcopy_onchannelcallback(fcopy_transaction.fcopy_context);
+	in_hand_shake = false;
+	return;
+}
+
+static void fcopy_send_data(void)
+{
+	struct hv_start_fcopy *smsg_out = &fcopy_transaction.message;
+	int operation = fcopy_transaction.fcopy_msg->operation;
+	struct hv_start_fcopy *smsg_in;
+
+	/*
+	 * The  strings sent from the host are encoded in
+	 * in utf16; convert it to utf8 strings.
+	 * The host assures us that the utf16 strings will not exceed
+	 * the max lengths specified. We will however, reserve room
+	 * for the string terminating character - in the utf16s_utf8s()
+	 * function we limit the size of the buffer where the converted
+	 * string is placed to W_MAX_PATH -1 to gaurantee
+	 * that the strings can be properly terminated!
+	 */
+
+	switch (operation) {
+	case START_FILE_COPY:
+		memset(smsg_out, 0, sizeof(struct hv_start_fcopy));
+		smsg_out->hdr.operation = operation;
+		smsg_in = (struct hv_start_fcopy *)fcopy_transaction.fcopy_msg;
+
+		utf16s_to_utf8s((wchar_t *)smsg_in->file_name, W_MAX_PATH,
+				UTF16_LITTLE_ENDIAN,
+				(__u8 *)smsg_out->file_name, W_MAX_PATH - 1);
+
+		utf16s_to_utf8s((wchar_t *)smsg_in->path_name, W_MAX_PATH,
+				UTF16_LITTLE_ENDIAN,
+				(__u8 *)smsg_out->path_name, W_MAX_PATH - 1);
+
+		smsg_out->copy_flags = smsg_in->copy_flags;
+		smsg_out->file_size = smsg_in->file_size;
+		break;
+
+	default:
+		break;
+	}
+	up(&fcopy_transaction.read_sema);
+	return;
+}
+
+/*
+ * Send a response back to the host.
+ */
+
+static void
+fcopy_respond_to_host(int error)
+{
+	struct icmsg_hdr *icmsghdrp;
+	u32 buf_len;
+	struct vmbus_channel *channel;
+	u64 req_id;
+
+	/*
+	 * Copy the global state for completing the transaction. Note that
+	 * only one transaction can be active at a time.
+	 */
+
+	buf_len = fcopy_transaction.recv_len;
+	channel = fcopy_transaction.recv_channel;
+	req_id = fcopy_transaction.recv_req_id;
+
+	fcopy_transaction.active = false;
+
+	icmsghdrp = (struct icmsg_hdr *)
+			&recv_buffer[sizeof(struct vmbuspipe_hdr)];
+
+	if (channel->onchannel_callback == NULL)
+		/*
+		 * We have raced with util driver being unloaded;
+		 * silently return.
+		 */
+		return;
+
+	icmsghdrp->status = error;
+	icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION | ICMSGHDRFLAG_RESPONSE;
+	vmbus_sendpacket(channel, recv_buffer, buf_len, req_id,
+				VM_PKT_DATA_INBAND, 0);
+}
+
+void hv_fcopy_onchannelcallback(void *context)
+{
+	struct vmbus_channel *channel = context;
+	u32 recvlen;
+	u64 requestid;
+	struct hv_fcopy_hdr *fcopy_msg;
+	struct icmsg_hdr *icmsghdrp;
+	struct icmsg_negotiate *negop = NULL;
+	int util_fw_version;
+	int fcopy_srv_version;
+
+	if (fcopy_transaction.active) {
+		/*
+		 * We will defer processing this callback once
+		 * the current transaction is complete.
+		 */
+		fcopy_transaction.fcopy_context = context;
+		return;
+	}
+
+	vmbus_recvpacket(channel, recv_buffer, PAGE_SIZE * 2, &recvlen,
+			 &requestid);
+	if (recvlen <= 0)
+		return;
+
+	icmsghdrp = (struct icmsg_hdr *)&recv_buffer[
+			sizeof(struct vmbuspipe_hdr)];
+	if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
+		util_fw_version = UTIL_FW_VERSION;
+		fcopy_srv_version = WIN8_SRV_VERSION;
+		vmbus_prep_negotiate_resp(icmsghdrp, negop, recv_buffer,
+				util_fw_version, fcopy_srv_version);
+	} else {
+		fcopy_msg = (struct hv_fcopy_hdr *)&recv_buffer[
+				sizeof(struct vmbuspipe_hdr) +
+				sizeof(struct icmsg_hdr)];
+
+		/*
+		 * Stash away this global state for completing the
+		 * transaction; note transactions are serialized.
+		 */
+
+		fcopy_transaction.active = true;
+		fcopy_transaction.recv_len = recvlen;
+		fcopy_transaction.recv_channel = channel;
+		fcopy_transaction.recv_req_id = requestid;
+		fcopy_transaction.fcopy_msg = fcopy_msg;
+
+		/*
+		 * Send the information to the user-level daemon.
+		 */
+		fcopy_send_data();
+		schedule_delayed_work(&fcopy_work, 5*HZ);
+		return;
+	}
+	icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION | ICMSGHDRFLAG_RESPONSE;
+	vmbus_sendpacket(channel, recv_buffer, recvlen, requestid,
+			VM_PKT_DATA_INBAND, 0);
+}
+
+/*
+ * Create a char device that can support read/write for passing
+ * the payload.
+ */
+static struct cdev fcopy_cdev;
+static struct class *cl;
+static struct device *sysfs_dev;
+
+static ssize_t fcopy_read(struct file *file, char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	int ret;
+	void *src;
+	size_t copy_size;
+	int operation;
+
+	/*
+	 * Wait until there is something to be read.
+	 */
+	ret = down_interruptible(&fcopy_transaction.read_sema);
+	if (ret)
+		return -EINTR;
+
+	operation = fcopy_transaction.fcopy_msg->operation;
+
+	if (operation == START_FILE_COPY) {
+		src = &fcopy_transaction.message;
+		copy_size = sizeof(struct hv_start_fcopy);
+		if (count < copy_size)
+			return 0;
+	} else {
+		src = fcopy_transaction.fcopy_msg;
+		copy_size = sizeof(struct hv_do_fcopy);
+		if (count < copy_size)
+			return 0;
+	}
+	if (copy_to_user(buf, src, copy_size))
+		return -EFAULT;
+
+	return copy_size;
+}
+
+static ssize_t fcopy_write(struct file *file, const char __user *buf,
+			size_t count, loff_t *ppos)
+{
+	int error = 0;
+
+	if (count != sizeof(int))
+		return 0;
+
+	if (copy_from_user(&error, buf, sizeof(int)))
+		return -EFAULT;
+
+	if (in_hand_shake) {
+		fcopy_handle_handshake();
+		return 0;
+	}
+
+	/*
+	 * Complete the transaction by forwarding the result
+	 * to the host. But first, cancel the timeout.
+	 */
+	if (cancel_delayed_work_sync(&fcopy_work))
+		fcopy_respond_to_host(error);
+
+	return sizeof(int);
+}
+
+int fcopy_open(struct inode *inode, struct file *f)
+{
+	if (opened)
+		return -EBUSY;
+
+	/*
+	 * The daemon is alive; setup the state.
+	 */
+	daemon_died = false;
+	opened = true;
+	dtp = current;
+	return 0;
+}
+
+int fcopy_release(struct inode *inode, struct file *f)
+{
+	/*
+	 * The daemon has exited; reset the state.
+	 */
+	daemon_died = true;
+	in_hand_shake = true;
+	dtp = NULL;
+	opened = false;
+	return 0;
+}
+
+
+static const struct file_operations fcopy_fops = {
+	.read           = fcopy_read,
+	.write          = fcopy_write,
+	.release	= fcopy_release,
+	.open		= fcopy_open,
+};
+
+static int fcopy_dev_init(void)
+{
+	int result;
+
+	result = alloc_chrdev_region(&fcopy_dev, 1, 1, "hv_fcopy");
+	if (result < 0) {
+		pr_err("Cannot get major number\n");
+		return result;
+	}
+
+	cl = class_create(THIS_MODULE, "chardev");
+	if (IS_ERR(cl)) {
+		pr_err("Error creating fcopy class.\n");
+		result = PTR_ERR(cl);
+		goto err_unregister;
+	}
+
+	sysfs_dev = device_create(cl, NULL, fcopy_dev, "%s", "hv_fcopy");
+	if (IS_ERR(sysfs_dev)) {
+		pr_err("Device creation failed\n");
+		result = PTR_ERR(cl);
+		goto err_destroy_class;
+	}
+
+	cdev_init(&fcopy_cdev, &fcopy_fops);
+	fcopy_cdev.owner = THIS_MODULE;
+	fcopy_cdev.ops = &fcopy_fops;
+
+	result = cdev_add(&fcopy_cdev, fcopy_dev, 1);
+	if (result) {
+		pr_err("Cannot cdev_add\n");
+		goto err_destroy_device;
+	}
+	return result;
+
+err_destroy_device:
+	device_destroy(cl, fcopy_dev);
+err_destroy_class:
+	class_destroy(cl);
+err_unregister:
+	unregister_chrdev_region(fcopy_dev, 1);
+	return result;
+}
+
+static void fcopy_dev_deinit(void)
+{
+	/*
+	 * first kill the daemon.
+	 */
+	if (dtp != NULL)
+		send_sig(SIGKILL, dtp, 0);
+	opened = false;
+	device_destroy(cl, fcopy_dev);
+	class_destroy(cl);
+	cdev_del(&fcopy_cdev);
+	unregister_chrdev_region(fcopy_dev, 1);
+}
+
+int hv_fcopy_init(struct hv_util_service *srv)
+{
+	recv_buffer = srv->recv_buffer;
+
+	/*
+	 * When this driver loads, the user level daemon that
+	 * processes the host requests may not yet be running.
+	 * Defer processing channel callbacks until the daemon
+	 * has registered.
+	 */
+	fcopy_transaction.active = true;
+	sema_init(&fcopy_transaction.read_sema, 0);
+
+	return fcopy_dev_init();
+}
+
+void hv_fcopy_deinit(void)
+{
+	cancel_delayed_work_sync(&fcopy_work);
+	fcopy_dev_deinit();
+}
diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index 62dfd246..efc5e83 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -82,6 +82,12 @@ static struct hv_util_service util_vss = {
 	.util_deinit = hv_vss_deinit,
 };
 
+static struct hv_util_service util_fcopy = {
+	.util_cb = hv_fcopy_onchannelcallback,
+	.util_init = hv_fcopy_init,
+	.util_deinit = hv_fcopy_deinit,
+};
+
 static void perform_shutdown(struct work_struct *dummy)
 {
 	orderly_poweroff(true);
@@ -401,6 +407,10 @@ static const struct hv_vmbus_device_id id_table[] = {
 	{ HV_VSS_GUID,
 	  .driver_data = (unsigned long)&util_vss
 	},
+	/* File copy GUID */
+	{ HV_FCOPY_GUID,
+	  .driver_data = (unsigned long)&util_fcopy
+	},
 	{ },
 };
 
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 15da677..e573ae9 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -26,6 +26,8 @@
 #define _HYPERV_H
 
 #include <linux/types.h>
+#include <linux/uuid.h>
+#include <linux/limits.h>
 
 /*
  * Framework version for util services.
@@ -96,6 +98,49 @@ struct hv_vss_msg {
 } __attribute__((packed));
 
 /*
+ * Implementation of a host to guest copy facility.
+ */
+
+#define W_MAX_PATH 260
+
+enum hv_fcopy_op {
+	START_FILE_COPY = 0,
+	WRITE_TO_FILE,
+	COMPLETE_FCOPY,
+	CANCEL_FCOPY,
+};
+
+struct hv_fcopy_hdr {
+	enum hv_fcopy_op operation;
+	uuid_le service_id0; /* currently unused */
+	uuid_le service_id1; /* currently unused */
+} __attribute__((packed));
+
+#define OVER_WRITE	0x1
+#define CREATE_PATH	0x2
+
+struct hv_start_fcopy {
+	struct hv_fcopy_hdr hdr;
+	__u16 file_name[W_MAX_PATH];
+	__u16 path_name[W_MAX_PATH];
+	__u32 copy_flags;
+	__u64 file_size;
+} __attribute__((packed));
+
+/*
+ * The file is chunked into fragments.
+ */
+#define DATA_FRAGMENT	(6 * 1024)
+
+struct hv_do_fcopy {
+	struct hv_fcopy_hdr hdr;
+	__u64	offset;
+	__u32	size;
+	__u8	data[DATA_FRAGMENT];
+};
+
+
+/*
  * An implementation of HyperV key value pair (KVP) functionality for Linux.
  *
  *
@@ -1352,6 +1397,17 @@ void vmbus_driver_unregister(struct hv_driver *hv_driver);
 		}
 
 /*
+ * Guest File Copy Service
+ * {34D14BE3-DEE4-41c8-9AE7-6B174977C192}
+ */
+
+#define HV_FCOPY_GUID \
+	.guid = { \
+			0xE3, 0x4B, 0xD1, 0x34, 0xE4, 0xDE, 0xC8, 0x41, \
+			0x9A, 0xE7, 0x6B, 0x17, 0x49, 0x77, 0xC1, 0x92 \
+		}
+
+/*
  * Common header for Hyper-V ICs
  */
 
@@ -1459,6 +1515,10 @@ int hv_vss_init(struct hv_util_service *);
 void hv_vss_deinit(void);
 void hv_vss_onchannelcallback(void *);
 
+int hv_fcopy_init(struct hv_util_service *);
+void hv_fcopy_deinit(void);
+void hv_fcopy_onchannelcallback(void *);
+
 /*
  * Negotiated version with the Host.
  */
diff --git a/tools/hv/hv_fcopy_daemon.c b/tools/hv/hv_fcopy_daemon.c
new file mode 100644
index 0000000..c0e5c90
--- /dev/null
+++ b/tools/hv/hv_fcopy_daemon.c
@@ -0,0 +1,174 @@
+/*
+ * An implementation of host to guest copy functionality for Linux.
+ *
+ * Copyright (C) 2014, Microsoft, Inc.
+ *
+ * Author : K. Y. Srinivasan <kys@microsoft.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ */
+
+
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <sys/poll.h>
+#include <linux/types.h>
+#include <linux/kdev_t.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <ctype.h>
+#include <errno.h>
+#include <linux/hyperv.h>
+#include <syslog.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <dirent.h>
+
+static int target_fd;
+char target_fname[W_MAX_PATH];
+
+static int hv_start_fcopy(struct hv_start_fcopy *smsg)
+{
+	int error = HV_E_FAIL;
+
+	sprintf(target_fname, "%s%s%s", smsg->path_name, "/",
+		smsg->file_name);
+
+	syslog(LOG_INFO, "Target file name: %s\n", target_fname);
+	/*
+	 * Check to see if the path is already in place; if not,
+	 * create if required.
+	 */
+	if (access((char *)smsg->path_name, F_OK)) {
+		if (smsg->copy_flags & CREATE_PATH) {
+			if (mkdir((char *)smsg->path_name, 0755)) {
+				syslog(LOG_ERR,
+					"Failed to create '%s'; error: %d %s\n",
+					smsg->path_name,
+					errno, strerror(errno));
+				goto done;
+			}
+		} else {
+			syslog(LOG_ERR, "Invalid path: %s\n", smsg->path_name);
+			goto done;
+		}
+	}
+
+	if (!access(target_fname, F_OK)) {
+		syslog(LOG_INFO, "File: %s exists\n", target_fname);
+		if (!smsg->copy_flags & OVER_WRITE)
+			goto done;
+	}
+
+	target_fd = open(target_fname, O_RDWR | O_CREAT | O_CLOEXEC, 0744);
+	if (target_fd == -1) {
+		syslog(LOG_INFO, "Open Failed: %s\n", strerror(errno));
+		goto done;
+	}
+
+	error = 0;
+done:
+	return error;
+}
+
+static int hv_copy_data(struct hv_do_fcopy *cpmsg)
+{
+	ssize_t bytes_written;
+
+	bytes_written = pwrite(target_fd, cpmsg->data, cpmsg->size,
+				cpmsg->offset);
+
+	if (bytes_written != cpmsg->size)
+		return HV_E_FAIL;
+
+	return 0;
+}
+
+static int hv_copy_finished(void)
+{
+	close(target_fd);
+	return 0;
+}
+static int hv_copy_cancel(void)
+{
+	close(target_fd);
+	unlink(target_fname);
+	return 0;
+
+}
+
+int main(void)
+{
+	int fd, fcopy_fd, len;
+	int error = 0;
+	int version = 0;
+	char *buffer[4096 * 2];
+	struct hv_fcopy_hdr *in_msg;
+
+	daemon(1, 0);
+	openlog("HV_FCOPY", 0, LOG_USER);
+	syslog(LOG_INFO, "HV_FCOPY starting; pid is:%d", getpid());
+
+	fcopy_fd = open("/dev/hv_fcopy", O_RDWR);
+
+	if (fcopy_fd < 0) {
+		syslog(LOG_ERR, "open /dev/hv_fcopy failed; error: %d %s",
+			errno, strerror(errno));
+		exit(EXIT_FAILURE);
+	}
+
+	/*
+	 * Register with the kernel.
+	 */
+	write(fcopy_fd, &version, sizeof(int));
+
+	while (1) {
+		/*
+		 * In this loop we process fcopy messages after the
+		 * handshake is complete.
+		 */
+
+		len = pread(fcopy_fd, buffer, (4096 * 2), 0);
+		if (len <= 0) {
+			if (!error) {
+				syslog(LOG_ERR, "Read error: %s\n",
+					 strerror(errno));
+				error = HV_E_FAIL;
+			}
+			continue;
+		}
+		in_msg = (struct hv_fcopy_hdr *)buffer;
+
+		switch (in_msg->operation) {
+		case START_FILE_COPY:
+			error = hv_start_fcopy((struct hv_start_fcopy *)in_msg);
+			break;
+		case WRITE_TO_FILE:
+			error = hv_copy_data((struct hv_do_fcopy *)in_msg);
+			break;
+		case COMPLETE_FCOPY:
+			error = hv_copy_finished();
+			break;
+		case CANCEL_FCOPY:
+			error = hv_copy_cancel();
+			break;
+
+		default:
+			syslog(LOG_ERR, "Unknown operation: %d\n",
+				in_msg->operation);
+
+		}
+
+		pwrite(fcopy_fd, &error, sizeof(int), 0);
+	}
+}
-- 
1.7.4.1

