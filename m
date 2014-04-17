Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbaDQHxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 03:53:33 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54777 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaDQHx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 03:53:29 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 2/3] perf ui/tui: Fix off-by-one in hist_browser__update_nr_entries()
Date: Thu, 17 Apr 2014 16:53:25 +0900
Message-Id: <1397721206-15393-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397721206-15393-1-git-send-email-namhyung@kernel.org>
References: <1397721206-15393-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nr_entries variable is increased inside the loop in the function
but it also counts when hists__filter_entries() returns NULL.  Thus
the end result will have actual count + 1.

It'd become a problem especially there's no entry at all - it'd get a
segfault during referencing a NULL pointer.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 4d416984c59d..e86b95cc55db 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1349,9 +1349,10 @@ static void hist_browser__update_pcnt_entries(struct hist_browser *hb)
 	struct rb_node *nd = rb_first(&hb->hists->entries);
 
 	while (nd) {
-		nr_entries++;
 		nd = hists__filter_entries(rb_next(nd), hb->hists,
 					   hb->min_pcnt);
+		if (nd)
+			nr_entries++;
 	}
 
 	hb->nr_pcnt_entries = nr_entries;
-- 
1.9.2

