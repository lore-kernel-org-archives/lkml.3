Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbaGYBTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 21:19:15 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46362 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634AbaGYBTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 21:19:13 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/7] perf tools: Left-align output contents
Date: Fri, 25 Jul 2014 10:18:52 +0900
Message-Id: <1406251138-6574-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406251138-6574-1-git-send-email-namhyung@kernel.org>
References: <1406251138-6574-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now perf left-aligns column headers but the contents does not.  It
should have same alignment.  This requires a change in pid sort key -
it consists of two part (pid and comm).  As length of comm can be vary
it'd be better to change the order of them.

Thanks to Jiri Olsa for pointing this out.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 14e5a039bc45..eda9ee836cee 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -70,12 +70,12 @@ static int hist_entry__thread_snprintf(struct hist_entry *he, char *bf,
 				       size_t size, unsigned int width)
 {
 	const char *comm = thread__comm_str(he->thread);
-	return repsep_snprintf(bf, size, "%*s:%5d", width - 6,
-			       comm ?: "", he->thread->tid);
+	return repsep_snprintf(bf, size, "%5d:%-*s", he->thread->tid,
+			       width - 6, comm ?: "");
 }
 
 struct sort_entry sort_thread = {
-	.se_header	= "Command:  Pid",
+	.se_header	= "  Pid:Command",
 	.se_cmp		= sort__thread_cmp,
 	.se_snprintf	= hist_entry__thread_snprintf,
 	.se_width_idx	= HISTC_THREAD,
@@ -106,7 +106,7 @@ sort__comm_sort(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__comm_snprintf(struct hist_entry *he, char *bf,
 				     size_t size, unsigned int width)
 {
-	return repsep_snprintf(bf, size, "%*s", width, comm__str(he->comm));
+	return repsep_snprintf(bf, size, "%-*s", width, comm__str(he->comm));
 }
 
 struct sort_entry sort_comm = {
@@ -305,7 +305,7 @@ static int hist_entry__srcline_snprintf(struct hist_entry *he, char *bf,
 					size_t size,
 					unsigned int width __maybe_unused)
 {
-	return repsep_snprintf(bf, size, "%s", he->srcline);
+	return repsep_snprintf(bf, size, "%-s", he->srcline);
 }
 
 struct sort_entry sort_srcline = {
-- 
2.0.0

