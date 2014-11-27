Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbaK0MDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:03:30 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:61880 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbaK0MD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:03:26 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Sven Schnelle <svens@stackframe.org>,
        Xunlei Pang <pang.xunlei@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: [RFC PATCH 2/4] rtc: Convert rtc_class_ops.set_mmss() to use time64_t
Date: Thu, 27 Nov 2014 20:02:38 +0800
Message-Id: <1417089760-26848-3-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417089760-26848-1-git-send-email-pang.xunlei@linaro.org>
References: <1417089760-26848-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the rtc_class_op's set_mmss() function takes a 32bit second
value (on 32bit systems), which is problematic for dates past y2038.

This patch resolves it by changing the interface and all users to use
y2038 safe time64_t.

Cc: John Stultz <john.stultz@linaro.org>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
This patch leaves some "y2106 issue" tags in the problematic drivers
whose rtc hardware only provides 32bit time. The handling of these
problematic drivers will be left to the succeeding patch series.
But, to better understand the purpose of this patch series, one of
those drivers is picked and resolved in the last patch as an example.

 arch/alpha/kernel/rtc.c     |    4 ++--
 drivers/rtc/interface.c     |    8 ++++----
 drivers/rtc/rtc-ab3100.c    |    4 ++--
 drivers/rtc/rtc-coh901331.c |    8 +++++++-
 drivers/rtc/rtc-ds1672.c    |    8 +++++++-
 drivers/rtc/rtc-ds2404.c    |    9 ++++++++-
 drivers/rtc/rtc-ep93xx.c    |    8 +++++++-
 drivers/rtc/rtc-imxdi.c     |    8 +++++++-
 drivers/rtc/rtc-jz4740.c    |    8 +++++++-
 drivers/rtc/rtc-lpc32xx.c   |    9 ++++++++-
 drivers/rtc/rtc-mc13xxx.c   |    5 ++---
 drivers/rtc/rtc-mxc.c       |    6 +++---
 drivers/rtc/rtc-pcap.c      |    6 ++----
 drivers/rtc/rtc-stmp3xxx.c  |    8 +++++++-
 drivers/rtc/rtc-test.c      |    4 ++--
 drivers/rtc/rtc-tx4939.c    |    8 +++++++-
 drivers/rtc/rtc-wm831x.c    |   16 +++++++++-------
 drivers/rtc/rtc-xgene.c     |    6 +++++-
 include/linux/rtc.h         |    2 +-
 19 files changed, 97 insertions(+), 38 deletions(-)

diff --git a/arch/alpha/kernel/rtc.c b/arch/alpha/kernel/rtc.c
index c8d284d..c398a23 100644
--- a/arch/alpha/kernel/rtc.c
+++ b/arch/alpha/kernel/rtc.c
@@ -116,7 +116,7 @@ alpha_rtc_set_time(struct device *dev, struct rtc_time *tm)
 }
 
 static int
-alpha_rtc_set_mmss(struct device *dev, unsigned long nowtime)
+alpha_rtc_set_mmss(struct device *dev, time64_t nowtime)
 {
 	int retval = 0;
 	int real_seconds, real_minutes, cmos_minutes;
@@ -276,7 +276,7 @@ do_remote_mmss(void *data)
 }
 
 static int
