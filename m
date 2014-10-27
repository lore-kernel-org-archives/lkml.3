Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaJ0FrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:47:19 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:50361 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaJ0FrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:47:14 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH RFC 03/12] time: Rename rtc_tm_to_time() to rtc_tm_to_time_unsafe()
Date: Mon, 27 Oct 2014 13:46:33 +0800
Message-Id: <1414388802-5866-2-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414388802-5866-1-git-send-email-pang.xunlei@linaro.org>
References: <1414388802-5866-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel uses 32-bit signed value(time_t) for seconds since 1970-01-01:00:00:00, thus it
will overflow at 2038-01-19 03:14:08 on 32-bit systems. We call this "2038 safety" issue.

Currently, rtc_tm_to_time() deals with "unsigned long" which is 2038 unsafe on 32-bit systems.

As part of addressing 2038 saftey for in-kernel uses, this patch creates no creates no functional
change in existing users, renames rtc_tm_to_time() to rtc_tm_to_time_unsafe(), and changes all its
calling users correspondingly. The safe version of rtc_tm_to_time() will be added in the following patch.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 arch/sh/kernel/time.c           |    2 +-
 drivers/power/charger-manager.c |    8 ++++----
 drivers/rtc/class.c             |    4 ++--
 drivers/rtc/hctosys.c           |    2 +-
 drivers/rtc/interface.c         |   10 +++++-----
 drivers/rtc/rtc-88pm80x.c       |   10 +++++-----
 drivers/rtc/rtc-88pm860x.c      |   10 +++++-----
 drivers/rtc/rtc-ab3100.c        |    2 +-
 drivers/rtc/rtc-ab8500.c        |   10 +++++-----
 drivers/rtc/rtc-at32ap700x.c    |    4 ++--
 drivers/rtc/rtc-at91sam9.c      |    4 ++--
 drivers/rtc/rtc-au1xxx.c        |    2 +-
 drivers/rtc/rtc-bfin.c          |    4 ++--
 drivers/rtc/rtc-coh901331.c     |    2 +-
 drivers/rtc/rtc-da9052.c        |    2 +-
 drivers/rtc/rtc-da9063.c        |    4 ++--
 drivers/rtc/rtc-davinci.c       |    4 ++--
 drivers/rtc/rtc-dev.c           |    4 ++--
 drivers/rtc/rtc-dm355evm.c      |    2 +-
 drivers/rtc/rtc-ds1305.c        |    4 ++--
 drivers/rtc/rtc-ds1374.c        |    6 +++---
 drivers/rtc/rtc-imxdi.c         |    2 +-
 drivers/rtc/rtc-isl1208.c       |    4 ++--
 drivers/rtc/rtc-jz4740.c        |    2 +-
 drivers/rtc/rtc-lib.c           |    8 ++++----
 drivers/rtc/rtc-lpc32xx.c       |    2 +-
 drivers/rtc/rtc-mc13xxx.c       |    2 +-
 drivers/rtc/rtc-mpc5121.c       |    2 +-
 drivers/rtc/rtc-mxc.c           |    4 ++--
 drivers/rtc/rtc-pcap.c          |    2 +-
 drivers/rtc/rtc-pl030.c         |    4 ++--
 drivers/rtc/rtc-pl031.c         |    6 +++---
 drivers/rtc/rtc-pm8xxx.c        |    4 ++--
 drivers/rtc/rtc-ps3.c           |    2 +-
 drivers/rtc/rtc-puv3.c          |    4 ++--
 drivers/rtc/rtc-sa1100.c        |    4 ++--
 drivers/rtc/rtc-sirfsoc.c       |    4 ++--
 drivers/rtc/rtc-snvs.c          |    4 ++--
 drivers/rtc/rtc-stmp3xxx.c      |    2 +-
 drivers/rtc/rtc-sun4v.c         |    2 +-
 drivers/rtc/rtc-sun6i.c         |    4 ++--
 drivers/rtc/rtc-sunxi.c         |    4 ++--
 drivers/rtc/rtc-sysfs.c         |    8 ++++----
 drivers/rtc/rtc-tegra.c         |    4 ++--
 drivers/rtc/rtc-tps6586x.c      |    4 ++--
 drivers/rtc/rtc-tx4939.c        |    2 +-
 drivers/rtc/rtc-wm831x.c        |    4 ++--
 drivers/rtc/rtc-xgene.c         |    2 +-
 include/linux/rtc.h             |    2 +-
 kernel/power/suspend_test.c     |    2 +-
 50 files changed, 100 insertions(+), 100 deletions(-)

diff --git a/arch/sh/kernel/time.c b/arch/sh/kernel/time.c
index ec1d24b..78a1632 100644
--- a/arch/sh/kernel/time.c
+++ b/arch/sh/kernel/time.c
@@ -67,7 +67,7 @@ int set_rtc_time(struct rtc_time *tm)
 {
 	unsigned long secs;
 
-	rtc_tm_to_time(tm, &secs);
+	rtc_tm_to_time_unsafe(tm, &secs);
 	return rtc_sh_set_time(secs);
 }
 EXPORT_SYMBOL(set_rtc_time);
diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 7098a1c..060aa2c 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -1031,7 +1031,7 @@ static bool cm_setup_timer(void)
 			 */
 			tmp.enabled = 1;
 			rtc_read_time(rtc_dev, &tmp.time);
-			rtc_tm_to_time(&tmp.time, &now);
+			rtc_tm_to_time_unsafe(&tmp.time, &now);
 			if (add < CM_RTC_SMALL)
 				add = CM_RTC_SMALL;
 			time = now + add;
@@ -1120,7 +1120,7 @@ out:
 		struct rtc_time tmp;
 
 		rtc_read_time(rtc_dev, &tmp);
-		rtc_tm_to_time(&tmp, &now);
+		rtc_tm_to_time_unsafe(&tmp, &now);
 
 		if (rtc_wkalarm_save_time &&
 		    now + CM_RTC_SMALL >= rtc_wkalarm_save_time)
