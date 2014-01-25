Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaAYO3d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 09:29:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52402 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaAYOXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 09:23:33 -0500
Date: Sat, 25 Jan 2014 06:22:56 -0800
From: tip-bot for Kevin Hilman <tipbot@zytor.com>
Message-ID: <tip-8fe8ff09ce3b5750e1f3e45a1f4a81d59c7ff1f1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, john.stultz@linaro.org, alex.shi@linaro.org,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, khilman@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, john.stultz@linaro.org, alex.shi@linaro.org,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
        khilman@linaro.org, tglx@linutronix.de
In-Reply-To: <1387315388-31676-2-git-send-email-khilman@linaro.org>
References: <1387315388-31676-2-git-send-email-khilman@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] sched/nohz:
  Fix overflow error in scheduler_tick_max_deferment()
Git-Commit-ID: 8fe8ff09ce3b5750e1f3e45a1f4a81d59c7ff1f1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 25 Jan 2014 06:23:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8fe8ff09ce3b5750e1f3e45a1f4a81d59c7ff1f1
Gitweb:     http://git.kernel.org/tip/8fe8ff09ce3b5750e1f3e45a1f4a81d59c7ff1f1
Author:     Kevin Hilman <khilman@linaro.org>
AuthorDate: Wed, 15 Jan 2014 14:51:38 +0100
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Thu, 16 Jan 2014 00:08:12 +0100

sched/nohz: Fix overflow error in scheduler_tick_max_deferment()

While calculating the scheduler tick max deferment, the delta is
converted from microseconds to nanoseconds through a multiplication
against NSEC_PER_USEC.

But this microseconds operand is an unsigned int, thus the result may
likely overflow. The result is cast to u64 but only once the operation
is completed, which is too late to avoid overflown result.

This is currently not a problem because the scheduler tick max deferment
is 1 second. But this may become an issue as we plan to make this
value tunable.

So lets fix this by casting the usecs value to u64 before multiplying by
NSECS_PER_USEC.

Also to prevent from this kind of mistake to happen again, move this
ad-hoc jiffies -> nsecs conversion to a new helper.

Signed-off-by: Kevin Hilman <khilman@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alex Shi <alex.shi@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Kevin Hilman <khilman@linaro.org>
Link: http://lkml.kernel.org/r/1387315388-31676-2-git-send-email-khilman@linaro.org
[move ad-hoc conversion to jiffies_to_nsecs helper]
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/jiffies.h | 6 ++++++
 kernel/sched/core.c     | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index d235e88..1f44466 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -294,6 +294,12 @@ extern unsigned long preset_lpj;
  */
 extern unsigned int jiffies_to_msecs(const unsigned long j);
 extern unsigned int jiffies_to_usecs(const unsigned long j);
+
+static inline u64 jiffies_to_nsecs(const unsigned long j)
+{
+	return (u64)jiffies_to_usecs(j) * NSEC_PER_USEC;
+}
+
 extern unsigned long msecs_to_jiffies(const unsigned int m);
 extern unsigned long usecs_to_jiffies(const unsigned int u);
 extern unsigned long timespec_to_jiffies(const struct timespec *value);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a88f4a4..61e601f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2325,7 +2325,7 @@ u64 scheduler_tick_max_deferment(void)
 	if (time_before_eq(next, now))
 		return 0;
 
-	return jiffies_to_usecs(next - now) * NSEC_PER_USEC;
+	return jiffies_to_nsecs(next - now);
 }
 #endif
 
