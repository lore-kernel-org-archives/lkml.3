Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab3EaLTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:19:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56463 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab3EaLTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:19:24 -0400
Date: Fri, 31 May 2013 04:19:04 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-2f532d09fa3a7eaf7cf1c23de9767eab8c8c0e7e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        andi@firstfloor.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1364991979-3008-2-git-send-email-namhyung@kernel.org>
References: <1364991979-3008-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sort:
  Factor out common code in sort_dimension__add()
Git-Commit-ID: 2f532d09fa3a7eaf7cf1c23de9767eab8c8c0e7e
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

Commit-ID:  2f532d09fa3a7eaf7cf1c23de9767eab8c8c0e7e
Gitweb:     http://git.kernel.org/tip/2f532d09fa3a7eaf7cf1c23de9767eab8c8c0e7e
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 3 Apr 2013 21:26:10 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:23:53 +0300

perf sort: Factor out common code in sort_dimension__add()

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
 
