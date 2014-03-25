Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbaCYUpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:45:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:45963 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332AbaCYUpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:45:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,730,1389772800"; 
   d="scan'208";a="506606917"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        eranian@google.com, namhyung@kernel.org, jolsa@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] tools, perf: Allow the user to disable time stamps
Date: Tue, 25 Mar 2014 13:44:32 -0700
Message-Id: <1395780272-27106-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

[post with updated description]

Time stamps are always implicitely enabled for record currently.
The old --time/-T option is a nop.

The time stamps are needed to handle library mmaps correctly.
This mainly matters at program startup, but is not useful
when profiling long running programs.

Allow the user to disable timestamps by using --no-time

This can cause some minor misaccounting, but lowers the
size of the perf.data nicely:

% perl -e 'while(1) {}' &
[1] 5827
% perf record -p 5827 --no-time -c 1000003 sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.089 MB perf.data (~3872 samples) ]
% perf record -p 5827  -c 1000003  sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.114 MB perf.data (~4967 samples) ]

22% smaller data file, even though we got more samples.
It also seems to speed up perf slightly, that is why we get more
samples.

The defaults are unchanged.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/builtin-record.c | 1 +
 tools/perf/util/evsel.c     | 9 ++++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 3c394bf..8e92d3c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -800,6 +800,7 @@ static const char * const record_usage[] = {
  */
 static struct record record = {
 	.opts = {
+		.sample_time	     = true,
 		.mmap_pages	     = UINT_MAX,
 		.user_freq	     = UINT_MAX,
 		.user_interval	     = ULLONG_MAX,
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 22e18a2..a15efc4 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -613,9 +613,12 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 	if (opts->period)
 		perf_evsel__set_sample_bit(evsel, PERIOD);
 
-	if (!perf_missing_features.sample_id_all &&
-	    (opts->sample_time || !opts->no_inherit ||
-	     target__has_cpu(&opts->target) || per_cpu))
+	/*
+	 * When the user explicitely disabled time don't force it here.
+	 */
+	if (opts->sample_time &&
+	    (!perf_missing_features.sample_id_all &&
+	    (!opts->no_inherit || target__has_cpu(&opts->target) || per_cpu)))
 		perf_evsel__set_sample_bit(evsel, TIME);
 
 	if (opts->raw_samples) {
-- 
1.8.5.3

