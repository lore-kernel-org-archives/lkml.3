Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933696Ab3HJMnw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 08:43:52 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48171 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933349Ab3HJMnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 08:43:14 -0400
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>, Lior Amsalem <alior@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: [PATCH 2/3] clocksource: orion: Use atomic access for shared registers
Date: Sat, 10 Aug 2013 09:43:01 -0300
Message-Id: <1376138582-7550-3-git-send-email-ezequiel.garcia@free-electrons.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376138582-7550-1-git-send-email-ezequiel.garcia@free-electrons.com>
References: <1376138582-7550-1-git-send-email-ezequiel.garcia@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the driver-specific thread-safe shared register API
by the recently introduced atomic_io_clear_set().

Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
---
 drivers/clocksource/time-orion.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/clocksource/time-orion.c b/drivers/clocksource/time-orion.c
index ecbeb68..4334ea7 100644
--- a/drivers/clocksource/time-orion.c
+++ b/drivers/clocksource/time-orion.c
@@ -35,20 +35,15 @@
 #define ORION_ONESHOT_MAX	0xfffffffe
 
 static void __iomem *timer_base;
-static DEFINE_SPINLOCK(timer_ctrl_lock);
 
 /*
  * Thread-safe access to TIMER_CTRL register
  * (shared with watchdog timer)
  */
-void orion_timer_ctrl_clrset(u32 clr, u32 set)
+static void orion_timer_ctrl_clrset(u32 clr, u32 set)
 {
-	spin_lock(&timer_ctrl_lock);
-	writel((readl(timer_base + TIMER_CTRL) & ~clr) | set,
-		timer_base + TIMER_CTRL);
-	spin_unlock(&timer_ctrl_lock);
+	atomic_io_clear_set(timer_base + TIMER_CTRL, clr, set);
 }
-EXPORT_SYMBOL(orion_timer_ctrl_clrset);
 
 /*
  * Free-running clocksource handling.
-- 
1.8.1.5

