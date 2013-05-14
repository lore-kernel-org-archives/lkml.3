Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab3ENTBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 15:01:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51404 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab3ENTBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 15:01:41 -0400
Date: Tue, 14 May 2013 12:01:13 -0700
From: tip-bot for John Stultz <tipbot@zytor.com>
Message-ID: <tip-b4f711ee03d28f776fd2324fd0bd999cc428e4d2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kay@vrfy.org, jgunthorpe@obsidianresearch.com, john.stultz@linaro.org,
        tglx@linutronix.de, feng.tang@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kay@vrfy.org, jgunthorpe@obsidianresearch.com, john.stultz@linaro.org,
        tglx@linutronix.de, feng.tang@intel.com
In-Reply-To: <1366828376-18124-1-git-send-email-john.stultz@linaro.org>
References: <1366828376-18124-1-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] time:
  Revert ALWAYS_USE_PERSISTENT_CLOCK compile time optimizaitons
Git-Commit-ID: b4f711ee03d28f776fd2324fd0bd999cc428e4d2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b4f711ee03d28f776fd2324fd0bd999cc428e4d2
Gitweb:     http://git.kernel.org/tip/b4f711ee03d28f776fd2324fd0bd999cc428e4d2
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Wed, 24 Apr 2013 11:32:56 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 14 May 2013 20:54:06 +0200

time: Revert ALWAYS_USE_PERSISTENT_CLOCK compile time optimizaitons

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

Reported-by: Kay Sievers <kay@vrfy.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: stable <stable@vger.kernel.org> #3.9
Cc: Feng Tang <feng.tang@intel.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Link: http://lkml.kernel.org/r/1366828376-18124-1-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig     | 1 -
 drivers/rtc/Kconfig  | 2 --
 include/linux/time.h | 4 ----
 kernel/time/Kconfig  | 5 -----
 4 files changed, 12 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5db2117..45c4124 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -108,7 +108,6 @@ config X86
 	select GENERIC_CLOCKEVENTS_BROADCAST if X86_64 || (X86_32 && X86_LOCAL_APIC)
 	select GENERIC_TIME_VSYSCALL if X86_64
 	select KTIME_SCALAR if X86_32
-	select ALWAYS_USE_PERSISTENT_CLOCK
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select HAVE_CONTEXT_TRACKING if X86_64
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 0c81915..b983813 100644
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
index 22d81b3..d5d229b 100644
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
