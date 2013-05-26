Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898Ab3EZC4q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 22:56:46 -0400
Received: from gnurou.org ([207.192.72.5]:55584 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758497Ab3EZC4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 22:56:45 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 May 2013 22:56:45 EDT
From: Alexandre Courbot <acourbot@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH RESEND] ARM: tegra114: correctly output clk_32k
Date: Sun, 26 May 2013 11:56:31 +0900
Message-Id: <1369536991-6111-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra has a blink timer register that allows to modulate the
clk_32k clock before outputting it. Since clk_32k is presented to the
kernel as a fixed clock, make sure this register does not tamper with
the clock frequency and that clk_32k is outputted as-is, similarly to
what is done on t20 and t30.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/clk/tegra/clk-tegra114.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index d78e16e..dc76d67 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -127,6 +127,7 @@
 #define PMC_DPD_PADS_ORIDE_BLINK_ENB 20
 #define PMC_CTRL 0
 #define PMC_CTRL_BLINK_ENB 7
+#define PMC_BLINK_TIMER 0x40
 
 #define OSC_CTRL			0x50
 #define OSC_CTRL_OSC_FREQ_SHIFT		28
@@ -1625,6 +1626,8 @@ static void __init tegra114_pmc_clk_init(void __iomem *pmc_base)
 	clks[clk_out_3] = clk;
 
 	/* blink */
+	/* clear the blink timer register to directly output clk_32k */
+	writel_relaxed(0, pmc_base + PMC_BLINK_TIMER);
 	clk = clk_register_gate(NULL, "blink_override", "clk_32k", 0,
 				pmc_base + PMC_DPD_PADS_ORIDE,
 				PMC_DPD_PADS_ORIDE_BLINK_ENB, 0, NULL);
-- 
1.8.2.3

