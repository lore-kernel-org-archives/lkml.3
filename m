Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab3LMPRo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:17:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45240 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab3LMPMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:12:17 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/20] tools lib traceevent: Get rid of malloc_or_die() in show_error()
Date: Fri, 13 Dec 2013 12:11:55 -0300
Message-Id: <1386947526-7118-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386947526-7118-1-git-send-email-acme@infradead.org>
References: <1386947526-7118-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386833777-3790-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.8.1.4

