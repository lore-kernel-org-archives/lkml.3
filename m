Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaJOKGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:06:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54530 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaJOKGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:06:35 -0400
Date: Wed, 15 Oct 2014 03:05:46 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-77faf4d060e3ee1fd2ff6cd39f2b2eb887100422@git.kernel.org>
Cc: peterz@infradead.org, acme@redhat.com, hpa@zytor.com, dsahern@gmail.com,
        linux-kernel@vger.kernel.org, eranian@google.com, namhyung@kernel.org,
        tglx@linutronix.de, mingo@kernel.org, jolsa@redhat.com
Reply-To: mingo@kernel.org, jolsa@redhat.com, tglx@linutronix.de,
        eranian@google.com, namhyung@kernel.org, linux-kernel@vger.kernel.org,
        dsahern@gmail.com, hpa@zytor.com, acme@redhat.com,
        peterz@infradead.org
In-Reply-To: <20141006083532.GA4850@quad>
References: <20141006083532.GA4850@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: fix off-by-one error in maps
Git-Commit-ID: 77faf4d060e3ee1fd2ff6cd39f2b2eb887100422
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  77faf4d060e3ee1fd2ff6cd39f2b2eb887100422
Gitweb:     http://git.kernel.org/tip/77faf4d060e3ee1fd2ff6cd39f2b2eb887100422
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 6 Oct 2014 10:35:32 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 14 Oct 2014 17:50:55 -0300

perf tools: fix off-by-one error in maps

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
index b709059..186418b 100644
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
