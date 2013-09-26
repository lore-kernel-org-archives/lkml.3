Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab3IZDAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 23:00:04 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56717 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab3IZDAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 23:00:02 -0400
X-Nat-Received: from [202.181.97.72]:63438 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1380164392.31143
To: rientjes@google.com
Cc: akpm@linux-foundation.org, oleg@redhat.com, security@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] kthread: Make kthread_create() killable.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20130915163919.GC13344@redhat.com>
	<201309160953.IGI12418.FOQHOFVJLOMFSt@I-love.SAKURA.ne.jp>
	<20130923160725.49093c565dcf6df7037dcc6b@linux-foundation.org>
	<201309250017.HBG57846.VFOStOFFOLQJHM@I-love.SAKURA.ne.jp>
	<alpine.DEB.2.02.1309251351001.27471@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1309251351001.27471@chino.kir.corp.google.com>
Message-Id: <201309261159.BHB18780.OHLFQFMOOJSVtF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 26 Sep 2013 11:59:50 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 26092013 #11069216, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for comments, David.

David Rientjes wrote:
> Also results in a livelock if you're running in a memcg and have hit its
> limit.

> wait_for_completion() is scary if that completion requires memory that 
> cannot be allocated because the caller is killed but uninterruptible.

I don't think these lines are specific to wait_for_completion() users.

Currently the OOM killer is disabled throughout from "the moment the OOM killer
chose a process to kill" to "the moment the task_struct of the chosen process
becomes unreachable". Any blocking functions which wait in TASK_UNINTERRUPTIBLE
(e.g. mutex_lock()) can disable the OOM killer if the current thread is chosen
by the OOM killer. Therefore, any users of blocking functions which wait in
TASK_UNINTERRUPTIBLE are considered scary if they assume that the current
thread will not be chosen by the OOM killer.

But it seems to me that re-enabling the OOM killer at some point is more
realizable than purging all such users.

To re-enable the OOM killer at some point, the OOM killer needs to choose more
processes if the to-be-killed process cannot be terminated within an adequate
period.

For example, add "unsigned long memdie_stamp;" to "struct task_struct" and do
"p->memdie_stamp = jiffies + 5 * HZ;" before "set_tsk_thread_flag(p, TIF_MEMDIE);"
and do

 	if (test_tsk_thread_flag(task, TIF_MEMDIE)) {
 		if (unlikely(frozen(task)))
 			__thaw_task(task);
+		/* Choose more processes if the chosen process cannot die. */
+		if (time_after(jiffies, p->memdie_stamp) &&
+		    task->state == TASK_UNINTERRUPTIBLE)
+		        return OOM_SCAN_CONTINUE;
 		if (!force_kill)
 			return OOM_SCAN_ABORT;
 	}

in oom_scan_process_thread().

This idea costs us the increment of the possibility of different side effects
(e.g. the second-worst process is chosen by the OOM killer when the worst
process cannot be terminated => memory allocation for writeback fails because
the second-worst process was in the ext3's writeback path => fs-error action
(remount read-only or panic) gets triggered by the second-worst process).



Anyway, this patch is for helping the OOM killer to kill the process smoothly
when the chosen process is waiting at kthread_create(). I attach updated patch
description. Did I merge your comments appropriately?
----------
[PATCH v3] kthread: Make kthread_create() killable.

Any user process callers of wait_for_completion() except global init process
might be chosen by the OOM killer while waiting for completion() call by some
other process which does memory allocation.

When such users are chosen by the OOM killer when they are waiting for
completion() in TASK_UNINTERRUPTIBLE, the system will be kept stressed
due to memory starvation because the OOM killer cannot kill such users.

kthread_create() is one of such users and this patch fixes the problem for
kthreadd by making kthread_create() killable.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
