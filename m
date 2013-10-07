Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab3JGGno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 02:43:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:51044 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004Ab3JGGnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 02:43:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1048,1371106800"; 
   d="scan'208";a="388846086"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V4 5/9] perf tools: fix annotate_browser__callq()
Date: Mon,  7 Oct 2013 09:50:14 +0300
Message-Id: <1381128618-22721-6-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381128618-22721-1-git-send-email-adrian.hunter@intel.com>
References: <1381128618-22721-1-git-send-email-adrian.hunter@intel.com>
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
 tools/perf/ui/browsers/annotate.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 08545ae..d9edb35 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -445,14 +445,16 @@ static bool annotate_browser__callq(struct annotate_browser *browser,
 	struct symbol *sym = ms->sym;
 	struct annotation *notes;
 	struct symbol *target;
+	struct map *map;
 	u64 ip;
 	char title[SYM_TITLE_MAX_SIZE];
 
 	if (!ins__is_call(dl->ins))
 		return false;
 
-	ip = ms->map->map_ip(ms->map, dl->ops.target.addr);
-	target = map__find_symbol(ms->map, ip, NULL);
+	map = ms->map;
+	ip = dl->ops.target.addr;
+	target = map__find_other_map_symbol(&map, &ip, NULL);
 	if (target == NULL) {
 		ui_helpline__puts("The called function was not found.");
 		return true;
@@ -469,8 +471,8 @@ static bool annotate_browser__callq(struct annotate_browser *browser,
 	}
 
 	pthread_mutex_unlock(&notes->lock);
-	symbol__tui_annotate(target, ms->map, evsel, hbt);
-	sym_title(sym, ms->map, title, sizeof(title));
+	symbol__tui_annotate(target, map, evsel, hbt);
+	sym_title(sym, map, title, sizeof(title));
 	ui_browser__show_title(&browser->b, title);
 	return true;
 }
-- 
1.7.11.7

