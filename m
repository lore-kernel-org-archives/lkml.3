Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaJQQ75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 12:59:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbaJQQ7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 12:59:55 -0400
From: Ulrich Obergfell <uobergfe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: dzickus@redhat.com, uobergfe@redhat.com
Subject: [PATCH v2 1/9] watchdog: new definitions and variables, initialization
Date: Fri, 17 Oct 2014 19:06:20 +0200
Message-Id: <1413565588-4144-2-git-send-email-uobergfe@redhat.com>
In-Reply-To: <1413565588-4144-1-git-send-email-uobergfe@redhat.com>
References: <1413565588-4144-1-git-send-email-uobergfe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce new definitions and variables to separate the user interface
in /proc/sys/kernel from the internal run state of the lockup detectors.
The internal run state is represented by two bits in a new variable that
is named 'watchdog_enabled'. This helps simplify the code, for example:

- In order to check if any of the two lockup detectors is enabled,
  it is sufficient to check if 'watchdog_enabled' is not zero.

- In order to enable/disable one or both lockup detectors,
  it is sufficient to set/clear one or both bits in 'watchdog_enabled'.

- Concurrent updates of 'watchdog_enabled' need not be synchronized via
  a spinlock or a mutex. Updates can either be atomic or concurrency can
  be detected by using 'cmpxchg'.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
---
 include/linux/nmi.h |  2 ++
 kernel/watchdog.c   | 27 ++++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 9b2022a..3885a7d 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -68,6 +68,8 @@ static inline bool trigger_allbutself_cpu_backtrace(void)
 #ifdef CONFIG_LOCKUP_DETECTOR
 int hw_nmi_is_cpu_stuck(struct pt_regs *);
 u64 hw_nmi_get_sample_period(int watchdog_thresh);
+extern int nmi_watchdog_enabled;
+extern int soft_watchdog_enabled;
 extern int watchdog_user_enabled;
 extern int watchdog_thresh;
 extern int sysctl_softlockup_all_cpu_backtrace;
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 49e9537..f8da756 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -24,8 +24,33 @@
 #include <linux/kvm_para.h>
 #include <linux/perf_event.h>
 
-int watchdog_user_enabled = 1;
+/*
+ * The run state of the lockup detectors is controlled by the content of the
+ * 'watchdog_enabled' variable. Each lockup detector has its dedicated bit -
+ * bit 0 for the hard lockup detector and bit 1 for the soft lockup detector.
+ *
+ * 'watchdog_user_enabled', 'nmi_watchdog_enabled' and 'soft_watchdog_enabled'
+ * are variables that are only used as an 'interface' between the parameters
+ * in /proc/sys/kernel and the internal state bits in 'watchdog_enabled'. The
+ * 'watchdog_thresh' variable is handled differently because its value is not
+ * boolean, and the lockup detectors are 'suspended' while 'watchdog_thresh'
+ * is equal zero.
+ */
+#define NMI_WATCHDOG_ENABLED_BIT   0
+#define SOFT_WATCHDOG_ENABLED_BIT  1
+#define NMI_WATCHDOG_ENABLED      (1 << NMI_WATCHDOG_ENABLED_BIT)
+#define SOFT_WATCHDOG_ENABLED     (1 << SOFT_WATCHDOG_ENABLED_BIT)
+
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
+static unsigned long __read_mostly watchdog_enabled = SOFT_WATCHDOG_ENABLED|NMI_WATCHDOG_ENABLED;
+#else
+static unsigned long __read_mostly watchdog_enabled = SOFT_WATCHDOG_ENABLED;
+#endif
+int __read_mostly nmi_watchdog_enabled;
+int __read_mostly soft_watchdog_enabled;
+int __read_mostly watchdog_user_enabled;
 int __read_mostly watchdog_thresh = 10;
+
 #ifdef CONFIG_SMP
 int __read_mostly sysctl_softlockup_all_cpu_backtrace;
 #else
-- 
1.7.11.7

