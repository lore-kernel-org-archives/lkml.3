Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750978Ab3IFGnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 02:43:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:34199 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813Ab3IFGnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 02:43:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,852,1371106800"; 
   d="scan'208";a="397541518"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH] perf kvm: fix sample_type manipulation
Date: Fri,  6 Sep 2013 09:48:54 +0300
Message-Id: <1378450134-28982-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manipulating the sample_type of an evsel requires
the use of:
	perf_evsel__set_sample_bit()
and	perf_evsel__reset_sample_bit()

Manipulating the sample type of an evlist requires
the id position to be recalculated.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-kvm.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 47b3540..0b7c5a9 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1165,16 +1165,16 @@ static int kvm_live_open_events(struct perf_kvm_stat *kvm)
 		struct perf_event_attr *attr = &pos->attr;
 
 		/* make sure these *are* set */
-		attr->sample_type |= PERF_SAMPLE_TID;
-		attr->sample_type |= PERF_SAMPLE_TIME;
-		attr->sample_type |= PERF_SAMPLE_CPU;
-		attr->sample_type |= PERF_SAMPLE_RAW;
+		perf_evsel__set_sample_bit(pos, TID);
+		perf_evsel__set_sample_bit(pos, TIME);
+		perf_evsel__set_sample_bit(pos, CPU);
+		perf_evsel__set_sample_bit(pos, RAW);
 		/* make sure these are *not*; want as small a sample as possible */
-		attr->sample_type &= ~PERF_SAMPLE_PERIOD;
-		attr->sample_type &= ~PERF_SAMPLE_IP;
-		attr->sample_type &= ~PERF_SAMPLE_CALLCHAIN;
-		attr->sample_type &= ~PERF_SAMPLE_ADDR;
-		attr->sample_type &= ~PERF_SAMPLE_READ;
+		perf_evsel__reset_sample_bit(pos, PERIOD);
+		perf_evsel__reset_sample_bit(pos, IP);
+		perf_evsel__reset_sample_bit(pos, CALLCHAIN);
+		perf_evsel__reset_sample_bit(pos, ADDR);
+		perf_evsel__reset_sample_bit(pos, READ);
 		attr->mmap = 0;
 		attr->comm = 0;
 		attr->task = 0;
@@ -1188,6 +1188,8 @@ static int kvm_live_open_events(struct perf_kvm_stat *kvm)
 		attr->disabled = 1;
 	}
 
+	perf_evlist__set_id_pos(evlist);
+
 	err = perf_evlist__open(evlist);
 	if (err < 0) {
 		printf("Couldn't create the events: %s\n", strerror(errno));
-- 
1.7.11.7

