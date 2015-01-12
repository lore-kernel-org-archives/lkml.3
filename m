Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbbALRl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:41:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:62049 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbbALRlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:41:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,745,1413270000"; 
   d="scan'208";a="668556208"
From: kan.liang@intel.com
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V2 1/1] perf, x86: bug fix for cycles:p and cycles:pp on SLM
Date: Mon, 12 Jan 2015 17:42:21 +0000
Message-Id: <1421084541-31639-1-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

cycles:p and cycles:pp do not work on SLM since
86a04461a99f ("perf/x86: Revamp PEBS event selection")

UOPS_RETIRED.ALL is not a PEBS capable event, so it should not be used
to count cycle number.
Actually SLM call intel_pebs_aliases_core2 which uses INST_RETIRED.ANY_P
counts the number of cycles. It's a PEBS capable event. But inv and
cmask must be set to count cycles.
Considering SLM allows all events as PEBS with no flags, here only
INST_RETIRED.ANY_P, inv=1, cmask=16 need to specially handled.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
Changes since V1
 - Only handle INST_RETIRED.ANY_P, inv=1, cmask=16

 arch/x86/kernel/cpu/perf_event_intel_ds.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 3c895d4..0739833 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -568,8 +568,8 @@ struct event_constraint intel_atom_pebs_event_constraints[] = {
 };
 
 struct event_constraint intel_slm_pebs_event_constraints[] = {
-	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
-	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
+	/* INST_RETIRED.ANY_P, inv=1, cmask=16 (cycles:p). */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0x108000c0, 0x1),
 	/* Allow all events as PEBS with no flags */
 	INTEL_ALL_EVENT_CONSTRAINT(0, 0x1),
 	EVENT_CONSTRAINT_END
-- 
1.7.11.7

