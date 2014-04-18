Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbaDRXCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 19:02:01 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:42932 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbaDRXBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 19:01:55 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: hannes@cmpxchg.org, mhocko@suse.cz, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        nasa4836@gmail.com
Subject: [PATCH 2/2] mm/memcontrol.c: introduce helper mem_cgroup_zoneinfo_zone()
Date: Sat, 19 Apr 2014 07:01:43 +0800
Message-Id: <1397862103-31982-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 1.9.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

introduce helper mem_cgroup_zoneinfo_zone(). This will make
mem_cgroup_iter() code more compact.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 mm/memcontrol.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e0ce15c..80d9e38 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -683,6 +683,15 @@ mem_cgroup_zoneinfo(struct mem_cgroup *memcg, int nid, int zid)
 	return &memcg->nodeinfo[nid]->zoneinfo[zid];
 }
 
+static struct mem_cgroup_per_zone *
+mem_cgroup_zoneinfo_zone(struct mem_cgroup *memcg, struct zone *zone)
+{
+       int nid = zone_to_nid(zone);
+       int zid = zone_idx(zone);
+
+       return mem_cgroup_zoneinfo(memcg, nid, zid);
+}
+
 struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *memcg)
 {
 	return &memcg->css;
@@ -1232,11 +1241,9 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 
 	rcu_read_lock();
 	if (reclaim) {
-		int nid = zone_to_nid(reclaim->zone);
-		int zid = zone_idx(reclaim->zone);
 		struct mem_cgroup_per_zone *mz;
 
-		mz = mem_cgroup_zoneinfo(root, nid, zid);
+		mz = mem_cgroup_zoneinfo_zone(root, reclaim->zone);
 		iter = &mz->reclaim_iter[reclaim->priority];
 		if (prev && reclaim->generation != iter->generation) {
 			iter->last_visited = NULL;
@@ -1340,7 +1347,7 @@ struct lruvec *mem_cgroup_zone_lruvec(struct zone *zone,
 		goto out;
 	}
 
-	mz = mem_cgroup_zoneinfo(memcg, zone_to_nid(zone), zone_idx(zone));
+	mz = mem_cgroup_zoneinfo_zone(memcg, zone);
 	lruvec = &mz->lruvec;
 out:
 	/*
-- 
1.9.0.GIT

