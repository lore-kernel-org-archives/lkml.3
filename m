Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbaJNVHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:07:38 -0400
Received: from mail.kernel.org ([198.145.19.201]:45053 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932AbaJNVGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:06:34 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 21/24] perf tools: fix off-by-one error in maps
Date: Tue, 14 Oct 2014 18:04:30 -0300
Message-Id: <1413320673-5784-22-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413320673-5784-1-git-send-email-acme@kernel.org>
References: <1413320673-5784-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

This patch fixes off-by-one errors in the management of maps.

A map is defined by start address and length as implemented by
map__new():

  map__init(map, type, start, start + len, pgoff, dso);

  map->start = addr;
  map->end = end;

Consequently, the actual address range is [start; end[ map->end is the
first byte outside the range.

This patch fixes two bugs where upper bound checking was off-by-one.

In V2, we fix map_groups__fixup_overlappings() some more where
map->start was off-by-one as reported by Jiri.

Signed-off-by: Stephane Eranian <eranian@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20141006083532.GA4850@quad
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index b7090596ac50..186418ba18db 100644
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
-- 
1.9.3

