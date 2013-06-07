Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab3FGQaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:30:30 -0400
Received: from 9.mo1.mail-out.ovh.net ([178.32.108.172]:56143 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754924Ab3FGQa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:30:28 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Jun 2013 12:30:28 EDT
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Mike Turquette <mturquette@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Victor <linux@maxim.org.za>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>,
        Russell King <linux@arm.linux.org.uk>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [RFC PATCH 25/50] ARM: at91: move pit timer to common clk framework
Date: Fri,  7 Jun 2013 18:23:41 +0200
Message-Id: <1370622222-19489-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
References: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 621215275219580956
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use device tree to get the source clock of the PIT (Periodic Interval Timer).
If the clock is not found in device tree (or dt is not enabled) we'll try to
get it using clk_lookup definitions.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/mach-at91/at91sam926x_time.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/arch/arm/mach-at91/at91sam926x_time.c
index 3a4bc2e..fba7bd6 100644
--- a/arch/arm/mach-at91/at91sam926x_time.c
+++ b/arch/arm/mach-at91/at91sam926x_time.c
@@ -39,6 +39,7 @@
 static u32 pit_cycle;		/* write-once */
 static u32 pit_cnt;		/* access only w/system irq blocked */
 static void __iomem *pit_base_addr __read_mostly;
+static struct clk *mck;
 
 static inline unsigned int pit_read(unsigned int reg_offset)
 {
@@ -186,6 +187,7 @@ static int __init of_at91sam926x_pit_init(void)
 {
 	struct device_node	*np;
 	int			ret;
+	int			err = -EINVAL;
 
 	np = of_find_matching_node(NULL, pit_timer_ids);
 	if (!np)
@@ -195,10 +197,19 @@ static int __init of_at91sam926x_pit_init(void)
 	if (!pit_base_addr)
 		goto node_err;
 
+	mck = of_clk_get(np, 0);
+	if (IS_ERR(mck)) {
+		err = PTR_RET(mck);
+		mck = NULL;
+		pr_crit("AT91: PIT: Unable to get mck clk from DT\n");
+		goto ioremap_err;
+	}
+
 	/* Get the interrupts property */
 	ret = irq_of_parse_and_map(np, 0);
 	if (!ret) {
 		pr_crit("AT91: PIT: Unable to get IRQ from DT\n");
+		clk_put(mck);
 		goto ioremap_err;
 	}
 	at91sam926x_pit_irq.irq = ret;
@@ -212,7 +223,7 @@ ioremap_err:
 node_err:
 	of_node_put(np);
 err:
-	return -EINVAL;
+	return err;
 }
 #else
 static int __init of_at91sam926x_pit_init(void)
@@ -237,7 +248,13 @@ void __init at91sam926x_pit_init(void)
 	 * Use our actual MCK to figure out how many MCK/16 ticks per
 	 * 1/HZ period (instead of a compile-time constant LATCH).
 	 */
-	pit_rate = clk_get_rate(clk_get(NULL, "mck")) / 16;
+	if (!mck)
+		mck = clk_get(NULL, "mck");
+
+	if (IS_ERR(mck))
+		panic("AT91: PIT: Unable to get mck clk\n");
+	pit_rate = clk_get_rate(mck) / 16;
+	pr_notice("AT91: PIT: mck rate = %lu\n", pit_rate);
 	pit_cycle = (pit_rate + HZ/2) / HZ;
 	WARN_ON(((pit_cycle - 1) & ~AT91_PIT_PIV) != 0);
 
-- 
1.7.9.5

