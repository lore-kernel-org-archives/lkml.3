Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaL2Mch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 07:32:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbaL2Mcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 07:32:32 -0500
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Oleg Nesterov <oleg@redhat.com>, <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] oom: Don't count on mm-less current process.
Date: Mon, 29 Dec 2014 13:32:06 +0100
Message-Id: <1419856327-673-2-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1419856327-673-1-git-send-email-mhocko@suse.cz>
References: <1419856327-673-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

out_of_memory() doesn't trigger the OOM killer if the current task is already
exiting or it has fatal signals pending, and gives the task access to memory
reserves instead. However, doing so is wrong if out_of_memory() is called by
an allocation (e.g. from exit_task_work()) after the current task has already
released its memory and cleared TIF_MEMDIE at exit_mm(). If we again set
TIF_MEMDIE to post-exit_mm() current task, the OOM killer will be blocked by
the task sitting in the final schedule() waiting for its parent to reap it.
It will trigger an OOM livelock if its parent is unable to reap it due to
doing an allocation and waiting for the OOM killer to kill it.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/oom_kill.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index d503e9ce1c7b..f82dd13cca68 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -643,8 +643,12 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 	 * If current has a pending SIGKILL or is exiting, then automatically
 	 * select it.  The goal is to allow it to allocate so that it may
 	 * quickly exit and free its memory.
+	 *
+	 * But don't select if current has already released its mm and cleared
+	 * TIF_MEMDIE flag at exit_mm(), otherwise an OOM livelock may occur.
 	 */
-	if (fatal_signal_pending(current) || task_will_free_mem(current)) {
+	if (current->mm &&
+	    (fatal_signal_pending(current) || task_will_free_mem(current))) {
 		set_thread_flag(TIF_MEMDIE);
 		return;
 	}
-- 
2.1.4

