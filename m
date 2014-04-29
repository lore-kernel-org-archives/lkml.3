Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543AbaD2AbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:31:00 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:52578 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933071AbaD2AZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:50 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 19/45] rcutorture: Print negatives for SRCU counter wraparound
Date: Mon, 28 Apr 2014 17:25:07 -0700
Message-Id: <1398731133-18925-19-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-1344-0000-0000-00000134E8AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The srcu_torture_stats() function prints SRCU's per-CPU c[] array with
an unsigned format, which means that the number one less than zero is
a very large number.  This commit therefore prints this array with a
signed format in order to improve readability of the rcutorture output.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/rcutorture.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 3845ea99ccd4..0141fcff6bb9 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -486,15 +486,16 @@ static void srcu_torture_barrier(void)
 
 static void srcu_torture_stats(char *page)
 {
+	long c0, c1;
 	int cpu;
 	int idx = srcu_ctl.completed & 0x1;
 
 	page += sprintf(page, "%s%s per-CPU(idx=%d):",
 		       torture_type, TORTURE_FLAG, idx);
 	for_each_possible_cpu(cpu) {
-		page += sprintf(page, " %d(%lu,%lu)", cpu,
-			       per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[!idx],
-			       per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[idx]);
+		c0 = (long)per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[!idx];
+		c1 = (long)per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[idx];
+		page += sprintf(page, " %d(%ld,%ld)", cpu, c0, c1);
 	}
 	sprintf(page, "\n");
 }
-- 
1.8.1.5

