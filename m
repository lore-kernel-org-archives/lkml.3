Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab3KANw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:52:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:23727 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab3KANw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:52:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="402157052"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V3 09/11] perf test: Update "sample parsing" test for PERF_SAMPLE_TRANSACTION
Date: Fri,  1 Nov 2013 15:51:37 +0200
Message-Id: <1383313899-15987-10-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383313899-15987-1-git-send-email-adrian.hunter@intel.com>
References: <1383313899-15987-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fact the "sample parsing" test does not automatically
check new sample type bits - they must be added to the
comparison logic.  Doing that shows that the test fails
because the functions perf_event__synthesize_sample()
and perf_event__sample_event_size() have not been
updated with PERF_SAMPLE_TRANSACTION either.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/tests/sample-parsing.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
index 61c9da2..1b67720 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -121,6 +121,9 @@ static bool samples_same(const struct perf_sample *s1,
 	if (type & PERF_SAMPLE_DATA_SRC)
 		COMP(data_src);
 
+	if (type & PERF_SAMPLE_TRANSACTION)
+		COMP(transaction);
+
 	return true;
 }
 
@@ -165,6 +168,7 @@ static int do_test(u64 sample_type, u64 sample_regs_user, u64 read_format)
 		.cpu		= 110,
 		.raw_size	= sizeof(raw_data),
 		.data_src	= 111,
+		.transaction	= 112,
 		.raw_data	= (void *)raw_data,
 		.callchain	= &callchain.callchain,
 		.branch_stack	= &branch_stack.branch_stack,
@@ -273,7 +277,8 @@ int test__sample_parsing(void)
 
 	/*
 	 * Fail the test if it has not been updated when new sample format bits
-	 * were added.
+	 * were added.  Please actually update the test rather than just change
+	 * the condition below.
 	 */
 	if (PERF_SAMPLE_MAX > PERF_SAMPLE_TRANSACTION << 1) {
 		pr_debug("sample format has changed, some new PERF_SAMPLE_ bit was introduced - test needs updating\n");
-- 
1.7.11.7

