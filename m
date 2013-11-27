Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab3K0MuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 07:50:12 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42556 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756598Ab3K0MuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 07:50:06 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mark.rutland@arm.com>,
        <wim@iguana.be>, <nsekhar@ti.com>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <Pawel.Moll@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <galak@kernel.crashing.org>, <rob.herring@calxeda.com>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <grygorii.strashko@ti.com>, Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH v4 3/5] watchdog: davinci: add GET_TIMELEFT option support
Date: Wed, 27 Nov 2013 14:48:26 +0200
Message-ID: <1385556508-3935-4-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385556508-3935-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1385556508-3935-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the davinci watchdog can be read while counting,
so we can add ability to report the remaining time before
the system will reboot.

Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 drivers/watchdog/davinci_wdt.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index 2d46c43..0eb2189 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -116,6 +116,31 @@ static int davinci_wdt_ping(struct watchdog_device *wdd)
 	return 0;
 }
 
+static unsigned int davinci_wdt_get_timeleft(struct watchdog_device *wdd)
+{
+	u64 timer_counter;
+	unsigned long freq;
+	u32 val;
+	struct davinci_wdt_device *davinci_wdt = watchdog_get_drvdata(wdd);
+
+	/* if timeout has occured then return 0 */
+	val = ioread32(davinci_wdt->base + WDTCR);
+	if (val & WDFLAG)
+		return 0;
+
+	freq = clk_get_rate(davinci_wdt->clk);
+
+	if (!freq)
+		return 0;
+
+	timer_counter = ioread32(davinci_wdt->base + TIM12);
+	timer_counter |= ((u64)ioread32(davinci_wdt->base + TIM34) << 32);
+
+	do_div(timer_counter, freq);
+
+	return wdd->timeout - timer_counter;
+}
+
 static const struct watchdog_info davinci_wdt_info = {
 	.options = WDIOF_KEEPALIVEPING,
 	.identity = "DaVinci Watchdog",
@@ -126,6 +151,7 @@ static const struct watchdog_ops davinci_wdt_ops = {
 	.start		= davinci_wdt_start,
 	.stop		= davinci_wdt_ping,
 	.ping		= davinci_wdt_ping,
+	.get_timeleft	= davinci_wdt_get_timeleft,
 };
 
 static int davinci_wdt_probe(struct platform_device *pdev)
-- 
1.7.9.5

