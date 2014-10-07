Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaJGKaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:30:22 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:55002 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbaJGKaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:30:17 -0400
Date: Tue, 7 Oct 2014 12:30:07 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: jolsa@redhat.com, acme@redhat.com, namhyung@kernel.org,
        peterz@infradead.org, mingo@elte.hu, dsahern@gmail.com
Subject: [PATCH v3] perf tools: fix off-by-one error in maps
Message-ID: <20141007103007.GA22205@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes off-by-one errors in the management of maps.

A map is defined by start address and length as implemented by map__new():

map__init(map, type, start, start + len, pgoff, dso);

map->start = addr;
map->end = end;

Consequently, the actual address range is ]start; end[
map->end is the first byte outside the range. This patch
fixes two bugs where upper bound checking was off-by-one.

In V2, we fix map_groups__fixup_overlappings() some more
where map->start was off-by-one.

In V3, we also fix:
 - __map_groups__fixup_end()
 - maps__find() as report by Namhyung

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/map.c    | 8 ++++----
 tools/perf/util/symbol.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index b709059..2137c45 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -556,7 +556,7 @@ struct symbol *map_groups__find_symbol_by_name(struct map_groups *mg,
 
 int map_groups__find_ams(struct addr_map_symbol *ams, symbol_filter_t filter)
 {
-	if (ams->addr < ams->map->start || ams->addr > ams->map->end) {
+	if (ams->addr < ams->map->start || ams->addr >= ams->map->end) {
 		if (ams->map->groups == NULL)
 			return -1;
 		ams->map = map_groups__find(ams->map->groups, ams->map->type,
@@ -664,7 +664,7 @@ int map_groups__fixup_overlappings(struct map_groups *mg, struct map *map,
 				goto move_map;
 			}
 
-			before->end = map->start - 1;
+			before->end = map->start;
 			map_groups__insert(mg, before);
 			if (verbose >= 2)
 				map__fprintf(before, fp);
@@ -678,7 +678,7 @@ int map_groups__fixup_overlappings(struct map_groups *mg, struct map *map,
 				goto move_map;
 			}
 
-			after->start = map->end + 1;
+			after->start = map->end;
 			map_groups__insert(mg, after);
 			if (verbose >= 2)
 				map__fprintf(after, fp);
@@ -752,7 +752,7 @@ struct map *maps__find(struct rb_root *maps, u64 ip)
 		m = rb_entry(parent, struct map, rb_node);
 		if (ip < m->start)
 			p = &(*p)->rb_left;
-		else if (ip > m->end)
+		else if (ip >= m->end)
 			p = &(*p)->rb_right;
 		else
 			return m;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index be84f7a..c787a43 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -207,7 +207,7 @@ void __map_groups__fixup_end(struct map_groups *mg, enum map_type type)
 	for (nd = rb_next(prevnd); nd; nd = rb_next(nd)) {
 		prev = curr;
 		curr = rb_entry(nd, struct map, rb_node);
-		prev->end = curr->start - 1;
+		prev->end = curr->start;
 	}
 
 	/*
-- 
1.9.1

