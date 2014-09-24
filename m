Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaIXLt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:49:29 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:41958 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaIXLtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:49:25 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        acme@redhat.com, cebbert.lkml@gmail.com
Subject: [PATCH v7 2/6] perf/x86: add support for sampling PEBS machine state registers
Date: Wed, 24 Sep 2014 13:48:38 +0200
Message-Id: <1411559322-16548-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411559322-16548-1-git-send-email-eranian@google.com>
References: <1411559322-16548-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PEBS can capture machine state regs at retiremnt of the sampled
instructions. When precise sampling is enabled on an event, PEBS
is used, so substitute the interrupted state with the PEBS state.
Note that not all registers are captured by PEBS. Those missing
are replaced by the interrupt state counter-parts.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index b1553d0..ce439f7 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -886,6 +886,29 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	regs.bp = pebs->bp;
 	regs.sp = pebs->sp;
 
+	if (sample_type & PERF_SAMPLE_REGS_INTR) {
+		regs.ax = pebs->ax;
+		regs.bx = pebs->bx;
+		regs.cx = pebs->cx;
+		regs.dx = pebs->dx;
+		regs.si = pebs->si;
+		regs.di = pebs->di;
+		regs.bp = pebs->bp;
+		regs.sp = pebs->sp;
+
+		regs.flags = pebs->flags;
+#ifndef CONFIG_X86_32
+		regs.r8 = pebs->r8;
+		regs.r9 = pebs->r9;
+		regs.r10 = pebs->r10;
+		regs.r11 = pebs->r11;
+		regs.r12 = pebs->r12;
+		regs.r13 = pebs->r13;
+		regs.r14 = pebs->r14;
+		regs.r15 = pebs->r15;
+#endif
+	}
+
 	if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format >= 2) {
 		regs.ip = pebs->real_ip;
 		regs.flags |= PERF_EFLAGS_EXACT;
-- 
1.7.9.5

