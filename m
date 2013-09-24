Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab3IXMJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:09:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:37644 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab3IXMJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:09:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,970,1371106800"; 
   d="scan'208";a="364821562"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V3 06/10] perf tools: fix annotate_browser__callq()
Date: Tue, 24 Sep 2013 15:15:48 +0300
Message-Id: <1380024952-29387-7-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1380024952-29387-1-git-send-email-adrian.hunter@intel.com>
References: <1380024952-29387-1-git-send-email-adrian.hunter@intel.com>
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

