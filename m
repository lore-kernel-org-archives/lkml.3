Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934149AbaCSNIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:08:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34269 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933851AbaCSNIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:08:49 -0400
Date: Wed, 19 Mar 2014 06:07:58 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-n1r51l329434js84qtb2c6l9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate:
  Print the evsel name in the stdio output
Git-Commit-ID: 9cdbadceca31bf2ccd9e50fecdc5591d3fb8dae3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9cdbadceca31bf2ccd9e50fecdc5591d3fb8dae3
Gitweb:     http://git.kernel.org/tip/9cdbadceca31bf2ccd9e50fecdc5591d3fb8dae3
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 18 Mar 2014 11:50:21 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Mar 2014 18:17:03 -0300

perf annotate: Print the evsel name in the stdio output

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
index 3aa555f..809b4c5 100644
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
