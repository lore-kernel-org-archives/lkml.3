Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946034Ab3FUUbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 16:31:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60766 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945951Ab3FUUbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 16:31:35 -0400
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: Marc Zyngier <Marc.Zyngier@arm.com>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: arch timer: Set the TVAL before timer is enabled
Date: Fri, 21 Jun 2013 13:31:24 -0700
Message-Id: <1371846684-23730-1-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some hardware, the timer deasserts the interrupt when a
new TVAL is written only when the enable bit is cleared.
Hence explicitly disable the timer and then program the
TVAL followed by enabling the timer.
If this order is not followed, there are chances that
you would not receive any timer interrupts.
This is done as suggested in https://lkml.org/lkml/2012/8/11/39

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 drivers/clocksource/arm_arch_timer.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index a2b2541..05ba0c2 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -103,9 +103,10 @@ static inline void set_next_event(const int access, unsigned long evt)
 {
 	unsigned long ctrl;
 	ctrl = arch_timer_reg_read(access, ARCH_TIMER_REG_CTRL);
-	ctrl |= ARCH_TIMER_CTRL_ENABLE;
-	ctrl &= ~ARCH_TIMER_CTRL_IT_MASK;
+	ctrl &= ~(ARCH_TIMER_CTRL_ENABLE | ARCH_TIMER_CTRL_IT_MASK);
+	arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl);
 	arch_timer_reg_write(access, ARCH_TIMER_REG_TVAL, evt);
+	ctrl |= ARCH_TIMER_CTRL_ENABLE;
 	arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl);
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

