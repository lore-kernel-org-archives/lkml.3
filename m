Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaJCKrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 06:47:23 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:62975 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaJCKrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 06:47:21 -0400
Date: Fri, 3 Oct 2014 12:47:07 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, jolsa@redhat.com, namhyung@kernel.org,
        peterz@infradead.org, mingo@elte.hu, dsahern@gmail.com
Subject: [PATCH] perf tools: fix off-by-one error in maps
Message-ID: <20141003104707.GA4435@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes off-by-one errors in the management
of maps.  A map is defined by start address and length
as implemented by map__new():

map__init(map, type, start, start + len, pgoff, dso);

map__init()
{
  map->start = addr;
  map->end = end;
}

Consequently, the actual address range is ]start; end[
map->end is the first byte outside the range. This patch
fixes two bugs where upper bounds were off-by-one.

Signed-off-by: Stephane Eranian <eranian@google.com>

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index b709059..9e2c71e 100644
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
@@ -678,7 +678,7 @@ int map_groups__fixup_overlappings(struct map_groups *mg, struct map *map,
 				goto move_map;
 			}
 
-			after->start = map->end + 1;
+			after->start = map->end;
 			map_groups__insert(mg, after);
 			if (verbose >= 2)
 				map__fprintf(after, fp);
