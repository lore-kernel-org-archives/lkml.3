Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab3COB01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 21:26:27 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:57803
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626Ab3COB0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 21:26:25 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH V2 1/1] Drivers: hv: Add a new driver to support host initiated backup
Date: Thu, 14 Mar 2013 18:56:17 -0700
Message-Id: <1363312577-14698-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver supports host initiated backup of the guest. On Windows guests,
the host can generate application consistent backups using the Windows VSS
framework. On Linux, we ensure that the backup will be file system consistent.
This driver allows the host to initiate a  "Freeze" operation on all the mounted
file systems in the guest. Once the mounted file systems in the guest are frozen,
the host snapshots the guest's file systems. Once this is done, the guest's file
systems are "thawed".

This driver has a user-level component (daemon) that invokes the appropriate
operation on all the mounted file systems in response to the requests from
the host. The duration for which the guest is frozen is very short - a few seconds.
During this interval, the diff disk is comitted.

In this version of the patch I have addressed the feedback from Olaf Herring.
Also, some of the connector related issues have been fixed.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/hv/Makefile            |    2 +-
 drivers/hv/hv_snapshot.c       |  287 ++++++++++++++++++++++++++++++++++++++++
 drivers/hv/hv_util.c           |   10 ++
 include/linux/hyperv.h         |   69 ++++++++++
 include/uapi/linux/connector.h |    5 +-
 tools/hv/hv_vss_daemon.c       |  220 ++++++++++++++++++++++++++++++
 6 files changed, 591 insertions(+), 2 deletions(-)
 create mode 100644 drivers/hv/hv_snapshot.c
 create mode 100644 tools/hv/hv_vss_daemon.c

diff --git a/drivers/hv/Makefile b/drivers/hv/Makefile
index e6abfa0..0a74b56 100644
--- a/drivers/hv/Makefile
+++ b/drivers/hv/Makefile
@@ -5,4 +5,4 @@ obj-$(CONFIG_HYPERV_BALLOON)	+= hv_balloon.o
 hv_vmbus-y := vmbus_drv.o \
 		 hv.o connection.o channel.o \
 		 channel_mgmt.o ring_buffer.o
