Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab3AOQJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 11:09:43 -0500
Received: from mga14.intel.com ([143.182.124.37]:56384 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173Ab3AOQJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 11:09:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,473,1355126400"; 
   d="scan'208";a="191395627"
From: Feng Tang <feng.tang@intel.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH v2 3/3] timekeeping: Add CONFIG_HAS_PERSISTENT_CLOCK option
Date: Wed, 16 Jan 2013 00:09:49 +0800
Message-Id: <1358266189-8812-3-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358266189-8812-1-git-send-email-feng.tang@intel.com>
References: <1358266189-8812-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the persistent clock check a kernel config option, so that some
platform can explicitely select it, also make CONFIG_RTC_HCTOSYS depends
on its non-existence, which could prevent the persistent clock and RTC
code from doing similar thing twice during system's init/suspend/resume
phases.

If the CONFIG_HAS_PERSISTENT_CLOCK=n, then no change happens for kernel
which still does the persistent clock check in timekeeping_init().

Cc: Thomas Gleixner <tglx@linutronix.de>
Suggested-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 drivers/rtc/Kconfig  |    1 +
 include/linux/time.h |    5 +++++
 kernel/time/Kconfig  |    5 +++++
 3 files changed, 11 insertions(+)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 923a9da..5b963c6 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -20,6 +20,7 @@ if RTC_CLASS
 config RTC_HCTOSYS
 	bool "Set system time from RTC on startup and resume"
 	default y
+	depends on !HAS_PERSISTENT_CLOCK
 	help
 	  If you say yes here, the system time (wall clock) will be set using
 	  the value read from a specified RTC device. This is useful to avoid
diff --git a/include/linux/time.h b/include/linux/time.h
index 2f58603..e08051c 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -116,10 +116,15 @@ static inline bool timespec_valid_strict(const struct timespec *ts)
 }
 
 extern bool persistent_clock_exist;
+
+#ifdef CONFIG_HAS_PERSISTENT_CLOCK
+#define has_persistent_clock()	true
+#else
 static inline bool has_persistent_clock(void)
 {
 	return persistent_clock_exist;
 }
+#endif
 
 extern void read_persistent_clock(struct timespec *ts);
 extern void read_boot_clock(struct timespec *ts);
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 8601f0d..f7e45b9 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -12,6 +12,11 @@ config CLOCKSOURCE_WATCHDOG
 config ARCH_CLOCKSOURCE_DATA
 	bool
 
+# Platforms has a persistent clock
+config HAS_PERSISTENT_CLOCK
+	bool
+	default n
+
 # Timekeeping vsyscall support
 config GENERIC_TIME_VSYSCALL
 	bool
-- 
1.7.9.5

