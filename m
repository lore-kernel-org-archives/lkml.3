Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbaIBIPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 04:15:41 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35856 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752873AbaIBIPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 04:15:32 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Raphael Rigo <ml-arm@syscall.eu>, Arnaud Ebalard <arno@natisbad.org>,
        Simon Boulay <simon.boulay@vitec.com>,
        Leigh Brown <leigh@solinno.co.uk>
Subject: [PATCH V2 2/4] clk: mvebu: armada-370: Fix timer drift caused by the SSCG deviation
Date: Tue,  2 Sep 2014 10:15:17 +0200
Message-Id: <1409645719-20003-3-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409645719-20003-1-git-send-email-gregory.clement@free-electrons.com>
References: <1409645719-20003-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit activates the SSCG deviation correction for the Armada
370. It uses the optional function introduced by the commit "clk:
mvebu: Fix clk frequency value if SSCG is enabled".

Without this fix the deviation measured on a Mirabox was of a few
second each hour, whereas with this fix it was reduced at around
50ppm (around 4s per day).

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/clk/mvebu/armada-370.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/clk/mvebu/armada-370.c b/drivers/clk/mvebu/armada-370.c
index bef198a83863..756f0f39d6a3 100644
--- a/drivers/clk/mvebu/armada-370.c
+++ b/drivers/clk/mvebu/armada-370.c
@@ -23,6 +23,7 @@
  */
 
 #define SARL				0	/* Low part [0:31] */
+#define	 SARL_A370_SSCG_ENABLE		BIT(10)
 #define	 SARL_A370_PCLK_FREQ_OPT	11
 #define	 SARL_A370_PCLK_FREQ_OPT_MASK	0xF
 #define	 SARL_A370_FAB_FREQ_OPT		15
@@ -133,10 +134,17 @@ static void __init a370_get_clk_ratio(
 	}
 }
 
+static bool a370_is_sscg_enabled(void __iomem *sar)
+{
+	return !(readl(sar) & SARL_A370_SSCG_ENABLE);
+}
+
 static const struct coreclk_soc_desc a370_coreclks = {
 	.get_tclk_freq = a370_get_tclk_freq,
 	.get_cpu_freq = a370_get_cpu_freq,
 	.get_clk_ratio = a370_get_clk_ratio,
+	.is_sscg_enabled = a370_is_sscg_enabled,
+	.fix_sscg_deviation = kirkwood_fix_sscg_deviation,
 	.ratios = a370_coreclk_ratios,
 	.num_ratios = ARRAY_SIZE(a370_coreclk_ratios),
 };
-- 
1.9.1

