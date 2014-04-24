Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbaDXPnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:43:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758235AbaDXPlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:41:04 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 08/11] perf ui/tui: Fix off-by-one in hist_browser__update_nr_entries()
Date: Thu, 24 Apr 2014 17:40:42 +0200
Message-Id: <1398354045-16505-9-git-send-email-jolsa@kernel.org>
In-Reply-To: <1398354045-16505-1-git-send-email-jolsa@kernel.org>
References: <1398354045-16505-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The nr_entries variable is increased inside the loop in the function
but it always count the first entry regardless of it's filtered or
not; caused an off-by-one error.

It'd become a problem especially there's no entry at all - it'd get a
segfault during referencing a NULL pointer.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1398327843-31845-9-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 4d41698..311226e 100644
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
1.8.3.1

