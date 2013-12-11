Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab3LKLGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:06:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60284 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab3LKLGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:06:43 -0500
Date: Wed, 11 Dec 2013 03:06:24 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-28942c87e5e907f591d77547203e86ad1089b499@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1386567251-22751-12-git-send-email-namhyung@kernel.org>
References: <1386567251-22751-12-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Get rid of malloc_or_die()
  in pevent_filter_add_filter_str()
Git-Commit-ID: 28942c87e5e907f591d77547203e86ad1089b499
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:06:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  28942c87e5e907f591d77547203e86ad1089b499
Gitweb:     http://git.kernel.org/tip/28942c87e5e907f591d77547203e86ad1089b499
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 9 Dec 2013 14:34:08 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 9 Dec 2013 15:39:53 -0300

tools lib traceevent: Get rid of malloc_or_die() in pevent_filter_add_filter_str()

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386567251-22751-12-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/parse-filter.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 53e48eb..a4d5bb2 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1226,7 +1226,13 @@ int pevent_filter_add_filter_str(struct event_filter *filter,
 		else
 			len = strlen(filter_str);
 
-		this_event = malloc_or_die(len + 1);
+		this_event = malloc(len + 1);
+		if (this_event == NULL) {
+			show_error(error_str, "Memory allocation failure");
+			/* This can only happen when events is NULL, but still */
+			free_events(events);
+			return -1;
+		}
 		memcpy(this_event, filter_str, len);
 		this_event[len] = 0;
 
