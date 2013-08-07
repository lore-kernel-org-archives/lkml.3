Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab3HGLfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 07:35:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:29189 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757500Ab3HGLd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:33:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,832,1367996400"; 
   d="scan'208";a="383214841"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V4 12/13] perf tools: remove nop at end of annotation
Date: Wed,  7 Aug 2013 14:38:56 +0300
Message-Id: <1375875537-4509-13-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375875537-4509-1-git-send-email-adrian.hunter@intel.com>
References: <1375875537-4509-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When kcore is used for annotation, symbols do not
have correct sizes because they come from kallsyms.
That sometimes results in an extra nop being seen
after the end of a function.  Remove it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
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
1.7.11.7

