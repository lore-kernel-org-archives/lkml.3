Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab3H0IU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:20:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:48948 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab3H0IRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:17:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,966,1367996400"; 
   d="scan'208";a="352105084"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V13 08/12] perf tools: add missing 'abi' member to 'struct regs_dump'
Date: Tue, 27 Aug 2013 11:23:10 +0300
Message-Id: <1377591794-30553-9-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377591794-30553-1-git-send-email-adrian.hunter@intel.com>
References: <1377591794-30553-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And store the parsed value there.  Note that the 'abi' is
0 (no registers), 1 (32-bit registers) or 2 (64-bit registers),
but the registers are anyway copied one-by-one as 64-bit
values onto the event i.e. see 'perf_output_sample_regs()'

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/event.h | 1 +
 tools/perf/util/evsel.c | 7 +++----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 4913339..f959801 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -62,6 +62,7 @@ struct sample_event {
 };
 
 struct regs_dump {
+	u64 abi;
 	u64 *regs;
 };
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index db4e431..1184188 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1416,13 +1416,12 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 	}
 
 	if (type & PERF_SAMPLE_REGS_USER) {
-		u64 avail;
-
 		/* First u64 tells us if we have any regs in sample. */
 		OVERFLOW_CHECK_u64(array);
-		avail = *array++;
+		data->user_regs.abi = *array;
+		array++;
 
-		if (avail) {
+		if (data->user_regs.abi) {
 			u64 regs_user = evsel->attr.sample_regs_user;
 
 			sz = hweight_long(regs_user) * sizeof(u64);
-- 
1.7.11.7

