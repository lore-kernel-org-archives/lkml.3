Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab3AXBQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 20:16:06 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:58250
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab3AXBQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 20:16:00 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, davem@davemloft.net, jkosina@suse.cz,
        James.Bottomley@HansenPartnership.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/6] Drivers: hv: vmbus: Consolidate all offer GUID definitions in hyperv.h
Date: Wed, 23 Jan 2013 17:42:40 -0800
Message-Id: <1358991765-22715-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358991737-22675-1-git-send-email-kys@microsoft.com>
References: <1358991737-22675-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate all GUID definitions in hyperv.h and use these definitions in implementing
channel bindings (as far as interrupt delivery goes).

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/channel_mgmt.c |   31 +++------------
 include/linux/hyperv.h    |   94 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 100 insertions(+), 25 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index c80fe62..421d607 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -265,36 +265,17 @@ enum {
 };
 
 /*
- * This is an array of channels (devices) that are performance critical.
+ * This is an array of device_ids (device types) that are performance critical.
  * We attempt to distribute the interrupt load for these devices across
  * all available CPUs.
  */
-static const uuid_le hp_devs[] = {
-	/* {32412632-86cb-44a2-9b5c-50d1417354f5} */
+static const struct hv_vmbus_device_id hp_devs[] = {
 	/* IDE */
-	{
-		.b = {
-			0x32, 0x26, 0x41, 0x32, 0xcb, 0x86, 0xa2, 0x44,
-			0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5
-		}
-	},
-	/* {ba6163d9-04a1-4d29-b605-72e2ffb1dc7f} */
+	{ HV_IDE_GUID, },
 	/* Storage - SCSI */
-	{
-		.b  = {
-			0xd9, 0x63, 0x61, 0xba, 0xa1, 0x04, 0x29, 0x4d,
-			0xb6, 0x05, 0x72, 0xe2, 0xff, 0xb1, 0xdc, 0x7f
-		}
-	},
-	/* {F8615163-DF3E-46c5-913F-F2D2F965ED0E} */
+	{ HV_SCSI_GUID, },
 	/* Network */
-	{
-		.b = {
-			0x63, 0x51, 0x61, 0xF8, 0x3E, 0xDF, 0xc5, 0x46,
-			0x91, 0x3F, 0xF2, 0xD2, 0xF9, 0x65, 0xED, 0x0E
-		}
-	},
-
+	{ HV_NIC_GUID, },
 };
 
 
@@ -320,7 +301,7 @@ static u32 get_vp_index(uuid_le *type_guid)
 	u32 max_cpus = num_online_cpus();
 
 	for (i = IDE; i < MAX_PERF_CHN; i++) {
-		if (!memcmp(type_guid->b, hp_devs[i].b,
+		if (!memcmp(type_guid->b, hp_devs[i].guid,
 				 sizeof(uuid_le))) {
 			perf_chn = true;
 			break;
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 5095b06..df77ba9 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1159,6 +1159,100 @@ void vmbus_driver_unregister(struct hv_driver *hv_driver);
 		  g8, g9, ga, gb, gc, gd, ge, gf },
 
 /*
+ * GUID definitions of various offer types - services offered to the guest.
+ */
+
+/*
+ * Network GUID
+ * {f8615163-df3e-46c5-913f-f2d2f965ed0e}
+ */
+#define HV_NIC_GUID \
+	.guid = { \
+			0x63, 0x51, 0x61, 0xf8, 0x3e, 0xdf, 0xc5, 0x46, \
+			0x91, 0x3f, 0xf2, 0xd2, 0xf9, 0x65, 0xed, 0x0e \
+		}
+
+/*
+ * IDE GUID
+ * {32412632-86cb-44a2-9b5c-50d1417354f5}
+ */
+#define HV_IDE_GUID \
+	.guid = { \
+			0x32, 0x26, 0x41, 0x32, 0xcb, 0x86, 0xa2, 0x44, \
+			0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5 \
+		}
+
+/*
+ * SCSI GUID
+ * {ba6163d9-04a1-4d29-b605-72e2ffb1dc7f}
+ */
+#define HV_SCSI_GUID \
+	.guid = { \
+			0xd9, 0x63, 0x61, 0xba, 0xa1, 0x04, 0x29, 0x4d, \
+			0xb6, 0x05, 0x72, 0xe2, 0xff, 0xb1, 0xdc, 0x7f \
+		}
+
+/*
+ * Shutdown GUID
+ * {0e0b6031-5213-4934-818b-38d90ced39db}
+ */
+#define HV_SHUTDOWN_GUID \
+	.guid = { \
+			0x31, 0x60, 0x0b, 0x0e, 0x13, 0x52, 0x34, 0x49, \
+			0x81, 0x8b, 0x38, 0xd9, 0x0c, 0xed, 0x39, 0xdb \
+		}
+
+/*
+ * Time Synch GUID
+ * {9527E630-D0AE-497b-ADCE-E80AB0175CAF}
+ */
+#define HV_TS_GUID \
+	.guid = { \
+			0x30, 0xe6, 0x27, 0x95, 0xae, 0xd0, 0x7b, 0x49, \
+			0xad, 0xce, 0xe8, 0x0a, 0xb0, 0x17, 0x5c, 0xaf \
+		}
+
+/*
+ * Heartbeat GUID
+ * {57164f39-9115-4e78-ab55-382f3bd5422d}
+ */
+#define HV_HEART_BEAT_GUID \
+	.guid = { \
+			0x39, 0x4f, 0x16, 0x57, 0x15, 0x91, 0x78, 0x4e, \
+			0xab, 0x55, 0x38, 0x2f, 0x3b, 0xd5, 0x42, 0x2d \
+		}
+
+/*
+ * KVP GUID
+ * {a9a0f4e7-5a45-4d96-b827-8a841e8c03e6}
+ */
+#define HV_KVP_GUID \
+	.guid = { \
+			0xe7, 0xf4, 0xa0, 0xa9, 0x45, 0x5a, 0x96, 0x4d, \
+			0xb8, 0x27, 0x8a, 0x84, 0x1e, 0x8c, 0x3,  0xe6 \
+		}
+
+/*
+ * Dynamic memory GUID
+ * {525074dc-8985-46e2-8057-a307dc18a502}
+ */
+#define HV_DM_GUID \
+	.guid = { \
+			0xdc, 0x74, 0x50, 0X52, 0x85, 0x89, 0xe2, 0x46, \
+			0x80, 0x57, 0xa3, 0x07, 0xdc, 0x18, 0xa5, 0x02 \
+		}
+
+/*
+ * Mouse GUID
+ * {cfa8b69e-5b4a-4cc0-b98b-8ba1a1f3f95a}
+ */
+#define HV_MOUSE_GUID \
+	.guid = { \
+			0x9e, 0xb6, 0xa8, 0xcf, 0x4a, 0x5b, 0xc0, 0x4c, \
+			0xb9, 0x8b, 0x8b, 0xa1, 0xa1, 0xf3, 0xf9, 0x5a \
+		}
+
+/*
  * Common header for Hyper-V ICs
  */
 
-- 
1.7.4.1

