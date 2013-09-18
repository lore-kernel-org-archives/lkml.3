Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab3IRMTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:19:42 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:54124 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab3IRMPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:15:12 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 24/41] clk: ux500: Add a 2-cell Device Tree parser for obtaining PRCC clocks
Date: Wed, 18 Sep 2013 13:14:21 +0100
Message-Id: <1379506478-16625-25-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PRCC (peripheral and kernel) clocks are specified using a property tuple
<&phandle base bit>, where 'base' is the peripheral (1, 2, 3, 5 or 6),
and bit is read-in value into that peripheral stipulated by the hardware
specification.

Acked-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/clk/ux500/u8500_of_clk.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/clk/ux500/u8500_of_clk.c b/drivers/clk/ux500/u8500_of_clk.c
index bfbe3ca..b9b3317 100644
--- a/drivers/clk/ux500/u8500_of_clk.c
+++ b/drivers/clk/ux500/u8500_of_clk.c
@@ -15,6 +15,28 @@
 #include <linux/platform_data/clk-ux500.h>
 #include "clk.h"
 
+#define PRCC_SHOW(clk, base, bit) \
+	clk[(base * PRCC_PERIPHS_PER_CLUSTER) + bit]
+
+struct clk *ux500_twocell_get(struct of_phandle_args *clkspec, void *data)
+{
+	struct clk **clk_data = data;
+	unsigned int base, bit;
+
+	if (clkspec->args_count != 2)
+		return  ERR_PTR(-EINVAL);
+
+	base = clkspec->args[0];
+	bit = clkspec->args[1];
+
+	if (base != 1 && base != 2 && base != 3 && base != 5 && base != 6) {
+		pr_err("%s: invalid PRCC base %d\n", __func__, base);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return PRCC_SHOW(clk_data, base, bit);
+}
+
 static const struct of_device_id u8500_clk_of_match[] = {
 	{ .compatible = "stericsson,u8500-clks", },
 	{ },
-- 
1.8.1.2

