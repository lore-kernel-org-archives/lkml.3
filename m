Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab3JNKrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 06:47:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:5082 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937Ab3JNKon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 06:44:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,491,1378882800"; 
   d="scan'208";a="374383643"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V7 1/7] perf tools: Add map_groups__find_ams()
Date: Mon, 14 Oct 2013 13:43:38 +0300
Message-Id: <1381747424-3557-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381747424-3557-1-git-send-email-adrian.hunter@intel.com>
References: <1381747424-3557-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Add a function to find a symbol using an ip that
might be on a different map.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/map.c | 17 +++++++++++++++++
 tools/perf/util/map.h |  4 ++++
 2 files changed, 21 insertions(+)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 17ee458..9dea404 100644
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
index 4886ca2..0359b4a 100644
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
1.7.11.7

