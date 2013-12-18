Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab3LRFVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 00:21:49 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:54370 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3LRFVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 00:21:30 -0500
X-AuditID: 9c93017d-b7c5eae000004296-1e-52b130d8b58d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Jiri Olsa <jolsa@redhat.com>, Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 02/18] perf sort: Do not compare dso again
Date: Wed, 18 Dec 2013 14:21:10 +0900
Message-Id: <1387344086-12744-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
References: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The commit 09600e0f9ebb ("perf tools: Compare dso's also when
comparing symbols") added a comparison of dso when comparing symbol.
But if the sort key already has dso, it doesn't need to do it again
since entries have a different dso already filtered out.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
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
1.7.11.7

