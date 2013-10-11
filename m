Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856Ab3JKKnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:43:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58469 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834Ab3JKKm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:42:57 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Qiang Huang <h.huangqiang@huawei.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 030/100] mm, memcg: give exiting processes access to memory reserves
Date: Fri, 11 Oct 2013 11:41:00 +0100
Message-Id: <1381488130-30235-31-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rientjes <rientjes@google.com>

commit 465adcf1ea7b2e49b2e0899366624f5532b64012 upstream.

A memcg may livelock when oom if the process that grabs the hierarchy's
oom lock is never the first process with PF_EXITING set in the memcg's
task iteration.

The oom killer, both global and memcg, will defer if it finds an
eligible process that is in the process of exiting and it is not being
ptraced.  The idea is to allow it to exit without using memory reserves
before needlessly killing another process.

This normally works fine except in the memcg case with a large number of
threads attached to the oom memcg.  In this case, the memcg oom killer
only gets called for the process that grabs the hierarchy's oom lock;
all others end up blocked on the memcg's oom waitqueue.  Thus, if the
process that grabs the hierarchy's oom lock is never the first
PF_EXITING process in the memcg's task iteration, the oom killer is
constantly deferred without anything making progress.

The fix is to give PF_EXITING processes access to memory reserves so
that we've marked them as oom killed without any iteration.  This allows
__mem_cgroup_try_charge() to succeed so that the process may exit.  This
makes the memcg oom killer exemption for TIF_MEMDIE tasks, now
immediately granted for processes with pending SIGKILLs and those in the
exit path, to be equivalent to what is done for the global oom killer.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[Qiang: backported to 3.4:
 - move the changes from memcontrol.c to oom_kill.c]
Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/oom_kill.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index ac300c9..b45c813 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -549,11 +549,11 @@ void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	struct task_struct *p;
 
 	/*
-	 * If current has a pending SIGKILL, then automatically select it.  The
-	 * goal is to allow it to allocate so that it may quickly exit and free
-	 * its memory.
+	 * If current has a pending SIGKILL or is exiting, then automatically
+	 * select it.  The goal is to allow it to allocate so that it may
+	 * quickly exit and free its memory.
 	 */
-	if (fatal_signal_pending(current)) {
+	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
 		set_thread_flag(TIF_MEMDIE);
 		return;
 	}
-- 
1.8.3.2

