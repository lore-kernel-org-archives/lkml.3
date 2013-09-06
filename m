Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab3IFTdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 15:33:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:26624 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127Ab3IFTdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 15:33:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,856,1371106800"; 
   d="scan'208";a="392153030"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 2/2] perf kvm: fix sample_type manipulation
Date: Fri,  6 Sep 2013 22:40:12 +0300
Message-Id: <1378496412-2424-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378496412-2424-1-git-send-email-adrian.hunter@intel.com>
References: <1378496412-2424-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manipulating the sample_type of an evsel requires
the use of:
	perf_evsel__set_sample_bit()
and	perf_evsel__reset_sample_bit()

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-kvm.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 47b3540..935d522 100644
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
-- 
1.7.11.7

