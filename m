Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab3LKLG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:06:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60302 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab3LKLGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:06:51 -0500
Date: Wed, 11 Dec 2013 03:06:33 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-7ef2e813476273ac9c9138f002d8f4cb28e5adad@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1386567251-22751-13-git-send-email-namhyung@kernel.org>
References: <1386567251-22751-13-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Get rid of die()
  in pevent_filter_clear_trivial()
Git-Commit-ID: 7ef2e813476273ac9c9138f002d8f4cb28e5adad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:06:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7ef2e813476273ac9c9138f002d8f4cb28e5adad
Gitweb:     http://git.kernel.org/tip/7ef2e813476273ac9c9138f002d8f4cb28e5adad
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 9 Dec 2013 14:34:09 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 9 Dec 2013 15:39:57 -0300

tools lib traceevent: Get rid of die() in pevent_filter_clear_trivial()

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
index 620c27a..6e23f19 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -860,7 +860,7 @@ int pevent_event_filtered(struct event_filter *filter,
 
 void pevent_filter_reset(struct event_filter *filter);
 
-void pevent_filter_clear_trivial(struct event_filter *filter,
+int pevent_filter_clear_trivial(struct event_filter *filter,
 				 enum filter_trivial_type type);
 
 void pevent_filter_free(struct event_filter *filter);
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index a4d5bb2..ab402fb 100644
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
