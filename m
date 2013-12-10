Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab3LJJW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:22:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44631 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab3LJJWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:22:19 -0500
Date: Tue, 10 Dec 2013 01:21:47 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-d8e56c98b7ef96a31a64c69df24ab5d80f90e055@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1386076182-14484-27-git-send-email-jolsa@redhat.com>
References: <1386076182-14484-27-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Remove malloc_or_die from plugin_function.c
Git-Commit-ID: d8e56c98b7ef96a31a64c69df24ab5d80f90e055
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 01:21:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8e56c98b7ef96a31a64c69df24ab5d80f90e055
Gitweb:     http://git.kernel.org/tip/d8e56c98b7ef96a31a64c69df24ab5d80f90e055
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 3 Dec 2013 14:09:40 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 4 Dec 2013 15:37:58 -0300

tools lib traceevent: Remove malloc_or_die from plugin_function.c

Removing malloc_or_die calls from plugin_function.c, replacing them and
factoring the code with standard realloc and error path.

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386076182-14484-27-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/plugin_function.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/tools/lib/traceevent/plugin_function.c b/tools/lib/traceevent/plugin_function.c
index 87acf9c..aad92ad 100644
--- a/tools/lib/traceevent/plugin_function.c
+++ b/tools/lib/traceevent/plugin_function.c
@@ -43,11 +43,17 @@ static void add_child(struct func_stack *stack, const char *child, int pos)
 	if (pos < stack->size)
 		free(stack->stack[pos]);
 	else {
-		if (!stack->stack)
-			stack->stack = malloc_or_die(sizeof(char *) * STK_BLK);
-		else
-			stack->stack = realloc(stack->stack, sizeof(char *) *
-					       (stack->size + STK_BLK));
+		char **ptr;
+
+		ptr = realloc(stack->stack, sizeof(char *) *
+			      (stack->size + STK_BLK));
+		if (!ptr) {
+			warning("could not allocate plugin memory\n");
+			return;
+		}
+
+		stack->stack = ptr;
+
 		for (i = stack->size; i < stack->size + STK_BLK; i++)
 			stack->stack[i] = NULL;
 		stack->size += STK_BLK;
@@ -64,10 +70,15 @@ static int add_and_get_index(const char *parent, const char *child, int cpu)
 		return 0;
 
 	if (cpu > cpus) {
-		if (fstack)
-			fstack = realloc(fstack, sizeof(*fstack) * (cpu + 1));
-		else
-			fstack = malloc_or_die(sizeof(*fstack) * (cpu + 1));
+		struct func_stack *ptr;
+
+		ptr = realloc(fstack, sizeof(*fstack) * (cpu + 1));
+		if (!ptr) {
+			warning("could not allocate plugin memory\n");
+			return 0;
+		}
+
+		fstack = ptr;
 
 		/* Account for holes in the cpu count */
 		for (i = cpus + 1; i <= cpu; i++)
