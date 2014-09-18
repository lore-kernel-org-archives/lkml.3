Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbaIRVyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 17:54:14 -0400
Received: from mail-pa0-f73.google.com ([209.85.220.73]:46112 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932700AbaIRVyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 17:54:09 -0400
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
Subject: [PATCH V2 24/24] MIPS: sead3: Use generic plat_irq_dispatch
Date: Thu, 18 Sep 2014 14:47:30 -0700
Message-Id: <1411076851-28242-25-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1411076851-28242-1-git-send-email-abrestic@chromium.org>
References: <1411076851-28242-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic plat_irq_dispatch provided in irq_cpu.c is sufficient for
dispatching interrupts on SEAD-3 in legacy and vectored interrupt modes.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
Reviewed-by: Qais Yousef <qais.yousef@imgtec.com>
Tested-by: Qais Yousef <qais.yousef@imgtec.com>
---
No changes from v1.
---
 arch/mips/mti-sead3/sead3-int.c | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/arch/mips/mti-sead3/sead3-int.c b/arch/mips/mti-sead3/sead3-int.c
index cb06cd9..69ae185 100644
--- a/arch/mips/mti-sead3/sead3-int.c
+++ b/arch/mips/mti-sead3/sead3-int.c
@@ -22,32 +22,11 @@
 
 static unsigned long sead3_config_reg;
 
-asmlinkage void plat_irq_dispatch(void)
-{
-	unsigned int pending = read_c0_cause() & read_c0_status() & ST0_IM;
-	int irq;
-
-	irq = (fls(pending) - CAUSEB_IP - 1);
-	if (irq >= 0)
-		do_IRQ(MIPS_CPU_IRQ_BASE + irq);
-	else
-		spurious_interrupt();
-}
-
 void __init arch_init_irq(void)
 {
-	int i;
-
-	if (!cpu_has_veic) {
+	if (!cpu_has_veic)
 		mips_cpu_irq_init();
 
-		if (cpu_has_vint) {
-			/* install generic handler */
-			for (i = 0; i < 8; i++)
-				set_vi_handler(i, plat_irq_dispatch);
-		}
-	}
-
 	sead3_config_reg = (unsigned long)ioremap_nocache(SEAD_CONFIG_BASE,
 		SEAD_CONFIG_SIZE);
 	gic_present = (REG32(sead3_config_reg) & SEAD_CONFIG_GIC_PRESENT_MSK) >>
-- 
2.1.0.rc2.206.gedb03e5