@@ -1948,9 +1948,9 @@ static int cm_suspend_prepare(struct device *dev)
 			rtc_read_time(rtc_dev, &tmp);
 
 			if (rtc_wkalarm_save.enabled) {
-				rtc_tm_to_time(&rtc_wkalarm_save.time,
+				rtc_tm_to_time_unsafe(&rtc_wkalarm_save.time,
 					       &rtc_wkalarm_save_time);
-				rtc_tm_to_time(&tmp, &now);
+				rtc_tm_to_time_unsafe(&tmp, &now);
 				if (now > rtc_wkalarm_save_time)
 					rtc_wkalarm_save_time = 0;
 			} else {
diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 38e26be..cde2c8d 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -69,7 +69,7 @@ static int rtc_suspend(struct device *dev)
 	}
 
 	getnstimeofday(&old_system);
-	rtc_tm_to_time(&tm, &old_rtc.tv_sec);
+	rtc_tm_to_time_unsafe(&tm, &old_rtc.tv_sec);
 
 
 	/*
@@ -121,7 +121,7 @@ static int rtc_resume(struct device *dev)
 		pr_debug("%s:  bogus resume time\n", dev_name(&rtc->dev));
 		return 0;
 	}
-	rtc_tm_to_time(&tm, &new_rtc.tv_sec);
+	rtc_tm_to_time_unsafe(&tm, &new_rtc.tv_sec);
 	new_rtc.tv_nsec = 0;
 
 	if (new_rtc.tv_sec < old_rtc.tv_sec) {
diff --git a/drivers/rtc/hctosys.c b/drivers/rtc/hctosys.c
index 4aa60d7..4e9a5c6 100644
--- a/drivers/rtc/hctosys.c
+++ b/drivers/rtc/hctosys.c
@@ -52,7 +52,7 @@ static int __init rtc_hctosys(void)
 		goto err_invalid;
 	}
 
-	rtc_tm_to_time(&tm, &tv.tv_sec);
+	rtc_tm_to_time_unsafe(&tm, &tv.tv_sec);
 
 	err = do_settimeofday(&tv);
 
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 5b2717f..eff42e9 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -66,7 +66,7 @@ int rtc_set_time(struct rtc_device *rtc, struct rtc_time *tm)
 		err = rtc->ops->set_time(rtc->dev.parent, tm);
 	else if (rtc->ops->set_mmss) {
 		unsigned long secs;
-		err = rtc_tm_to_time(tm, &secs);
+		err = rtc_tm_to_time_unsafe(tm, &secs);
 		if (err == 0)
 			err = rtc->ops->set_mmss(rtc->dev.parent, secs);
 	} else
@@ -250,8 +250,8 @@ int __rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 	}
 
 	/* with luck, no rollover is needed */
-	rtc_tm_to_time(&now, &t_now);
-	rtc_tm_to_time(&alarm->time, &t_alm);
+	rtc_tm_to_time_unsafe(&now, &t_now);
+	rtc_tm_to_time_unsafe(&alarm->time, &t_alm);
 	if (t_now < t_alm)
 		goto done;
 
@@ -344,13 +344,13 @@ static int __rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 	err = rtc_valid_tm(&alarm->time);
 	if (err)
 		return err;
-	rtc_tm_to_time(&alarm->time, &scheduled);
+	rtc_tm_to_time_unsafe(&alarm->time, &scheduled);
 
 	/* Make sure we're not setting alarms in the past */
 	err = __rtc_read_time(rtc, &tm);
 	if (err)
 		return err;
-	rtc_tm_to_time(&tm, &now);
+	rtc_tm_to_time_unsafe(&tm, &now);
 	if (scheduled <= now)
 		return -ETIME;
 	/*
diff --git a/drivers/rtc/rtc-88pm80x.c b/drivers/rtc/rtc-88pm80x.c
index 0916089..ad10664 100644
--- a/drivers/rtc/rtc-88pm80x.c
+++ b/drivers/rtc/rtc-88pm80x.c
@@ -100,8 +100,8 @@ static void rtc_next_alarm_time(struct rtc_time *next, struct rtc_time *now,
 	next->tm_min = alrm->tm_min;
 	next->tm_sec = alrm->tm_sec;
 
-	rtc_tm_to_time(now, &now_time);
-	rtc_tm_to_time(next, &next_time);
+	rtc_tm_to_time_unsafe(now, &now_time);
+	rtc_tm_to_time_unsafe(next, &next_time);
 
 	if (next_time < now_time) {
 		/* Advance one day */
@@ -140,7 +140,7 @@ static int pm80x_rtc_set_time(struct device *dev, struct rtc_time *tm)
 			1900 + tm->tm_year);
 		return -EINVAL;
 	}
-	rtc_tm_to_time(tm, &ticks);
+	rtc_tm_to_time_unsafe(tm, &ticks);
 
 	/* load 32-bit read-only counter */
 	regmap_raw_read(info->map, PM800_RTC_COUNTER1, buf, 4);
@@ -206,7 +206,7 @@ static int pm80x_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	dev_dbg(info->dev, "%s, now time : %lu\n", __func__, ticks);
 	rtc_next_alarm_time(&alarm_tm, &now_tm, &alrm->time);
 	/* get new ticks for alarm in 24 hours */
-	rtc_tm_to_time(&alarm_tm, &ticks);
+	rtc_tm_to_time_unsafe(&alarm_tm, &ticks);
 	dev_dbg(info->dev, "%s, alarm time: %lu\n", __func__, ticks);
 	data = ticks - base;
 
@@ -311,7 +311,7 @@ static int pm80x_rtc_probe(struct platform_device *pdev)
 			goto out_rtc;
 		}
 	}
-	rtc_tm_to_time(&tm, &ticks);
+	rtc_tm_to_time_unsafe(&tm, &ticks);
 
 	info->rtc_dev = devm_rtc_device_register(&pdev->dev, "88pm80x-rtc",
 					    &pm80x_rtc_ops, THIS_MODULE);
diff --git a/drivers/rtc/rtc-88pm860x.c b/drivers/rtc/rtc-88pm860x.c
index 0c6add1..4fabd6f 100644
--- a/drivers/rtc/rtc-88pm860x.c
+++ b/drivers/rtc/rtc-88pm860x.c
@@ -96,8 +96,8 @@ static void rtc_next_alarm_time(struct rtc_time *next, struct rtc_time *now,
 	next->tm_min = alrm->tm_min;
 	next->tm_sec = alrm->tm_sec;
 
-	rtc_tm_to_time(now, &now_time);
-	rtc_tm_to_time(next, &next_time);
+	rtc_tm_to_time_unsafe(now, &now_time);
+	rtc_tm_to_time_unsafe(next, &next_time);
 
 	if (next_time < now_time) {
 		/* Advance one day */
@@ -141,7 +141,7 @@ static int pm860x_rtc_set_time(struct device *dev, struct rtc_time *tm)
 			1900 + tm->tm_year);
 		return -EINVAL;
 	}
-	rtc_tm_to_time(tm, &ticks);
+	rtc_tm_to_time_unsafe(tm, &ticks);
 
 	/* load 32-bit read-only counter */
 	pm860x_bulk_read(info->i2c, PM8607_RTC_COUNTER1, 4, buf);
