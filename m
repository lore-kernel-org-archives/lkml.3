Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbaCHBZC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:25:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbaCHBHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:07:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jianguo Wu <wujianguo@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Minchan Kim <minchan@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Keping Chen <chenkeping@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 51/99] mm/hotplug: correctly add new zone to all other nodes zone lists
Date: Fri,  7 Mar 2014 17:07:47 -0800
Message-Id: <20140308010613.241225956@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiang Liu <jiang.liu@huawei.com>

commit 08dff7b7d629807dbb1f398c68dd9cd58dd657a1 upstream.

When online_pages() is called to add new memory to an empty zone, it
rebuilds all zone lists by calling build_all_zonelists().  But there's a
bug which prevents the new zone to be added to other nodes' zone lists.

online_pages() {
	build_all_zonelists()
	.....
	node_set_state(zone_to_nid(zone), N_HIGH_MEMORY)
}

Here the node of the zone is put into N_HIGH_MEMORY state after calling
build_all_zonelists(), but build_all_zonelists() only adds zones from
nodes in N_HIGH_MEMORY state to the fallback zone lists.
build_all_zonelists()

    ->__build_all_zonelists()
	->build_zonelists()
	    ->find_next_best_node()
		->for_each_node_state(n, N_HIGH_MEMORY)

So memory in the new zone will never be used by other nodes, and it may
cause strange behavor when system is under memory pressure.  So put node
into N_HIGH_MEMORY state before calling build_all_zonelists().

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Jiang Liu <liuj97@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Keping Chen <chenkeping@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memory_hotplug.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -515,19 +515,20 @@ int __ref online_pages(unsigned long pfn
 
 	zone->present_pages += onlined_pages;
 	zone->zone_pgdat->node_present_pages += onlined_pages;
-	if (need_zonelists_rebuild)
-		build_all_zonelists(zone);
-	else
-		zone_pcp_update(zone);
+	if (onlined_pages) {
+		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
+		if (need_zonelists_rebuild)
+			build_all_zonelists(zone);
+		else
+			zone_pcp_update(zone);
+	}
 
 	mutex_unlock(&zonelists_mutex);
 
 	init_per_zone_wmark_min();
 
-	if (onlined_pages) {
+	if (onlined_pages)
 		kswapd_run(zone_to_nid(zone));
-		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
-	}
 
 	vm_total_pages = nr_free_pagecache_pages();
 


