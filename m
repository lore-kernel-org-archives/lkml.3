Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab3CMGww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 02:52:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58070 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285Ab3CMGwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 02:52:50 -0400
From: Lokesh Vutla <lokeshvutla@ti.com>
To: <will.deacon@arm.com>
CC: <dietmar.eggemann@arm.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <santosh.shilimkar@ti.com>, <lokeshvutla@ti.com>
Subject: [PATCH] ARM: hw_breakpoint: Enable debug powerdown only if system supports 'has_ossr'
Date: Wed, 13 Mar 2013 12:22:33 +0530
Message-ID: <1363157553-21085-1-git-send-email-lokeshvutla@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit {9a6eb31 ARM: hw_breakpoint: Debug powerdown support for self-hosted
debug} introduces debug powerdown support for self-hosted debug.
While merging the patch 'has_ossr' check was removed which
was needed for hardwares which doesn't support self-hosted debug.
Pandaboard (A9) is one such hardware and Dietmar's orginial
patch did mention this issue.
Without that check on Panda with CPUIDLE enabled, a flood of
below messages thrown.

[ 3.597930] hw-breakpoint: CPU 0 failed to disable vector catch
[ 3.597991] hw-breakpoint: CPU 1 failed to disable vector catch

So restore that check back to avoid the mentioned issue.

Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Reported-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 arch/arm/kernel/hw_breakpoint.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
index 96093b7..0ba062d 100644
--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -1049,7 +1049,8 @@ static struct notifier_block __cpuinitdata dbg_cpu_pm_nb = {
 
 static void __init pm_init(void)
 {
-	cpu_pm_register_notifier(&dbg_cpu_pm_nb);
+	if (has_ossr)
+		cpu_pm_register_notifier(&dbg_cpu_pm_nb);
 }
 #else
 static inline void pm_init(void)
-- 
1.7.9.5