-remote_set_mmss(struct device *dev, unsigned long now)
+remote_set_mmss(struct device *dev, time64_t now)
 {
 	union remote_data x;
 	if (smp_processor_id() != boot_cpuid) {
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 5b2717f..f409a36 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -65,10 +65,10 @@ int rtc_set_time(struct rtc_device *rtc, struct rtc_time *tm)
 	else if (rtc->ops->set_time)
 		err = rtc->ops->set_time(rtc->dev.parent, tm);
 	else if (rtc->ops->set_mmss) {
-		unsigned long secs;
-		err = rtc_tm_to_time(tm, &secs);
-		if (err == 0)
-			err = rtc->ops->set_mmss(rtc->dev.parent, secs);
+		time64_t secs;
+
+		secs = rtc_tm_to_time64(tm);
+		err = rtc->ops->set_mmss(rtc->dev.parent, secs);
 	} else
 		err = -EINVAL;
 
diff --git a/drivers/rtc/rtc-ab3100.c b/drivers/rtc/rtc-ab3100.c
index ff43534..1cf4cd4 100644
--- a/drivers/rtc/rtc-ab3100.c
+++ b/drivers/rtc/rtc-ab3100.c
@@ -43,12 +43,12 @@
 /*
  * RTC clock functions and device struct declaration
  */
-static int ab3100_rtc_set_mmss(struct device *dev, unsigned long secs)
+static int ab3100_rtc_set_mmss(struct device *dev, time64_t secs)
 {
 	u8 regs[] = {AB3100_TI0, AB3100_TI1, AB3100_TI2,
 		     AB3100_TI3, AB3100_TI4, AB3100_TI5};
 	unsigned char buf[6];
-	u64 fat_time = (u64) secs * AB3100_RTC_CLOCK_RATE * 2;
+	time64_t fat_time = secs * AB3100_RTC_CLOCK_RATE * 2;
 	int err = 0;
 	int i;
 
diff --git a/drivers/rtc/rtc-coh901331.c b/drivers/rtc/rtc-coh901331.c
index 869cae2..85fd650 100644
--- a/drivers/rtc/rtc-coh901331.c
+++ b/drivers/rtc/rtc-coh901331.c
@@ -88,11 +88,17 @@ static int coh901331_read_time(struct device *dev, struct rtc_time *tm)
 	return -EINVAL;
 }
 
-static int coh901331_set_mmss(struct device *dev, unsigned long secs)
+static int coh901331_set_mmss(struct device *dev, time64_t secs)
 {
 	struct coh901331_port *rtap = dev_get_drvdata(dev);
 
 	clk_enable(rtap->clk);
+	/*
+	 * y2106 issue:
+	 *   On 32bit systems the time64_t secs value gets cast to
+	 *   a 32bit long, and thus we can only write a maximum value
+	 *   of y2016
+	 */
 	writel(secs, rtap->virtbase + COH901331_SET_TIME);
 	clk_disable(rtap->clk);
 
diff --git a/drivers/rtc/rtc-ds1672.c b/drivers/rtc/rtc-ds1672.c
index a4888db..4da0f4a 100644
--- a/drivers/rtc/rtc-ds1672.c
+++ b/drivers/rtc/rtc-ds1672.c
@@ -98,8 +98,14 @@ static int ds1672_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	return ds1672_get_datetime(to_i2c_client(dev), tm);
 }
 
-static int ds1672_rtc_set_mmss(struct device *dev, unsigned long secs)
+static int ds1672_rtc_set_mmss(struct device *dev, time64_t secs)
 {
+	/*
+	 * y2106 issue:
+	 *   On 32bit systems the time64_t secs value gets cast to
+	 *   a 32bit long, and thus we can only write a maximum value
+	 *   of y2016
+	 */
 	return ds1672_set_mmss(to_i2c_client(dev), secs);
 }
 
diff --git a/drivers/rtc/rtc-ds2404.c b/drivers/rtc/rtc-ds2404.c
index fc209dc..ec50757 100644
--- a/drivers/rtc/rtc-ds2404.c
+++ b/drivers/rtc/rtc-ds2404.c
@@ -210,9 +210,16 @@ static int ds2404_read_time(struct device *dev, struct rtc_time *dt)
 	return rtc_valid_tm(dt);
 }
 
-static int ds2404_set_mmss(struct device *dev, unsigned long secs)
+static int ds2404_set_mmss(struct device *dev, time64_t secs)
 {
+	/*
+	 * y2106 issue:
+	 *   On 32bit systems the time64_t secs value gets cast to
+	 *   a 32bit long, and thus we can only write a maximum value
+	 *   of y2016
+	 */
 	u32 time = cpu_to_le32(secs);
+
 	ds2404_write_memory(dev, 0x203, 4, (u8 *)&time);
 	return 0;
 }
diff --git a/drivers/rtc/rtc-ep93xx.c b/drivers/rtc/rtc-ep93xx.c
index 5e4f5dc..6e50aaa8 100644
--- a/drivers/rtc/rtc-ep93xx.c
+++ b/drivers/rtc/rtc-ep93xx.c
@@ -69,10 +69,16 @@ static int ep93xx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	return 0;
 }
 
-static int ep93xx_rtc_set_mmss(struct device *dev, unsigned long secs)
+static int ep93xx_rtc_set_mmss(struct device *dev, time64_t secs)
 {
 	struct ep93xx_rtc *ep93xx_rtc = dev_get_platdata(dev);
 
+	/*
+	 * y2106 issue:
+	 *   On 32bit systems the time64_t secs value gets cast to
+	 *   a 32bit long, and thus we can only write a maximum value
+	 *   of y2016
+	 */
 	__raw_writel(secs + 1, ep93xx_rtc->mmio_base + EP93XX_RTC_LOAD);
 	return 0;
 }
