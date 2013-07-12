Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab3GLIv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 04:51:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54836 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab3GLIvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 04:51:51 -0400
Date: Fri, 12 Jul 2013 01:51:17 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-7cab84e8975cfb8a59ce3e79ce75e5eedd384484@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1372793245-4136-2-git-send-email-dsahern@gmail.com>
References: <1372793245-4136-2-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evsel:
  Fix count parameter to read call in event_format__new
Git-Commit-ID: 7cab84e8975cfb8a59ce3e79ce75e5eedd384484
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 01:51:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7cab84e8975cfb8a59ce3e79ce75e5eedd384484
Gitweb:     http://git.kernel.org/tip/7cab84e8975cfb8a59ce3e79ce75e5eedd384484
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Tue, 2 Jul 2013 13:27:20 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Jul 2013 17:40:39 -0300

perf evsel: Fix count parameter to read call in event_format__new

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
