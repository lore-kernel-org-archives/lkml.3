Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760685Ab3LIFfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:35:17 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51889 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760009Ab3LIFeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:34:17 -0500
X-AuditID: 9c930197-b7bdbae000000e78-6f-52a556550952
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 06/14] tools lib traceevent: Get rid of malloc_or_die() in find_event()
Date: Mon,  9 Dec 2013 14:34:03 +0900
Message-Id: <1386567251-22751-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it return -2 to distinguish malloc allocation failure.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/parse-filter.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index e9d17bfcdffd..06e5af9f8fc4 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -301,7 +301,10 @@ find_event(struct pevent *pevent, struct event_list **events,
 		sys_name = NULL;
 	}
 
-	reg = malloc_or_die(strlen(event_name) + 3);
+	reg = malloc(strlen(event_name) + 3);
+	if (reg == NULL)
+		return -2;
+
 	sprintf(reg, "^%s$", event_name);
 
 	ret = regcomp(&ereg, reg, REG_ICASE|REG_NOSUB);
@@ -311,7 +314,12 @@ find_event(struct pevent *pevent, struct event_list **events,
 		return -1;
 
 	if (sys_name) {
-		reg = malloc_or_die(strlen(sys_name) + 3);
+		reg = malloc(strlen(sys_name) + 3);
+		if (reg == NULL) {
+			regfree(&ereg);
+			return -2;
+		}
+
 		sprintf(reg, "^%s$", sys_name);
 		ret = regcomp(&sreg, reg, REG_ICASE|REG_NOSUB);
 		free(reg);
@@ -1290,7 +1298,10 @@ int pevent_filter_add_filter_str(struct event_filter *filter,
 		/* Find this event */
 		ret = find_event(pevent, &events, strim(sys_name), strim(event_name));
 		if (ret < 0) {
-			if (event_name)
+			if (ret == -2)
+				show_error(error_str,
+					   "Memory allocation failure");
+			else if (event_name)
 				show_error(error_str,
 					   "No event found under '%s.%s'",
 					   sys_name, event_name);
-- 
1.7.11.7

