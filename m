Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab3LKLLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:11:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60255 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab3LKLGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:06:22 -0500
Date: Wed, 11 Dec 2013 03:06:05 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-234520d3fbe43ef72268c4959f85ae326459378c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1386567251-22751-8-git-send-email-namhyung@kernel.org>
References: <1386567251-22751-8-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Get rid of malloc_or_die()
  in add_event()
Git-Commit-ID: 234520d3fbe43ef72268c4959f85ae326459378c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:06:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  234520d3fbe43ef72268c4959f85ae326459378c
Gitweb:     http://git.kernel.org/tip/234520d3fbe43ef72268c4959f85ae326459378c
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 9 Dec 2013 14:34:04 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 9 Dec 2013 15:39:40 -0300

tools lib traceevent: Get rid of malloc_or_die() in add_event()

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
index b3a61d4..2b73abf 100644
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
