Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbaHLCB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 22:01:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:18686 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaHLCBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 22:01:24 -0400
X-AuditID: cbfee61a-f79e46d00000134f-ac-53e9756d4f3d
From: y@samsung.com
To: a.zummo@towertech.it
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 4/5] rtc: s3c: Add support for RTC of Exynos3250 SoC
Date: Tue, 12 Aug 2014 11:01:10 +0900
Message-id: <1407808871-6046-5-git-send-email-y@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1407808871-6046-1-git-send-email-y@samsung.com>
References: <y@samsung.com> <1407808871-6046-1-git-send-email-y@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42I5/e+xgG5e6ctgg8srmCyWXLzKbnH9y3NW
	i94FV9kszja9Ybe4vGsOm8WM8/uYLPZ3djA6sHvsmXiSzaNvyypGj+nzfjJ5fN4kF8ASxWWT
	kpqTWZZapG+XwJXxZftLxoJpcRXLv9xma2B86tvFyMkhIWAicf1iOwuELSZx4d56ti5GLg4h
	gUWMEn3tN5ggnCYmiX2fnzF3MXJwsAkIS0w9oAXSICIgIbFkzh1GkBpmgd2MEpPXvASbJCzg
	JrFg4nxmEJtFQFWie8ICRhCbV8BGomvVClaIbXISH/Y8YgexOQVsJX4tWQHWKyTgI3Fv8g3W
	CYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEB9MzqR2MKxssDjEKcDAq8fDO+Psi
	WIg1say4MvcQowQHs5II7zHZl8FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+0WgcKCaQnlqRm
	p6YWpBbBZJk4OKUaGHOnbt2flyl8r3K6l8X/PUzHhX+ubAqZ2FO1t9z39eoNpqHNH54sz9mZ
	MG3yedPqhR4r301z/WG1c4WP98XbEySFVb2tYyynfdv2X+16pWx/Xe66DUFOa0r2mHavu2+7
	w9q9xmzKciFOkVfz4tzCLvt3zrk3IzHt+f4DM8PKjZq7oteuzWL946HEUpyRaKjFXFScCADr
	NQOhIgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chanwoo Choi <cw00.choi@samsung.com>

This patch add support for RTC of Exynos3250 SoC. The Exynos3250 needs source
clock(32.768KHz) for RTC block. If source clock of RTC is registerd on clock
list of common clk framework, Exynos RTC drvier have to control this clock.

Clock list for s3c-rtc device:
- rtc : CLK_RTC of CLK_GATE_IP_PERIR is gate clock for RTC.
- rtc_src : XrtcXTI is 32.768.kHz source clock for RTC.
 (XRTCXTI: Specifies a clock from 32.768 kHz crystal pad with XRTCXTI and
 XRTCXTO pins. RTC uses this clock as the source of a real-time clock.)

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/devicetree/bindings/rtc/s3c-rtc.txt |  1 +
 drivers/rtc/rtc-s3c.c                             | 93 ++++++++++++++++++++++-
 2 files changed, 93 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/rtc/s3c-rtc.txt b/Documentation/devicetree/bindings/rtc/s3c-rtc.txt
index 06db446..ab757b84 100644
--- a/Documentation/devicetree/bindings/rtc/s3c-rtc.txt
+++ b/Documentation/devicetree/bindings/rtc/s3c-rtc.txt
@@ -6,6 +6,7 @@ Required properties:
     * "samsung,s3c2416-rtc" - for controllers compatible with s3c2416 rtc.
     * "samsung,s3c2443-rtc" - for controllers compatible with s3c2443 rtc.
     * "samsung,s3c6410-rtc" - for controllers compatible with s3c6410 rtc.
+    * "samsung,exynos3250-rtc" - for controllers compatible with exynos3250 rtc.
 - reg: physical base address of the controller and length of memory mapped
   region.
 - interrupts: Two interrupt numbers to the cpu should be specified. First
diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 26a88f9..90dcf51 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -38,6 +38,7 @@ struct s3c_rtc {
 
 	void __iomem *base;
 	struct clk *rtc_clk;
+	struct clk *rtc_src_clk;
 	bool enabled;
 
 	struct s3c_rtc_data *data;
@@ -54,6 +55,7 @@ struct s3c_rtc {
 
 struct s3c_rtc_data {
 	int max_user_freq;
+	bool needs_src_clk;
 
 	void (*irq_handler) (struct s3c_rtc *info, int mask);
 	void (*set_freq) (struct s3c_rtc *info, int freq);
@@ -73,10 +75,14 @@ static void s3c_rtc_alarm_clk_enable(struct s3c_rtc *info, bool enable)
 	if (enable) {
 		if (!info->enabled) {
 			clk_enable(info->rtc_clk);
+			if (info->data->needs_src_clk)
+				clk_enable(info->rtc_src_clk);
 			info->enabled = true;
 		}
 	} else {
 		if (info->enabled) {
+			if (info->data->needs_src_clk)
+				clk_disable(info->rtc_src_clk);
 			clk_disable(info->rtc_clk);
 			info->enabled = false;
 		}
@@ -117,12 +123,16 @@ static int s3c_rtc_setaie(struct device *dev, unsigned int enabled)
 	dev_dbg(info->dev, "%s: aie=%d\n", __func__, enabled);
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 	tmp = readb(info->base + S3C2410_RTCALM) & ~S3C2410_RTCALM_ALMEN;
 
 	if (enabled)
 		tmp |= S3C2410_RTCALM_ALMEN;
 
 	writeb(tmp, info->base + S3C2410_RTCALM);
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	s3c_rtc_alarm_clk_enable(info, enabled);
@@ -137,12 +147,16 @@ static int s3c_rtc_setfreq(struct s3c_rtc *info, int freq)
 		return -EINVAL;
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 	spin_lock_irq(&info->pie_lock);
 
 	if (info->data->set_freq)
 		info->data->set_freq(info, freq);
 
 	spin_unlock_irq(&info->pie_lock);
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	return 0;
@@ -158,6 +172,9 @@ static int s3c_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
 		return -EINVAL;
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
+
  retry_get_time:
 	rtc_tm->tm_min  = readb(info->base + S3C2410_RTCMIN);
 	rtc_tm->tm_hour = readb(info->base + S3C2410_RTCHOUR);
@@ -191,6 +208,8 @@ static int s3c_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
 
 	rtc_tm->tm_mon -= 1;
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	return rtc_valid_tm(rtc_tm);
@@ -216,6 +235,8 @@ static int s3c_rtc_settime(struct device *dev, struct rtc_time *tm)
 	}
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 
 	writeb(bin2bcd(tm->tm_sec),  info->base + S3C2410_RTCSEC);
 	writeb(bin2bcd(tm->tm_min),  info->base + S3C2410_RTCMIN);
@@ -224,6 +245,8 @@ static int s3c_rtc_settime(struct device *dev, struct rtc_time *tm)
 	writeb(bin2bcd(tm->tm_mon + 1), info->base + S3C2410_RTCMON);
 	writeb(bin2bcd(year), info->base + S3C2410_RTCYEAR);
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	return 0;
@@ -239,6 +262,9 @@ static int s3c_rtc_getalarm(struct device *dev, struct rtc_wkalrm *alrm)
 		return -EINVAL;
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
+
 	alm_tm->tm_sec  = readb(info->base + S3C2410_ALMSEC);
 	alm_tm->tm_min  = readb(info->base + S3C2410_ALMMIN);
 	alm_tm->tm_hour = readb(info->base + S3C2410_ALMHOUR);
@@ -290,7 +316,10 @@ static int s3c_rtc_getalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	else
 		alm_tm->tm_year = -1;
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
+
 	return 0;
 }
 
@@ -304,6 +333,9 @@ static int s3c_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 		return -EINVAL;
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
+
 	dev_dbg(dev, "s3c_rtc_setalarm: %d, %04d.%02d.%02d %02d:%02d:%02d\n",
 		 alrm->enabled,
 		 1900 + tm->tm_year, tm->tm_mon + 1, tm->tm_mday,
@@ -333,6 +365,8 @@ static int s3c_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 	s3c_rtc_setaie(dev, alrm->enabled);
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	return 0;
@@ -346,10 +380,14 @@ static int s3c_rtc_proc(struct device *dev, struct seq_file *seq)
 		return -EINVAL;
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 
 	if (info->data->enable_tick)
 		info->data->enable_tick(info, seq);
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	return 0;
@@ -369,6 +407,8 @@ static void s3c24xx_rtc_enable(struct s3c_rtc *info)
 	unsigned int con, tmp;
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 
 	con = readw(info->base + S3C2410_RTCCON);
 	/* re-enable the device, and check it is ok */
@@ -396,6 +436,8 @@ static void s3c24xx_rtc_enable(struct s3c_rtc *info)
 			info->base + S3C2410_RTCCON);
 	}
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 }
 
@@ -404,6 +446,8 @@ static void s3c24xx_rtc_disable(struct s3c_rtc *info)
 	unsigned int con;
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 
 	con = readw(info->base + S3C2410_RTCCON);
 	con &= ~S3C2410_RTCCON_RTCEN;
