Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab3LLHgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:36:33 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53469 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab3LLHgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:36:23 -0500
X-AuditID: 9c93016f-b7c57ae0000070d3-e5-52a9677339ff
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 04/14] tools lib traceevent: Get rid of malloc_or_die() in read_token()
Date: Thu, 12 Dec 2013 16:36:07 +0900
Message-Id: <1386833777-3790-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
References: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/parse-filter.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index ab9cefe320b4..246ee81e1f93 100644
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
@@ -1123,6 +1127,8 @@ process_filter(struct event_format *event, struct filter_arg **parg,
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

