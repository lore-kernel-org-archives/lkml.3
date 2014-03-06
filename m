Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbaCFR6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:58:34 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:34899 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaCFR4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:56:49 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/6] cputime: Default implementation of nsecs -> cputime conversion
Date: Thu,  6 Mar 2014 18:56:37 +0100
Message-Id: <1394128601-26034-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1394128601-26034-1-git-send-email-fweisbec@gmail.com>
References: <1394128601-26034-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The architectures that override cputime_t (s390, ppc) don't provide
any version of nsecs_to_cputime(). Indeed this cputime_t implementation
by backend only happens when CONFIG_VIRT_CPU_ACCOUNTING_NATIVE=y under
which the core code doesn't make any use of nsecs_to_cputime().

At least for now.

We are going to make a broader use of it so lets provide a default
version with a per usecs granularity. It should be good enough for most
usecases.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 drivers/cpufreq/cpufreq_stats.c |  2 +-
 drivers/s390/cio/cio.c          |  2 +-
 fs/proc/stat.c                  |  2 +-
 fs/proc/uptime.c                |  2 +-
 include/linux/cputime.h         | 11 +++++++++++
 include/linux/kernel_stat.h     |  2 +-
 include/linux/sched.h           |  2 +-
 7 files changed, 17 insertions(+), 6 deletions(-)
 create mode 100644 include/linux/cputime.h

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 5793e14..79911a2 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -13,7 +13,7 @@
 #include <linux/cpufreq.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <asm/cputime.h>
+#include <linux/cputime.h>
 
 static spinlock_t cpufreq_stats_lock;
 
diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index 88e35d8..5154513 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -28,7 +28,7 @@
 #include <asm/chpid.h>
 #include <asm/airq.h>
 #include <asm/isc.h>
-#include <asm/cputime.h>
+#include <linux/cputime.h>
 #include <asm/fcx.h>
 #include <asm/nmi.h>
 #include <asm/crw.h>
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 6f599c6..9d231e9 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -9,7 +9,7 @@
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/irqnr.h>
-#include <asm/cputime.h>
+#include <linux/cputime.h>
 #include <linux/tick.h>
 
 #ifndef arch_irq_stat_cpu
diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
index 7141b8d..33de567 100644
--- a/fs/proc/uptime.c
+++ b/fs/proc/uptime.c
@@ -5,7 +5,7 @@
 #include <linux/seq_file.h>
 #include <linux/time.h>
 #include <linux/kernel_stat.h>
-#include <asm/cputime.h>
+#include <linux/cputime.h>
 
 static int uptime_proc_show(struct seq_file *m, void *v)
 {
diff --git a/include/linux/cputime.h b/include/linux/cputime.h
new file mode 100644
index 0000000..2842ebe
--- /dev/null
+++ b/include/linux/cputime.h
@@ -0,0 +1,11 @@
+#ifndef __LINUX_CPUTIME_H
+#define __LINUX_CPUTIME_H
+
+#include <asm/cputime.h>
+
+#ifndef nsecs_to_cputime
+# define nsecs_to_cputime(__nsecs)	\
+	usecs_to_cputime((__nsecs) / NSEC_PER_USEC)
+#endif
+
+#endif /* __LINUX_CPUTIME_H */
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 51c72be..d7c6131 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -9,7 +9,7 @@
 #include <linux/sched.h>
 #include <linux/vtime.h>
 #include <asm/irq.h>
-#include <asm/cputime.h>
+#include <linux/cputime.h>
 
 /*
  * 'kernel_stat.h' contains the definitions needed for doing
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 68a0e84..1ac566c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -27,7 +27,7 @@ struct sched_param {
 
 #include <asm/page.h>
 #include <asm/ptrace.h>
-#include <asm/cputime.h>
+#include <linux/cputime.h>
 
 #include <linux/smp.h>
 #include <linux/sem.h>
-- 
1.8.3.1

