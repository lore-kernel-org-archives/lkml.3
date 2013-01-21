Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab3AUMJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:09:58 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:46649 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab3AUMJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:09:54 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 1/2] clocksource: dbx500-prcmu: use relaxed readl variant
Date: Mon, 21 Jan 2013 13:09:31 +0100
Message-Id: <1358770172-30125-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
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

