Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab3FLMG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 08:06:56 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:42882 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab3FLMGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 08:06:54 -0400
Message-ID: <51B86456.3060606@gmail.com>
Date: Wed, 12 Jun 2013 20:06:46 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: Remove zone_type argument of build_zonelists_node
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

The callers of build_zonelists_node always pass MAX_NR_ZONES -1
as the zone_type argument, so we can directly use the value
in build_zonelists_node and remove zone_type argument.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/page_alloc.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 378a15b..4c09dea 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3148,12 +3148,10 @@ static void zoneref_set_zone(struct zone *zone, struct zoneref *zoneref)
  * Add all populated zones of a node to the zonelist.
  */
 static int build_zonelists_node(pg_data_t *pgdat, struct zonelist *zonelist,
-				int nr_zones, enum zone_type zone_type)
+				int nr_zones)
 {
 	struct zone *zone;
-
-	BUG_ON(zone_type >= MAX_NR_ZONES);
-	zone_type++;
+	enum zone_type zone_type = MAX_NR_ZONES;
 
 	do {
 		zone_type--;
@@ -3163,8 +3161,8 @@ static int build_zonelists_node(pg_data_t *pgdat, struct zonelist *zonelist,
 				&zonelist->_zonerefs[nr_zones++]);
 			check_highest_zone(zone_type);
 		}
-
 	} while (zone_type);
+
 	return nr_zones;
 }
 
@@ -3351,8 +3349,7 @@ static void build_zonelists_in_node_order(pg_data_t *pgdat, int node)
 	zonelist = &pgdat->node_zonelists[0];
 	for (j = 0; zonelist->_zonerefs[j].zone != NULL; j++)
 		;
-	j = build_zonelists_node(NODE_DATA(node), zonelist, j,
-							MAX_NR_ZONES - 1);
+	j = build_zonelists_node(NODE_DATA(node), zonelist, j);
 	zonelist->_zonerefs[j].zone = NULL;
 	zonelist->_zonerefs[j].zone_idx = 0;
 }
@@ -3366,7 +3363,7 @@ static void build_thisnode_zonelists(pg_data_t *pgdat)
 	struct zonelist *zonelist;
 
 	zonelist = &pgdat->node_zonelists[1];
-	j = build_zonelists_node(pgdat, zonelist, 0, MAX_NR_ZONES - 1);
+	j = build_zonelists_node(pgdat, zonelist, 0);
 	zonelist->_zonerefs[j].zone = NULL;
 	zonelist->_zonerefs[j].zone_idx = 0;
 }
@@ -3574,7 +3571,7 @@ static void build_zonelists(pg_data_t *pgdat)
 	local_node = pgdat->node_id;
 
 	zonelist = &pgdat->node_zonelists[0];
-	j = build_zonelists_node(pgdat, zonelist, 0, MAX_NR_ZONES - 1);
+	j = build_zonelists_node(pgdat, zonelist, 0);
 
 	/*
 	 * Now we build the zonelist so that it contains the zones
@@ -3587,14 +3584,12 @@ static void build_zonelists(pg_data_t *pgdat)
 	for (node = local_node + 1; node < MAX_NUMNODES; node++) {
 		if (!node_online(node))
 			continue;
-		j = build_zonelists_node(NODE_DATA(node), zonelist, j,
-							MAX_NR_ZONES - 1);
+		j = build_zonelists_node(NODE_DATA(node), zonelist, j);
 	}
 	for (node = 0; node < local_node; node++) {
 		if (!node_online(node))
 			continue;
-		j = build_zonelists_node(NODE_DATA(node), zonelist, j,
-							MAX_NR_ZONES - 1);
+		j = build_zonelists_node(NODE_DATA(node), zonelist, j);
 	}
 
 	zonelist->_zonerefs[j].zone = NULL;
-- 
1.7.1
