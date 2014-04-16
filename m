Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbaDPDGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 23:06:24 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:60091 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaDPDF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 23:05:58 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 12/17] perf tools: Add ->sort() member to struct sort_entry
Date: Wed, 16 Apr 2014 12:05:49 +0900
Message-Id: <1397617554-26319-13-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
References: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, what the sort_entry does is just identifying hist entries
so that they can be grouped properly.  However, with -F option
support, it indeed needs to sort entries appropriately to be shown to
users.  So add ->sort() member to do it.

Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 27 ++++++++++++++++++++++-----
 tools/perf/util/sort.h |  1 +
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 639dd49f2884..1e7b80e517d5 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -98,6 +98,12 @@ sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
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
@@ -108,6 +114,7 @@ struct sort_entry sort_comm = {
 	.se_header	= "Command",
 	.se_cmp		= sort__comm_cmp,
 	.se_collapse	= sort__comm_collapse,
+	.se_sort	= sort__comm_sort,
 	.se_snprintf	= hist_entry__comm_snprintf,
 	.se_width_idx	= HISTC_COMM,
 };
@@ -121,7 +128,7 @@ static int64_t _sort__dso_cmp(struct map *map_l, struct map *map_r)
 	const char *dso_name_l, *dso_name_r;
 
 	if (!dso_l || !dso_r)
-		return cmp_null(dso_l, dso_r);
+		return cmp_null(dso_r, dso_l);
 
 	if (verbose) {
 		dso_name_l = dso_l->long_name;
@@ -137,7 +144,7 @@ static int64_t _sort__dso_cmp(struct map *map_l, struct map *map_r)
 static int64_t
 sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	return _sort__dso_cmp(left->ms.map, right->ms.map);
+	return _sort__dso_cmp(right->ms.map, left->ms.map);
 }
 
 static int _hist_entry__dso_snprintf(struct map *map, char *bf,
@@ -209,6 +216,15 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
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
@@ -255,6 +271,7 @@ static int hist_entry__sym_snprintf(struct hist_entry *he, char *bf,
 struct sort_entry sort_sym = {
 	.se_header	= "Symbol",
 	.se_cmp		= sort__sym_cmp,
+	.se_sort	= sort__sym_sort,
 	.se_snprintf	= hist_entry__sym_snprintf,
 	.se_width_idx	= HISTC_SYMBOL,
 };
@@ -282,7 +299,7 @@ sort__srcline_cmp(struct hist_entry *left, struct hist_entry *right)
 					    map__rip_2objdump(map, right->ip));
 		}
 	}
-	return strcmp(left->srcline, right->srcline);
+	return strcmp(right->srcline, left->srcline);
 }
 
 static int hist_entry__srcline_snprintf(struct hist_entry *he, char *bf,
@@ -310,7 +327,7 @@ sort__parent_cmp(struct hist_entry *left, struct hist_entry *right)
 	if (!sym_l || !sym_r)
 		return cmp_null(sym_l, sym_r);
 
-	return strcmp(sym_l->name, sym_r->name);
+	return strcmp(sym_r->name, sym_l->name);
 }
 
 static int hist_entry__parent_snprintf(struct hist_entry *he, char *bf,
@@ -1125,7 +1142,7 @@ __sort_dimension__alloc_hpp(struct sort_dimension *sd)
 
 	hse->hpp.cmp = sd->entry->se_cmp;
 	hse->hpp.collapse = sd->entry->se_collapse ? : sd->entry->se_cmp;
-	hse->hpp.sort = hse->hpp.collapse;
+	hse->hpp.sort = sd->entry->se_sort ? : hse->hpp.collapse;
 
 	INIT_LIST_HEAD(&hse->hpp.list);
 	INIT_LIST_HEAD(&hse->hpp.sort_list);
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 02706c9766d6..cd679a56c81d 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -181,6 +181,7 @@ struct sort_entry {
 
 	int64_t (*se_cmp)(struct hist_entry *, struct hist_entry *);
 	int64_t (*se_collapse)(struct hist_entry *, struct hist_entry *);
+	int64_t	(*se_sort)(struct hist_entry *, struct hist_entry *);
 	int	(*se_snprintf)(struct hist_entry *he, char *bf, size_t size,
 			       unsigned int width);
 	u8	se_width_idx;
-- 
1.9.2

