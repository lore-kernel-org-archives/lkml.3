Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaJ0Fq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:46:27 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:50338 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbaJ0FqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:46:25 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH RFC 01/12] time: Rename mktime() to mktime_unsafe()
Date: Mon, 27 Oct 2014 13:45:48 +0800
Message-Id: <1414388748-3333-1-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel uses 32-bit signed value(time_t) for seconds since 1970-01-01:00:00:00, thus it
will overflow at 2038-01-19 03:14:08 on 32-bit systems. We call this "2038 safety" issue.

Currently, mktime() deals with "unsigned long" which is 2038 unsafe on 32-bit systems.

As part of addressing 2038 saftey for in-kernel uses, this patch renames mktime() to
mktime_unsafe(), and changes all its calling users correspondingly. The safe version
of mktime() will be added in the following patch.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 arch/avr32/kernel/time.c                     |    2 +-
 arch/frv/kernel/time.c                       |    2 +-
 arch/ia64/kernel/efi.c                       |    2 +-
 arch/m32r/kernel/time.c                      |    2 +-
 arch/m68k/kernel/time.c                      |    2 +-
 arch/m68k/mac/misc.c                         |    2 +-
 arch/mips/dec/time.c                         |    2 +-
 arch/mips/include/asm/mc146818-time.h        |    2 +-
 arch/mips/sibyte/swarm/rtc_m41t81.c          |    2 +-
 arch/mips/sibyte/swarm/rtc_xicor1241.c       |    2 +-
 arch/mips/sibyte/swarm/setup.c               |    2 +-
 arch/mn10300/kernel/rtc.c                    |    4 ++--
 arch/parisc/include/asm/rtc.h                |    2 +-
 arch/powerpc/kernel/rtas-proc.c              |    2 +-
 arch/powerpc/kernel/rtas-rtc.c               |    2 +-
 arch/powerpc/kernel/time.c                   |    2 +-
 arch/powerpc/platforms/8xx/m8xx_setup.c      |    2 +-
 arch/powerpc/platforms/cell/beat.c           |    2 +-
 arch/powerpc/platforms/maple/time.c          |    2 +-
 arch/powerpc/platforms/pasemi/time.c         |    2 +-
 arch/powerpc/platforms/powermac/time.c       |    2 +-
 arch/powerpc/platforms/powernv/opal-rtc.c    |    2 +-
 arch/sh/boards/mach-sh03/rtc.c               |    2 +-
 arch/sh/kernel/time.c                        |    2 +-
 arch/x86/kernel/rtc.c                        |    2 +-
 arch/x86/platform/efi/efi.c                  |    2 +-
 arch/x86/platform/intel-mid/intel_mid_vrtc.c |    2 +-
 drivers/rtc/rtc-lib.c                        |    2 +-
 drivers/rtc/rtc-ls1x.c                       |    2 +-
 drivers/rtc/rtc-tps6586x.c                   |    2 +-
 drivers/rtc/rtc-vr41xx.c                     |    8 ++++----
 include/linux/time.h                         |    6 +++---
 kernel/time/time.c                           |    4 ++--
 33 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/arch/avr32/kernel/time.c b/arch/avr32/kernel/time.c
index d0f771b..37ba222 100644
--- a/arch/avr32/kernel/time.c
+++ b/arch/avr32/kernel/time.c
@@ -123,7 +123,7 @@ static struct clock_event_device comparator = {
 
 void read_persistent_clock(struct timespec *ts)
 {
-	ts->tv_sec = mktime(2007, 1, 1, 0, 0, 0);
+	ts->tv_sec = mktime_unsafe(2007, 1, 1, 0, 0, 0);
 	ts->tv_nsec = 0;
 }
 
diff --git a/arch/frv/kernel/time.c b/arch/frv/kernel/time.c
index 332e00b..b695e0e 100644
--- a/arch/frv/kernel/time.c
+++ b/arch/frv/kernel/time.c
@@ -101,7 +101,7 @@ void read_persistent_clock(struct timespec *ts)
 
 	if ((year += 1900) < 1970)
 		year += 100;
-	ts->tv_sec = mktime(year, mon, day, hour, min, sec);
+	ts->tv_sec = mktime_unsafe(year, mon, day, hour, min, sec);
 	ts->tv_nsec = 0;
 }
 
diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index 741b99c..c2ae0fd 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -245,7 +245,7 @@ efi_gettimeofday (struct timespec *ts)
 		return;
 	}
 
-	ts->tv_sec = mktime(tm.year, tm.month, tm.day,
+	ts->tv_sec = mktime_unsafe(tm.year, tm.month, tm.day,
 			    tm.hour, tm.minute, tm.second);
 	ts->tv_nsec = tm.nanosecond;
 }
diff --git a/arch/m32r/kernel/time.c b/arch/m32r/kernel/time.c
index 093f276..56956ea 100644
--- a/arch/m32r/kernel/time.c
+++ b/arch/m32r/kernel/time.c
@@ -157,7 +157,7 @@ void read_persistent_clock(struct timespec *ts)
 		epoch = 1952;
 	year += epoch;
 
-	ts->tv_sec = mktime(year, mon, day, hour, min, sec);
+	ts->tv_sec = mktime_unsafe(year, mon, day, hour, min, sec);
 	ts->tv_nsec = (INITIAL_JIFFIES % HZ) * (NSEC_PER_SEC / HZ);
 }
 
diff --git a/arch/m68k/kernel/time.c b/arch/m68k/kernel/time.c
index 3857737..4ed21ea 100644
--- a/arch/m68k/kernel/time.c
+++ b/arch/m68k/kernel/time.c
@@ -81,7 +81,7 @@ void read_persistent_clock(struct timespec *ts)
 
 		if ((time.tm_year += 1900) < 1970)
 			time.tm_year += 100;
-		ts->tv_sec = mktime(time.tm_year, time.tm_mon, time.tm_mday,
+		ts->tv_sec = mktime_unsafe(time.tm_year, time.tm_mon, time.tm_mday,
 				      time.tm_hour, time.tm_min, time.tm_sec);
 	}
 }
diff --git a/arch/m68k/mac/misc.c b/arch/m68k/mac/misc.c
index 707b61a..85be5f3 100644
--- a/arch/m68k/mac/misc.c
+++ b/arch/m68k/mac/misc.c
@@ -730,7 +730,7 @@ int mac_hwclk(int op, struct rtc_time *t)
 			t->tm_hour, t->tm_min, t->tm_sec);
 #endif
 
-		now = mktime(t->tm_year + 1900, t->tm_mon + 1, t->tm_mday,
+		now = mktime_unsafe(t->tm_year + 1900, t->tm_mon + 1, t->tm_mday,
 			     t->tm_hour, t->tm_min, t->tm_sec);
 
 		switch (macintosh_config->adb_type) {
diff --git a/arch/mips/dec/time.c b/arch/mips/dec/time.c
index 1914e56..d9905cb 100644
--- a/arch/mips/dec/time.c
+++ b/arch/mips/dec/time.c
@@ -53,7 +53,7 @@ void read_persistent_clock(struct timespec *ts)
 
 	year += real_year - 72 + 2000;
 
-	ts->tv_sec = mktime(year, mon, day, hour, min, sec);
+	ts->tv_sec = mktime_unsafe(year, mon, day, hour, min, sec);
 	ts->tv_nsec = 0;
 }
 
diff --git a/arch/mips/include/asm/mc146818-time.h b/arch/mips/include/asm/mc146818-time.h
index 9e1ad26..a5df6b0 100644
--- a/arch/mips/include/asm/mc146818-time.h
+++ b/arch/mips/include/asm/mc146818-time.h
@@ -113,7 +113,7 @@ static inline unsigned long mc146818_get_cmos_time(void)
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	year = mc146818_decode_year(year);
 
-	return mktime(year, mon, day, hour, min, sec);
+	return mktime_unsafe(year, mon, day, hour, min, sec);
 }
 
 #endif /* __ASM_MC146818_TIME_H */
