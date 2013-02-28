Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab3B1KBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 05:01:34 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35637 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3B1KBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 05:01:33 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: John Stultz <johnstul@us.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH RESEND 1/2] clocksource: dbx500-prcmu: use relaxed readl variant
Date: Thu, 28 Feb 2013 11:01:06 +0100
Message-Id: <1362045667-23891-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Modify clksrc_dbx500_prcmu_read to replace readl() with readl_relaxed().
This speeds up calls to the function by about 40%.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/clocksource/clksrc-dbx500-prcmu.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/clocksource/clksrc-dbx500-prcmu.c b/drivers/clocksource/clksrc-dbx500-prcmu.c
index c26c369..159f54a 100644
--- a/drivers/clocksource/clksrc-dbx500-prcmu.c
+++ b/drivers/clocksource/clksrc-dbx500-prcmu.c
@@ -33,15 +33,14 @@
 
 static void __iomem *clksrc_dbx500_timer_base;
 
-static cycle_t clksrc_dbx500_prcmu_read(struct clocksource *cs)
+static cycle_t notrace clksrc_dbx500_prcmu_read(struct clocksource *cs)
 {
+	void __iomem *base = clksrc_dbx500_timer_base;
 	u32 count, count2;
 
 	do {
-		count = readl(clksrc_dbx500_timer_base +
-			      PRCMU_TIMER_DOWNCOUNT);
-		count2 = readl(clksrc_dbx500_timer_base +
-			       PRCMU_TIMER_DOWNCOUNT);
+		count = readl_relaxed(base + PRCMU_TIMER_DOWNCOUNT);
+		count2 = readl_relaxed(base + PRCMU_TIMER_DOWNCOUNT);
 	} while (count2 != count);
 
 	/* Negate because the timer is a decrementing counter */
-- 
1.7.12.1

