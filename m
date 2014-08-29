Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaH2LoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 07:44:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48220 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752735AbaH2LoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 07:44:07 -0400
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
        Simon Boulay <simon.boulay@vitec.com>
Subject: [PATCH 2/4] clk: mvebu: armada-370: Fix timer drift caused by the SSCG deviation
Date: Fri, 29 Aug 2014 13:43:38 +0200
Message-Id: <1409312620-20631-3-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409312620-20631-1-git-send-email-gregory.clement@free-electrons.com>
References: <1409312620-20631-1-git-send-email-gregory.clement@free-electrons.com>
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
 drivers/clk/mvebu/armada-370.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/clk/mvebu/armada-370.c b/drivers/clk/mvebu/armada-370.c
index bef198a83863..b084a84d8fad 100644
--- a/drivers/clk/mvebu/armada-370.c
+++ b/drivers/clk/mvebu/armada-370.c
@@ -23,6 +23,7 @@
  */
 
 #define SARL				0	/* Low part [0:31] */
+#define	 SARL_A370_SSCG_ENABLE		BIT(10)
 #define	 SARL_A370_PCLK_FREQ_OPT	11
 #define	 SARL_A370_PCLK_FREQ_OPT_MASK	0xF
 #define	 SARL_A370_FAB_FREQ_OPT		15
@@ -133,10 +134,16 @@ static void __init a370_get_clk_ratio(
 	}
 }
 
+bool a370_is_sscg_enabled(void __iomem *sar)
+{
+	return !(readl(sar) & SARL_A370_SSCG_ENABLE);
+}
+
 static const struct coreclk_soc_desc a370_coreclks = {
 	.get_tclk_freq = a370_get_tclk_freq,
 	.get_cpu_freq = a370_get_cpu_freq,
 	.get_clk_ratio = a370_get_clk_ratio,
+	.is_sscg_enabled = a370_is_sscg_enabled,
 	.ratios = a370_coreclk_ratios,
 	.num_ratios = ARRAY_SIZE(a370_coreclk_ratios),
 };
-- 
1.9.1