diff --git a/drivers/rtc/rtc-imxdi.c b/drivers/rtc/rtc-imxdi.c
index cd741c7..34d76b2 100644
--- a/drivers/rtc/rtc-imxdi.c
+++ b/drivers/rtc/rtc-imxdi.c
@@ -209,7 +209,7 @@ static int dryice_rtc_read_time(struct device *dev, struct rtc_time *tm)
  * set the seconds portion of dryice time counter and clear the
  * fractional part.
  */
-static int dryice_rtc_set_mmss(struct device *dev, unsigned long secs)
+static int dryice_rtc_set_mmss(struct device *dev, time64_t secs)
 {
 	struct imxdi_dev *imxdi = dev_get_drvdata(dev);
 	int rc;
@@ -217,6 +217,12 @@ static int dryice_rtc_set_mmss(struct device *dev, unsigned long secs)
 	/* zero the fractional part first */
 	rc = di_write_wait(imxdi, 0, DTCLR);
 	if (rc == 0)
+		/*
+		 * y2106 issue:
+		 *   On 32bit systems the time64_t secs value gets cast to
+		 *   a 32bit long, and thus we can only write a maximum value
+		 *   of y2016
+		 */
 		rc = di_write_wait(imxdi, secs, DTCMR);
 
 	return rc;
diff --git a/drivers/rtc/rtc-jz4740.c b/drivers/rtc/rtc-jz4740.c
index 08f5160..06a8917 100644
--- a/drivers/rtc/rtc-jz4740.c
+++ b/drivers/rtc/rtc-jz4740.c
@@ -127,10 +127,16 @@ static int jz4740_rtc_read_time(struct device *dev, struct rtc_time *time)
 	return rtc_valid_tm(time);
 }
 
-static int jz4740_rtc_set_mmss(struct device *dev, unsigned long secs)
+static int jz4740_rtc_set_mmss(struct device *dev, time64_t secs)
 {
 	struct jz4740_rtc *rtc = dev_get_drvdata(dev);
 
+	/*
+	 * y2106 issue:
+	 *   On 32bit systems the time64_t secs value gets cast to
+	 *   a 32bit long, and thus we can only write a maximum value
+	 *   of y2016
+	 */
 	return jz4740_rtc_reg_write(rtc, JZ_REG_RTC_SEC, secs);
 }
 
diff --git a/drivers/rtc/rtc-lpc32xx.c b/drivers/rtc/rtc-lpc32xx.c
index f130c08..4b782a4 100644
--- a/drivers/rtc/rtc-lpc32xx.c
+++ b/drivers/rtc/rtc-lpc32xx.c
@@ -73,7 +73,7 @@ static int lpc32xx_rtc_read_time(struct device *dev, struct rtc_time *time)
 	return rtc_valid_tm(time);
 }
 
-static int lpc32xx_rtc_set_mmss(struct device *dev, unsigned long secs)
+static int lpc32xx_rtc_set_mmss(struct device *dev, time64_t secs)
 {
 	struct lpc32xx_rtc *rtc = dev_get_drvdata(dev);
 	u32 tmp;
@@ -83,6 +83,13 @@ static int lpc32xx_rtc_set_mmss(struct device *dev, unsigned long secs)
 	/* RTC must be disabled during count update */
 	tmp = rtc_readl(rtc, LPC32XX_RTC_CTRL);
 	rtc_writel(rtc, LPC32XX_RTC_CTRL, tmp | LPC32XX_RTC_CTRL_CNTR_DIS);
+
+	/*
+	 * y2106 issue:
+	 *   On 32bit systems the time64_t secs value gets cast to
+	 *   a 32bit long, and thus we can only write a maximum value
+	 *   of y2016
+	 */
 	rtc_writel(rtc, LPC32XX_RTC_UCOUNT, secs);
 	rtc_writel(rtc, LPC32XX_RTC_DCOUNT, 0xFFFFFFFF - secs);
 	rtc_writel(rtc, LPC32XX_RTC_CTRL, tmp &= ~LPC32XX_RTC_CTRL_CNTR_DIS);
diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
index 124996d..d87edf1 100644
--- a/drivers/rtc/rtc-mc13xxx.c
+++ b/drivers/rtc/rtc-mc13xxx.c
@@ -88,15 +88,14 @@ static int mc13xxx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	return rtc_valid_tm(tm);
 }
 
