Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934579Ab3DHIYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 04:24:00 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:47296 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934322Ab3DHIX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 04:23:58 -0400
Message-ID: <51627E4A.6090807@huawei.com>
Date: Mon, 8 Apr 2013 16:22:34 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH 6/8] memcg: fail to create cgroup if the cgroup id is too
 big
References: <51627DA9.7020507@huawei.com>
In-Reply-To: <51627DA9.7020507@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memcg requires the cgroup id to be smaller than 65536.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 mm/memcontrol.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c4e0173..947dff1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -492,6 +492,12 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
 	return (memcg == root_mem_cgroup);
 }
 
+/*
+ * We restrict the id in the range of [0, 65535], so it can fit into
+ * an unsigned short.
+ */
+#define MEM_CGROUP_ID_MAX	(65535)
+
 static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
 {
 	return memcg->css.cgroup->id;
@@ -6125,6 +6131,9 @@ mem_cgroup_css_alloc(struct cgroup *cont)
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
