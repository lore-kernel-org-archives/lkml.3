Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab3HGLfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 07:35:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:29189 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757543Ab3HGLd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:33:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,832,1367996400"; 
   d="scan'208";a="383214836"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V4 11/13] perf tools: put dso name in symbol annotation title
Date: Wed,  7 Aug 2013 14:38:55 +0300
Message-Id: <1375875537-4509-12-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375875537-4509-1-git-send-email-adrian.hunter@intel.com>
References: <1375875537-4509-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the symbol name is displayed at the top
when displaying symbol annotation.  Add to this
the dso long name.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
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
1.7.11.7

