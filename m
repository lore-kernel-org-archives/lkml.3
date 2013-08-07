Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684Ab3HGVTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:19:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47323 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933652Ab3HGVTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:19:37 -0400
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
Subject: [PATCH 34/47] perf annotate: Put dso name in symbol annotation title
Date: Wed,  7 Aug 2013 18:11:01 -0300
Message-Id: <1375909874-22073-35-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Currently the symbol name is displayed at the top when displaying symbol
annotation.  Add to this the dso long name.

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
Link: http://lkml.kernel.org/r/1375875537-4509-12-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index cc64d3f..0f88a77 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -428,6 +428,14 @@ static void annotate_browser__init_asm_mode(struct annotate_browser *browser)
 	browser->b.nr_entries = browser->nr_asm_entries;
 }
 
+#define SYM_TITLE_MAX_SIZE (PATH_MAX + 64)
+
+static int sym_title(struct symbol *sym, struct map *map, char *title,
+		     size_t sz)
+{
+	return snprintf(title, sz, "%s  %s", sym->name, map->dso->long_name);
+}
+
 static bool annotate_browser__callq(struct annotate_browser *browser,
 				    struct perf_evsel *evsel,
 				    struct hist_browser_timer *hbt)
@@ -438,6 +446,7 @@ static bool annotate_browser__callq(struct annotate_browser *browser,
 	struct annotation *notes;
 	struct symbol *target;
 	u64 ip;
+	char title[SYM_TITLE_MAX_SIZE];
 
 	if (!ins__is_call(dl->ins))
 		return false;
@@ -461,7 +470,8 @@ static bool annotate_browser__callq(struct annotate_browser *browser,
 
 	pthread_mutex_unlock(&notes->lock);
 	symbol__tui_annotate(target, ms->map, evsel, hbt);
-	ui_browser__show_title(&browser->b, sym->name);
+	sym_title(sym, ms->map, title, sizeof(title));
+	ui_browser__show_title(&browser->b, title);
 	return true;
 }
 
@@ -653,8 +663,10 @@ static int annotate_browser__run(struct annotate_browser *browser,
 	const char *help = "Press 'h' for help on key bindings";
 	int delay_secs = hbt ? hbt->refresh : 0;
 	int key;
+	char title[SYM_TITLE_MAX_SIZE];
 
-	if (ui_browser__show(&browser->b, sym->name, help) < 0)
+	sym_title(sym, ms->map, title, sizeof(title));
+	if (ui_browser__show(&browser->b, title, help) < 0)
 		return -1;
 
 	annotate_browser__calc_percent(browser, evsel);
-- 
1.8.1.4

