Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671Ab3LIFfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:35:14 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61198 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760037Ab3LIFeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:34:17 -0500
X-AuditID: 9c930197-b7bdbae000000e78-73-52a55655217e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 07/14] tools lib traceevent: Get rid of malloc_or_die() in add_event()
Date: Mon,  9 Dec 2013 14:34:04 +0900
Message-Id: <1386567251-22751-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it return error value since its only caller find_event() now can
handle allocation error properly.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/parse-filter.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 06e5af9f8fc4..faa10824b87d 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -260,15 +260,19 @@ static void free_arg(struct filter_arg *arg)
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
@@ -291,6 +295,7 @@ find_event(struct pevent *pevent, struct event_list **events,
 	regex_t ereg;
 	regex_t sreg;
 	int match = 0;
+	int fail = 0;
 	char *reg;
 	int ret;
 	int i;
@@ -333,7 +338,10 @@ find_event(struct pevent *pevent, struct event_list **events,
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
 
@@ -343,6 +351,8 @@ find_event(struct pevent *pevent, struct event_list **events,
 
 	if (!match)
 		return -1;
+	if (fail)
+		return -2;
 
 	return 0;
 }
-- 
1.7.11.7

