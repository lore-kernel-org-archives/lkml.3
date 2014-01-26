Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaAZDsj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 22:48:39 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:37492 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaAZDsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 22:48:38 -0500
Date: Sat, 25 Jan 2014 19:48:32 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch] mm, oom: base root bonus on current usage
In-Reply-To: <20140124040531.GF4407@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1401251942510.3140@chino.kir.corp.google.com>
References: <20140115234308.GB4407@cmpxchg.org> <alpine.DEB.2.02.1401151614480.15665@chino.kir.corp.google.com> <20140116070709.GM6963@cmpxchg.org> <alpine.DEB.2.02.1401212050340.8512@chino.kir.corp.google.com> <20140124040531.GF4407@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A 3% of system memory bonus is sometimes too excessive in comparison to 
other processes and can yield poor results when all processes on the 
system are root and none of them use over 3% of memory.

Replace the 3% of system memory bonus with a 3% of current memory usage 
bonus.

Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/filesystems/proc.txt | 4 ++--
 mm/oom_kill.c                      | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1386,8 +1386,8 @@ may allocate from based on an estimation of its current memory and swap use.
 For example, if a task is using all allowed memory, its badness score will be
 1000.  If it is using half of its allowed memory, its score will be 500.
 
-There is an additional factor included in the badness score: root
-processes are given 3% extra memory over other tasks.
+There is an additional factor included in the badness score: the current memory
+and swap usage is discounted by 3% for root processes.
 
 The amount of "allowed" memory depends on the context in which the oom killer
 was called.  If it is due to the memory assigned to the allocating task's cpuset
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -178,7 +178,7 @@ unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *memcg,
 	 * implementation used by LSMs.
 	 */
 	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
-		adj -= 30;
+		points -= (points * 3) / 100;
 
 	/* Normalize to oom_score_adj units */
 	adj *= totalpages / 1000;