-static int mc13xxx_rtc_set_mmss(struct device *dev, unsigned long secs)
+static int mc13xxx_rtc_set_mmss(struct device *dev, time64_t secs)
 {
 	struct mc13xxx_rtc *priv = dev_get_drvdata(dev);
 	unsigned int seconds, days;
 	unsigned int alarmseconds;
 	int ret;
 
-	seconds = secs % SEC_PER_DAY;
-	days = secs / SEC_PER_DAY;
+	days = div_s64_rem(secs, SEC_PER_DAY, &seconds);
 
 	mc13xxx_lock(priv->mc13xxx);
 
diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
index 07bff34..3339571 100644
--- a/drivers/rtc/rtc-mxc.c
+++ b/drivers/rtc/rtc-mxc.c
@@ -297,7 +297,7 @@ static int mxc_rtc_read_time(struct device *dev, struct rtc_time *tm)
 /*
  * This function sets the internal RTC time based on tm in Gregorian date.
  */
-static int mxc_rtc_set_mmss(struct device *dev, unsigned long time)
+static int mxc_rtc_set_mmss(struct device *dev, time64_t time)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
@@ -308,9 +308,9 @@ static int mxc_rtc_set_mmss(struct device *dev, unsigned long time)
 	if (is_imx1_rtc(pdata)) {
 		struct rtc_time tm;
 
-		rtc_time_to_tm(time, &tm);
+		rtc_time64_to_tm(time, &tm);
 		tm.tm_year = 70;
-		rtc_tm_to_time(&tm, &time);
+		time = rtc_tm_to_time64(&tm);
 	}
 
 	/* Avoid roll-over from reading the different registers */
diff --git a/drivers/rtc/rtc-pcap.c b/drivers/rtc/rtc-pcap.c
index 40b5c63..1fe5849 100644
--- a/drivers/rtc/rtc-pcap.c
+++ b/drivers/rtc/rtc-pcap.c
@@ -98,16 +98,14 @@ static int pcap_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	return rtc_valid_tm(tm);
 }
 
-static int pcap_rtc_set_mmss(struct device *dev, unsigned long secs)
+static int pcap_rtc_set_mmss(struct device *dev, time64_t secs)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct pcap_rtc *pcap_rtc = platform_get_drvdata(pdev);
 	u32 tod, days;
 
-	tod = secs % SEC_PER_DAY;
+	days = div_s64_rem(secs, SEC_PER_DAY, &tod);
 	ezx_pcap_write(pcap_rtc->pcap, PCAP_REG_RTC_TOD, tod);
-
-	days = secs / SEC_PER_DAY;
 	ezx_pcap_write(pcap_rtc->pcap, PCAP_REG_RTC_DAY, days);
 
 	return 0;
diff --git a/drivers/rtc/rtc-stmp3xxx.c b/drivers/rtc/rtc-stmp3xxx.c
index ea96492..fe5f8bb 100644
--- a/drivers/rtc/rtc-stmp3xxx.c
+++ b/drivers/rtc/rtc-stmp3xxx.c
@@ -157,10 +157,16 @@ static int stmp3xxx_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
 	return 0;
 }
 
-static int stmp3xxx_rtc_set_mmss(struct device *dev, unsigned long t)
+static int stmp3xxx_rtc_set_mmss(struct device *dev, time64_t t)
 {
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
 
+	/*
+	 * y2106 issue:
+	 *   On 32bit systems the time64_t secs value gets cast to
+	 *   a 32bit long, and thus we can only write a maximum value
+	 *   of y2016
+	 */
 	writel(t, rtc_data->io + STMP3XXX_RTC_SECONDS);
 	return stmp3xxx_wait_time(rtc_data);
 }
diff --git a/drivers/rtc/rtc-test.c b/drivers/rtc/rtc-test.c
index 6599c20..3e831bc 100644
--- a/drivers/rtc/rtc-test.c
+++ b/drivers/rtc/rtc-test.c
@@ -34,9 +34,9 @@ static int test_rtc_read_time(struct device *dev,
 	return 0;
 }
 
-static int test_rtc_set_mmss(struct device *dev, unsigned long secs)
+static int test_rtc_set_mmss(struct device *dev, time64_t secs)
 {
-	dev_info(dev, "%s, secs = %lu\n", __func__, secs);
+	dev_info(dev, "%s, secs = %lld\n", __func__, (long long)secs);
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-tx4939.c b/drivers/rtc/rtc-tx4939.c
index 2e678c6..4165442 100644
--- a/drivers/rtc/rtc-tx4939.c
+++ b/drivers/rtc/rtc-tx4939.c
@@ -42,13 +42,19 @@ static int tx4939_rtc_cmd(struct tx4939_rtc_reg __iomem *rtcreg, int cmd)
 	return 0;
 }
 
