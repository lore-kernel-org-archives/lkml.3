Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759949AbbA0VqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:46:20 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:31769 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315AbbA0VqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:46:16 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Ralf Baechle <ralf@linux-mips.org>, <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 1/9] MIPS: cevt-r4k: Move handle_perf_irq() out of header
Date: Tue, 27 Jan 2015 21:45:47 +0000
Message-ID: <1422395155-16511-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <1422395155-16511-1-git-send-email-james.hogan@imgtec.com>
References: <1422395155-16511-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.110]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Long ago, commit 8531a35e5e27 ("[MIPS] SMTC: Fix SMTC dyntick support.")
moved handle_perf_irq() out of cevt-r4k.c into a header so it could be
shared with cevt-smtc.c.

Slightly less long ago, commit b633648c5ad3 ("MIPS: MT: Remove SMTC
support") removed all traces of SMTC support, including cevt-smtc.c,
leaving cevt-r4k.c once again the sole user of handle_perf_irq(),
therefore move it back into cevt-r4k.c from the header.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/include/asm/cevt-r4k.h | 19 -------------------
 arch/mips/kernel/cevt-r4k.c      | 18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/arch/mips/include/asm/cevt-r4k.h b/arch/mips/include/asm/cevt-r4k.h
index 65f9bdd02f1f..f0edf6fcd002 100644
--- a/arch/mips/include/asm/cevt-r4k.h
+++ b/arch/mips/include/asm/cevt-r4k.h
@@ -27,23 +27,4 @@ irqreturn_t c0_compare_interrupt(int, void *);
 extern struct irqaction c0_compare_irqaction;
 extern int cp0_timer_irq_installed;
 
-/*
- * Possibly handle a performance counter interrupt.
- * Return true if the timer interrupt should not be checked
- */
-
-static inline int handle_perf_irq(int r2)
-{
-	/*
-	 * The performance counter overflow interrupt may be shared with the
-	 * timer interrupt (cp0_perfcount_irq < 0). If it is and a
-	 * performance counter has overflowed (perf_irq() == IRQ_HANDLED)
-	 * and we can't reliably determine if a counter interrupt has also
-	 * happened (!r2) then don't check for a timer interrupt.
-	 */
-	return (cp0_perfcount_irq < 0) &&
-		perf_irq() == IRQ_HANDLED &&
-		!r2;
-}
-
 #endif /* __ASM_CEVT_R4K_H */
diff --git a/arch/mips/kernel/cevt-r4k.c b/arch/mips/kernel/cevt-r4k.c
index 6acaad0480af..02dd77955a6f 100644
--- a/arch/mips/kernel/cevt-r4k.c
+++ b/arch/mips/kernel/cevt-r4k.c
@@ -38,6 +38,24 @@ void mips_set_clock_mode(enum clock_event_mode mode,
 DEFINE_PER_CPU(struct clock_event_device, mips_clockevent_device);
 int cp0_timer_irq_installed;
 
+/*
+ * Possibly handle a performance counter interrupt.
+ * Return true if the timer interrupt should not be checked
+ */
+static inline int handle_perf_irq(int r2)
+{
+	/*
+	 * The performance counter overflow interrupt may be shared with the
+	 * timer interrupt (cp0_perfcount_irq < 0). If it is and a
+	 * performance counter has overflowed (perf_irq() == IRQ_HANDLED)
+	 * and we can't reliably determine if a counter interrupt has also
+	 * happened (!r2) then don't check for a timer interrupt.
+	 */
+	return (cp0_perfcount_irq < 0) &&
+		perf_irq() == IRQ_HANDLED &&
+		!r2;
+}
+
 irqreturn_t c0_compare_interrupt(int irq, void *dev_id)
 {
 	const int r2 = cpu_has_mips_r2;
-- 
2.0.5

