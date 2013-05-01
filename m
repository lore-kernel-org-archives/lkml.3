Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263Ab3EAXci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 19:32:38 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52773 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757422Ab3EAXcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 19:32:18 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 3/4] memory_hotplug: use pgdat_resize_lock() in online_pages()
Date: Wed,  1 May 2013 16:32:00 -0700
Message-Id: <1367451121-22725-4-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367451121-22725-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1367451121-22725-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050123-5806-0000-0000-000020F6C7F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmzone.h documents node_size_lock (which pgdat_resize_lock() locks) as
guarding against changes to node_present_pages, so actually lock it when
we update node_present_pages to keep that promise.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/memory_hotplug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a221fac..0bdca10 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -915,6 +915,7 @@ static void node_states_set_node(int node, struct memory_notify *arg)
 
 int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int online_type)
 {
+	unsigned long flags;
 	unsigned long onlined_pages = 0;
 	struct zone *zone;
 	int need_zonelists_rebuild = 0;
@@ -993,7 +994,11 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int online_typ
 
 	zone->managed_pages += onlined_pages;
 	zone->present_pages += onlined_pages;
+
+	pgdat_resize_lock(zone->zone_pgdat, &flags);
 	zone->zone_pgdat->node_present_pages += onlined_pages;
+	pgdat_resize_unlock(zone->zone_pgdat, &flags);
+
 	if (onlined_pages) {
 		node_states_set_node(zone_to_nid(zone), &arg);
 		if (need_zonelists_rebuild)
-- 
1.8.2.2

