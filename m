Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbaIWHo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 03:44:59 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42913 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754316AbaIWHoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 03:44:55 -0400
From: Jisheng Zhang <jszhang@marvell.com>
To: <wim@iguana.be>, <linux@roeck-us.net>
CC: <linux-watchdog@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH v2 1/2] watchdog: dw_wdt: initialise TOP_INIT in dw_wdt_set_top()
Date: Tue, 23 Sep 2014 15:42:11 +0800
Message-ID: <1411458132-5410-2-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411458132-5410-1-git-send-email-jszhang@marvell.com>
References: <1411458132-5410-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-23_03:2014-09-23,2014-09-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1409230081
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TOP_INIT, ie bit 4-7 of the WDOG_TIMEOUT_RANGE_REG_OFFSET register
may be zero, so the timeout period may be very short after initialization
is done, thus the system may be reset soon after enabling. We fix this
problem by also initialising the TOP_INIT when setting TOP in function
dw_wdt_set_top().

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
---
 drivers/watchdog/dw_wdt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
index 9f21029..449c885 100644
--- a/drivers/watchdog/dw_wdt.c
+++ b/drivers/watchdog/dw_wdt.c
@@ -40,6 +40,7 @@
 #define WDOG_CONTROL_REG_OFFSET		    0x00
 #define WDOG_CONTROL_REG_WDT_EN_MASK	    0x01
 #define WDOG_TIMEOUT_RANGE_REG_OFFSET	    0x04
+#define WDOG_TIMEOUT_RANGE_TOPINIT_SHIFT    4
 #define WDOG_CURRENT_COUNT_REG_OFFSET	    0x08
 #define WDOG_COUNTER_RESTART_REG_OFFSET     0x0c
 #define WDOG_COUNTER_RESTART_KICK_VALUE	    0x76
@@ -106,7 +107,8 @@ static int dw_wdt_set_top(unsigned top_s)
 		}
 
 	/* Set the new value in the watchdog. */
-	writel(top_val, dw_wdt.regs + WDOG_TIMEOUT_RANGE_REG_OFFSET);
+	writel(top_val | top_val << WDOG_TIMEOUT_RANGE_TOPINIT_SHIFT,
+		dw_wdt.regs + WDOG_TIMEOUT_RANGE_REG_OFFSET);
 
 	dw_wdt_set_next_heartbeat();
 
-- 
2.1.0

