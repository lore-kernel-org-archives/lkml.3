Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab3IFSJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 14:09:00 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:47828
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123Ab3IFSIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 14:08:54 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: util: Correctly support ws2008R2 and earlier
Date: Fri,  6 Sep 2013 11:49:56 -0700
Message-Id: <1378493396-7266-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code does not correctly negotiate the version numbers for the util
driver when hosted on earlier hosts. The version numbers presented by this
driver were not compatible with the version numbers supported by Windows Server
2008. Fix this problem.

I would like to thank Olaf Hering (ohering@suse.com) for identifying the problem.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/hv_kvp.c      |   38 +++++++++++++++++--------
 drivers/hv/hv_snapshot.c |    6 ++--
 drivers/hv/hv_util.c     |   71 +++++++++++++++++++++++++++++++++++-----------
 include/linux/hyperv.h   |    7 +++-
 4 files changed, 88 insertions(+), 34 deletions(-)

diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index 28b0332..09988b2 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -32,13 +32,17 @@
 /*
  * Pre win8 version numbers used in ws2008 and ws 2008 r2 (win7)
  */
+#define WS2008_SRV_MAJOR	1
+#define WS2008_SRV_MINOR	0
+#define WS2008_SRV_VERSION     (WS2008_SRV_MAJOR << 16 | WS2008_SRV_MINOR)
+
 #define WIN7_SRV_MAJOR   3
 #define WIN7_SRV_MINOR   0
-#define WIN7_SRV_MAJOR_MINOR     (WIN7_SRV_MAJOR << 16 | WIN7_SRV_MINOR)
+#define WIN7_SRV_VERSION     (WIN7_SRV_MAJOR << 16 | WIN7_SRV_MINOR)
 
 #define WIN8_SRV_MAJOR   4
 #define WIN8_SRV_MINOR   0
-#define WIN8_SRV_MAJOR_MINOR     (WIN8_SRV_MAJOR << 16 | WIN8_SRV_MINOR)
+#define WIN8_SRV_VERSION     (WIN8_SRV_MAJOR << 16 | WIN8_SRV_MINOR)
 
 /*
  * Global state maintained for transaction that is being processed.
@@ -587,6 +591,8 @@ void hv_kvp_onchannelcallback(void *context)
 
 	struct icmsg_hdr *icmsghdrp;
 	struct icmsg_negotiate *negop = NULL;
+	int util_fw_version;
+	int kvp_srv_version;
 
 	if (kvp_transaction.active) {
 		/*
@@ -606,17 +612,26 @@ void hv_kvp_onchannelcallback(void *context)
 
 		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
 			/*
-			 * We start with win8 version and if the host cannot
-			 * support that we use the previous version.
+			 * Based on the host, select appropriate
+			 * framework and service versions we will
+			 * negotiate.
 			 */
