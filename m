Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760475Ab3LIFiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:38:04 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61198 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab3LIFeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:34:15 -0500
X-AuditID: 9c930197-b7bdbae000000e78-5e-52a55654380a
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 02/14] tools lib traceevent: Get rid of die in add_filter_type()
Date: Mon,  9 Dec 2013 14:33:59 +0900
Message-Id: <1386567251-22751-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The realloc() should check return value and not to overwrite previous
pointer in case of error.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/parse-filter.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 0fc905c230ad..d9c239933992 100644
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
@@ -1164,6 +1166,12 @@ static int filter_event(struct event_filter *filter,
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
@@ -1395,6 +1403,9 @@ static int copy_filter_type(struct event_filter *filter,
 			arg->boolean.value = 0;
 
 		filter_type = add_filter_type(filter, event->id);
+		if (filter_type == NULL)
+			return -1;
+
 		filter_type->filter = arg;
 
 		free(str);
-- 
1.7.11.7

