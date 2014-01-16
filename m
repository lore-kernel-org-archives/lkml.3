Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaAPCkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:40:51 -0500
Received: from mail-yk0-f175.google.com ([209.85.160.175]:52580 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaAPCks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:40:48 -0500
Date: Wed, 15 Jan 2014 18:40:41 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch -mm] mm, oom: prefer thread group leaders for display
 purposes
Message-ID: <alpine.DEB.2.02.1401151837560.1835@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When two threads have the same badness score, it's preferable to kill the 
thread group leader so that the actual process name is printed to the 
kernel log rather than the thread group name which may be shared amongst 
several processes.

This was the behavior when select_bad_process() used to do 
for_each_process(), but it now iterates threads instead and leads to 
ambiguity.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/memcontrol.c | 18 +++++++++++-------
 mm/oom_kill.c   | 12 ++++++++----
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a815686..b482f49 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1841,13 +1841,17 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 				break;
 			};
 			points = oom_badness(task, memcg, NULL, totalpages);
-			if (points > chosen_points) {
-				if (chosen)
-					put_task_struct(chosen);
-				chosen = task;
-				chosen_points = points;
-				get_task_struct(chosen);
-			}
+			if (points < chosen_points)
+				continue;
+			/* Prefer thread group leaders for display purposes */
+			if (points == chosen_points &&
+			    thread_group_leader(chosen))
+				continue;
+
+			if (chosen)
+				put_task_struct(chosen);
+			chosen = task;
+			chosen_points = points;
 		}
 		css_task_iter_end(&it);
 	}
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 054ff47..1dca3d8 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -327,10 +327,14 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
 			break;
 		};
 		points = oom_badness(p, NULL, nodemask, totalpages);
-		if (points > chosen_points) {
-			chosen = p;
-			chosen_points = points;
-		}
+		if (points < chosen_points)
+			continue;
+		/* Prefer thread group leaders for display purposes */
+		if (points == chosen_points && thread_group_leader(chosen))
+			continue;
+
+		chosen = p;
+		chosen_points = points;
 	}
 	if (chosen)
 		get_task_struct(chosen);
