Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965542Ab3FTNVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 09:21:19 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32379 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965039Ab3FTNVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 09:21:18 -0400
From: Maxim Uvarov <maxim.uvarov@oracle.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ipmi: make kcs timeout parameters as module options
Date: Thu, 20 Jun 2013 17:28:20 +0400
Message-Id: <1371734900-7220-1-git-send-email-maxim.uvarov@oracle.com>
X-Mailer: git-send-email 1.8.3.1.378.g9926f66
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based off work by Pavel Bures <Pavel.Bures@Sun.COM>:
For slow or heavily used BMC contollers the default wait timeouts for IBF or OBF
bits in the driver may not be sufficient. This may cause problems during more
complicated oem operatoins on the BMC side.
These timeoutsare changed from hardcoded values in the code into kernel
module parameters. The default values are kept unchanged.

Signed-off-by: Maxim Uvarov <maxim.uvarov@oracle.com>
---
 drivers/char/ipmi/ipmi_kcs_sm.c |   45 +++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_kcs_sm.c b/drivers/char/ipmi/ipmi_kcs_sm.c
index e53fc24..674ca99 100644
--- a/drivers/char/ipmi/ipmi_kcs_sm.c
+++ b/drivers/char/ipmi/ipmi_kcs_sm.c
@@ -54,10 +54,29 @@
 #define KCS_DEBUG_MSG		2
 #define	KCS_DEBUG_ENABLE	1
 
+/* Timeouts in microseconds. */
+#define IBF_RETRY_TIMEOUT 5000000
+#define OBF_RETRY_TIMEOUT 5000000
+#define MAX_ERROR_RETRIES 10
+#define ERROR0_OBF_WAIT_JIFFIES (2*HZ)
+
 static int kcs_debug;
+static uint kcs_obf_timeout = OBF_RETRY_TIMEOUT;
+static uint kcs_ibf_timeout = IBF_RETRY_TIMEOUT;
+static ushort kcs_err_retries = MAX_ERROR_RETRIES;
+
 module_param(kcs_debug, int, 0644);
 MODULE_PARM_DESC(kcs_debug, "debug bitmask, 1=enable, 2=messages, 4=states");
 
+module_param(kcs_obf_timeout, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(kcs_obf_timeout, "OBF timeout value in microseconds. Default is 1000000.");
+
+module_param(kcs_ibf_timeout, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(kcs_ibf_timeout, "IBF timeout value in microseconds. Default is 1000000.");
+
+module_param(kcs_err_retries, ushort, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(kcs_err_retries, "Number of error retries for kcs device. Default is 10.");
+
 /* The states the KCS driver may be in. */
 enum kcs_states {
 	/* The KCS interface is currently doing nothing. */
@@ -117,12 +136,6 @@ enum kcs_states {
 #define MAX_KCS_READ_SIZE IPMI_MAX_MSG_LENGTH
 #define MAX_KCS_WRITE_SIZE IPMI_MAX_MSG_LENGTH
 
-/* Timeouts in microseconds. */
-#define IBF_RETRY_TIMEOUT 5000000
-#define OBF_RETRY_TIMEOUT 5000000
-#define MAX_ERROR_RETRIES 10
-#define ERROR0_OBF_WAIT_JIFFIES (2*HZ)
-
 struct si_sm_data {
 	enum kcs_states  state;
 	struct si_sm_io *io;
@@ -151,8 +164,8 @@ static unsigned int init_kcs_data(struct si_sm_data *kcs,
 	kcs->read_pos = 0;
 	kcs->error_retries = 0;
 	kcs->truncated = 0;
-	kcs->ibf_timeout = IBF_RETRY_TIMEOUT;
-	kcs->obf_timeout = OBF_RETRY_TIMEOUT;
+	kcs->ibf_timeout = kcs_ibf_timeout;
+	kcs->obf_timeout = kcs_obf_timeout;
 
 	/* Reserve 2 I/O bytes. */
 	return 2;
@@ -205,7 +218,7 @@ static inline void write_next_byte(struct si_sm_data *kcs)
 static inline void start_error_recovery(struct si_sm_data *kcs, char *reason)
 {
 	(kcs->error_retries)++;
-	if (kcs->error_retries > MAX_ERROR_RETRIES) {
+	if (kcs->error_retries > kcs_err_retries) {
 		if (kcs_debug & KCS_DEBUG_ENABLE)
 			printk(KERN_DEBUG "ipmi_kcs_sm: kcs hosed: %s\n",
 			       reason);
@@ -236,12 +249,12 @@ static inline int check_ibf(struct si_sm_data *kcs, unsigned char status,
 		kcs->ibf_timeout -= time;
 		if (kcs->ibf_timeout < 0) {
 			start_error_recovery(kcs, "IBF not ready in time");
-			kcs->ibf_timeout = IBF_RETRY_TIMEOUT;
+			kcs->ibf_timeout = kcs_ibf_timeout;
 			return 1;
 		}
 		return 0;
 	}
-	kcs->ibf_timeout = IBF_RETRY_TIMEOUT;
+	kcs->ibf_timeout = kcs_ibf_timeout;
 	return 1;
 }
 
@@ -256,7 +269,7 @@ static inline int check_obf(struct si_sm_data *kcs, unsigned char status,
 		}
 		return 0;
 	}
-	kcs->obf_timeout = OBF_RETRY_TIMEOUT;
+	kcs->obf_timeout = kcs_obf_timeout;
 	return 1;
 }
 
@@ -272,8 +285,8 @@ static void restart_kcs_transaction(struct si_sm_data *kcs)
 	kcs->write_pos = 0;
 	kcs->read_pos = 0;
 	kcs->state = KCS_WAIT_WRITE_START;
-	kcs->ibf_timeout = IBF_RETRY_TIMEOUT;
-	kcs->obf_timeout = OBF_RETRY_TIMEOUT;
+	kcs->ibf_timeout = kcs_ibf_timeout;
+	kcs->obf_timeout = kcs_obf_timeout;
 	write_cmd(kcs, KCS_WRITE_START);
 }
 
@@ -303,8 +316,8 @@ static int start_kcs_transaction(struct si_sm_data *kcs, unsigned char *data,
 	kcs->write_pos = 0;
 	kcs->read_pos = 0;
 	kcs->state = KCS_START_OP;
-	kcs->ibf_timeout = IBF_RETRY_TIMEOUT;
-	kcs->obf_timeout = OBF_RETRY_TIMEOUT;
+	kcs->ibf_timeout = kcs_ibf_timeout;
+	kcs->obf_timeout = kcs_obf_timeout;
 	return 0;
 }
 
-- 
1.7.9.5