-			if (vmbus_prep_negotiate_resp(icmsghdrp, negop,
-				 recv_buffer, UTIL_FW_MAJOR_MINOR,
-				 WIN8_SRV_MAJOR_MINOR))
-				goto done;
-
+			switch (vmbus_proto_version) {
+			case (VERSION_WS2008):
+				util_fw_version = UTIL_WS2K8_FW_VERSION;
+				kvp_srv_version = WS2008_SRV_VERSION;
+				break;
+			case (VERSION_WIN7):
+				util_fw_version = UTIL_FW_VERSION;
+				kvp_srv_version = WIN7_SRV_VERSION;
+				break;
+			default:
+				util_fw_version = UTIL_FW_VERSION;
+				kvp_srv_version = WIN8_SRV_VERSION;
+			}
 			vmbus_prep_negotiate_resp(icmsghdrp, negop,
-				 recv_buffer, UTIL_FW_MAJOR_MINOR,
-				 WIN7_SRV_MAJOR_MINOR);
+				 recv_buffer, util_fw_version,
+				 kvp_srv_version);
 
 		} else {
 			kvp_msg = (struct hv_kvp_msg *)&recv_buffer[
@@ -649,7 +664,6 @@ void hv_kvp_onchannelcallback(void *context)
 			return;
 
 		}
-done:
 
 		icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION
 			| ICMSGHDRFLAG_RESPONSE;
diff --git a/drivers/hv/hv_snapshot.c b/drivers/hv/hv_snapshot.c
index e4572f3..0c35462 100644
--- a/drivers/hv/hv_snapshot.c
+++ b/drivers/hv/hv_snapshot.c
@@ -26,7 +26,7 @@
 
 #define VSS_MAJOR  5
 #define VSS_MINOR  0
-#define VSS_MAJOR_MINOR    (VSS_MAJOR << 16 | VSS_MINOR)
+#define VSS_VERSION    (VSS_MAJOR << 16 | VSS_MINOR)
 
 
 
@@ -190,8 +190,8 @@ void hv_vss_onchannelcallback(void *context)
 
 		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
 			vmbus_prep_negotiate_resp(icmsghdrp, negop,
-				 recv_buffer, UTIL_FW_MAJOR_MINOR,
-				 VSS_MAJOR_MINOR);
+				 recv_buffer, UTIL_FW_VERSION,
+				 VSS_VERSION);
 		} else {
 			vss_msg = (struct hv_vss_msg *)&recv_buffer[
 				sizeof(struct vmbuspipe_hdr) +
diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index cb82233..273e3dd 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -28,17 +28,32 @@
 #include <linux/reboot.h>
 #include <linux/hyperv.h>
 
-#define SHUTDOWN_MAJOR	3
-#define SHUTDOWN_MINOR  0
-#define SHUTDOWN_MAJOR_MINOR	(SHUTDOWN_MAJOR << 16 | SHUTDOWN_MINOR)
 
-#define TIMESYNCH_MAJOR	3
-#define TIMESYNCH_MINOR 0
-#define TIMESYNCH_MAJOR_MINOR	(TIMESYNCH_MAJOR << 16 | TIMESYNCH_MINOR)
+#define SD_MAJOR	3
+#define SD_MINOR	0
+#define SD_VERSION	(SD_MAJOR << 16 | SD_MINOR)
 
-#define HEARTBEAT_MAJOR	3
-#define HEARTBEAT_MINOR 0
-#define HEARTBEAT_MAJOR_MINOR	(HEARTBEAT_MAJOR << 16 | HEARTBEAT_MINOR)
+#define SD_WS2008_MAJOR		1
+#define SD_WS2008_VERSION	(SD_WS2008_MAJOR << 16 | SD_MINOR)
+
+#define TS_MAJOR	3
+#define TS_MINOR	0
+#define TS_VERSION	(TS_MAJOR << 16 | TS_MINOR)
+
+#define TS_WS2008_MAJOR		1
+#define TS_WS2008_VERSION	(TS_WS2008_MAJOR << 16 | TS_MINOR)
+
+#define HB_MAJOR	3
+#define HB_MINOR 0
+#define HB_VERSION	(HB_MAJOR << 16 | HB_MINOR)
+
+#define HB_WS2008_MAJOR	1
+#define HB_WS2008_VERSION	(HB_WS2008_MAJOR << 16 | HB_MINOR)
+
+static int sd_srv_version;
+static int ts_srv_version;
+static int hb_srv_version;
+static int util_fw_version;
 
 static void shutdown_onchannelcallback(void *context);
 static struct hv_util_service util_shutdown = {
@@ -99,8 +114,8 @@ static void shutdown_onchannelcallback(void *context)
 
 		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
 			vmbus_prep_negotiate_resp(icmsghdrp, negop,
-					shut_txf_buf, UTIL_FW_MAJOR_MINOR,
-					SHUTDOWN_MAJOR_MINOR);
+					shut_txf_buf, util_fw_version,
+					sd_srv_version);
 		} else {
 			shutdown_msg =
 				(struct shutdown_msg_data *)&shut_txf_buf[
@@ -216,6 +231,7 @@ static void timesync_onchannelcallback(void *context)
 	struct icmsg_hdr *icmsghdrp;
 	struct ictimesync_data *timedatap;
 	u8 *time_txf_buf = util_timesynch.recv_buffer;
+	struct icmsg_negotiate *negop = NULL;
 
 	vmbus_recvpacket(channel, time_txf_buf,
 			 PAGE_SIZE, &recvlen, &requestid);
@@ -225,9 +241,10 @@ static void timesync_onchannelcallback(void *context)
 				sizeof(struct vmbuspipe_hdr)];
 
 		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
-			vmbus_prep_negotiate_resp(icmsghdrp, NULL, time_txf_buf,
-						UTIL_FW_MAJOR_MINOR,
-						TIMESYNCH_MAJOR_MINOR);
+			vmbus_prep_negotiate_resp(icmsghdrp, negop,
+						time_txf_buf,
+						util_fw_version,
+						ts_srv_version);
 		} else {
 			timedatap = (struct ictimesync_data *)&time_txf_buf[
 				sizeof(struct vmbuspipe_hdr) +
@@ -257,6 +274,7 @@ static void heartbeat_onchannelcallback(void *context)
 	struct icmsg_hdr *icmsghdrp;
 	struct heartbeat_msg_data *heartbeat_msg;
 	u8 *hbeat_txf_buf = util_heartbeat.recv_buffer;
+	struct icmsg_negotiate *negop = NULL;
 
 	vmbus_recvpacket(channel, hbeat_txf_buf,
 			 PAGE_SIZE, &recvlen, &requestid);
@@ -266,9 +284,9 @@ static void heartbeat_onchannelcallback(void *context)
 				sizeof(struct vmbuspipe_hdr)];
 
 		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
-			vmbus_prep_negotiate_resp(icmsghdrp, NULL,
-				hbeat_txf_buf, UTIL_FW_MAJOR_MINOR,
-				HEARTBEAT_MAJOR_MINOR);
+			vmbus_prep_negotiate_resp(icmsghdrp, negop,
+				hbeat_txf_buf, util_fw_version,
+				hb_srv_version);
 		} else {
 			heartbeat_msg =
 				(struct heartbeat_msg_data *)&hbeat_txf_buf[
@@ -321,6 +339,25 @@ static int util_probe(struct hv_device *dev,
 		goto error;
 
 	hv_set_drvdata(dev, srv);
+	/*
+	 * Based on the host; initialize the framework and
+	 * service version numbers we will negotiate.
+	 */
+	switch (vmbus_proto_version) {
+	case (VERSION_WS2008):
+		util_fw_version = UTIL_WS2K8_FW_VERSION;
+		sd_srv_version = SD_WS2008_VERSION;
+		ts_srv_version = TS_WS2008_VERSION;
+		hb_srv_version = HB_WS2008_VERSION;
+		break;
+
+	default:
+		util_fw_version = UTIL_FW_VERSION;
+		sd_srv_version = SD_VERSION;
+		ts_srv_version = TS_VERSION;
+		hb_srv_version = HB_VERSION;
+	}
+
 	return 0;
 
 error:
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index a3b8b2e..d98503b 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -30,10 +30,13 @@
 /*
  * Framework version for util services.
  */
+#define UTIL_FW_MINOR  0
+
+#define UTIL_WS2K8_FW_MAJOR  1
+#define UTIL_WS2K8_FW_VERSION     (UTIL_WS2K8_FW_MAJOR << 16 | UTIL_FW_MINOR)
 
 #define UTIL_FW_MAJOR  3
-#define UTIL_FW_MINOR  0
-#define UTIL_FW_MAJOR_MINOR     (UTIL_FW_MAJOR << 16 | UTIL_FW_MINOR)
+#define UTIL_FW_VERSION     (UTIL_FW_MAJOR << 16 | UTIL_FW_MINOR)
 
 
 /*
-- 
1.7.4.1

