Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbaIXLtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:49:53 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49786 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaIXLtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:49:51 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        acme@redhat.com, cebbert.lkml@gmail.com
Subject: [PATCH v7 4/6] perf/tests: add interrupted state sample parsing test
Date: Wed, 24 Sep 2014 13:48:40 +0200
Message-Id: <1411559322-16548-5-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411559322-16548-1-git-send-email-eranian@google.com>
References: <1411559322-16548-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the sample parsing test with support
for the sampling of machine interrupted state.

The patch modifies the do_test() code to sahred the sample
regts bitmask between user and intr regs.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/tests/sample-parsing.c |   55 +++++++++++++++++++++++++++----------
 1 file changed, 40 insertions(+), 15 deletions(-)

diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
index ca292f9..4908c64 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -126,16 +126,28 @@ static bool samples_same(const struct perf_sample *s1,
 	if (type & PERF_SAMPLE_TRANSACTION)
 		COMP(transaction);
 
+	if (type & PERF_SAMPLE_REGS_INTR) {
+		size_t sz = hweight_long(s1->intr_regs.mask) * sizeof(u64);
+
+		COMP(intr_regs.mask);
+		COMP(intr_regs.abi);
+		if (s1->intr_regs.abi &&
+		    (!s1->intr_regs.regs || !s2->intr_regs.regs ||
+		     memcmp(s1->intr_regs.regs, s2->intr_regs.regs, sz))) {
+			pr_debug("Samples differ at 'intr_regs'\n");
+			return false;
+		}
+	}
+
 	return true;
 }
 
-static int do_test(u64 sample_type, u64 sample_regs_user, u64 read_format)
+static int do_test(u64 sample_type, u64 sample_regs, u64 read_format)
 {
 	struct perf_evsel evsel = {
 		.needs_swap = false,
 		.attr = {
 			.sample_type = sample_type,
-			.sample_regs_user = sample_regs_user,
 			.read_format = read_format,
 		},
 	};
@@ -154,7 +166,7 @@ static int do_test(u64 sample_type, u64 sample_regs_user, u64 read_format)
 		/* 1 branch_entry */
 		.data = {1, 211, 212, 213},
 	};
-	u64 user_regs[64];
+	u64 regs[64];
 	const u64 raw_data[] = {0x123456780a0b0c0dULL, 0x1102030405060708ULL};
 	const u64 data[] = {0x2211443366558877ULL, 0, 0xaabbccddeeff4321ULL};
 	struct perf_sample sample = {
@@ -176,8 +188,8 @@ static int do_test(u64 sample_type, u64 sample_regs_user, u64 read_format)
 		.branch_stack	= &branch_stack.branch_stack,
 		.user_regs	= {
 			.abi	= PERF_SAMPLE_REGS_ABI_64,
-			.mask	= sample_regs_user,
-			.regs	= user_regs,
+			.mask	= sample_regs,
+			.regs	= regs,
 		},
 		.user_stack	= {
 			.size	= sizeof(data),
@@ -187,14 +199,25 @@ static int do_test(u64 sample_type, u64 sample_regs_user, u64 read_format)
 			.time_enabled = 0x030a59d664fca7deULL,
 			.time_running = 0x011b6ae553eb98edULL,
 		},
+		.intr_regs	= {
+			.abi	= PERF_SAMPLE_REGS_ABI_64,
+			.mask	= sample_regs,
+			.regs	= regs,
+		},
 	};
 	struct sample_read_value values[] = {{1, 5}, {9, 3}, {2, 7}, {6, 4},};
 	struct perf_sample sample_out;
 	size_t i, sz, bufsz;
 	int err, ret = -1;
 
-	for (i = 0; i < sizeof(user_regs); i++)
-		*(i + (u8 *)user_regs) = i & 0xfe;
+	if (sample_type & PERF_SAMPLE_REGS_USER)
+		evsel.attr.sample_regs_user = sample_regs;
+
+	if (sample_type & PERF_SAMPLE_REGS_INTR)
+		evsel.attr.sample_regs_intr = sample_regs;
+
+	for (i = 0; i < sizeof(regs); i++)
+		*(i + (u8 *)regs) = i & 0xfe;
 
 	if (read_format & PERF_FORMAT_GROUP) {
 		sample.read.group.nr     = 4;
@@ -271,7 +294,7 @@ int test__sample_parsing(void)
 {
 	const u64 rf[] = {4, 5, 6, 7, 12, 13, 14, 15};
 	u64 sample_type;
-	u64 sample_regs_user;
+	u64 sample_regs;
 	size_t i;
 	int err;
 
@@ -280,7 +303,7 @@ int test__sample_parsing(void)
 	 * were added.  Please actually update the test rather than just change
 	 * the condition below.
 	 */
-	if (PERF_SAMPLE_MAX > PERF_SAMPLE_TRANSACTION << 1) {
+	if (PERF_SAMPLE_MAX > PERF_SAMPLE_REGS_INTR << 1) {
 		pr_debug("sample format has changed, some new PERF_SAMPLE_ bit was introduced - test needs updating\n");
 		return -1;
 	}
@@ -297,22 +320,24 @@ int test__sample_parsing(void)
 			}
 			continue;
 		}
+		sample_regs = 0;
 
 		if (sample_type == PERF_SAMPLE_REGS_USER)
-			sample_regs_user = 0x3fff;
-		else
-			sample_regs_user = 0;
+			sample_regs = 0x3fff;
+
+		if (sample_type == PERF_SAMPLE_REGS_INTR)
+			sample_regs = 0xff0fff;
 
-		err = do_test(sample_type, sample_regs_user, 0);
+		err = do_test(sample_type, sample_regs, 0);
 		if (err)
 			return err;
 	}
 
 	/* Test all sample format bits together */
 	sample_type = PERF_SAMPLE_MAX - 1;
-	sample_regs_user = 0x3fff;
+	sample_regs = 0x3fff; /* shared yb intr and user regs */
 	for (i = 0; i < ARRAY_SIZE(rf); i++) {
-		err = do_test(sample_type, sample_regs_user, rf[i]);
+		err = do_test(sample_type, sample_regs, rf[i]);
 		if (err)
 			return err;
 	}
-- 
1.7.9.5

