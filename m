Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762256Ab3DCM03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:26:29 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48225 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761171Ab3DCM0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:26:25 -0400
X-AuditID: 9c93016f-b7c18ae000002f5f-96-515c1ff06faf
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 01/10] perf sort: Factor out common code in sort_dimension__add()
Date: Wed,  3 Apr 2013 21:26:10 +0900
Message-Id: <1364991979-3008-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364991979-3008-1-git-send-email-namhyung@kernel.org>
References: <1364991979-3008-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Let's remove duplicate code.

Suggested-by: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 41 +++++++++++++++++------------------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index a6ddad41d57a..a997955085eb 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -895,6 +895,21 @@ static struct sort_dimension bstack_sort_dimensions[] = {
 
 #undef DIM
 
+static void __sort_dimension__add(struct sort_dimension *sd, enum sort_type idx)
+{
+	if (sd->taken)
+		return;
+
+	if (sd->entry->se_collapse)
+		sort__need_collapse = 1;
+
+	if (list_empty(&hist_entry__sort_list))
+		sort__first_dimension = idx;
+
+	list_add_tail(&sd->entry->list, &hist_entry__sort_list);
+	sd->taken = 1;
+}
+
 int sort_dimension__add(const char *tok)
 {
 	unsigned int i;
@@ -922,18 +937,7 @@ int sort_dimension__add(const char *tok)
 			sort__has_sym = 1;
 		}
 
-		if (sd->taken)
-			return 0;
-
-		if (sd->entry->se_collapse)
-			sort__need_collapse = 1;
-
-		if (list_empty(&hist_entry__sort_list))
-			sort__first_dimension = i;
-
-		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
-		sd->taken = 1;
-
+		__sort_dimension__add(sd, i);
 		return 0;
 	}
 
@@ -949,18 +953,7 @@ int sort_dimension__add(const char *tok)
 		if (sd->entry == &sort_sym_from || sd->entry == &sort_sym_to)
 			sort__has_sym = 1;
 
-		if (sd->taken)
-			return 0;
-
-		if (sd->entry->se_collapse)
-			sort__need_collapse = 1;
-
-		if (list_empty(&hist_entry__sort_list))
-			sort__first_dimension = i + __SORT_BRANCH_STACK;
-
-		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
-		sd->taken = 1;
-
+		__sort_dimension__add(sd, i + __SORT_BRANCH_STACK);
 		return 0;
 	}
 
-- 
1.7.11.7

