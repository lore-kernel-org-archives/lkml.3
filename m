Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbaIQAnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 20:43:05 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:54377 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbaIQAnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 20:43:03 -0400
X-Original-SENDERIP: 10.178.36.63
X-Original-MAILFROM: chanho.min@lge.com
From: Chanho Min <chanho.min@lge.com>
To: Russell King <linux@arm.linux.org.uk>, Stephen Boyd <sboyd@codeaurora.org>,
        Michael Opdenacker <michael@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Chanho Min <chanho.min@lge.com>
Subject: [PATCH] ARM: timer-sp: ensure interrupt is cleared at sp804_clockevents_init
Date: Wed, 17 Sep 2014 09:42:51 +0900
Message-Id: <1410914571-8388-1-git-send-email-chanho.min@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When sp804 is registerd as clock event device, it may not be added to
tick device if the higher rated device is already registerd. In this case,
for uncertan reason, inetrrupt is occured without event_handler it cause
kernel panic. So Interrupt should be cleared before clockevent is registered.

Signed-off-by: Chanho Min <chanho.min@lge.com>
---
 arch/arm/common/timer-sp.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/common/timer-sp.c b/arch/arm/common/timer-sp.c
index fd6bff0..b658873 100644
--- a/arch/arm/common/timer-sp.c
+++ b/arch/arm/common/timer-sp.c
@@ -205,6 +205,8 @@ void __init __sp804_clockevents_init(void __iomem *base, unsigned int irq, struc
 
 	writel(0, base + TIMER_CTRL);
 
+	/* Ensure interrupt is cleared */
+	writel(1, clkevt_base + TIMER_INTCLR);
 	setup_irq(irq, &sp804_timer_irq);
 	clockevents_config_and_register(evt, rate, 0xf, 0xffffffff);
 }
-- 
1.7.9.5

