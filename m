Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbaFSPwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:52:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757301AbaFSPwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:52:14 -0400
Date: Thu, 19 Jun 2014 17:51:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
        LKML <linux-kernel@vger.kernel.org>,
        Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org
Subject: Re: [trace:ftrace/core 1/3] include/trace/syscall.h:39:6: error:
	'TIF_SYSCALL_TRACEPOINT' undeclared
Message-ID: <20140619155108.GA15883@redhat.com>
References: <53a1e7ba.ZIiv6DbOB78b9RzY%fengguang.wu@intel.com> <20140618211559.76bdea15@gandalf.local.home> <20140618211737.719fcf49@gandalf.local.home> <20140618213833.731d5fc4@gandalf.local.home> <20140619150300.GA7215@redhat.com> <20140619112635.41412408@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619112635.41412408@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19, Steven Rostedt wrote:
>
> On Thu, 19 Jun 2014 17:03:00 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Argh... but it seems that that patch really needs a fix?
> >
> > 	- #ifdef CONFIG_TRACEPOINTS
> > 	+ #ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
> >
> > or even
> > 	- #ifdef CONFIG_TRACEPOINTS
> > 	+ #if defined(CONFIG_TRACEPOINTS) && defined(CONFIG_HAVE_SYSCALL_TRACEPOINTS)
> >
> > or I am totally confused?
>
> I think the second one is needed.

Agreed... see the updated patch below.

Please tell me if I should another "[PATCH]" email or resend 2-3 as well.
Sorry for inconvenience.

-------------------------------------------------------------------------------
Subject: [PATCH] tracing: Fix syscall_*regfunc() vs copy_process() race

syscall_regfunc() and syscall_unregfunc() should set/clear
TIF_SYSCALL_TRACEPOINT system-wide, but do_each_thread() can race
with copy_process() and miss the new child which was not added to
the process/thread lists yet.

Change copy_process() to update the child's TIF_SYSCALL_TRACEPOINT
under tasklist.

Link: http://lkml.kernel.org/p/20140413185854.GB20668@redhat.com

Cc: stable@vger.kernel.org # 2.6.33
Fixes: a871bd33a6c0 "tracing: Add syscall tracepoints"
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/trace/syscall.h |   15 +++++++++++++++
 kernel/fork.c           |    2 ++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index fed853f..9674145 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -4,6 +4,7 @@
 #include <linux/tracepoint.h>
 #include <linux/unistd.h>
 #include <linux/ftrace_event.h>
+#include <linux/thread_info.h>
 
 #include <asm/ptrace.h>
 
@@ -32,4 +33,18 @@ struct syscall_metadata {
 	struct ftrace_event_call *exit_event;
 };
 
+#if defined(CONFIG_TRACEPOINTS) && defined(CONFIG_HAVE_SYSCALL_TRACEPOINTS)
+static inline void syscall_tracepoint_update(struct task_struct *p)
+{
+	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
+		set_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
+	else
+		clear_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
+}
+#else
+static inline void syscall_tracepoint_update(struct task_struct *p)
+{
+}
+#endif
+
 #endif /* _TRACE_SYSCALL_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index cafea61..f7417f5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1485,7 +1485,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	total_forks++;
 	spin_unlock(&current->sighand->siglock);
+	syscall_tracepoint_update(p);
 	write_unlock_irq(&tasklist_lock);
+
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
 	if (clone_flags & CLONE_THREAD)
-- 
1.5.5.1


