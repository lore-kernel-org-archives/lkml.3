Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab3JBMl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:41:57 -0400
Received: from 4.mo4.mail-out.ovh.net ([178.32.98.131]:60198 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753761Ab3JBMlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:41:32 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: [PATCH 1/3] ARM: at91/tc/clocksource: replace clk_enable/disable with clk_prepare_enable/disable_unprepare
Date: Wed,  2 Oct 2013 14:34:57 +0200
Message-Id: <1380717297-6537-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380717265-6497-1-git-send-email-b.brezillon@overkiz.com>
References: <1380717265-6497-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 1365716587702614124
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrudegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrudegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
avoid common clk framework warnings.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/clocksource/tcb_clksrc.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
index 8a61872..0481562 100644
--- a/drivers/clocksource/tcb_clksrc.c
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -100,7 +100,7 @@ static void tc_mode(enum clock_event_mode m, struct clock_event_device *d)
 			|| tcd->clkevt.mode == CLOCK_EVT_MODE_ONESHOT) {
 		__raw_writel(0xff, regs + ATMEL_TC_REG(2, IDR));
 		__raw_writel(ATMEL_TC_CLKDIS, regs + ATMEL_TC_REG(2, CCR));
-		clk_disable(tcd->clk);
+		clk_disable_unprepare(tcd->clk);
 	}
 
 	switch (m) {
@@ -109,7 +109,7 @@ static void tc_mode(enum clock_event_mode m, struct clock_event_device *d)
 	 * of oneshot, we get lower overhead and improved accuracy.
 	 */
 	case CLOCK_EVT_MODE_PERIODIC:
-		clk_enable(tcd->clk);
+		clk_prepare_enable(tcd->clk);
 
 		/* slow clock, count up to RC, then irq and restart */
 		__raw_writel(timer_clock
@@ -126,7 +126,7 @@ static void tc_mode(enum clock_event_mode m, struct clock_event_device *d)
 		break;
 
 	case CLOCK_EVT_MODE_ONESHOT:
-		clk_enable(tcd->clk);
+		clk_prepare_enable(tcd->clk);
 
 		/* slow clock, count up to RC, then irq and stop */
 		__raw_writel(timer_clock | ATMEL_TC_CPCSTOP
@@ -265,6 +265,7 @@ static int __init tcb_clksrc_init(void)
 	int best_divisor_idx = -1;
 	int clk32k_divisor_idx = -1;
 	int i;
+	int ret;
 
 	tc = atmel_tc_alloc(CONFIG_ATMEL_TCB_CLKSRC_BLOCK, clksrc.name);
 	if (!tc) {
@@ -275,7 +276,11 @@ static int __init tcb_clksrc_init(void)
 	pdev = tc->pdev;
 
 	t0_clk = tc->clk[0];
-	clk_enable(t0_clk);
+	ret = clk_prepare_enable(t0_clk);
+	if (ret) {
+		pr_debug("can't enable T0 clk\n");
+		goto err_free_tc;
+	}
 
 	/* How fast will we be counting?  Pick something over 5 MHz.  */
 	rate = (u32) clk_get_rate(t0_clk);
@@ -313,7 +318,11 @@ static int __init tcb_clksrc_init(void)
 		/* tclib will give us three clocks no matter what the
 		 * underlying platform supports.
 		 */
-		clk_enable(tc->clk[1]);
+		ret = clk_prepare_enable(tc->clk[1]);
+		if (ret) {
+			pr_debug("can't enable T1 clk\n");
+			goto err_disable_t0;
+		}
 		/* setup both channel 0 & 1 */
 		tcb_setup_dual_chan(tc, best_divisor_idx);
 	}
@@ -325,5 +334,12 @@ static int __init tcb_clksrc_init(void)
 	setup_clkevents(tc, clk32k_divisor_idx);
 
 	return 0;
+
+err_disable_t0:
+	clk_disable_unprepare(t0_clk);
+
+err_free_tc:
+	atmel_tc_free(tc);
+	return ret;
 }
 arch_initcall(tcb_clksrc_init);
-- 
1.7.9.5

