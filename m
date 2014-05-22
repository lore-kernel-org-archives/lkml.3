Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964876AbaEVMWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:22:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50996 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964844AbaEVMWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:22:48 -0400
Date: Thu, 22 May 2014 05:22:37 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-202e7a6d16127323d03e912d7844aa0d614c315e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1400480762-22852-13-git-send-email-namhyung@kernel.org>
References: <1400480762-22852-13-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add ->sort()
  member to struct sort_entry
Git-Commit-ID: 202e7a6d16127323d03e912d7844aa0d614c315e
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

Commit-ID:  202e7a6d16127323d03e912d7844aa0d614c315e
Gitweb:     http://git.kernel.org/tip/202e7a6d16127323d03e912d7844aa0d614c315e
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 4 Mar 2014 11:01:41 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Wed, 21 May 2014 11:45:35 +0200

perf tools: Add ->sort() member to struct sort_entry

Currently, what the sort_entry does is just identifying hist entries
so that they can be grouped properly.  However, with -F option
support, it indeed needs to sort entries appropriately to be shown to
users.  So add ->sort() member to do it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1400480762-22852-13-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/sort.c | 27 ++++++++++++++++++++++-----
 tools/perf/util/sort.h |  1 +
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index b748b02..5414ba5 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -99,6 +99,12 @@ sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
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
@@ -109,6 +115,7 @@ struct sort_entry sort_comm = {
 	.se_header	= "Command",
 	.se_cmp		= sort__comm_cmp,
 	.se_collapse	= sort__comm_collapse,
+	.se_sort	= sort__comm_sort,
 	.se_snprintf	= hist_entry__comm_snprintf,
 	.se_width_idx	= HISTC_COMM,
 };
@@ -122,7 +129,7 @@ static int64_t _sort__dso_cmp(struct map *map_l, struct map *map_r)
 	const char *dso_name_l, *dso_name_r;
 
 	if (!dso_l || !dso_r)
-		return cmp_null(dso_l, dso_r);
+		return cmp_null(dso_r, dso_l);
 
 	if (verbose) {
 		dso_name_l = dso_l->long_name;
@@ -138,7 +145,7 @@ static int64_t _sort__dso_cmp(struct map *map_l, struct map *map_r)
 static int64_t
 sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	return _sort__dso_cmp(left->ms.map, right->ms.map);
+	return _sort__dso_cmp(right->ms.map, left->ms.map);
 }
 
 static int _hist_entry__dso_snprintf(struct map *map, char *bf,
@@ -210,6 +217,15 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
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
@@ -256,6 +272,7 @@ static int hist_entry__sym_snprintf(struct hist_entry *he, char *bf,
 struct sort_entry sort_sym = {
 	.se_header	= "Symbol",
 	.se_cmp		= sort__sym_cmp,
+	.se_sort	= sort__sym_sort,
 	.se_snprintf	= hist_entry__sym_snprintf,
 	.se_width_idx	= HISTC_SYMBOL,
 };
@@ -283,7 +300,7 @@ sort__srcline_cmp(struct hist_entry *left, struct hist_entry *right)
 					    map__rip_2objdump(map, right->ip));
 		}
 	}
-	return strcmp(left->srcline, right->srcline);
+	return strcmp(right->srcline, left->srcline);
 }
 
 static int hist_entry__srcline_snprintf(struct hist_entry *he, char *bf,
@@ -311,7 +328,7 @@ sort__parent_cmp(struct hist_entry *left, struct hist_entry *right)
 	if (!sym_l || !sym_r)
 		return cmp_null(sym_l, sym_r);
 
-	return strcmp(sym_l->name, sym_r->name);
+	return strcmp(sym_r->name, sym_l->name);
 }
 
 static int hist_entry__parent_snprintf(struct hist_entry *he, char *bf,
@@ -1126,7 +1143,7 @@ __sort_dimension__alloc_hpp(struct sort_dimension *sd)
 
 	hse->hpp.cmp = sd->entry->se_cmp;
 	hse->hpp.collapse = sd->entry->se_collapse ? : sd->entry->se_cmp;
-	hse->hpp.sort = hse->hpp.collapse;
+	hse->hpp.sort = sd->entry->se_sort ? : hse->hpp.collapse;
 
 	INIT_LIST_HEAD(&hse->hpp.list);
 	INIT_LIST_HEAD(&hse->hpp.sort_list);
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 89e5057..f5a831c 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -182,6 +182,7 @@ struct sort_entry {
 
 	int64_t (*se_cmp)(struct hist_entry *, struct hist_entry *);
 	int64_t (*se_collapse)(struct hist_entry *, struct hist_entry *);
+	int64_t	(*se_sort)(struct hist_entry *, struct hist_entry *);
 	int	(*se_snprintf)(struct hist_entry *he, char *bf, size_t size,
 			       unsigned int width);
 	u8	se_width_idx;
