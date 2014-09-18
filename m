Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821AbaIRVxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 17:53:48 -0400
Received: from mail-ob0-f201.google.com ([209.85.214.201]:39177 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757449AbaIRVri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 17:47:38 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>, Jonas Gorski <jogo@openwrt.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 03/24] MIPS: Provide a generic plat_irq_dispatch
Date: Thu, 18 Sep 2014 14:47:09 -0700
Message-Id: <1411076851-28242-4-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1411076851-28242-1-git-send-email-abrestic@chromium.org>
References: <1411076851-28242-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For platforms which boot with device-tree or have correctly chained
all external interrupt controllers, a generic plat_irq_dispatch() can
be used.  Implement a plat_irq_dispatch() which simply handles all the
pending interrupts as reported by C0_Cause.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
Reviewed-by: Qais Yousef <qais.yousef@imgtec.com>
Tested-by: Qais Yousef <qais.yousef@imgtec.com>
---
Changes from v1:
 - handle interrupts in descending order
---
 arch/mips/kernel/irq_cpu.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/mips/kernel/irq_cpu.c b/arch/mips/kernel/irq_cpu.c
index ca98a9f..531b11c 100644
--- a/arch/mips/kernel/irq_cpu.c
+++ b/arch/mips/kernel/irq_cpu.c
@@ -94,6 +94,24 @@ static struct irq_chip mips_mt_cpu_irq_controller = {
 	.irq_eoi	= unmask_mips_irq,
 };
 
+asmlinkage void __weak plat_irq_dispatch(void)
+{
+	unsigned long pending = read_c0_cause() & read_c0_status() & ST0_IM;
+	int irq;
+
+	if (!pending) {
+		spurious_interrupt();
+		return;
+	}
+
+	pending >>= CAUSEB_IP;
+	while (pending) {
+		irq = fls(pending) - 1;
+		do_IRQ(MIPS_CPU_IRQ_BASE + irq);
+		pending &= ~BIT(irq);
+	}
+}
+
 static int mips_cpu_intc_map(struct irq_domain *d, unsigned int irq,
 			     irq_hw_number_t hw)
 {
-- 
2.1.0.rc2.206.gedb03e5

