Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaHMIZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:25:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52098 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbaHMIZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:25:25 -0400
Date: Wed, 13 Aug 2014 01:24:35 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-f3908b8cfb65ab6e78ac84df3b864eb22d5b6d9e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, acme@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, acme@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1407785233-32193-3-git-send-email-eranian@google.com>
References: <1407785233-32193-3-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Don't mark DataLA addresses as store
Git-Commit-ID: f3908b8cfb65ab6e78ac84df3b864eb22d5b6d9e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f3908b8cfb65ab6e78ac84df3b864eb22d5b6d9e
Gitweb:     http://git.kernel.org/tip/f3908b8cfb65ab6e78ac84df3b864eb22d5b6d9e
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 11 Aug 2014 21:27:11 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Aug 2014 07:51:14 +0200

perf/x86: Don't mark DataLA addresses as store

Haswell supports reporting the data address for a range
of PEBS events, including:

	UOPS_RETIRED.ALL
	MEM_UOPS_RETIRED.STLB_MISS_LOADS
	MEM_UOPS_RETIRED.STLB_MISS_STORES
	MEM_UOPS_RETIRED.LOCK_LOADS
	MEM_UOPS_RETIRED.SPLIT_LOADS
	MEM_UOPS_RETIRED.SPLIT_STORES
	MEM_UOPS_RETIRED.ALL_LOADS
	MEM_UOPS_RETIRED.ALL_STORES
	MEM_LOAD_UOPS_RETIRED.L1_HIT
	MEM_LOAD_UOPS_RETIRED.L2_HIT
	MEM_LOAD_UOPS_RETIRED.L3_HIT
	MEM_LOAD_UOPS_RETIRED.L1_MISS
	MEM_LOAD_UOPS_RETIRED.L2_MISS
	MEM_LOAD_UOPS_RETIRED.L3_MISS
	MEM_LOAD_UOPS_RETIRED.HIT_LFB
	MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_MISS
	MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_HIT
	MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_HITM
	MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_NONE
	MEM_LOAD_UOPS_L3_MISS_RETIRED.LOCAL_DRAM

This facility was already enabled earlier with the original Haswell
perf changes.

However these addresses were always reports as stores by perf, which is wrong,
as they could be loads too.  The hardware does not distinguish loads and stores
for these instructions, so there's no (cheap) way for the profiler
to find out.

Change the type to PERF_MEM_OP_NA instead.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Link: http://lkml.kernel.org/r/1407785233-32193-3-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index aca77e9..a9b60f3 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -114,7 +114,7 @@ static u64 precise_store_data_hsw(struct perf_event *event, u64 status)
 	u64 cfg = event->hw.config & INTEL_ARCH_EVENT_MASK;
 
 	dse.val = 0;
-	dse.mem_op = PERF_MEM_OP_STORE;
+	dse.mem_op = PERF_MEM_OP_NA;
 	dse.mem_lvl = PERF_MEM_LVL_NA;
 
 	/*
