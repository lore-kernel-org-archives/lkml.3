Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab3HUXsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 19:48:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:56963 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045Ab3HUXra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 19:47:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,930,1367996400"; 
   d="scan'208";a="390059801"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: peterz@infradead.org, acme@infradead.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/4] perf, x86: Add Haswell TSX event aliases v6
Date: Wed, 21 Aug 2013 16:47:25 -0700
Message-Id: <1377128846-977-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1377128846-977-1-git-send-email-andi@firstfloor.org>
References: <1377128846-977-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add TSX event aliases, and export them from the kernel to perf.

These are used by perf stat -T and to allow
more user friendly access to events. The events are designed to
be fairly generic and may also apply to other architectures
implementing HTM.  They all cover common situations that
happens during tuning of transactional code.

For Haswell we have to separate the HLE and RTM events,
as they are separate in the PMU.

This adds the following events.

tx-start	Count start transaction (used by perf stat -T)
tx-commit	Count commit of transaction
tx-abort	Count all aborts
tx-conflict	Count aborts due to conflict with another CPU.
tx-capacity	Count capacity aborts (transaction too large)

Then matching el-* events for HLE

cycles-t	Transactional cycles (used by perf stat -T)
* also exists on POWER8
cycles-ct	Transactional cycles commited (used by perf stat -T)
* according to Michael Ellerman POWER8 has a cycles-transactional-committed,
* perf stat -T handles both cases

Note for useful abort profiling often precise has to be set,
as Haswell can only report the point inside the transaction
with precise=2.

(I had another patchkit to allow exporting precise too, but Vince
Weaver pointed out it violates the ABI, so dropped now)

For some classes of aborts, like conflicts, this is not needed,
as it makes more sense to look at the complete critical section.

This gives a clean set of generalized events to examine transaction
success and aborts. Haswell has additional events for TSX, but those are more
specialized for very specific situations.

v2: Move to new sysfs infrastructure
v3: Use own sysfs functions now
v4: Add tx/el-abort-return for better conflict sampling
v5: Different white space.
v6: Cut down events, rewrite description.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 9218025..ca7f02c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2076,7 +2076,34 @@ static __init void intel_nehalem_quirk(void)
 EVENT_ATTR_STR(mem-loads,      mem_ld_hsw,     "event=0xcd,umask=0x1,ldlat=3");
 EVENT_ATTR_STR(mem-stores,     mem_st_hsw,     "event=0xd0,umask=0x82")
 
+/* Haswell special events */
+EVENT_ATTR_STR(tx-start,        tx_start,       "event=0xc9,umask=0x1");
+EVENT_ATTR_STR(tx-commit,       tx_commit,      "event=0xc9,umask=0x2");
+EVENT_ATTR_STR(tx-abort,        tx_abort,	"event=0xc9,umask=0x4");
+EVENT_ATTR_STR(tx-capacity,     tx_capacity,	"event=0x54,umask=0x2");
+EVENT_ATTR_STR(tx-conflict,     tx_conflict,	"event=0x54,umask=0x1");
+EVENT_ATTR_STR(el-start,        el_start,       "event=0xc8,umask=0x1");
+EVENT_ATTR_STR(el-commit,       el_commit,      "event=0xc8,umask=0x2");
+EVENT_ATTR_STR(el-abort,        el_abort,	"event=0xc8,umask=0x4");
+EVENT_ATTR_STR(el-capacity,     el_capacity,    "event=0x54,umask=0x2");
+EVENT_ATTR_STR(el-conflict,     el_conflict,    "event=0x54,umask=0x1");
+EVENT_ATTR_STR(cycles-t,        cycles_t,       "event=0x3c,in_tx=1");
+EVENT_ATTR_STR(cycles-ct,       cycles_ct,
+					"event=0x3c,in_tx=1,in_tx_cp=1");
+
 static struct attribute *hsw_events_attrs[] = {
+	EVENT_PTR(tx_start),
+	EVENT_PTR(tx_commit),
+	EVENT_PTR(tx_abort),
+	EVENT_PTR(tx_capacity),
+	EVENT_PTR(tx_conflict),
+	EVENT_PTR(el_start),
+	EVENT_PTR(el_commit),
+	EVENT_PTR(el_abort),
+	EVENT_PTR(el_capacity),
+	EVENT_PTR(el_conflict),
+	EVENT_PTR(cycles_t),
+	EVENT_PTR(cycles_ct),
 	EVENT_PTR(mem_ld_hsw),
 	EVENT_PTR(mem_st_hsw),
 	NULL
-- 
1.8.3.1

