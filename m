Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaABMJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:09:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:49981 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbaABMIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:08:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Chas Williams <chas@cmf.nrl.navy.mil>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH, RFC 18/30] atm: firestream: fix interruptible_sleep_on race
Date: Thu,  2 Jan 2014 13:07:42 +0100
Message-Id: <1388664474-1710039-19-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:osBHNfXL/PXZlWTrOynGOXMP10GVlAR32jD38t/CXfD
 rfh1TUHvZM6nSkvCPa+sUHSaJmz1xo9ZLLKMjYuWjFdfKbVbMg
 c3GOsrlxZc4HQsgHaDPT+lqTZCH87+hCUDWvEMofN5qIv2TuTn
 qsckG2v7E7PMAGAF4R5qWSLE//19WruULUKNmyPnTMuSS+mnTG
 KYaTqdM4JMuY6059FXrciTFSysn5cdTHv8DrdVwacNztCZgYdZ
 e+p/Cch6Qs3oYQ2nqV4rOLzIurBHCVzsigpmyBFkuwrgv+nZwo
 GZ358mp0GKiHTDCMNvM0mLV6YYDmEznMD28mkPAYKuDMfEZzrC
 v1y+zTiydsxSp5qgb1NAFSFP0VL6YNilx0D2QzVoO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

interruptible_sleep_on is racy and going away. This replaces the one use
in the firestream driver with the appropriate wait_event_interruptible
variant.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: linux-atm-general@lists.sourceforge.net
Cc: netdev@vger.kernel.org
---
 drivers/atm/firestream.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index b41c948..f43e1c1 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -736,8 +736,8 @@ static void process_txdone_queue (struct fs_dev *dev, struct queue *q)
       
 			skb = td->skb;
 			if (skb == FS_VCC (ATM_SKB(skb)->vcc)->last_skb) {
-				wake_up_interruptible (& FS_VCC (ATM_SKB(skb)->vcc)->close_wait);
 				FS_VCC (ATM_SKB(skb)->vcc)->last_skb = NULL;
+				wake_up_interruptible (& FS_VCC (ATM_SKB(skb)->vcc)->close_wait);
 			}
 			td->dev->ntxpckts--;
 
@@ -1123,7 +1123,7 @@ static void fs_close(struct atm_vcc *atm_vcc)
 		   this sleep_on, we'll lose any reference to these packets. Memory leak!
 		   On the other hand, it's awfully convenient that we can abort a "close" that
 		   is taking too long. Maybe just use non-interruptible sleep on? -- REW */
-		interruptible_sleep_on (& vcc->close_wait);
+		wait_event_interruptible(vcc->close_wait, !vcc->last_skb);
 	}
 
 	txtp = &atm_vcc->qos.txtp;
-- 
1.8.3.2

