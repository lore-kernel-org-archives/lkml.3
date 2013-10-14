Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab3JNKpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 06:45:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:45722 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755747Ab3JNKpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 06:45:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,491,1378882800"; 
   d="scan'208";a="374383684"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V7 2/7] perf tools: fix annotate_browser__callq()
Date: Mon, 14 Oct 2013 13:43:39 +0300
Message-Id: <1381747424-3557-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381747424-3557-1-git-send-email-adrian.hunter@intel.com>
References: <1381747424-3557-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When following a call, annotate_browser__callq()
uses the current symbol's map to look up the
target ip.  That will not work if the target ip
is on a map with a different mapping (i.e.
start - pgoff is different).

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/ui/browsers/annotate.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 08545ae..57d3a86 100644
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
1.7.11.7

