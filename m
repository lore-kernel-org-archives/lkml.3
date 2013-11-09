Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab3KIGww (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:52:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932868Ab3KIGwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 3.11 68/94] clk: nomadik: set all timers to use 2.4 MHz TIMCLK
Date: Fri,  8 Nov 2013 22:52:14 -0800
Message-Id: <20131109065209.076300558@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit b9b5ab11ea221a9f2d5af41da639e0898675c34c upstream.

This fixes a regression for the Nomadik on the main system
timers.

The Nomadik seemed a bit slow and its heartbeat wasn't looking
healthy. And it was not strange, because it has been connected
to the 32768 Hz clock at boot, while being told by the clock driver
that it was 2.4MHz. Actually connect the TIMCLK to 2.4MHz by
default as this is what we want for nice scheduling, clocksource
and clock event.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/clk-nomadik.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/drivers/clk/clk-nomadik.c
+++ b/drivers/clk/clk-nomadik.c
@@ -27,6 +27,14 @@
  */
 
 #define SRC_CR			0x00U
+#define SRC_CR_T0_ENSEL		BIT(15)
+#define SRC_CR_T1_ENSEL		BIT(17)
+#define SRC_CR_T2_ENSEL		BIT(19)
+#define SRC_CR_T3_ENSEL		BIT(21)
+#define SRC_CR_T4_ENSEL		BIT(23)
+#define SRC_CR_T5_ENSEL		BIT(25)
+#define SRC_CR_T6_ENSEL		BIT(27)
+#define SRC_CR_T7_ENSEL		BIT(29)
 #define SRC_XTALCR		0x0CU
 #define SRC_XTALCR_XTALTIMEN	BIT(20)
 #define SRC_XTALCR_SXTALDIS	BIT(19)
@@ -543,6 +551,19 @@ void __init nomadik_clk_init(void)
 		       __func__, np->name);
 		return;
 	}
+
+	/* Set all timers to use the 2.4 MHz TIMCLK */
+	val = readl(src_base + SRC_CR);
+	val |= SRC_CR_T0_ENSEL;
+	val |= SRC_CR_T1_ENSEL;
+	val |= SRC_CR_T2_ENSEL;
+	val |= SRC_CR_T3_ENSEL;
+	val |= SRC_CR_T4_ENSEL;
+	val |= SRC_CR_T5_ENSEL;
+	val |= SRC_CR_T6_ENSEL;
+	val |= SRC_CR_T7_ENSEL;
+	writel(val, src_base + SRC_CR);
+
 	val = readl(src_base + SRC_XTALCR);
 	pr_info("SXTALO is %s\n",
 		(val & SRC_XTALCR_SXTALDIS) ? "disabled" : "enabled");


