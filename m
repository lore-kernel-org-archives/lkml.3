Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaAPBtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:49:36 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44408 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaAPBte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:49:34 -0500
X-AuditID: 9c930179-b7c84ae000000e38-a1-52d73aacffbe
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Gaurav Jain <gjain@fb.com>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] perf tools: Fix JIT profiling on heap
Date: Thu, 16 Jan 2014 10:49:31 +0900
Message-Id: <1389836971-3549-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gaurav reported that perf cannot profile JIT program if it executes
the code on heap.  This was because current map__new() only handle JIT
on anon mappings - extends it to handle no_dso (heap, stack) case too.

This patch assumes JIT profiling only provides dynamic function
symbols so check the mapping type to distinguish the case.  It'd
provide no symbols for data mapping - if we need to support symbols on
data mappings later it should be changed.

Reported-by: Gaurav Jain <gjain@fb.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/map.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 9b9bd719aa19..ee1dd687a262 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -69,7 +69,7 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		map->ino = ino;
 		map->ino_generation = ino_gen;
 
-		if (anon) {
+		if ((anon || no_dso) && type == MAP__FUNCTION) {
 			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
 			filename = newfilename;
 		}
@@ -93,7 +93,7 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 			 * functions still return NULL, and we avoid the
 			 * unnecessary map__load warning.
 			 */
-			if (no_dso)
+			if (type != MAP__FUNCTION)
 				dso__set_loaded(dso, map->type);
 		}
 	}
-- 
1.7.11.7

