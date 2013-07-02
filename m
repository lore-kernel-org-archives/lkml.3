Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab3GBT1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 15:27:43 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:54558 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab3GBT1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 15:27:36 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 2/6] perf evlist: fix use of uninitialized variable
Date: Tue,  2 Jul 2013 13:27:21 -0600
Message-Id: <1372793245-4136-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1372793245-4136-1-git-send-email-dsahern@gmail.com>
References: <1372793245-4136-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes valgrind complaint:
==1870== Syscall param write(buf) points to uninitialised byte(s)
==1870==    at 0x4E3F5B0: __write_nocancel (in /lib64/libpthread-2.14.90.so)
==1870==    by 0x449D7C: perf_evlist__start_workload (evlist.c:846)
==1870==    by 0x427BC1: cmd_record (builtin-record.c:561)
==1870==    by 0x419D72: run_builtin (perf.c:319)
==1870==    by 0x4195F2: main (perf.c:376)
==1870==  Address 0x7feffcdd7 is on thread 1's stack

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/evlist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 4a901be..d8f34e0 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -838,7 +838,7 @@ out_close_ready_pipe:
 int perf_evlist__start_workload(struct perf_evlist *evlist)
 {
 	if (evlist->workload.cork_fd > 0) {
-		char bf;
+		char bf = 0;
 		int ret;
 		/*
 		 * Remove the cork, let it rip!
-- 
1.7.10.1

