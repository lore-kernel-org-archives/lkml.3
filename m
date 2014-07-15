Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965094AbaGOXP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:15:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933885AbaGOXOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joel Stanley <joel@jms.id.au>, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.15 30/84] powerpc/perf: Add PPMU_ARCH_207S define
Date: Tue, 15 Jul 2014 16:17:27 -0700
Message-Id: <20140715231714.109093757@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joel Stanley <joel@jms.id.au>

commit 4d9690dd56b0d18f2af8a9d4a279cb205aae3345 upstream.

Instead of separate bits for every POWER8 PMU feature, have a single one
for v2.07 of the architecture.

This saves us adding a MMCR2 define for a future patch.

Signed-off-by: Joel Stanley <joel@jms.id.au>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/perf_event_server.h |    3 +--
 arch/powerpc/perf/core-book3s.c              |    6 +++---
 arch/powerpc/perf/power8-pmu.c               |    2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

--- a/arch/powerpc/include/asm/perf_event_server.h
+++ b/arch/powerpc/include/asm/perf_event_server.h
@@ -61,8 +61,7 @@ struct power_pmu {
 #define PPMU_SIAR_VALID		0x00000010 /* Processor has SIAR Valid bit */
 #define PPMU_HAS_SSLOT		0x00000020 /* Has sampled slot in MMCRA */
 #define PPMU_HAS_SIER		0x00000040 /* Has SIER */
-#define PPMU_BHRB		0x00000080 /* has BHRB feature enabled */
-#define PPMU_EBB		0x00000100 /* supports event based branch */
+#define PPMU_ARCH_207S		0x00000080 /* PMC is architecture v2.07S */
 
 /*
  * Values for flags to get_alternatives()
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -485,7 +485,7 @@ static bool is_ebb_event(struct perf_eve
 	 * check that the PMU supports EBB, meaning those that don't can still
 	 * use bit 63 of the event code for something else if they wish.
 	 */
-	return (ppmu->flags & PPMU_EBB) &&
+	return (ppmu->flags & PPMU_ARCH_207S) &&
 	       ((event->attr.config >> PERF_EVENT_CONFIG_EBB_SHIFT) & 1);
 }
 
@@ -777,7 +777,7 @@ void perf_event_print_debug(void)
 	if (ppmu->flags & PPMU_HAS_SIER)
 		sier = mfspr(SPRN_SIER);
 
-	if (ppmu->flags & PPMU_EBB) {
+	if (ppmu->flags & PPMU_ARCH_207S) {
 		pr_info("MMCR2: %016lx EBBHR: %016lx\n",
 			mfspr(SPRN_MMCR2), mfspr(SPRN_EBBHR));
 		pr_info("EBBRR: %016lx BESCR: %016lx\n",
@@ -1711,7 +1711,7 @@ static int power_pmu_event_init(struct p
 
 	if (has_branch_stack(event)) {
 	        /* PMU has BHRB enabled */
-		if (!(ppmu->flags & PPMU_BHRB))
+		if (!(ppmu->flags & PPMU_ARCH_207S))
 			return -EOPNOTSUPP;
 	}
 
--- a/arch/powerpc/perf/power8-pmu.c
+++ b/arch/powerpc/perf/power8-pmu.c
@@ -792,7 +792,7 @@ static struct power_pmu power8_pmu = {
 	.get_constraint		= power8_get_constraint,
 	.get_alternatives	= power8_get_alternatives,
 	.disable_pmc		= power8_disable_pmc,
-	.flags			= PPMU_HAS_SSLOT | PPMU_HAS_SIER | PPMU_BHRB | PPMU_EBB,
+	.flags			= PPMU_HAS_SSLOT | PPMU_HAS_SIER | PPMU_ARCH_207S,
 	.n_generic		= ARRAY_SIZE(power8_generic_events),
 	.generic_events		= power8_generic_events,
 	.cache_events		= &power8_cache_events,


