Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab3LLHga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:36:30 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53469 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab3LLHgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:36:21 -0500
X-AuditID: 9c93016f-b7c57ae0000070d3-d0-52a96772cf45
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 01/14] tools lib traceevent: Get rid of malloc_or_die() in show_error()
Date: Thu, 12 Dec 2013 16:36:04 +0900
Message-Id: <1386833777-3790-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
References: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/parse-filter.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index ab402fb2dcf7..d4b0bac80dc8 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -56,7 +56,21 @@ static void show_error(char **error_str, const char *fmt, ...)
 	index = pevent_get_input_buf_ptr();
 	len = input ? strlen(input) : 0;
 
-	error = malloc_or_die(MAX_ERR_STR_SIZE + (len*2) + 3);
+	error = malloc(MAX_ERR_STR_SIZE + (len*2) + 3);
+	if (error == NULL) {
+		/*
+		 * Maybe it's due to len is too long.
+		 * Retry without the input buffer part.
+		 */
+		len = 0;
+
+		error = malloc(MAX_ERR_STR_SIZE);
+		if (error == NULL) {
+			/* no memory */
+			*error_str = NULL;
+			return;
+		}
+	}
 
 	if (len) {
 		strcpy(error, input);
-- 
1.7.11.7