diff --git a/arch/mips/sibyte/swarm/rtc_m41t81.c b/arch/mips/sibyte/swarm/rtc_m41t81.c
index b732600..c117804 100644
--- a/arch/mips/sibyte/swarm/rtc_m41t81.c
+++ b/arch/mips/sibyte/swarm/rtc_m41t81.c
@@ -218,7 +218,7 @@ unsigned long m41t81_get_time(void)
 
 	year += 2000;
 
-	return mktime(year, mon, day, hour, min, sec);
+	return mktime_unsafe(year, mon, day, hour, min, sec);
 }
 
 int m41t81_probe(void)
diff --git a/arch/mips/sibyte/swarm/rtc_xicor1241.c b/arch/mips/sibyte/swarm/rtc_xicor1241.c
index 178a824..ba9e4b40 100644
--- a/arch/mips/sibyte/swarm/rtc_xicor1241.c
+++ b/arch/mips/sibyte/swarm/rtc_xicor1241.c
@@ -201,7 +201,7 @@ unsigned long xicor_get_time(void)
 
 	year += (y2k * 100);
 
-	return mktime(year, mon, day, hour, min, sec);
+	return mktime_unsafe(year, mon, day, hour, min, sec);
 }
 
 int xicor_probe(void)
diff --git a/arch/mips/sibyte/swarm/setup.c b/arch/mips/sibyte/swarm/setup.c
index 3462c83..8c5aca1 100644
--- a/arch/mips/sibyte/swarm/setup.c
+++ b/arch/mips/sibyte/swarm/setup.c
@@ -102,7 +102,7 @@ void read_persistent_clock(struct timespec *ts)
 
 	case RTC_NONE:
 	default:
-		sec = mktime(2000, 1, 1, 0, 0, 0);
+		sec = mktime_unsafe(2000, 1, 1, 0, 0, 0);
 		break;
 	}
 	ts->tv_sec = sec;
diff --git a/arch/mn10300/kernel/rtc.c b/arch/mn10300/kernel/rtc.c
index 48d7058..35915d5 100644
--- a/arch/mn10300/kernel/rtc.c
+++ b/arch/mn10300/kernel/rtc.c
@@ -30,12 +30,12 @@ void read_persistent_clock(struct timespec *ts)
 	get_rtc_time(&tm);
 
 	ts->tv_nsec = 0;
