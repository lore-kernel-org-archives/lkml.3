Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbaESM4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:56:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59098 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbaESM4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:56:21 -0400
Date: Mon, 19 May 2014 05:55:23 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-722e76e60f2775c21b087ff12c5e678cf0ebcaaf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        dzickus@redhat.com
In-Reply-To: <20140515155644.GA3884@quad>
References: <20140515155644.GA3884@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] fix Haswell precise store data source encoding
Git-Commit-ID: 722e76e60f2775c21b087ff12c5e678cf0ebcaaf
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

Commit-ID:  722e76e60f2775c21b087ff12c5e678cf0ebcaaf
Gitweb:     http://git.kernel.org/tip/722e76e60f2775c21b087ff12c5e678cf0ebcaaf
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 15 May 2014 17:56:44 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 May 2014 21:52:59 +0900

fix Haswell precise store data source encoding

This patch fixes a bug in  precise_store_data_hsw() whereby
it would set the data source memory level to the wrong value.

As per the the SDM Vol 3b Table 18-41 (Layout of Data Linear
Address Information in PEBS Record), when status bit 0 is set
this is a L1 hit, otherwise this is a L1 miss.

This patch encodes the memory level according to the specification.

In V2, we added the filtering on the store events.
Only the following events produce L1 information:
 * MEM_UOPS_RETIRED.STLB_MISS_STORES
 * MEM_UOPS_RETIRED.LOCK_STORES
 * MEM_UOPS_RETIRED.SPLIT_STORES
 * MEM_UOPS_RETIRED.ALL_STORES

Cc: mingo@elte.hu
Cc: acme@ghostprotocols.net
Cc: jolsa@redhat.com
Cc: jmario@redhat.com
Cc: ak@linux.intel.com
Tested-and-Reviewed-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140515155644.GA3884@quad
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index ae96cfa..980970c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -108,15 +108,31 @@ static u64 precise_store_data(u64 status)
 	return val;
 }
 
-static u64 precise_store_data_hsw(u64 status)
+static u64 precise_store_data_hsw(struct perf_event *event, u64 status)
 {
 	union perf_mem_data_src dse;
+	u64 cfg = event->hw.config & INTEL_ARCH_EVENT_MASK;
 
 	dse.val = 0;
 	dse.mem_op = PERF_MEM_OP_STORE;
 	dse.mem_lvl = PERF_MEM_LVL_NA;
+
+	/*
+	 * L1 info only valid for following events:
+	 *
+	 * MEM_UOPS_RETIRED.STLB_MISS_STORES
+	 * MEM_UOPS_RETIRED.LOCK_STORES
+	 * MEM_UOPS_RETIRED.SPLIT_STORES
+	 * MEM_UOPS_RETIRED.ALL_STORES
+	 */
+	if (cfg != 0x12d0 && cfg != 0x22d0 && cfg != 0x42d0 && cfg != 0x82d0)
+		return dse.mem_lvl;
+
 	if (status & 1)
-		dse.mem_lvl = PERF_MEM_LVL_L1;
+		dse.mem_lvl = PERF_MEM_LVL_L1 | PERF_MEM_LVL_HIT;
+	else
+		dse.mem_lvl = PERF_MEM_LVL_L1 | PERF_MEM_LVL_MISS;
+
 	/* Nothing else supported. Sorry. */
 	return dse.val;
 }
@@ -887,7 +903,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 				data.data_src.val = load_latency_data(pebs->dse);
 			else if (event->hw.flags & PERF_X86_EVENT_PEBS_ST_HSW)
 				data.data_src.val =
-					precise_store_data_hsw(pebs->dse);
+					precise_store_data_hsw(event, pebs->dse);
 			else
 				data.data_src.val = precise_store_data(pebs->dse);
 		}
