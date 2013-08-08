Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934037Ab3HHISw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 04:18:52 -0400
Received: from 20.mo4.mail-out.ovh.net ([46.105.33.73]:56827 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933980Ab3HHISs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 04:18:48 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Richard Genoud <richard.genoud@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: [PATCH v3 18/19] ARM: at91: move pit timer to common clk framework
Date: Thu,  8 Aug 2013 10:17:24 +0200
Message-Id: <1375949844-10545-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com>
References: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 6118984520085567536
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrtdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrtdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use device tree to get the source clock of the PIT (Periodic Interval Timer).
If the clock is not found in device tree (or dt is not enabled) we'll try to
get it using clk_lookup definitions.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/mach-at91/at91sam926x_time.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/arch/arm/mach-at91/at91sam926x_time.c
index 3a4bc2e..8ac976a 100644
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

