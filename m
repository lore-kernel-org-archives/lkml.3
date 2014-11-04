Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbaKDQYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:24:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566AbaKDQUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:20:46 -0500
From: Don Zickus <dzickus@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        uobergfe@redhat.com, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 1/9] watchdog: new definitions and variables, initialization
Date: Tue,  4 Nov 2014 11:20:16 -0500
Message-Id: <1415118024-194247-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1415118024-194247-1-git-send-email-dzickus@redhat.com>
References: <1415118024-194247-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Obergfell <uobergfe@redhat.com>

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
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 include/linux/nmi.h |    2 ++
 kernel/watchdog.c   |   27 ++++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletions(-)

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
index 70bf118..91e7bff 100644
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
1.7.1

