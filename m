Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab3GXKC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 06:02:56 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:63818 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab3GXKCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 06:02:54 -0400
Message-ID: <51EFA62B.3020508@huawei.com>
Date: Wed, 24 Jul 2013 18:02:19 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH v2 6/8] memcg: fail to create cgroup if the cgroup id is too
 big
References: <51EFA554.6080801@huawei.com>
In-Reply-To: <51EFA554.6080801@huawei.com>
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
index 35d8286..403c8d9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -512,6 +512,12 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
 	return (memcg == root_mem_cgroup);
 }
 
+/*
+ * We restrict the id in the range of [1, 65535], so it can fit into
+ * an unsigned short.
+ */
+#define MEM_CGROUP_ID_MAX	(65535)
+
 static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
 {
 	/*
@@ -6243,6 +6249,9 @@ mem_cgroup_css_alloc(struct cgroup *cont)
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
