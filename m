Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab3LPP2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:28:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47713 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab3LPP2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:28:48 -0500
Date: Mon, 16 Dec 2013 07:28:29 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-605b8fda958a578e0a50ed1df3cac5a12f1fe8dc@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1386833777-3790-6-git-send-email-namhyung@kernel.org>
References: <1386833777-3790-6-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Get rid of malloc_or_die()
  in find_event()
Git-Commit-ID: 605b8fda958a578e0a50ed1df3cac5a12f1fe8dc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 16 Dec 2013 07:28:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  605b8fda958a578e0a50ed1df3cac5a12f1fe8dc
Gitweb:     http://git.kernel.org/tip/605b8fda958a578e0a50ed1df3cac5a12f1fe8dc
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 12 Dec 2013 16:36:08 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 13 Dec 2013 10:30:22 -0300

tools lib traceevent: Get rid of malloc_or_die() in find_event()

Make it return pevent_errno to distinguish malloc allocation failure.
Since it'll be returned to user later, add more error code.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386833777-3790-6-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.h  |  4 +++-
 tools/lib/traceevent/parse-filter.c | 27 +++++++++++++++++++--------
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 6e23f19..abdfd3c 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -356,7 +356,9 @@ enum pevent_flag {
 	_PE(READ_FORMAT_FAILED,	"failed to read event format"),		      \
 	_PE(READ_PRINT_FAILED,	"failed to read event print fmt"), 	      \
 	_PE(OLD_FTRACE_ARG_FAILED,"failed to allocate field name for ftrace"),\
-	_PE(INVALID_ARG_TYPE,	"invalid argument type")
+	_PE(INVALID_ARG_TYPE,	"invalid argument type"),		      \
+	_PE(INVALID_EVENT_NAME,	"invalid event name"),			      \
+	_PE(EVENT_NOT_FOUND,	"No event found")
 
 #undef _PE
 #define _PE(__code, __str) PEVENT_ERRNO__ ## __code
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 246ee81..a0ab040 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -287,7 +287,7 @@ static int event_match(struct event_format *event,
 		!regexec(ereg, event->name, 0, NULL, 0);
 }
 
-static int
+static enum pevent_errno
 find_event(struct pevent *pevent, struct event_list **events,
 	   char *sys_name, char *event_name)
 {
@@ -306,23 +306,31 @@ find_event(struct pevent *pevent, struct event_list **events,
 		sys_name = NULL;
 	}
 
-	reg = malloc_or_die(strlen(event_name) + 3);
+	reg = malloc(strlen(event_name) + 3);
+	if (reg == NULL)
+		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+
 	sprintf(reg, "^%s$", event_name);
 
 	ret = regcomp(&ereg, reg, REG_ICASE|REG_NOSUB);
 	free(reg);
 
 	if (ret)
-		return -1;
+		return PEVENT_ERRNO__INVALID_EVENT_NAME;
 
 	if (sys_name) {
-		reg = malloc_or_die(strlen(sys_name) + 3);
+		reg = malloc(strlen(sys_name) + 3);
+		if (reg == NULL) {
+			regfree(&ereg);
+			return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+		}
+
 		sprintf(reg, "^%s$", sys_name);
 		ret = regcomp(&sreg, reg, REG_ICASE|REG_NOSUB);
 		free(reg);
 		if (ret) {
 			regfree(&ereg);
-			return -1;
+			return PEVENT_ERRNO__INVALID_EVENT_NAME;
 		}
 	}
 
@@ -342,9 +350,9 @@ find_event(struct pevent *pevent, struct event_list **events,
 		regfree(&sreg);
 
 	if (!match)
-		return -1;
+		return PEVENT_ERRNO__EVENT_NOT_FOUND;
 	if (fail)
-		return -2;
+		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
 
 	return 0;
 }
@@ -1312,7 +1320,10 @@ int pevent_filter_add_filter_str(struct event_filter *filter,
 		/* Find this event */
 		ret = find_event(pevent, &events, strim(sys_name), strim(event_name));
 		if (ret < 0) {
-			if (event_name)
+			if (ret == PEVENT_ERRNO__MEM_ALLOC_FAILED)
+				show_error(error_str,
+					   "Memory allocation failure");
+			else if (event_name)
 				show_error(error_str,
 					   "No event found under '%s.%s'",
 					   sys_name, event_name);
