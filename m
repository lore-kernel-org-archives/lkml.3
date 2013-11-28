Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743Ab3K1Nzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 08:55:44 -0500
Received: from 4.mo6.mail-out.ovh.net ([87.98.184.159]:34116 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757435Ab3K1Nzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 08:55:41 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: [PATCH v6 15/16] ARM: at91: move pit timer to common clk framework
Date: Thu, 28 Nov 2013 14:55:11 +0100
Message-Id: <1385646911-8462-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385642184-6467-1-git-send-email-b.brezillon@overkiz.com>
References: <1385642184-6467-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 5426274602057234540
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use device tree to get the source clock of the PIT (Periodic Interval Timer).
If the clock is not found in device tree (or dt is not enabled) we'll try to
get it using clk_lookup definitions.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91sam926x_time.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/arch/arm/mach-at91/at91sam926x_time.c
index bb39232..0f04ffe 100644
--- a/arch/arm/mach-at91/at91sam926x_time.c
+++ b/arch/arm/mach-at91/at91sam926x_time.c
@@ -39,6 +39,7 @@
 static u32 pit_cycle;		/* write-once */
 static u32 pit_cnt;		/* access only w/system irq blocked */
 static void __iomem *pit_base_addr __read_mostly;
+static struct clk *mck;
 
 static inline unsigned int pit_read(unsigned int reg_offset)
 {
@@ -195,10 +196,14 @@ static int __init of_at91sam926x_pit_init(void)
 	if (!pit_base_addr)
 		goto node_err;
 
+	mck = of_clk_get(np, 0);
+
 	/* Get the interrupts property */
 	ret = irq_of_parse_and_map(np, 0);
 	if (!ret) {
 		pr_crit("AT91: PIT: Unable to get IRQ from DT\n");
+		if (!IS_ERR(mck))
+			clk_put(mck);
 		goto ioremap_err;
 	}
 	at91sam926x_pit_irq.irq = ret;
@@ -230,6 +235,8 @@ void __init at91sam926x_pit_init(void)
 	unsigned	bits;
 	int		ret;
 
+	mck = ERR_PTR(-ENOENT);
+
 	/* For device tree enabled device: initialize here */
 	of_at91sam926x_pit_init();
 
@@ -237,7 +244,12 @@ void __init at91sam926x_pit_init(void)
 	 * Use our actual MCK to figure out how many MCK/16 ticks per
 	 * 1/HZ period (instead of a compile-time constant LATCH).
 	 */
-	pit_rate = clk_get_rate(clk_get(NULL, "mck")) / 16;
+	if (IS_ERR(mck))
+		mck = clk_get(NULL, "mck");
+
+	if (IS_ERR(mck))
+		panic("AT91: PIT: Unable to get mck clk\n");
+	pit_rate = clk_get_rate(mck) / 16;
 	pit_cycle = (pit_rate + HZ/2) / HZ;
 	WARN_ON(((pit_cycle - 1) & ~AT91_PIT_PIV) != 0);
 
-- 
1.7.9.5

