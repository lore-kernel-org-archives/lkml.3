Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbaDWKMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 06:12:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58409 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbaDWKMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 06:12:18 -0400
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        <stable@vger.kernel.org>
Subject: [PATCH -mm -repost] memcg: do not hang on OOM when killed by userspace OOM access to memory reserves
Date: Wed, 23 Apr 2014 12:12:02 +0200
Message-Id: <1398247922-2374-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric has reported that he can see task(s) stuck in memcg OOM handler
regularly.  The only way out is to

	echo 0 > $GROUP/memory.oom_controll

His usecase is:

- Setup a hierarchy with memory and the freezer (disable kernel oom and
  have a process watch for oom).

- In that memory cgroup add a process with one thread per cpu.

- In one thread slowly allocate once per second I think it is 16M of ram
  and mlock and dirty it (just to force the pages into ram and stay
  there).

- When oom is achieved loop:
  * attempt to freeze all of the tasks.
  * if frozen send every task SIGKILL, unfreeze, remove the directory in
    cgroupfs.

Eric has then pinpointed the issue to be memcg specific.

All tasks are sitting on the memcg_oom_waitq when memcg oom is disabled.
Those that have received fatal signal will bypass the charge and should
continue on their way out.  The tricky part is that the exit path might
trigger a page fault (e.g.  exit_robust_list), thus the memcg charge,
while its memcg is still under OOM because nobody has released any charges
yet.

Unlike with the in-kernel OOM handler the exiting task doesn't get
TIF_MEMDIE set so it doesn't shortcut further charges of the killed task
and falls to the memcg OOM again without any way out of it as there are no
fatal signals pending anymore.

This patch fixes the issue by checking PF_EXITING early in
mem_cgroup_try_charge and bypass the charge same as if it had fatal
signal pending or TIF_MEMDIE set.

Normally exiting tasks (aka not killed) will bypass the charge now but
this should be OK as the task is leaving and will release memory and
increasing the memory pressure just to release it in a moment seems
dubious wasting of cycles.  Besides that charges after exit_signals should
be rare.

Reported-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

I am bringing this patch again (rebased on the current mmotm tree). I
hope we can move forward finally. If there is still an opposition then
I would really appreciate a concurrent approach so that we can discuss
alternatives.

http://comments.gmane.org/gmane.linux.kernel.stable/77650 is a reference
to the followup discussion when the patch has been dropped from the
mmotm last time.

 mm/memcontrol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e59f5729e5e6..48d109af1fa8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2675,7 +2675,8 @@ static int mem_cgroup_try_charge(struct mem_cgroup *memcg,
 	 * free their memory.
 	 */
 	if (unlikely(test_thread_flag(TIF_MEMDIE) ||
-		     fatal_signal_pending(current)))
+		     fatal_signal_pending(current) ||
+		     current->flags & PF_EXITING))
 		goto bypass;
 
 	if (unlikely(task_in_memcg_oom(current)))
-- 
1.9.2

