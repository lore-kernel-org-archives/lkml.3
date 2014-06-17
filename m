Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568AbaFQO6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:58:46 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:41382 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933158AbaFQOx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:53:27 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: [PATCH v2 16/20] mfd: sun6i-prcm: Add support for Allwinner A23 PRCM
Date: Tue, 17 Jun 2014 22:52:53 +0800
Message-Id: <1403016777-15121-17-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403016777-15121-1-git-send-email-wens@csie.org>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A23 SoC has a PRCM unit like the previous A31 SoC.
The differences are the AR100 clock can no longer be modified,
the APB0 clock has different divisors, and some clock gates are
gone.

This patch adds a compatible with a modified subdevice list for
the A23.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 .../devicetree/bindings/mfd/sun6i-prcm.txt         |  2 +-
 drivers/mfd/sun6i-prcm.c                           | 30 ++++++++++++++++++++++
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mfd/sun6i-prcm.txt b/Documentation/devicetree/bindings/mfd/sun6i-prcm.txt
index 1f5a31f..03c5a55 100644
--- a/Documentation/devicetree/bindings/mfd/sun6i-prcm.txt
+++ b/Documentation/devicetree/bindings/mfd/sun6i-prcm.txt
@@ -4,7 +4,7 @@ PRCM is an MFD device exposing several Power Management related devices
 (like clks and reset controllers).
 
 Required properties:
- - compatible: "allwinner,sun6i-a31-prcm"
+ - compatible: "allwinner,sun6i-a31-prcm" or "allwinner,sun8i-a23-prcm"
  - reg: The PRCM registers range
 
 The prcm node may contain several subdevices definitions:
diff --git a/drivers/mfd/sun6i-prcm.c b/drivers/mfd/sun6i-prcm.c
index 718fc4d..7a198d3 100644
--- a/drivers/mfd/sun6i-prcm.c
+++ b/drivers/mfd/sun6i-prcm.c
@@ -76,16 +76,46 @@ static const struct mfd_cell sun6i_a31_prcm_subdevs[] = {
 	},
 };
 
+static const struct mfd_cell sun8i_a23_prcm_subdevs[] = {
+	{
+		.name = "sun6i-a31-apb0-clk",
+		.of_compatible = "allwinner,sun8i-a23-apb0-clk",
+		.num_resources = ARRAY_SIZE(sun6i_a31_apb0_clk_res),
+		.resources = sun6i_a31_apb0_clk_res,
+	},
+	{
+		.name = "sun6i-a31-apb0-gates-clk",
+		.of_compatible = "allwinner,sun8i-a23-apb0-gates-clk",
+		.num_resources = ARRAY_SIZE(sun6i_a31_apb0_gates_clk_res),
+		.resources = sun6i_a31_apb0_gates_clk_res,
+	},
+	{
+		.name = "sun6i-a31-apb0-clock-reset",
+		.of_compatible = "allwinner,sun6i-a31-clock-reset",
+		.num_resources = ARRAY_SIZE(sun6i_a31_apb0_rstc_res),
+		.resources = sun6i_a31_apb0_rstc_res,
+	},
+};
+
 static const struct prcm_data sun6i_a31_prcm_data = {
 	.nsubdevs = ARRAY_SIZE(sun6i_a31_prcm_subdevs),
 	.subdevs = sun6i_a31_prcm_subdevs,
 };
 
+static const struct prcm_data sun8i_a23_prcm_data = {
+	.nsubdevs = ARRAY_SIZE(sun8i_a23_prcm_subdevs),
+	.subdevs = sun8i_a23_prcm_subdevs,
+};
+
 static const struct of_device_id sun6i_prcm_dt_ids[] = {
 	{
 		.compatible = "allwinner,sun6i-a31-prcm",
 		.data = &sun6i_a31_prcm_data,
 	},
+	{
+		.compatible = "allwinner,sun8i-a23-prcm",
+		.data = &sun8i_a23_prcm_data,
+	},
 	{ /* sentinel */ },
 };
 
-- 
2.0.0

