Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaICIrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:47:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43941 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755505AbaICIpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:45:41 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 4/5] rtc: at91sam9: retain slow clock and check its rate
Date: Wed,  3 Sep 2014 10:45:33 +0200
Message-Id: <1409733934-14465-5-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409733934-14465-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1409733934-14465-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RTT block is using the slow clock and expect it to run at 32KHz.
Now that we moved to the CCF it's better to retain the clk reference so
that the CCF can't disable the slow clock considering it is unused.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/rtc/rtc-at91sam9.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index 57014b7..5c5093b 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -21,6 +21,7 @@
 #include <linux/slab.h>
 #include <linux/platform_data/atmel.h>
 #include <linux/io.h>
+#include <linux/clk.h>
 
 /*
  * This driver uses two configurable hardware resources that live in the
@@ -74,6 +75,7 @@ struct sam9_rtc {
 	u32			imr;
 	void __iomem		*gpbr;
 	int 			irq;
+	struct clk		*sclk;
 };
 
 #define rtt_readl(rtc, field) \
@@ -373,6 +375,25 @@ static int at91_rtc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	/* Retain slow clk if it is specified in the DT.
+	 * Do not complain if slow clk is missing, but check its rate
+	 * if it is available.
+	 */
+	rtc->sclk = devm_clk_get(&pdev->dev, NULL);
+	if (!IS_ERR(rtc->sclk)) {
+		if (clk_get_rate(rtc->sclk) != AT91_SLOW_CLOCK) {
+			dev_err(&pdev->dev,
+				"Invalid slow clock rate (expecting %lu got %lu)",
+				(unsigned long)AT91_SLOW_CLOCK,
+				clk_get_rate(rtc->sclk));
+			return -EINVAL;
+		}
+
+		ret = clk_prepare_enable(rtc->sclk);
+		if (ret)
+			return ret;
+	}
+
 	/* NOTE:  sam9260 rev A silicon has a ROM bug which resets the
 	 * RTT on at least some reboots.  If you have that chip, you must
 	 * initialize the time from some external source like a GPS, wall
@@ -397,6 +418,9 @@ static int at91_rtc_remove(struct platform_device *pdev)
 	/* disable all interrupts */
 	rtt_writel(rtc, MR, mr & ~(AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN));
 
+	if (!IS_ERR(rtc->sclk))
+		clk_disable_unprepare(rtc->sclk);
+
 	return 0;
 }
 
-- 
1.9.1

