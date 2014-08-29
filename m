Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbaH2Q0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 12:26:21 -0400
Received: from 10.mo69.mail-out.ovh.net ([46.105.73.241]:48132 "EHLO
	mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753905AbaH2Q0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 12:26:19 -0400
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Aug 2014 12:26:18 EDT
From: =?UTF-8?q?Ga=C3=ABl=20PORTAY?= <g.portay@overkiz.com>
To: Arnd Bergmann <arnd@arndb.de>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: =?utf-8?q?Ga=C3=ABl=20PORTAY?= <gael.portay@gmail.com>
Subject: [PATCHv2 2/4] ARM: at91/tclib: move initialization from alloc to probe
Date: Fri, 29 Aug 2014 18:16:41 +0200
Message-Id: <1409329003-17252-3-git-send-email-g.portay@overkiz.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409329003-17252-1-git-send-email-g.portay@overkiz.com>
References: <1409329003-17252-1-git-send-email-g.portay@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 12095824174927244038
X-Ovh-Remote: 109.190.157.19 (19-157-190-109.dsl.ovh.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejgedrtdeiucdltddurdefjeefrddttddmucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejgedrtdeiucdltddurdefjeefrddttddmucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gaël PORTAY <gael.portay@gmail.com>

Move resource retrieval from atmel_tc_alloc to tc_probe to avoid lately
reporting resource related issues when a TC block user request a TC block.

Moreover, resources retrieval are usually done in the probe function,
thus moving them add some consistency with other drivers.

Initialization is done once, ie not every time a tc block is requested.
If it fails, the device is not appended to the list of tc blocks.

Furhermore, the device id is retrieved at probe as well, avoiding parsing
DT every time the user requests of tc block.

Signed-off-by: Gaël PORTAY <gael.portay@gmail.com>
Acked-by: Thierry Reding <thierry.reding@gmail.com>
Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/clocksource/tcb_clksrc.c |  2 +-
 drivers/misc/atmel_tclib.c       | 71 +++++++++++++---------------------------
 drivers/pwm/pwm-atmel-tcb.c      |  2 +-
 include/linux/atmel_tc.h         |  8 +++--
 4 files changed, 29 insertions(+), 54 deletions(-)

diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
index a8d7ea1..f922e81 100644
--- a/drivers/clocksource/tcb_clksrc.c
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -279,7 +279,7 @@ static int __init tcb_clksrc_init(void)
 	int i;
 	int ret;
 
-	tc = atmel_tc_alloc(CONFIG_ATMEL_TCB_CLKSRC_BLOCK, clksrc.name);
+	tc = atmel_tc_alloc(CONFIG_ATMEL_TCB_CLKSRC_BLOCK);
 	if (!tc) {
 		pr_debug("can't alloc TC for clocksource\n");
 		return -ENODEV;
diff --git a/drivers/misc/atmel_tclib.c b/drivers/misc/atmel_tclib.c
index b514a2d..d505d1e 100644
--- a/drivers/misc/atmel_tclib.c
+++ b/drivers/misc/atmel_tclib.c
@@ -35,60 +35,31 @@ static LIST_HEAD(tc_list);
 /**
  * atmel_tc_alloc - allocate a specified TC block
  * @block: which block to allocate
- * @name: name to be associated with the iomem resource
  *
  * Caller allocates a block.  If it is available, a pointer to a
  * pre-initialized struct atmel_tc is returned. The caller can access
  * the registers directly through the "regs" field.
  */
-struct atmel_tc *atmel_tc_alloc(unsigned block, const char *name)
+struct atmel_tc *atmel_tc_alloc(unsigned block)
 {
 	struct atmel_tc		*tc;
 	struct platform_device	*pdev = NULL;
-	struct resource		*r;
-	size_t			size;
 
 	spin_lock(&tc_list_lock);
 	list_for_each_entry(tc, &tc_list, node) {
-		if (tc->pdev->dev.of_node) {
-			if (of_alias_get_id(tc->pdev->dev.of_node, "tcb")
-					== block) {
-				pdev = tc->pdev;
-				break;
-			}
-		} else if (tc->pdev->id == block) {
+		if (tc->allocated)
+			continue;
+
+		if ((tc->pdev->dev.of_node && tc->id == block) ||
+		    (tc->pdev->id == block)) {
 			pdev = tc->pdev;
+			tc->allocated = true;
 			break;
 		}
 	}
-
-	if (!pdev || tc->iomem)
-		goto fail;
-
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r)
-		goto fail;
-
-	size = resource_size(r);
-	r = request_mem_region(r->start, size, name);
-	if (!r)
-		goto fail;
-
-	tc->regs = ioremap(r->start, size);
-	if (!tc->regs)
-		goto fail_ioremap;
-
-	tc->iomem = r;
-
-out:
 	spin_unlock(&tc_list_lock);
-	return tc;
 
-fail_ioremap:
-	release_mem_region(r->start, size);
-fail:
-	tc = NULL;
-	goto out;
+	return pdev ? tc : NULL;
 }
 EXPORT_SYMBOL_GPL(atmel_tc_alloc);
 
@@ -96,19 +67,14 @@ EXPORT_SYMBOL_GPL(atmel_tc_alloc);
  * atmel_tc_free - release a specified TC block
  * @tc: Timer/counter block that was returned by atmel_tc_alloc()
  *
- * This reverses the effect of atmel_tc_alloc(), unmapping the I/O
- * registers, invalidating the resource returned by that routine and
- * making the TC available to other drivers.
+ * This reverses the effect of atmel_tc_alloc(), invalidating the resource
+ * returned by that routine and making the TC available to other drivers.
  */
 void atmel_tc_free(struct atmel_tc *tc)
 {
 	spin_lock(&tc_list_lock);
-	if (tc->regs) {
-		iounmap(tc->regs);
-		release_mem_region(tc->iomem->start, resource_size(tc->iomem));
-		tc->regs = NULL;
-		tc->iomem = NULL;
-	}
+	if (tc->allocated)
+		tc->allocated = false;
 	spin_unlock(&tc_list_lock);
 }
 EXPORT_SYMBOL_GPL(atmel_tc_free);
@@ -142,9 +108,7 @@ static int __init tc_probe(struct platform_device *pdev)
 	struct atmel_tc *tc;
 	struct clk	*clk;
 	int		irq;
-
-	if (!platform_get_resource(pdev, IORESOURCE_MEM, 0))
-		return -EINVAL;
+	struct resource	*r;
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
@@ -160,12 +124,21 @@ static int __init tc_probe(struct platform_device *pdev)
 	if (IS_ERR(clk))
 		return PTR_ERR(clk);
 
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	tc->regs = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(tc->regs))
+		return PTR_ERR(tc->regs);
+
 	/* Now take SoC information if available */
 	if (pdev->dev.of_node) {
 		const struct of_device_id *match;
 		match = of_match_node(atmel_tcb_dt_ids, pdev->dev.of_node);
 		if (match)
 			tc->tcb_config = match->data;
+
+		tc->id = of_alias_get_id(tc->pdev->dev.of_node, "tcb");
+	} else {
+		tc->id = pdev->id;
 	}
 
 	tc->clk[0] = clk;
diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
index f3dcd02..d56e5b7 100644
--- a/drivers/pwm/pwm-atmel-tcb.c
+++ b/drivers/pwm/pwm-atmel-tcb.c
@@ -379,7 +379,7 @@ static int atmel_tcb_pwm_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	tc = atmel_tc_alloc(tcblock, "tcb-pwm");
+	tc = atmel_tc_alloc(tcblock);
 	if (tc == NULL) {
 		dev_err(&pdev->dev, "failed to allocate Timer Counter Block\n");
 		return -ENOMEM;
diff --git a/include/linux/atmel_tc.h b/include/linux/atmel_tc.h
index 89a931b..d8aa884 100644
--- a/include/linux/atmel_tc.h
+++ b/include/linux/atmel_tc.h
@@ -44,12 +44,13 @@ struct atmel_tcb_config {
 /**
  * struct atmel_tc - information about a Timer/Counter Block
  * @pdev: physical device
- * @iomem: resource associated with the I/O register
  * @regs: mapping through which the I/O registers can be accessed
+ * @id: block id
  * @tcb_config: configuration data from SoC
  * @irq: irq for each of the three channels
  * @clk: internal clock source for each of the three channels
  * @node: list node, for tclib internal use
+ * @allocated: if already used, for tclib internal use
  *
  * On some platforms, each TC channel has its own clocks and IRQs,
  * while on others, all TC channels share the same clock and IRQ.
@@ -61,15 +62,16 @@ struct atmel_tcb_config {
  */
 struct atmel_tc {
 	struct platform_device	*pdev;
-	struct resource		*iomem;
 	void __iomem		*regs;
+	int                     id;
 	const struct atmel_tcb_config *tcb_config;
 	int			irq[3];
 	struct clk		*clk[3];
 	struct list_head	node;
+	bool			allocated;
 };
 
-extern struct atmel_tc *atmel_tc_alloc(unsigned block, const char *name);
+extern struct atmel_tc *atmel_tc_alloc(unsigned block);
 extern void atmel_tc_free(struct atmel_tc *tc);
 
 /* platform-specific ATMEL_TC_TIMER_CLOCKx divisors (0 means 32KiHz) */
-- 
1.9.3