-hv_utils-y := hv_util.o hv_kvp.o
+hv_utils-y := hv_util.o hv_kvp.o hv_snapshot.o
diff --git a/drivers/hv/hv_snapshot.c b/drivers/hv/hv_snapshot.c
new file mode 100644
index 0000000..8ad5653
--- /dev/null
+++ b/drivers/hv/hv_snapshot.c
@@ -0,0 +1,287 @@
+/*
+ * An implementation of host initiated guest snapshot.
+ *
+ *
+ * Copyright (C) 2013, Microsoft, Inc.
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
+ *
+ */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/net.h>
+#include <linux/nls.h>
+#include <linux/connector.h>
+#include <linux/workqueue.h>
+#include <linux/hyperv.h>
+
+
+
+/*
+ * Global state maintained for transaction that is being processed.
+ * Note that only one transaction can be active at any point in time.
+ *
+ * This state is set when we receive a request from the host; we
+ * cleanup this state when the transaction is completed - when we respond
+ * to the host with the key value.
+ */
+
+static struct {
+	bool active; /* transaction status - active or not */
+	int recv_len; /* number of bytes received. */
+	struct vmbus_channel *recv_channel; /* chn we got the request */
+	u64 recv_req_id; /* request ID. */
+	struct hv_vss_msg  *msg; /* current message */
+} vss_transaction;
+
+
+static void vss_respond_to_host(int error);
+
+static struct cb_id vss_id = { CN_VSS_IDX, CN_VSS_VAL };
+static const char vss_name[] = "vss_kernel_module";
+static __u8 *recv_buffer;
+
+static void vss_send_op(struct work_struct *dummy);
+static DECLARE_WORK(vss_send_op_work, vss_send_op);
+
+/*
+ * Callback when data is received from user mode.
+ */
+
+static void
+vss_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
+{
+	struct hv_vss_msg *vss_msg;
+
+	vss_msg = (struct hv_vss_msg *)msg->data;
+
+	if (vss_msg->vss_hdr.operation == VSS_OP_REGISTER) {
+		pr_info("VSS daemon registered\n");
+		vss_transaction.active = false;
+		if (vss_transaction.recv_channel != NULL)
+			hv_vss_onchannelcallback(vss_transaction.recv_channel);
+		return;
+
+	}
+	vss_respond_to_host(vss_msg->error);
+}
+
+
+static void vss_send_op(struct work_struct *dummy)
+{
+	int op = vss_transaction.msg->vss_hdr.operation;
+	struct cn_msg *msg;
+	struct hv_vss_msg *vss_msg;
+
+	msg = kzalloc(sizeof(*msg) + sizeof(*vss_msg), GFP_ATOMIC);
+	if (!msg)
+		return;
+
+	vss_msg = (struct hv_vss_msg *)msg->data;
+
+	msg->id.idx =  CN_VSS_IDX;
+	msg->id.val = CN_VSS_VAL;
+
+	vss_msg->vss_hdr.operation = op;
+	msg->len = sizeof(struct hv_vss_msg);
+
+	cn_netlink_send(msg, 0, GFP_ATOMIC);
+	kfree(msg);
+
+	return;
+}
+
+/*
+ * Send a response back to the host.
+ */
+
+static void
+vss_respond_to_host(int error)
+{
+	struct icmsg_hdr *icmsghdrp;
+	u32	buf_len;
+	struct vmbus_channel *channel;
+	u64	req_id;
+
+	/*
+	 * If a transaction is not active; log and return.
+	 */
+
+	if (!vss_transaction.active) {
+		/*
+		 * This is a spurious call!
+		 */
+		pr_warn("VSS: Transaction not active\n");
+		return;
+	}
+	/*
+	 * Copy the global state for completing the transaction. Note that
+	 * only one transaction can be active at a time.
+	 */
+
+	buf_len = vss_transaction.recv_len;
+	channel = vss_transaction.recv_channel;
+	req_id = vss_transaction.recv_req_id;
+	vss_transaction.active = false;
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
+
+	icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION | ICMSGHDRFLAG_RESPONSE;
+
+	vmbus_sendpacket(channel, recv_buffer, buf_len, req_id,
+				VM_PKT_DATA_INBAND, 0);
+
+}
+
+/*
+ * This callback is invoked when we get a VSS message from the host.
+ * The host ensures that only one VSS transaction can be active at a time.
+ */
+
+void hv_vss_onchannelcallback(void *context)
+{
+	struct vmbus_channel *channel = context;
+	u32 recvlen;
+	u64 requestid;
+	struct hv_vss_msg *vss_msg;
+
+
+	struct icmsg_hdr *icmsghdrp;
+	struct icmsg_negotiate *negop = NULL;
+
+	if (vss_transaction.active) {
+		/*
+		 * We will defer processing this callback once
+		 * the current transaction is complete.
+		 */
+		vss_transaction.recv_channel = channel;
+		return;
+	}
+
+	vmbus_recvpacket(channel, recv_buffer, PAGE_SIZE * 2, &recvlen,
+			 &requestid);
+
+	if (recvlen > 0) {
+		icmsghdrp = (struct icmsg_hdr *)&recv_buffer[
+			sizeof(struct vmbuspipe_hdr)];
+
+		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
+			vmbus_prep_negotiate_resp(icmsghdrp, negop,
+				 recv_buffer, MAX_SRV_VER, MAX_SRV_VER);
+			/*
+			 * We currently negotiate the highest number the
+			 * host has presented. If this version is not
+			 * atleast 5.0, reject.
+			 */
+			negop = (struct icmsg_negotiate *)&recv_buffer[
+				sizeof(struct vmbuspipe_hdr) +
+				sizeof(struct icmsg_hdr)];
+
+			if (negop->icversion_data[1].major < 5)
+				negop->icframe_vercnt = 0;
+		} else {
+			vss_msg = (struct hv_vss_msg *)&recv_buffer[
+				sizeof(struct vmbuspipe_hdr) +
+				sizeof(struct icmsg_hdr)];
+
+			/*
+			 * Stash away this global state for completing the
+			 * transaction; note transactions are serialized.
+			 */
+
+			vss_transaction.recv_len = recvlen;
+			vss_transaction.recv_channel = channel;
+			vss_transaction.recv_req_id = requestid;
+			vss_transaction.active = true;
+			vss_transaction.msg = (struct hv_vss_msg *)vss_msg;
+
+			switch (vss_msg->vss_hdr.operation) {
+				/*
+				 * Initiate a "freeze/thaw"
+				 * operation in the guest.
+				 * We respond to the host once
+				 * the operation is complete.
+				 *
+				 * We send the message to the
+				 * user space daemon and the
+				 * operation is performed in
+				 * the daemon.
+				 */
+			case VSS_OP_FREEZE:
+			case VSS_OP_THAW:
+				schedule_work(&vss_send_op_work);
+				return;
+
+			case VSS_OP_HOT_BACKUP:
+				vss_msg->vss_cf.flags =
+					 VSS_HBU_NO_AUTO_RECOVERY;
+				vss_respond_to_host(0);
+				return;
+
+			case VSS_OP_GET_DM_INFO:
+				vss_msg->dm_info.flags = 0;
+				vss_respond_to_host(0);
+				return;
+
+			default:
+				vss_respond_to_host(0);
+				return;
+
+			}
+
+		}
+
+		icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION
+			| ICMSGHDRFLAG_RESPONSE;
+
+		vmbus_sendpacket(channel, recv_buffer,
+				       recvlen, requestid,
+				       VM_PKT_DATA_INBAND, 0);
+	}
+
+}
+
+int
+hv_vss_init(struct hv_util_service *srv)
+{
+	int err;
+
+	err = cn_add_callback(&vss_id, vss_name, vss_cn_callback);
+	if (err)
+		return err;
+	recv_buffer = srv->recv_buffer;
+
+	/*
+	 * When this driver loads, the user level daemon that
+	 * processes the host requests may not yet be running.
+	 * Defer processing channel callbacks until the daemon
+	 * has registered.
+	 */
+	vss_transaction.active = true;
+	return 0;
+}
+
+void hv_vss_deinit(void)
+{
+	cn_del_callback(&vss_id);
+	cancel_work_sync(&vss_send_op_work);
+}
diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index 1d4cbd8..2f561c5 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -49,6 +49,12 @@ static struct hv_util_service util_kvp = {
 	.util_deinit = hv_kvp_deinit,
 };
 
