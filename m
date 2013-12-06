Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3LFHfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 02:35:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:4740 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207Ab3LFHfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 02:35:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,839,1378882800"; 
   d="scan'208";a="447839397"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH V2 1/3] perf script: Fix symoff printing in callchains
Date: Fri,  6 Dec 2013 09:42:56 +0200
Message-Id: <1386315778-11633-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386315778-11633-1-git-send-email-adrian.hunter@intel.com>
References: <1386315778-11633-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The address being used to calculate the offset was
the memory address but the address needed is the
address mapped to the dso. i.e. the 'addr' member
of 'struct addr_location'

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/session.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 8a7da6f..c236b38 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1515,6 +1515,8 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, struct perf_sample *sample,
 			node_al = *al;
 
 		while (stack_depth) {
+			u64 addr = 0;
+
 			node = callchain_cursor_current(&callchain_cursor);
 			if (!node)
 				break;
@@ -1525,10 +1527,13 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, struct perf_sample *sample,
 			if (print_ip)
 				printf("%c%16" PRIx64, s, node->ip);
 
+			if (node->map)
+				addr = node->map->map_ip(node->map, node->ip);
+
 			if (print_sym) {
 				printf(" ");
 				if (print_symoffset) {
-					node_al.addr = node->ip;
+					node_al.addr = addr;
 					node_al.map  = node->map;
 					symbol__fprintf_symname_offs(node->sym, &node_al, stdout);
 				} else
-- 
1.7.11.7

