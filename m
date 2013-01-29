Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab3A2Irl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 03:47:41 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:15700
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753514Ab3A2Irk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 03:47:40 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(zcb8kzzz1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1155h)
From: Gary Zhang <b13634@freescale.com>
To: <shawn.guo@linaro.org>, <kernel@pengutronix.de>, <linux@arm.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] ARM: imx: set CKO1 parent clock source in imx6q sabresd
Date: Tue, 29 Jan 2013 15:49:39 +0800
Message-ID: <1359445779-2038-1-git-send-email-b13634@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in imx6q sabresd board, wm8962 uses CKO1 as MCLK. set ahb as CKO1
parent clock source

Signed-off-by: Gary Zhang <b13634@freescale.com>
---
 arch/arm/mach-imx/mach-imx6q.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index 4eb1b3a..ee3f357 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -151,6 +151,36 @@ static void __init imx6q_sabrelite_init(void)
 	imx6q_sabrelite_cko1_setup();
 }
 
+static void __init imx6q_sabresd_cko1_setup(void)
+{
+	struct clk *cko1_sel, *ahb, *cko1;
+	unsigned long rate;
+
+	cko1_sel = clk_get_sys(NULL, "cko1_sel");
+	ahb = clk_get_sys(NULL, "ahb");
+	cko1 = clk_get_sys(NULL, "cko1");
+	if (IS_ERR(cko1_sel) || IS_ERR(ahb) || IS_ERR(cko1)) {
+		pr_err("cko1 setup failed!\n");
+		goto put_clk;
+	}
+	clk_set_parent(cko1_sel, ahb);
+	rate = clk_round_rate(cko1, 24000000);
+	clk_set_rate(cko1, rate);
+
+	return;
+put_clk:
+	if (!IS_ERR(cko1_sel))
+		clk_put(cko1_sel);
+	if (!IS_ERR(ahb))
+		clk_put(ahb);
+	if (!IS_ERR(cko1))
+		clk_put(cko1);
+}
+static void __init imx6q_sabresd_init(void)
+{
+	imx6q_sabresd_cko1_setup();
+}
+
 static void __init imx6q_1588_init(void)
 {
 	struct regmap *gpr;
@@ -193,6 +223,8 @@ static void __init imx6q_init_machine(void)
 {
 	if (of_machine_is_compatible("fsl,imx6q-sabrelite"))
 		imx6q_sabrelite_init();
+	else if (of_machine_is_compatible("fsl,imx6q-sabresd"))
+		imx6q_sabresd_init();
 
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 
-- 
1.7.0.4


