Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbaBEVDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:03:15 -0500
Received: from mail.windriver.com ([147.11.1.11]:54594 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbaBEUFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:08 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>,
        Tom Herbert <therbert@google.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 056/213] softirq: reduce latencies
Date: Wed, 5 Feb 2014 15:00:11 -0500
Message-ID: <1391630568-49251-57-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit c10d73671ad30f54692f7f69f0e09e75d3a8926a upstream.

In various network workloads, __do_softirq() latencies can be up
to 20 ms if HZ=1000, and 200 ms if HZ=100.

This is because we iterate 10 times in the softirq dispatcher,
and some actions can consume a lot of cycles.

This patch changes the fallback to ksoftirqd condition to :

- A time limit of 2 ms.
- need_resched() being set on current task

When one of this condition is met, we wakeup ksoftirqd for further
softirq processing if we still have pending softirqs.

Using need_resched() as the only condition can trigger RCU stalls,
as we can keep BH disabled for too long.

I ran several benchmarks and got no significant difference in
throughput, but a very significant reduction of latencies (one order
of magnitude) :

In following bench, 200 antagonist "netperf -t TCP_RR" are started in
background, using all available cpus.

Then we start one "netperf -t TCP_RR", bound to the cpu handling the NIC
IRQ (hard+soft)

Before patch :

# netperf -H 7.7.7.84 -t TCP_RR -T2,2 -- -k
RT_LATENCY,MIN_LATENCY,MAX_LATENCY,P50_LATENCY,P90_LATENCY,P99_LATENCY,MEAN_LATENCY,STDDEV_LATENCY
MIGRATED TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET
to 7.7.7.84 () port 0 AF_INET : first burst 0 : cpu bind
RT_LATENCY=550110.424
MIN_LATENCY=146858
MAX_LATENCY=997109
P50_LATENCY=305000
P90_LATENCY=550000
P99_LATENCY=710000
MEAN_LATENCY=376989.12
STDDEV_LATENCY=184046.92

After patch :

# netperf -H 7.7.7.84 -t TCP_RR -T2,2 -- -k
RT_LATENCY,MIN_LATENCY,MAX_LATENCY,P50_LATENCY,P90_LATENCY,P99_LATENCY,MEAN_LATENCY,STDDEV_LATENCY
MIGRATED TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET
to 7.7.7.84 () port 0 AF_INET : first burst 0 : cpu bind
RT_LATENCY=40545.492
MIN_LATENCY=9834
MAX_LATENCY=78366
P50_LATENCY=33583
P90_LATENCY=59000
P99_LATENCY=69000
MEAN_LATENCY=38364.67
STDDEV_LATENCY=12865.26

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: David Miller <davem@davemloft.net>
Cc: Tom Herbert <therbert@google.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/softirq.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 7c1a67ef0274..0df9a9406271 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -178,21 +178,21 @@ void local_bh_enable_ip(unsigned long ip)
 EXPORT_SYMBOL(local_bh_enable_ip);
 
 /*
- * We restart softirq processing MAX_SOFTIRQ_RESTART times,
- * and we fall back to softirqd after that.
+ * We restart softirq processing for at most 2 ms,
+ * and if need_resched() is not set.
  *
- * This number has been established via experimentation.
+ * These limits have been established via experimentation.
  * The two things to balance is latency against fairness -
  * we want to handle softirqs as soon as possible, but they
  * should not be able to lock up the box.
  */
-#define MAX_SOFTIRQ_RESTART 10
+#define MAX_SOFTIRQ_TIME  msecs_to_jiffies(2)
 
 asmlinkage void __do_softirq(void)
 {
 	struct softirq_action *h;
 	__u32 pending;
-	int max_restart = MAX_SOFTIRQ_RESTART;
+	unsigned long end = jiffies + MAX_SOFTIRQ_TIME;
 	int cpu;
 
 	pending = local_softirq_pending();
@@ -236,11 +236,12 @@ restart:
 	local_irq_disable();
 
 	pending = local_softirq_pending();
-	if (pending && --max_restart)
-		goto restart;
+	if (pending) {
+		if (time_before(jiffies, end) && !need_resched())
+			goto restart;
 
-	if (pending)
 		wakeup_softirqd();
+	}
 
 	lockdep_softirq_exit();
 
-- 
1.8.5.2

