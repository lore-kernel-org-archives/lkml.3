Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab3DTTVu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 15:21:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:5439 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430Ab3DTTT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 15:19:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,515,1363158000"; 
   d="scan'208";a="298141410"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: acme@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 14/15] perf, x86: Add Haswell TSX event aliases v4
Date: Sat, 20 Apr 2013 12:19:22 -0700
Message-Id: <1366485563-16209-15-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
References: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add infrastructure to generate event aliases in /sys/devices/cpu/events/

And use this to set up user friendly aliases for the common TSX events.
TSX tuning relies heavily on the PMU, so it's important to be user friendly.

This replaces the generic transaction events in an earlier version
of this patchkit.

tx-start/commit/abort  to count RTM transactions
el-start/commit/abort  to count HLE ("elision") transactions
tx-conflict/overflow   to count conflict/overflow for both combined.

The general abort events exist in precise and non precise and precise-return
variants.  Since the common case is sampling plain "tx-aborts" in precise.

This is very important because abort sampling only really works
with PEBS enabled, otherwise it would report the IP after the abort,
not the abort point. But counting with PEBS has more overhead,
so also have tx/el-abort-count aliases that do not enable PEBS
for perf stat.

In many cases sampling the return address with PEBS is still useful, so
we also have tx/el-abort-return. These are mainly for sampling
asynchronous conflicts, where it can be more beneficial to look at the
complete critical section, than the exact abort point. We still
want PEBS for those so that the transaction weight and flags can
be examined.

There is an tx-abort<->tx-aborts alias too, because I found myself
using both variants.

Also added friendly aliases for cpu/cycles,intx=1/ and
cpu/cycles,intx=1,intx_cp=1/ and the same for instructions.
These will be used by perf stat -T, and are also useful for users directly.
So for example to get transactional cycles can use "perf stat -e cycles-t"

This gives a clean set of generalized events to examine transaction
success and aborts. Haswell has additional events for TSX, but those are more
specialized for very specific situations.

v2: Move to new sysfs infrastructure
v3: Use own sysfs functions now
v4: Add tx/el-abort-return for better conflict sampling
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   55 ++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index f24fb6f..d3fa8cd 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2069,6 +2069,60 @@ static __init void intel_nehalem_quirk(void)
 	}
 }
 
+/* Haswell special events */
+EVENT_ATTR_STR(tx-start,        tx_start,       "event=0xc9,umask=0x1");
+EVENT_ATTR_STR(tx-commit,       tx_commit,      "event=0xc9,umask=0x2");
+EVENT_ATTR_STR(tx-abort,        tx_abort,       "event=0xc9,umask=0x4,precise=2");
+EVENT_ATTR_STR(tx-abort-count,  tx_abort_return, "event=0xc9,umask=0x4");
+EVENT_ATTR_STR(tx-abort-return, tx_abort_count, "event=0xc9,umask=0x4,precise=1");
+/* alias */
+EVENT_ATTR_STR(tx-aborts,       tx_aborts,      "event=0xc9,umask=0x4,precise=2");
+EVENT_ATTR_STR(tx-capacity,     tx_capacity,    "event=0x54,umask=0x2");
+EVENT_ATTR_STR(tx-conflict,     tx_conflict,    "event=0x54,umask=0x1");
+EVENT_ATTR_STR(el-start,        el_start,       "event=0xc8,umask=0x1");
+EVENT_ATTR_STR(el-commit,       el_commit,      "event=0xc8,umask=0x2");
+EVENT_ATTR_STR(el-abort,        el_abort,       "event=0xc8,umask=0x4,precise=2");
+EVENT_ATTR_STR(el-abort-return, el_abort_return, "event=0xc8,umask=0x4,precise=1");
+EVENT_ATTR_STR(el-abort-count,  el_abort_count, "event=0xc8,umask=0x4");
+/* alias */
+EVENT_ATTR_STR(el-aborts,       el_aborts,      "event=0xc8,umask=0x4,precise=2");
+/* shared with tx-* */
+EVENT_ATTR_STR(el-capacity,     el_capacity,    "event=0x54,umask=0x2");
+/* shared with tx-* */
+EVENT_ATTR_STR(el-conflict,     el_conflict,    "event=0x54,umask=0x1");
+EVENT_ATTR_STR(cycles-t,        cycles_t,       "event=0x3c,intx=1");
+EVENT_ATTR_STR(cycles-ct,       cycles_ct,      "event=0x3c,intx=1,intx_cp=1");
+EVENT_ATTR_STR(instructions-t,  instructions_t, "event=0xc0,umask=0x01,intx=1");
+EVENT_ATTR_STR(instructions-ct, instructions_ct, "event=0xc0,umask=0x01,intx=1,intx_cp=1");
+EVENT_ATTR_STR(instructions-p,  instructions_p, "event=0xc0,umask=0x01,precise=2");
+
+static struct attribute *hsw_events_attrs[] = {
+	EVENT_PTR(tx_start),
+	EVENT_PTR(tx_commit),
+	EVENT_PTR(tx_abort),
+	EVENT_PTR(tx_aborts),
+	EVENT_PTR(tx_abort_count),
+	EVENT_PTR(tx_abort_return),
+	EVENT_PTR(tx_capacity),
+	EVENT_PTR(tx_conflict),
+	EVENT_PTR(el_start),
+	EVENT_PTR(el_commit),
+	EVENT_PTR(el_abort),
+	EVENT_PTR(el_aborts),
+	EVENT_PTR(el_abort_count),
+	EVENT_PTR(el_abort_return),
+	EVENT_PTR(el_capacity),
+	EVENT_PTR(el_conflict),
+	EVENT_PTR(cycles_t),
+	EVENT_PTR(cycles_ct),
+	EVENT_PTR(instructions_t),
+	EVENT_PTR(instructions_ct),
+	EVENT_PTR(instructions_p),
+	EVENT_PTR(mem_ld_nhm),
+	/* TBD add a mem-stores event */
+	NULL
+};
+
 __init int intel_pmu_init(void)
 {
 	union cpuid10_edx edx;
@@ -2307,6 +2361,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.hw_config = hsw_hw_config;
 		x86_pmu.get_event_constraints = hsw_get_event_constraints;
 		x86_pmu.format_attrs = intel_hsw_formats_attr;
+		x86_pmu.cpu_events = hsw_events_attrs;
 		x86_pmu.lbr_double_abort = true;
 		pr_cont("Haswell events, ");
 		break;
-- 
1.7.7.6

