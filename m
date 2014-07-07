Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaGGWYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:24:37 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49503 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaGGWYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:24:36 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/4] documentation: Clarify wake-up/memory-barrier relationship
Date: Mon,  7 Jul 2014 15:24:19 -0700
Message-Id: <1404771862-6904-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20140707222345.GA6320@linux.vnet.ibm.com>
References: <20140707222345.GA6320@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-9332-0000-0000-0000014D6CB7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds an example demonstrating that if a wake_up() doesn't
actually wake something up, no memory ordering is provided.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/memory-barriers.txt | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index f1dc4a215593..a6ca533a73fc 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -1893,6 +1893,21 @@ between the STORE to indicate the event and the STORE to set TASK_RUNNING:
 	    <general barrier>		  STORE current->state
 	LOAD event_indicated
 
+To repeat, this write memory barrier is present if and only if something
+is actually awakened.  To see this, consider the following sequence of
+events, where X and Y are both initially zero:
+
+	CPU 1				CPU 2
+	===============================	===============================
+	X = 1;				STORE event_indicated
+	smp_mb();			wake_up();
+	Y = 1;				wait_event(wq, Y == 1);
+	wake_up();			  load from Y sees 1, no memory barrier
+					load from X might see 0
+
+In contrast, if a wakeup does occur, CPU 2's load from X would be guaranteed
+to see 1.
+
 The available waker functions include:
 
 	complete();
-- 
1.8.1.5

