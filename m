Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab3K3MwA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:52:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59652 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab3K3Mv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:51:56 -0500
Date: Sat, 30 Nov 2013 04:51:05 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-69e7e5b02bc6a9e5cf4a54911b27ca133cc1f99f@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@redhat.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, peterz@infradead.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, mingo@redhat.com, eranian@google.com,
        acme@redhat.com, a.p.zijlstra@chello.nl, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
In-Reply-To: <1384768557-23331-5-git-send-email-adrian.hunter@intel.com>
References: <1384768557-23331-5-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Default -t option to no inheritance
Git-Commit-ID: 69e7e5b02bc6a9e5cf4a54911b27ca133cc1f99f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:51:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  69e7e5b02bc6a9e5cf4a54911b27ca133cc1f99f
Gitweb:     http://git.kernel.org/tip/69e7e5b02bc6a9e5cf4a54911b27ca133cc1f99f
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 18 Nov 2013 11:55:57 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 14:58:36 -0300

perf record: Default -t option to no inheritance

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
