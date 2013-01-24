Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab3AXTNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:13:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33358 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab3AXTNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:13:12 -0500
Date: Thu, 24 Jan 2013 11:12:41 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-jg0dh8rmlx7x11e7u7mnasvd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record:
  Export the callchain parsing routine and help
Git-Commit-ID: 75d9a10854db6aab2400cd6a844c392107be4c64
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 11:12:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  75d9a10854db6aab2400cd6a844c392107be4c64
Gitweb:     http://git.kernel.org/tip/75d9a10854db6aab2400cd6a844c392107be4c64
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 11 Dec 2012 16:46:05 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 11 Dec 2012 17:22:14 -0300

perf record: Export the callchain parsing routine and help

Will be used by perf top, that will first setup the symbol system to
deal with callchains and then call these routines to ask the kernel
for callchains.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-jg0dh8rmlx7x11e7u7mnasvd@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 11 ++++++-----
 tools/perf/util/callchain.h |  5 +++++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d035040..028de72 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -868,7 +868,8 @@ static int get_stack_size(char *str, unsigned long *_size)
 }
 #endif /* LIBUNWIND_SUPPORT */
 
-static int parse_callchain_opt(const struct option *opt, const char *arg, int unset)
+int record_parse_callchain_opt(const struct option *opt,
+			       const char *arg, int unset)
 {
 	struct perf_record_opts *opts = opt->value;
 	char *tok, *name, *saveptr = NULL;
@@ -973,9 +974,9 @@ static struct perf_record record = {
 #define CALLCHAIN_HELP "do call-graph (stack chain/backtrace) recording: "
 
 #ifdef LIBUNWIND_SUPPORT
-static const char callchain_help[] = CALLCHAIN_HELP "[fp] dwarf";
+const char record_callchain_help[] = CALLCHAIN_HELP "[fp] dwarf";
 #else
-static const char callchain_help[] = CALLCHAIN_HELP "[fp]";
+const char record_callchain_help[] = CALLCHAIN_HELP "[fp]";
 #endif
 
 /*
@@ -1020,8 +1021,8 @@ const struct option record_options[] = {
 	OPT_BOOLEAN(0, "group", &record.opts.group,
 		    "put the counters into a counter group"),
 	OPT_CALLBACK_DEFAULT('g', "call-graph", &record.opts,
-			     "mode[,dump_size]", callchain_help,
-			     &parse_callchain_opt, "fp"),
+			     "mode[,dump_size]", record_callchain_help,
+			     &record_parse_callchain_opt, "fp"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_BOOLEAN('q', "quiet", &quiet, "don't print any message"),
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index eb34057..3ee9f67 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -143,4 +143,9 @@ static inline void callchain_cursor_advance(struct callchain_cursor *cursor)
 	cursor->curr = cursor->curr->next;
 	cursor->pos++;
 }
+
+struct option;
+
+int record_parse_callchain_opt(const struct option *opt, const char *arg, int unset);
+extern const char record_callchain_help[];
 #endif	/* __PERF_CALLCHAIN_H */
