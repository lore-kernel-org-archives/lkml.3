Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaEMP3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:29:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053AbaEMP3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:29:32 -0400
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>,
        Greg Thelen <gthelen@google.com>, LKML <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH] memcg: deprecate memory.force_empty knob
Date: Tue, 13 May 2014 17:29:16 +0200
Message-Id: <1399994956-3907-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 2.0.0.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

force_empty has been introduced primarily to drop memory before it gets
reparented on the group removal. This alone doesn't sound fully
justified because reparented pages which are not in use can be reclaimed
also later when there is a memory pressure on the parent level.

Mark the knob CFTYPE_INSANE which tells the cgroup core that it
shouldn't create the knob with the experimental sane_behavior. Other
users will get informed about the deprecation and asked to tell us more
because I do not expect most users will use sane_behavior cgroups mode
very soon.
Anyway I expect that most users will be simply cgroup remove handlers
which do that since ever without having any good reason for it.

If somebody really cares because reparented pages, which would be
dropped otherwise, push out more important ones then we should fix the
reparenting code and put pages to the tail.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---

Hi,
This patch has been created based on http://marc.info/?l=linux-kernel&m=139967135405272

 Documentation/cgroups/memory.txt | 3 +++
 mm/memcontrol.c                  | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index f0f67b44ea07..fc9fad984bfb 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -477,6 +477,9 @@ About use_hierarchy, see Section 6.
   write will still return success. In this case, it is expected that
   memory.kmem.usage_in_bytes == memory.usage_in_bytes.
 
+  Please note that this knob is considered deprecated and will be removed
+  in future.
+
   About use_hierarchy, see Section 6.
 
 5.2 stat file
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b030b15b626a..ee123f3d40d5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4793,6 +4793,10 @@ static int mem_cgroup_force_empty_write(struct cgroup_subsys_state *css,
 
 	if (mem_cgroup_is_root(memcg))
 		return -EINVAL;
+	pr_info("%s (%d): memory.force_empty is deprecated and will be removed.",
+			current->comm, task_pid_nr(current));
+	pr_cont(" Let us know if you know if it needed in your usecase at");
+	pr_cont(" linux-mm@kvack.org\n");
 	return mem_cgroup_force_empty(memcg);
 }
 
@@ -6037,6 +6041,7 @@ static struct cftype mem_cgroup_files[] = {
 	},
 	{
 		.name = "force_empty",
+		.flags = CFTYPE_INSANE,
 		.trigger = mem_cgroup_force_empty_write,
 	},
 	{
-- 
2.0.0.rc0

