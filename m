Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab3DWPyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:54:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57534 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340Ab3DWPyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:54:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Christian Daudt <csd@broadcom.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH] clocksource: kona: adapt to CLOCKSOURCE_OF_DECLARE change
Date: Tue, 23 Apr 2013 17:54:35 +0200
Message-Id: <1366732475-479886-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366732475-479886-1-git-send-email-arnd@arndb.de>
References: <1366732475-479886-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:lRRaOTBgeO46rGB9pj3clrYk0KLV2Dt2ngCPA1wFXZN
 AaGRUm5FPiueV5bC2zRVONc4+0ENAxcSh7M9YalEMw3G5CdB0J
 UaH+hYVC0/aSTFwyuuBJ9uLZ5/7QHGg+Oit85EtA6I6/mCK30v
 bkjj4MNJSMRwZXS7jWzG0u2u+ePx8cnK5Qd7wjuIkXGgPGw3Om
 LTcQbB58wsulejpJQCaMEeuw90wgQYpq3FfdCiT1HTcbc9tWGI
 PizRGts+Vvi3uvsOG1cHrfJCYojh6yLuxK7zGJTMYpReD1G0hK
 blXoHiVqq3/EF6KzaFmop+HwL+0iTnwt/oii8zWVUVU6k9HDyc
 EkvfY9yAUTXjF6RIpjogVHkqfwLhUrmB+syIOsX9z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CLOCKSOURCE_OF_DECLARE functions now take a device_node pointer
as their argument, as of the clksrc/cleanup branch in arm-soc.
This patch adapts the bcm_kona_timer driver to the new interface.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Daudt <csd@broadcom.com>
Cc: John Stultz <john.stultz@linaro.org>
---
 drivers/clocksource/bcm_kona_timer.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/clocksource/bcm_kona_timer.c b/drivers/clocksource/bcm_kona_timer.c
index 350f493..ba3d859 100644
--- a/drivers/clocksource/bcm_kona_timer.c
+++ b/drivers/clocksource/bcm_kona_timer.c
@@ -103,16 +103,10 @@ static const struct of_device_id bcm_timer_ids[] __initconst = {
 	{},
 };
 
-static void __init kona_timers_init(void)
+static void __init kona_timers_init(struct device_node *node)
 {
-	struct device_node *node;
 	u32 freq;
 
-	node = of_find_matching_node(NULL, bcm_timer_ids);
-
-	if (!node)
-		panic("No timer");
-
 	if (!of_property_read_u32(node, "clock-frequency", &freq))
 		arch_timer_rate = freq;
 	else
@@ -199,13 +193,12 @@ static struct irqaction kona_timer_irq = {
 	.handler = kona_timer_interrupt,
 };
 
-static void __init kona_timer_init(void)
+static void __init kona_timer_init(struct device_node *node)
 {
-	kona_timers_init();
+	kona_timers_init(node);
 	kona_timer_clockevents_init();
 	setup_irq(timers.tmr_irq, &kona_timer_irq);
 	kona_timer_set_next_event((arch_timer_rate / HZ), NULL);
 }
 
-CLOCKSOURCE_OF_DECLARE(bcm_kona, "bcm,kona-timer",
-	kona_timer_init);
+CLOCKSOURCE_OF_DECLARE(bcm_kona, "bcm,kona-timer", kona_timer_init);
-- 
1.8.1.2

