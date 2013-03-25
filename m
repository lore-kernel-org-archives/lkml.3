Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab3CYBQN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:16:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34020 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756066Ab3CYBQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:04 -0400
Message-Id: <20130325010530.023505840@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:22 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: [ 058/104] tracing: Fix free of probe entry by calling call_rcu_sched()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 740466bc89ad8bd5afcc8de220f715f62b21e365 upstream.

Because function tracing is very invasive, and can even trace
calls to rcu_read_lock(), RCU access in function tracing is done
with preempt_disable_notrace(). This requires a synchronize_sched()
for updates and not a synchronize_rcu().

Function probes (traceon, traceoff, etc) must be freed after
a synchronize_sched() after its entry has been removed from the
hash. But call_rcu() is used. Fix this by using call_rcu_sched().

Also fix the usage to use hlist_del_rcu() instead of hlist_del().

Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/ftrace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2725,8 +2725,8 @@ __unregister_ftrace_function_probe(char
 					continue;
 			}
 
-			hlist_del(&entry->node);
-			call_rcu(&entry->rcu, ftrace_free_entry_rcu);
+			hlist_del_rcu(&entry->node);
+			call_rcu_sched(&entry->rcu, ftrace_free_entry_rcu);
 		}
 	}
 	__disable_ftrace_function_probe();


