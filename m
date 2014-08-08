Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933457AbaHHU6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:58:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41472 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933174AbaHHUyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:54:10 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 097/259] powerpc/perf: Add PPMU_ARCH_207S define
Date: Fri,  8 Aug 2014 13:38:40 -0700
Message-Id: <1407530482-4483-98-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joel Stanley <joel@jms.id.au>

commit 4d9690dd56b0d18f2af8a9d4a279cb205aae3345 upstream.

Instead of separate bits for every POWER8 PMU feature, have a single one
for v2.07 of the architecture.

This saves us adding a MMCR2 define for a future patch.

Signed-off-by: Joel Stanley <joel@jms.id.au>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
[ kamal: backport to 3.13-stable (drop perf_event_print_debug change) ]
---
 arch/powerpc/include/asm/perf_event_server.h | 3 +--
 arch/powerpc/perf/core-book3s.c              | 4 ++--
 arch/powerpc/perf/power8-pmu.c               | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/perf_event_server.h b/arch/powerpc/include/asm/perf_event_server.h
index 3fd2f1b..cefc7b4 100644
--- a/arch/powerpc/include/asm/perf_event_server.h
+++ b/arch/powerpc/include/asm/perf_event_server.h
@@ -60,8 +60,7 @@ struct power_pmu {
 #define PPMU_SIAR_VALID		0x00000010 /* Processor has SIAR Valid bit */
 #define PPMU_HAS_SSLOT		0x00000020 /* Has sampled slot in MMCRA */
 #define PPMU_HAS_SIER		0x00000040 /* Has SIER */
-#define PPMU_BHRB		0x00000080 /* has BHRB feature enabled */
-#define PPMU_EBB		0x00000100 /* supports event based branch */
+#define PPMU_ARCH_207S		0x00000080 /* PMC is architecture v2.07S */
 
 /*
  * Values for flags to get_alternatives()
diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 29b89e8..8855aec 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -483,7 +483,7 @@ static bool is_ebb_event(struct perf_event *event)
 	 * check that the PMU supports EBB, meaning those that don't can still
 	 * use bit 63 of the event code for something else if they wish.
 	 */
-	return (ppmu->flags & PPMU_EBB) &&
+	return (ppmu->flags & PPMU_ARCH_207S) &&
 	       ((event->attr.config >> PERF_EVENT_CONFIG_EBB_SHIFT) & 1);
 }
 
@@ -1547,7 +1547,7 @@ static int power_pmu_event_init(struct perf_event *event)
 
 	if (has_branch_stack(event)) {
 	        /* PMU has BHRB enabled */
-		if (!(ppmu->flags & PPMU_BHRB))
+		if (!(ppmu->flags & PPMU_ARCH_207S))
 			return -EOPNOTSUPP;
 	}
 
diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.c
index a3f7abd..79b7e20 100644
--- a/arch/powerpc/perf/power8-pmu.c
+++ b/arch/powerpc/perf/power8-pmu.c
@@ -608,7 +608,7 @@ static struct power_pmu power8_pmu = {
 	.get_constraint		= power8_get_constraint,
 	.get_alternatives	= power8_get_alternatives,
 	.disable_pmc		= power8_disable_pmc,
-	.flags			= PPMU_HAS_SSLOT | PPMU_HAS_SIER | PPMU_BHRB | PPMU_EBB,
+	.flags			= PPMU_HAS_SSLOT | PPMU_HAS_SIER | PPMU_ARCH_207S,
 	.n_generic		= ARRAY_SIZE(power8_generic_events),
 	.generic_events		= power8_generic_events,
 	.attr_groups		= power8_pmu_attr_groups,
-- 
1.9.1

