Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab3GBTmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 15:42:12 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33986 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab3GBT1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 15:27:33 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 1/6] perf evsel: fix count parameter to read call in event_format__new
Date: Tue,  2 Jul 2013 13:27:20 -0600
Message-Id: <1372793245-4136-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1372793245-4136-1-git-send-email-dsahern@gmail.com>
References: <1372793245-4136-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/evsel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index dea0684..01fdfc6 100644
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
1.7.10.1

