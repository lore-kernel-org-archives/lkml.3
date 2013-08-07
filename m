Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530Ab3HGVN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:13:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47107 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933419Ab3HGVLc (ORCPT
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
Subject: [PATCH 35/47] perf annotate: Remove nop at end of annotation
Date: Wed,  7 Aug 2013 18:11:02 -0300
Message-Id: <1375909874-22073-36-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

When kcore is used for annotation, symbols do not have correct sizes
because they come from kallsyms, that has only its start address, with
the end address being the next symbol's minus one.

That sometimes results in an extra nop being seen after the end of a
function.  Remove it.

Suggested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
Link: http://lkml.kernel.org/r/1375875537-4509-13-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 4ab2f11..646e38d 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -830,6 +830,30 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 	return 0;
 }
 
+static void delete_last_nop(struct symbol *sym)
+{
+	struct annotation *notes = symbol__annotation(sym);
+	struct list_head *list = &notes->src->source;
+	struct disasm_line *dl;
+
+	while (!list_empty(list)) {
+		dl = list_entry(list->prev, struct disasm_line, node);
+
+		if (dl->ins && dl->ins->ops) {
+			if (dl->ins->ops != &nop_ops)
+				return;
+		} else {
+			if (!strstr(dl->line, " nop ") &&
+			    !strstr(dl->line, " nopl ") &&
+			    !strstr(dl->line, " nopw "))
+				return;
+		}
+
+		list_del(&dl->node);
+		disasm_line__free(dl);
+	}
+}
+
 int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize)
 {
 	struct dso *dso = map->dso;
@@ -923,6 +947,13 @@ fallback:
 		if (symbol__parse_objdump_line(sym, map, file, privsize) < 0)
 			break;
 
+	/*
+	 * kallsyms does not have symbol sizes so there may a nop at the end.
+	 * Remove it.
+	 */
+	if (dso__is_kcore(dso))
+		delete_last_nop(sym);
+
 	pclose(file);
 out_free_filename:
 	if (free_filename)
-- 
1.8.1.4

