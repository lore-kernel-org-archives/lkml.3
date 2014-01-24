Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaAXUCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 15:02:12 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:43766 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbaAXUCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 15:02:03 -0500
From: minyard@acm.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Xie XiuQi <xiexiuqi@huawei.com>, Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 3/4] ipmi: fix timeout calculation when bmc is disconnected
Date: Fri, 24 Jan 2014 14:00:52 -0600
Message-Id: <1390593653-5408-4-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1390593653-5408-1-git-send-email-minyard@acm.org>
References: <1390593653-5408-1-git-send-email-minyard@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xie XiuQi <xiexiuqi@huawei.com>

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
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_si_intf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 68c5ef5..a5e048f 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2773,7 +2773,7 @@ static int wait_for_msg_done(struct smi_info *smi_info)
 		    smi_result == SI_SM_CALL_WITH_TICK_DELAY) {
 			schedule_timeout_uninterruptible(1);
 			smi_result = smi_info->handlers->event(
-				smi_info->si_sm, 100);
+				smi_info->si_sm, jiffies_to_usecs(1));
 		} else if (smi_result == SI_SM_CALL_WITHOUT_DELAY) {
 			smi_result = smi_info->handlers->event(
 				smi_info->si_sm, 0);
-- 
1.8.3.1

