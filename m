Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab3IJJ6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 05:58:51 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46811 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750986Ab3IJJ6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 05:58:49 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-alpha@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Cree <mcree@orcon.net.nz>, Matt Turner <mattst88@gmail.com>
Subject: [PATCH] alpha: perf: fix out-of-bounds array access triggered from raw event
Date: Tue, 10 Sep 2013 10:58:12 +0100
Message-Id: <1378807092-28674-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vince's perf fuzzer uncovered the following issue on Alpha:

Unable to handle kernel paging request at virtual address fffffbfe4e46a0e8
CPU 0 perf_fuzzer(1278): Oops 0
pc = [<fffffc000031fbc0>]  ra = [<fffffc000031ff54>]  ps = 0007    Not tainted
pc is at alpha_perf_event_set_period+0x60/0xf0
ra is at alpha_pmu_enable+0x1a4/0x1c0
v0 = 0000000000000000  t0 = 00000000000fffff  t1 = fffffc007b3f5800
t2 = fffffbff275faa94  t3 = ffffffffc9b9bd89  t4 = fffffbfe4e46a098
t5 = 0000000000000020  t6 = fffffbfe4e46a0b8  t7 = fffffc007f4c8000
s0 = 0000000000000000  s1 = fffffc0001b0c018  s2 = fffffc0001b0c020
s3 = fffffc007b3f5800  s4 = 0000000000000001  s5 = ffffffffc9b9bd85
s6 = 0000000000000001
a0 = 0000000000000006  a1 = fffffc007b3f5908  a2 = fffffbfe4e46a098
a3 = 00000005000108c0  a4 = 0000000000000000  a5 = 0000000000000000
t8 = 0000000000000001  t9 = 0000000000000001  t10= 0000000027829f6f
t11= 0000000000000020  pv = fffffc000031fb60  at = fffffc0000950900
gp = fffffc0000940900  sp = fffffc007f4cbca8
Disabling lock debugging due to kernel taint
Trace:
[<fffffc000031ff54>] alpha_pmu_enable+0x1a4/0x1c0
[<fffffc000039f4e8>] perf_pmu_enable+0x48/0x60
[<fffffc00003a0d6c>] __perf_install_in_context+0x15c/0x230
[<fffffc000039d1f0>] remote_function+0x80/0xa0
[<fffffc00003a0c10>] __perf_install_in_context+0x0/0x230
[<fffffc000037b7e4>] smp_call_function_single+0x1b4/0x1d0
[<fffffc000039bb70>] task_function_call+0x60/0x80
[<fffffc00003a0c10>] __perf_install_in_context+0x0/0x230
[<fffffc000039bb44>] task_function_call+0x34/0x80
[<fffffc000039d3fc>] perf_install_in_context+0x9c/0x150
[<fffffc00003a0c10>] __perf_install_in_context+0x0/0x230
[<fffffc00003a5100>] SYSC_perf_event_open+0x360/0xac0
[<fffffc00003110c4>] entSys+0xa4/0xc0

This is due to the raw event encoding being used as an index directly
into the ev67_mapping array, rather than being validated against the
ev67_pmc_event_type enumeration instead. Unlike other architectures,
which allow raw events to propagate into the hardware counters with
little interference, the limited number of events on Alpha and the
strict event <-> counter relationships mean that raw events actually
correspond to the Linux-specific Alpha events, rather than anything
defined by the architecture.

This patch adds a new callback to alpha_pmu_t for validating the raw
event encoding with the Linux event types for the PMU, preventing the
out-of-bounds array access.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Michael Cree <mcree@orcon.net.nz>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/alpha/kernel/perf_event.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/kernel/perf_event.c b/arch/alpha/kernel/perf_event.c
index d821b17..c52e7f0 100644
--- a/arch/alpha/kernel/perf_event.c
+++ b/arch/alpha/kernel/perf_event.c
@@ -83,6 +83,8 @@ struct alpha_pmu_t {
 	long pmc_left[3];
 	 /* Subroutine for allocation of PMCs.  Enforces constraints. */
 	int (*check_constraints)(struct perf_event **, unsigned long *, int);
+	/* Subroutine for checking validity of a raw event for this PMU. */
+	int (*raw_event_valid)(u64 config);
 };
 
 /*
@@ -203,6 +205,12 @@ success:
 }
 
 
+static int ev67_raw_event_valid(u64 config)
+{
+	return config >= EV67_CYCLES && config < EV67_LAST_ET;
+};
+
+
 static const struct alpha_pmu_t ev67_pmu = {
 	.event_map = ev67_perfmon_event_map,
 	.max_events = ARRAY_SIZE(ev67_perfmon_event_map),
@@ -211,7 +219,8 @@ static const struct alpha_pmu_t ev67_pmu = {
 	.pmc_count_mask = {EV67_PCTR_0_COUNT_MASK,  EV67_PCTR_1_COUNT_MASK,  0},
 	.pmc_max_period = {(1UL<<20) - 1, (1UL<<20) - 1, 0},
 	.pmc_left = {16, 4, 0},
-	.check_constraints = ev67_check_constraints
+	.check_constraints = ev67_check_constraints,
+	.raw_event_valid = ev67_raw_event_valid,
 };
 
 
@@ -609,7 +618,9 @@ static int __hw_perf_event_init(struct perf_event *event)
 	} else if (attr->type == PERF_TYPE_HW_CACHE) {
 		return -EOPNOTSUPP;
 	} else if (attr->type == PERF_TYPE_RAW) {
-		ev = attr->config & 0xff;
+		if (!alpha_pmu->raw_event_valid(attr->config))
+			return -EINVAL;
+		ev = attr->config;
 	} else {
 		return -EOPNOTSUPP;
 	}
-- 
1.8.3.2

