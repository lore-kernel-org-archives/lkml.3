Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbaKEJiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:38:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:43844 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbaKEJiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:38:06 -0500
Date: Wed, 5 Nov 2014 10:37:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kan Liang <kan.liang@intel.com>
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        paulus@samba.org, acme@kernel.org, jolsa@redhat.com,
        ak@linux.intel.com
Subject: Re: [PATCH V7 00/17] perf, x86: Haswell LBR call stack support
Message-ID: <20141105093759.GQ10501@worktop.programming.kicks-ass.net>
References: <1415156173-10035-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415156173-10035-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



So if I take all except 11,13,16,17 but instead do something like the
below, everything will work just fine, right?

Or am I missing something?

---
 arch/x86/kernel/cpu/perf_event.h           |    8 --------
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |    8 ++++----
 include/uapi/linux/perf_event.h            |   16 ++++++++--------
 3 files changed, 12 insertions(+), 20 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -521,14 +521,6 @@ struct x86_perf_task_context {
 	int lbr_stack_state;
 };
 
-enum {
-	PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT = PERF_SAMPLE_BRANCH_MAX_SHIFT,
-	PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE,
-
-	PERF_SAMPLE_BRANCH_CALL_STACK =
-				1U << PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT,
-};
-
 #define x86_add_quirk(func_)						\
 do {									\
 	static struct x86_pmu_quirk __quirk __initdata = {		\
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -537,7 +537,7 @@ static int intel_pmu_setup_hw_lbr_filter
 	u64 mask = 0, v;
 	int i;
 
-	for (i = 0; i < PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE; i++) {
+	for (i = 0; i < PERF_SAMPLE_BRANCH_MAX_SHIFT; i++) {
 		if (!(br_type & (1ULL << i)))
 			continue;
 
@@ -808,7 +808,7 @@ intel_pmu_lbr_filter(struct cpu_hw_event
 /*
  * Map interface branch filters onto LBR filters
  */
-static const int nhm_lbr_sel_map[PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE] = {
+static const int nhm_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX_SHIFT] = {
 	[PERF_SAMPLE_BRANCH_ANY_SHIFT]		= LBR_ANY,
 	[PERF_SAMPLE_BRANCH_USER_SHIFT]		= LBR_USER,
 	[PERF_SAMPLE_BRANCH_KERNEL_SHIFT]	= LBR_KERNEL,
@@ -827,7 +827,7 @@ static const int nhm_lbr_sel_map[PERF_SA
 	[PERF_SAMPLE_BRANCH_COND_SHIFT]     = LBR_JCC,
 };
 
-static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE] = {
+static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX_SHIFT] = {
 	[PERF_SAMPLE_BRANCH_ANY_SHIFT]		= LBR_ANY,
 	[PERF_SAMPLE_BRANCH_USER_SHIFT]		= LBR_USER,
 	[PERF_SAMPLE_BRANCH_KERNEL_SHIFT]	= LBR_KERNEL,
@@ -839,7 +839,7 @@ static const int snb_lbr_sel_map[PERF_SA
 	[PERF_SAMPLE_BRANCH_COND_SHIFT]		= LBR_JCC,
 };
 
-static const int hsw_lbr_sel_map[PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE] = {
+static const int hsw_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX_SHIFT] = {
 	[PERF_SAMPLE_BRANCH_ANY_SHIFT]		= LBR_ANY,
 	[PERF_SAMPLE_BRANCH_USER_SHIFT]		= LBR_USER,
 	[PERF_SAMPLE_BRANCH_KERNEL_SHIFT]	= LBR_KERNEL,
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -166,6 +166,8 @@ enum perf_branch_sample_type_shift {
 	PERF_SAMPLE_BRANCH_NO_TX_SHIFT		= 9, /* not in transaction */
 	PERF_SAMPLE_BRANCH_COND_SHIFT		= 10, /* conditional branches */
 
+	PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT	= 11, /* call/ret stack */
+
 	PERF_SAMPLE_BRANCH_MAX_SHIFT		/* non-ABI */
 };
 
@@ -175,18 +177,16 @@ enum perf_branch_sample_type {
 	PERF_SAMPLE_BRANCH_HV		= 1U << PERF_SAMPLE_BRANCH_HV_SHIFT,
 
 	PERF_SAMPLE_BRANCH_ANY		= 1U << PERF_SAMPLE_BRANCH_ANY_SHIFT,
-	PERF_SAMPLE_BRANCH_ANY_CALL	=
-				1U << PERF_SAMPLE_BRANCH_ANY_CALL_SHIFT,
-	PERF_SAMPLE_BRANCH_ANY_RETURN	=
-				1U << PERF_SAMPLE_BRANCH_ANY_RETURN_SHIFT,
-	PERF_SAMPLE_BRANCH_IND_CALL	=
-				1U << PERF_SAMPLE_BRANCH_IND_CALL_SHIFT,
-	PERF_SAMPLE_BRANCH_ABORT_TX	=
-				1U << PERF_SAMPLE_BRANCH_ABORT_TX_SHIFT,
+	PERF_SAMPLE_BRANCH_ANY_CALL	= 1U << PERF_SAMPLE_BRANCH_ANY_CALL_SHIFT,
+	PERF_SAMPLE_BRANCH_ANY_RETURN	= 1U << PERF_SAMPLE_BRANCH_ANY_RETURN_SHIFT,
+	PERF_SAMPLE_BRANCH_IND_CALL	= 1U << PERF_SAMPLE_BRANCH_IND_CALL_SHIFT,
+	PERF_SAMPLE_BRANCH_ABORT_TX	= 1U << PERF_SAMPLE_BRANCH_ABORT_TX_SHIFT,
 	PERF_SAMPLE_BRANCH_IN_TX	= 1U << PERF_SAMPLE_BRANCH_IN_TX_SHIFT,
 	PERF_SAMPLE_BRANCH_NO_TX	= 1U << PERF_SAMPLE_BRANCH_NO_TX_SHIFT,
 	PERF_SAMPLE_BRANCH_COND		= 1U << PERF_SAMPLE_BRANCH_COND_SHIFT,
 
+	PERF_SAMPLE_BRANCH_CALL_STACK	= 1U << PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT,
+
 	PERF_SAMPLE_BRANCH_MAX		= 1U << PERF_SAMPLE_BRANCH_MAX_SHIFT,
 };
 
