Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab3LFHfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 02:35:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:4740 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756067Ab3LFHfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 02:35:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,839,1378882800"; 
   d="scan'208";a="447839472"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH V2 3/3] perf script: Improve srcline display for BTS
Date: Fri,  6 Dec 2013 09:42:58 +0200
Message-Id: <1386315778-11633-4-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386315778-11633-1-git-send-email-adrian.hunter@intel.com>
References: <1386315778-11633-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the order of the output to put the srcline last.
e.g. old format:

          4028fc main+0x2c (/bin/ls)
  /build/buildd/coreutils-8.20/src/ls.c:1269 =>           40d8a0 set_program_name+0x0 (/bin/ls)

new format:

          4028fc main+0x2c (/bin/ls) =>           40d8a0 set_program_name+0x0 (/bin/ls)
  /build/buildd/coreutils-8.20/src/ls.c:1269

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-script.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 7a571fb..8997b69 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -428,15 +428,22 @@ static void print_sample_bts(union perf_event *event,
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
-		perf_evsel__print_ip(evsel, sample, machine, al,
-				     output[attr->type].print_ip_opts,
+		} else {
+			printf(" ");
+			if (print_opts & PRINT_IP_OPT_SRCLINE) {
+				print_srcline_last = true;
+				print_opts &= ~PRINT_IP_OPT_SRCLINE;
+			}
+		}
+		perf_evsel__print_ip(evsel, sample, machine, al, print_opts,
 				     PERF_MAX_STACK_DEPTH);
 	}
 
@@ -448,6 +455,9 @@ static void print_sample_bts(union perf_event *event,
 	     !output[attr->type].user_set))
 		print_sample_addr(event, sample, machine, thread, attr);
 
+	if (print_srcline_last)
+		map__fprintf_srcline(al->map, al->addr, "\n  ", stdout);
+
 	printf("\n");
 }
 
-- 
1.7.11.7

