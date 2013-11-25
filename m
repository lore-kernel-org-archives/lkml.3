Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab3KYE3z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 23:29:55 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:55848 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab3KYE3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 23:29:53 -0500
From: dt.tangr@gmail.com
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Tang <dt.tangr@gmail.com>,
        tglx@linutronix.de
Subject: [PATCH 1/2] clocksource: zevio-timer: fix incorrect function definition so the correct function pointer is passed to CLOCKSOURCE_OF_DECLARE
Date: Mon, 25 Nov 2013 15:29:23 +1100
Message-Id: <1385353764-88784-1-git-send-email-dt.tangr@gmail.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Tang <dt.tangr@gmail.com>


Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 drivers/clocksource/zevio-timer.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/clocksource/zevio-timer.c b/drivers/clocksource/zevio-timer.c
index ca81809..a1bd107 100644
--- a/drivers/clocksource/zevio-timer.c
+++ b/drivers/clocksource/zevio-timer.c
@@ -122,28 +122,27 @@ static irqreturn_t zevio_timer_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }

-static int __init zevio_timer_add(struct device_node *node)
+static void __init zevio_timer_add(struct device_node *node)
 {
 	struct zevio_timer *timer;
 	struct resource res;
-	int irqnr, ret;
+	int irqnr;

 	timer = kzalloc(sizeof(*timer), GFP_KERNEL);
 	if (!timer)
-		return -ENOMEM;
+		return;

 	timer->base = of_iomap(node, 0);
-	if (!timer->base) {
-		ret = -EINVAL;
+	if (!timer->base)
 		goto error_free;
-	}
+
 	timer->timer1 = timer->base + IO_TIMER1;
 	timer->timer2 = timer->base + IO_TIMER2;

 	timer->clk = of_clk_get(node, 0);
 	if (IS_ERR(timer->clk)) {
-		ret = PTR_ERR(timer->clk);
-		pr_err("Timer clock not found! (error %d)\n", ret);
+		pr_err("Timer clock not found! (error %d)\n",
+				(int)PTR_ERR(timer->clk));
 		goto error_unmap;
 	}

@@ -204,12 +203,12 @@ static int __init zevio_timer_add(struct device_node *node)

 	pr_info("Added %s as clocksource\n", timer->clocksource_name);

-	return 0;
+	return;
 error_unmap:
 	iounmap(timer->base);
 error_free:
 	kfree(timer);
-	return ret;
+	return;
 }

 CLOCKSOURCE_OF_DECLARE(zevio_timer, "lsi,zevio-timer", zevio_timer_add);
--
1.8.1.3