-	ts->tv_sec = mktime(tm.tm_year, tm.tm_mon, tm.tm_mday,
+	ts->tv_sec = mktime_unsafe(tm.tm_year, tm.tm_mon, tm.tm_mday,
 			    tm.tm_hour, tm.tm_min, tm.tm_sec);
 
 	/* if rtc is way off in the past, set something reasonable */
 	if (ts->tv_sec < 0)
-		ts->tv_sec = mktime(2009, 1, 1, 12, 0, 0);
+		ts->tv_sec = mktime_unsafe(2009, 1, 1, 12, 0, 0);
 }
 
 /*
diff --git a/arch/parisc/include/asm/rtc.h b/arch/parisc/include/asm/rtc.h
index 099d641..c360087 100644
--- a/arch/parisc/include/asm/rtc.h
+++ b/arch/parisc/include/asm/rtc.h
@@ -100,7 +100,7 @@ static int set_rtc_time(struct rtc_time *wtime)
 {
 	u_int32_t secs;
 
-	secs = mktime(wtime->tm_year + 1900, wtime->tm_mon + 1, wtime->tm_mday, 
+	secs = mktime_unsafe(wtime->tm_year + 1900, wtime->tm_mon + 1, wtime->tm_mday,
 		      wtime->tm_hour, wtime->tm_min, wtime->tm_sec);
 
 	if(pdc_tod_set(secs, 0) < 0)
diff --git a/arch/powerpc/kernel/rtas-proc.c b/arch/powerpc/kernel/rtas-proc.c
index 8777fb0..1183005 100644
--- a/arch/powerpc/kernel/rtas-proc.c
+++ b/arch/powerpc/kernel/rtas-proc.c
@@ -403,7 +403,7 @@ static int ppc_rtas_clock_show(struct seq_file *m, void *v)
 		year = ret[0]; mon  = ret[1]; day  = ret[2];
 		hour = ret[3]; min  = ret[4]; sec  = ret[5];
 		seq_printf(m, "%lu\n",
-				mktime(year, mon, day, hour, min, sec));
+				mktime_unsafe(year, mon, day, hour, min, sec));
 	}
 	return 0;
 }
diff --git a/arch/powerpc/kernel/rtas-rtc.c b/arch/powerpc/kernel/rtas-rtc.c
index c57c193..ba1655a 100644
--- a/arch/powerpc/kernel/rtas-rtc.c
+++ b/arch/powerpc/kernel/rtas-rtc.c
@@ -37,7 +37,7 @@ unsigned long __init rtas_get_boot_time(void)
 		return 0;
 	}
 
-	return mktime(ret[0], ret[1], ret[2], ret[3], ret[4], ret[5]);
+	return mktime_unsafe(ret[0], ret[1], ret[2], ret[3], ret[4], ret[5]);
 }
 
 /* NOTE: get_rtc_time will get an error if executed in interrupt context
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 7505599..e78f82f 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -713,7 +713,7 @@ static void __read_persistent_clock(struct timespec *ts)
 	}
 	ppc_md.get_rtc_time(&tm);
 
-	ts->tv_sec = mktime(tm.tm_year+1900, tm.tm_mon+1, tm.tm_mday,
+	ts->tv_sec = mktime_unsafe(tm.tm_year+1900, tm.tm_mon+1, tm.tm_mday,
 			    tm.tm_hour, tm.tm_min, tm.tm_sec);
 }
 
diff --git a/arch/powerpc/platforms/8xx/m8xx_setup.c b/arch/powerpc/platforms/8xx/m8xx_setup.c
index d303774..5e3e471 100644
--- a/arch/powerpc/platforms/8xx/m8xx_setup.c
+++ b/arch/powerpc/platforms/8xx/m8xx_setup.c
@@ -172,7 +172,7 @@ int mpc8xx_set_rtc_time(struct rtc_time *tm)
 
 	sys_tmr1 = immr_map(im_sitk);
 	sys_tmr2 = immr_map(im_sit);
-	time = mktime(tm->tm_year+1900, tm->tm_mon+1, tm->tm_mday,
+	time = mktime_unsafe(tm->tm_year+1900, tm->tm_mon+1, tm->tm_mday,
 	              tm->tm_hour, tm->tm_min, tm->tm_sec);
 
 	out_be32(&sys_tmr1->sitk_rtck, KAPWR_KEY);
diff --git a/arch/powerpc/platforms/cell/beat.c b/arch/powerpc/platforms/cell/beat.c
index affcf56..48b1b79 100644
--- a/arch/powerpc/platforms/cell/beat.c
+++ b/arch/powerpc/platforms/cell/beat.c
@@ -58,7 +58,7 @@ void beat_halt(void)
 int beat_set_rtc_time(struct rtc_time *rtc_time)
 {
 	u64 tim;
-	tim = mktime(rtc_time->tm_year+1900,
+	tim = mktime_unsafe(rtc_time->tm_year+1900,
 		     rtc_time->tm_mon+1, rtc_time->tm_mday,
 		     rtc_time->tm_hour, rtc_time->tm_min, rtc_time->tm_sec);
 	if (beat_rtc_write(tim))
diff --git a/arch/powerpc/platforms/maple/time.c b/arch/powerpc/platforms/maple/time.c
index b4a369d..2f6d1cb 100644
--- a/arch/powerpc/platforms/maple/time.c
+++ b/arch/powerpc/platforms/maple/time.c
@@ -170,7 +170,7 @@ unsigned long __init maple_get_boot_time(void)
 	request_resource(&ioport_resource, &rtc_iores);
 
 	maple_get_rtc_time(&tm);
-	return mktime(tm.tm_year+1900, tm.tm_mon+1, tm.tm_mday,
+	return mktime_unsafe(tm.tm_year+1900, tm.tm_mon+1, tm.tm_mday,
 		      tm.tm_hour, tm.tm_min, tm.tm_sec);
 }
 
diff --git a/arch/powerpc/platforms/pasemi/time.c b/arch/powerpc/platforms/pasemi/time.c
index fa54351..656c2c5 100644
--- a/arch/powerpc/platforms/pasemi/time.c
+++ b/arch/powerpc/platforms/pasemi/time.c
@@ -24,5 +24,5 @@
 unsigned long __init pas_get_boot_time(void)
 {
 	/* Let's just return a fake date right now */
