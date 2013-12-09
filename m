Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760983Ab3LIIKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:10:04 -0500
Received: from relay.parallels.com ([195.214.232.42]:35848 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab3LIIGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:06:08 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <dchinner@redhat.com>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>, <glommer@openvz.org>,
        <glommer@gmail.com>, <vdavydov@parallels.com>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH v13 03/16] memcg: move initialization to memcg creation
Date: Mon, 9 Dec 2013 12:05:44 +0400
Message-ID: <f4d4ff27f63506c2779399fbe51f01596b5e6cfb.1386571280.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1386571280.git.vdavydov@parallels.com>
References: <cover.1386571280.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@openvz.org>

Those structures are only used for memcgs that are effectively using
kmemcg. However, in a later patch I intend to use scan that list
inconditionally (list empty meaning no kmem caches present), which
simplifies the code a lot.

So move the initialization to early kmem creation.

Signed-off-by: Glauber Costa <glommer@openvz.org>
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 144cb4c..3a4e2f8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3122,8 +3122,6 @@ int memcg_update_cache_sizes(struct mem_cgroup *memcg)
 	}
 
 	memcg->kmemcg_id = num;
-	INIT_LIST_HEAD(&memcg->memcg_slab_caches);
-	mutex_init(&memcg->slab_caches_mutex);
 	return 0;
 }
 
@@ -5909,6 +5907,8 @@ static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 {
 	int ret;
 
+	INIT_LIST_HEAD(&memcg->memcg_slab_caches);
+	mutex_init(&memcg->slab_caches_mutex);
 	memcg->kmemcg_id = -1;
 	ret = memcg_propagate_kmem(memcg);
 	if (ret)
-- 
1.7.10.4