@@ -210,7 +210,7 @@ static int pm860x_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	rtc_time_to_tm(ticks, &now_tm);
 	rtc_next_alarm_time(&alarm_tm, &now_tm, &alrm->time);
 	/* get new ticks for alarm in 24 hours */
-	rtc_tm_to_time(&alarm_tm, &ticks);
+	rtc_tm_to_time_unsafe(&alarm_tm, &ticks);
 	data = ticks - base;
 
 	buf[0] = data & 0xff;
@@ -367,7 +367,7 @@ static int pm860x_rtc_probe(struct platform_device *pdev)
 			return ret;
 		}
 	}
-	rtc_tm_to_time(&tm, &ticks);
+	rtc_tm_to_time_unsafe(&tm, &ticks);
 	if (pm860x_rtc_dt_init(pdev, info)) {
 		if (pdata && pdata->sync) {
 			pdata->sync(ticks);
diff --git a/drivers/rtc/rtc-ab3100.c b/drivers/rtc/rtc-ab3100.c
index ff43534..0beb865 100644
--- a/drivers/rtc/rtc-ab3100.c
+++ b/drivers/rtc/rtc-ab3100.c
@@ -152,7 +152,7 @@ static int ab3100_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	int err;
 	int i;
 
-	rtc_tm_to_time(&alarm->time, &secs);
+	rtc_tm_to_time_unsafe(&alarm->time, &secs);
 	fat_time = (u64) secs * AB3100_RTC_CLOCK_RATE * 2;
 	buf[0] = (fat_time >> 16) & 0xFF;
 	buf[1] = (fat_time >> 24) & 0xFF;
diff --git a/drivers/rtc/rtc-ab8500.c b/drivers/rtc/rtc-ab8500.c
index 727e2f5..1d326dc 100644
--- a/drivers/rtc/rtc-ab8500.c
+++ b/drivers/rtc/rtc-ab8500.c
@@ -80,7 +80,7 @@ static unsigned long get_elapsed_seconds(int year)
 	 * This function calculates secs from 1970 and not from
 	 * 1900, even if we supply the offset from year 1900.
 	 */
-	rtc_tm_to_time(&tm, &secs);
+	rtc_tm_to_time_unsafe(&tm, &secs);
 	return secs;
 }
 
@@ -146,7 +146,7 @@ static int ab8500_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	}
 
 	/* Get the number of seconds since 1970 */
-	rtc_tm_to_time(tm, &secs);
+	rtc_tm_to_time_unsafe(tm, &secs);
 
 	/*
 	 * Convert it to the number of seconds since 01-01-2000 00:00:00, since
@@ -239,7 +239,7 @@ static int ab8500_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	}
 
 	/* Get the number of seconds since 1970 */
-	rtc_tm_to_time(&alarm->time, &secs);
+	rtc_tm_to_time_unsafe(&alarm->time, &secs);
 
 	/*
 	 * Check whether alarm is set less than 1min.
@@ -247,7 +247,7 @@ static int ab8500_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	 * return -EINVAL, so UIE EMUL can take it up, incase of UIE_ON
 	 */
 	ab8500_rtc_read_time(dev, &curtm); /* Read current time */
-	rtc_tm_to_time(&curtm, &cursec);
+	rtc_tm_to_time_unsafe(&curtm, &cursec);
 	if ((secs - cursec) < 59) {
 		dev_dbg(dev, "Alarm less than 1 minute not supported\r\n");
 		return -EINVAL;
@@ -289,7 +289,7 @@ static int ab8540_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	}
 
 	/* Get the number of seconds since 1970 */
-	rtc_tm_to_time(&alarm->time, &secs);
+	rtc_tm_to_time_unsafe(&alarm->time, &secs);
 
 	/*
 	 * Convert it to the number of seconds since 01-01-2000 00:00:00
diff --git a/drivers/rtc/rtc-at32ap700x.c b/drivers/rtc/rtc-at32ap700x.c
index aee3387..26500c0 100644
--- a/drivers/rtc/rtc-at32ap700x.c
+++ b/drivers/rtc/rtc-at32ap700x.c
@@ -84,7 +84,7 @@ static int at32_rtc_settime(struct device *dev, struct rtc_time *tm)
 	unsigned long now;
 	int ret;
 
-	ret = rtc_tm_to_time(tm, &now);
+	ret = rtc_tm_to_time_unsafe(tm, &now);
 	if (ret == 0)
 		rtc_writel(rtc, VAL, now);
 
@@ -113,7 +113,7 @@ static int at32_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 	rtc_unix_time = rtc_readl(rtc, VAL);
 
-	ret = rtc_tm_to_time(&alrm->time, &alarm_unix_time);
+	ret = rtc_tm_to_time_unsafe(&alrm->time, &alarm_unix_time);
 	if (ret)
 		return ret;
 
diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index 5963743..6d83959 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -115,7 +115,7 @@ static int at91_rtc_settime(struct device *dev, struct rtc_time *tm)
 		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
 
-	err = rtc_tm_to_time(tm, &secs);
+	err = rtc_tm_to_time_unsafe(tm, &secs);
 	if (err != 0)
 		return err;
 
@@ -189,7 +189,7 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	u32 mr;
 	int err;
 
-	err = rtc_tm_to_time(tm, &secs);
+	err = rtc_tm_to_time_unsafe(tm, &secs);
 	if (err != 0)
 		return err;
 
diff --git a/drivers/rtc/rtc-au1xxx.c b/drivers/rtc/rtc-au1xxx.c
index fd25e23..4949259 100644
--- a/drivers/rtc/rtc-au1xxx.c
+++ b/drivers/rtc/rtc-au1xxx.c
@@ -43,7 +43,7 @@ static int au1xtoy_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	unsigned long t;
 
-	rtc_tm_to_time(tm, &t);
+	rtc_tm_to_time_unsafe(tm, &t);
 
 	alchemy_wrsys(t, AU1000_SYS_TOYWRITE);
 
diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index fe4bdb0..7910191 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -276,7 +276,7 @@ static int bfin_rtc_set_time(struct device *dev, struct rtc_time *tm)
 
 	dev_dbg_stamp(dev);
 
-	ret = rtc_tm_to_time(tm, &now);
+	ret = rtc_tm_to_time_unsafe(tm, &now);
 	if (ret == 0) {
 		if (rtc->rtc_wrote_regs & 0x1)
 			bfin_rtc_sync_pending(dev);
@@ -304,7 +304,7 @@ static int bfin_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 	dev_dbg_stamp(dev);
 
-	if (rtc_tm_to_time(&alrm->time, &rtc_alarm))
+	if (rtc_tm_to_time_unsafe(&alrm->time, &rtc_alarm))
 		return -EINVAL;
 
 	rtc->rtc_alarm = alrm->time;
diff --git a/drivers/rtc/rtc-coh901331.c b/drivers/rtc/rtc-coh901331.c
index 869cae2..4d6e290 100644
--- a/drivers/rtc/rtc-coh901331.c
+++ b/drivers/rtc/rtc-coh901331.c
@@ -117,7 +117,7 @@ static int coh901331_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	struct coh901331_port *rtap = dev_get_drvdata(dev);
 	unsigned long time;
 
-	rtc_tm_to_time(&alarm->time, &time);
+	rtc_tm_to_time_unsafe(&alarm->time, &time);
 	clk_enable(rtap->clk);
 	writel(time, rtap->virtbase + COH901331_ALARM);
 	writel(alarm->enabled, rtap->virtbase + COH901331_IRQ_MASK);
diff --git a/drivers/rtc/rtc-da9052.c b/drivers/rtc/rtc-da9052.c
index e5c9486..23dce8a 100644
--- a/drivers/rtc/rtc-da9052.c
+++ b/drivers/rtc/rtc-da9052.c
@@ -83,7 +83,7 @@ static int da9052_set_alarm(struct da9052_rtc *rtc, struct rtc_time *rtc_tm)
 	int ret;
 	uint8_t v[3];
 
-	ret = rtc_tm_to_time(rtc_tm, &alm_time);
+	ret = rtc_tm_to_time_unsafe(rtc_tm, &alm_time);
 	if (ret != 0)
 		return ret;
 
diff --git a/drivers/rtc/rtc-da9063.c b/drivers/rtc/rtc-da9063.c
index 731ed1a..b35bc48 100644
--- a/drivers/rtc/rtc-da9063.c
+++ b/drivers/rtc/rtc-da9063.c
@@ -123,8 +123,8 @@ static int da9063_rtc_read_time(struct device *dev, struct rtc_time *tm)
 
 	da9063_data_to_tm(data, tm);
 
-	rtc_tm_to_time(tm, &tm_secs);
-	rtc_tm_to_time(&rtc->alarm_time, &al_secs);
+	rtc_tm_to_time_unsafe(tm, &tm_secs);
+	rtc_tm_to_time_unsafe(&rtc->alarm_time, &al_secs);
 
 	/* handle the rtc synchronisation delay */
 	if (rtc->rtc_sync == true && al_secs - tm_secs == 1)
