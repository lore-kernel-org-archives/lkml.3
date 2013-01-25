Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab3AYKsD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:48:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40934 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab3AYKr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:47:58 -0500
Date: Fri, 25 Jan 2013 02:47:21 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-9afcf930b1fa1158b0878afeba3eff299300dc65@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1355128197-18193-2-git-send-email-namhyung@kernel.org>
References: <1355128197-18193-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists:
  Exchange order of comparing items when collapsing hists
Git-Commit-ID: 9afcf930b1fa1158b0878afeba3eff299300dc65
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 02:47:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9afcf930b1fa1158b0878afeba3eff299300dc65
Gitweb:     http://git.kernel.org/tip/9afcf930b1fa1158b0878afeba3eff299300dc65
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 10 Dec 2012 17:29:54 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:05 -0300

perf hists: Exchange order of comparing items when collapsing hists

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
