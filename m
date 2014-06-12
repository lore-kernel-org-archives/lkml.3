Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbaFLPbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:31:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984AbaFLPbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:31:11 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 01/14] perf record: Fix to honor user freq/interval properly
Date: Thu, 12 Jun 2014 17:30:32 +0200
Message-Id: <1402587045-5461-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1402587045-5461-1-git-send-email-jolsa@kernel.org>
References: <1402587045-5461-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

When configuring event perf checked a wrong condition that user
specified both of freq (-F) and period (-c) or the event has no
default value.  This worked because most of events don't have default
value and only tracepoint events have default of 1 (and it's not
desirable to change it for those events).

However, Andi's downloadable event patch changes the situation so it
cannot change the value for those events.  Fix it by allowing override
the default value if user gives one of the options.

  $ perf record -a -e uops_retired.all -F 4000 sleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.325 MB perf.data (~14185 samples) ]

  $ perf evlist -F
  cpu/uops_retired.all/: sample_freq=4000

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1402292617-26278-1-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/evsel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 21154da..8606175 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -589,10 +589,10 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 	}
 
 	/*
-	 * We default some events to a 1 default interval. But keep
+	 * We default some events to have a default interval. But keep
 	 * it a weak assumption overridable by the user.
 	 */
-	if (!attr->sample_period || (opts->user_freq != UINT_MAX &&
+	if (!attr->sample_period || (opts->user_freq != UINT_MAX ||
 				     opts->user_interval != ULLONG_MAX)) {
 		if (opts->freq) {
 			perf_evsel__set_sample_bit(evsel, PERIOD);
-- 
1.8.3.1