@@ -413,6 +457,8 @@ static void s3c24xx_rtc_disable(struct s3c_rtc *info)
 	con &= ~S3C2410_TICNT_ENABLE;
 	writeb(con, info->base + S3C2410_TICNT);
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 }
 
@@ -421,12 +467,16 @@ static void s3c6410_rtc_disable(struct s3c_rtc *info)
 	unsigned int con;
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 
 	con = readw(info->base + S3C2410_RTCCON);
 	con &= ~S3C64XX_RTCCON_TICEN;
 	con &= ~S3C2410_RTCCON_RTCEN;
 	writew(con, info->base + S3C2410_RTCCON);
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 }
 
@@ -498,11 +548,19 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 
 	info->rtc_clk = devm_clk_get(&pdev->dev, "rtc");
 	if (IS_ERR(info->rtc_clk)) {
-		dev_err(&pdev->dev, "failed to find rtc clock source\n");
+		dev_err(&pdev->dev, "failed to find rtc clock\n");
 		return PTR_ERR(info->rtc_clk);
 	}
 	clk_prepare_enable(info->rtc_clk);
 
+	info->rtc_src_clk = devm_clk_get(&pdev->dev, "rtc_src");
+	if (IS_ERR(info->rtc_src_clk)) {
+		dev_err(&pdev->dev, "failed to find rtc source clock\n");
+		return PTR_ERR(info->rtc_src_clk);
+	}
+	clk_prepare_enable(info->rtc_src_clk);
+
+
 	/* check to see if everything is setup correctly */
 	if (info->data->enable)
 		info->data->enable(info);
@@ -556,6 +614,8 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 
 	s3c_rtc_setfreq(info, 1);
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	return 0;
@@ -575,6 +635,8 @@ static int s3c_rtc_suspend(struct device *dev)
 	struct s3c_rtc *info = dev_get_drvdata(dev);
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 
 	/* save TICNT for anyone using periodic interrupts */
 	if (info->data->save_tick_cnt)
@@ -590,6 +652,8 @@ static int s3c_rtc_suspend(struct device *dev)
 			dev_err(dev, "enable_irq_wake failed\n");
 	}
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	return 0;
@@ -600,6 +664,8 @@ static int s3c_rtc_resume(struct device *dev)
 	struct s3c_rtc *info = dev_get_drvdata(dev);
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 
 	if (info->data->enable)
 		info->data->enable(info);
@@ -612,6 +678,8 @@ static int s3c_rtc_resume(struct device *dev)
 		info->wake_en = false;
 	}
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	return 0;
@@ -622,7 +690,11 @@ static SIMPLE_DEV_PM_OPS(s3c_rtc_pm_ops, s3c_rtc_suspend, s3c_rtc_resume);
 static void s3c24xx_rtc_irq(struct s3c_rtc *info, int mask)
 {
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 	rtc_update_irq(info->rtc, 1, RTC_AF | RTC_IRQF);
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	s3c_rtc_alarm_clk_enable(info, false);
@@ -631,8 +703,12 @@ static void s3c24xx_rtc_irq(struct s3c_rtc *info, int mask)
 static void s3c6410_rtc_irq(struct s3c_rtc *info, int mask)
 {
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 	rtc_update_irq(info->rtc, 1, RTC_AF | RTC_IRQF);
 	writeb(mask, info->base + S3C2410_INTP);
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	s3c_rtc_alarm_clk_enable(info, false);
@@ -798,6 +874,18 @@ static struct s3c_rtc_data const s3c6410_rtc_data = {
 	.disable		= s3c6410_rtc_disable,
 };
 
+static struct s3c_rtc_data const exynos3250_rtc_data = {
+	.max_user_freq		= 32768,
+	.needs_src_clk		= true,
+	.irq_handler		= s3c6410_rtc_irq,
+	.set_freq		= s3c6410_rtc_setfreq,
+	.enable_tick		= s3c6410_rtc_enable_tick,
+	.save_tick_cnt		= s3c6410_rtc_save_tick_cnt,
+	.restore_tick_cnt	= s3c6410_rtc_restore_tick_cnt,
+	.enable			= s3c24xx_rtc_enable,
+	.disable		= s3c6410_rtc_disable,
+};
+
 static const struct of_device_id s3c_rtc_dt_match[] = {
 	{
 		.compatible = "samsung,s3c2410-rtc",
@@ -811,6 +899,9 @@ static const struct of_device_id s3c_rtc_dt_match[] = {
 	}, {
 		.compatible = "samsung,s3c6410-rtc",
 		.data = (void *)&s3c6410_rtc_data,
+	}, {
+		.compatible = "samsung,exynos3250-rtc",
+		.data = (void *)&exynos3250_rtc_data,
 	},
 	{ /* sentinel */ },
 };
-- 
1.8.0

