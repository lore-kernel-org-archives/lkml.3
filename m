Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab3K2MnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:43:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab3K2MnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:43:18 -0500
Date: Fri, 29 Nov 2013 13:42:49 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCHv3 20/29] tools lib traceevent: Remove malloc_or_die from
 plugin_function.c
Message-ID: <20131129124249.GF1231@krava.brq.redhat.com>
References: <1385638408-23519-1-git-send-email-jolsa@redhat.com>
 <1385638408-23519-21-git-send-email-jolsa@redhat.com>
 <87eh5zpv5l.fsf@sejong.aot.lge.com>
 <20131129103707.GB1231@krava.brq.redhat.com>
 <CAM9d7cj2T-AP45ZSy+Q+_cGzHcm+sr7wpPD4Nu-Ud316hpFHDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9d7cj2T-AP45ZSy+Q+_cGzHcm+sr7wpPD4Nu-Ud316hpFHDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 10:54:21AM +0000, Namhyung Kim wrote:
> > Removing malloc_or_die calls from plugin_function.c,
> > replacing them and factoring the code with standard
> > realloc and error path.
> 
> [SNIP]
> >
> >         if (cpu > cpus) {
> > -               if (fstack)
> > -                       fstack = realloc(fstack, sizeof(*fstack) * (cpu + 1));
> > -               else
> > -                       fstack = malloc_or_die(sizeof(*fstack) * (cpu + 1));
> > +               fstack = realloc(fstack, sizeof(*fstack) * (cpu + 1));
> 
> This code also has same problem..
> 

and v3.1 ;-) thanks

jirka


---
Removing malloc_or_die calls from plugin_function.c,
replacing them and factoring the code with standard
realloc and error path.

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
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
-- 
1.8.3.1

