Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbaEHPOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:14:04 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:63120 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbaEHPOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:14:00 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org
Cc: git@xilinx.com, Michal Simek <monstr@monstr.eu>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] clocksource: cadence_ttc: Use readl/writel_relaxed instead of __raw
Date: Thu,  8 May 2014 17:13:38 +0200
Message-Id: <b8e5801e5f833aa180b020807ef91e0c568e99fa.1399562009.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <5e4fb08db4f6a436fc4593b22c3ae611ba545967.1399562009.git.michal.simek@xilinx.com>
References: <5e4fb08db4f6a436fc4593b22c3ae611ba545967.1399562009.git.michal.simek@xilinx.com>
In-Reply-To: <5e4fb08db4f6a436fc4593b22c3ae611ba545967.1399562009.git.michal.simek@xilinx.com>
References: <5e4fb08db4f6a436fc4593b22c3ae611ba545967.1399562009.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-691-1399562028-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-691-1399562028-0001

For supporting ARM big-endian is necessary to use
proper IO endianess accessors.

Based on Ben Dooks BE guide.
Similar conversion is done here:
"mv_xor: use {readl, writel}_relaxed instead of __raw_{readl, writel}"
(sha1: 5733c38ae3473115ac7df3fe19bd2502149d8c51)

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 drivers/clocksource/cadence_ttc_timer.c | 54 ++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index 49fbe2847c84..7a08811df9aa 100644
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@ -118,11 +118,11 @@ static void ttc_set_interval(struct ttc_timer *timer,
 	u32 ctrl_reg;

 	/* Disable the counter, set the counter value  and re-enable counter */
-	ctrl_reg = __raw_readl(timer->base_addr + TTC_CNT_CNTRL_OFFSET);
+	ctrl_reg = readl_relaxed(timer->base_addr + TTC_CNT_CNTRL_OFFSET);
 	ctrl_reg |= TTC_CNT_CNTRL_DISABLE_MASK;
-	__raw_writel(ctrl_reg, timer->base_addr + TTC_CNT_CNTRL_OFFSET);
+	writel_relaxed(ctrl_reg, timer->base_addr + TTC_CNT_CNTRL_OFFSET);

-	__raw_writel(cycles, timer->base_addr + TTC_INTR_VAL_OFFSET);
+	writel_relaxed(cycles, timer->base_addr + TTC_INTR_VAL_OFFSET);

 	/*
 	 * Reset the counter (0x10) so that it starts from 0, one-shot
@@ -130,7 +130,7 @@ static void ttc_set_interval(struct ttc_timer *timer,
 	 */
 	ctrl_reg |= CNT_CNTRL_RESET;
 	ctrl_reg &= ~TTC_CNT_CNTRL_DISABLE_MASK;
-	__raw_writel(ctrl_reg, timer->base_addr + TTC_CNT_CNTRL_OFFSET);
+	writel_relaxed(ctrl_reg, timer->base_addr + TTC_CNT_CNTRL_OFFSET);
 }

 /**
@@ -147,7 +147,7 @@ static irqreturn_t ttc_clock_event_interrupt(int irq, void *dev_id)
 	struct ttc_timer *timer = &ttce->ttc;

 	/* Acknowledge the interrupt and call event handler */
-	__raw_readl(timer->base_addr + TTC_ISR_OFFSET);
+	readl_relaxed(timer->base_addr + TTC_ISR_OFFSET);

 	ttce->ce.event_handler(&ttce->ce);

