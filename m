Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab3IMHst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 03:48:49 -0400
Received: from 5.mo2.mail-out.ovh.net ([87.98.181.248]:58668 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755503Ab3IMHsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 03:48:47 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [RFC PATCH 2/4] pinctrl: at91: fix sam9x5 debounce/deglitch functions
Date: Fri, 13 Sep 2013 09:47:22 +0200
Message-Id: <1379058442-3321-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379058213-3245-1-git-send-email-b.brezillon@overkiz.com>
References: <1379058213-3245-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 14141865781640657120
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrleefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrleefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace at91_mux_get_deglitch with at91_mux_pio3_get_deglitch when using
sam9x5 (pio3) IP.
at91_mux_get_deglitch only test the activation of the "Input Filter" which
may be overloaded by the activation of the "Input Filter Slow Clock" to use
the input filter as a debounce filter instead of a deglitch filter.

Fix at91_mux_pio3_get_debounce to test the activation of the Input Filter
before testing the activation of the debounce filter (Input Filter Slow
Clock depends on Input Filter).

Fix at91_mux_pio3_set_debounce function to avoid disabling the deglitch
filter ("Input Filter") when debounce filter is disabled.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/pinctrl/pinctrl-at91.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 50b555a..6624bce 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -417,6 +417,14 @@ static void at91_mux_set_deglitch(void __iomem *pio, unsigned mask, bool is_on)
 	__raw_writel(mask, pio + (is_on ? PIO_IFER : PIO_IFDR));
 }
 
+static bool at91_mux_pio3_get_deglitch(void __iomem *pio, unsigned pin)
+{
+	if ((__raw_readl(pio + PIO_IFSR) >> pin) & 0x1)
+		return !((__raw_readl(pio + PIO_IFSCSR) >> pin) & 0x1);
+
+	return false;
+}
+
 static void at91_mux_pio3_set_deglitch(void __iomem *pio, unsigned mask, bool is_on)
 {
 	if (is_on)
@@ -428,7 +436,8 @@ static bool at91_mux_pio3_get_debounce(void __iomem *pio, unsigned pin, u32 *div
 {
 	*div = __raw_readl(pio + PIO_SCDR);
 
-	return (__raw_readl(pio + PIO_IFSCSR) >> pin) & 0x1;
+	return ((__raw_readl(pio + PIO_IFSR) >> pin) & 0x1) &&
+	       ((__raw_readl(pio + PIO_IFSCSR) >> pin) & 0x1);
 }
 
 static void at91_mux_pio3_set_debounce(void __iomem *pio, unsigned mask,
@@ -438,9 +447,8 @@ static void at91_mux_pio3_set_debounce(void __iomem *pio, unsigned mask,
 		__raw_writel(mask, pio + PIO_IFSCER);
 		__raw_writel(div & PIO_SCDR_DIV, pio + PIO_SCDR);
 		__raw_writel(mask, pio + PIO_IFER);
-	} else {
-		__raw_writel(mask, pio + PIO_IFDR);
-	}
+	} else
+		__raw_writel(mask, pio + PIO_IFSCDR);
 }
 
 static bool at91_mux_pio3_get_pulldown(void __iomem *pio, unsigned pin)
@@ -478,7 +486,7 @@ static struct at91_pinctrl_mux_ops at91sam9x5_ops = {
 	.mux_B_periph	= at91_mux_pio3_set_B_periph,
 	.mux_C_periph	= at91_mux_pio3_set_C_periph,
 	.mux_D_periph	= at91_mux_pio3_set_D_periph,
-	.get_deglitch	= at91_mux_get_deglitch,
+	.get_deglitch	= at91_mux_pio3_get_deglitch,
 	.set_deglitch	= at91_mux_pio3_set_deglitch,
 	.get_debounce	= at91_mux_pio3_get_debounce,
 	.set_debounce	= at91_mux_pio3_set_debounce,
-- 
1.7.9.5

