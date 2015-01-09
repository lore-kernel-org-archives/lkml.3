Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbbAIDfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 22:35:16 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:60944 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbbAIDfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 22:35:12 -0500
From: Cyril Bur <cyrilbur@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mpe@ellerman.id.au, drjones@redhat.com, dzickus@redhat.com,
        akpm@linux-foundation.org, mingo@kernel.org, uobergfe@redhat.com,
        chaiw.fnst@cn.fujitsu.com, fabf@skynet.be, atomlin@redhat.com,
        benzh@chromium.org, schwidefsky@de.ibm.com,
        Cyril Bur <cyrilbur@gmail.com>
Subject: [PATCH v2 1/2] Add another clock for use with the soft lockup watchdog.
Date: Fri,  9 Jan 2015 14:34:37 +1100
Message-Id: <1420774478-16760-2-git-send-email-cyrilbur@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420774478-16760-1-git-send-email-cyrilbur@gmail.com>
References: <1420774478-16760-1-git-send-email-cyrilbur@gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010903-0005-0000-0000-0000012B4D88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This permits the use of arch specific clocks for which virtualised kernels can
use their notion of 'running' time, not the elpased wall time which will
include host execution time.

Signed-off-by: Cyril Bur <cyrilbur@gmail.com>
---
V2:
   Remove the export of running_clock
   Use local_clock instead of sched_clock as was initally used in the
softlockup detector

---
 include/linux/sched.h |  1 +
 kernel/sched/clock.c  | 13 +++++++++++++
 kernel/watchdog.c     |  2 +-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8db31ef..e400162 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2145,6 +2145,7 @@ extern unsigned long long notrace sched_clock(void);
  */
 extern u64 cpu_clock(int cpu);
 extern u64 local_clock(void);
+extern u64 running_clock(void);
 extern u64 sched_clock_cpu(int cpu);
 
 
diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index c27e4f8..c0a2051 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -420,3 +420,16 @@ u64 local_clock(void)
 
 EXPORT_SYMBOL_GPL(cpu_clock);
 EXPORT_SYMBOL_GPL(local_clock);
+
+/*
+ * Running clock - returns the time that has elapsed while a guest has been
+ * running.
+ * On a guest this value should be local_clock minus the time the guest was
+ * suspended by the hypervisor (for any reason).
+ * On bare metal this function should return the same as local_clock.
+ * Architectures and sub-architectures can override this.
+ */
+u64 __weak running_clock(void)
+{
+	return local_clock();
+}
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

