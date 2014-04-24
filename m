Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbaDXIYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:24:20 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:38655 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbaDXIYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:24:11 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 08/11] perf ui/tui: Fix off-by-one in hist_browser__update_nr_entries()
Date: Thu, 24 Apr 2014 17:24:00 +0900
Message-Id: <1398327843-31845-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398327843-31845-1-git-send-email-namhyung@kernel.org>
References: <1398327843-31845-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nr_entries variable is increased inside the loop in the function
but it always count the first entry regardless of it's filtered or
not; caused an off-by-one error.

It'd become a problem especially there's no entry at all - it'd get a
segfault during referencing a NULL pointer.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 4d416984c59d..311226edae12 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1348,10 +1348,10 @@ static void hist_browser__update_pcnt_entries(struct hist_browser *hb)
 	u64 nr_entries = 0;
 	struct rb_node *nd = rb_first(&hb->hists->entries);
 
-	while (nd) {
+	while ((nd = hists__filter_entries(nd, hb->hists,
+					   hb->min_pcnt)) != NULL) {
 		nr_entries++;
-		nd = hists__filter_entries(rb_next(nd), hb->hists,
-					   hb->min_pcnt);
+		nd = rb_next(nd);
 	}
 
 	hb->nr_pcnt_entries = nr_entries;
-- 
1.9.2

