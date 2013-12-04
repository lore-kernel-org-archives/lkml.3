Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933335Ab3LDXgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 18:36:51 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:40086 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab3LDXfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 18:35:41 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Mike Turquette <mturquette@linaro.org>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 4/7] clk: highbank: prevent glitching when going into bypass mode
Date: Wed,  4 Dec 2013 17:35:24 -0600
Message-Id: <1386200127-23143-5-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386200127-23143-1-git-send-email-robherring2@gmail.com>
References: <1386200127-23143-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Langsdorf <mark.langsdorf@calxeda.com>

Under very rare circumstances, the clock multiplexer can take around
100 ns to enter bypass mode. Attempting to reprogram the clock PLL
before the clock has fully entered bypass mode can cause errors in the
system, up to and including kernel panics. Add a 300 ns delay after
programming the bypass enable to make sure that bypass mode has been
enabled.

This patch should be added to the stable series.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 drivers/clk/clk-highbank.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/clk/clk-highbank.c b/drivers/clk/clk-highbank.c
index 2e7e9d9..dc7ca30 100644
--- a/drivers/clk/clk-highbank.c
+++ b/drivers/clk/clk-highbank.c
@@ -21,6 +21,7 @@
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/delay.h>
 
 #define HB_PLL_LOCK_500		0x20000000
 #define HB_PLL_LOCK		0x10000000
@@ -167,6 +168,8 @@ static int clk_pll_set_rate(struct clk_hw *hwclk, unsigned long rate,
 		/* Need to re-lock PLL, so put it into bypass mode */
 		reg |= HB_PLL_EXT_BYPASS;
 		writel(reg | HB_PLL_EXT_BYPASS, hbclk->reg);
+		/* delay to make sure we are in bypass */
+		ndelay(300);
 
 		writel(reg | HB_PLL_RESET, hbclk->reg);
 		reg &= ~(HB_PLL_DIVF_MASK | HB_PLL_DIVQ_MASK);
@@ -182,6 +185,9 @@ static int clk_pll_set_rate(struct clk_hw *hwclk, unsigned long rate,
 		reg &= ~HB_PLL_EXT_BYPASS;
 	} else {
 		writel(reg | HB_PLL_EXT_BYPASS, hbclk->reg);
+		/* delay to make sure we are in bypass */
+		ndelay(300);
+
 		reg &= ~HB_PLL_DIVQ_MASK;
 		reg |= divq << HB_PLL_DIVQ_SHIFT;
 		writel(reg | HB_PLL_EXT_BYPASS, hbclk->reg);
-- 
1.8.3.2

