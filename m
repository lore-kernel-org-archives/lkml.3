Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbaCaAWX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:22:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36290 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752933AbaC3XZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:00 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johannes Weiner" <hannes@cmpxchg.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "David Rientjes" <rientjes@google.com>,
        "Michal Hocko" <mhocko@suse.cz>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.82329646@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 068/200] mm, oom: base root bonus on current usage
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: existing code changes 'points' directly rather
 than using 'adj' variable]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/filesystems/proc.txt | 4 ++--
 mm/oom_kill.c                      | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1293,8 +1293,8 @@ may allocate from based on an estimation
 For example, if a task is using all allowed memory, its badness score will be
 1000.  If it is using half of its allowed memory, its score will be 500.
 
-There is an additional factor included in the badness score: root
-processes are given 3% extra memory over other tasks.
+There is an additional factor included in the badness score: the current memory
+and swap usage is discounted by 3% for root processes.
 
 The amount of "allowed" memory depends on the context in which the oom killer
 was called.  If it is due to the memory assigned to the allocating task's cpuset
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -213,7 +213,7 @@ unsigned int oom_badness(struct task_str
 	 * implementation used by LSMs.
 	 */
 	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
-		points -= 30;
+		points -= (points * 3) / 100;
 
 	/*
 	 * /proc/pid/oom_score_adj ranges from -1000 to +1000 such that it may

