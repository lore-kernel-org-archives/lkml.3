Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab3JNKpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 06:45:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:45722 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209Ab3JNKpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 06:45:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,491,1378882800"; 
   d="scan'208";a="374383717"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V7 3/7] perf tools: find kcore symbols on other maps
Date: Mon, 14 Oct 2013 13:43:40 +0300
Message-Id: <1381747424-3557-4-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381747424-3557-1-git-send-email-adrian.hunter@intel.com>
References: <1381747424-3557-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new map__find_other_map_symbol() to
find kcore symbols on other maps.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/annotate.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 882bb86..cf6242c 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -825,20 +825,16 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 		dl->ops.target.offset = dl->ops.target.addr -
 					map__rip_2objdump(map, sym->start);
 
-	/*
-	 * kcore has no symbols, so add the call target name if it is on the
-	 * same map.
-	 */
+	/* kcore has no symbols, so add the call target name */
 	if (dl->ins && ins__is_call(dl->ins) && !dl->ops.target.name) {
-		struct symbol *s;
-		u64 ip = dl->ops.target.addr;
-
-		if (ip >= map->start && ip <= map->end) {
-			ip = map->map_ip(map, ip);
-			s = map__find_symbol(map, ip, NULL);
-			if (s && s->start == ip)
-				dl->ops.target.name = strdup(s->name);
-		}
+		struct addr_map_symbol target = {
+			.map = map,
+			.addr = dl->ops.target.addr,
+		};
+
+		if (!map_groups__find_ams(&target, NULL) &&
+		    target.sym->start == target.al_addr)
+			dl->ops.target.name = strdup(target.sym->name);
 	}
 
 	disasm__add(&notes->src->source, dl);
-- 
1.7.11.7

