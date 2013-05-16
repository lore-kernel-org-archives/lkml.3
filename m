Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab3EPLQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:16:46 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:45661 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3EPLPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:15:43 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, rob.herring@calxeda.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] ARM: ux500: Only configure wake-up reasons on ux500 based platforms
Date: Thu, 16 May 2013 12:15:35 +0100
Message-Id: <1368702935-25599-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multiplatform calls all enabled platforms' initcalls. In the
ux500_idle_init() initcall we call into the DBx500-PRCMU which in turn
executes some ux500 specific register reads/writes. When running on
some !ux500 platforms this ends up causing a kernel Oops. This patch
ensures the PRCMU call is only invoked when running on ux500 based
platforms.

Reported-by: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpuidle.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/mach-ux500/cpuidle.c b/arch/arm/mach-ux500/cpuidle.c
index 317a2be..a45dd09 100644
--- a/arch/arm/mach-ux500/cpuidle.c
+++ b/arch/arm/mach-ux500/cpuidle.c
@@ -21,6 +21,7 @@
 #include <asm/proc-fns.h>
 
 #include "db8500-regs.h"
+#include "id.h"
 
 static atomic_t master = ATOMIC_INIT(0);
 static DEFINE_SPINLOCK(master_lock);
@@ -114,6 +115,9 @@ static struct cpuidle_driver ux500_idle_driver = {
 
 int __init ux500_idle_init(void)
 {
+	if (!(cpu_is_u8500_family() || cpu_is_ux540_family()))
+		return -ENODEV;
+
 	/* Configure wake up reasons */
 	prcmu_enable_wakeups(PRCMU_WAKEUP(ARM) | PRCMU_WAKEUP(RTC) |
 			     PRCMU_WAKEUP(ABB));
-- 
1.7.10.4

