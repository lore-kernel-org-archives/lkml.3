Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbaCDCnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 21:43:12 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56494 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144AbaCDCmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 21:42:24 -0500
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 10/10] perf tools: Add ->sort() member to struct sort_entry
Date: Tue,  4 Mar 2014 11:42:16 +0900
Message-Id: <1393900936-22977-11-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1393900936-22977-1-git-send-email-namhyung@kernel.org>
References: <1393900936-22977-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, what the sort_entry does is just identifying hist entries
so that they can be grouped properly.  However, with -F option
support, it indeed needs to sort entries appropriately to be shown to
users.  So add ->sort() member to do it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 23 ++++++++++++++++++++---
 tools/perf/util/sort.h |  1 +
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 39f8f36fc37a..b55ff6d615d3 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -95,6 +95,12 @@ sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
 	return comm__str(right->comm) - comm__str(left->comm);
 }
 
+static int64_t
+sort__comm_sort(struct hist_entry *left, struct hist_entry *right)
+{
+	return strcmp(comm__str(right->comm), comm__str(left->comm));
+}
+
 static int hist_entry__comm_snprintf(struct hist_entry *he, char *bf,
 				     size_t size, unsigned int width)
 {
@@ -105,6 +111,7 @@ struct sort_entry sort_comm = {
 	.se_header	= "Command",
 	.se_cmp		= sort__comm_cmp,
 	.se_collapse	= sort__comm_collapse,
+	.se_sort	= sort__comm_sort,
 	.se_snprintf	= hist_entry__comm_snprintf,
 	.se_width_idx	= HISTC_COMM,
 };
@@ -134,7 +141,7 @@ static int64_t _sort__dso_cmp(struct map *map_l, struct map *map_r)
 static int64_t
 sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	return _sort__dso_cmp(left->ms.map, right->ms.map);
+	return _sort__dso_cmp(right->ms.map, left->ms.map);
 }
 
 static int _hist_entry__dso_snprintf(struct map *map, char *bf,
@@ -206,6 +213,15 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 	return _sort__sym_cmp(left->ms.sym, right->ms.sym);
 }
 
+static int64_t
+sort__sym_sort(struct hist_entry *left, struct hist_entry *right)
+{
+	if (!left->ms.sym || !right->ms.sym)
+		return cmp_null(left->ms.sym, right->ms.sym);
+
+	return strcmp(right->ms.sym->name, left->ms.sym->name);
+}
+
 static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
 				     u64 ip, char level, char *bf, size_t size,
 				     unsigned int width)
@@ -252,6 +268,7 @@ static int hist_entry__sym_snprintf(struct hist_entry *he, char *bf,
 struct sort_entry sort_sym = {
 	.se_header	= "Symbol",
 	.se_cmp		= sort__sym_cmp,
+	.se_sort	= sort__sym_sort,
 	.se_snprintf	= hist_entry__sym_snprintf,
 	.se_width_idx	= HISTC_SYMBOL,
 };
@@ -279,7 +296,7 @@ sort__srcline_cmp(struct hist_entry *left, struct hist_entry *right)
 					    map__rip_2objdump(map, right->ip));
 		}
 	}
-	return strcmp(left->srcline, right->srcline);
+	return strcmp(right->srcline, left->srcline);
 }
 
 static int hist_entry__srcline_snprintf(struct hist_entry *he, char *bf,
@@ -307,7 +324,7 @@ sort__parent_cmp(struct hist_entry *left, struct hist_entry *right)
 	if (!sym_l || !sym_r)
 		return cmp_null(sym_l, sym_r);
 
-	return strcmp(sym_l->name, sym_r->name);
+	return strcmp(sym_r->name, sym_l->name);
 }
 
 static int hist_entry__parent_snprintf(struct hist_entry *he, char *bf,
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index ba65741783fa..1d8d80376e97 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -180,6 +180,7 @@ struct sort_entry {
 
 	int64_t (*se_cmp)(struct hist_entry *, struct hist_entry *);
 	int64_t (*se_collapse)(struct hist_entry *, struct hist_entry *);
+	int64_t	(*se_sort)(struct hist_entry *, struct hist_entry *);
 	int	(*se_snprintf)(struct hist_entry *he, char *bf, size_t size,
 			       unsigned int width);
 	u8	se_width_idx;
-- 
1.7.11.7

