Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab3JNUFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:05:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39153 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757823Ab3JNUDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 146/161] perf symbols: Add map_groups__find_ams()
Date: Mon, 14 Oct 2013 17:02:15 -0300
Message-Id: <1381780950-25642-147-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Add a function to find a symbol using an ip that might be on a different
map.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1381747424-3557-2-git-send-email-adrian.hunter@intel.com
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c | 17 +++++++++++++++++
 tools/perf/util/map.h |  4 ++++
 2 files changed, 21 insertions(+)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 17ee458a0870..9dea404de3fa 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -371,6 +371,23 @@ struct symbol *map_groups__find_symbol_by_name(struct map_groups *mg,
 	return NULL;
 }
 
+int map_groups__find_ams(struct addr_map_symbol *ams, symbol_filter_t filter)
+{
+	if (ams->addr < ams->map->start || ams->addr > ams->map->end) {
+		if (ams->map->groups == NULL)
+			return -1;
+		ams->map = map_groups__find(ams->map->groups, ams->map->type,
+					    ams->addr);
+		if (ams->map == NULL)
+			return -1;
+	}
+
+	ams->al_addr = ams->map->map_ip(ams->map, ams->addr);
+	ams->sym = map__find_symbol(ams->map, ams->al_addr, filter);
+
+	return ams->sym ? 0 : -1;
+}
+
 size_t __map_groups__fprintf_maps(struct map_groups *mg,
 				  enum map_type type, int verbose, FILE *fp)
 {
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 4886ca280536..0359b4a808f0 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -167,6 +167,10 @@ struct symbol *map_groups__find_symbol_by_name(struct map_groups *mg,
 					       struct map **mapp,
 					       symbol_filter_t filter);
 
+struct addr_map_symbol;
+
+int map_groups__find_ams(struct addr_map_symbol *ams, symbol_filter_t filter);
+
 static inline
 struct symbol *map_groups__find_function_by_name(struct map_groups *mg,
 						 const char *name, struct map **mapp,
-- 
1.8.1.4

