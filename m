Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab3LPP3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:29:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47757 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab3LPP32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:29:28 -0500
Date: Mon, 16 Dec 2013 07:29:07 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-c8ea690dd0d1385a766d68c51832497181e013b8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1386833777-3790-10-git-send-email-namhyung@kernel.org>
References: <1386833777-3790-10-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Refactor create_arg_item()
Git-Commit-ID: c8ea690dd0d1385a766d68c51832497181e013b8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 16 Dec 2013 07:29:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c8ea690dd0d1385a766d68c51832497181e013b8
Gitweb:     http://git.kernel.org/tip/c8ea690dd0d1385a766d68c51832497181e013b8
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 12 Dec 2013 16:36:12 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 13 Dec 2013 10:30:22 -0300

tools lib traceevent: Refactor create_arg_item()

So that it can return a proper pevent_errno value.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386833777-3790-10-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.h  |  3 ++-
 tools/lib/traceevent/parse-filter.c | 20 ++++++++++----------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 5e4392d..57b66ae 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -367,7 +367,8 @@ enum pevent_flag {
 	_PE(ILLEGAL_INTEGER_CMP,"illegal comparison for integer"), 	      \
 	_PE(REPARENT_NOT_OP,	"cannot reparent other than OP"),	      \
 	_PE(REPARENT_FAILED,	"failed to reparent filter OP"),	      \
-	_PE(BAD_FILTER_ARG,	"bad arg in filter tree")
+	_PE(BAD_FILTER_ARG,	"bad arg in filter tree"),		      \
+	_PE(UNEXPECTED_TYPE,	"unexpected type (not a value)")
 
 #undef _PE
 #define _PE(__code, __str) PEVENT_ERRNO__ ## __code
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 9b05892..8d71208 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -368,9 +368,9 @@ static void free_events(struct event_list *events)
 	}
 }
 
-static struct filter_arg *
+static enum pevent_errno
 create_arg_item(struct event_format *event, const char *token,
-		enum event_type type, char **error_str)
+		enum event_type type, struct filter_arg **parg, char **error_str)
 {
 	struct format_field *field;
 	struct filter_arg *arg;
@@ -378,7 +378,7 @@ create_arg_item(struct event_format *event, const char *token,
 	arg = allocate_arg();
 	if (arg == NULL) {
 		show_error(error_str, "failed to allocate filter arg");
-		return NULL;
+		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
 	}
 
 	switch (type) {
@@ -392,7 +392,7 @@ create_arg_item(struct event_format *event, const char *token,
 		if (!arg->value.str) {
 			free_arg(arg);
 			show_error(error_str, "failed to allocate string filter arg");
-			return NULL;
+			return PEVENT_ERRNO__MEM_ALLOC_FAILED;
 		}
 		break;
 	case EVENT_ITEM:
@@ -420,11 +420,11 @@ create_arg_item(struct event_format *event, const char *token,
 		break;
 	default:
 		free_arg(arg);
-		show_error(error_str, "expected a value but found %s",
-			   token);
-		return NULL;
+		show_error(error_str, "expected a value but found %s", token);
+		return PEVENT_ERRNO__UNEXPECTED_TYPE;
 	}
-	return arg;
+	*parg = arg;
+	return 0;
 }
 
 static struct filter_arg *
@@ -993,8 +993,8 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 		case EVENT_SQUOTE:
 		case EVENT_DQUOTE:
 		case EVENT_ITEM:
-			arg = create_arg_item(event, token, type, error_str);
-			if (!arg)
+			ret = create_arg_item(event, token, type, &arg, error_str);
+			if (ret < 0)
 				goto fail;
 			if (!left_item)
 				left_item = arg;
