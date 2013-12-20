Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab3LTTKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:10:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38555 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab3LTTJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:09:34 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/35] perf sort: Do not compare dso again
Date: Fri, 20 Dec 2013 16:08:37 -0300
Message-Id: <1387566550-3524-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387566550-3524-1-git-send-email-acme@infradead.org>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The commit 09600e0f9ebb ("perf tools: Compare dso's also when comparing
symbols") added a comparison of dso when comparing symbol.

But if the sort key already has dso, it doesn't need to do it again
since entries have a different dso already filtered out.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rodrigo Campos <rodrigo@sdfg.com.ar>
Link: http://lkml.kernel.org/r/1387344086-12744-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 68a4fd2f505e..635cd8f8b22e 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -13,6 +13,7 @@ int		have_ignore_callees = 0;
 int		sort__need_collapse = 0;
 int		sort__has_parent = 0;
 int		sort__has_sym = 0;
+int		sort__has_dso = 0;
 enum sort_mode	sort__mode = SORT_MODE__NORMAL;
 
 enum sort_type	sort__first_dimension;
@@ -194,9 +195,11 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 	 * comparing symbol address alone is not enough since it's a
 	 * relative address within a dso.
 	 */
-	ret = sort__dso_cmp(left, right);
-	if (ret != 0)
-		return ret;
+	if (!sort__has_dso) {
+		ret = sort__dso_cmp(left, right);
+		if (ret != 0)
+			return ret;
+	}
 
 	return _sort__sym_cmp(left->ms.sym, right->ms.sym);
 }
@@ -1061,6 +1064,8 @@ int sort_dimension__add(const char *tok)
 			sort__has_parent = 1;
 		} else if (sd->entry == &sort_sym) {
 			sort__has_sym = 1;
+		} else if (sd->entry == &sort_dso) {
+			sort__has_dso = 1;
 		}
 
 		__sort_dimension__add(sd, i);
-- 
1.8.1.4

