Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbaJWLAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:00:07 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37147 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677AbaJWLAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:00:05 -0400
Message-Id: <20141023105658.169659428@infradead.org>
User-Agent: quilt/0.61-1
Date: Thu, 23 Oct 2014 12:51:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, tglx@linutronix.de, ak@linux.intel.com,
        eranian@google.com, dzickus@redhat.com, andi@firstfloor.org,
        jmario@redhat.com, acme@kernel.org
Cc: linux-kernel@vger.kernel.org, "Peter Zijlstra" <peterz@infradead.org>
Subject: [PATCH 2/4] perf,x86: HSW offcore prefetch events
References: <20141023105119.173457103@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-hsw-offcore-fix-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the HSW events to be more inline with the other uarchs
and removes the prefetch request bits from the read/write demands and
into the prefetch demand.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-@git.kernel.org
---
 arch/x86/kernel/cpu/perf_event_intel.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -539,16 +539,12 @@ static __initconst const u64 hsw_hw_cach
  * SNB_LLC_* is specified as 'reserved' in the SDM
  * but Andi added it anyhow, suggesting HSW/BDW have it just fine
  *
- * XXX NHM/WSM/SNB/IVB don't have the PF/IFETCH bits set
+ * XXX NHM/WSM/SNB/IVB don't have the IFETCH bits set
  */
 #define HSW_DMND_READ		(HSW_DMND_DATA_RD|HSW_DMND_IFETCH| \
-				 HSW_PF_DATA_RD|HSW_PF_IFETCH| \
 				 SNB_LLC_DATA_RD|SNB_LLC_IFETCH)
-
-/* XXX NHM/WSM/SNB/IVB dont have the PF bits set */
-#define HSW_DMND_WRITE		(HSW_DMND_RFO|HSW_PF_RFO|SNB_LLC_RFO)
-
-#define HSW_DMND_PREFETCH	(0) /* XXX broken ? */
+#define HSW_DMND_WRITE		(HSW_DMND_RFO|SNB_LLC_RFO)
+#define HSW_DMND_PREFETCH	(HSW_PF_DATA_RD|HSW_PF_RFO|HSW_PF_IFETCH)
 
 #define HSW_DRAM_ANY		(SNB_NO_SUPP|SNB_SNP_ANY|(0x78ULL << 23)) /* WTF */
 
@@ -570,8 +566,8 @@ static __initconst const u64 hsw_hw_cach
 		[ C(RESULT_MISS)   ] = HSW_DMND_WRITE|HSW_L3_MISS,
 	},
 	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0,
-		[ C(RESULT_MISS)   ] = 0x0,
+		[ C(RESULT_ACCESS) ] = HSW_DMND_PREFETCH|HSW_L3_ACCESS,
+		[ C(RESULT_MISS)   ] = HSW_DMND_PREFETCH|HSW_L3_MISS,
 	},
  },
 };


