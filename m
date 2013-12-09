Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933900Ab3LITkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:40:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55004 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab3LIThZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:37:25 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 20/21] tools lib traceevent: Get rid of die() in pevent_filter_clear_trivial()
Date: Mon,  9 Dec 2013 16:37:09 -0300
Message-Id: <1386617830-18926-21-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386617830-18926-1-git-send-email-acme@infradead.org>
References: <1386617830-18926-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Change the function signature to return error code and not call die()
anymore.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386567251-22751-13-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.h  |  2 +-
 tools/lib/traceevent/parse-filter.c | 21 +++++++++++++++------
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 620c27a72960..6e23f197175f 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -860,7 +860,7 @@ int pevent_event_filtered(struct event_filter *filter,
 
 void pevent_filter_reset(struct event_filter *filter);
 
-void pevent_filter_clear_trivial(struct event_filter *filter,
+int pevent_filter_clear_trivial(struct event_filter *filter,
 				 enum filter_trivial_type type);
 
 void pevent_filter_free(struct event_filter *filter);
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index a4d5bb23a110..ab402fb2dcf7 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1504,8 +1504,10 @@ int pevent_update_trivial(struct event_filter *dest, struct event_filter *source
  * @type: remove only true, false, or both
  *
  * Removes filters that only contain a TRUE or FALES boolean arg.
+ *
+ * Returns 0 on success and -1 if there was a problem.
  */
-void pevent_filter_clear_trivial(struct event_filter *filter,
+int pevent_filter_clear_trivial(struct event_filter *filter,
 				 enum filter_trivial_type type)
 {
 	struct filter_type *filter_type;
@@ -1514,13 +1516,15 @@ void pevent_filter_clear_trivial(struct event_filter *filter,
 	int i;
 
 	if (!filter->filters)
-		return;
+		return 0;
 
 	/*
 	 * Two steps, first get all ids with trivial filters.
 	 *  then remove those ids.
 	 */
 	for (i = 0; i < filter->filters; i++) {
+		int *new_ids;
+
 		filter_type = &filter->event_filters[i];
 		if (filter_type->filter->type != FILTER_ARG_BOOLEAN)
 			continue;
@@ -1535,19 +1539,24 @@ void pevent_filter_clear_trivial(struct event_filter *filter,
 			break;
 		}
 
-		ids = realloc(ids, sizeof(*ids) * (count + 1));
-		if (!ids)
-			die("Can't allocate ids");
+		new_ids = realloc(ids, sizeof(*ids) * (count + 1));
+		if (!new_ids) {
+			free(ids);
+			return -1;
+		}
+
+		ids = new_ids;
 		ids[count++] = filter_type->event_id;
 	}
 
 	if (!count)
-		return;
+		return 0;
 
 	for (i = 0; i < count; i++)
 		pevent_filter_remove_event(filter, ids[i]);
 
 	free(ids);
+	return 0;
 }
 
 /**
-- 
1.8.1.4

