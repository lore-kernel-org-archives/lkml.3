Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbaGHWRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:17:36 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:46063 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbaGHWQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:16:48 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        acme@redhat.com, namhyung@kernel.org
Subject: [PATCH 2/4] perf/x86: add support for sampling PEBS machine state registers
Date: Wed,  9 Jul 2014 00:15:57 +0200
Message-Id: <1404857759-25105-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404857759-25105-1-git-send-email-eranian@google.com>
References: <1404857759-25105-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PEBS can capture machine state regs at retirement of the sampled
instructions. When precise sampling is enabled on an event, PEBS
is used, so substitute the interrupted state with the PEBS state.
Note that not all registers are captured by PEBS. Those missing
are replaced by the interrupt state counter-parts.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 980970c..d612bcd 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -925,6 +925,25 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	regs.bp = pebs->bp;
 	regs.sp = pebs->sp;
 
+	if (sample_type & PERF_SAMPLE_REGS_INTR) {
+		regs.ax = pebs->ax;
+		regs.bx = pebs->bx;
+		regs.cx = pebs->cx;
+		regs.si = pebs->si;
+		regs.di = pebs->di;
+
+		regs.r8 = pebs->r8;
+		regs.r9 = pebs->r9;
+		regs.r10 = pebs->r10;
+		regs.r11 = pebs->r11;
+		regs.r12 = pebs->r12;
+		regs.r13 = pebs->r13;
+		regs.r14 = pebs->r14;
+		regs.r14 = pebs->r15;
+
+		data.regs_intr.regs = &regs;
+	}
+
 	if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format >= 2) {
 		regs.ip = pebs->real_ip;
 		regs.flags |= PERF_EFLAGS_EXACT;
-- 
1.8.3.2