diff --git a/drivers/rtc/rtc-davinci.c b/drivers/rtc/rtc-davinci.c
index c0a3b59..915d625 100644
--- a/drivers/rtc/rtc-davinci.c
+++ b/drivers/rtc/rtc-davinci.c
@@ -430,12 +430,12 @@ static int davinci_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 		unsigned long now, then;
 
 		davinci_rtc_read_time(dev, &tm);
-		rtc_tm_to_time(&tm, &now);
+		rtc_tm_to_time_unsafe(&tm, &now);
 
 		alm->time.tm_mday = tm.tm_mday;
 		alm->time.tm_mon = tm.tm_mon;
 		alm->time.tm_year = tm.tm_year;
-		rtc_tm_to_time(&alm->time, &then);
+		rtc_tm_to_time_unsafe(&alm->time, &then);
 
 		if (then < now) {
 			rtc_time_to_tm(now + 24 * 60 * 60, &tm);
diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index d049393..6145ba9 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -309,7 +309,7 @@ static long rtc_dev_ioctl(struct file *file,
 			err = rtc_read_time(rtc, &tm);
 			if (err < 0)
 				return err;
-			rtc_tm_to_time(&tm, &now);
+			rtc_tm_to_time_unsafe(&tm, &now);
 
 			alarm.time.tm_mday = tm.tm_mday;
 			alarm.time.tm_mon = tm.tm_mon;
@@ -317,7 +317,7 @@ static long rtc_dev_ioctl(struct file *file,
 			err  = rtc_valid_tm(&alarm.time);
 			if (err < 0)
 				return err;
-			rtc_tm_to_time(&alarm.time, &then);
+			rtc_tm_to_time_unsafe(&alarm.time, &then);
 
 			/* alarm may need to wrap into tomorrow */
 			if (then < now) {
diff --git a/drivers/rtc/rtc-dm355evm.c b/drivers/rtc/rtc-dm355evm.c
index 1aca083..b07d0ee 100644
--- a/drivers/rtc/rtc-dm355evm.c
+++ b/drivers/rtc/rtc-dm355evm.c
@@ -88,7 +88,7 @@ static int dm355evm_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	unsigned long	value;
 	int		status;
 
-	rtc_tm_to_time(tm, &value);
+	rtc_tm_to_time_unsafe(tm, &value);
 	time.value = cpu_to_le32(value);
 
 	dev_dbg(dev, "write timestamp %08x\n", time.value);
diff --git a/drivers/rtc/rtc-ds1305.c b/drivers/rtc/rtc-ds1305.c
index 129add77..6bc0ccf 100644
--- a/drivers/rtc/rtc-ds1305.c
+++ b/drivers/rtc/rtc-ds1305.c
@@ -341,7 +341,7 @@ static int ds1305_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 	u8		buf[1 + DS1305_ALM_LEN];
 
 	/* convert desired alarm to time_t */
-	status = rtc_tm_to_time(&alm->time, &later);
+	status = rtc_tm_to_time_unsafe(&alm->time, &later);
 	if (status < 0)
 		return status;
 
@@ -349,7 +349,7 @@ static int ds1305_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 	status = ds1305_get_time(dev, &tm);
 	if (status < 0)
 		return status;
-	status = rtc_tm_to_time(&tm, &now);
+	status = rtc_tm_to_time_unsafe(&tm, &now);
 	if (status < 0)
 		return status;
 
diff --git a/drivers/rtc/rtc-ds1374.c b/drivers/rtc/rtc-ds1374.c
index 9e6e14f..12e3b26 100644
--- a/drivers/rtc/rtc-ds1374.c
+++ b/drivers/rtc/rtc-ds1374.c
@@ -158,7 +158,7 @@ static int ds1374_set_time(struct device *dev, struct rtc_time *time)
 	struct i2c_client *client = to_i2c_client(dev);
 	unsigned long itime;
 
-	rtc_tm_to_time(time, &itime);
+	rtc_tm_to_time_unsafe(time, &itime);
 	return ds1374_write_rtc(client, itime, DS1374_REG_TOD0, 4);
 }
 
@@ -220,8 +220,8 @@ static int ds1374_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	if (ret < 0)
 		return ret;
 
-	rtc_tm_to_time(&alarm->time, &new_alarm);
-	rtc_tm_to_time(&now, &itime);
+	rtc_tm_to_time_unsafe(&alarm->time, &new_alarm);
+	rtc_tm_to_time_unsafe(&now, &itime);
 
 	/* This can happen due to races, in addition to dates that are
 	 * truly in the past.  To avoid requiring the caller to check for
diff --git a/drivers/rtc/rtc-imxdi.c b/drivers/rtc/rtc-imxdi.c
index cd741c7..53fc4bc 100644
--- a/drivers/rtc/rtc-imxdi.c
+++ b/drivers/rtc/rtc-imxdi.c
@@ -271,7 +271,7 @@ static int dryice_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	unsigned long alarm_time;
 	int rc;
 
-	rc = rtc_tm_to_time(&alarm->time, &alarm_time);
+	rc = rtc_tm_to_time_unsafe(&alarm->time, &alarm_time);
 	if (rc)
 		return rc;
 
diff --git a/drivers/rtc/rtc-isl1208.c b/drivers/rtc/rtc-isl1208.c
index c3c549d..d998420 100644
--- a/drivers/rtc/rtc-isl1208.c
+++ b/drivers/rtc/rtc-isl1208.c
@@ -377,10 +377,10 @@ isl1208_i2c_set_alarm(struct i2c_client *client, struct rtc_wkalrm *alarm)
 	err = isl1208_i2c_read_time(client, &rtc_tm);
 	if (err)
 		return err;
-	err = rtc_tm_to_time(&rtc_tm, &rtc_secs);
+	err = rtc_tm_to_time_unsafe(&rtc_tm, &rtc_secs);
 	if (err)
 		return err;
-	err = rtc_tm_to_time(alarm_tm, &alarm_secs);
+	err = rtc_tm_to_time_unsafe(alarm_tm, &alarm_secs);
 	if (err)
 		return err;
 
diff --git a/drivers/rtc/rtc-jz4740.c b/drivers/rtc/rtc-jz4740.c
index 08f5160..a1379cc 100644
--- a/drivers/rtc/rtc-jz4740.c
+++ b/drivers/rtc/rtc-jz4740.c
@@ -158,7 +158,7 @@ static int jz4740_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	struct jz4740_rtc *rtc = dev_get_drvdata(dev);
 	unsigned long secs;
 
-	rtc_tm_to_time(&alrm->time, &secs);
+	rtc_tm_to_time_unsafe(&alrm->time, &secs);
 
 	ret = jz4740_rtc_reg_write(rtc, JZ_REG_RTC_SEC_ALARM, secs);
 	if (!ret)
diff --git a/drivers/rtc/rtc-lib.c b/drivers/rtc/rtc-lib.c
index a0b473a..168d2a2 100644
--- a/drivers/rtc/rtc-lib.c
+++ b/drivers/rtc/rtc-lib.c
@@ -111,13 +111,13 @@ EXPORT_SYMBOL(rtc_valid_tm);
 /*
  * Convert Gregorian date to seconds since 01-01-1970 00:00:00.
  */
-int rtc_tm_to_time(struct rtc_time *tm, unsigned long *time)
+int rtc_tm_to_time_unsafe(struct rtc_time *tm, unsigned long *time)
 {
-	*time = mktime_unsafe(tm->tm_year + 1900, tm->tm_mon + 1, tm->tm_mday,
+	*time = (unsigned long) mktime(tm->tm_year + 1900, tm->tm_mon + 1, tm->tm_mday,
 			tm->tm_hour, tm->tm_min, tm->tm_sec);
 	return 0;
 }
-EXPORT_SYMBOL(rtc_tm_to_time);
+EXPORT_SYMBOL(rtc_tm_to_time_unsafe);
 
 /*
  * Convert rtc_time to ktime
@@ -125,7 +125,7 @@ EXPORT_SYMBOL(rtc_tm_to_time);
 ktime_t rtc_tm_to_ktime(struct rtc_time tm)
 {
 	time_t time;
-	rtc_tm_to_time(&tm, &time);
+	rtc_tm_to_time_unsafe(&tm, &time);
 	return ktime_set(time, 0);
 }
 EXPORT_SYMBOL_GPL(rtc_tm_to_ktime);
diff --git a/drivers/rtc/rtc-lpc32xx.c b/drivers/rtc/rtc-lpc32xx.c
index f130c08..da235f2 100644
--- a/drivers/rtc/rtc-lpc32xx.c
+++ b/drivers/rtc/rtc-lpc32xx.c
@@ -113,7 +113,7 @@ static int lpc32xx_rtc_set_alarm(struct device *dev,
 	u32 tmp;
 	int ret;
 
-	ret = rtc_tm_to_time(&wkalrm->time, &alarmsecs);
+	ret = rtc_tm_to_time_unsafe(&wkalrm->time, &alarmsecs);
 	if (ret < 0) {
 		dev_warn(dev, "Failed to convert time: %d\n", ret);
 		return ret;
diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
index 0765606..78ec451 100644
--- a/drivers/rtc/rtc-mc13xxx.c
+++ b/drivers/rtc/rtc-mc13xxx.c
@@ -215,7 +215,7 @@ static int mc13xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	if (unlikely(ret))
 		goto out;
 
-	ret = rtc_tm_to_time(&alarm->time, &s1970);
+	ret = rtc_tm_to_time_unsafe(&alarm->time, &s1970);
 	if (unlikely(ret))
 		goto out;
 
diff --git a/drivers/rtc/rtc-mpc5121.c b/drivers/rtc/rtc-mpc5121.c
index 3b965ad..508a1ed 100644
--- a/drivers/rtc/rtc-mpc5121.c
+++ b/drivers/rtc/rtc-mpc5121.c
@@ -136,7 +136,7 @@ static int mpc5121_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	 * The actual_time register is read only so we write the offset
 	 * between it and linux time to the target_time register.
 	 */
-	ret = rtc_tm_to_time(tm, &now);
+	ret = rtc_tm_to_time_unsafe(tm, &now);
 	if (ret == 0)
 		out_be32(&regs->target_time, now - in_be32(&regs->actual_time));
 
diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
index 419874f..7bc66ab 100644
--- a/drivers/rtc/rtc-mxc.c
+++ b/drivers/rtc/rtc-mxc.c
@@ -189,7 +189,7 @@ static int rtc_update_alarm(struct device *dev, struct rtc_time *alrm)
 	alarm_tm.tm_hour = alrm->tm_hour;
 	alarm_tm.tm_min = alrm->tm_min;
 	alarm_tm.tm_sec = alrm->tm_sec;
-	rtc_tm_to_time(&alarm_tm, &time);
+	rtc_tm_to_time_unsafe(&alarm_tm, &time);
 
 	/* clear all the interrupt status bits */
 	writew(readw(ioaddr + RTC_RTCISR), ioaddr + RTC_RTCISR);
@@ -311,7 +311,7 @@ static int mxc_rtc_set_mmss(struct device *dev, unsigned long time)
 
 		rtc_time_to_tm(time, &tm);
 		tm.tm_year = 70;
-		rtc_tm_to_time(&tm, &time);
+		rtc_tm_to_time_unsafe(&tm, &time);
 	}
 
 	/* Avoid roll-over from reading the different registers */
diff --git a/drivers/rtc/rtc-pcap.c b/drivers/rtc/rtc-pcap.c
index 40b5c63..d8bfe37 100644
--- a/drivers/rtc/rtc-pcap.c
+++ b/drivers/rtc/rtc-pcap.c
@@ -69,7 +69,7 @@ static int pcap_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	unsigned long secs;
 	u32 tod, days;
 
-	rtc_tm_to_time(tm, &secs);
+	rtc_tm_to_time_unsafe(tm, &secs);
 
 	tod = secs % SEC_PER_DAY;
 	ezx_pcap_write(pcap_rtc->pcap, PCAP_REG_RTC_TODA, tod);
diff --git a/drivers/rtc/rtc-pl030.c b/drivers/rtc/rtc-pl030.c
index f85a1a9..5c2c1c8 100644
--- a/drivers/rtc/rtc-pl030.c
+++ b/drivers/rtc/rtc-pl030.c
@@ -54,7 +54,7 @@ static int pl030_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	 */
 	ret = rtc_valid_tm(&alrm->time);
 	if (ret == 0)
-		ret = rtc_tm_to_time(&alrm->time, &time);
+		ret = rtc_tm_to_time_unsafe(&alrm->time, &time);
 	if (ret == 0)
 		writel(time, rtc->base + RTC_MR);
 	return ret;
@@ -83,7 +83,7 @@ static int pl030_set_time(struct device *dev, struct rtc_time *tm)
 	unsigned long time;
 	int ret;
 
-	ret = rtc_tm_to_time(tm, &time);
+	ret = rtc_tm_to_time_unsafe(tm, &time);
 	if (ret == 0)
 		writel(time + 1, rtc->base + RTC_LR);
 
diff --git a/drivers/rtc/rtc-pl031.c b/drivers/rtc/rtc-pl031.c
index 99181fff..5a73252 100644
--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -129,7 +129,7 @@ static int pl031_stv2_tm_to_time(struct device *dev,
 		unsigned long time;
 		struct rtc_time calc_tm;
 
-		rtc_tm_to_time(tm, &time);
+		rtc_tm_to_time_unsafe(tm, &time);
 		rtc_time_to_tm(time, &calc_tm);
 		wday = calc_tm.tm_wday;
 	}
@@ -262,7 +262,7 @@ static int pl031_set_time(struct device *dev, struct rtc_time *tm)
 	struct pl031_local *ldata = dev_get_drvdata(dev);
 	int ret;
 
-	ret = rtc_tm_to_time(tm, &time);
+	ret = rtc_tm_to_time_unsafe(tm, &time);
 
 	if (ret == 0)
 		writel(time, ldata->base + RTC_LR);
@@ -291,7 +291,7 @@ static int pl031_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	/* At the moment, we can only deal with non-wildcarded alarm times. */
 	ret = rtc_valid_tm(&alarm->time);
 	if (ret == 0) {
-		ret = rtc_tm_to_time(&alarm->time, &time);
+		ret = rtc_tm_to_time_unsafe(&alarm->time, &time);
 		if (ret == 0) {
 			writel(time, ldata->base + RTC_MR);
 			pl031_alarm_irq_enable(dev, alarm->enabled);
diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
index 197699f..76d5b84 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -77,7 +77,7 @@ static int pm8xxx_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	if (!rtc_dd->allow_set_time)
 		return -EACCES;
 
-	rtc_tm_to_time(tm, &secs);
+	rtc_tm_to_time_unsafe(tm, &secs);
 
 	for (i = 0; i < NUM_8_BIT_RTC_REGS; i++) {
 		value[i] = secs & 0xFF;
@@ -199,7 +199,7 @@ static int pm8xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	unsigned long secs, irq_flags;
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
 
-	rtc_tm_to_time(&alarm->time, &secs);
+	rtc_tm_to_time_unsafe(&alarm->time, &secs);
 
 	for (i = 0; i < NUM_8_BIT_RTC_REGS; i++) {
 		value[i] = secs & 0xFF;
diff --git a/drivers/rtc/rtc-ps3.c b/drivers/rtc/rtc-ps3.c
index 554ada5..e6f3fe6 100644
--- a/drivers/rtc/rtc-ps3.c
+++ b/drivers/rtc/rtc-ps3.c
@@ -48,7 +48,7 @@ static int ps3_set_time(struct device *dev, struct rtc_time *tm)
 {
 	unsigned long now;
 
-	rtc_tm_to_time(tm, &now);
+	rtc_tm_to_time_unsafe(tm, &now);
 	ps3_os_area_set_rtc_diff(now - read_rtc());
 	return 0;
 }
diff --git a/drivers/rtc/rtc-puv3.c b/drivers/rtc/rtc-puv3.c
index 1cff2a2..ae8b7e8 100644
--- a/drivers/rtc/rtc-puv3.c
+++ b/drivers/rtc/rtc-puv3.c
@@ -105,7 +105,7 @@ static int puv3_rtc_settime(struct device *dev, struct rtc_time *tm)
 		 tm->tm_year, tm->tm_mon, tm->tm_mday,
 		 tm->tm_hour, tm->tm_min, tm->tm_sec);
 
-	rtc_tm_to_time(tm, &rtc_count);
+	rtc_tm_to_time_unsafe(tm, &rtc_count);
 	writel(rtc_count, RTC_RCNR);
 
 	return 0;
@@ -137,7 +137,7 @@ static int puv3_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 		 tm->tm_mday & 0xff, tm->tm_mon & 0xff, tm->tm_year & 0xff,
 		 tm->tm_hour & 0xff, tm->tm_min & 0xff, tm->tm_sec);
 
-	rtc_tm_to_time(tm, &rtcalarm_count);
+	rtc_tm_to_time_unsafe(tm, &rtcalarm_count);
 	writel(rtcalarm_count, RTC_RTAR);
 
 	puv3_rtc_setaie(dev, alrm->enabled);
diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index b6e1ca0..b736f1e 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -166,7 +166,7 @@ static int sa1100_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	unsigned long time;
 	int ret;
 
-	ret = rtc_tm_to_time(tm, &time);
+	ret = rtc_tm_to_time_unsafe(tm, &time);
 	if (ret == 0)
 		RCNR = time;
 	return ret;
@@ -189,7 +189,7 @@ static int sa1100_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	int ret;
 
 	spin_lock_irq(&info->lock);
-	ret = rtc_tm_to_time(&alrm->time, &time);
+	ret = rtc_tm_to_time_unsafe(&alrm->time, &time);
 	if (ret != 0)
 		goto out;
 	RTSR = RTSR & (RTSR_HZE|RTSR_ALE|RTSR_AL);
diff --git a/drivers/rtc/rtc-sirfsoc.c b/drivers/rtc/rtc-sirfsoc.c
index 76e3800..8579970 100644
--- a/drivers/rtc/rtc-sirfsoc.c
+++ b/drivers/rtc/rtc-sirfsoc.c
@@ -97,7 +97,7 @@ static int sirfsoc_rtc_set_alarm(struct device *dev,
 	rtcdrv = dev_get_drvdata(dev);
 
 	if (alrm->enabled) {
-		rtc_tm_to_time(&(alrm->time), &rtc_alarm);
+		rtc_tm_to_time_unsafe(&(alrm->time), &rtc_alarm);
 
 		local_irq_disable();
 
@@ -180,7 +180,7 @@ static int sirfsoc_rtc_set_time(struct device *dev,
 	struct sirfsoc_rtc_drv *rtcdrv;
 	rtcdrv = dev_get_drvdata(dev);
 
-	rtc_tm_to_time(tm, &rtc_time);
+	rtc_tm_to_time_unsafe(tm, &rtc_time);
 
 	rtcdrv->overflow_rtc = rtc_time >> (BITS_PER_LONG - RTC_SHIFT);
 
diff --git a/drivers/rtc/rtc-snvs.c b/drivers/rtc/rtc-snvs.c
index fa384fe..198377a 100644
--- a/drivers/rtc/rtc-snvs.c
+++ b/drivers/rtc/rtc-snvs.c
@@ -131,7 +131,7 @@ static int snvs_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	struct snvs_rtc_data *data = dev_get_drvdata(dev);
 	unsigned long time;
 
-	rtc_tm_to_time(tm, &time);
+	rtc_tm_to_time_unsafe(tm, &time);
 
 	/* Disable RTC first */
 	snvs_rtc_enable(data, false);
@@ -190,7 +190,7 @@ static int snvs_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	unsigned long flags;
 	u32 lpcr;
 
-	rtc_tm_to_time(alrm_tm, &time);
+	rtc_tm_to_time_unsafe(alrm_tm, &time);
 
 	spin_lock_irqsave(&data->lock, flags);
 
diff --git a/drivers/rtc/rtc-stmp3xxx.c b/drivers/rtc/rtc-stmp3xxx.c
index ea96492..f9a0c46 100644
--- a/drivers/rtc/rtc-stmp3xxx.c
+++ b/drivers/rtc/rtc-stmp3xxx.c
@@ -214,7 +214,7 @@ static int stmp3xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 	unsigned long t;
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
 
-	rtc_tm_to_time(&alm->time, &t);
+	rtc_tm_to_time_unsafe(&alm->time, &t);
 	writel(t, rtc_data->io + STMP3XXX_RTC_ALARM);
 
 	stmp3xxx_alarm_irq_enable(dev, alm->enabled);
diff --git a/drivers/rtc/rtc-sun4v.c b/drivers/rtc/rtc-sun4v.c
index bc97ff9..ed041ed 100644
--- a/drivers/rtc/rtc-sun4v.c
+++ b/drivers/rtc/rtc-sun4v.c
@@ -67,7 +67,7 @@ static int sun4v_set_time(struct device *dev, struct rtc_time *tm)
 	unsigned long secs;
 	int err;
 
-	err = rtc_tm_to_time(tm, &secs);
+	err = rtc_tm_to_time_unsafe(tm, &secs);
 	if (err)
 		return err;
 
diff --git a/drivers/rtc/rtc-sun6i.c b/drivers/rtc/rtc-sun6i.c
index c169a2c..c49c399 100644
--- a/drivers/rtc/rtc-sun6i.c
+++ b/drivers/rtc/rtc-sun6i.c
@@ -219,8 +219,8 @@ static int sun6i_rtc_setalarm(struct device *dev, struct rtc_wkalrm *wkalrm)
 		return -EINVAL;
 	}
 
-	rtc_tm_to_time(alrm_tm, &time_set);
-	rtc_tm_to_time(&tm_now, &time_now);
+	rtc_tm_to_time_unsafe(alrm_tm, &time_set);
+	rtc_tm_to_time_unsafe(&tm_now, &time_now);
 	if (time_set <= time_now) {
 		dev_err(dev, "Date to set in the past\n");
 		return -EINVAL;
diff --git a/drivers/rtc/rtc-sunxi.c b/drivers/rtc/rtc-sunxi.c
index b6f21f7..1124b3f 100644
--- a/drivers/rtc/rtc-sunxi.c
+++ b/drivers/rtc/rtc-sunxi.c
@@ -284,8 +284,8 @@ static int sunxi_rtc_setalarm(struct device *dev, struct rtc_wkalrm *wkalrm)
 		return -EINVAL;
 	}
 
-	rtc_tm_to_time(alrm_tm, &time_set);
-	rtc_tm_to_time(&tm_now, &time_now);
+	rtc_tm_to_time_unsafe(alrm_tm, &time_set);
+	rtc_tm_to_time_unsafe(&tm_now, &time_now);
 	if (time_set <= time_now) {
 		dev_err(dev, "Date to set in the past\n");
 		return -EINVAL;
diff --git a/drivers/rtc/rtc-sysfs.c b/drivers/rtc/rtc-sysfs.c
index babd43b..b9695f3 100644
--- a/drivers/rtc/rtc-sysfs.c
+++ b/drivers/rtc/rtc-sysfs.c
@@ -72,7 +72,7 @@ since_epoch_show(struct device *dev, struct device_attribute *attr, char *buf)
 	retval = rtc_read_time(to_rtc_device(dev), &tm);
 	if (retval == 0) {
 		unsigned long time;
-		rtc_tm_to_time(&tm, &time);
+		rtc_tm_to_time_unsafe(&tm, &time);
 		retval = sprintf(buf, "%lu\n", time);
 	}
 
@@ -151,7 +151,7 @@ rtc_sysfs_show_wakealarm(struct device *dev, struct device_attribute *attr,
 	 */
 	retval = rtc_read_alarm(to_rtc_device(dev), &alm);
 	if (retval == 0 && alm.enabled) {
-		rtc_tm_to_time(&alm.time, &alarm);
+		rtc_tm_to_time_unsafe(&alm.time, &alarm);
 		retval = sprintf(buf, "%lu\n", alarm);
 	}
 
@@ -176,7 +176,7 @@ rtc_sysfs_set_wakealarm(struct device *dev, struct device_attribute *attr,
 	retval = rtc_read_time(rtc, &alm.time);
 	if (retval < 0)
 		return retval;
-	rtc_tm_to_time(&alm.time, &now);
+	rtc_tm_to_time_unsafe(&alm.time, &now);
 
 	buf_ptr = (char *)buf;
 	if (*buf_ptr == '+') {
@@ -201,7 +201,7 @@ rtc_sysfs_set_wakealarm(struct device *dev, struct device_attribute *attr,
 			return retval;
 		if (alm.enabled) {
 			if (push) {
-				rtc_tm_to_time(&alm.time, &push);
+				rtc_tm_to_time_unsafe(&alm.time, &push);
 				alarm += push;
 			} else
 				return -EBUSY;
diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
index 76af92a..409b4a0 100644
--- a/drivers/rtc/rtc-tegra.c
+++ b/drivers/rtc/rtc-tegra.c
@@ -145,7 +145,7 @@ static int tegra_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	if (ret)
 		return ret;
 
-	rtc_tm_to_time(tm, &sec);
+	rtc_tm_to_time_unsafe(tm, &sec);
 
 	dev_vdbg(dev, "time set to %lu. %d/%d/%d %d:%02u:%02u\n",
 		sec,
@@ -226,7 +226,7 @@ static int tegra_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	unsigned long sec;
 
 	if (alarm->enabled)
-		rtc_tm_to_time(&alarm->time, &sec);
+		rtc_tm_to_time_unsafe(&alarm->time, &sec);
 	else
 		sec = 0;
 
diff --git a/drivers/rtc/rtc-tps6586x.c b/drivers/rtc/rtc-tps6586x.c
index 5f8d726..341b000 100644
--- a/drivers/rtc/rtc-tps6586x.c
+++ b/drivers/rtc/rtc-tps6586x.c
@@ -102,7 +102,7 @@ static int tps6586x_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	u8 buff[5];
 	int ret;
 
-	rtc_tm_to_time(tm, &seconds);
+	rtc_tm_to_time_unsafe(tm, &seconds);
 	if (seconds < rtc->epoch_start) {
 		dev_err(dev, "requested time unsupported\n");
 		return -EINVAL;
@@ -166,7 +166,7 @@ static int tps6586x_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	int ret;
 	int i;
 
-	rtc_tm_to_time(&alrm->time, &seconds);
+	rtc_tm_to_time_unsafe(&alrm->time, &seconds);
 
 	if (alrm->enabled && (seconds < rtc->epoch_start)) {
 		dev_err(dev, "can't set alarm to requested time\n");
diff --git a/drivers/rtc/rtc-tx4939.c b/drivers/rtc/rtc-tx4939.c
index 2e678c6..b3cf814 100644
--- a/drivers/rtc/rtc-tx4939.c
+++ b/drivers/rtc/rtc-tx4939.c
@@ -106,7 +106,7 @@ static int tx4939_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	    alrm->time.tm_mon < 0 ||
 	    alrm->time.tm_year < 0)
 		return -EINVAL;
-	rtc_tm_to_time(&alrm->time, &sec);
+	rtc_tm_to_time_unsafe(&alrm->time, &sec);
 	buf[0] = 0;
 	buf[1] = 0;
 	buf[2] = sec;
diff --git a/drivers/rtc/rtc-wm831x.c b/drivers/rtc/rtc-wm831x.c
index 75aea4c..5d6a877 100644
--- a/drivers/rtc/rtc-wm831x.c
+++ b/drivers/rtc/rtc-wm831x.c
@@ -215,7 +215,7 @@ static int wm831x_rtc_set_mmss(struct device *dev, unsigned long time)
 	if (ret < 0)
 		return ret;
 
-	ret = rtc_tm_to_time(&new_tm, &new_time);
+	ret = rtc_tm_to_time_unsafe(&new_tm, &new_time);
 	if (ret < 0) {
 		dev_err(dev, "Failed to convert time: %d\n", ret);
 		return ret;
@@ -288,7 +288,7 @@ static int wm831x_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	int ret;
 	unsigned long time;
 
-	ret = rtc_tm_to_time(&alrm->time, &time);
+	ret = rtc_tm_to_time_unsafe(&alrm->time, &time);
 	if (ret < 0) {
 		dev_err(dev, "Failed to convert time: %d\n", ret);
 		return ret;
diff --git a/drivers/rtc/rtc-xgene.c b/drivers/rtc/rtc-xgene.c
index 14129cc..2da0616 100644
--- a/drivers/rtc/rtc-xgene.c
+++ b/drivers/rtc/rtc-xgene.c
@@ -111,7 +111,7 @@ static int xgene_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	unsigned long alarm_time;
 
 	rtc_time = readl(pdata->csr_base + RTC_CCVR);
-	rtc_tm_to_time(&alrm->time, &alarm_time);
+	rtc_tm_to_time_unsafe(&alrm->time, &alarm_time);
 
 	pdata->alarm_time = alarm_time;
 	writel((u32) pdata->alarm_time, pdata->csr_base + RTC_CMR);
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index c2c2897..97bbb6f 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -19,7 +19,7 @@
 extern int rtc_month_days(unsigned int month, unsigned int year);
 extern int rtc_year_days(unsigned int day, unsigned int month, unsigned int year);
 extern int rtc_valid_tm(struct rtc_time *tm);
-extern int rtc_tm_to_time(struct rtc_time *tm, unsigned long *time);
+extern int rtc_tm_to_time_unsafe(struct rtc_time *tm, unsigned long *time);
 extern void rtc_time_to_tm(unsigned long time, struct rtc_time *tm);
 ktime_t rtc_tm_to_ktime(struct rtc_time tm);
 struct rtc_time rtc_ktime_to_tm(ktime_t kt);
diff --git a/kernel/power/suspend_test.c b/kernel/power/suspend_test.c
index 084452e..f82b228 100644
--- a/kernel/power/suspend_test.c
+++ b/kernel/power/suspend_test.c
@@ -82,7 +82,7 @@ repeat:
 		printk(err_readtime, dev_name(&rtc->dev), status);
 		return;
 	}
-	rtc_tm_to_time(&alm.time, &now);
+	rtc_tm_to_time_unsafe(&alm.time, &now);
 
 	memset(&alm, 0, sizeof alm);
 	rtc_time_to_tm(now + TEST_SUSPEND_SECONDS, &alm.time);
-- 
1.7.9.5

