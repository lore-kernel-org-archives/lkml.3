Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbaJ1WES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:04:18 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:53135 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbaJ1WER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:04:17 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/5] documentation: Additional restriction for control dependencies
Date: Tue, 28 Oct 2014 15:00:15 -0700
Message-Id: <1414533617-25933-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414533617-25933-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028215937.GA25095@linux.vnet.ibm.com>
 <1414533617-25933-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0025-0000-0000-000000F0501D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Short-circuit booleans are not defences against compilers breaking
your intended control dependencies.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/memory-barriers.txt | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index d6bc77eb179a..8ebb66128cc8 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -725,6 +725,24 @@ Please note once again that the stores to 'b' differ.  If they were
 identical, as noted earlier, the compiler could pull this store outside
 of the 'if' statement.
 
+You must also be careful not to rely too much on boolean short-circuit
+evaluation.  Consider this example:
+
+	q = ACCESS_ONCE(a);
+	if (a || 1 > 0)
+		ACCESS_ONCE(b) = 1;
+
+Because the second condition is always true, the compiler can transform
+this example as following, defeating control dependency:
+
+	q = ACCESS_ONCE(a);
+	ACCESS_ONCE(b) = 1;
+
+This example underscores the need to ensure that the compiler cannot
+out-guess your code.  More generally, although ACCESS_ONCE() does force
+the compiler to actually emit code for a given load, it does not force
+the compiler to use the results.
+
 Finally, control dependencies do -not- provide transitivity.  This is
 demonstrated by two related examples, with the initial values of
 x and y both being zero:
-- 
1.8.1.5

