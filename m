Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaEWKfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:35:10 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:61506 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbaEWKcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:55 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 63/71] clocksource: Fix clocksource_mmio_readX_down
Date: Fri, 23 May 2014 12:31:43 +0200
Message-Id: <1400841111-6683-63-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiubo Li <Li.Xiubo@freescale.com>

For some clocksource devices, for example, the registers are 32-bit, while
the lower 16-bit is used for timer counting(And reading the upper 16-bit
will return 0).

For example, when the counter value is 0x00001111, and then the
~readl_relaxed(to_mmio_clksrc(c)->reg) will return the value of 0xFFFFEEEE,
but it should be 0x0000EEEE.

So just using the c->mask to mask the unused bits.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/mmio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/mmio.c b/drivers/clocksource/mmio.c
index 19a6b3f..1593ade 100644
--- a/drivers/clocksource/mmio.c
+++ b/drivers/clocksource/mmio.c
@@ -27,7 +27,7 @@ cycle_t clocksource_mmio_readl_up(struct clocksource *c)
 
 cycle_t clocksource_mmio_readl_down(struct clocksource *c)
 {
-	return ~(cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg);
+	return ~(cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg) & c->mask;
 }
 
 cycle_t clocksource_mmio_readw_up(struct clocksource *c)
@@ -37,7 +37,7 @@ cycle_t clocksource_mmio_readw_up(struct clocksource *c)
 
 cycle_t clocksource_mmio_readw_down(struct clocksource *c)
 {
-	return ~(cycle_t)readw_relaxed(to_mmio_clksrc(c)->reg);
+	return ~(cycle_t)readw_relaxed(to_mmio_clksrc(c)->reg) & c->mask;
 }
 
 /**
-- 
1.7.9.5

