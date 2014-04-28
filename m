Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473AbaD1X4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:56:46 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:39525 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbaD1X4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:56:41 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/19] rcu: Print negatives for stall-warning counter wraparound
Date: Mon, 28 Apr 2014 16:56:16 -0700
Message-Id: <1398729392-15087-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140428235600.GA12200@linux.vnet.ibm.com>
 <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042823-9332-0000-0000-000000A23C7A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The print_other_cpu_stall() and print_cpu_stall() functions print
grace-period numbers using an unsigned format, which means that the number
one less than zero is a very large number.  This commit therefore causes
these numbers to be printed with a signed format in order to improve
readability of the RCU CPU stall-warning output.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 2c53ac924cab..b33c29a99df3 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -932,9 +932,9 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	print_cpu_stall_info_end();
 	for_each_possible_cpu(cpu)
 		totqlen += per_cpu_ptr(rsp->rda, cpu)->qlen;
-	pr_cont("(detected by %d, t=%ld jiffies, g=%lu, c=%lu, q=%lu)\n",
+	pr_cont("(detected by %d, t=%ld jiffies, g=%ld, c=%ld, q=%lu)\n",
 	       smp_processor_id(), (long)(jiffies - rsp->gp_start),
-	       rsp->gpnum, rsp->completed, totqlen);
+	       (long)rsp->gpnum, (long)rsp->completed, totqlen);
 	if (ndetected == 0)
 		pr_err("INFO: Stall ended before state dump start\n");
 	else if (!trigger_all_cpu_backtrace())
@@ -971,8 +971,9 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	print_cpu_stall_info_end();
 	for_each_possible_cpu(cpu)
 		totqlen += per_cpu_ptr(rsp->rda, cpu)->qlen;
-	pr_cont(" (t=%lu jiffies g=%lu c=%lu q=%lu)\n",
-		jiffies - rsp->gp_start, rsp->gpnum, rsp->completed, totqlen);
+	pr_cont(" (t=%lu jiffies g=%ld c=%ld q=%lu)\n",
+		jiffies - rsp->gp_start,
+		(long)rsp->gpnum, (long)rsp->completed, totqlen);
 	if (!trigger_all_cpu_backtrace())
 		dump_stack();
 
-- 
1.8.1.5

