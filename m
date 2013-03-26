Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab3CZXkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:40:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab3CZWoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: [ 39/98] tracing: Fix free of probe entry by calling call_rcu_sched()
Date: Tue, 26 Mar 2013 15:42:28 -0700
Message-Id: <20130326224246.528206396@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ftrace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3082,8 +3082,8 @@ __unregister_ftrace_function_probe(char
 					continue;
 			}
 
-			hlist_del(&entry->node);
-			call_rcu(&entry->rcu, ftrace_free_entry_rcu);
+			hlist_del_rcu(&entry->node);
+			call_rcu_sched(&entry->rcu, ftrace_free_entry_rcu);
 		}
 	}
 	__disable_ftrace_function_probe();


