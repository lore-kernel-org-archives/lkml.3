Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbaGQKzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:55:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756555AbaGQKzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:55:16 -0400
Date: Thu, 17 Jul 2014 12:55:00 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCHv3 4/5] perf tools: Add --debug optionto set debug variable
Message-ID: <20140717105500.GG516@krava.redhat.com>
References: <1405374411-29012-1-git-send-email-jolsa@kernel.org>
 <1405374411-29012-5-git-send-email-jolsa@kernel.org>
 <87wqbc1juy.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wqbc1juy.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 05:15:49PM +0900, Namhyung Kim wrote:

SNIP

> > index 0eeb247dc7d2..c75a42822c53 100644
> > --- a/tools/perf/Documentation/perf.txt
> > +++ b/tools/perf/Documentation/perf.txt
> > @@ -8,7 +8,15 @@ perf - Performance analysis tools for Linux
> >  SYNOPSIS
> >  --------
> >  [verse]
> > -'perf' [--version] [--help] COMMAND [ARGS]
> > +'perf' [--version] [--debug variable[=VALUE]] [--help] COMMAND [ARGS]
> 
> Hmm.. is this really needed?  Also, there're other options might be
> added here.  What about just saying
> 
>   'perf' [--version] [--help] [OPTIONS] COMMAND [ARGS]
> 
> ?
> 

yep, it's better, v3 attached

thanks,
jirka


---
Adding --debug option as a way to setup debug variables.
Starting with support for verbose, more will come.

It's possible to use it now with report command:
  $ perf --debug verbose   ...
  $ perf --debug verbose=2 ...

I'll need this support to add separated debug variable
for ordered events change in order to separate debug
output out of standard verbose stream.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Documentation/perf.txt | 10 ++++++++-
 tools/perf/perf.c                 | 13 +++++++++++-
 tools/perf/util/debug.c           | 44 +++++++++++++++++++++++++++++++++++++++
 tools/perf/util/debug.h           |  2 ++
 4 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf.txt b/tools/perf/Documentation/perf.txt
index 0eeb247dc7d2..d240bb2e5b22 100644
--- a/tools/perf/Documentation/perf.txt
+++ b/tools/perf/Documentation/perf.txt
@@ -8,7 +8,15 @@ perf - Performance analysis tools for Linux
 SYNOPSIS
 --------
 [verse]
-'perf' [--version] [--help] COMMAND [ARGS]
+'perf' [--version] [--help] [OPTIONS] COMMAND [ARGS]
+
+OPTIONS
+-------
+--debug::
+	Setup debug variable (just verbose for now) in value
+	range (0, 10). Use like:
+	  --debug verbose   # sets verbose = 1
+	  --debug verbose=2 # sets verbose = 2
 
 DESCRIPTION
 -----------
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 95c58fc15284..eed3fb2a3af0 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -13,11 +13,12 @@
 #include "util/quote.h"
 #include "util/run-command.h"
 #include "util/parse-events.h"
+#include "util/debug.h"
 #include <api/fs/debugfs.h>
 #include <pthread.h>
 
 const char perf_usage_string[] =
-	"perf [--version] [--help] COMMAND [ARGS]";
+	"perf [--version] [--debug variable[=VALUE]] [--help] COMMAND [ARGS]";
 
 const char perf_more_info_string[] =
 	"See 'perf help COMMAND' for more information on a specific command.";
@@ -212,6 +213,16 @@ static int handle_options(const char ***argv, int *argc, int *envchanged)
 				printf("%s ", p->cmd);
 			}
 			exit(0);
+		} else if (!strcmp(cmd, "--debug")) {
+			if (*argc < 2) {
+				fprintf(stderr, "No variable specified for --debug.\n");
+				usage(perf_usage_string);
+			}
+			if (perf_debug_option((*argv)[1]))
+				usage(perf_usage_string);
+
+			(*argv)++;
+			(*argc)--;
 		} else {
 			fprintf(stderr, "Unknown option: %s\n", cmd);
 			usage(perf_usage_string);
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index c208d6f56e63..71d419362634 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -105,3 +105,47 @@ void trace_event(union perf_event *event)
 	}
 	printf(".\n");
 }
+
+static struct debug_variable {
+	const char *name;
+	int *ptr;
+} debug_variables[] = {
+	{ .name = "verbose", .ptr = &verbose },
+	{ .name = NULL, }
+};
+
+int perf_debug_option(const char *str)
+{
+	struct debug_variable *var = &debug_variables[0];
+	char *vstr, *s = strdup(str);
+	int v = 1;
+
+	vstr = strchr(s, '=');
+	if (vstr)
+		*vstr++ = 0;
+
+	while (var->name) {
+		if (!strcmp(s, var->name))
+			break;
+		var++;
+	}
+
+	if (!var->name) {
+		pr_err("Unknown debug variable name '%s'\n", s);
+		free(s);
+		return -1;
+	}
+
+	if (vstr) {
+		v = atoi(vstr);
+		/*
+		 * Allow only values in range (0, 10),
+		 * otherwise set 0.
+		 */
+		v = (v < 0) || (v > 10) ? 0 : v;
+	}
+
+	*var->ptr = v;
+	free(s);
+	return 0;
+}
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 1cb808123242..89fb6b0f7ab2 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -39,4 +39,6 @@ void pr_stat(const char *fmt, ...);
 
 int eprintf(int level, int var, const char *fmt, ...) __attribute__((format(printf, 3, 4)));
 
+int perf_debug_option(const char *str);
+
 #endif	/* __PERF_DEBUG_H */
-- 
1.8.3.1

