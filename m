Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab3FXQiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 12:38:04 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:45599 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab3FXQiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 12:38:01 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Bo Shen <voice.shen@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Wenyou Yang <wenyou.yang@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/2] ARM: at91/PMC: fix at91sam9n12 USB FS init
Date: Mon, 24 Jun 2013 18:37:59 +0200
Message-ID: <1372091879-28459-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

at91sam9n12 has Full-speed only USB. So we should add
it to the list in at91_pllb_usbfs_clock_init() function.
Moreover, at91sam9n12 has an unusual PMC in the sense that it
has a PLLB but also has a USB clock register.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/clock.c                 | 25 +++++++++++++++++++++----
 arch/arm/mach-at91/include/mach/at91_pmc.h |  3 +++
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
index 978de42..661111f 100644
--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -489,7 +489,7 @@ static int at91_clk_show(struct seq_file *s, void *unused)
 		seq_printf(s, "UCKR = %8x\n", uckr);
 	}
 	seq_printf(s, "MCKR = %8x\n", at91_pmc_read(AT91_PMC_MCKR));
-	if (cpu_has_upll())
+	if (cpu_has_upll() || cpu_is_at91sam9n12())
 		seq_printf(s, "USB  = %8x\n", at91_pmc_read(AT91_PMC_USB));
 	seq_printf(s, "SR   = %8x\n", sr);
 
@@ -614,6 +614,8 @@ static u32 __init at91_usb_rate(struct clk *pll, u32 freq, u32 reg)
 {
 	if (pll == &pllb && (reg & AT91_PMC_USB96M))
 		return freq / 2;
+	else if (pll == &utmi_clk || cpu_is_at91sam9n12())
+		return freq / (1 + ((reg & AT91_PMC_OHCIUSBDIV) >> 8));
 	else
 		return freq;
 }
@@ -683,6 +685,8 @@ static struct clk *const standard_pmc_clocks[] __initconst = {
 /* PLLB generated USB full speed clock init */
 static void __init at91_pllb_usbfs_clock_init(unsigned long main_clock)
 {
+	unsigned int reg;
+
 	/*
 	 * USB clock init:  choose 48 MHz PLLB value,
 	 * disable 48MHz clock during usb peripheral suspend.
@@ -691,22 +695,35 @@ static void __init at91_pllb_usbfs_clock_init(unsigned long main_clock)
 	 */
 	uhpck.parent = &pllb;
 
-	at91_pllb_usb_init = at91_pll_calc(main_clock, 48000000 * 2) | AT91_PMC_USB96M;
+	reg = at91_pllb_usb_init = at91_pll_calc(main_clock, 48000000 * 2);
 	pllb.rate_hz = at91_pll_rate(&pllb, main_clock, at91_pllb_usb_init);
 	if (cpu_is_at91rm9200()) {
+		reg = at91_pllb_usb_init |= AT91_PMC_USB96M;
 		uhpck.pmc_mask = AT91RM9200_PMC_UHP;
 		udpck.pmc_mask = AT91RM9200_PMC_UDP;
 		at91_pmc_write(AT91_PMC_SCER, AT91RM9200_PMC_MCKUDP);
 	} else if (cpu_is_at91sam9260() || cpu_is_at91sam9261() ||
 		   cpu_is_at91sam9263() || cpu_is_at91sam9g20() ||
 		   cpu_is_at91sam9g10()) {
+		reg = at91_pllb_usb_init |= AT91_PMC_USB96M;
+		uhpck.pmc_mask = AT91SAM926x_PMC_UHP;
+		udpck.pmc_mask = AT91SAM926x_PMC_UDP;
+	} else if (cpu_is_at91sam9n12()) {
+		/* Divider for USB clock is in USB clock register for 9n12 */
+		reg = AT91_PMC_USBS_PLLB;
+
+		/* For PLLB output 96M, set usb divider 2 (USBDIV + 1) */
+		reg |= AT91_PMC_OHCIUSBDIV_2;
+		at91_pmc_write(AT91_PMC_USB, reg);
+
+		/* Still setup masks */
 		uhpck.pmc_mask = AT91SAM926x_PMC_UHP;
 		udpck.pmc_mask = AT91SAM926x_PMC_UDP;
 	}
 	at91_pmc_write(AT91_CKGR_PLLBR, 0);
 
-	udpck.rate_hz = at91_usb_rate(&pllb, pllb.rate_hz, at91_pllb_usb_init);
-	uhpck.rate_hz = at91_usb_rate(&pllb, pllb.rate_hz, at91_pllb_usb_init);
+	udpck.rate_hz = at91_usb_rate(&pllb, pllb.rate_hz, reg);
+	uhpck.rate_hz = at91_usb_rate(&pllb, pllb.rate_hz, reg);
 }
 
 /* UPLL generated USB full speed clock init */
diff --git a/arch/arm/mach-at91/include/mach/at91_pmc.h b/arch/arm/mach-at91/include/mach/at91_pmc.h
index 2bd7f51..c604cc6 100644
--- a/arch/arm/mach-at91/include/mach/at91_pmc.h
+++ b/arch/arm/mach-at91/include/mach/at91_pmc.h
@@ -130,7 +130,10 @@ extern void __iomem *at91_pmc_base;
 #define		AT91_PMC_USBS		(0x1 <<  0)		/* USB OHCI Input clock selection */
 #define			AT91_PMC_USBS_PLLA		(0 << 0)
 #define			AT91_PMC_USBS_UPLL		(1 << 0)
+#define			AT91_PMC_USBS_PLLB		(1 << 0)	/* [AT91SAMN12 only] */
 #define		AT91_PMC_OHCIUSBDIV	(0xF <<  8)		/* Divider for USB OHCI Clock */
+#define			AT91_PMC_OHCIUSBDIV_1	(0x0 <<  8)
+#define			AT91_PMC_OHCIUSBDIV_2	(0x1 <<  8)
 
 #define	AT91_PMC_SMD		0x3c			/* Soft Modem Clock Register [some SAM9 only] */
 #define		AT91_PMC_SMDS		(0x1  <<  0)		/* SMD input clock selection */
-- 
1.8.2.2

