Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaGNKFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:05:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:22558 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313AbaGNKE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:04:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,657,1400050800"; 
   d="scan'208";a="561434263"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 15/41] perf script: Improve srcline display for BTS
Date: Mon, 14 Jul 2014 13:02:39 +0300
Message-Id: <1405332185-4050-16-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
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
index 9e9c91f..333b15e 100644
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
1.8.3.2

