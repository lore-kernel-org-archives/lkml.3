Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbaLHWJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:09:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:39650 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbaLHWJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:09:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,540,1413270000"; 
   d="scan'208";a="644468204"
From: kan.liang@intel.com
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH 1/1] perf, x86: bug fix for cycles:p and cycles:pp on SLM
Date: Mon,  8 Dec 2014 06:27:43 -0800
Message-Id: <1418048863-4294-1-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

cycles:p and cycles:pp don't work on SLM since 86a0446

This regression issue is because UOPS_RETIRED.ALL is not a PEBS event on SLM.

According to pebs_aliases, INST_RETIRED.ANY_P (a PEBS capable event) can be
used as an alternative way to count cycles. Roll back the pebs_constraints to
use INST_RETIRED.ANY_P.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 3c895d4..ac8f941 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -568,8 +568,8 @@ struct event_constraint intel_atom_pebs_event_constraints[] = {
 };
 
 struct event_constraint intel_slm_pebs_event_constraints[] = {
-	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
-	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
+	/* INST_RETIRED.ANY_P */
+	INTEL_UEVENT_CONSTRAINT(0x00c0, 0x1),
 	/* Allow all events as PEBS with no flags */
 	INTEL_ALL_EVENT_CONSTRAINT(0, 0x1),
 	EVENT_CONSTRAINT_END
-- 
1.8.3.1

