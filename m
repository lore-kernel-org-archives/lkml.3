Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089Ab3LIThn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:37:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54960 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760937Ab3LIThU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:37:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/21] tools lib traceevent: Get rid of malloc_or_die() in add_event()
Date: Mon,  9 Dec 2013 16:37:06 -0300
Message-Id: <1386617830-18926-18-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386617830-18926-1-git-send-email-acme@infradead.org>
References: <1386617830-18926-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Make it return error value since its only caller find_event() now can
handle allocation error properly.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386567251-22751-8-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/parse-filter.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index b3a61d4fe38e..2b73abfb0c9f 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -245,15 +245,19 @@ static void free_arg(struct filter_arg *arg)
 	free(arg);
 }
 
-static void add_event(struct event_list **events,
+static int add_event(struct event_list **events,
 		      struct event_format *event)
 {
 	struct event_list *list;
 
-	list = malloc_or_die(sizeof(*list));
+	list = malloc(sizeof(*list));
+	if (list == NULL)
+		return -1;
+
 	list->next = *events;
 	*events = list;
 	list->event = event;
+	return 0;
 }
 
 static int event_match(struct event_format *event,
@@ -276,6 +280,7 @@ find_event(struct pevent *pevent, struct event_list **events,
 	regex_t ereg;
 	regex_t sreg;
 	int match = 0;
+	int fail = 0;
 	char *reg;
 	int ret;
 	int i;
@@ -310,7 +315,10 @@ find_event(struct pevent *pevent, struct event_list **events,
 		event = pevent->events[i];
 		if (event_match(event, sys_name ? &sreg : NULL, &ereg)) {
 			match = 1;
-			add_event(events, event);
+			if (add_event(events, event) < 0) {
+				fail = 1;
+				break;
+			}
 		}
 	}
 
@@ -320,6 +328,8 @@ find_event(struct pevent *pevent, struct event_list **events,
 
 	if (!match)
 		return -1;
+	if (fail)
+		return -2;
 
 	return 0;
 }
-- 
1.8.1.4

