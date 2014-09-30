Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaI3M0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:26:31 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:40462 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbaI3M02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:26:28 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH/RFC v2 2/4] ARM: shmobile: r8a7740 legacy: Sync arm_dbg_regs_available with D4 PM domain
Date: Tue, 30 Sep 2014 14:26:25 +0200
Message-Id: <1412079987-1827-3-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412079987-1827-1-git-send-email-geert+renesas@glider.be>
References: <1412079987-1827-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If power area D4, which contains the Coresight-ETM hardware block, is
powered down on R-Mobile A1 (r8a7740), the kernel crashes when
suspending from s2ram with:

    Internal error: Oops - undefined instruction: 0 [#1] ARM

This happens because dbg_cpu_pm_notify() calls reset_ctrl_regs(), which
can't access the debug registers as the debug module is powered down.

Keep the arm_dbg_regs_available flag in sync with the state of the D4 PM
domain to fix this.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
This is a fix on top of series "[PATCH v2 00/11] ARM: shmobile:
r8a7740/armadillo800eva legacy PM domain support"
(http://www.spinics.net/lists/arm-kernel/msg365435.html), to be folded
into "[PATCH v2 08/11] ARM: shmobile: r8a7740: Add D4 pm domain
support" (http://www.spinics.net/lists/arm-kernel/msg365437.html).

v2:
  - New

---
 arch/arm/mach-shmobile/pm-r8a7740.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm/mach-shmobile/pm-r8a7740.c b/arch/arm/mach-shmobile/pm-r8a7740.c
index f92e64fd91de5631..b4a52f4067a87105 100644
--- a/arch/arm/mach-shmobile/pm-r8a7740.c
+++ b/arch/arm/mach-shmobile/pm-r8a7740.c
@@ -12,6 +12,8 @@
 #include <linux/io.h>
 #include <linux/suspend.h>
 
+#include <asm/hw_breakpoint.h>
+
 #include "common.h"
 #include "pm-rmobile.h"
 
@@ -36,6 +38,21 @@ static int r8a7740_pd_a3sp_suspend(void)
 	return console_suspend_enabled ? 0 : -EBUSY;
 }
 
+/*
+ * The D4 domain contains the Coresight-ETM hardware block.
+ * The debug registers cannot be accessed while this domain is powered down.
+ */
+static int r8a7740_pd_d4_suspend(void)
+{
+	arm_dbg_regs_available = false;
+	return 0;
+}
+
+static void r8a7740_pd_d4_resume(void)
+{
+	arm_dbg_regs_available = true;
+}
+
 static struct rmobile_pm_domain r8a7740_pm_domains[] = {
 	{
 		.genpd.name	= "A4LC",
@@ -49,6 +66,8 @@ static struct rmobile_pm_domain r8a7740_pm_domains[] = {
 		.genpd.name	= "D4",
 		.base		= SYSC_BASE,
 		.bit_shift	= 3,
+		.suspend	= r8a7740_pd_d4_suspend,
+		.resume		= r8a7740_pd_d4_resume,
 	}, {
 		.genpd.name	= "A4R",
 		.base		= SYSC_BASE,
-- 
1.9.1

