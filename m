Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbaEUNNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 09:13:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbaEUNNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 09:13:09 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 13/22] perf report/tui: Fix a bug when --fields/sort is given
Date: Wed, 21 May 2014 15:12:35 +0200
Message-Id: <1400677964-25160-14-git-send-email-jolsa@kernel.org>
In-Reply-To: <1400677964-25160-1-git-send-email-jolsa@kernel.org>
References: <1400677964-25160-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The hists__filter_entries() function is called when down arrow key is
pressed for navigating through the entries in TUI.  It has a check for
filtering out entries that have very small overhead (under min_pcnt).

However it just assumed the entries are sorted by the overhead so when
it saw such a small overheaded entry, it just stopped navigating as an
optimization.  But it's not true anymore due to new --fields and
--sort optoin behavior and this case users cannot go down to a next
entry if ther's an entry with small overhead in-between.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1400480762-22852-14-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 92d128f..169224c 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -812,10 +812,7 @@ static struct rb_node *hists__filter_entries(struct rb_node *nd,
 		if (total)
 			percent = h->stat.period * 100.0 / total;
 
-		if (percent < min_pcnt)
-			return NULL;
-
-		if (!h->filtered)
+		if (!h->filtered && percent >= min_pcnt)
 			return nd;
 
 		nd = rb_next(nd);
-- 
1.8.3.1

