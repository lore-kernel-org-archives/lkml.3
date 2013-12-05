Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab3LETaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:30:52 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:62777 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab3LETar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:30:47 -0500
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Dec 2013 14:30:46 EST
X-IronPort-AV: E=Sophos;i="4.93,835,1378882800"; 
   d="scan'208";a="366953"
From: Tim Kryger <tim.kryger@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        Axel Lin <axel.lin@ingics.com>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linaro Patches List <patches@linaro.org>
Subject: [PATCH v4 7/8] clocksource: kona: Add basic use of external clock
Date: Thu, 5 Dec 2013 11:20:43 -0800
Message-ID: <1386271244-3927-8-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1386271244-3927-1-git-send-email-tim.kryger@linaro.org>
References: <1386271244-3927-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an clock is specified in the device tree, enable it and use it to
determine the external clock frequency.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
---
 drivers/clocksource/bcm_kona_timer.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/bcm_kona_timer.c b/drivers/clocksource/bcm_kona_timer.c
index 0d7d8c3..8a4ab36 100644
--- a/drivers/clocksource/bcm_kona_timer.c
+++ b/drivers/clocksource/bcm_kona_timer.c
@@ -17,6 +17,7 @@
 #include <linux/jiffies.h>
 #include <linux/clockchips.h>
 #include <linux/types.h>
+#include <linux/clk.h>
 
 #include <linux/io.h>
 #include <asm/mach/time.h>
@@ -107,11 +108,18 @@ static const struct of_device_id bcm_timer_ids[] __initconst = {
 static void __init kona_timers_init(struct device_node *node)
 {
 	u32 freq;
+	struct clk *external_clk;
 
-	if (!of_property_read_u32(node, "clock-frequency", &freq))
+	external_clk = of_clk_get_by_name(node, NULL);
+
+	if (!IS_ERR(external_clk)) {
+		arch_timer_rate = clk_get_rate(external_clk);
+		clk_prepare_enable(external_clk);
+	} else if (!of_property_read_u32(node, "clock-frequency", &freq)) {
 		arch_timer_rate = freq;
-	else
-		panic("clock-frequency not set in the .dts file");
+	} else {
+		panic("unable to determine clock-frequency");
+	}
 
 	/* Setup IRQ numbers */
 	timers.tmr_irq = irq_of_parse_and_map(node, 0);
-- 
1.8.0.1