@@ -163,13 +163,13 @@ static cycle_t __ttc_clocksource_read(struct clocksource *cs)
 {
 	struct ttc_timer *timer = &to_ttc_timer_clksrc(cs)->ttc;

-	return (cycle_t)__raw_readl(timer->base_addr +
+	return (cycle_t)readl_relaxed(timer->base_addr +
 				TTC_COUNT_VAL_OFFSET);
 }

 static u64 notrace ttc_sched_clock_read(void)
 {
-	return __raw_readl(ttc_sched_clock_val_reg);
+	return readl_relaxed(ttc_sched_clock_val_reg);
 }

 /**
@@ -211,17 +211,17 @@ static void ttc_set_mode(enum clock_event_mode mode,
 	case CLOCK_EVT_MODE_ONESHOT:
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
-		ctrl_reg = __raw_readl(timer->base_addr +
+		ctrl_reg = readl_relaxed(timer->base_addr +
 					TTC_CNT_CNTRL_OFFSET);
 		ctrl_reg |= TTC_CNT_CNTRL_DISABLE_MASK;
-		__raw_writel(ctrl_reg,
+		writel_relaxed(ctrl_reg,
 				timer->base_addr + TTC_CNT_CNTRL_OFFSET);
 		break;
 	case CLOCK_EVT_MODE_RESUME:
-		ctrl_reg = __raw_readl(timer->base_addr +
+		ctrl_reg = readl_relaxed(timer->base_addr +
 					TTC_CNT_CNTRL_OFFSET);
 		ctrl_reg &= ~TTC_CNT_CNTRL_DISABLE_MASK;
-		__raw_writel(ctrl_reg,
+		writel_relaxed(ctrl_reg,
 				timer->base_addr + TTC_CNT_CNTRL_OFFSET);
 		break;
 	}
@@ -266,8 +266,8 @@ static int ttc_rate_change_clocksource_cb(struct notifier_block *nb,
 		 * of an abort.
 		 */
 		ttccs->scale_clk_ctrl_reg_old =
-			__raw_readl(ttccs->ttc.base_addr +
-					TTC_CLK_CNTRL_OFFSET);
+			readl_relaxed(ttccs->ttc.base_addr +
+			TTC_CLK_CNTRL_OFFSET);

 		psv = (ttccs->scale_clk_ctrl_reg_old &
 				TTC_CLK_CNTRL_PSV_MASK) >>
@@ -291,8 +291,8 @@ static int ttc_rate_change_clocksource_cb(struct notifier_block *nb,
 			return NOTIFY_DONE;

 		/* scale up: adjust divider now - before frequency change */
-		__raw_writel(ttccs->scale_clk_ctrl_reg_new,
-				ttccs->ttc.base_addr + TTC_CLK_CNTRL_OFFSET);
+		writel_relaxed(ttccs->scale_clk_ctrl_reg_new,
+			       ttccs->ttc.base_addr + TTC_CLK_CNTRL_OFFSET);
 		break;
 	}
 	case POST_RATE_CHANGE:
@@ -301,8 +301,8 @@ static int ttc_rate_change_clocksource_cb(struct notifier_block *nb,
 			return NOTIFY_OK;

 		/* scale down: adjust divider now - after frequency change */
-		__raw_writel(ttccs->scale_clk_ctrl_reg_new,
-				ttccs->ttc.base_addr + TTC_CLK_CNTRL_OFFSET);
+		writel_relaxed(ttccs->scale_clk_ctrl_reg_new,
+			       ttccs->ttc.base_addr + TTC_CLK_CNTRL_OFFSET);
 		break;

 	case ABORT_RATE_CHANGE:
@@ -311,8 +311,8 @@ static int ttc_rate_change_clocksource_cb(struct notifier_block *nb,
 			return NOTIFY_OK;

 		/* restore original register value */
-		__raw_writel(ttccs->scale_clk_ctrl_reg_old,
-				ttccs->ttc.base_addr + TTC_CLK_CNTRL_OFFSET);
+		writel_relaxed(ttccs->scale_clk_ctrl_reg_old,
+			       ttccs->ttc.base_addr + TTC_CLK_CNTRL_OFFSET);
 		/* fall through */
 	default:
 		return NOTIFY_DONE;
@@ -359,10 +359,10 @@ static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base)
 	 * with no interrupt and it rolls over at 0xFFFF. Pre-scale
 	 * it by 32 also. Let it start running now.
 	 */
-	__raw_writel(0x0,  ttccs->ttc.base_addr + TTC_IER_OFFSET);
-	__raw_writel(CLK_CNTRL_PRESCALE | CLK_CNTRL_PRESCALE_EN,
+	writel_relaxed(0x0,  ttccs->ttc.base_addr + TTC_IER_OFFSET);
+	writel_relaxed(CLK_CNTRL_PRESCALE | CLK_CNTRL_PRESCALE_EN,
 		     ttccs->ttc.base_addr + TTC_CLK_CNTRL_OFFSET);
-	__raw_writel(CNT_CNTRL_RESET,
+	writel_relaxed(CNT_CNTRL_RESET,
 		     ttccs->ttc.base_addr + TTC_CNT_CNTRL_OFFSET);

 	err = clocksource_register_hz(&ttccs->cs, ttccs->ttc.freq / PRESCALE);
@@ -438,10 +438,10 @@ static void __init ttc_setup_clockevent(struct clk *clk,
 	 * is prescaled by 32 using the interval interrupt. Leave it
 	 * disabled for now.
 	 */
-	__raw_writel(0x23, ttcce->ttc.base_addr + TTC_CNT_CNTRL_OFFSET);
-	__raw_writel(CLK_CNTRL_PRESCALE | CLK_CNTRL_PRESCALE_EN,
+	writel_relaxed(0x23, ttcce->ttc.base_addr + TTC_CNT_CNTRL_OFFSET);
+	writel_relaxed(CLK_CNTRL_PRESCALE | CLK_CNTRL_PRESCALE_EN,
 		     ttcce->ttc.base_addr + TTC_CLK_CNTRL_OFFSET);
-	__raw_writel(0x1,  ttcce->ttc.base_addr + TTC_IER_OFFSET);
+	writel_relaxed(0x1,  ttcce->ttc.base_addr + TTC_IER_OFFSET);

 	err = request_irq(irq, ttc_clock_event_interrupt,
 			  IRQF_TIMER, ttcce->ce.name, ttcce);
@@ -490,7 +490,7 @@ static void __init ttc_timer_init(struct device_node *timer)
 		BUG();
 	}

-	clksel = __raw_readl(timer_baseaddr + TTC_CLK_CNTRL_OFFSET);
+	clksel = readl_relaxed(timer_baseaddr + TTC_CLK_CNTRL_OFFSET);
 	clksel = !!(clksel & TTC_CLK_CNTRL_CSRC_MASK);
 	clk_cs = of_clk_get(timer, clksel);
 	if (IS_ERR(clk_cs)) {
@@ -498,7 +498,7 @@ static void __init ttc_timer_init(struct device_node *timer)
 		BUG();
 	}

-	clksel = __raw_readl(timer_baseaddr + 4 + TTC_CLK_CNTRL_OFFSET);
+	clksel = readl_relaxed(timer_baseaddr + 4 + TTC_CLK_CNTRL_OFFSET);
 	clksel = !!(clksel & TTC_CLK_CNTRL_CSRC_MASK);
 	clk_ce = of_clk_get(timer, clksel);
 	if (IS_ERR(clk_ce)) {
--
1.8.2.3


--=_mimegpg-monstr-desktop-691-1399562028-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlNrnywACgkQykllyylKDCHD7QCeJckG16v74Ttfa/QDoROVLVHG
aOMAoJD2Dh9wIeVPxUGeM04m0qtPZ7V4
=i8uz
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-691-1399562028-0001--
