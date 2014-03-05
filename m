Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbaCETwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 14:52:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:12245 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756534AbaCETtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 14:49:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,594,1389772800"; 
   d="scan'208";a="492970299"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        eranian@google.com, namhyung@kernel.org, jolsa@redhat.com,
        Andi Kleen <ak@linux.intel.com>, fweisbec@gmail.com
Subject: [PATCH 7/8] perf, tools, record: Always allow to overide default period
Date: Wed,  5 Mar 2014 11:49:37 -0800
Message-Id: <1394048978-15909-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394048978-15909-1-git-send-email-andi@firstfloor.org>
References: <1394048978-15909-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Fix the logic to allow overriding event default periods with -c or -F
on the command line. I'm not sure what the previous if was supposed
to do, it didn't work and seemed bogus. I just remove the extra
check and unconditionally allow overiding when the user set
an option.

This fixed specifying -c / -F with json event list events,
which have a default period. It should do the same
for trace point events.

Cc: fweisbec@gmail.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/evsel.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index adc94dd..ca4b976 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -561,19 +561,15 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 	}
 
 	/*
-	 * We default some events to a 1 default interval. But keep
-	 * it a weak assumption overridable by the user.
+	 * Let the user override any default periods.
 	 */
-	if (!attr->sample_period || (opts->user_freq != UINT_MAX &&
-				     opts->user_interval != ULLONG_MAX)) {
-		if (opts->freq) {
-			perf_evsel__set_sample_bit(evsel, PERIOD);
-			attr->freq		= 1;
-			attr->sample_freq	= opts->freq;
-		} else {
-			attr->sample_period = opts->default_interval;
-		}
+	if (opts->user_freq != UINT_MAX) {
+		perf_evsel__set_sample_bit(evsel, PERIOD);
+		attr->freq		= 1;
+		attr->sample_freq	= opts->freq;
 	}
+	if (opts->user_interval != ULLONG_MAX)
+		attr->sample_period = opts->default_interval;
 
 	/*
 	 * Disable sampling for all group members other
-- 
1.8.5.3

