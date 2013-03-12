Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194Ab3CLR7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 13:59:32 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:51991
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932284Ab3CLR7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 13:59:31 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: Add a new driver to support host initiated backup
Date: Tue, 12 Mar 2013 11:29:19 -0700
Message-Id: <1363112959-30386-1-git-send-email-kys@microsoft.com>
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

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/Makefile            |    2 +-
 drivers/hv/hv_util.c           |   10 ++++++
 include/linux/hyperv.h         |   69 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/connector.h |    5 ++-
 4 files changed, 84 insertions(+), 2 deletions(-)

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
-- 
1.7.4.1

