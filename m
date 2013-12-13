Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab3LMCjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:39:15 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:28461 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab3LMCjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:39:14 -0500
Message-ID: <52AA7319.9080603@huawei.com>
Date: Fri, 13 Dec 2013 10:38:17 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>
CC: Hushiyuan <hushiyuan@huawei.com>,
        <openipmi-developer@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhangdianfang <zhangdianfang@huawei.com>
Subject: [PATCH 1/2] ipmi: use USEC_PER_SEC instead of 1000000 for more meaningful
References: <52AA72B4.4080807@huawei.com>
In-Reply-To: <52AA72B4.4080807@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use USEC_PER_SEC instead of 1000000, that making the later bugfix
more clearly.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 drivers/char/ipmi/ipmi_bt_sm.c   | 8 ++++----
 drivers/char/ipmi/ipmi_kcs_sm.c  | 4 ++--
 drivers/char/ipmi/ipmi_smic_sm.c | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_bt_sm.c b/drivers/char/ipmi/ipmi_bt_sm.c
index a22a7a5..f5e4cd7 100644
--- a/drivers/char/ipmi/ipmi_bt_sm.c
+++ b/drivers/char/ipmi/ipmi_bt_sm.c
@@ -201,7 +201,7 @@ static unsigned int bt_init_data(struct si_sm_data *bt, struct si_sm_io *io)
 	}
 	bt->state = BT_STATE_IDLE;	/* start here */
 	bt->complete = BT_STATE_IDLE;	/* end here */
-	bt->BT_CAP_req2rsp = BT_NORMAL_TIMEOUT * 1000000;
+	bt->BT_CAP_req2rsp = BT_NORMAL_TIMEOUT * USEC_PER_SEC;
 	bt->BT_CAP_retries = BT_NORMAL_RETRY_LIMIT;
 	/* BT_CAP_outreqs == zero is a flag to read BT Capabilities */
 	return 3; /* We claim 3 bytes of space; ought to check SPMI table */
@@ -613,7 +613,7 @@ static enum si_sm_result bt_event(struct si_sm_data *bt, long time)
 		HOST2BMC(42);		/* Sequence number */
 		HOST2BMC(3);		/* Cmd == Soft reset */
 		BT_CONTROL(BT_H2B_ATN);
-		bt->timeout = BT_RESET_DELAY * 1000000;
+		bt->timeout = BT_RESET_DELAY * USEC_PER_SEC;
 		BT_STATE_CHANGE(BT_STATE_RESET3,
 				SI_SM_CALL_WITH_DELAY);

@@ -651,14 +651,14 @@ static enum si_sm_result bt_event(struct si_sm_data *bt, long time)
 		bt_init_data(bt, bt->io);
 		if ((i == 8) && !BT_CAP[2]) {
 			bt->BT_CAP_outreqs = BT_CAP[3];
-			bt->BT_CAP_req2rsp = BT_CAP[6] * 1000000;
+			bt->BT_CAP_req2rsp = BT_CAP[6] * USEC_PER_SEC;
 			bt->BT_CAP_retries = BT_CAP[7];
 		} else
 			printk(KERN_WARNING "IPMI BT: using default values\n");
 		if (!bt->BT_CAP_outreqs)
 			bt->BT_CAP_outreqs = 1;
 		printk(KERN_WARNING "IPMI BT: req2rsp=%ld secs retries=%d\n",
-			bt->BT_CAP_req2rsp / 1000000L, bt->BT_CAP_retries);
+			bt->BT_CAP_req2rsp / USEC_PER_SEC, bt->BT_CAP_retries);
 		bt->timeout = bt->BT_CAP_req2rsp;
 		return SI_SM_CALL_WITHOUT_DELAY;

diff --git a/drivers/char/ipmi/ipmi_kcs_sm.c b/drivers/char/ipmi/ipmi_kcs_sm.c
index e53fc24..6a4bdc1 100644
--- a/drivers/char/ipmi/ipmi_kcs_sm.c
+++ b/drivers/char/ipmi/ipmi_kcs_sm.c
@@ -118,8 +118,8 @@ enum kcs_states {
 #define MAX_KCS_WRITE_SIZE IPMI_MAX_MSG_LENGTH

 /* Timeouts in microseconds. */
-#define IBF_RETRY_TIMEOUT 5000000
-#define OBF_RETRY_TIMEOUT 5000000
+#define IBF_RETRY_TIMEOUT (5*USEC_PER_SEC)
+#define OBF_RETRY_TIMEOUT (5*USEC_PER_SEC)
 #define MAX_ERROR_RETRIES 10
 #define ERROR0_OBF_WAIT_JIFFIES (2*HZ)

diff --git a/drivers/char/ipmi/ipmi_smic_sm.c b/drivers/char/ipmi/ipmi_smic_sm.c
index faed929..c8e77af 100644
--- a/drivers/char/ipmi/ipmi_smic_sm.c
+++ b/drivers/char/ipmi/ipmi_smic_sm.c
@@ -80,7 +80,7 @@ enum smic_states {
 #define SMIC_MAX_ERROR_RETRIES 3

 /* Timeouts in microseconds. */
-#define SMIC_RETRY_TIMEOUT 2000000
+#define SMIC_RETRY_TIMEOUT (2*USEC_PER_SEC)

 /* SMIC Flags Register Bits */
 #define SMIC_RX_DATA_READY	0x80
-- 
1.8.2.2


