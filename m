Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbaBESjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 13:39:45 -0500
Received: from relay.parallels.com ([195.214.232.42]:35615 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbaBESjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 13:39:36 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <dchinner@redhat.com>, <mhocko@suse.cz>, <hannes@cmpxchg.org>,
        <glommer@gmail.com>, <rientjes@google.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>, Glauber Costa <glommer@openvz.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH -mm v15 03/13] memcg: move initialization to memcg creation
Date: Wed, 5 Feb 2014 22:39:19 +0400
Message-ID: <bcb50b8fafbb284f3bfcbf083630aa38154faf16.1391624021.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1391624021.git.vdavydov@parallels.com>
References: <cover.1391624021.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.25.229]
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
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9d1245dc993a..deb5b9bb6188 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5210,8 +5210,6 @@ static int __memcg_activate_kmem(struct mem_cgroup *memcg,
 		goto out_rmid;
 
 	memcg->kmemcg_id = memcg_id;
-	INIT_LIST_HEAD(&memcg->memcg_slab_caches);
-	mutex_init(&memcg->slab_caches_mutex);
 
 	/*
 	 * We couldn't have accounted to this cgroup, because it hasn't got the
@@ -5958,6 +5956,9 @@ static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 	int ret;
 
 	memcg->kmemcg_id = -1;
+	INIT_LIST_HEAD(&memcg->memcg_slab_caches);
+	mutex_init(&memcg->slab_caches_mutex);
+
 	ret = memcg_propagate_kmem(memcg);
 	if (ret)
 		return ret;
-- 
1.7.10.4

