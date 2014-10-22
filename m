Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbaJVI0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:26:42 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:42920 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754156AbaJVI0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:26:37 -0400
X-IronPort-AV: E=Sophos;i="5.04,767,1406563200"; 
   d="scan'208";a="37711559"
From: chai wen <chaiw.fnst@cn.fujitsu.com>
To: <will.deacon@arm.com>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <yuichi.kusakabe@jp.fujitsu.com>,
        chai wen <chaiw.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] ARM: perf: armv7 remove useless return and check of idx in counter handling
Date: Wed, 22 Oct 2014 16:21:46 +0800
Message-ID: <1413966107-11881-1-git-send-email-chaiw.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.161]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Idx sanity check was once implemented separately in these counter handling
functions and then return value was treated as a judgement.
	armv7_pmnc_select_counter()
	armv7_pmnc_enable_counter()
	armv7_pmnc_disable_counter()
	armv7_pmnc_enable_intens()
	armv7_pmnc_disable_intens()
But we do not need to do this now, and the return of idx is useless.

Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>
---
 arch/arm/kernel/perf_event_v7.c |   32 ++++++++++++++------------------
 1 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
index 116758b..f66a9b8 100644
--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -564,13 +564,11 @@ static inline int armv7_pmnc_counter_has_overflowed(u32 pmnc, int idx)
 	return pmnc & BIT(ARMV7_IDX_TO_COUNTER(idx));
 }
 
-static inline int armv7_pmnc_select_counter(int idx)
+static inline void armv7_pmnc_select_counter(int idx)
 {
 	u32 counter = ARMV7_IDX_TO_COUNTER(idx);
 	asm volatile("mcr p15, 0, %0, c9, c12, 5" : : "r" (counter));
 	isb();
-
-	return idx;
 }
 
 static inline u32 armv7pmu_read_counter(struct perf_event *event)
@@ -585,8 +583,10 @@ static inline u32 armv7pmu_read_counter(struct perf_event *event)
 			smp_processor_id(), idx);
 	else if (idx == ARMV7_IDX_CYCLE_COUNTER)
 		asm volatile("mrc p15, 0, %0, c9, c13, 0" : "=r" (value));
-	else if (armv7_pmnc_select_counter(idx) == idx)
+	else {
+		armv7_pmnc_select_counter(idx);
 		asm volatile("mrc p15, 0, %0, c9, c13, 2" : "=r" (value));
+	}
 
 	return value;
 }
@@ -602,40 +602,38 @@ static inline void armv7pmu_write_counter(struct perf_event *event, u32 value)
 			smp_processor_id(), idx);
 	else if (idx == ARMV7_IDX_CYCLE_COUNTER)
 		asm volatile("mcr p15, 0, %0, c9, c13, 0" : : "r" (value));
-	else if (armv7_pmnc_select_counter(idx) == idx)
+	else {
+		armv7_pmnc_select_counter(idx);
 		asm volatile("mcr p15, 0, %0, c9, c13, 2" : : "r" (value));
+	}
 }
 
 static inline void armv7_pmnc_write_evtsel(int idx, u32 val)
 {
-	if (armv7_pmnc_select_counter(idx) == idx) {
-		val &= ARMV7_EVTYPE_MASK;
-		asm volatile("mcr p15, 0, %0, c9, c13, 1" : : "r" (val));
-	}
+	armv7_pmnc_select_counter(idx);
+	val &= ARMV7_EVTYPE_MASK;
+	asm volatile("mcr p15, 0, %0, c9, c13, 1" : : "r" (val));
 }
 
-static inline int armv7_pmnc_enable_counter(int idx)
+static inline void armv7_pmnc_enable_counter(int idx)
 {
 	u32 counter = ARMV7_IDX_TO_COUNTER(idx);
 	asm volatile("mcr p15, 0, %0, c9, c12, 1" : : "r" (BIT(counter)));
-	return idx;
 }
 
-static inline int armv7_pmnc_disable_counter(int idx)
+static inline void armv7_pmnc_disable_counter(int idx)
 {
 	u32 counter = ARMV7_IDX_TO_COUNTER(idx);
 	asm volatile("mcr p15, 0, %0, c9, c12, 2" : : "r" (BIT(counter)));
-	return idx;
 }
 
-static inline int armv7_pmnc_enable_intens(int idx)
+static inline void armv7_pmnc_enable_intens(int idx)
 {
 	u32 counter = ARMV7_IDX_TO_COUNTER(idx);
 	asm volatile("mcr p15, 0, %0, c9, c14, 1" : : "r" (BIT(counter)));
-	return idx;
 }
 
-static inline int armv7_pmnc_disable_intens(int idx)
+static inline void armv7_pmnc_disable_intens(int idx)
 {
 	u32 counter = ARMV7_IDX_TO_COUNTER(idx);
 	asm volatile("mcr p15, 0, %0, c9, c14, 2" : : "r" (BIT(counter)));
@@ -643,8 +641,6 @@ static inline int armv7_pmnc_disable_intens(int idx)
 	/* Clear the overflow flag in case an interrupt is pending. */
 	asm volatile("mcr p15, 0, %0, c9, c12, 3" : : "r" (BIT(counter)));
 	isb();
-
-	return idx;
 }
 
 static inline u32 armv7_pmnc_getreset_flags(void)
-- 
1.7.1

