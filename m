Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbaDYNPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:15:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40532 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbaDYNO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:14:58 -0400
Date: Fri, 25 Apr 2014 06:14:46 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-c481f9301183260a78e55fa4d70d977b68c81846@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1398327843-31845-9-git-send-email-namhyung@kernel.org>
References: <1398327843-31845-9-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui/tui:
  Fix off-by-one in hist_browser__update_nr_entries()
Git-Commit-ID: c481f9301183260a78e55fa4d70d977b68c81846
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c481f9301183260a78e55fa4d70d977b68c81846
Gitweb:     http://git.kernel.org/tip/c481f9301183260a78e55fa4d70d977b68c81846
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 22 Apr 2014 13:56:11 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 24 Apr 2014 16:33:08 +0200

perf ui/tui: Fix off-by-one in hist_browser__update_nr_entries()

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
