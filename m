Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaBXT1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:27:47 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:37098 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbaBXT1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:27:46 -0500
Date: Mon, 24 Feb 2014 20:27:34 +0100
From: Guillaume Morin <guillaume@morinfr.org>
To: matt.helsley@gmail.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] exit.c: call proc_exit_connector() after exit_state is set
Message-ID: <20140224192734.GA15573@bender.morinfr.org>
Mail-Followup-To: matt.helsley@gmail.com, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Morin <guillaume@morinfr.org>

The process events connector delivers a notification when a process
exits.  This is really convenient for a process that spawns and wants
to monitor its children through an epoll-able() interface.

Unfortunately, there is a small window between when the event is
delivered and the child become wait()-able.

This is creates a race if the parent wants to make sure that it knows
about the exit, e.g

pid_t pid = fork();
if (pid > 0) {
	register_interest_for_pid(pid);
	if (waitpid(pid, NULL, WNOHANG) > 0)
	{
	  /* We might have raced with exit() */
	}
	return;
}

/* Child */
execve(...)

register_interest_for_pid() would be telling the the connector socket
reader to pay attention to events related to pid.

Though this is not a bug, I think it would make the connector a bit
more usable if this race was closed by simply moving the call to
proc_exit_connector() from just before exit_notify() to right after.

Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
Cc: matt.helsley@gmail.com
---
diff --git a/kernel/exit.c b/kernel/exit.c
index 1e77fc6..9b0ac8c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -804,7 +804,6 @@ void do_exit(long code)
 
 	module_put(task_thread_info(tsk)->exec_domain->module);
 
-	proc_exit_connector(tsk);
 
 	/*
 	 * FIXME: do that only when needed, using sched_exit tracepoint
@@ -812,6 +811,7 @@ void do_exit(long code)
 	flush_ptrace_hw_breakpoint(tsk);
 
 	exit_notify(tsk, group_dead);
+	proc_exit_connector(tsk);
 #ifdef CONFIG_NUMA
 	task_lock(tsk);
 	mpol_put(tsk->mempolicy);



-- 
Guillaume Morin <guillaume@morinfr.org>
