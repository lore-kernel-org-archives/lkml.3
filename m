Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965614AbaLLKPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 05:15:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934677AbaLLKPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:15:20 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] perf tools: Fix bare address display value of callchain entries
Date: Fri, 12 Dec 2014 11:14:58 +0100
Message-Id: <1418379298-29176-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case we don't have symbol to display we display bare
'unmapped' address. This was unintentionally changed in
recent commit:
  5550171b2a9f perf callchain: Use al.addr to set up call chain

Putting the original way back.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/callchain.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 64b377e591e4..a4fb25fb26f5 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -816,22 +816,30 @@ out:
 char *callchain_list__sym_name(struct callchain_list *cl,
 			       char *bf, size_t bfsize, bool show_dso)
 {
+	struct map *map = cl->ms.map;
 	int printed;
 
 	if (cl->ms.sym) {
 		if (callchain_param.key == CCKEY_ADDRESS &&
-		    cl->ms.map && !cl->srcline)
-			cl->srcline = get_srcline(cl->ms.map->dso,
-						  map__rip_2objdump(cl->ms.map,
-								    cl->ip),
+		    map && !cl->srcline) {
+			cl->srcline = get_srcline(map->dso,
+						  map__rip_2objdump(map, cl->ip),
 						  cl->ms.sym, false);
+		}
 		if (cl->srcline)
 			printed = scnprintf(bf, bfsize, "%s %s",
 					cl->ms.sym->name, cl->srcline);
 		else
 			printed = scnprintf(bf, bfsize, "%s", cl->ms.sym->name);
-	} else
-		printed = scnprintf(bf, bfsize, "%#" PRIx64, cl->ip);
+	} else {
+		/*
+		 * The cl->ip value is unbased ip (applied map->map_ip).
+		 * Display the unmap ip in case we have no symbol.
+		 */
+		u64 addr = map ? map->unmap_ip(map, cl->ip) : cl->ip;
+
+		printed = scnprintf(bf, bfsize, "%#" PRIx64, addr);
+	}
 
 	if (show_dso)
 		scnprintf(bf + printed, bfsize - printed, " %s",
-- 
1.9.3

