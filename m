Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630Ab3JOFgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:36:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33945 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932603Ab3JOFgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:36:00 -0400
Date: Mon, 14 Oct 2013 22:35:41 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-1d5077bdd9a10c4297cded139989bb9ee2998a6c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1381747424-3557-8-git-send-email-adrian.hunter@intel.com>
References: <1381747424-3557-8-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate:
  Another fix for annotate_browser__callq()
Git-Commit-ID: 1d5077bdd9a10c4297cded139989bb9ee2998a6c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:35:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d5077bdd9a10c4297cded139989bb9ee2998a6c
Gitweb:     http://git.kernel.org/tip/1d5077bdd9a10c4297cded139989bb9ee2998a6c
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 14 Oct 2013 13:43:44 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 14 Oct 2013 12:21:18 -0300

perf annotate: Another fix for annotate_browser__callq()

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
