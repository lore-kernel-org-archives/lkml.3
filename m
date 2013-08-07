Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877Ab3HGLeC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 07:34:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:29189 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757554Ab3HGLd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:33:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,832,1367996400"; 
   d="scan'208";a="383214843"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V4 13/13] perf tools: add annotation call target name if it is missing
Date: Wed,  7 Aug 2013 14:38:57 +0300
Message-Id: <1375875537-4509-14-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375875537-4509-1-git-send-email-adrian.hunter@intel.com>
References: <1375875537-4509-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcore has no symbols, so the call target name does not display.
Fix by looking up the symbol name if it is on the same map.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/annotate.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 646e38d..bfc5a27 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -825,6 +825,22 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 		dl->ops.target.offset = dl->ops.target.addr -
 					map__rip_2objdump(map, sym->start);
 
+	/*
+	 * kcore has no symbols, so add the call target name if it is on the
+	 * same map.
+	 */
+	if (dl->ins && ins__is_call(dl->ins) && !dl->ops.target.name) {
+		struct symbol *s;
+		u64 ip = dl->ops.target.addr;
+
+		if (ip >= map->start && ip <= map->end) {
+			ip = map->map_ip(map, ip);
+			s = map__find_symbol(map, ip, NULL);
+			if (s && s->start == ip)
+				dl->ops.target.name = strdup(s->name);
+		}
+	}
+
 	disasm__add(&notes->src->source, dl);
 
 	return 0;
-- 
1.7.11.7

