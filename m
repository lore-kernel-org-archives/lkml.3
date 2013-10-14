Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961Ab3JNUEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:04:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39159 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757847Ab3JNUDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 159/161] perf annotate: Another fix for annotate_browser__callq()
Date: Mon, 14 Oct 2013 17:02:28 -0300
Message-Id: <1381780950-25642-160-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

The target address is provided by objdump and is not necessary a memory
address.  Add a helper to get the correct address.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1381747424-3557-8-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |  7 +++++--
 tools/perf/util/map.c             | 31 ++++++++++++++++++++++++++++++-
 tools/perf/util/map.h             |  3 +++
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 57d3a8659fc0..f0697a3aede0 100644
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
index 9dea404de3fa..ef5bc913ca7a 100644
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
index 0359b4a808f0..e4e259c3ba16 100644
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
1.8.1.4

