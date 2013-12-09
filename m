Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713Ab3LIFhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:37:05 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61198 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab3LIFeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:34:16 -0500
X-AuditID: 9c930197-b7bdbae000000e78-68-52a5565566c7
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 05/14] tools lib traceevent: Get rid of malloc_or_die() in read_token()
Date: Mon,  9 Dec 2013 14:34:02 +0900
Message-Id: <1386567251-22751-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/parse-filter.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 35fac1fa376b..e9d17bfcdffd 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -109,7 +109,11 @@ static enum event_type read_token(char **tok)
 	    (strcmp(token, "=") == 0 || strcmp(token, "!") == 0) &&
 	    pevent_peek_char() == '~') {
 		/* append it */
-		*tok = malloc_or_die(3);
+		*tok = malloc(3);
+		if (*tok == NULL) {
+			free_token(token);
+			return EVENT_ERROR;
+		}
 		sprintf(*tok, "%c%c", *token, '~');
 		free_token(token);
 		/* Now remove the '~' from the buffer */
@@ -1107,6 +1111,8 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 			break;
 		case EVENT_NONE:
 			break;
+		case EVENT_ERROR:
+			goto fail_alloc;
 		default:
 			goto fail_print;
 		}
-- 
1.7.11.7