-static int tx4939_rtc_set_mmss(struct device *dev, unsigned long secs)
+static int tx4939_rtc_set_mmss(struct device *dev, time64_t secs)
 {
 	struct tx4939rtc_plat_data *pdata = get_tx4939rtc_plat_data(dev);
 	struct tx4939_rtc_reg __iomem *rtcreg = pdata->rtcreg;
 	int i, ret;
 	unsigned char buf[6];
 
+	/*
+	 * y2106 issue:
+	 *   On 32bit systems the time64_t secs value gets cast to
+	 *   a 32bit long, and thus we can only write a maximum value
+	 *   of y2016
+	 */
 	buf[0] = 0;
 	buf[1] = 0;
 	buf[2] = secs;
diff --git a/drivers/rtc/rtc-wm831x.c b/drivers/rtc/rtc-wm831x.c
index 75aea4c..f9c03f4 100644
--- a/drivers/rtc/rtc-wm831x.c
+++ b/drivers/rtc/rtc-wm831x.c
@@ -169,15 +169,21 @@ static int wm831x_rtc_readtime(struct device *dev, struct rtc_time *tm)
 /*
  * Set current time and date in RTC
  */
-static int wm831x_rtc_set_mmss(struct device *dev, unsigned long time)
+static int wm831x_rtc_set_mmss(struct device *dev, time64_t time)
 {
 	struct wm831x_rtc *wm831x_rtc = dev_get_drvdata(dev);
 	struct wm831x *wm831x = wm831x_rtc->wm831x;
 	struct rtc_time new_tm;
-	unsigned long new_time;
+	time64_t new_time;
 	int ret;
 	int count = 0;
 
+	/*
+	 * y2106 issue:
+	 *   On 32bit systems the time64_t secs value gets cast to
+	 *   a 32bit long, and thus we can only write a maximum value
+	 *   of y2016
+	 */
 	ret = wm831x_reg_write(wm831x, WM831X_RTC_TIME_1,
 			       (time >> 16) & 0xffff);
 	if (ret < 0) {
@@ -215,11 +221,7 @@ static int wm831x_rtc_set_mmss(struct device *dev, unsigned long time)
 	if (ret < 0)
 		return ret;
 
-	ret = rtc_tm_to_time(&new_tm, &new_time);
-	if (ret < 0) {
-		dev_err(dev, "Failed to convert time: %d\n", ret);
-		return ret;
-	}
+	new_time = rtc_tm_to_time64(&new_tm);
 
 	/* Allow a second of change in case of tick */
 	if (new_time - time > 1) {
diff --git a/drivers/rtc/rtc-xgene.c b/drivers/rtc/rtc-xgene.c
index 14129cc..5dd329d 100644
--- a/drivers/rtc/rtc-xgene.c
+++ b/drivers/rtc/rtc-xgene.c
@@ -62,13 +62,17 @@ static int xgene_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	return rtc_valid_tm(tm);
 }
 
-static int xgene_rtc_set_mmss(struct device *dev, unsigned long secs)
+static int xgene_rtc_set_mmss(struct device *dev, time64_t secs)
 {
 	struct xgene_rtc_dev *pdata = dev_get_drvdata(dev);
 
 	/*
 	 * NOTE: After the following write, the RTC_CCVR is only reflected
 	 *       after the update cycle of 1 seconds.
+	 * y2106 issue:
+	 *   On 32bit systems the time64_t secs value gets cast to
+	 *   a 32bit long, and thus we can only write a maximum value
+	 *   of y2016
 	 */
 	writel((u32) secs, pdata->csr_base + RTC_CLR);
 	readl(pdata->csr_base + RTC_CLR); /* Force a barrier */
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 6d6be09..d080606 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -77,7 +77,7 @@ struct rtc_class_ops {
 	int (*read_alarm)(struct device *, struct rtc_wkalrm *);
 	int (*set_alarm)(struct device *, struct rtc_wkalrm *);
 	int (*proc)(struct device *, struct seq_file *);
-	int (*set_mmss)(struct device *, unsigned long secs);
+	int (*set_mmss)(struct device *, time64_t secs);
 	int (*read_callback)(struct device *, int data);
 	int (*alarm_irq_enable)(struct device *, unsigned int enabled);
 };
-- 
1.7.9.5

