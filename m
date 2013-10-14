Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab3JNKps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 06:45:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:3800 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756213Ab3JNKpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 06:45:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,491,1378882800"; 
   d="scan'208";a="374383864"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V7 7/7] perf tools: another fix for annotate_browser__callq()
Date: Mon, 14 Oct 2013 13:43:44 +0300
Message-Id: <1381747424-3557-8-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381747424-3557-1-git-send-email-adrian.hunter@intel.com>
References: <1381747424-3557-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The target address is provided by objdump and is not
necessary a memory address.  Add a helper to get the
correct address.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/ui/browsers/annotate.c |  7 +++++--
 tools/perf/util/map.c             | 31 ++++++++++++++++++++++++++++++-
 tools/perf/util/map.h             |  3 +++
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 57d3a86..f0697a3 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -445,14 +445,17 @@ static bool annotate_browser__callq(struct annotate_browser *browser,
 	struct annotation *notes;
 	struct addr_map_symbol target = {
 		.map = ms->map,
-		.addr = dl->ops.target.addr,
+		.addr = map__objdump_2mem(ms->map, dl->ops.target.addr),
 	};
 	char title[SYM_TITLE_MAX_SIZE];
 
 	if (!ins__is_call(dl->ins))
 		return false;
 
-	if (map_groups__find_ams(&target, NULL)) {
+	if (map_groups__find_ams(&target, NULL) ||
+	    map__rip_2objdump(target.map, target.map->map_ip(target.map,
+							     target.addr)) !=
+	    dl->ops.target.addr) {
 		ui_helpline__puts("The called function was not found.");
 		return true;
 	}
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 9dea404..ef5bc91 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -252,10 +252,16 @@ size_t map__fprintf_dsoname(struct map *map, FILE *fp)
 	return fprintf(fp, "%s", dsoname);
 }
 
-/*
+/**
+ * map__rip_2objdump - convert symbol start address to objdump address.
+ * @map: memory map
+ * @rip: symbol start address
+ *
  * objdump wants/reports absolute IPs for ET_EXEC, and RIPs for ET_DYN.
  * map->dso->adjust_symbols==1 for ET_EXEC-like cases except ET_REL which is
  * relative to section start.
+ *
+ * Return: Address suitable for passing to "objdump --start-address="
  */
 u64 map__rip_2objdump(struct map *map, u64 rip)
 {
@@ -268,6 +274,29 @@ u64 map__rip_2objdump(struct map *map, u64 rip)
 	return map->unmap_ip(map, rip);
 }
 
+/**
+ * map__objdump_2mem - convert objdump address to a memory address.
+ * @map: memory map
+ * @ip: objdump address
+ *
+ * Closely related to map__rip_2objdump(), this function takes an address from
+ * objdump and converts it to a memory address.  Note this assumes that @map
+ * contains the address.  To be sure the result is valid, check it forwards
+ * e.g. map__rip_2objdump(map->map_ip(map, map__objdump_2mem(map, ip))) == ip
+ *
+ * Return: Memory address.
+ */
+u64 map__objdump_2mem(struct map *map, u64 ip)
+{
+	if (!map->dso->adjust_symbols)
+		return map->unmap_ip(map, ip);
+
+	if (map->dso->rel)
+		return map->unmap_ip(map, ip + map->pgoff);
+
+	return ip;
+}
+
 void map_groups__init(struct map_groups *mg)
 {
 	int i;
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 0359b4a..e4e259c 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -84,6 +84,9 @@ static inline u64 identity__map_ip(struct map *map __maybe_unused, u64 ip)
 /* rip/ip <-> addr suitable for passing to `objdump --start-address=` */
 u64 map__rip_2objdump(struct map *map, u64 rip);
 
+/* objdump address -> memory address */
+u64 map__objdump_2mem(struct map *map, u64 ip);
+
 struct symbol;
 
 typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
-- 
1.7.11.7

