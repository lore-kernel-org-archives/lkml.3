Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934884Ab3CZPtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:49:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53842 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965092Ab3CZPWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 071/150] tracing: Fix free of probe entry by calling call_rcu_sched()
Date: Tue, 26 Mar 2013 15:19:30 +0000
Message-Id: <1364311249-14454-72-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/ftrace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e5a77ba..1b6ec54 100644
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
1.8.1.2

