Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab3IWI5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:57:05 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:3070 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab3IWI5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:57:03 -0400
Message-ID: <5240023D.6040606@huawei.com>
Date: Mon, 23 Sep 2013 16:56:29 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH v6 3/5] memcg: fail to create cgroup if the cgroup id is too
 big
References: <524001F8.6070205@huawei.com>
In-Reply-To: <524001F8.6070205@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memcg requires the cgroup id to be smaller than 65536.

This is a preparation to kill css id.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6719e2c..4e40ebe 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -498,6 +498,12 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
 	return (memcg == root_mem_cgroup);
 }
 
+/*
+ * We restrict the id in the range of [1, 65535], so it can fit into
+ * an unsigned short.
+ */
+#define MEM_CGROUP_ID_MAX	USHRT_MAX
+
 static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
 {
 	/*
@@ -6312,6 +6318,9 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	struct mem_cgroup *parent = mem_cgroup_from_css(css_parent(css));
 	int error = 0;
 
+	if (css->cgroup->id > MEM_CGROUP_ID_MAX)
+		return -ENOSPC;
+
 	if (!parent)
 		return 0;
 
-- 
1.8.0.2

