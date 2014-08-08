Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbaHHVjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:39:23 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58590 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758713AbaHHVib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:38:31 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: linux-mm@kvack.org
Cc: Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>,
        Vladimir Davydov <vdavydov@parallels.com>, Tejun Heo <tj@kernel.org>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 3/4] mm: memcontrol: add memory.max to default hierarchy
Date: Fri,  8 Aug 2014 17:38:13 -0400
Message-Id: <1407533894-25845-4-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <1407533894-25845-1-git-send-email-hannes@cmpxchg.org>
References: <1407533894-25845-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In untrusted environments, a strict upper memory limit on a cgroup can
be necessary, to protect against bugs or malicious users.

Provide memory.max, a limit that can not be breached and will trigger
group-internal OOM killing once page reclaim can no longer enforce it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 Documentation/cgroups/unified-hierarchy.txt |  5 +++++
 mm/memcontrol.c                             | 35 +++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/Documentation/cgroups/unified-hierarchy.txt b/Documentation/cgroups/unified-hierarchy.txt
index 2d91530b8d6c..ef1db728a035 100644
--- a/Documentation/cgroups/unified-hierarchy.txt
+++ b/Documentation/cgroups/unified-hierarchy.txt
@@ -372,6 +372,10 @@ estimate of the average working set size and then make upward
 adjustments based on monitoring high limit excess, workload
 performance, and the global memory situation.
 
+In untrusted environments, users may wish to limit the amount of high
+limit excess in order to contain buggy or malicious workloads.  For
+that purpose, a hard upper limit can be set through 'memory.max'.
+
 4.3.3.2 Misc changes
 
 - use_hierarchy is on by default and the cgroup file for the flag is
@@ -380,6 +384,7 @@ performance, and the global memory situation.
 - memory.usage_in_bytes is renamed to memory.current to be in line
   with the new limit naming scheme
 
+
 5. Planned Changes
 
 5-1. CAP for resource control
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 81627387fbd7..a69ff21c8a9a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6253,6 +6253,36 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 	return nbytes;
 }
 
+static u64 memory_max_read(struct cgroup_subsys_state *css,
+			   struct cftype *cft)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+
+	return res_counter_read_u64(&memcg->res, RES_LIMIT);
+}
+
+static ssize_t memory_max_write(struct kernfs_open_file *of,
+				char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	u64 max;
+	int ret;
+
+	if (mem_cgroup_is_root(memcg))
+		return -EINVAL;
+
+	buf = strim(buf);
+	ret = res_counter_memparse_write_strategy(buf, &max);
+	if (ret)
+		return ret;
+
+	ret = mem_cgroup_resize_limit(memcg, max);
+	if (ret)
+		return ret;
+
+	return nbytes;
+}
+
 static struct cftype memory_files[] = {
 	{
 		.name = "current",
@@ -6263,6 +6293,11 @@ static struct cftype memory_files[] = {
 		.read_u64 = memory_high_read,
 		.write = memory_high_write,
 	},
+	{
+		.name = "max",
+		.read_u64 = memory_max_read,
+		.write = memory_max_write,
+	},
 };
 
 struct cgroup_subsys memory_cgrp_subsys = {
-- 
2.0.3

