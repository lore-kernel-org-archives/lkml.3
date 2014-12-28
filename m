Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaL1OUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 09:20:34 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:44437 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaL1OU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 09:20:29 -0500
From: Christoffer Dall <christoffer.dall@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>,
        Sonny Rao <sonnyrao@chromium.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Olof Johansson <olof@lixom.net>, Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>
Subject: [PATCH] clocksource: arch_timer: Fix arm64 platforms not booting
Date: Sun, 28 Dec 2014 15:20:31 +0100
Message-Id: <1419776431-26217-1-git-send-email-christoffer.dall@linaro.org>
X-Mailer: git-send-email 2.1.2.330.g565301e.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0b46b8a718c6e ("clocksource: arch_timer: Fix code to...") fixes
timer issues with certain ARMv7 platforms, but unfortunately breaks
arm64 platforms with hyp mode (EL2) enabled.

The commit only sets arch_timer_use_virtual to false under CONFIG_ARM,
but forgets that the config variable is also set in other code paths
(actually, right underneath the check in the patch) with detrimental
consequences as we've now introduced a direct early call to BUG() on
practically all arm64 platforms.

One could argue that this code could be refactored to use different
variables for checking which *timer* to use and which *counter* to use,
which seems to be the desired difference between ARM and arm64 in this
case, but this approach fixes an urgent issue for now.

Cc: Sonny Rao <sonnyrao@chromium.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
This was apparently already discovered by Yingjoe Chen in this thread
https://lkml.org/lkml/2014/11/24/41 and Catalin recommended a similar
fix.

 drivers/clocksource/arm_arch_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 6a79fc4..095c177 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -462,7 +462,7 @@ static void __init arch_counter_register(unsigned type)
 
 	/* Register the CP15 based counter if we have one */
 	if (type & ARCH_CP15_TIMER) {
-		if (arch_timer_use_virtual)
+		if (IS_ENABLED(CONFIG_ARM64) || arch_timer_use_virtual)
 			arch_timer_read_counter = arch_counter_get_cntvct;
 		else
 			arch_timer_read_counter = arch_counter_get_cntpct;
-- 
2.1.2.330.g565301e.dirty

