Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbaG2XjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:39:25 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:59615 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbaG2XjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:39:23 -0400
Date: Tue, 29 Jul 2014 16:39:20 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [patch] mm, oom: remove unnecessary exit_state check
Message-ID: <alpine.DEB.2.02.1407291638310.858@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The oom killer scans each process and determines whether it is eligible for oom 
kill or whether the oom killer should abort because of concurrent memory 
freeing.  It will abort when an eligible process is found to have TIF_MEMDIE 
set, meaning it has already been oom killed and we're waiting for it to exit.

Processes with task->mm == NULL should not be considered because they are either 
kthreads or have already detached their memory and killing them would not lead 
to memory freeing.  That memory is only freed after exit_mm() has returned, 
however, and not when task->mm is first set to NULL.

Clear TIF_MEMDIE after exit_mm()'s mmput() so that an oom killed process is no 
longer considered for oom kill, but only until exit_mm() has returned.  This was 
fragile in the past because it relied on exit_notify() to be reached before no 
longer considering TIF_MEMDIE processes.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 kernel/exit.c | 1 +
 mm/oom_kill.c | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -455,6 +455,7 @@ static void exit_mm(struct task_struct * tsk)
 	task_unlock(tsk);
 	mm_update_next_owner(mm);
 	mmput(mm);
+	clear_thread_flag(TIF_MEMDIE);
 }
 
 /*
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -258,8 +258,6 @@ enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
 		unsigned long totalpages, const nodemask_t *nodemask,
 		bool force_kill)
 {
-	if (task->exit_state)
-		return OOM_SCAN_CONTINUE;
 	if (oom_unkillable_task(task, NULL, nodemask))
 		return OOM_SCAN_CONTINUE;
 