-	return mktime(2006, 1, 1, 12, 0, 0);
+	return mktime_unsafe(2006, 1, 1, 12, 0, 0);
 }
diff --git a/arch/powerpc/platforms/powermac/time.c b/arch/powerpc/platforms/powermac/time.c
index 8680bb6..1b591c0 100644
--- a/arch/powerpc/platforms/powermac/time.c
+++ b/arch/powerpc/platforms/powermac/time.c
@@ -96,7 +96,7 @@ static void to_rtc_time(unsigned long now, struct rtc_time *tm)
     defined(CONFIG_PMAC_SMU)
 static unsigned long from_rtc_time(struct rtc_time *tm)
 {
-	return mktime(tm->tm_year+1900, tm->tm_mon+1, tm->tm_mday,
+	return mktime_unsafe(tm->tm_year+1900, tm->tm_mon+1, tm->tm_mday,
 		      tm->tm_hour, tm->tm_min, tm->tm_sec);
 }
 #endif
diff --git a/arch/powerpc/platforms/powernv/opal-rtc.c b/arch/powerpc/platforms/powernv/opal-rtc.c
index 499707d..5e9c80a 100644
--- a/arch/powerpc/platforms/powernv/opal-rtc.c
+++ b/arch/powerpc/platforms/powernv/opal-rtc.c
@@ -58,7 +58,7 @@ unsigned long __init opal_get_boot_time(void)
 	y_m_d = be32_to_cpu(__y_m_d);
 	h_m_s_ms = be64_to_cpu(__h_m_s_ms);
 	opal_to_tm(y_m_d, h_m_s_ms, &tm);
-	return mktime(tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
+	return mktime_unsafe(tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
 		      tm.tm_hour, tm.tm_min, tm.tm_sec);
 out:
 	ppc_md.get_rtc_time = NULL;
diff --git a/arch/sh/boards/mach-sh03/rtc.c b/arch/sh/boards/mach-sh03/rtc.c
index f83ac79..67ce035 100644
--- a/arch/sh/boards/mach-sh03/rtc.c
+++ b/arch/sh/boards/mach-sh03/rtc.c
@@ -74,7 +74,7 @@ unsigned long get_cmos_time(void)
 	}
 
 	spin_unlock(&sh03_rtc_lock);
-	return mktime(year, mon, day, hour, min, sec);
+	return mktime_unsafe(year, mon, day, hour, min, sec);
 }
 
 void sh03_rtc_gettimeofday(struct timespec *tv)
diff --git a/arch/sh/kernel/time.c b/arch/sh/kernel/time.c
index d6d0a98..ec1d24b 100644
--- a/arch/sh/kernel/time.c
+++ b/arch/sh/kernel/time.c
@@ -26,7 +26,7 @@
 /* Dummy RTC ops */
 static void null_rtc_get_time(struct timespec *tv)
 {
-	tv->tv_sec = mktime(2000, 1, 1, 0, 0, 0);
+	tv->tv_sec = mktime_unsafe(2000, 1, 1, 0, 0, 0);
 	tv->tv_nsec = 0;
 }
 
diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index ca9622a..820958d 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -108,7 +108,7 @@ void mach_get_cmos_time(struct timespec *now)
 	} else
 		year += CMOS_YEARS_OFFS;
 
-	now->tv_sec = mktime(year, mon, day, hour, min, sec);
+	now->tv_sec = mktime_unsafe(year, mon, day, hour, min, sec);
 	now->tv_nsec = 0;
 }
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 850da94..cb4116a 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -114,7 +114,7 @@ void efi_get_time(struct timespec *now)
 	if (status != EFI_SUCCESS)
 		pr_err("Oops: efitime: can't read time!\n");
 
-	now->tv_sec = mktime(eft.year, eft.month, eft.day, eft.hour,
+	now->tv_sec = mktime_unsafe(eft.year, eft.month, eft.day, eft.hour,
 			     eft.minute, eft.second);
 	now->tv_nsec = 0;
 }
diff --git a/arch/x86/platform/intel-mid/intel_mid_vrtc.c b/arch/x86/platform/intel-mid/intel_mid_vrtc.c
index 4762cff..5685ca2 100644
--- a/arch/x86/platform/intel-mid/intel_mid_vrtc.c
+++ b/arch/x86/platform/intel-mid/intel_mid_vrtc.c
@@ -82,7 +82,7 @@ void vrtc_get_time(struct timespec *now)
 	pr_info("vRTC: sec: %d min: %d hour: %d day: %d "
 		"mon: %d year: %d\n", sec, min, hour, mday, mon, year);
 
-	now->tv_sec = mktime(year, mon, mday, hour, min, sec);
+	now->tv_sec = mktime_unsafe(year, mon, mday, hour, min, sec);
 	now->tv_nsec = 0;
 }
 