+static struct hv_util_service util_vss = {
+	.util_cb = hv_vss_onchannelcallback,
+	.util_init = hv_vss_init,
+	.util_deinit = hv_vss_deinit,
+};
+
 static void perform_shutdown(struct work_struct *dummy)
 {
 	orderly_poweroff(true);
@@ -339,6 +345,10 @@ static const struct hv_vmbus_device_id id_table[] = {
 	{ HV_KVP_GUID,
 	  .driver_data = (unsigned long)&util_kvp
 	},
+	/* VSS GUID */
+	{ HV_VSS_GUID,
+	  .driver_data = (unsigned long)&util_vss
+	},
 	{ },
 };
 
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index df77ba9..95d0850 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -27,6 +27,63 @@
 
 #include <linux/types.h>
 
+
+/*
+ * Implementation of host controlled snapshot of the guest.
+ */
+
+#define VSS_OP_REGISTER 128
+
+enum hv_vss_op {
+	VSS_OP_CREATE = 0,
+	VSS_OP_DELETE,
+	VSS_OP_HOT_BACKUP,
+	VSS_OP_GET_DM_INFO,
+	VSS_OP_BU_COMPLETE,
+	/*
+	 * Following operations are only supported with IC version >= 5.0
+	 */
+	VSS_OP_FREEZE, /* Freeze the file systems in the VM */
+	VSS_OP_THAW, /* Unfreeze the file systems */
+	VSS_OP_AUTO_RECOVER,
+	VSS_OP_COUNT /* Number of operations, must be last */
+};
+
+
+/*
+ * Header for all VSS messages.
+ */
+struct hv_vss_hdr {
+	__u8 operation;
+	__u8 reserved[7];
+} __attribute__((packed));
+
+
+/*
+ * Flag values for the hv_vss_check_feature. Linux supports only
+ * one value.
+ */
+#define VSS_HBU_NO_AUTO_RECOVERY	0x00000005
+
+struct hv_vss_check_feature {
+	__u32 flags;
+} __attribute__((packed));
+
+struct hv_vss_check_dm_info {
+	__u32 flags;
+} __attribute__((packed));
+
+struct hv_vss_msg {
+	union {
+		struct hv_vss_hdr vss_hdr;
+		int error;
+	};
+	union {
+		struct hv_vss_check_feature vss_cf;
+		struct hv_vss_check_dm_info dm_info;
+	};
+} __attribute__((packed));
+
 /*
  * An implementation of HyperV key value pair (KVP) functionality for Linux.
  *
@@ -1253,6 +1310,14 @@ void vmbus_driver_unregister(struct hv_driver *hv_driver);
 		}
 
 /*
+ * VSS (Backup/Restore) GUID
+ */
+#define HV_VSS_GUID \
+	.guid = { \
+			0x29, 0x2e, 0xfa, 0x35, 0x23, 0xea, 0x36, 0x42, \
+			0x96, 0xae, 0x3a, 0x6e, 0xba, 0xcb, 0xa4,  0x40 \
+		}
+/*
  * Common header for Hyper-V ICs
  */
 
@@ -1356,6 +1421,10 @@ int hv_kvp_init(struct hv_util_service *);
 void hv_kvp_deinit(void);
 void hv_kvp_onchannelcallback(void *);
 
+int hv_vss_init(struct hv_util_service *);
+void hv_vss_deinit(void);
+void hv_vss_onchannelcallback(void *);
+
 /*
  * Negotiated version with the Host.
  */
diff --git a/include/uapi/linux/connector.h b/include/uapi/linux/connector.h
index 8761a03..4cb2835 100644
--- a/include/uapi/linux/connector.h
+++ b/include/uapi/linux/connector.h
@@ -44,8 +44,11 @@
 #define CN_VAL_DRBD			0x1
 #define CN_KVP_IDX			0x9	/* HyperV KVP */
 #define CN_KVP_VAL			0x1	/* queries from the kernel */
+#define CN_VSS_IDX			0xA     /* HyperV VSS */
+#define CN_VSS_VAL			0x1     /* queries from the kernel */
 
-#define CN_NETLINK_USERS		10	/* Highest index + 1 */
+
+#define CN_NETLINK_USERS		11	/* Highest index + 1 */
 
 /*
  * Maximum connector's message size.
diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
new file mode 100644
index 0000000..9526995
--- /dev/null
+++ b/tools/hv/hv_vss_daemon.c
@@ -0,0 +1,220 @@
+/*
+ * An implementation of the host initiated guest snapshot for Hyper-V.
+ *
+ *
+ * Copyright (C) 2013, Microsoft, Inc.
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
+ *
+ */
+
+
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <sys/poll.h>
+#include <linux/types.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <ctype.h>
+#include <errno.h>
+#include <arpa/inet.h>
+#include <linux/connector.h>
+#include <linux/hyperv.h>
+#include <linux/netlink.h>
+#include <syslog.h>
+
+static char vss_recv_buffer[4096];
+static char vss_send_buffer[4096];
+static struct sockaddr_nl addr;
+
+#ifndef SOL_NETLINK
+#define SOL_NETLINK 270
+#endif
+
+
+static int vss_operate(int operation)
+{
+	char *fs_op;
+	char cmd[512];
+	char buf[512];
+	FILE *file;
+	char *p;
+	char *x;
+	int error;
+
+	switch (operation) {
+	case VSS_OP_FREEZE:
+		fs_op = "-f ";
+		break;
+	case VSS_OP_THAW:
+		fs_op = "-u ";
+		break;
+	}
+
+	file = popen("mount | awk '/^\/dev\// { print $3}'", "r");
+	if (file == NULL)
+		return;
+
+	while ((p = fgets(buf, sizeof(buf), file)) != NULL) {
+		x = strchr(p, '\n');
+		*x = '\0';
+		if (!strncmp(p, "/", sizeof("/")))
+			continue;
+
+		sprintf(cmd, "%s %s %s", "fsfreeze ", fs_op, p);
+		syslog(LOG_INFO, "VSS cmd is %s\n", cmd);
+		error = system(cmd);
+	}
+	pclose(file);
+
+	sprintf(cmd, "%s %s %s", "fsfreeze ", fs_op, "/");
+	syslog(LOG_INFO, "VSS cmd is %s\n", cmd);
+	error = system(cmd);
+
+	return error;
+}
+
+static int netlink_send(int fd, struct cn_msg *msg)
+{
+	struct nlmsghdr *nlh;
+	unsigned int size;
+	struct msghdr message;
+	char buffer[64];
+	struct iovec iov[2];
+
+	size = NLMSG_SPACE(sizeof(struct cn_msg) + msg->len);
+
+	nlh = (struct nlmsghdr *)buffer;
+	nlh->nlmsg_seq = 0;
+	nlh->nlmsg_pid = getpid();
+	nlh->nlmsg_type = NLMSG_DONE;
+	nlh->nlmsg_len = NLMSG_LENGTH(size - sizeof(*nlh));
+	nlh->nlmsg_flags = 0;
+
+	iov[0].iov_base = nlh;
+	iov[0].iov_len = sizeof(*nlh);
+
+	iov[1].iov_base = msg;
+	iov[1].iov_len = size;
+
+	memset(&message, 0, sizeof(message));
+	message.msg_name = &addr;
+	message.msg_namelen = sizeof(addr);
+	message.msg_iov = iov;
+	message.msg_iovlen = 2;
+
+	return sendmsg(fd, &message, 0);
+}
+
+int main(void)
+{
+	int fd, len, nl_group;
+	int error;
+	struct cn_msg *message;
+	struct pollfd pfd;
+	struct nlmsghdr *incoming_msg;
+	struct cn_msg	*incoming_cn_msg;
+	int	op;
+	struct hv_vss_msg *vss_msg;
+
+	daemon(1, 0);
+	openlog("Hyper-V VSS", 0, LOG_USER);
+	syslog(LOG_INFO, "VSS starting; pid is:%d", getpid());
+
+	fd = socket(AF_NETLINK, SOCK_DGRAM, NETLINK_CONNECTOR);
+	if (fd < 0) {
+		syslog(LOG_ERR, "netlink socket creation failed; error:%d", fd);
+		exit(EXIT_FAILURE);
+	}
+	addr.nl_family = AF_NETLINK;
+	addr.nl_pad = 0;
+	addr.nl_pid = 0;
+	addr.nl_groups = 0;
+
+
+	error = bind(fd, (struct sockaddr *)&addr, sizeof(addr));
+	if (error < 0) {
+		syslog(LOG_ERR, "bind failed; error:%d", error);
+		close(fd);
+		exit(EXIT_FAILURE);
+	}
+	nl_group = CN_VSS_IDX;
+	setsockopt(fd, SOL_NETLINK, NETLINK_ADD_MEMBERSHIP, &nl_group, sizeof(nl_group));
+	/*
+	 * Register ourselves with the kernel.
+	 */
+	message = (struct cn_msg *)vss_send_buffer;
+	message->id.idx = CN_VSS_IDX;
+	message->id.val = CN_VSS_VAL;
+	message->ack = 0;
+	vss_msg = (struct hv_vss_msg *)message->data;
+	vss_msg->vss_hdr.operation = VSS_OP_REGISTER;
+
+	message->len = sizeof(struct hv_vss_msg);
+
+	len = netlink_send(fd, message);
+	if (len < 0) {
+		syslog(LOG_ERR, "netlink_send failed; error:%d", len);
+		close(fd);
+		exit(EXIT_FAILURE);
+	}
+
+	pfd.fd = fd;
+
+	while (1) {
+		struct sockaddr *addr_p = (struct sockaddr *) &addr;
+		socklen_t addr_l = sizeof(addr);
+		pfd.events = POLLIN;
+		pfd.revents = 0;
+		poll(&pfd, 1, -1);
+
+		len = recvfrom(fd, vss_recv_buffer, sizeof(vss_recv_buffer), 0,
+				addr_p, &addr_l);
+
+		if (len < 0 || addr.nl_pid) {
+			syslog(LOG_ERR, "recvfrom failed; pid:%u error:%d %s",
+					addr.nl_pid, errno, strerror(errno));
+			close(fd);
+			return -1;
+		}
+
+		incoming_msg = (struct nlmsghdr *)vss_recv_buffer;
+
+		if (incoming_msg->nlmsg_type != NLMSG_DONE)
+			continue;
+
+		incoming_cn_msg = (struct cn_msg *)NLMSG_DATA(incoming_msg);
+		vss_msg = (struct hv_vss_msg *)incoming_cn_msg->data;
+		op = vss_msg->vss_hdr.operation;
+		error =  HV_S_OK;
+
+		switch (op) {
+		case VSS_OP_FREEZE:
+		case VSS_OP_THAW:
+			error = vss_operate(op);
+			if (error)
+				error = HV_E_FAIL;
+			break;
+		default:
+			syslog(LOG_ERR, "Illegal op:%d\n", op);
+		}
+		vss_msg->error = error;
+		len = netlink_send(fd, incoming_cn_msg);
+		if (len < 0) {
+			syslog(LOG_ERR, "net_link send failed; error:%d", len);
+			exit(EXIT_FAILURE);
+		}
+	}
+
+}
-- 
1.7.4.1

