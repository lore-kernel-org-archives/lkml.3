Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbaAUUnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:43:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37278 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbaAUUn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:43:29 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Gaurav Jain <gjain@fb.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 8/8] perf symbols: Fix JIT symbol resolution on heap
Date: Tue, 21 Jan 2014 17:43:04 -0300
Message-Id: <1390336984-1553-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1390336984-1553-1-git-send-email-acme@infradead.org>
References: <1390336984-1553-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Gaurav reported that perf cannot profile JIT program if it executes the
code on heap.  This was because current map__new() only handle JIT on
anon mappings - extends it to handle no_dso (heap, stack) case too.

This patch assumes JIT profiling only provides dynamic function symbols
so check the mapping type to distinguish the case.  It'd provide no
symbols for data mapping - if we need to support symbols on data
mappings later it should be changed.

Reported-by: Gaurav Jain <gjain@fb.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Gaurav Jain <gjain@fb.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Gaurav Jain <gjain@fb.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1389836971-3549-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.8.1.4

