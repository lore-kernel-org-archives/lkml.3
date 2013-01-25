Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab3AYWdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:33:33 -0500
Received: from mga14.intel.com ([143.182.124.37]:63154 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab3AYWdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:33:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,541,1355126400"; 
   d="scan'208";a="248537212"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 14/18] perf, x86: Add Haswell TSX event aliases v2
Date: Fri, 25 Jan 2013 14:33:08 -0800
Message-Id: <1359153192-13409-15-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359153192-13409-1-git-send-email-andi@firstfloor.org>
References: <1359153192-13409-1-git-send-email-andi@firstfloor.org>
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

The general abort events exist in precise and non precise variants
Since the common case is sampling plain "tx-aborts" in precise.

This is very important because abort sampling only really works
with PEBS enabled, otherwise it would report the IP after the abort,
not the abort point. But counting with PEBS has more overhead,
so also have tx/el-abort-count aliases that do not enable PEBS
for perf stat.

It would be nice to switch automatically between those two, like in the
previous version, but that would need more new infrastructure for sysfs
first.

There is an tx-abort<->tx-aborts alias too, because I found myself
using both variants.

Also added friendly aliases for cpu/cycles,intx=1/ and
cpu/cycles,intx=1,intx_cp=1/ and the same for instructions.
These will be used by perf stat -T, and are also useful for users directly.

So for example to get transactional cycles can use "perf stat -e cycles-t"

v2: Move to new sysfs infrastructure
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   47 ++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index d8acedd..022246a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2004,6 +2004,52 @@ static __init void intel_nehalem_quirk(void)
 	}
 }
 
+/* Haswell special events */
+EVENT_ATTR_STR(tx-start,       tx_start,       "event=0xc9,umask=0x1");
+EVENT_ATTR_STR(tx-commit,      tx_commit,      "event=0xc9,umask=0x2");
+EVENT_ATTR_STR(tx-abort,       tx_abort,       "event=0xc9,umask=0x4,precise=2");
+EVENT_ATTR_STR(tx-abort-count, tx_abort_count, "event=0xc9,umask=0x4");
+/* alias */
+EVENT_ATTR_STR(tx-aborts,      tx_aborts,      "event=0xc9,umask=0x4,precise=2");
+EVENT_ATTR_STR(tx-capacity,    tx_capacity,    "event=0x54,umask=0x2");
+EVENT_ATTR_STR(tx-conflict,    tx_conflict,    "event=0x54,umask=0x1");
+EVENT_ATTR_STR(el-start,       el_start,       "event=0xc8,umask=0x1");
+EVENT_ATTR_STR(el-commit,      el_commit,      "event=0xc8,umask=0x2");
+EVENT_ATTR_STR(el-abort,       el_abort,       "event=0xc8,umask=0x4,precise=2");
+EVENT_ATTR_STR(el-abort-count, el_abort_count, "event=0xc8,umask=0x4");
+/* alias */
+EVENT_ATTR_STR(el-aborts,      el_aborts,      "event=0xc8,umask=0x4,precise=2");
+/* shared with tx-* */
+EVENT_ATTR_STR(el-capacity,    el_capacity,    "event=0x54,umask=0x2");
+/* shared with tx-* */
+EVENT_ATTR_STR(el-conflict,    el_conflict,    "event=0x54,umask=0x1");
+EVENT_ATTR_STR(cycles-t,       cycles_t,       "event=0x3c,intx=1");
+EVENT_ATTR_STR(cycles-ct,      cycles_ct,      "event=0x3c,intx=1,intx_cp=1");
+EVENT_ATTR_STR(instructions-t, instructions_t, "event=0xc0,intx=1");
+EVENT_ATTR_STR(instructions-ct,instructions_ct,"event=0xc0,intx=1,intx_cp=1");
+
+static struct attribute *hsw_events_attrs[] = {
+	EVENT_PTR(tx_start),
+	EVENT_PTR(tx_commit),
+	EVENT_PTR(tx_abort),
+	EVENT_PTR(tx_aborts),
+	EVENT_PTR(tx_abort_count),
+	EVENT_PTR(tx_capacity),
+	EVENT_PTR(tx_conflict),
+	EVENT_PTR(el_start),
+	EVENT_PTR(el_commit),
+	EVENT_PTR(el_abort),
+	EVENT_PTR(el_aborts),
+	EVENT_PTR(el_abort_count),
+	EVENT_PTR(el_capacity),
+	EVENT_PTR(el_conflict),
+	EVENT_PTR(cycles_t),
+	EVENT_PTR(cycles_ct),
+	EVENT_PTR(instructions_t),
+	EVENT_PTR(instructions_ct),
+	NULL
+};
+
 __init int intel_pmu_init(void)
 {
 	union cpuid10_edx edx;
@@ -2229,6 +2275,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.get_event_constraints = hsw_get_event_constraints;
 		x86_pmu.format_attrs = intel_hsw_formats_attr;
 		x86_pmu.memory_lat_events = intel_hsw_memory_latency_events;
+		x86_pmu.cpu_events = hsw_events_attrs;
 		pr_cont("Haswell events, ");
 		break;
 
-- 
1.7.7.6

