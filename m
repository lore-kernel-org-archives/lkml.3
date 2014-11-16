Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbaKPMgc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:36:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35656 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326AbaKPMg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:36:29 -0500
Date: Sun, 16 Nov 2014 04:35:59 -0800
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-aea48559ac454a065244d3eff0c94cc8af9c553e@git.kernel.org>
Cc: torvalds@linux-foundation.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, peterz@infradead.org,
        acme@kernel.org, mingo@kernel.org
Reply-To: torvalds@linux-foundation.org, eranian@google.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, peterz@infradead.org,
        acme@kernel.org, mingo@kernel.org
In-Reply-To: <1411559322-16548-3-git-send-email-eranian@google.com>
References: <1411559322-16548-3-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Add support for sampling PEBS machine state registers
Git-Commit-ID: aea48559ac454a065244d3eff0c94cc8af9c553e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aea48559ac454a065244d3eff0c94cc8af9c553e
Gitweb:     http://git.kernel.org/tip/aea48559ac454a065244d3eff0c94cc8af9c553e
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 24 Sep 2014 13:48:38 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 11:41:58 +0100

perf/x86: Add support for sampling PEBS machine state registers

PEBS can capture machine state regs at retiremnt of the sampled
instructions. When precise sampling is enabled on an event, PEBS
is used, so substitute the interrupted state with the PEBS state.
Note that not all registers are captured by PEBS. Those missing
are replaced by the interrupt state counter-parts.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1411559322-16548-3-git-send-email-eranian@google.com
Cc: cebbert.lkml@gmail.com
Cc: jolsa@redhat.com
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 3c5d5c1..495ae97 100644
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
