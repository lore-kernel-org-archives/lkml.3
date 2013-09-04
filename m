Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934949Ab3IDOhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:37:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13595 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934886Ab3IDOhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:37:32 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Ak3n_PMYkrAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ijUnBEa8c7kA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=0o7y571fHu_23mVW6bQA:9 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130904143701.445531774@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 04 Sep 2013 10:35:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [for-next][PATCH 07/18] ftrace: Add test for ops against unsafe RCU functions in callback
References: <20130904143552.456506259@goodmis.org>
Content-Disposition: inline; filename=0006-ftrace-Add-test-for-ops-against-unsafe-RCU-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When more than one ftrace_ops is registered, the list function is
used to call all registered functions. It uses the filter and
notrace hashes from the ftrace_ops to determine if the corresponding
callback should be called or not.

Currently, it does not take into account for RCU unsafe functions.
If multiple functions are registered, and an RCU safe callback is
used on a RCU unsafe function, and the RCU unsafe callback says to
trace all functions, it will end up tracing this RCU unsafe function
and still suffer the problems when using RCU when RCU tracing is
off.

Add a test to the multiple ops list function to test if the ops in
question can use an RCU unsafe function or not, and if the function
being traced happens to be an RCU unsafe function.

Cc: Jiri Olsa <jolsa@redhat.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index caeeda24..45822de 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1480,7 +1480,9 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip, void *regs)
 	if ((ftrace_hash_empty(filter_hash) ||
 	     ftrace_lookup_ip(filter_hash, ip)) &&
 	    (ftrace_hash_empty(notrace_hash) ||
-	     !ftrace_lookup_ip(notrace_hash, ip)))
+	     !ftrace_lookup_ip(notrace_hash, ip)) &&
+	    (ops->flags & FTRACE_OPS_FL_RCU_SAFE ||
+	     !ftrace_lookup_ip(ftrace_unsafe_rcu, ip)))
 		ret = 1;
 	else
 		ret = 0;
-- 
1.7.10.4


