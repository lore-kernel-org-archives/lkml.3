Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933619Ab3JOFfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:35:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33928 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932603Ab3JOFfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:35:43 -0400
Date: Mon, 14 Oct 2013 22:35:23 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-1179e11bbb655162e83b33e17a97c45d3fe292da@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1381747424-3557-3-git-send-email-adrian.hunter@intel.com>
References: <1381747424-3557-3-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Fix annotate_browser__callq()
Git-Commit-ID: 1179e11bbb655162e83b33e17a97c45d3fe292da
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:35:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1179e11bbb655162e83b33e17a97c45d3fe292da
Gitweb:     http://git.kernel.org/tip/1179e11bbb655162e83b33e17a97c45d3fe292da
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 14 Oct 2013 13:43:39 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 14 Oct 2013 10:29:27 -0300

perf annotate: Fix annotate_browser__callq()

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
