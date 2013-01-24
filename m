Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab3AXUJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:09:43 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54078
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755894Ab3AXUIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 42/74] perf sort: Move misplaced sort entry functions
Date: Thu, 24 Jan 2013 17:07:51 -0300
Message-Id: <1359058103-31645-43-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

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
-- 
1.8.1.1.361.gec3ae6e

