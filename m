Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab3LPP2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:28:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47708 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab3LPP2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:28:44 -0500
Date: Mon, 16 Dec 2013 07:28:20 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-91dfa49bdd8ef9600d850ef68ec892eb70824e3d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1386833777-3790-5-git-send-email-namhyung@kernel.org>
References: <1386833777-3790-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Get rid of malloc_or_die()
  in read_token()
Git-Commit-ID: 91dfa49bdd8ef9600d850ef68ec892eb70824e3d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 16 Dec 2013 07:28:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  91dfa49bdd8ef9600d850ef68ec892eb70824e3d
Gitweb:     http://git.kernel.org/tip/91dfa49bdd8ef9600d850ef68ec892eb70824e3d
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 12 Dec 2013 16:36:07 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 13 Dec 2013 10:30:21 -0300

tools lib traceevent: Get rid of malloc_or_die() in read_token()

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386833777-3790-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/parse-filter.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index ab9cefe..246ee81 100644
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
