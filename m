Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab3LMPMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:12:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45223 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab3LMPMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:12:16 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/20] tools lib traceevent: Get rid of die in add_filter_type()
Date: Fri, 13 Dec 2013 12:11:56 -0300
Message-Id: <1386947526-7118-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386947526-7118-1-git-send-email-acme@infradead.org>
References: <1386947526-7118-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The realloc() should check return value and not to overwrite previous
pointer in case of error.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386833777-3790-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/parse-filter.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index d4b0bac80dc8..767de4f1e8ee 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -161,11 +161,13 @@ add_filter_type(struct event_filter *filter, int id)
 	if (filter_type)
 		return filter_type;
 
-	filter->event_filters =	realloc(filter->event_filters,
-					sizeof(*filter->event_filters) *
-					(filter->filters + 1));
-	if (!filter->event_filters)
-		die("Could not allocate filter");
+	filter_type = realloc(filter->event_filters,
+			      sizeof(*filter->event_filters) *
+			      (filter->filters + 1));
+	if (!filter_type)
+		return NULL;
+
+	filter->event_filters = filter_type;
 
 	for (i = 0; i < filter->filters; i++) {
 		if (filter->event_filters[i].event_id > id)
@@ -1180,6 +1182,12 @@ static int filter_event(struct event_filter *filter,
 	}
 
 	filter_type = add_filter_type(filter, event->id);
+	if (filter_type == NULL) {
+		show_error(error_str, "failed to add a new filter: %s",
+			   filter_str ? filter_str : "true");
+		return -1;
+	}
+
 	if (filter_type->filter)
 		free_arg(filter_type->filter);
 	filter_type->filter = arg;
@@ -1417,6 +1425,9 @@ static int copy_filter_type(struct event_filter *filter,
 			arg->boolean.value = 0;
 
 		filter_type = add_filter_type(filter, event->id);
+		if (filter_type == NULL)
+			return -1;
+
 		filter_type->filter = arg;
 
 		free(str);
-- 
1.8.1.4

