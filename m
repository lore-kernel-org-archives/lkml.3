Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaBKKaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 05:30:09 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:9825 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaBKKaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:30:06 -0500
Message-ID: <52F9FAC4.4040105@huawei.com>
Date: Tue, 11 Feb 2014 18:26:12 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>
CC: <openipmi-developer@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hushiyuan <hushiyuan@huawei.com>
Subject: [PATCH] ipmi: fix BT reset for a while when cmd timeout
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.17.191]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fould a problem: when a cmd timeout and just
in that time bt->seq < 2, system will alway keep
retrying and we can't send any cmd to bmc.

the error message is like this:
[  530.908621] IPMI BT: timeout in RD_WAIT [ ] 1 retries left
[  582.661329] IPMI BT: timeout in RD_WAIT [ ]
[  582.661334] failed 2 retries, sending error response
[  582.661337] IPMI: BT reset (takes 5 secs)
[  693.335307] IPMI BT: timeout in RD_WAIT [ ]
[  693.335312] failed 2 retries, sending error response
[  693.335315] IPMI: BT reset (takes 5 secs)
[  804.825161] IPMI BT: timeout in RD_WAIT [ ]
[  804.825166] failed 2 retries, sending error response
[  804.825169] IPMI: BT reset (takes 5 secs)
...

When BT reset, a cmd "warm reset" will be sent to bmc, but this cmd
is Optional in spec(refer to ipmi-interface-spec-v2). Some machines
don't support this cmd.

So, bt->init is introduced. Only during insmod, we do BT reset when
response timeout to avoid system crash.

Reported-by: Hu Shiyuan <hushiyuan@huawei.com>
Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Cc: stable@vger.kernel.org	# 3.4+
---
 drivers/char/ipmi/ipmi_bt_sm.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_bt_sm.c b/drivers/char/ipmi/ipmi_bt_sm.c
index a22a7a5..b4a7b2a 100644
--- a/drivers/char/ipmi/ipmi_bt_sm.c
+++ b/drivers/char/ipmi/ipmi_bt_sm.c
@@ -107,6 +107,7 @@ struct si_sm_data {
 	int		BT_CAP_outreqs;
 	long		BT_CAP_req2rsp;
 	int		BT_CAP_retries;	/* Recommended retries */
+	int		init;
 };

 #define BT_CLR_WR_PTR	0x01	/* See IPMI 1.5 table 11.6.4 */
@@ -438,8 +439,8 @@ static enum si_sm_result error_recovery(struct si_sm_data *bt,
 	if (!bt->nonzero_status)
 		printk(KERN_ERR "IPMI BT: stuck, try power cycle\n");

-	/* this is most likely during insmod */
-	else if (bt->seq <= (unsigned char)(bt->BT_CAP_retries & 0xFF)) {
+	/* only during insmod */
+	else if (!bt->init) {
 		printk(KERN_WARNING "IPMI: BT reset (takes 5 secs)\n");
 		bt->state = BT_STATE_RESET1;
 		return SI_SM_CALL_WITHOUT_DELAY;
@@ -589,6 +590,10 @@ static enum si_sm_result bt_event(struct si_sm_data *bt, long time)
 			BT_STATE_CHANGE(BT_STATE_READ_WAIT,
 					SI_SM_CALL_WITHOUT_DELAY);
 		bt->state = bt->complete;
+
+		if (!bt->init && bt->seq)
+			bt->init = 1;
+
 		return bt->state == BT_STATE_IDLE ?	/* where to next? */
 			SI_SM_TRANSACTION_COMPLETE :	/* normal */
 			SI_SM_CALL_WITHOUT_DELAY;	/* Startup magic */
-- 
1.8.2.2


