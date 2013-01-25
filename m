Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab3AYLiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:38:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41823 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab3AYLiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:38:05 -0500
Date: Fri, 25 Jan 2013 03:37:39 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-14d1ac7429d104b09d65c72fd215e1cffd5c7eba@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1356599507-14226-2-git-send-email-namhyung@kernel.org>
References: <1356599507-14226-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sort: Move misplaced sort entry functions
Git-Commit-ID: 14d1ac7429d104b09d65c72fd215e1cffd5c7eba
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:37:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  14d1ac7429d104b09d65c72fd215e1cffd5c7eba
Gitweb:     http://git.kernel.org/tip/14d1ac7429d104b09d65c72fd215e1cffd5c7eba
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 27 Dec 2012 18:11:38 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:20 -0300

perf sort: Move misplaced sort entry functions

Some functions are misplaced along with other entries.  Move them to a
right place so that it can be found together with related functions.

No functional change intended.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1356599507-14226-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 119 +++++++++++++++++++++++++------------------------
 1 file changed, 60 insertions(+), 59 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index dbaded9..ce5d404 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -97,6 +97,16 @@ static int hist_entry__comm_snprintf(struct hist_entry *self, char *bf,
 	return repsep_snprintf(bf, size, "%*s", width, self->thread->comm);
 }
 
+struct sort_entry sort_comm = {
+	.se_header	= "Command",
+	.se_cmp		= sort__comm_cmp,
+	.se_collapse	= sort__comm_collapse,
+	.se_snprintf	= hist_entry__comm_snprintf,
+	.se_width_idx	= HISTC_COMM,
+};
+
+/* --sort dso */
+
 static int64_t _sort__dso_cmp(struct map *map_l, struct map *map_r)
 {
 	struct dso *dso_l = map_l ? map_l->dso : NULL;
@@ -117,22 +127,38 @@ static int64_t _sort__dso_cmp(struct map *map_l, struct map *map_r)
 	return strcmp(dso_name_l, dso_name_r);
 }
 
-struct sort_entry sort_comm = {
-	.se_header	= "Command",
-	.se_cmp		= sort__comm_cmp,
-	.se_collapse	= sort__comm_collapse,
-	.se_snprintf	= hist_entry__comm_snprintf,
-	.se_width_idx	= HISTC_COMM,
-};
-
-/* --sort dso */
-
 static int64_t
 sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
 {
 	return _sort__dso_cmp(left->ms.map, right->ms.map);
 }
 
+static int _hist_entry__dso_snprintf(struct map *map, char *bf,
+				     size_t size, unsigned int width)
+{
+	if (map && map->dso) {
+		const char *dso_name = !verbose ? map->dso->short_name :
+			map->dso->long_name;
+		return repsep_snprintf(bf, size, "%-*s", width, dso_name);
+	}
+
+	return repsep_snprintf(bf, size, "%-*s", width, "[unknown]");
+}
+
+static int hist_entry__dso_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	return _hist_entry__dso_snprintf(self->ms.map, bf, size, width);
+}
+
+struct sort_entry sort_dso = {
+	.se_header	= "Shared Object",
+	.se_cmp		= sort__dso_cmp,
+	.se_snprintf	= hist_entry__dso_snprintf,
+	.se_width_idx	= HISTC_DSO,
+};
+
+/* --sort symbol */
 
 static int64_t _sort__sym_cmp(struct symbol *sym_l, struct symbol *sym_r,
 			      u64 ip_l, u64 ip_r)
@@ -149,22 +175,24 @@ static int64_t _sort__sym_cmp(struct symbol *sym_l, struct symbol *sym_r,
 	return (int64_t)(ip_r - ip_l);
 }
 
-static int _hist_entry__dso_snprintf(struct map *map, char *bf,
-				     size_t size, unsigned int width)
+static int64_t
+sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	if (map && map->dso) {
-		const char *dso_name = !verbose ? map->dso->short_name :
-			map->dso->long_name;
-		return repsep_snprintf(bf, size, "%-*s", width, dso_name);
-	}
+	u64 ip_l, ip_r;
 
-	return repsep_snprintf(bf, size, "%-*s", width, "[unknown]");
-}
+	if (!left->ms.sym && !right->ms.sym)
+		return right->level - left->level;
 
-static int hist_entry__dso_snprintf(struct hist_entry *self, char *bf,
-				    size_t size, unsigned int width)
-{
-	return _hist_entry__dso_snprintf(self->ms.map, bf, size, width);
+	if (!left->ms.sym || !right->ms.sym)
+		return cmp_null(left->ms.sym, right->ms.sym);
+
+	if (left->ms.sym == right->ms.sym)
+		return 0;
+
+	ip_l = left->ms.sym->start;
+	ip_r = right->ms.sym->start;
+
+	return _sort__sym_cmp(left->ms.sym, right->ms.sym, ip_l, ip_r);
 }
 
 static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
@@ -195,14 +223,6 @@ static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
 	return ret;
 }
 
-
-struct sort_entry sort_dso = {
-	.se_header	= "Shared Object",
-	.se_cmp		= sort__dso_cmp,
-	.se_snprintf	= hist_entry__dso_snprintf,
-	.se_width_idx	= HISTC_DSO,
-};
-
 static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
 				    size_t size,
 				    unsigned int width __maybe_unused)
@@ -211,27 +231,6 @@ static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
 					 self->level, bf, size, width);
 }
 
-/* --sort symbol */
-static int64_t
-sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	u64 ip_l, ip_r;
-
-	if (!left->ms.sym && !right->ms.sym)
-		return right->level - left->level;
-
-	if (!left->ms.sym || !right->ms.sym)
-		return cmp_null(left->ms.sym, right->ms.sym);
-
-	if (left->ms.sym == right->ms.sym)
-		return 0;
-
-	ip_l = left->ms.sym->start;
-	ip_r = right->ms.sym->start;
-
-	return _sort__sym_cmp(left->ms.sym, right->ms.sym, ip_l, ip_r);
-}
-
 struct sort_entry sort_sym = {
 	.se_header	= "Symbol",
 	.se_cmp		= sort__sym_cmp,
@@ -343,6 +342,8 @@ struct sort_entry sort_cpu = {
 	.se_width_idx	= HISTC_CPU,
 };
 
+/* sort keys for branch stacks */
+
 static int64_t
 sort__dso_from_cmp(struct hist_entry *left, struct hist_entry *right)
 {
@@ -357,13 +358,6 @@ static int hist_entry__dso_from_snprintf(struct hist_entry *self, char *bf,
 					 bf, size, width);
 }
 
-struct sort_entry sort_dso_from = {
-	.se_header	= "Source Shared Object",
-	.se_cmp		= sort__dso_from_cmp,
-	.se_snprintf	= hist_entry__dso_from_snprintf,
-	.se_width_idx	= HISTC_DSO_FROM,
-};
-
 static int64_t
 sort__dso_to_cmp(struct hist_entry *left, struct hist_entry *right)
 {
@@ -423,6 +417,13 @@ static int hist_entry__sym_to_snprintf(struct hist_entry *self, char *bf,
 
 }
 
+struct sort_entry sort_dso_from = {
+	.se_header	= "Source Shared Object",
+	.se_cmp		= sort__dso_from_cmp,
+	.se_snprintf	= hist_entry__dso_from_snprintf,
+	.se_width_idx	= HISTC_DSO_FROM,
+};
+
 struct sort_entry sort_dso_to = {
 	.se_header	= "Target Shared Object",
 	.se_cmp		= sort__dso_to_cmp,
