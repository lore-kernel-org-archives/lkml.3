Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab3HLKXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:23:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48068 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab3HLKW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:22:57 -0400
Date: Mon, 12 Aug 2013 03:22:12 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-34f77abcb34e1da4ee3ca5c5a41b673664eee1fa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1375875537-4509-12-git-send-email-adrian.hunter@intel.com>
References: <1375875537-4509-12-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate:
  Put dso name in symbol annotation title
Git-Commit-ID: 34f77abcb34e1da4ee3ca5c5a41b673664eee1fa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:22:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  34f77abcb34e1da4ee3ca5c5a41b673664eee1fa
Gitweb:     http://git.kernel.org/tip/34f77abcb34e1da4ee3ca5c5a41b673664eee1fa
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 7 Aug 2013 14:38:55 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:35 -0300

perf annotate: Put dso name in symbol annotation title

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
