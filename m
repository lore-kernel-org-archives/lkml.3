Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbbA2LR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:17:26 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:22398 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923AbbA2LOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:14:35 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Ralf Baechle <ralf@linux-mips.org>, <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 5/9] MIPS: Malta: Implement get_c0_fdc_int()
Date: Thu, 29 Jan 2015 11:14:10 +0000
Message-ID: <1422530054-7976-6-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <1422530054-7976-1-git-send-email-james.hogan@imgtec.com>
References: <1422530054-7976-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.110]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the weak get_c0_fdc_int() function for Malta. The Fast Debug
Channel (FDC) interrupt is obtained mainly depending on whether a GIC is
present. Vectored external interrupt mode isn't yet supported.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
EIC mode not supported because I don't have anything to try it on (and
it isn't clear which interrupt priority level would get used).

It may make sense to have a common default implementation of
get_c0_fdc_int(), but this isn't done for the other local IRQs yet so
I've kept it like this for consistency.
---
 arch/mips/mti-malta/malta-time.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/mips/mti-malta/malta-time.c b/arch/mips/mti-malta/malta-time.c
index ce02dbdedc62..7d4b86571564 100644
--- a/arch/mips/mti-malta/malta-time.c
+++ b/arch/mips/mti-malta/malta-time.c
@@ -115,6 +115,22 @@ void read_persistent_clock(struct timespec *ts)
 	ts->tv_nsec = 0;
 }
 
+int get_c0_fdc_int(void)
+{
+	int mips_cpu_fdc_irq;
+
+	if (cpu_has_veic)
+		mips_cpu_fdc_irq = -1;
+	else if (gic_present)
+		mips_cpu_fdc_irq = gic_get_c0_fdc_int();
+	else if (cp0_fdc_irq >= 0)
+		mips_cpu_fdc_irq = MIPS_CPU_IRQ_BASE + cp0_fdc_irq;
+	else
+		mips_cpu_fdc_irq = -1;
+
+	return mips_cpu_fdc_irq;
+}
+
 int get_c0_perfcount_int(void)
 {
 	if (cpu_has_veic) {
-- 
2.0.5

