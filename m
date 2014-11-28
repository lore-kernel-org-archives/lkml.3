Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270AbaK1SYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:24:14 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:36117 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbaK1SYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:11 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC PATCH 02/30] time: Introduce jiffies64_to_nsecs()
Date: Fri, 28 Nov 2014 19:23:32 +0100
Message-Id: <1417199040-21044-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will be needed for the cputime_t to nsec conversion.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/jiffies.h  |  2 ++
 kernel/time/time.c       | 10 ++++++++++
 kernel/time/timeconst.bc |  6 ++++++
 3 files changed, 18 insertions(+)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index c367cbd..1161e5c 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -288,6 +288,8 @@ static inline u64 jiffies_to_nsecs(const unsigned long j)
 	return (u64)jiffies_to_usecs(j) * NSEC_PER_USEC;
 }
 
+extern u64 jiffies64_to_nsecs(u64 j);
+
 extern unsigned long msecs_to_jiffies(const unsigned int m);
 extern unsigned long usecs_to_jiffies(const unsigned int u);
 extern unsigned long timespec_to_jiffies(const struct timespec *value);
diff --git a/kernel/time/time.c b/kernel/time/time.c
index e44f6f1..0fe3490 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -715,6 +715,16 @@ u64 nsec_to_clock_t(u64 x)
 #endif
 }
 
+u64 jiffies64_to_nsecs(u64 j)
+{
+#if !(NSEC_PER_SEC % HZ)
+	return (NSEC_PER_SEC / HZ) * j;
+# else
+	return div_u64(j * HZ_TO_NSEC_NUM, HZ_TO_NSEC_DEN);
+#endif
+}
+EXPORT_SYMBOL(jiffies64_to_nsecs);
+
 /**
  * nsecs_to_jiffies64 - Convert nsecs in u64 to jiffies64
  *
diff --git a/kernel/time/timeconst.bc b/kernel/time/timeconst.bc
index 511bdf2..a0ab148 100644
--- a/kernel/time/timeconst.bc
+++ b/kernel/time/timeconst.bc
@@ -98,6 +98,12 @@ define timeconst(hz) {
 		print "#define HZ_TO_USEC_DEN\t\t", hz/cd, "\n"
 		print "#define USEC_TO_HZ_NUM\t\t", hz/cd, "\n"
 		print "#define USEC_TO_HZ_DEN\t\t", 1000000/cd, "\n"
+
+		cd=gcd(hz,1000000000)
+		print "#define HZ_TO_NSEC_NUM\t\t", 1000000000/cd, "\n"
+		print "#define HZ_TO_NSEC_DEN\t\t", hz/cd, "\n"
+		print "#define NSEC_TO_HZ_NUM\t\t", hz/cd, "\n"
+		print "#define NSEC_TO_HZ_DEN\t\t", 1000000000/cd, "\n"
 		print "\n"
 
 		print "#endif /* KERNEL_TIMECONST_H */\n"
-- 
2.1.3

