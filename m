Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358Ab3EQWUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:20:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756940Ab3EQVhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kay Sievers <kay@vrfy.org>, John Stultz <john.stultz@linaro.org>,
        Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 033/102] time: Revert ALWAYS_USE_PERSISTENT_CLOCK compile time optimizaitons
Date: Fri, 17 May 2013 14:35:48 -0700
Message-Id: <20130517213247.817587821@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <john.stultz@linaro.org>

commit b4f711ee03d28f776fd2324fd0bd999cc428e4d2 upstream.

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
Cc: Feng Tang <feng.tang@intel.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Link: http://lkml.kernel.org/r/1366828376-18124-1-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/Kconfig     |    1 -
 drivers/rtc/Kconfig  |    2 --
 include/linux/time.h |    4 ----
 kernel/time/Kconfig  |    5 -----
 4 files changed, 12 deletions(-)

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
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -117,14 +117,10 @@ static inline bool timespec_valid_strict
 
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


