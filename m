Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab3K0UZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:25:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33292 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758443Ab3K0UZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:25:38 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/34] perf record: Default -t option to no inheritance
Date: Wed, 27 Nov 2013 17:16:13 -0300
Message-Id: <1385583394-3703-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385583394-3703-1-git-send-email-acme@infradead.org>
References: <1385583394-3703-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

The change to per-cpu mmaps causes the -p, -t and -u options now to have
inheritance enabled by default.  Change that back to no inheritance but
for the -t option only.

Requested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1384768557-23331-5-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-record.txt | 2 ++
 tools/perf/builtin-record.c              | 8 ++++++--
 tools/perf/perf.h                        | 1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 6ac867e7667f..c407897f0435 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -57,6 +57,8 @@ OPTIONS
 -t::
 --tid=::
         Record events on existing thread ID (comma separated list).
+        This option also disables inheritance by default.  Enable it by adding
+        --inherit.
 
 -u::
 --uid=::
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f5b18b8fe8c9..65615a8bc25e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -843,8 +843,9 @@ const struct option record_options[] = {
 	OPT_U64('c', "count", &record.opts.user_interval, "event period to sample"),
 	OPT_STRING('o', "output", &record.file.path, "file",
 		    "output file name"),
-	OPT_BOOLEAN('i', "no-inherit", &record.opts.no_inherit,
-		    "child tasks do not inherit counters"),
+	OPT_BOOLEAN_SET('i', "no-inherit", &record.opts.no_inherit,
+			&record.opts.no_inherit_set,
+			"child tasks do not inherit counters"),
 	OPT_UINTEGER('F', "freq", &record.opts.user_freq, "profile at this frequency"),
 	OPT_CALLBACK('m', "mmap-pages", &record.opts.mmap_pages, "pages",
 		     "number of mmap data pages",
@@ -939,6 +940,9 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 		goto out_symbol_exit;
 	}
 
+	if (rec->opts.target.tid && !rec->opts.no_inherit_set)
+		rec->opts.no_inherit = true;
+
 	err = target__validate(&rec->opts.target);
 	if (err) {
 		target__strerror(&rec->opts.target, err, errbuf, BUFSIZ);
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index b079304bd53d..b23fed527514 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -254,6 +254,7 @@ struct perf_record_opts {
 	bool	     inherit_stat;
 	bool	     no_delay;
 	bool	     no_inherit;
+	bool	     no_inherit_set;
 	bool	     no_samples;
 	bool	     raw_samples;
 	bool	     sample_address;
-- 
1.8.1.4

