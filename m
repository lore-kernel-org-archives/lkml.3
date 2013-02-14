Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934806Ab3BNRDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:03:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388Ab3BNRDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:03:37 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, linux-efi@vger.kernel.org
Subject: [RFE PATCH 1/2] x86, rtc, ntp, Do full rtc synchronization with ntp
Date: Thu, 14 Feb 2013 12:02:54 -0500
Message-Id: <1360861375-24131-2-git-send-email-prarit@redhat.com>
In-Reply-To: <1360861375-24131-1-git-send-email-prarit@redhat.com>
References: <1360861375-24131-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every 11 minutes ntp attempts to update the x86 rtc with the current
system time.  Currently, the x86 code only updates the rtc if the system
time is within +/-15 minutes of the current value of the rtc.  Other
architectures do a full synchronization and there is no reason that x86
should be software limited to a 30 minute window.

This patch changes the behavior of the kernel to do a full synchronization
(year, month, day, hour, minute, and second) of the rtc when ntp requests
a synchronization between the system time and the rtc.

I've used the RTC library functions in this patchset as they do all the
required bounds checking.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: x86@kernel.org
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: linux-efi@vger.kernel.org
---
 arch/x86/kernel/rtc.c         | 69 ++++++++-----------------------------------
 arch/x86/platform/efi/efi.c   | 24 ++++++++++-----
 arch/x86/platform/mrst/vrtc.c | 41 ++++++++++++++-----------
 3 files changed, 52 insertions(+), 82 deletions(-)

diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 801602b..44e6c3a 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -13,6 +13,7 @@
 #include <asm/x86_init.h>
 #include <asm/time.h>
 #include <asm/mrst.h>
+#include <asm/rtc.h>
 
 #ifdef CONFIG_X86_32
 /*
@@ -36,70 +37,24 @@ EXPORT_SYMBOL(rtc_lock);
  * nowtime is written into the registers of the CMOS clock, it will
  * jump to the next second precisely 500 ms later. Check the Motorola
  * MC146818A or Dallas DS12887 data sheet for details.
- *
- * BUG: This routine does not handle hour overflow properly; it just
- *      sets the minutes. Usually you'll only notice that after reboot!
  */
 int mach_set_rtc_mmss(unsigned long nowtime)
 {
-	int real_seconds, real_minutes, cmos_minutes;
-	unsigned char save_control, save_freq_select;
-	unsigned long flags;
+	struct rtc_time tm;
 	int retval = 0;
 
-	spin_lock_irqsave(&rtc_lock, flags);
-
-	 /* tell the clock it's being set */
-	save_control = CMOS_READ(RTC_CONTROL);
-	CMOS_WRITE((save_control|RTC_SET), RTC_CONTROL);
-
-	/* stop and reset prescaler */
-	save_freq_select = CMOS_READ(RTC_FREQ_SELECT);
-	CMOS_WRITE((save_freq_select|RTC_DIV_RESET2), RTC_FREQ_SELECT);
-
-	cmos_minutes = CMOS_READ(RTC_MINUTES);
-	if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
-		cmos_minutes = bcd2bin(cmos_minutes);
-
-	/*
-	 * since we're only adjusting minutes and seconds,
-	 * don't interfere with hour overflow. This avoids
-	 * messing with unknown time zones but requires your
-	 * RTC not to be off by more than 15 minutes
-	 */
-	real_seconds = nowtime % 60;
-	real_minutes = nowtime / 60;
-	/* correct for half hour time zone */
-	if (((abs(real_minutes - cmos_minutes) + 15)/30) & 1)
-		real_minutes += 30;
-	real_minutes %= 60;
-
-	if (abs(real_minutes - cmos_minutes) < 30) {
-		if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-			real_seconds = bin2bcd(real_seconds);
-			real_minutes = bin2bcd(real_minutes);
-		}
-		CMOS_WRITE(real_seconds, RTC_SECONDS);
-		CMOS_WRITE(real_minutes, RTC_MINUTES);
+	rtc_time_to_tm(nowtime, &tm);
+	if (!rtc_valid_tm(&tm)) {
+		retval = set_rtc_time(&tm);
+		if (retval)
+			printk(KERN_ERR "%s: RTC write failed with error %d\n",
+			       __FUNCTION__, retval);
 	} else {
-		printk_once(KERN_NOTICE
-		       "set_rtc_mmss: can't update from %d to %d\n",
-		       cmos_minutes, real_minutes);
-		retval = -1;
+		printk(KERN_ERR
+		       "%s: Invalid RTC value: write of %lx to RTC failed\n",
+			__FUNCTION__, nowtime);
+		retval = -EINVAL;
 	}
-
-	/* The following flags have to be released exactly in this order,
-	 * otherwise the DS12887 (popular MC146818A clone with integrated
-	 * battery and quartz) will not reset the oscillator and will not
-	 * update precisely 500 ms later. You won't find this mentioned in
-	 * the Dallas Semiconductor data sheets, but who believes data
-	 * sheets anyway ...                           -- Markus Kuhn
-	 */
-	CMOS_WRITE(save_control, RTC_CONTROL);
-	CMOS_WRITE(save_freq_select, RTC_FREQ_SELECT);
-
-	spin_unlock_irqrestore(&rtc_lock, flags);
-
 	return retval;
 }
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 77cf009..6ca930e 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -48,6 +48,7 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm/x86_init.h>
+#include <asm/rtc.h>
 
 #define EFI_DEBUG	1
 
