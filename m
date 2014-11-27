Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbaK0UQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 15:16:17 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:49874 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaK0UQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 15:16:14 -0500
Message-ID: <54778685.2070108@linaro.org>
Date: Thu, 27 Nov 2014 20:16:05 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 3.18-rc4 v10 4/6] irqchip: gic: Introduce plumbing for
 IPI FIQ
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <1417019010-9220-1-git-send-email-daniel.thompson@linaro.org> <1417019010-9220-5-git-send-email-daniel.thompson@linaro.org> <20141126174204.GK22670@titan.lakedaemon.net> <54772975.9090908@linaro.org> <20141127180633.GM22670@titan.lakedaemon.net> <54777EA1.3030508@linaro.org>
In-Reply-To: <54777EA1.3030508@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/11/14 19:42, Daniel Thompson wrote:
>> Hmm, I'd look at that as a performance enhancement.  I'm more concerned
>> about performance regressions for current users of the gic (non-group
>> enabled).
> 
> "Current users of the gic" doesn't imply "non-group enabled". Whether or
> not grouping is enabled is a property of the hardware or (secure)
> bootloader.
> 
> If we are seriously worried about a performance regression here we
> actually have to care about both cases.
> 
> 
>> Let's go ahead and do the change (well, a working facsimile) I suggested
>> above, and we can do a follow on patch to increase performance for the
>> group enabled use case.
> 
> Hmnnn...
> 
> I've have a new patch ready to go that shadows the IGROUP[0]. Its looks
> OK to me and I think it is actually fewer lines of code than v10 because
> we can remove gic_get_group_irq() completely.

Fianlly from me. If you are worried about large "last minute changes"
involved in v11 here is the v10 -> v11 diff.

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 978e5e48d5c1..5c36aefa67ea 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -70,6 +70,7 @@ struct gic_chip_data {
 #endif
 	struct irq_domain *domain;
 	unsigned int gic_irqs;
+	u32 igroup0_shadow;
 #ifdef CONFIG_GIC_NON_BANKED
 	void __iomem *(*get_base)(union gic_base *);
 #endif
@@ -363,9 +364,10 @@ static struct irq_chip gic_chip = {
  * If is safe to call this function on systems which do not support
  * grouping (it will have no effect).
  */
-static void gic_set_group_irq(void __iomem *base, unsigned int hwirq,
-				int group)
+static void gic_set_group_irq(struct gic_chip_data *gic, unsigned int
hwirq,
+			      int group)
 {
+	void __iomem *base = gic_data_dist_base(gic);
 	unsigned int grp_reg = hwirq / 32 * 4;
 	u32 grp_mask = BIT(hwirq % 32);
 	u32 grp_val;
@@ -395,25 +397,14 @@ static void gic_set_group_irq(void __iomem *base,
unsigned int hwirq,
 	}

 	writel_relaxed(grp_val, base + GIC_DIST_IGROUP + grp_reg);
+	if (grp_reg == 0)
+		gic->igroup0_shadow = grp_val;
+
 	writel_relaxed(pri_val, base + GIC_DIST_PRI + pri_reg);

 	raw_spin_unlock(&irq_controller_lock);
 }

-/*
- * Test which group an interrupt belongs to.
- *
- * Returns 0 if the controller does not support grouping.
- */
-static int gic_get_group_irq(void __iomem *base, unsigned int hwirq)
-{
-	unsigned int grp_reg = hwirq / 32 * 4;
-	u32 grp_val;
-
-	grp_val = readl_relaxed(base + GIC_DIST_IGROUP + grp_reg);
-
-	return (grp_val >> (hwirq % 32)) & 1;
-}

 /*
  * Fully acknowledge (both ack and eoi) any outstanding FIQ-based IPI,
@@ -565,8 +556,9 @@ static void gic_cpu_init(struct gic_chip_data *gic)
 	if (GICD_ENABLE_GRP1 & readl_relaxed(dist_base + GIC_DIST_CTRL)) {
 		secure_irqs = SMP_IPI_FIQ_MASK;
 		writel_relaxed(~secure_irqs, dist_base + GIC_DIST_IGROUP + 0);
+		gic->igroup0_shadow = ~secure_irqs;
 		for_each_set_bit(secure_irq, &secure_irqs, 16)
-			gic_set_group_irq(dist_base, secure_irq, 0);
+			gic_set_group_irq(gic, secure_irq, 0);
 	}

 	writel_relaxed(GICC_INT_PRI_THRESHOLD, base + GIC_CPU_PRIMASK);
@@ -801,10 +793,12 @@ static void gic_raise_softirq(const struct cpumask
*mask, unsigned int irq)
 	 */
 	dmb(ishst);

-	/* this always happens on GIC0 */
+	/* We avoid a readl here by using the shadow copy of IGROUP[0] */
 	softint = map << 16 | irq;
-	if (gic_get_group_irq(gic_data_dist_base(&gic_data[0]), irq))
+	if (gic_data[0].igroup0_shadow & BIT(irq))
 		softint |= 0x8000;
+
+	/* This always happens on GIC0 */
 	writel_relaxed(softint,
 		       gic_data_dist_base(&gic_data[0]) + GIC_DIST_SOFTINT);

