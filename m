Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbaHULdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:33:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:16495 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677AbaHULbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:31:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,908,1400050800"; 
   d="scan'208";a="587969506"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 07/14] mei: add hbm commands return status values
Date: Thu, 21 Aug 2014 14:29:16 +0300
Message-Id: <1408620563-25834-7-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
References: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HBM uses global list of status values
from which the values of particular commands
are derived

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c | 22 ++++++++++++++++++++--
 drivers/misc/mei/hw.h  | 39 +++++++++++++++++++++++++++++++++------
 2 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 5fb177b..d50c8d1 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -25,6 +25,23 @@
 #include "hbm.h"
 #include "client.h"
 
+static const char *mei_hbm_status_str(enum mei_hbm_status status)
+{
+#define MEI_HBM_STATUS(status) case MEI_HBMS_##status: return #status
+	switch (status) {
+	MEI_HBM_STATUS(SUCCESS);
+	MEI_HBM_STATUS(CLIENT_NOT_FOUND);
+	MEI_HBM_STATUS(ALREADY_EXISTS);
+	MEI_HBM_STATUS(REJECTED);
+	MEI_HBM_STATUS(INVALID_PARAMETER);
+	MEI_HBM_STATUS(NOT_ALLOWED);
+	MEI_HBM_STATUS(ALREADY_STARTED);
+	MEI_HBM_STATUS(NOT_STARTED);
+	default: return "unknown";
+	}
+#undef MEI_HBM_STATUS
+};
+
 static const char *mei_cl_conn_status_str(enum mei_cl_connect_status status)
 {
 #define MEI_CL_CS(status) case MEI_CL_CONN_##status: return #status
@@ -770,8 +787,9 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 		props_res = (struct hbm_props_response *)mei_msg;
 
 		if (props_res->status) {
-			dev_err(&dev->pdev->dev, "hbm: properties response: wrong status = %d\n",
-				props_res->status);
+			dev_err(&dev->pdev->dev, "hbm: properties response: wrong status = %d %s\n",
+				props_res->status,
+				mei_hbm_status_str(props_res->status));
 			return -EPROTO;
 		}
 
diff --git a/drivers/misc/mei/hw.h b/drivers/misc/mei/hw.h
index 50526f9..6e31113 100644
--- a/drivers/misc/mei/hw.h
+++ b/drivers/misc/mei/hw.h
@@ -97,23 +97,50 @@ enum mei_stop_reason_types {
 	SYSTEM_S5_ENTRY = 0x08
 };
 
+
+/**
+ * mei_hbm_status  - mei host bus messages return values
+ *
+ * @MEI_HBMS_SUCCESS           - status success
+ * @MEI_HBMS_CLIENT_NOT_FOUND  - client not found
+ * @MEI_HBMS_ALREADY_EXISTS    - connection already established
+ * @MEI_HBMS_REJECTED          - connection is rejected
+ * @MEI_HBMS_INVALID_PARAMETER - invalid parameter
+ * @MEI_HBMS_NOT_ALLOWED       - operation not allowed
+ * @MEI_HBMS_ALREADY_STARTED   - system is already started
+ * @MEI_HBMS_NOT_STARTED       - system not started
+ */
+enum mei_hbm_status {
+	MEI_HBMS_SUCCESS           = 0,
+	MEI_HBMS_CLIENT_NOT_FOUND  = 1,
+	MEI_HBMS_ALREADY_EXISTS    = 2,
+	MEI_HBMS_REJECTED          = 3,
+	MEI_HBMS_INVALID_PARAMETER = 4,
+	MEI_HBMS_NOT_ALLOWED       = 5,
+	MEI_HBMS_ALREADY_STARTED   = 6,
+	MEI_HBMS_NOT_STARTED       = 7,
+
+	MEI_HBMS_MAX
+};
+
+
 /*
  * Client Connect Status
  * used by hbm_client_connect_response.status
  */
 enum mei_cl_connect_status {
-	MEI_CL_CONN_SUCCESS          = 0x00,
-	MEI_CL_CONN_NOT_FOUND        = 0x01,
-	MEI_CL_CONN_ALREADY_STARTED  = 0x02,
-	MEI_CL_CONN_OUT_OF_RESOURCES = 0x03,
-	MEI_CL_CONN_MESSAGE_SMALL    = 0x04
+	MEI_CL_CONN_SUCCESS          = MEI_HBMS_SUCCESS,
+	MEI_CL_CONN_NOT_FOUND        = MEI_HBMS_CLIENT_NOT_FOUND,
+	MEI_CL_CONN_ALREADY_STARTED  = MEI_HBMS_ALREADY_EXISTS,
+	MEI_CL_CONN_OUT_OF_RESOURCES = MEI_HBMS_REJECTED,
+	MEI_CL_CONN_MESSAGE_SMALL    = MEI_HBMS_INVALID_PARAMETER,
 };
 
 /*
  * Client Disconnect Status
  */
 enum  mei_cl_disconnect_status {
-	MEI_CL_DISCONN_SUCCESS = 0x00
+	MEI_CL_DISCONN_SUCCESS = MEI_HBMS_SUCCESS
 };
 
 /*
-- 
1.9.3

