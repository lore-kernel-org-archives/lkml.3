Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbaLVTcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 14:32:13 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:46822 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868AbaLVTcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 14:32:11 -0500
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>, Chris Zhong <zyw@rock-chips.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-rockchip@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, sboyd@codeaurora.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] clk: rockchip: rk3288: Make s2r reliable by switching PLLs to slow mode
Date: Mon, 22 Dec 2014 11:31:48 -0800
Message-Id: <1419276708-28294-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've been seeing some crashes at resume time on rk3288-based systems.
On some machines they simply never wake up from suspend.  Symptoms
include:

- System clearly got to sleep OK.  Power consumption is low, the PWM
  for the PWM regulator has stopped, and the "global_pwroff" output
  shows that the system is down.

- When system tries to wake up power consumption goes up.

- No kernel resume code (which was left in PMU SRAM) ran.  We added
  some basic logging to this code (write to a location in SRAM right
  at resume time) and didn't see the logging run.

It appears that we can fix the problem by slowing down APLL before we
suspend.  On the system I tested things seemed reliable if I disabled
1.8GHz and 1.7GHz.  The Mask ROM itself tries to slow things down
(which is why PLLs are in slow mode by the time we get to the kernel),
but apparently it is crashing before it even gets there.

We'll be super paranoid and not just go down to 1.6GHz but we'll match
what the Mask ROM seems to be doing and go into slow mode.  We'll also
be safe and put all PLLs (not just APLL) into slow mode (well, except
DPLL which is needed for SDRAM).  We'll even put NPLL into slow mode
which the Mask ROM didn't do (not that it's used for much important
stuff at early resume time).

Note that the old Rockchip reference code did something just like
this, though they jammed it into pm.c instead of putting it in the
syscore ops of the clock driver.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/clk/rockchip/clk-rk3288.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index ac6be7c..8cf4210 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -805,6 +805,20 @@ static int rk3288_clk_suspend(void)
 		rk3288_saved_cru_regs[i] =
 				readl_relaxed(rk3288_cru_base + reg_id);
 	}
+
+	/*
+	 * Switch PLLs other than DPLL (for SDRAM) to slow mode to
+	 * avoid crashes on resume. The Mask ROM on the system will
+	 * put APLL, CPLL, and GPLL into slow mode at resume time
+	 * anyway (which is why we restore them), but we might not
+	 * even make it to the Mask ROM if this isn't done at suspend
+	 * time.
+	 *
+	 * NOTE: only APLL truly matters here, but we'll do them all.
+	 */
+
+	writel_relaxed(0xf3030000, rk3288_cru_base + RK3288_MODE_CON);
+
 	return 0;
 }
 
-- 
2.2.0.rc0.207.ga3a616c

