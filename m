Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbaI2AYW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 20:24:22 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:46068 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbaI2AYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 20:24:03 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/13] clocksource: sirf: Disable counter before re-setting it
Date: Mon, 29 Sep 2014 02:23:43 +0200
Message-Id: <1411950226-21598-10-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411950226-21598-1-git-send-email-daniel.lezcano@linaro.org>
References: <5428A559.5050908@linaro.org>
 <1411950226-21598-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hao Liu <Hao.Liu@csr.com>

According to HW spec, we have to disable the counter before setting
it, if we don't this, in pressure test, sometimes the timer might
not generate interrupt any more.

And this patch also fixes a typo for register set by changing 0x7
to 0x3. 0x7 is loop mode in HW, but here we are using oneshot 0x3.

Signed-off-by: Hao Liu <Hao.Liu@csr.com>
Signed-off-by: Barry Song <Baohua.Song@csr.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/timer-marco.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-marco.c b/drivers/clocksource/timer-marco.c
index 330e930..caf7a20 100644
--- a/drivers/clocksource/timer-marco.c
+++ b/drivers/clocksource/timer-marco.c
@@ -63,7 +63,7 @@ static inline void sirfsoc_timer_count_disable(int idx)
 /* enable count and interrupt */
 static inline void sirfsoc_timer_count_enable(int idx)
 {
-	writel_relaxed(readl_relaxed(sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_0_CTRL + 4 * idx) | 0x7,
+	writel_relaxed(readl_relaxed(sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_0_CTRL + 4 * idx) | 0x3,
 		sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_0_CTRL + 4 * idx);
 }
 
@@ -103,6 +103,9 @@ static int sirfsoc_timer_set_next_event(unsigned long delta,
 {
 	int cpu = smp_processor_id();
 
+	/* disable timer first, then modify the related registers */
+	sirfsoc_timer_count_disable(cpu);
+
 	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_COUNTER_0 +
 		4 * cpu);
 	writel_relaxed(delta, sirfsoc_timer_base + SIRFSOC_TIMER_MATCH_0 +
-- 
1.9.1

