Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760603Ab3LIFew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:34:52 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51889 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760098Ab3LIFeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:34:19 -0500
X-AuditID: 9c930197-b7bdbae000000e78-87-52a556575e61
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 12/14] tools lib traceevent: Get rid of die() in pevent_filter_clear_trivial()
Date: Mon,  9 Dec 2013 14:34:09 +0900
Message-Id: <1386567251-22751-13-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the function signature to return error code and not call die()
anymore.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
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
index d8613308c08d..4d395e8b88bb 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1606,8 +1606,10 @@ int pevent_update_trivial(struct event_filter *dest, struct event_filter *source
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
@@ -1616,13 +1618,15 @@ void pevent_filter_clear_trivial(struct event_filter *filter,
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
@@ -1637,19 +1641,24 @@ void pevent_filter_clear_trivial(struct event_filter *filter,
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
1.7.11.7

