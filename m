Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423116Ab3FUOWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:22:05 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:45371 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423085Ab3FUOWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:22:00 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH 5/8] perf,x86: add support for PERF_SAMPLE_PHYS_ADDR for PEBS-LL
Date: Fri, 21 Jun 2013 16:20:45 +0200
Message-Id: <1371824448-7306-6-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371824448-7306-1-git-send-email-eranian@google.com>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for sampling the physical data address
of Loads/Stores captured by PEBS Load Latency/Precise Store
facility.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 06d02fa..e32a5ab 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -3,6 +3,7 @@
 #include <linux/slab.h>
 
 #include <asm/perf_event.h>
+#include <asm/uaccess.h>
 #include <asm/insn.h>
 
 #include "perf_event.h"
@@ -835,10 +836,14 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	else
 		regs.flags &= ~PERF_EFLAGS_EXACT;
 
-	if ((event->attr.sample_type & PERF_SAMPLE_ADDR) &&
+	if ((sample_type & PERF_SAMPLE_ADDR) &&
 		x86_pmu.intel_cap.pebs_format >= 1)
 		data.addr = pebs->dla;
 
+	if ((fll || fst) && (sample_type & PERF_SAMPLE_PHYS_ADDR) &&
+		x86_pmu.intel_cap.pebs_format >= 1)
+		data.phys_addr = uvirt_to_phys_nmi((void *)(pebs->dla));
+
 	if (has_branch_stack(event))
 		data.br_stack = &cpuc->lbr_stack;
 
-- 
1.8.1.2

