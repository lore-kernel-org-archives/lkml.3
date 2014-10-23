Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaJWLA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:00:28 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37124 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbaJWLAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:00:01 -0400
Message-Id: <20141023105658.236729829@infradead.org>
User-Agent: quilt/0.61-1
Date: Thu, 23 Oct 2014 12:51:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, tglx@linutronix.de, ak@linux.intel.com,
        eranian@google.com, dzickus@redhat.com, andi@firstfloor.org,
        jmario@redhat.com, acme@kernel.org
Cc: linux-kernel@vger.kernel.org, "Peter Zijlstra" <peterz@infradead.org>
Subject: [PATCH 3/4] perf,x86: Attempt to sanitize the HSW supplier info
References: <20141023105119.173457103@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-hsw-offcore-fix-3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SDM states the HSW/BDW supplier and snoop info are identical to
SNB/IVB, make it so.

Furthermore, it states you have to minimally program a request and
supplier type, but the current code does not set a supplier for the
ACCESS events.

This significantly alters the actual events and does away with some of
the weirdness found by decoding the magic numbers. If this breaks
things someone needs to go explain things and augment the SDM.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-@git.kernel.org
---
 arch/x86/kernel/cpu/perf_event_intel.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -544,11 +544,6 @@ static __initconst const u64 hsw_hw_cach
 #define HSW_DMND_WRITE		(HSW_DMND_RFO|SNB_LLC_RFO)
 #define HSW_DMND_PREFETCH	(HSW_PF_DATA_RD|HSW_PF_RFO|HSW_PF_IFETCH)
 
-#define HSW_DRAM_ANY		(SNB_NO_SUPP|SNB_SNP_ANY|(0x78ULL << 23)) /* WTF */
-
-#define HSW_L3_ACCESS		(0) /* XXX no supplier! */
-#define NSW_L3_MISS		(HSW_DRAM_ANY|SNB_NON_DRAM)
-
 static __initconst const u64 hsw_hw_cache_extra_regs
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
@@ -556,16 +551,16 @@ static __initconst const u64 hsw_hw_cach
 {
  [ C(LL  ) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = HSW_DMND_READ|HSW_L3_ACCESS,
-		[ C(RESULT_MISS)   ] = HSW_DMND_READ|HSW_L3_MISS,
+		[ C(RESULT_ACCESS) ] = HSW_DMND_READ|SNB_L3_ACCESS,
+		[ C(RESULT_MISS)   ] = HSW_DMND_READ|SNB_L3_MISS,
 	},
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = HSW_DMND_WRITE|HSW_L3_ACCESS,
-		[ C(RESULT_MISS)   ] = HSW_DMND_WRITE|HSW_L3_MISS,
+		[ C(RESULT_ACCESS) ] = HSW_DMND_WRITE|SNB_L3_ACCESS,
+		[ C(RESULT_MISS)   ] = HSW_DMND_WRITE|SNB_L3_MISS,
 	},
 	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = HSW_DMND_PREFETCH|HSW_L3_ACCESS,
-		[ C(RESULT_MISS)   ] = HSW_DMND_PREFETCH|HSW_L3_MISS,
+		[ C(RESULT_ACCESS) ] = HSW_DMND_PREFETCH|SNB_L3_ACCESS,
+		[ C(RESULT_MISS)   ] = HSW_DMND_PREFETCH|SNB_L3_MISS,
 	},
  },
 };


