Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab3DXSdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 14:33:10 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:37513 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110Ab3DXSdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 14:33:07 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, stable <stable@vger.kernel.org>,
        Kay Sievers <kay@vrfy.org>, Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] time: Revert ALWAYS_USE_PERSISTENT_CLOCK compile time optimizaitons
Date: Wed, 24 Apr 2013 11:32:56 -0700
Message-Id: <1366828376-18124-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers noted that the ALWAYS_USE_PERSISTENT_CLOCK config,
which enables some minor compile time optimization to avoid
uncessary code in mostly the suspend/resume path could cause
problems for userland.

In particular, the dependency for RTC_HCTOSYS on
!ALWAYS_USE_PERSISTENT_CLOCK, which avoids setting the time
twice and simplifies suspend/resume, has the side effect
of causing the /sys/class/rtc/rtcN/hctosys flag to always be
zero, and this flag is commonly used by udev to setup the
/dev/rtc symlink to /dev/rtcN, which can cause pain for
older applications.

While the udev rules could use some work to be less fragile,
breaking userland should strongly be avoided. Additionally
the compile time optimizations are fairly minor, and the code
being optimized is likely to be reworked in the future, so
lets revert this change.

I suspect this will miss 3.9-final, so marking it for 3.9-stable.

Cc: stable <stable@vger.kernel.org>
CC: Kay Sievers <kay@vrfy.org>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Kay Sievers <kay@vrfy.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/x86/Kconfig     |    1 -
 drivers/rtc/Kconfig  |    2 --
 include/linux/time.h |    4 ----
 kernel/time/Kconfig  |    5 -----
 4 files changed, 12 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 15b5cef..6ef2a37 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -107,7 +107,6 @@ config X86
 	select GENERIC_CLOCKEVENTS_BROADCAST if X86_64 || (X86_32 && X86_LOCAL_APIC)
 	select GENERIC_TIME_VSYSCALL if X86_64
 	select KTIME_SCALAR if X86_32
-	select ALWAYS_USE_PERSISTENT_CLOCK
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select HAVE_CONTEXT_TRACKING if X86_64
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 79fbe38..9e95473 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -20,7 +20,6 @@ if RTC_CLASS
 config RTC_HCTOSYS
 	bool "Set system time from RTC on startup and resume"
 	default y
-	depends on !ALWAYS_USE_PERSISTENT_CLOCK
 	help
 	  If you say yes here, the system time (wall clock) will be set using
 	  the value read from a specified RTC device. This is useful to avoid
@@ -29,7 +28,6 @@ config RTC_HCTOSYS
 config RTC_SYSTOHC
 	bool "Set the RTC time based on NTP synchronization"
 	default y
-	depends on !ALWAYS_USE_PERSISTENT_CLOCK
 	help
 	  If you say yes here, the system time (wall clock) will be stored
 	  in the RTC specified by RTC_HCTOSYS_DEVICE approximately every 11
diff --git a/include/linux/time.h b/include/linux/time.h
index d4835df..afcdc4b 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -117,14 +117,10 @@ static inline bool timespec_valid_strict(const struct timespec *ts)
 
 extern bool persistent_clock_exist;
 
-#ifdef ALWAYS_USE_PERSISTENT_CLOCK
-#define has_persistent_clock()	true
-#else
 static inline bool has_persistent_clock(void)
 {
 	return persistent_clock_exist;
 }
-#endif
 
 extern void read_persistent_clock(struct timespec *ts);
 extern void read_boot_clock(struct timespec *ts);
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 24510d8..b696922 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -12,11 +12,6 @@ config CLOCKSOURCE_WATCHDOG
 config ARCH_CLOCKSOURCE_DATA
 	bool
 
-# Platforms has a persistent clock
-config ALWAYS_USE_PERSISTENT_CLOCK
-	bool
-	default n
-
 # Timekeeping vsyscall support
 config GENERIC_TIME_VSYSCALL
 	bool
-- 
1.7.10.4

