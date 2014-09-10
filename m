Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaIJADa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 20:03:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:65346 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbaIJAD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 20:03:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,494,1406617200"; 
   d="scan'208";a="588890337"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        tglx@linutronix.de, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, x86: Fall back to vmalloc for BTS buffer allocation
Date: Tue,  9 Sep 2014 17:03:21 -0700
Message-Id: <1410307401-12401-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

On my workstation the order 4 BTS buffer allocation fails regularly
after the system has been up for some time due to memory
fragmentation.

BTS is virtual memory, so we can just fall back to vmalloc
instead of failing.

Do this here.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 9dc4199..3cf5b74 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -312,8 +312,11 @@ static int alloc_bts_buffer(int cpu)
 
 	buffer = kzalloc_node(BTS_BUFFER_SIZE, GFP_KERNEL | __GFP_NOWARN, node);
 	if (unlikely(!buffer)) {
-		WARN_ONCE(1, "%s: BTS buffer allocation failure\n", __func__);
-		return -ENOMEM;
+		buffer = vmalloc_node(BTS_BUFFER_SIZE, node);
+		if (!buffer) {
+			WARN_ONCE(1, "%s: BTS buffer allocation failure\n", __func__);
+			return -ENOMEM;
+		}
 	}
 
 	max = BTS_BUFFER_SIZE / BTS_RECORD_SIZE;
@@ -336,7 +339,7 @@ static void release_bts_buffer(int cpu)
 	if (!ds || !x86_pmu.bts)
 		return;
 
-	kfree((void *)(unsigned long)ds->bts_buffer_base);
+	kvfree((void *)(unsigned long)ds->bts_buffer_base);
 	ds->bts_buffer_base = 0;
 }
 
-- 
1.9.3

