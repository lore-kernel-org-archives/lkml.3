Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab3LKLEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:04:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60120 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab3LKLEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:04:36 -0500
Date: Wed, 11 Dec 2013 03:04:01 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-a4eb24a49566db77ee999b46603f602a0302f481@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@redhat.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, ak@linux.intel.com,
        tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, mingo@redhat.com, eranian@google.com,
        acme@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        jolsa@redhat.com, fweisbec@gmail.com, ak@linux.intel.com,
        dsahern@gmail.com, tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
In-Reply-To: <1386315778-11633-2-git-send-email-adrian.hunter@intel.com>
References: <1386315778-11633-2-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Fix symoff printing in callchains
Git-Commit-ID: a4eb24a49566db77ee999b46603f602a0302f481
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:04:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a4eb24a49566db77ee999b46603f602a0302f481
Gitweb:     http://git.kernel.org/tip/a4eb24a49566db77ee999b46603f602a0302f481
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Fri, 6 Dec 2013 09:42:56 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 9 Dec 2013 11:13:50 -0300

perf script: Fix symoff printing in callchains

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
