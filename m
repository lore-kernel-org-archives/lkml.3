Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbaCDQmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:42:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41585 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbaCDQme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:42:34 -0500
Date: Tue, 4 Mar 2014 08:40:28 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-8435cf757632a5559fbbf1cb79299716c8d5b651@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        linux-arm-kernel@lists.infradead.org, rmk+kernel@arm.linux.org.uk,
        peterz@infradead.org, tony@atomide.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, peterz@infradead.org,
        rmk+kernel@arm.linux.org.uk, tony@atomide.com, tglx@linutronix.de
In-Reply-To: <20140223212737.099151500@linutronix.de>
References: <20140223212737.099151500@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] arm: Replace various irq_desc accesses
Git-Commit-ID: 8435cf757632a5559fbbf1cb79299716c8d5b651
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

Commit-ID:  8435cf757632a5559fbbf1cb79299716c8d5b651
Gitweb:     http://git.kernel.org/tip/8435cf757632a5559fbbf1cb79299716c8d5b651
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 23 Feb 2014 21:40:12 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 17:37:52 +0100

arm: Replace various irq_desc accesses

Use the proper functions. There is no need to fiddle with irq_desc.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Shawn Guo <shawn.guo@linaro.org>C
Acked-by: Tony Lindgren <tony@atomide.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: arm <linux-arm-kernel@lists.infradead.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Link: http://lkml.kernel.org/r/20140223212737.099151500@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/mach-imx/pm-imx6q.c        | 7 +++----
 arch/arm/mach-omap1/ams-delta-fiq.c | 7 ++-----
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-imx/pm-imx6q.c b/arch/arm/mach-imx/pm-imx6q.c
index 7a9b985..29e3fe6 100644
--- a/arch/arm/mach-imx/pm-imx6q.c
+++ b/arch/arm/mach-imx/pm-imx6q.c
@@ -120,7 +120,7 @@ static void imx6q_enable_wb(bool enable)
 
 int imx6q_set_lpm(enum mxc_cpu_pwr_mode mode)
 {
-	struct irq_desc *iomuxc_irq_desc;
+	struct irq_data *iomuxc_irq_data = irq_get_irq_data(32);
 	u32 val = readl_relaxed(ccm_base + CLPCR);
 
 	val &= ~BM_CLPCR_LPM;
@@ -167,10 +167,9 @@ int imx6q_set_lpm(enum mxc_cpu_pwr_mode mode)
 	 * 3) Software should mask IRQ #32 right after CCM Low-Power mode
 	 *    is set (set bits 0-1 of CCM_CLPCR).
 	 */
-	iomuxc_irq_desc = irq_to_desc(32);
-	imx_gpc_irq_unmask(&iomuxc_irq_desc->irq_data);
+	imx_gpc_irq_unmask(iomuxc_irq_data);
 	writel_relaxed(val, ccm_base + CLPCR);
-	imx_gpc_irq_mask(&iomuxc_irq_desc->irq_data);
+	imx_gpc_irq_mask(iomuxc_irq_data);
 
 	return 0;
 }
diff --git a/arch/arm/mach-omap1/ams-delta-fiq.c b/arch/arm/mach-omap1/ams-delta-fiq.c
index f12a12a..2ebc514 100644
--- a/arch/arm/mach-omap1/ams-delta-fiq.c
+++ b/arch/arm/mach-omap1/ams-delta-fiq.c
@@ -44,13 +44,10 @@ static unsigned int irq_counter[16];
 
 static irqreturn_t deferred_fiq(int irq, void *dev_id)
 {
-	struct irq_desc *irq_desc;
-	struct irq_chip *irq_chip = NULL;
 	int gpio, irq_num, fiq_count;
+	struct irq_chip *irq_chip;
 
-	irq_desc = irq_to_desc(gpio_to_irq(AMS_DELTA_GPIO_PIN_KEYBRD_CLK));
-	if (irq_desc)
-		irq_chip = irq_desc->irq_data.chip;
+	irq_chip = irq_get_irq_chip(gpio_to_irq(AMS_DELTA_GPIO_PIN_KEYBRD_CLK));
 
 	/*
 	 * For each handled GPIO interrupt, keep calling its interrupt handler
