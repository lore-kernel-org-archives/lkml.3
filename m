Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934052Ab3LITlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:41:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54996 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761346Ab3LIThX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:37:23 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/21] perf script: Fix symoff printing in callchains
Date: Mon,  9 Dec 2013 16:36:53 -0300
Message-Id: <1386617830-18926-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386617830-18926-1-git-send-email-acme@infradead.org>
References: <1386617830-18926-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

The address being used to calculate the offset was the memory address
but the address needed is the address mapped to the dso. i.e. the 'addr'
member of 'struct addr_location'

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1386315778-11633-2-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 8a7da6f4a569..c236b38ed02b 100644
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
1.8.1.4

