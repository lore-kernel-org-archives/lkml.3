Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbaD2ACf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:02:35 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:55895 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbaD1X4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:56:42 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        Andreea-Cristina Bernat <bernat.ada@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 10/19] rcu: Add event tracing to dyntick_save_progress_counter().
Date: Mon, 28 Apr 2014 16:56:23 -0700
Message-Id: <1398729392-15087-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140428235600.GA12200@linux.vnet.ibm.com>
 <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042823-7164-0000-0000-0000015FB4FF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreea-Cristina Bernat <bernat.ada@gmail.com>

This patch adds event tracing to dyntick_save_progress_counter() in the case
where it returns 1. I used the tracepoint string "dti" because this function
returns 1 in case the CPU is in dynticks idle mode.

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index fca911b6b29c..c6fd0f15425c 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -772,7 +772,12 @@ static int dyntick_save_progress_counter(struct rcu_data *rdp,
 {
 	rdp->dynticks_snap = atomic_add_return(0, &rdp->dynticks->dynticks);
 	rcu_sysidle_check_cpu(rdp, isidle, maxj);
-	return (rdp->dynticks_snap & 0x1) == 0;
+	if ((rdp->dynticks_snap & 0x1) == 0) {
+		trace_rcu_fqs(rdp->rsp->name, rdp->gpnum, rdp->cpu, TPS("dti"));
+		return 1;
+	} else {
+		return 0;
+	}
 }
 
 /*
-- 
1.8.1.5