diff --git a/drivers/rtc/rtc-lib.c b/drivers/rtc/rtc-lib.c
index c4cf057..a0b473a 100644
--- a/drivers/rtc/rtc-lib.c
+++ b/drivers/rtc/rtc-lib.c
@@ -113,7 +113,7 @@ EXPORT_SYMBOL(rtc_valid_tm);
  */
 int rtc_tm_to_time(struct rtc_time *tm, unsigned long *time)
 {
-	*time = mktime(tm->tm_year + 1900, tm->tm_mon + 1, tm->tm_mday,
+	*time = mktime_unsafe(tm->tm_year + 1900, tm->tm_mon + 1, tm->tm_mday,
 			tm->tm_hour, tm->tm_min, tm->tm_sec);
 	return 0;
 }
diff --git a/drivers/rtc/rtc-ls1x.c b/drivers/rtc/rtc-ls1x.c
index 682ecb0..04687c9 100644
--- a/drivers/rtc/rtc-ls1x.c
+++ b/drivers/rtc/rtc-ls1x.c
@@ -93,7 +93,7 @@ static int ls1x_rtc_read_time(struct device *dev, struct rtc_time *rtm)
 	t = readl(SYS_TOYREAD1);
 
 	memset(rtm, 0, sizeof(struct rtc_time));
-	t  = mktime((t & LS1X_YEAR_MASK), ls1x_get_month(v),
+	t  = mktime_unsafe((t & LS1X_YEAR_MASK), ls1x_get_month(v),
 			ls1x_get_day(v), ls1x_get_hour(v),
 			ls1x_get_min(v), ls1x_get_sec(v));
 	rtc_time_to_tm(t, rtm);
diff --git a/drivers/rtc/rtc-tps6586x.c b/drivers/rtc/rtc-tps6586x.c
index 426901c..5f8d726 100644
--- a/drivers/rtc/rtc-tps6586x.c
+++ b/drivers/rtc/rtc-tps6586x.c
@@ -261,7 +261,7 @@ static int tps6586x_rtc_probe(struct platform_device *pdev)
 	rtc->irq = platform_get_irq(pdev, 0);
 
 	/* Set epoch start as 00:00:00:01:01:2009 */
-	rtc->epoch_start = mktime(2009, 1, 1, 0, 0, 0);
+	rtc->epoch_start = mktime_unsafe(2009, 1, 1, 0, 0, 0);
 
 	/* 1 kHz tick mode, enable tick counting */
 	ret = tps6586x_update(tps_dev, RTC_CTRL,
diff --git a/drivers/rtc/rtc-vr41xx.c b/drivers/rtc/rtc-vr41xx.c
index 88c9c92..a3d5772 100644
--- a/drivers/rtc/rtc-vr41xx.c
+++ b/drivers/rtc/rtc-vr41xx.c
@@ -140,7 +140,7 @@ static int vr41xx_rtc_read_time(struct device *dev, struct rtc_time *time)
 {
 	unsigned long epoch_sec, elapsed_sec;
 
-	epoch_sec = mktime(epoch, 1, 1, 0, 0, 0);
+	epoch_sec = mktime_unsafe(epoch, 1, 1, 0, 0, 0);
 	elapsed_sec = read_elapsed_second();
 
 	rtc_time_to_tm(epoch_sec + elapsed_sec, time);
@@ -152,8 +152,8 @@ static int vr41xx_rtc_set_time(struct device *dev, struct rtc_time *time)
 {
 	unsigned long epoch_sec, current_sec;
 
-	epoch_sec = mktime(epoch, 1, 1, 0, 0, 0);
-	current_sec = mktime(time->tm_year + 1900, time->tm_mon + 1, time->tm_mday,
+	epoch_sec = mktime_unsafe(epoch, 1, 1, 0, 0, 0);
+	current_sec = mktime_unsafe(time->tm_year + 1900, time->tm_mon + 1, time->tm_mday,
 			     time->tm_hour, time->tm_min, time->tm_sec);
 
 	write_elapsed_second(current_sec - epoch_sec);
@@ -185,7 +185,7 @@ static int vr41xx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
 	unsigned long alarm_sec;
 	struct rtc_time *time = &wkalrm->time;
 
-	alarm_sec = mktime(time->tm_year + 1900, time->tm_mon + 1, time->tm_mday,
+	alarm_sec = mktime_unsafe(time->tm_year + 1900, time->tm_mon + 1, time->tm_mday,
 			   time->tm_hour, time->tm_min, time->tm_sec);
 
 	spin_lock_irq(&rtc_lock);
diff --git a/include/linux/time.h b/include/linux/time.h
index 8c42cf8..e49d421 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -39,9 +39,9 @@ static inline int timeval_compare(const struct timeval *lhs, const struct timeva
 	return lhs->tv_usec - rhs->tv_usec;
 }
 
-extern unsigned long mktime(const unsigned int year, const unsigned int mon,
-			    const unsigned int day, const unsigned int hour,
-			    const unsigned int min, const unsigned int sec);
+extern unsigned long mktime_unsafe(const unsigned int year, const unsigned int mon,
+                            const unsigned int day, const unsigned int hour,
+                            const unsigned int min, const unsigned int sec);
 
 extern void set_normalized_timespec(struct timespec *ts, time_t sec, s64 nsec);
 
diff --git a/kernel/time/time.c b/kernel/time/time.c
index a9ae20f..d6a4464 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -320,7 +320,7 @@ EXPORT_SYMBOL(timespec_trunc);
  * will already get problems at other places on 2038-01-19 03:14:08)
  */
 unsigned long
-mktime(const unsigned int year0, const unsigned int mon0,
+mktime_unsafe(const unsigned int year0, const unsigned int mon0,
        const unsigned int day, const unsigned int hour,
        const unsigned int min, const unsigned int sec)
 {
@@ -340,7 +340,7 @@ mktime(const unsigned int year0, const unsigned int mon0,
 	)*60 + sec; /* finally seconds */
 }
 
-EXPORT_SYMBOL(mktime);
+EXPORT_SYMBOL(mktime_unsafe);
 
 /**
  * set_normalized_timespec - set timespec sec and nsec parts and normalize
-- 
1.7.9.5

