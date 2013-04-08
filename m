Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935027Ab3DHGem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 02:34:42 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:20289 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934734Ab3DHGej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 02:34:39 -0400
Message-ID: <516264E4.5090405@huawei.com>
Date: Mon, 8 Apr 2013 14:34:12 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH 05/12] memcg: use css_get() in sock_update_memcg()
References: <5162648B.9070802@huawei.com>
In-Reply-To: <5162648B.9070802@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use css_get/css_put instead of mem_cgroup_get/put.

Note, if at the same time someone is moving @current to a different
cgroup and removing the old cgroup, css_tryget() may return false,
and sock->sk_cgrp won't be initialized, which is fine.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e65eaac..bbf5bf3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -536,15 +536,15 @@ void sock_update_memcg(struct sock *sk)
 		 */
 		if (sk->sk_cgrp) {
 			BUG_ON(mem_cgroup_is_root(sk->sk_cgrp->memcg));
-			mem_cgroup_get(sk->sk_cgrp->memcg);
+			css_get(&sk->sk_cgrp->memcg->css);
 			return;
 		}
 
 		rcu_read_lock();
 		memcg = mem_cgroup_from_task(current);
 		cg_proto = sk->sk_prot->proto_cgroup(memcg);
-		if (!mem_cgroup_is_root(memcg) && memcg_proto_active(cg_proto)) {
-			mem_cgroup_get(memcg);
+		if (!mem_cgroup_is_root(memcg) &&
+		    memcg_proto_active(cg_proto) && css_tryget(&memcg->css)) {
 			sk->sk_cgrp = cg_proto;
 		}
 		rcu_read_unlock();
@@ -558,7 +558,7 @@ void sock_release_memcg(struct sock *sk)
 		struct mem_cgroup *memcg;
 		WARN_ON(!sk->sk_cgrp->memcg);
 		memcg = sk->sk_cgrp->memcg;
-		mem_cgroup_put(memcg);
+		css_put(&sk->sk_cgrp->memcg->css);
 	}
 }
 
-- 
1.8.0.2
