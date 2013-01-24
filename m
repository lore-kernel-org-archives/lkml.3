Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab3AXUeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:34:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50145 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845Ab3AXUIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:40 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/74] perf hists: Exchange order of comparing items when collapsing hists
Date: Thu, 24 Jan 2013 17:07:10 -0300
Message-Id: <1359058103-31645-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When comparing entries for collapsing put the given entry first, and
then the iterated entry.  This is not the case of hist_entry__cmp() when
called if given sort keys don't require collapsing.  So change the order
for the sake of consistency.  It will be required for matching and/or
linking multiple hist entries.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1355128197-18193-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c |  2 +-
 tools/perf/util/hist.c    | 12 +++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index b2e7d39..4dda6f4 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -285,7 +285,7 @@ static void insert_hist_entry_by_name(struct rb_root *root,
 	while (*p != NULL) {
 		parent = *p;
 		iter = rb_entry(parent, struct hist_entry, rb_node);
-		if (hist_entry__cmp(he, iter) < 0)
+		if (hist_entry__cmp(iter, he) < 0)
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 82df1b2..3a9ccd0 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -285,7 +285,13 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 		parent = *p;
 		he = rb_entry(parent, struct hist_entry, rb_node_in);
 
-		cmp = hist_entry__cmp(entry, he);
+		/*
+		 * Make sure that it receives arguments in a same order as
+		 * hist_entry__collapse() so that we can use an appropriate
+		 * function when searching an entry regardless which sort
+		 * keys were used.
+		 */
+		cmp = hist_entry__cmp(he, entry);
 
 		if (!cmp) {
 			he_stat__add_period(&he->stat, period);
@@ -729,7 +735,7 @@ static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 		parent = *p;
 		he = rb_entry(parent, struct hist_entry, rb_node);
 
-		cmp = hist_entry__cmp(pair, he);
+		cmp = hist_entry__cmp(he, pair);
 
 		if (!cmp)
 			goto out;
@@ -759,7 +765,7 @@ static struct hist_entry *hists__find_entry(struct hists *hists,
 
 	while (n) {
 		struct hist_entry *iter = rb_entry(n, struct hist_entry, rb_node);
-		int64_t cmp = hist_entry__cmp(he, iter);
+		int64_t cmp = hist_entry__cmp(iter, he);
 
 		if (cmp < 0)
 			n = n->rb_left;
-- 
1.8.1.1.361.gec3ae6e

