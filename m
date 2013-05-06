Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab3EFLhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 07:37:03 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:59152 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab3EFLhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 07:37:01 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org, benh@kernel.crashing.org
Subject: [PATCH] powerpc, perf: Clear out branch entries to avoid any previous stale values
Date: Mon,  6 May 2013 13:34:40 +0530
Message-Id: <1367827480-5375-1-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050611-0260-0000-0000-000002ED6A4B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'to' field inside branch entries might contain stale values from previous
PMU interrupt instances which had indirect branches. So clear all the values
before reading a fresh set of BHRB entries after a PMU interrupt.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/perf/core-book3s.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index c627843..09db68d 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -1590,6 +1590,8 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
 		if (event->attr.sample_type & PERF_SAMPLE_BRANCH_STACK) {
 			struct cpu_hw_events *cpuhw;
 			cpuhw = &__get_cpu_var(cpu_hw_events);
+			memset(cpuhw->bhrb_entries, 0,
+				sizeof(struct perf_branch_entry) * BHRB_MAX_ENTRIES);
 			power_pmu_bhrb_read(cpuhw);
 			data.br_stack = &cpuhw->bhrb_stack;
 		}
-- 
1.7.11.7

