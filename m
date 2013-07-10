Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab3GJTTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:19:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56806 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab3GJTTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:19:51 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/23] perf evsel: Fix count parameter to read call in event_format__new
Date: Wed, 10 Jul 2013 16:19:13 -0300
Message-Id: <1373483963-19277-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373483963-19277-1-git-send-email-acme@infradead.org>
References: <1373483963-19277-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

per realloc above the length of the buffer is alloc_size, not BUFSIZ.
Adjust length per size as done for buf start.

Addresses some valgrind complaints:

==1870== Syscall param read(buf) points to unaddressable byte(s)
==1870==    at 0x4E3F610: __read_nocancel (in /lib64/libpthread-2.14.90.so)
==1870==    by 0x44AEE1: event_format__new (unistd.h:45)
==1870==    by 0x44B025: perf_evsel__newtp (evsel.c:158)
==1870==    by 0x451919: add_tracepoint_event (parse-events.c:395)
==1870==    by 0x479815: parse_events_parse (parse-events.y:292)
==1870==    by 0x45463A: parse_events_option (parse-events.c:861)
==1870==    by 0x44FEE4: get_value (parse-options.c:113)
==1870==    by 0x450767: parse_options_step (parse-options.c:192)
==1870==    by 0x450C40: parse_options (parse-options.c:422)
==1870==    by 0x42735F: cmd_record (builtin-record.c:918)
==1870==    by 0x419D72: run_builtin (perf.c:319)
==1870==    by 0x4195F2: main (perf.c:376)
==1870==  Address 0xcffebf0 is 0 bytes after a block of size 8,192 alloc'd
==1870==    at 0x4C2A62F: malloc (vg_replace_malloc.c:270)
==1870==    by 0x4C2A7A3: realloc (vg_replace_malloc.c:662)
==1870==    by 0x44AF07: event_format__new (evsel.c:121)
==1870==    by 0x44B025: perf_evsel__newtp (evsel.c:158)
==1870==    by 0x451919: add_tracepoint_event (parse-events.c:395)
==1870==    by 0x479815: parse_events_parse (parse-events.y:292)
==1870==    by 0x45463A: parse_events_option (parse-events.c:861)
==1870==    by 0x44FEE4: get_value (parse-options.c:113)
==1870==    by 0x450767: parse_options_step (parse-options.c:192)
==1870==    by 0x450C40: parse_options (parse-options.c:422)
==1870==    by 0x42735F: cmd_record (builtin-record.c:918)
==1870==    by 0x419D72: run_builtin (perf.c:319)

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1372793245-4136-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 63b6f8c..df99ebe 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -124,7 +124,7 @@ struct event_format *event_format__new(const char *sys, const char *name)
 			bf = nbf;
 		}
 
-		n = read(fd, bf + size, BUFSIZ);
+		n = read(fd, bf + size, alloc_size - size);
 		if (n < 0)
 			goto out_free_bf;
 		size += n;
-- 
1.8.1.4

