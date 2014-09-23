Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbaIWLY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 07:24:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56657 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755786AbaIWLY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:24:27 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Johan Hovold <jhovold@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v8 08/10] rtc: at91sam9: use clk API instead of relying on AT91_SLOW_CLOCK
Date: Tue, 23 Sep 2014 13:24:02 +0200
Message-Id: <1411471444-2764-9-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411471444-2764-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1411471444-2764-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RTT block is using the slow clock which is accessible through the clk
API.
Use the clk API to retrieve, enable and get the slow clk rate instead of
the AT91_SLOW_CLOCK macro (which hardcodes the slow clk rate).
Doing this allows us to reference the clk thus preventing the CCF from
disabling it during the "disable unused" phase.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Johan Hovold <johan@kernel.org>
---
 drivers/rtc/rtc-at91sam9.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index be9c28b..2eca624 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -23,6 +23,7 @@
 #include <linux/io.h>
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
+#include <linux/clk.h>
 
 /*
  * This driver uses two configurable hardware resources that live in the
@@ -61,8 +62,6 @@
 #define AT91_RTT_ALMS		(1 << 0)		/* Real-time Alarm Status */
 #define AT91_RTT_RTTINC		(1 << 1)		/* Real-time Timer Increment */
 
-#define AT91_SLOW_CLOCK		32768
-
 /*
  * We store ALARM_DISABLED in ALMV to record that no alarm is set.
  * It's also the reset value for that field.
@@ -77,6 +76,7 @@ struct sam9_rtc {
 	struct regmap		*gpbr;
 	unsigned int		gpbr_offset;
 	int 			irq;
+	struct clk		*sclk;
 };
 
 #define rtt_readl(rtc, field) \
@@ -328,6 +328,7 @@ static int at91_rtc_probe(struct platform_device *pdev)
 	struct sam9_rtc	*rtc;
 	int		ret, irq;
 	u32		mr;
+	unsigned int	sclk_rate;
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
@@ -385,11 +386,27 @@ static int at91_rtc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	rtc->sclk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(rtc->sclk))
+		return PTR_ERR(rtc->sclk);
+
+	sclk_rate = clk_get_rate(rtc->sclk);
+	if (!sclk_rate || sclk_rate > AT91_RTT_RTPRES) {
+		dev_err(&pdev->dev, "Invalid slow clock rate");
+		return -EINVAL;
+	}
+
+	ret = clk_prepare_enable(rtc->sclk);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not enable slow clock");
+		return ret;
+	}
+
 	mr = rtt_readl(rtc, MR);
 
 	/* unless RTT is counting at 1 Hz, re-initialize it */
-	if ((mr & AT91_RTT_RTPRES) != AT91_SLOW_CLOCK) {
-		mr = AT91_RTT_RTTRST | (AT91_SLOW_CLOCK & AT91_RTT_RTPRES);
+	if ((mr & AT91_RTT_RTPRES) != sclk_rate) {
+		mr = AT91_RTT_RTTRST | (sclk_rate & AT91_RTT_RTPRES);
 		gpbr_writel(rtc, 0);
 	}
 
@@ -434,6 +451,9 @@ static int at91_rtc_remove(struct platform_device *pdev)
 	/* disable all interrupts */
 	rtt_writel(rtc, MR, mr & ~(AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN));
 
+	if (!IS_ERR(rtc->sclk))
+		clk_disable_unprepare(rtc->sclk);
+
 	return 0;
 }
 
-- 
1.9.1

