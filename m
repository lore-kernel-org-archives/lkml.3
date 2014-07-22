Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbaGVILE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 04:11:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:46717 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbaGVIK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 04:10:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,708,1400050800"; 
   d="scan'208";a="573497523"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH v3 9/9] tools, perf: Allow the user to disable time stamps
Date: Tue, 22 Jul 2014 16:10:02 +0800
Message-Id: <1406016602-31845-10-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406016602-31845-1-git-send-email-zheng.z.yan@intel.com>
References: <1406016602-31845-1-git-send-email-zheng.z.yan@intel.com>
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
index 378b85b..8728c7c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -776,6 +776,7 @@ static const char * const record_usage[] = {
  */
 static struct record record = {
 	.opts = {
+		.sample_time	     = true,
 		.mmap_pages	     = UINT_MAX,
 		.user_freq	     = UINT_MAX,
 		.user_interval	     = ULLONG_MAX,
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 8606175..1bc4093 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -632,9 +632,12 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
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
1.9.3

