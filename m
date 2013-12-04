Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933431Ab3LDUIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:08:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59441 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933329Ab3LDUHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:07:24 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 37/38] tools lib traceevent: Remove malloc_or_die from plugin_function.c
Date: Wed,  4 Dec 2013 17:07:01 -0300
Message-Id: <1386187622-2928-38-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386187622-2928-1-git-send-email-acme@infradead.org>
References: <1386187622-2928-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

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
index 87acf9c77948..aad92ad5e96f 100644
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
-- 
1.8.1.4

