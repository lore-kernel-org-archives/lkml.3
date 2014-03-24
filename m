Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbaCXThG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:37:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197AbaCXTfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:35:22 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net, peterz@infradead.org
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com, andi.kleen@intel.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 6/6] perf, sort:  Allow unique sorting instead of combining hist_entries
Date: Mon, 24 Mar 2014 15:34:36 -0400
Message-Id: <1395689676-214799-7-git-send-email-dzickus@redhat.com>
In-Reply-To: <1395689676-214799-1-git-send-email-dzickus@redhat.com>
References: <1395689676-214799-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cache contention tools needs to keep all the perf records unique in order
to properly parse all the data.  Currently add_hist_entry() will combine
the duplicate record and add the weight/period to the existing record.

This throws away the unique data the cache contention tool needs (mainly
the data source).  Create a flag to force the records to stay unique.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/util/hist.c | 3 ++-
 tools/perf/util/sort.c | 1 +
 tools/perf/util/sort.h | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 81f47ee..69d2cb9 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -378,7 +378,8 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 		 */
 		cmp = hist_entry__cmp(he, entry);
 
-		if (!cmp) {
+		if (!cmp && !sort__wants_unique) {
+
 			he_stat__add_period(&he->stat, period, weight);
 
 			/*
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index be675f4..ca86b23 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -15,6 +15,7 @@ int		sort__need_collapse = 0;
 int		sort__has_parent = 0;
 int		sort__has_sym = 0;
 int		sort__has_dso = 0;
+int		sort__wants_unique = 0;
 enum sort_mode	sort__mode = SORT_MODE__NORMAL;
 
 enum sort_type	sort__first_dimension;
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index b1f52a8..b005445 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -33,6 +33,7 @@ extern int have_ignore_callees;
 extern int sort__need_collapse;
 extern int sort__has_parent;
 extern int sort__has_sym;
+extern int sort__wants_unique;
 extern enum sort_mode sort__mode;
 extern struct sort_entry sort_comm;
 extern struct sort_entry sort_dso;
-- 
1.7.11.7

