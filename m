Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbaCTBcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 21:32:32 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:34464 "EHLO
	lgeamrelo05.lge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752188AbaCTBbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 21:31:31 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 12/13] perf top: Add --fields option to specify output fields
Date: Thu, 20 Mar 2014 10:31:26 +0900
Message-Id: <1395279087-12554-13-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1395279087-12554-1-git-send-email-namhyung@kernel.org>
References: <1395279087-12554-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The --fields option is to allow user setup output field in any order.
It can recieve any sort keys and following (hpp) fields:

  overhead, overhead_sys, overhead_us, sample and period

If guest profiling is enabled, overhead_guest_{sys,us} will be
available too.

More more information, please see previous patch "perf report:
Add -F option to specify output fields"

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-top.txt | 9 +++++++++
 tools/perf/builtin-top.c              | 7 +++++++
 2 files changed, 16 insertions(+)

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 0acf54f203f0..50fcf97a7dc9 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -116,6 +116,15 @@ Default is to monitor all CPUS.
 	Sort by key(s): pid, comm, dso, symbol, parent, srcline, weight,
 	local_weight, abort, in_tx, transaction
 
+--fields=::
+	Specify output field - multiple keys can be specified in CSV format.
+	Following fields are available:
+	overhead, overhead_sys, overhead_us, sample and period.
+	Also it can contain any sort key(s).
+
+	By default, every sort keys not specified in --field will be appended
+	automatically.
+
 -n::
 --show-nr-samples::
 	Show a column with the number of samples.
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index bb2aa6645a7e..dcda6d5e320b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1085,6 +1085,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent, weight, local_weight,"
 		   " abort, in_tx, transaction"),
+	OPT_STRING(0, "fields", &field_order, "key[,keys...]",
+		   "output field(s): overhead, period, sample plus all of sort keys"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
 	OPT_CALLBACK_NOOPT('g', NULL, &top.record_opts,
@@ -1203,6 +1205,11 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	sort__setup_elide(stdout);
 
+	if (setup_output_field() < 0) {
+		parse_options_usage(top_usage, options, "F", 1);
+		goto out_delete_evlist;
+	}
+
 	get_term_dimensions(&top.winsize);
 	if (top.print_entries == 0) {
 		struct sigaction act = {
-- 
1.7.11.7

