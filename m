Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934886Ab3DKUfP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:35:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5168 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748Ab3DKU0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:11 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=dW28dkJG3RcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=cAuAz9kGQ5cA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202552.061647157@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: [ 036/171 ] tracing: Fix free of probe entry by calling call_rcu_sched()
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0036-tracing-Fix-free-of-probe-entry-by-calling-call_rcu_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

[ Upstream commit 740466bc89ad8bd5afcc8de220f715f62b21e365 ]

Because function tracing is very invasive, and can even trace
calls to rcu_read_lock(), RCU access in function tracing is done
with preempt_disable_notrace(). This requires a synchronize_sched()
for updates and not a synchronize_rcu().

Function probes (traceon, traceoff, etc) must be freed after
a synchronize_sched() after its entry has been removed from the
hash. But call_rcu() is used. Fix this by using call_rcu_sched().

Also fix the usage to use hlist_del_rcu() instead of hlist_del().

Cc: stable@vger.kernel.org
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 781ecc2..c27095d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3002,8 +3002,8 @@ __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 					continue;
 			}
 
-			hlist_del(&entry->node);
-			call_rcu(&entry->rcu, ftrace_free_entry_rcu);
+			hlist_del_rcu(&entry->node);
+			call_rcu_sched(&entry->rcu, ftrace_free_entry_rcu);
 		}
 	}
 	__disable_ftrace_function_probe();
-- 
1.7.10.4


