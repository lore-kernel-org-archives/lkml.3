Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbaF1SVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:21:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822AbaF1Rv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:51:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.15 025/139] memcg: do not hang on OOM when killed by userspace OOM access to memory reserves
Date: Sat, 28 Jun 2014 10:46:26 -0700
Message-Id: <20140628174606.559806091@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Hocko <mhocko@suse.cz>

commit d8dc595ce3909fbc131bdf5ab8c9808fe624b18d upstream.

Eric has reported that he can see task(s) stuck in memcg OOM handler
regularly.  The only way out is to

	echo 0 > $GROUP/memory.oom_control

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

I am bringing this patch again (rebased on the current mmotm tree). I
hope we can move forward finally. If there is still an opposition then
I would really appreciate a concurrent approach so that we can discuss
alternatives.

http://comments.gmane.org/gmane.linux.kernel.stable/77650 is a reference
to the followup discussion when the patch has been dropped from the mmotm
last time.

Reported-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2684,7 +2684,8 @@ static int mem_cgroup_try_charge(struct
 	 * free their memory.
 	 */
 	if (unlikely(test_thread_flag(TIF_MEMDIE) ||
-		     fatal_signal_pending(current)))
+		     fatal_signal_pending(current) ||
+		     current->flags & PF_EXITING))
 		goto bypass;
 
 	if (unlikely(task_in_memcg_oom(current)))


