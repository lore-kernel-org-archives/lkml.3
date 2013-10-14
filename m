Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab3JNUEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:04:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39157 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520Ab3JNUDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 157/161] perf annotate: Fix annotate_browser__callq()
Date: Mon, 14 Oct 2013 17:02:26 -0300
Message-Id: <1381780950-25642-158-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

When following a call, annotate_browser__callq() uses the current
symbol's map to look up the target ip.  That will not work if the target
ip is on a map with a different mapping (i.e.  start - pgoff is
different).

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1381747424-3557-3-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 08545ae46992..57d3a8659fc0 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -442,35 +442,34 @@ static bool annotate_browser__callq(struct annotate_browser *browser,
 {
 	struct map_symbol *ms = browser->b.priv;
 	struct disasm_line *dl = browser->selection;
-	struct symbol *sym = ms->sym;
 	struct annotation *notes;
-	struct symbol *target;
-	u64 ip;
+	struct addr_map_symbol target = {
+		.map = ms->map,
+		.addr = dl->ops.target.addr,
+	};
 	char title[SYM_TITLE_MAX_SIZE];
 
 	if (!ins__is_call(dl->ins))
 		return false;
 
-	ip = ms->map->map_ip(ms->map, dl->ops.target.addr);
-	target = map__find_symbol(ms->map, ip, NULL);
-	if (target == NULL) {
+	if (map_groups__find_ams(&target, NULL)) {
 		ui_helpline__puts("The called function was not found.");
 		return true;
 	}
 
-	notes = symbol__annotation(target);
+	notes = symbol__annotation(target.sym);
 	pthread_mutex_lock(&notes->lock);
 
-	if (notes->src == NULL && symbol__alloc_hist(target) < 0) {
+	if (notes->src == NULL && symbol__alloc_hist(target.sym) < 0) {
 		pthread_mutex_unlock(&notes->lock);
 		ui__warning("Not enough memory for annotating '%s' symbol!\n",
-			    target->name);
+			    target.sym->name);
 		return true;
 	}
 
 	pthread_mutex_unlock(&notes->lock);
-	symbol__tui_annotate(target, ms->map, evsel, hbt);
-	sym_title(sym, ms->map, title, sizeof(title));
+	symbol__tui_annotate(target.sym, target.map, evsel, hbt);
+	sym_title(ms->sym, ms->map, title, sizeof(title));
 	ui_browser__show_title(&browser->b, title);
 	return true;
 }
-- 
1.8.1.4