@@ -262,10 +263,10 @@ static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
 
 int efi_set_rtc_mmss(unsigned long nowtime)
 {
-	int real_seconds, real_minutes;
 	efi_status_t 	status;
 	efi_time_t 	eft;
 	efi_time_cap_t 	cap;
+	struct rtc_time	tm;
 
 	status = efi.get_time(&eft, &cap);
 	if (status != EFI_SUCCESS) {
@@ -273,13 +274,20 @@ int efi_set_rtc_mmss(unsigned long nowtime)
 		return -1;
 	}
 
-	real_seconds = nowtime % 60;
-	real_minutes = nowtime / 60;
-	if (((abs(real_minutes - eft.minute) + 15)/30) & 1)
-		real_minutes += 30;
-	real_minutes %= 60;
-	eft.minute = real_minutes;
-	eft.second = real_seconds;
+	rtc_time_to_tm(nowtime, &tm);
+	if (!rtc_valid_tm(&tm)) {
+		eft.year = tm.tm_year + 1900;
+		eft.month = tm.tm_mon + 1;
+		eft.day = tm.tm_mday;
+		eft.minute = tm.tm_min;
+		eft.second = tm.tm_sec;
+		eft.nanosecond = 0;
+	} else {
+		printk(KERN_ERR
+		       "%s: Invalid EFI RTC value: write of %lx to EFI RTC failed\n",
+		       __FUNCTION__, nowtime);
+		return -1;
+	}
 
 	status = efi.set_time(&eft);
 	if (status != EFI_SUCCESS) {
diff --git a/arch/x86/platform/mrst/vrtc.c b/arch/x86/platform/mrst/vrtc.c
index 225bd0f..205b3d0 100644
--- a/arch/x86/platform/mrst/vrtc.c
+++ b/arch/x86/platform/mrst/vrtc.c
@@ -85,26 +85,33 @@ unsigned long vrtc_get_time(void)
 	return mktime(year, mon, mday, hour, min, sec);
 }
 
-/* Only care about the minutes and seconds */
 int vrtc_set_mmss(unsigned long nowtime)
 {
-	int real_sec, real_min;
 	unsigned long flags;
-	int vrtc_min;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	vrtc_min = vrtc_cmos_read(RTC_MINUTES);
-
-	real_sec = nowtime % 60;
-	real_min = nowtime / 60;
-	if (((abs(real_min - vrtc_min) + 15)/30) & 1)
-		real_min += 30;
-	real_min %= 60;
-
-	vrtc_cmos_write(real_sec, RTC_SECONDS);
-	vrtc_cmos_write(real_min, RTC_MINUTES);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-
+	struct rtc_time tm;
+	int year;
+
+	rtc_time_to_tm(nowtime, &tm);
+	if (!rtc_valid_tm(&tm) && tm.year >= 72) {
+		/*
+		 * tm.year is the number of years since 1900, and the
+		 * vrtc need the years since 1972.
+		 */
+		year = tm.year - 72;
+		spin_lock_irqsave(&rtc_lock, flags);
+		vrtc_cmos_write(year, RTC_YEAR);
+		vrtc_cmos_write(tm.mon, RTC_MONTH);
+		vrtc_cmos_write(tm.mday, RTC_DAY_OF_MONTH);
+		vrtc_cmos_write(tm.hour, RTC_HOURS);
+		vrtc_cmos_write(tm.min, RTC_MINUTES);
+		vrtc_cmos_write(tm.sec, RTC_SECONDS);
+		spin_unlock_irqrestore(&rtc_lock, flags);
+	} else {
+		printk(KERN_ERR
+		       "%s: Invalid vRTC value: write of %lx to vRTC failed\n",
+			__FUNCTION__, nowtime);
+		retval = -EINVAL;
+	}
 	return 0;
 }
 
-- 
1.8.1.2

