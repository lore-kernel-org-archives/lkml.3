Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760503Ab3LIFeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:34:21 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51889 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3LIFeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:34:14 -0500
X-AuditID: 9c930197-b7bdbae000000e78-5c-52a55654bbe9
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 01/14] tools lib traceevent: Get rid of malloc_or_die() in show_error()
Date: Mon,  9 Dec 2013 14:33:58 +0900
Message-Id: <1386567251-22751-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/parse-filter.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 2500e75583fc..0fc905c230ad 100644
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
+			*error_str = "failed to allocate memory";
+			return;
+		}
+	}
 
 	if (len) {
 		strcpy(error, input);
-- 
1.7.11.7

