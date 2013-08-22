Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab3HVFjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 01:39:20 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:58459 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab3HVFjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 01:39:18 -0400
Date: Thu, 22 Aug 2013 13:39:09 +0800
From: larmbr <nasa4836@gmail.com>
To: linux-mm@kvack.org
Cc: hannes@cmpxchg.org, mhocko@suse.cz, mgorman@suse.de, riel@redhat.com,
        bsingharora@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm/vmscan : use vmcan_swappiness( ) basing on MEMCG config
 to elimiate unnecessary runtime cost
Message-ID: <20130822053909.GA10775@larmbr-lcx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we get the vm_swappiness via vmscan_swappiness(), which
calls global_reclaim() to check if this is a global reclaim. 

Besides, the current implementation of global_reclaim() always returns 
true for the !CONFIG_MEGCG case, and judges the other case by checking 
whether scan_control->target_mem_cgroup is null or not.

Thus, we could just use two versions of vmscan_swappiness() based on 
MEMCG Kconfig , to eliminate the unnecessary run-time cost for 
the !CONFIG_MEMCG at all, and to squash all memcg-related checking
into the CONFIG_MEMCG version.

Signed-off-by: Zhan Jianyu <nasa4836@gmail.com>
---
mm/memcontrol.c |    6 +++++-
mm/vmscan.c     |    9 +++++++--
2 files changed, 12 insertions(+), 3 deletions(-)


diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c5792a5..1290320 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1525,9 +1525,13 @@ static unsigned long mem_cgroup_margin(struct mem_cgroup *memcg)
 
 int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
-	struct cgroup *cgrp = memcg->css.cgroup;
+	struct cgroup *cgrp;
+
+	if (!memcg)
+		return vm_swappiness;
 
 	/* root ? */
+	cgrp = memcg->css.cgroup;
 	if (cgrp->parent == NULL)
 		return vm_swappiness;
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2cff0d4..1de652d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1742,12 +1742,17 @@ static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
 	return shrink_inactive_list(nr_to_scan, lruvec, sc, lru);
 }
 
+#ifdef CONFIG_MEMCG
 static int vmscan_swappiness(struct scan_control *sc)
 {
-	if (global_reclaim(sc))
-		return vm_swappiness;
 	return mem_cgroup_swappiness(sc->target_mem_cgroup);
 }
+#else
+static int vmscan_swappiness(struct scan_control *sc)
+{
+	return vm_swappiness;
+}
+#endif
 
 enum scan_balance {
 	SCAN_EQUAL,
