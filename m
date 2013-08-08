Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863Ab3HHCe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:34:59 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:6930 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932966Ab3HHCe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:34:57 -0400
Message-ID: <520303A6.1050801@huawei.com>
Date: Thu, 8 Aug 2013 10:34:14 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH v5 3/5] memcg: fail to create cgroup if the cgroup id is too
 big
References: <52030346.4050003@huawei.com>
In-Reply-To: <52030346.4050003@huawei.com>
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
index 3189f70..c0bb83c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -503,6 +503,12 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
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
@@ -6056,6 +6062,9 @@ mem_cgroup_css_alloc(struct cgroup *cont)
 	long error = -ENOMEM;
 	int node;
 
+	if (cont->id > MEM_CGROUP_ID_MAX)
+		return ERR_PTR(-ENOSPC);
+
 	memcg = mem_cgroup_alloc();
 	if (!memcg)
 		return ERR_PTR(error);
-- 
1.8.0.2
