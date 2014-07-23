Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbaGWK5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:57:12 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52108 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293AbaGWKy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:54:29 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 17/25] clocksource: sirf: Fix incorrect clock enable counter for timer
Date: Wed, 23 Jul 2014 12:53:59 +0200
Message-Id: <1406112847-26275-17-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
References: <53CF93B2.6040903@linaro.org>
 <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhiwu Song <Zhiwu.Song@csr.com>

In the clocksource driver, we didn't explicitly enable the clock. it makes the
clk reference counter wrong. We didn't encounter any hang issue because the
tick's clock input has been open and is shared by some other hardware
components, but if we don't enable those components in kernel, in the stage of
disabling unused clk in kernel boot, Linux tick hangs.

This patch fixes it. it does an explicit prepare and enable to the clock input,
and increases the usage counter of the clk.

Signed-off-by: Zhiwu Song <Zhiwu.Song@csr.com>
Signed-off-by: Barry Song <Baohua.Song@csr.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/timer-marco.c  |    3 +++
 drivers/clocksource/timer-prima2.c |    3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/clocksource/timer-marco.c b/drivers/clocksource/timer-marco.c
index dbd3039..330e930 100644
--- a/drivers/clocksource/timer-marco.c
+++ b/drivers/clocksource/timer-marco.c
@@ -260,6 +260,9 @@ static void __init sirfsoc_marco_timer_init(struct device_node *np)
 
 	clk = of_clk_get(np, 0);
 	BUG_ON(IS_ERR(clk));
+
+	BUG_ON(clk_prepare_enable(clk));
+
 	rate = clk_get_rate(clk);
 
 	BUG_ON(rate < MARCO_CLOCK_FREQ);
diff --git a/drivers/clocksource/timer-prima2.c b/drivers/clocksource/timer-prima2.c
index a722aac..ce18d57 100644
--- a/drivers/clocksource/timer-prima2.c
+++ b/drivers/clocksource/timer-prima2.c
@@ -200,6 +200,9 @@ static void __init sirfsoc_prima2_timer_init(struct device_node *np)
 
 	clk = of_clk_get(np, 0);
 	BUG_ON(IS_ERR(clk));
+
+	BUG_ON(clk_prepare_enable(clk));
+
 	rate = clk_get_rate(clk);
 
 	BUG_ON(rate < PRIMA2_CLOCK_FREQ);
-- 
1.7.9.5

