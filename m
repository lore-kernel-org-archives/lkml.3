Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab3JGSZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 14:25:31 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3862 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab3JGSZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 14:25:29 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Tim Kryger" <tim.kryger@linaro.org>
To: "Christian Daudt" <bcm@fixthebug.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, "Chris Ball" <cjb@laptop.org>
cc: "Tim Kryger" <tim.kryger@linaro.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, patches@linaro.org
Subject: [PATCH v2 4/6] clocksource: kona: Add basic use of external
 clock
Date: Mon, 7 Oct 2013 11:23:58 -0700
Message-ID: <1381170240-23227-5-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1381170240-23227-1-git-send-email-tim.kryger@linaro.org>
References: <1381170240-23227-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
X-WSS-ID: 7E4C23070UO14823646-11-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an clock handle is specified in the device tree, enable it and use
it to determine the external clock frequency.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
---
 drivers/clocksource/bcm_kona_timer.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/bcm_kona_timer.c b/drivers/clocksource/bcm_kona_timer.c
index 0d7d8c3..fd11f96 100644
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
+		panic("neither clock-frequency or clocks handle in .dts file");
+	}
 
 	/* Setup IRQ numbers */
 	timers.tmr_irq = irq_of_parse_and_map(node, 0);
-- 
1.8.0.1


