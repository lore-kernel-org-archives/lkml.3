Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab3KRJtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:49:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:49734 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784Ab3KRJs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:48:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,722,1378882800"; 
   d="scan'208";a="435266954"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/4] perf record: Default -t option to no inheritance
Date: Mon, 18 Nov 2013 11:55:57 +0200
Message-Id: <1384768557-23331-5-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1384768557-23331-1-git-send-email-adrian.hunter@intel.com>
References: <1384768557-23331-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The change to per-cpu mmaps causes the -p, -t
and -u options now to have inheritance enabled
by default.  Change that back to no inheritance
but for the -t option only.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Requested-by: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/Documentation/perf-record.txt | 2 ++
 tools/perf/builtin-record.c              | 8 ++++++--
 tools/perf/perf.h                        | 1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 6ac867e..c407897 100644
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
index f5b18b8..65615a8 100644
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
index b079304..b23fed5 100644
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
1.7.11.7

