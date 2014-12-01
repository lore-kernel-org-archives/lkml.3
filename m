Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaLACk2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 21:40:28 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:41028 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaLACk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 21:40:26 -0500
From: Cyril Bur <cyrilbur@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mpe@ellerman.id.au, akpm@linux-foundation.org,
        Cyril Bur <cyrilbur@gmail.com>
Subject: [PATCH 1/2] Add another clock for use with the soft lockup watchdog.
Date: Mon,  1 Dec 2014 13:38:59 +1100
Message-Id: <1417401540-12121-2-git-send-email-cyrilbur@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417401540-12121-1-git-send-email-cyrilbur@gmail.com>
References: <1417401540-12121-1-git-send-email-cyrilbur@gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120102-0029-0000-0000-000000B74EC7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This permits the use of arch specific clocks for which virtualised kernels can
use their notion of 'running' time, not the elpased wall time which will
include host execution time.

Signed-off-by: Cyril Bur <cyrilbur@gmail.com>
---
 include/linux/sched.h |  1 +
 kernel/sched/clock.c  | 14 ++++++++++++++
 kernel/watchdog.c     |  2 +-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5e344bb..12eb1d0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2101,6 +2101,7 @@ extern unsigned long long notrace sched_clock(void);
  */
 extern u64 cpu_clock(int cpu);
 extern u64 local_clock(void);
+extern u64 running_clock(void);
 extern u64 sched_clock_cpu(int cpu);
 
 
diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index c27e4f8..c83af4f 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -74,6 +74,20 @@ unsigned long long __weak sched_clock(void)
 }
 EXPORT_SYMBOL_GPL(sched_clock);
 
+/*
+ * Running clock - returns the time that has elapsed while a guest has been
+ * running.
+ * On a guest this value should be sched_clock minus the time the
+ * guest was suspended by the hypervisor (for any reason).
+ * On bare metal this function should return the same as sched_clock.
+ * Architectures and sub-architectures can override this.
+ */
+unsigned long long __weak running_clock(void)
+{
+	return sched_clock();
+}
+EXPORT_SYMBOL_GPL(running_clock);
+
 __read_mostly int sched_clock_running;
 
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 70bf118..3174bf8 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -154,7 +154,7 @@ static int get_softlockup_thresh(void)
  */
 static unsigned long get_timestamp(void)
 {
-	return local_clock() >> 30LL;  /* 2^30 ~= 10^9 */
+	return running_clock() >> 30LL;  /* 2^30 ~= 10^9 */
 }
 
 static void set_sample_period(void)
-- 
1.9.1

