Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbaELGb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:31:28 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57559 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbaELG3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:29:06 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 13/20] perf report/tui: Fix a bug when --fields/sort is given
Date: Mon, 12 May 2014 15:28:46 +0900
Message-Id: <1399876133-17963-14-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
References: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hists__filter_entries() function is called when down arrow key is
pressed for navigating through the entries in TUI.  It has a check for
filtering out entries that have very small overhead (under min_pcnt).

However it just assumed the entries are sorted by the overhead so when
it saw such a small overheaded entry, it just stopped navigating as an
optimization.  But it's not true anymore due to new --fields and
--sort optoin behavior and this case users cannot go down to a next
entry if ther's an entry with small overhead in-between.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 69c2b0e536ab..20b200f88129 100644
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
1.9.2

