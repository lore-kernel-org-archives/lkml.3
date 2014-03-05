Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbaCEECT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 23:02:19 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:52873 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757692AbaCED7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:59:22 -0500
Date: Tue, 4 Mar 2014 19:59:19 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Tejun Heo <tj@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>,
        Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>,
        Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [patch 04/11] mm, memcg: add tunable for oom reserves
In-Reply-To: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1403041955050.8067@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userspace needs a way to define the amount of memory reserves that
processes handling oom conditions may utilize.  This patch adds a per-
memcg oom reserve field and file, memory.oom_reserve_in_bytes, to
manipulate its value.

If currently utilized memory reserves are attempted to be reduced by
writing a smaller value to memory.oom_reserve_in_bytes, it will fail with
-EBUSY until some memory is uncharged.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/memcontrol.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -315,6 +315,9 @@ struct mem_cgroup {
 	/* OOM-Killer disable */
 	int		oom_kill_disable;
 
+	/* reserves for handling oom conditions, protected by res.lock */
+	unsigned long long	oom_reserve;
+
 	/* set when res.limit == memsw.limit */
 	bool		memsw_is_minimum;
 
@@ -5936,6 +5939,51 @@ static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
 	return 0;
 }
 
+static int mem_cgroup_resize_oom_reserve(struct mem_cgroup *memcg,
+					 unsigned long long new_limit)
+{
+	struct res_counter *res = &memcg->res;
+	u64 limit, usage;
+	int ret = 0;
+
+	spin_lock(&res->lock);
+	limit = res->limit;
+	usage = res->usage;
+
+	if (usage > limit && usage - limit > new_limit) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	memcg->oom_reserve = new_limit;
+out:
+	spin_unlock(&res->lock);
+	return ret;
+}
+
+static u64 mem_cgroup_oom_reserve_read(struct cgroup_subsys_state *css,
+				       struct cftype *cft)
+{
+	return mem_cgroup_from_css(css)->oom_reserve;
+}
+
+static int mem_cgroup_oom_reserve_write(struct cgroup_subsys_state *css,
+					struct cftype *cft, const char *buffer)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+	unsigned long long val;
+	int ret;
+
+	if (mem_cgroup_is_root(memcg))
+		return -EINVAL;
+
+	ret = res_counter_memparse_write_strategy(buffer, &val);
+	if (ret)
+		return ret;
+
+	return mem_cgroup_resize_oom_reserve(memcg, val);
+}
+
 #ifdef CONFIG_MEMCG_KMEM
 static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 {
@@ -6291,6 +6339,11 @@ static struct cftype mem_cgroup_files[] = {
 		.private = MEMFILE_PRIVATE(_OOM_TYPE, OOM_CONTROL),
 	},
 	{
+		.name = "oom_reserve_in_bytes",
+		.read_u64 = mem_cgroup_oom_reserve_read,
+		.write_string = mem_cgroup_oom_reserve_write,
+	},
+	{
 		.name = "pressure_level",
 	},
 #ifdef CONFIG_NUMA
