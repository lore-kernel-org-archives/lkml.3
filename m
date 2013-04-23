Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab3DWMpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 08:45:53 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:51094 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab3DWMpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 08:45:52 -0400
X-Nat-Received: from [202.181.97.72]:50313 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1366721126.24137
To: tglx@linutronix.de, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fernando_b1@lab.ntt.co.jp
Subject: [PATCH] proc: Add workaround for idle/iowait decreasing problem.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201301152014.AAD52192.FOOHQVtSFMFOJL@I-love.SAKURA.ne.jp>
	<alpine.LFD.2.02.1301151313170.7475@ionos>
	<201301180857.r0I8vK7c052791@www262.sakura.ne.jp>
	<1363660703.4993.3.camel@nexus>
	<201304012205.DFC60784.HVOMJSFFLFtOOQ@I-love.SAKURA.ne.jp>
In-Reply-To: <201304012205.DFC60784.HVOMJSFFLFtOOQ@I-love.SAKURA.ne.jp>
Message-Id: <201304232145.AHE52181.HJVOOQSFLMFOtF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 23 Apr 2013 21:45:23 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 23042013 #9885973, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_NO_HZ=y can cause idle/iowait values to decrease.

If /proc/stat is monitored with a short interval (e.g. 1 or 2 secs) using
sysstat package, sar reports bogus %idle/iowait values because sar expects
that idle/iowait values do not decrease unless wraparound happens.

This patch makes idle/iowait values visible from /proc/stat increase
monotonically, with an assumption that we don't need to worry about
wraparound.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/proc/stat.c |   42 ++++++++++++++++++++++++++++++++++++++----
 1 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index e296572..9fff534 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -19,6 +19,40 @@
 #define arch_irq_stat() 0
 #endif
 
+/*
+ * CONFIG_NO_HZ=y can cause idle/iowait values to decrease.
+ * Make sure that idle/iowait values visible from /proc/stat do not decrease.
+ */
+static inline u64 validate_iowait(u64 iowait, const int cpu)
+{
+#ifdef CONFIG_NO_HZ
+	static u64 max_iowait[NR_CPUS];
+	static DEFINE_SPINLOCK(lock);
+	spin_lock(&lock);
+	if (likely(iowait >= max_iowait[cpu]))
+		max_iowait[cpu] = iowait;
+	else
+		iowait = max_iowait[cpu];
+	spin_unlock(&lock);
+#endif
+	return iowait;
+}
+
+static inline u64 validate_idle(u64 idle, const int cpu)
+{
+#ifdef CONFIG_NO_HZ
+	static u64 max_idle[NR_CPUS];
+	static DEFINE_SPINLOCK(lock);
+	spin_lock(&lock);
+	if (likely(idle >= max_idle[cpu]))
+		max_idle[cpu] = idle;
+	else
+		idle = max_idle[cpu];
+	spin_unlock(&lock);
+#endif
+	return idle;
+}
+
 #ifdef arch_idle_time
 
 static cputime64_t get_idle_time(int cpu)
@@ -28,7 +62,7 @@ static cputime64_t get_idle_time(int cpu)
 	idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
 	if (cpu_online(cpu) && !nr_iowait_cpu(cpu))
 		idle += arch_idle_time(cpu);
-	return idle;
+	return validate_idle(idle, cpu);
 }
 
 static cputime64_t get_iowait_time(int cpu)
@@ -38,7 +72,7 @@ static cputime64_t get_iowait_time(int cpu)
 	iowait = kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
 	if (cpu_online(cpu) && nr_iowait_cpu(cpu))
 		iowait += arch_idle_time(cpu);
-	return iowait;
+	return validate_iowait(iowait, cpu);
 }
 
 #else
@@ -56,7 +90,7 @@ static u64 get_idle_time(int cpu)
 	else
 		idle = usecs_to_cputime64(idle_time);
 
-	return idle;
+	return validate_idle(idle, cpu);
 }
 
 static u64 get_iowait_time(int cpu)
@@ -72,7 +106,7 @@ static u64 get_iowait_time(int cpu)
 	else
 		iowait = usecs_to_cputime64(iowait_time);
 
-	return iowait;
+	return validate_iowait(iowait, cpu);
 }
 
 #endif
-- 
1.7.1
