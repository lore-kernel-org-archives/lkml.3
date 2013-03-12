Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab3CLWw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:52:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60650 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964783Ab3CLWo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:44:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Simon Baatz <gmbnomis@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [ 33/40] rtc: rtc-mv: Add support for clk to avoid lockups
Date: Tue, 12 Mar 2013 15:43:54 -0700
Message-Id: <20130312223214.995095830@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223211.492954675@linuxfoundation.org>
References: <20130312223211.492954675@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Lunn <andrew@lunn.ch>

commit 89c58c198b252f2bc20657fdd72a2aea788c435c upstream.

The Marvell RTC on Kirkwood makes use of the runit clock. Ensure the
driver clk_prepare_enable() this clock, otherwise there is a danger
the SoC will lockup when accessing RTC registers with the clock
disabled.

Reported-by: Simon Baatz <gmbnomis@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Simon Baatz <gmbnomis@gmail.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/kirkwood.dtsi |    1 +
 drivers/rtc/rtc-mv.c            |   28 ++++++++++++++++++++++++----
 2 files changed, 25 insertions(+), 4 deletions(-)

--- a/arch/arm/boot/dts/kirkwood.dtsi
+++ b/arch/arm/boot/dts/kirkwood.dtsi
@@ -31,6 +31,7 @@
 			compatible = "mrvl,kirkwood-rtc", "mrvl,orion-rtc";
 			reg = <0x10300 0x20>;
 			interrupts = <53>;
+			clocks = <&gate_clk 7>;
 		};
 	};
 };
--- a/drivers/rtc/rtc-mv.c
+++ b/drivers/rtc/rtc-mv.c
@@ -14,6 +14,7 @@
 #include <linux/platform_device.h>
 #include <linux/of.h>
 #include <linux/delay.h>
+#include <linux/clk.h>
 #include <linux/gfp.h>
 #include <linux/module.h>
 
@@ -41,6 +42,7 @@ struct rtc_plat_data {
 	struct rtc_device *rtc;
 	void __iomem *ioaddr;
 	int		irq;
+	struct clk	*clk;
 };
 
 static int mv_rtc_set_time(struct device *dev, struct rtc_time *tm)
@@ -221,6 +223,7 @@ static int __devinit mv_rtc_probe(struct
 	struct rtc_plat_data *pdata;
 	resource_size_t size;
 	u32 rtc_time;
+	int ret = 0;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
@@ -239,11 +242,17 @@ static int __devinit mv_rtc_probe(struct
 	if (!pdata->ioaddr)
 		return -ENOMEM;
 
+	pdata->clk = devm_clk_get(&pdev->dev, NULL);
+	/* Not all SoCs require a clock.*/
+	if (!IS_ERR(pdata->clk))
+		clk_prepare_enable(pdata->clk);
+
 	/* make sure the 24 hours mode is enabled */
 	rtc_time = readl(pdata->ioaddr + RTC_TIME_REG_OFFS);
 	if (rtc_time & RTC_HOURS_12H_MODE) {
 		dev_err(&pdev->dev, "24 Hours mode not supported.\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	/* make sure it is actually functional */
@@ -252,7 +261,8 @@ static int __devinit mv_rtc_probe(struct
 		rtc_time = readl(pdata->ioaddr + RTC_TIME_REG_OFFS);
 		if (rtc_time == 0x01000000) {
 			dev_err(&pdev->dev, "internal RTC not ticking\n");
-			return -ENODEV;
+			ret = -ENODEV;
+			goto out;
 		}
 	}
 
@@ -268,8 +278,10 @@ static int __devinit mv_rtc_probe(struct
 	} else
 		pdata->rtc = rtc_device_register(pdev->name, &pdev->dev,
 						 &mv_rtc_ops, THIS_MODULE);
-	if (IS_ERR(pdata->rtc))
-		return PTR_ERR(pdata->rtc);
+	if (IS_ERR(pdata->rtc)) {
+		ret = PTR_ERR(pdata->rtc);
+		goto out;
+	}
 
 	if (pdata->irq >= 0) {
 		writel(0, pdata->ioaddr + RTC_ALARM_INTERRUPT_MASK_REG_OFFS);
@@ -282,6 +294,11 @@ static int __devinit mv_rtc_probe(struct
 	}
 
 	return 0;
+out:
+	if (!IS_ERR(pdata->clk))
+		clk_disable_unprepare(pdata->clk);
+
+	return ret;
 }
 
 static int __exit mv_rtc_remove(struct platform_device *pdev)
@@ -292,6 +309,9 @@ static int __exit mv_rtc_remove(struct p
 		device_init_wakeup(&pdev->dev, 0);
 
 	rtc_device_unregister(pdata->rtc);
+	if (!IS_ERR(pdata->clk))
+		clk_disable_unprepare(pdata->clk);
+
 	return 0;
 }
 


