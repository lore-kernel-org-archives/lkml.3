Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab3LPP2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:28:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47660 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab3LPP2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:28:12 -0500
Date: Mon, 16 Dec 2013 07:27:52 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-9451a2fd78c785445afe0f6966b2043c3ee187ca@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1386833777-3790-2-git-send-email-namhyung@kernel.org>
References: <1386833777-3790-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Get rid of malloc_or_die()
  in show_error()
Git-Commit-ID: 9451a2fd78c785445afe0f6966b2043c3ee187ca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 16 Dec 2013 07:27:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9451a2fd78c785445afe0f6966b2043c3ee187ca
Gitweb:     http://git.kernel.org/tip/9451a2fd78c785445afe0f6966b2043c3ee187ca
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 12 Dec 2013 16:36:04 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 13 Dec 2013 10:30:21 -0300

tools lib traceevent: Get rid of malloc_or_die() in show_error()

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
index ab402fb..d4b0bac 100644
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
