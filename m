Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340AbaK1SYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:24:21 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:35051 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaK1SYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:15 -0500
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
Subject: [RFC PATCH 04/30] s390: Convert open coded idle time seqcount
Date: Fri, 28 Nov 2014 19:23:34 +0100
Message-Id: <1417199040-21044-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s390 uses open coded seqcount to synchronize idle time accounting.
Lets consolidate it with the standard API.

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
 arch/s390/include/asm/idle.h |  3 ++-
 arch/s390/kernel/idle.c      | 28 +++++++++++++++-------------
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/s390/include/asm/idle.h b/arch/s390/include/asm/idle.h
index 6af037f..113cd96 100644
--- a/arch/s390/include/asm/idle.h
+++ b/arch/s390/include/asm/idle.h
@@ -9,9 +9,10 @@
 
 #include <linux/types.h>
 #include <linux/device.h>
+#include <linux/seqlock.h>
 
 struct s390_idle_data {
-	unsigned int sequence;
+	seqcount_t seqcount;
 	unsigned long long idle_count;
 	unsigned long long idle_time;
 	unsigned long long clock_idle_enter;
diff --git a/arch/s390/kernel/idle.c b/arch/s390/kernel/idle.c
index 7559f1b..9b75577 100644
--- a/arch/s390/kernel/idle.c
+++ b/arch/s390/kernel/idle.c
@@ -36,15 +36,13 @@ void __kprobes enabled_wait(void)
 	psw_idle(idle, psw_mask);
 
 	/* Account time spent with enabled wait psw loaded as idle time. */
-	idle->sequence++;
-	smp_wmb();
+	write_seqcount_begin(&idle->seqcount);
 	idle_time = idle->clock_idle_exit - idle->clock_idle_enter;
 	idle->clock_idle_enter = idle->clock_idle_exit = 0ULL;
 	idle->idle_time += idle_time;
 	idle->idle_count++;
 	account_idle_time(idle_time);
-	smp_wmb();
-	idle->sequence++;
+	write_seqcount_end(&idle->seqcount);
 }
 
 static ssize_t show_idle_count(struct device *dev,
@@ -52,14 +50,15 @@ static ssize_t show_idle_count(struct device *dev,
 {
 	struct s390_idle_data *idle = &per_cpu(s390_idle, dev->id);
 	unsigned long long idle_count;
-	unsigned int sequence;
+	unsigned int seq;
 
 	do {
-		sequence = ACCESS_ONCE(idle->sequence);
+		seq = read_seqcount_begin(&idle->seqcount);
 		idle_count = ACCESS_ONCE(idle->idle_count);
 		if (ACCESS_ONCE(idle->clock_idle_enter))
 			idle_count++;
-	} while ((sequence & 1) || (ACCESS_ONCE(idle->sequence) != sequence));
+	} while (read_seqcount_retry(&idle->seqcount, seq));
+
 	return sprintf(buf, "%llu\n", idle_count);
 }
 DEVICE_ATTR(idle_count, 0444, show_idle_count, NULL);
@@ -69,16 +68,18 @@ static ssize_t show_idle_time(struct device *dev,
 {
 	struct s390_idle_data *idle = &per_cpu(s390_idle, dev->id);
 	unsigned long long now, idle_time, idle_enter, idle_exit;
-	unsigned int sequence;
+	unsigned int seq;
 
 	do {
 		now = get_tod_clock();
-		sequence = ACCESS_ONCE(idle->sequence);
+		seq = read_seqcount_begin(&idle->seqcount);
 		idle_time = ACCESS_ONCE(idle->idle_time);
 		idle_enter = ACCESS_ONCE(idle->clock_idle_enter);
 		idle_exit = ACCESS_ONCE(idle->clock_idle_exit);
-	} while ((sequence & 1) || (ACCESS_ONCE(idle->sequence) != sequence));
+	} while (read_seqcount_retry(&idle->seqcount, seq));
+
 	idle_time += idle_enter ? ((idle_exit ? : now) - idle_enter) : 0;
+
 	return sprintf(buf, "%llu\n", idle_time >> 12);
 }
 DEVICE_ATTR(idle_time_us, 0444, show_idle_time, NULL);
@@ -87,14 +88,15 @@ cputime64_t arch_cpu_idle_time(int cpu)
 {
 	struct s390_idle_data *idle = &per_cpu(s390_idle, cpu);
 	unsigned long long now, idle_enter, idle_exit;
-	unsigned int sequence;
+	unsigned int seq;
 
 	do {
 		now = get_tod_clock();
-		sequence = ACCESS_ONCE(idle->sequence);
+		seq = read_seqcount_begin(&idle->seqcount);
 		idle_enter = ACCESS_ONCE(idle->clock_idle_enter);
 		idle_exit = ACCESS_ONCE(idle->clock_idle_exit);
-	} while ((sequence & 1) || (ACCESS_ONCE(idle->sequence) != sequence));
+	} while (read_seqcount_retry(&idle->seqcount, seq));
+
 	return idle_enter ? ((idle_exit ?: now) - idle_enter) : 0;
 }
 
-- 
2.1.3

