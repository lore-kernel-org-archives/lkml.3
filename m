Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaJTTJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:09:33 -0400
Received: from mail-qg0-f74.google.com ([209.85.192.74]:44066 "EHLO
	mail-qg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaJTTEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:04:10 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        John Crispin <blogic@openwrt.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/19] MIPS: sead3: Stop using GIC REG macros
Date: Mon, 20 Oct 2014 12:03:50 -0700
Message-Id: <1413831846-32100-4-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
References: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop using the REG macros from gic.h and instead use proper iomem
accessors.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/mti-sead3/sead3-int.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/mips/mti-sead3/sead3-int.c b/arch/mips/mti-sead3/sead3-int.c
index 69ae185..995c401 100644
--- a/arch/mips/mti-sead3/sead3-int.c
+++ b/arch/mips/mti-sead3/sead3-int.c
@@ -20,16 +20,15 @@
 #define SEAD_CONFIG_BASE		0x1b100110
 #define SEAD_CONFIG_SIZE		4
 
-static unsigned long sead3_config_reg;
+static void __iomem *sead3_config_reg;
 
 void __init arch_init_irq(void)
 {
 	if (!cpu_has_veic)
 		mips_cpu_irq_init();
 
-	sead3_config_reg = (unsigned long)ioremap_nocache(SEAD_CONFIG_BASE,
-		SEAD_CONFIG_SIZE);
-	gic_present = (REG32(sead3_config_reg) & SEAD_CONFIG_GIC_PRESENT_MSK) >>
+	sead3_config_reg = ioremap_nocache(SEAD_CONFIG_BASE, SEAD_CONFIG_SIZE);
+	gic_present = (readl(sead3_config_reg) & SEAD_CONFIG_GIC_PRESENT_MSK) >>
 		SEAD_CONFIG_GIC_PRESENT_SHF;
 	pr_info("GIC: %spresent\n", (gic_present) ? "" : "not ");
 	pr_info("EIC: %s\n",
-- 
2.1.0.rc2.206.gedb03e5

