Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935498Ab3E3QM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:12:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50953 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934549Ab3E3QCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/66] perf sort: Factor out common code in sort_dimension__add()
Date: Thu, 30 May 2013 19:00:39 +0300
Message-Id: <1369929699-8724-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Let's remove duplicate code.

Suggested-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1364991979-3008-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 41 +++++++++++++++++------------------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index a6ddad4..a997955 100644
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
1.8.1.4

