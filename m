Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3IXMLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:11:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:37644 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab3IXMJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:09:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,970,1371106800"; 
   d="scan'208";a="364821526"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V3 05/10] perf tools: add map__find_other_map_symbol()
Date: Tue, 24 Sep 2013 15:15:47 +0300
Message-Id: <1380024952-29387-6-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1380024952-29387-1-git-send-email-adrian.hunter@intel.com>
References: <1380024952-29387-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to find a symbol using an ip that
might be on a different map.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/map.c | 27 +++++++++++++++++++++++++++
 tools/perf/util/map.h |  2 ++
 2 files changed, 29 insertions(+)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 4f6680d..beedeef 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -213,6 +213,33 @@ struct symbol *map__find_symbol_by_name(struct map *map, const char *name,
 	return dso__find_symbol_by_name(map->dso, map->type, name);
 }
 
+struct symbol *map__find_other_map_symbol(struct map **map_ptr, u64 *ip_ptr,
+					  symbol_filter_t filter)
+{
+	struct map *map = *map_ptr;
+	u64 ip = *ip_ptr;
+	struct map *sym_map = NULL;
+	struct symbol *sym;
+
+	if (ip >= map->start && ip <= map->end)
+		sym_map = map;
+	else if (map->groups)
+		sym_map = map_groups__find(map->groups, map->type, ip);
+
+	if (!sym_map)
+		return NULL;
+
+	ip = sym_map->map_ip(sym_map, ip);
+
+	sym = map__find_symbol(sym_map, ip, filter);
+	if (sym) {
+		*map_ptr = sym_map;
+		*ip_ptr = ip;
+	}
+
+	return sym;
+}
+
 struct map *map__clone(struct map *map)
 {
 	return memdup(map, sizeof(*map));
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 4886ca2..b7b494c 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -106,6 +106,8 @@ struct symbol *map__find_symbol(struct map *map,
 				u64 addr, symbol_filter_t filter);
 struct symbol *map__find_symbol_by_name(struct map *map, const char *name,
 					symbol_filter_t filter);
+struct symbol *map__find_other_map_symbol(struct map **map_ptr, u64 *ip_ptr,
+					  symbol_filter_t filter);
 void map__fixup_start(struct map *map);
 void map__fixup_end(struct map *map);
 
-- 
1.7.11.7

