Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaANQlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:41:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52856 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaANQlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:41:40 -0500
Date: Tue, 14 Jan 2014 08:41:24 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-6619a53ef7572b9eaf7aa71ff7f74c0d06b3817b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung@kernel.org, jolsa@redhat.com,
        ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung@kernel.org, jolsa@redhat.com,
        ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1389476307-2124-1-git-send-email-andi@firstfloor.org>
References: <1389476307-2124-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Add --initial-delay option
Git-Commit-ID: 6619a53ef7572b9eaf7aa71ff7f74c0d06b3817b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:41:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6619a53ef7572b9eaf7aa71ff7f74c0d06b3817b
Gitweb:     http://git.kernel.org/tip/6619a53ef7572b9eaf7aa71ff7f74c0d06b3817b
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 11 Jan 2014 13:38:27 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 10:07:03 -0300

perf record: Add --initial-delay option

perf stat has a --delay option to delay measuring the workload.

This is useful to skip measuring the startup phase of the program, which
is often very different from the main workload.

The same is useful for perf record when sampling.

--no-delay was already taken, so add a --initial-delay
to perf record too.
-D was already taken for record, so there is only a long option.

v2: Don't disable group members (Namhyung Kim)
v3: port to latest perf/core
    rename to --initial-delay to avoid conflict with --no-delay

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1389476307-2124-1-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-record.txt | 4 ++++
 tools/perf/builtin-record.c              | 9 ++++++++-
 tools/perf/perf.h                        | 1 +
 tools/perf/util/evsel.c                  | 3 ++-
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index c407897..82bffac 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -209,6 +209,10 @@ overrides that and uses per-thread mmaps.  A side-effect of that is that
 inheritance is automatically disabled.  --per-thread is ignored with a warning
 if combined with -a or -C options.
 
+--initial-delay msecs::
+After starting the program, wait msecs before measuring. This is useful to
+filter out the startup phase of the program, which is often very different.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8860015..07d4cf8 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -499,7 +499,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	 * (apart from group members) have enable_on_exec=1 set,
 	 * so don't spoil it by prematurely enabling them.
 	 */
-	if (!target__none(&opts->target))
+	if (!target__none(&opts->target) && !opts->initial_delay)
 		perf_evlist__enable(rec->evlist);
 
 	/*
@@ -508,6 +508,11 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	if (forks)
 		perf_evlist__start_workload(rec->evlist);
 
+	if (opts->initial_delay) {
+		usleep(opts->initial_delay * 1000);
+		perf_evlist__enable(rec->evlist);
+	}
+
 	for (;;) {
 		int hits = rec->samples;
 
@@ -877,6 +882,8 @@ const struct option record_options[] = {
 	OPT_CALLBACK('G', "cgroup", &record.evlist, "name",
 		     "monitor event in cgroup name only",
 		     parse_cgroups),
+	OPT_UINTEGER(0, "initial-delay", &record.opts.initial_delay,
+		  "ms to wait before starting measurement after program start"),
 	OPT_STRING('u', "uid", &record.opts.target.uid_str, "user",
 		   "user to profile"),
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index b1cc84b..af1ce6e 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -269,6 +269,7 @@ struct record_opts {
 	u64	     user_interval;
 	u16	     stack_dump_size;
 	bool	     sample_transaction;
+	unsigned     initial_delay;
 };
 
 #endif
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index ade8d9c..cd4630a 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -658,7 +658,8 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 	 * Setting enable_on_exec for independent events and
 	 * group leaders for traced executed by perf.
 	 */
-	if (target__none(&opts->target) && perf_evsel__is_group_leader(evsel))
+	if (target__none(&opts->target) && perf_evsel__is_group_leader(evsel) &&
+		!opts->initial_delay)
 		attr->enable_on_exec = 1;
 }
 
