Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaDYNOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:14:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40524 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbaDYNOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:14:45 -0400
Date: Fri, 25 Apr 2014 06:14:34 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-3186b6815d49b5e0defbd884223da3778edb59fc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1398327843-31845-8-git-send-email-namhyung@kernel.org>
References: <1398327843-31845-8-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists:
  Add missing update on filtered stats in hists__decay_entries()
Git-Commit-ID: 3186b6815d49b5e0defbd884223da3778edb59fc
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

Commit-ID:  3186b6815d49b5e0defbd884223da3778edb59fc
Gitweb:     http://git.kernel.org/tip/3186b6815d49b5e0defbd884223da3778edb59fc
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 22 Apr 2014 13:44:23 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 24 Apr 2014 16:32:44 +0200

perf hists: Add missing update on filtered stats in hists__decay_entries()

When a filter is used for perf top, its hists->nr_non_filtered_entries
was not updated after it removed an entry in hists__decay_entries().
Also hists->stats.total_non_filtered_period was missed too.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1398327843-31845-8-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/hist.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 6d0d2d7..7f0236c 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -225,14 +225,18 @@ static void he_stat__decay(struct he_stat *he_stat)
 static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
 {
 	u64 prev_period = he->stat.period;
+	u64 diff;
 
 	if (prev_period == 0)
 		return true;
 
 	he_stat__decay(&he->stat);
 
+	diff = prev_period - he->stat.period;
+
+	hists->stats.total_period -= diff;
 	if (!he->filtered)
-		hists->stats.total_period -= prev_period - he->stat.period;
+		hists->stats.total_non_filtered_period -= diff;
 
 	return he->stat.period == 0;
 }
@@ -259,8 +263,11 @@ void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
 			if (sort__need_collapse)
 				rb_erase(&n->rb_node_in, &hists->entries_collapsed);
 
-			hist_entry__free(n);
 			--hists->nr_entries;
+			if (!n->filtered)
+				--hists->nr_non_filtered_entries;
+
+			hist_entry__free(n);
 		}
 	}
 }
