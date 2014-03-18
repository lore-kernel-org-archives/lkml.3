Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933518AbaCRV20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:28:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44438 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933199AbaCRV0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:26:20 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 09/13] perf annotate: Print the evsel name in the stdio output
Date: Tue, 18 Mar 2014 18:26:01 -0300
Message-Id: <1395177965-8879-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1395177965-8879-1-git-send-email-acme@infradead.org>
References: <1395177965-8879-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that when showing multiple events annotations, we can figure out
which is which:

  # perf record -a -e instructions,cycles sleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.826 MB perf.data (~36078 samples) ]
  # perf evlist
  instructions
  cycles
  # perf annotate intel_idle 2> /dev/null | head -1
   Percent |	Source code & Disassembly of vmlinux for instructions
  #

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-n1r51l329434js84qtb2c6l9@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 3aa555ff9d89..809b4c50beae 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1236,6 +1236,7 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map,
 	struct dso *dso = map->dso;
 	char *filename;
 	const char *d_filename;
+	const char *evsel_name = perf_evsel__name(evsel);
 	struct annotation *notes = symbol__annotation(sym);
 	struct disasm_line *pos, *queue = NULL;
 	u64 start = map__rip_2objdump(map, sym->start);
@@ -1243,7 +1244,7 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map,
 	int more = 0;
 	u64 len;
 	int width = 8;
-	int namelen;
+	int namelen, evsel_name_len, graph_dotted_len;
 
 	filename = strdup(dso->long_name);
 	if (!filename)
@@ -1256,14 +1257,17 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map,
 
 	len = symbol__size(sym);
 	namelen = strlen(d_filename);
+	evsel_name_len = strlen(evsel_name);
 
 	if (perf_evsel__is_group_event(evsel))
 		width *= evsel->nr_members;
 
-	printf(" %-*.*s|	Source code & Disassembly of %s\n",
-	       width, width, "Percent", d_filename);
-	printf("-%-*.*s-------------------------------------\n",
-	       width+namelen, width+namelen, graph_dotted_line);
+	printf(" %-*.*s|	Source code & Disassembly of %s for %s\n",
+	       width, width, "Percent", d_filename, evsel_name);
+
+	graph_dotted_len = width + namelen + evsel_name_len;
+	printf("-%-*.*s-----------------------------------------\n",
+	       graph_dotted_len, graph_dotted_len, graph_dotted_line);
 
 	if (verbose)
 		symbol__annotate_hits(sym, evsel);
-- 
1.8.1.4

