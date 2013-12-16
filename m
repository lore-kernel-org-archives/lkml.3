Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab3LPP2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:28:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47668 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab3LPP2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:28:20 -0500
Date: Mon, 16 Dec 2013 07:28:01 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-ef3072cd1d5c2ea229f7abf8d6475e0c200eeb71@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1386833777-3790-3-git-send-email-namhyung@kernel.org>
References: <1386833777-3790-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Get rid of die in add_filter_type()
Git-Commit-ID: ef3072cd1d5c2ea229f7abf8d6475e0c200eeb71
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 16 Dec 2013 07:28:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef3072cd1d5c2ea229f7abf8d6475e0c200eeb71
Gitweb:     http://git.kernel.org/tip/ef3072cd1d5c2ea229f7abf8d6475e0c200eeb71
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 12 Dec 2013 16:36:05 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 13 Dec 2013 10:30:21 -0300

tools lib traceevent: Get rid of die in add_filter_type()

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
index d4b0bac..767de4f 100644
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
