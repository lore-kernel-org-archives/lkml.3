Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508AbaBGLwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:52:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42378 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbaBGLwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:52:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 198/233] mm, oom: base root bonus on current usage
Date: Fri,  7 Feb 2014 11:46:57 +0000
Message-Id: <1391773652-25214-199-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rientjes <rientjes@google.com>

commit 778c14affaf94a9e4953179d3e13a544ccce7707 upstream.

A 3% of system memory bonus is sometimes too excessive in comparison to
other processes.

With commit a63d83f427fb ("oom: badness heuristic rewrite"), the OOM
killer tries to avoid killing privileged tasks by subtracting 3% of
overall memory (system or cgroup) from their per-task consumption.  But
as a result, all root tasks that consume less than 3% of overall memory
are considered equal, and so it only takes 33+ privileged tasks pushing
the system out of memory for the OOM killer to do something stupid and
kill dhclient or other root-owned processes.  For example, on a 32G
machine it can't tell the difference between the 1M agetty and the 10G
fork bomb member.

The changelog describes this 3% boost as the equivalent to the global
overcommit limit being 3% higher for privileged tasks, but this is not
the same as discounting 3% of overall memory from _every privileged task
individually_ during OOM selection.

Replace the 3% of system memory bonus with a 3% of current memory usage
bonus.

By giving root tasks a bonus that is proportional to their actual size,
they remain comparable even when relatively small.  In the example
above, the OOM killer will discount the 1M agetty's 256 badness points
down to 179, and the 10G fork bomb's 262144 points down to 183500 points
and make the right choice, instead of discounting both to 0 and killing
agetty because it's first in the task list.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 Documentation/filesystems/proc.txt | 4 ++--
 mm/oom_kill.c                      | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index fcc22c9..9198f01 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1377,8 +1377,8 @@ may allocate from based on an estimation of its current memory and swap use.
 For example, if a task is using all allowed memory, its badness score will be
 1000.  If it is using half of its allowed memory, its score will be 500.
 
-There is an additional factor included in the badness score: root
-processes are given 3% extra memory over other tasks.
+There is an additional factor included in the badness score: the current memory
+and swap usage is discounted by 3% for root processes.
 
 The amount of "allowed" memory depends on the context in which the oom killer
 was called.  If it is due to the memory assigned to the allocating task's cpuset
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 79e451a..dfa94ed 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -170,7 +170,7 @@ unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *memcg,
 	 * implementation used by LSMs.
 	 */
 	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
-		adj -= 30;
+		points -= (points * 3) / 100;
 
 	/* Normalize to oom_score_adj units */
 	adj *= totalpages / 1000;
-- 
1.8.3.2

