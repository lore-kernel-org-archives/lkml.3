Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122AbaLPNZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 08:25:53 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41537 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaLPNZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 08:25:51 -0500
From: Chintan Pandya <cpandya@codeaurora.org>
To: mhocko@suse.cz, hannes@cmpxchg.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chintan Pandya <cpandya@codeaurora.org>
Subject: [PATCH] memcg: Provide knob for force OOM into the memcg
Date: Tue, 16 Dec 2014 18:55:35 +0530
Message-Id: <1418736335-30915-1-git-send-email-cpandya@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We may want to use memcg to limit the total memory
footprint of all the processes within the one group.
This may lead to a situation where any arbitrary
process cannot get migrated to that one  memcg
because its limits will be breached. Or, process can
get migrated but even being most recently used
process, it can get killed by in-cgroup OOM. To
avoid such scenarios, provide a convenient knob
by which we can forcefully trigger OOM and make
a room for upcoming process.

To trigger force OOM,
$ echo 1 > /<memcg_path>/memory.force_oom

Signed-off-by: Chintan Pandya <cpandya@codeaurora.org>
---
 mm/memcontrol.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ef91e85..4c68aa7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3305,6 +3305,30 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 	return 0;
 }
 
+static int mem_cgroup_force_oom(struct cgroup *cont, unsigned int event)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
+	int ret;
+
+	if (mem_cgroup_is_root(memcg))
+		return -EINVAL;
+
+	css_get(&memcg->css);
+	ret = mem_cgroup_handle_oom(memcg, GFP_KERNEL, 0);
+	css_put(&memcg->css);
+
+	return ret;
+}
+
+static int mem_cgroup_force_oom_write(struct cgroup *cgrp,
+				struct cftype *cft, u64 val)
+{
+	if (val > 1 || val < 1)
+		return -EINVAL;
+
+	return mem_cgroup_force_oom(cgrp, 0);
+}
+
 static ssize_t mem_cgroup_force_empty_write(struct kernfs_open_file *of,
 					    char *buf, size_t nbytes,
 					    loff_t off)
@@ -4442,6 +4466,11 @@ static struct cftype mem_cgroup_files[] = {
 		.write = mem_cgroup_force_empty_write,
 	},
 	{
+		.name = "force_oom",
+		.trigger = mem_cgroup_force_oom,
+		.write_u64 = mem_cgroup_force_oom_write,
+	},
+	{
 		.name = "use_hierarchy",
 		.write_u64 = mem_cgroup_hierarchy_write,
 		.read_u64 = mem_cgroup_hierarchy_read,
-- 
Chintan Pandya

QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation

