Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbaGaGpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:45:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:9710 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932080AbaGaGpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:45:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="578059886"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH v4 9/9] tools, perf: Allow the user to disable time stamps
Date: Thu, 31 Jul 2014 14:45:04 +0800
Message-Id: <1406789104-25863-10-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406789104-25863-1-git-send-email-zheng.z.yan@intel.com>
References: <1406789104-25863-1-git-send-email-zheng.z.yan@intel.com>
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
index 4869050..ca0251e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -781,6 +781,7 @@ static const char * const record_usage[] = {
  */
 static struct record record = {
 	.opts = {
+		.sample_time	     = true,
 		.mmap_pages	     = UINT_MAX,
 		.user_freq	     = UINT_MAX,
 		.user_interval	     = ULLONG_MAX,
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 21a373e..92e5235 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -633,9 +633,12 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
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
 
 	if (opts->raw_samples && !evsel->no_aux_samples) {
-- 
1.9.3

