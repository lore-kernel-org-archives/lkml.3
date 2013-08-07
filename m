Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557Ab3HGVN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:13:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47105 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933417Ab3HGVLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:11:32 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 36/47] perf annotate: Add call target name if it is missing
Date: Wed,  7 Aug 2013 18:11:03 -0300
Message-Id: <1375909874-22073-37-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

The /proc/kcore file has no symbols, so the call target name does not
display.  Fix by looking up the symbol name if it is on the same map.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375875537-4509-14-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.8.1.4

