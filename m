Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab3LMCk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:40:26 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:28808 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab3LMCkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:40:21 -0500
Message-ID: <52AA7377.4070408@huawei.com>
Date: Fri, 13 Dec 2013 10:39:51 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>
CC: Hushiyuan <hushiyuan@huawei.com>,
        <openipmi-developer@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhangdianfang <zhangdianfang@huawei.com>
Subject: [PATCH 2/2] ipmi: fix timeout calculation when bmc is disconnected
References: <52AA72B4.4080807@huawei.com>
In-Reply-To: <52AA72B4.4080807@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Loading ipmi_si module while bmc is disconnected, we found the timeout
is longer than 5 secs. Actually it takes about 3 mins and 20 secs.(HZ=250)

error message as below:
Dec 12 19:08:59 linux kernel: IPMI BT: timeout in RD_WAIT [ ] 1 retries left
Dec 12 19:08:59 linux kernel: BT: write 4 bytes seq=0x01 03 18 00 01
[...]
Dec 12 19:12:19 linux kernel: IPMI BT: timeout in RD_WAIT [ ]
Dec 12 19:12:19 linux kernel: failed 2 retries, sending error response
Dec 12 19:12:19 linux kernel: IPMI: BT reset (takes 5 secs)
Dec 12 19:12:19 linux kernel: IPMI BT: flag reset [ ]

Function wait_for_msg_done() use schedule_timeout_uninterruptible(1) to
sleep 1 tick, so we should subtract jiffies_to_usecs(1) instead of 100
usecs from timeout.

Reported-by: Hu Shiyuan <hushiyuan@huawei.com>
Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 drivers/char/ipmi/ipmi_si_intf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index af4b23f..e086d82 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2707,7 +2707,7 @@ static int wait_for_msg_done(struct smi_info *smi_info)
 		    smi_result == SI_SM_CALL_WITH_TICK_DELAY) {
 			schedule_timeout_uninterruptible(1);
 			smi_result = smi_info->handlers->event(
-				smi_info->si_sm, 100);
+				smi_info->si_sm, jiffies_to_usecs(1));
 		} else if (smi_result == SI_SM_CALL_WITHOUT_DELAY) {
 			smi_result = smi_info->handlers->event(
 				smi_info->si_sm, 0);
-- 
1.8.2.2


