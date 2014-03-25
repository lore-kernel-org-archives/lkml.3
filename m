Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbaCYUe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:34:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:31920 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122AbaCYUeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:34:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,730,1389772800"; 
   d="scan'208";a="507434035"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        eranian@google.com, namhyung@kernel.org, jolsa@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] tools, perf: Allow the user to disable time stamps
Date: Tue, 25 Mar 2014 13:34:05 -0700
Message-Id: <1395779645-25452-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Time stamps are always implicitely enabled for record currently.
The old --time/-T option is a nop.

Allow the user to disable timestamps by using --no-time

This can cause some minor misaccounting (by missing mmaps), but significantly
lowers the size of perf.data

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

