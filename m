Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934390Ab3CMXxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:53:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9169 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933336Ab3CMXxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:53:34 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Qh-hwnkWAW8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=NXp5nV4CtKoA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=Lyb6QooEgCay2PGuC7oA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363218811.25967.12.camel@gandalf.local.home>
Subject: [PATCH][GIT PULL][3.9] tracing: Fix free of probe entry by calling
 call_rcu_sched()
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>
Date: Wed, 13 Mar 2013 19:53:31 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

While testing my new code I stumbled upon this bug. This is a real
bug and has been in the kernel forever. Luckily, it's in a feature
that is seldom used. But it can cause a crash if the race is hit.

I based this off of my last pull request of tip/perf/urgent.

Thanks,

-- Steve


Please pull the latest tip/perf/urgent-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent-2

Head SHA1: 740466bc89ad8bd5afcc8de220f715f62b21e365


Steven Rostedt (Red Hat) (1):
      tracing: Fix free of probe entry by calling call_rcu_sched()

----
 kernel/trace/ftrace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
---------------------------
commit 740466bc89ad8bd5afcc8de220f715f62b21e365
Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Date:   Wed Mar 13 11:15:19 2013 -0400

    tracing: Fix free of probe entry by calling call_rcu_sched()
    
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

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 98ca94a..e6effd0 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3108,8 +3108,8 @@ __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 					continue;
 			}
 
-			hlist_del(&entry->node);
-			call_rcu(&entry->rcu, ftrace_free_entry_rcu);
+			hlist_del_rcu(&entry->node);
+			call_rcu_sched(&entry->rcu, ftrace_free_entry_rcu);
 		}
 	}
 	__disable_ftrace_function_probe();


