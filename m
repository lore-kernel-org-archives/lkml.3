Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760858AbaGYPhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:37:35 -0400
Received: from mail.kernel.org ([198.145.19.201]:34905 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbaGYPhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:37:33 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/27] perf script: Improve srcline display for BTS
Date: Fri, 25 Jul 2014 12:36:45 -0300
Message-Id: <1406302629-11790-4-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406302629-11790-1-git-send-email-acme@kernel.org>
References: <1406302629-11790-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Change the order of the output to put the srcline last.

It puts the branch 'from address' and 'to address' on the same line,
which is how it would be without the source line reference.

So it makes it consistent and much easier to read.

E.g. old format:

          4028fc main+0x2c (/bin/ls)
  /build/buildd/coreutils-8.20/src/ls.c:1269 =>           40d8a0 set_program_name+0x0 (/bin/ls)

new format:

          4028fc main+0x2c (/bin/ls) =>           40d8a0 set_program_name+0x0 (/bin/ls)
  /build/buildd/coreutils-8.20/src/ls.c:1269

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406035081-14301-7-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 9e9c91f5b7fa..333b15ebe72b 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -427,15 +427,22 @@ static void print_sample_bts(union perf_event *event,
 			     struct addr_location *al)
 {
 	struct perf_event_attr *attr = &evsel->attr;
+	bool print_srcline_last = false;
 
 	/* print branch_from information */
 	if (PRINT_FIELD(IP)) {
-		if (!symbol_conf.use_callchain)
-			printf(" ");
-		else
+		unsigned int print_opts = output[attr->type].print_ip_opts;
+
+		if (symbol_conf.use_callchain && sample->callchain) {
 			printf("\n");
-		perf_evsel__print_ip(evsel, sample, al,
-				     output[attr->type].print_ip_opts,
+		} else {
+			printf(" ");
+			if (print_opts & PRINT_IP_OPT_SRCLINE) {
+				print_srcline_last = true;
+				print_opts &= ~PRINT_IP_OPT_SRCLINE;
+			}
+		}
+		perf_evsel__print_ip(evsel, sample, al, print_opts,
 				     PERF_MAX_STACK_DEPTH);
 	}
 
@@ -447,6 +454,9 @@ static void print_sample_bts(union perf_event *event,
 	     !output[attr->type].user_set))
 		print_sample_addr(event, sample, al->machine, thread, attr);
 
+	if (print_srcline_last)
+		map__fprintf_srcline(al->map, al->addr, "\n  ", stdout);
+
 	printf("\n");
 }
 
-- 
1.9.3

